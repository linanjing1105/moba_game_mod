-module(gate_way).
-behaviour(gen_server).

-export([start_link/1, stop/0, init/1, handle_cast/2, handle_info/2, terminate/2, code_change/3, handle_call/3]). 
-include("common.hrl").
%Sid是mynet节点，hid是agent节点
-record(state, {ws_socket=0,sid=0,hid=0,uid=0,aid=0,step=0,recv=0,send=0,prev=0,ws_state=shake_hand}).

start_link(_) ->
    gen_server:start_link(?MODULE, [], []).

stop() ->  
    gen_server:cast(?MODULE, stop).

init([]) ->
	erlang:put(unfinish_bin, <<>>),
    {ok, #state{sid = self()}}.

%等待握手状态
handle_info ({tcp, WsSwocket, Bin}, #state{ws_state = shake_hand} = State)->
	BinList = erlang:binary_to_list(Bin),
%% 	case re:run(BinList, "token\=([a-zA-Z0-9\-_]+)", [{capture, [1], binary}]) of % 正则匹配
%% 		{match,[Result]} ->
%% 			Token = Result;
%% 		nomatch ->
%% 			Token = <<"">>
%% 	end,
	%通过鉴权码查找相应的用户
    case erlang:get(shake_head) of
        undefined ->
            HeadInfo = BinList;
        OldHead ->
            HeadInfo = OldHead++BinList
    end,
    case binary:matches(list_to_binary(HeadInfo), <<"\r\n\r\n">>) of
        []->
            erlang:put (shake_head, HeadInfo),
            {noreply, State};
        _Find->
            HeaderList = string:tokens (HeadInfo, "\r\n"),
            HeaderTupleList = [list_to_tuple (string:tokens (Header, ": ")) || Header <- HeaderList],
            erlang:put (header, HeaderTupleList),
            SecWebSocketKey = proplists:get_value ("Sec-WebSocket-Key", HeaderTupleList),
            case SecWebSocketKey =:= undefined of
                false->
                    Sha = crypto:hash (sha, [list_to_binary(SecWebSocketKey), <<"258EAFA5-E914-47DA-95CA-C5AB0DC85B11">>]),
                    Base64 = base64:encode (Sha),
                    HandshakeHeader = [
                        <<"HTTP/1.1 101 Switching Protocols\r\n">>,
                        <<"Upgrade: websocket\r\n">>,
                        <<"Connection: Upgrade\r\n">>,
                        <<"Sec-WebSocket-Accept: ">>, Base64, <<"\r\n">>,
                        <<"\r\n">>
                    ],
                    ok = gen_tcp:send(WsSwocket, HandshakeHeader),
					%%鉴权登陆 开始
%% 					Ip = get_ip(WsSwocket), 
%% 					Data = [{?PT_CODE,?PT_REQ_LOGIN},{?PT_TOKEN,Token}],
%%     				gen_server:cast({global, login}, {recv, Sid, Uid, Ip, Data}),
					%%鉴权登陆 结束
                    NewState = State#state{ws_state = ready},
                    {noreply, NewState};
                true->
                    self() ! {tcp_closed, State#state.ws_socket},
                    {noreply, State}
            end
    end;
% 握手成功，监听消息状态
handle_info({tcp, _WsSwocket, Bin}, #state{ws_state = ready} = State) ->
    #state{sid = Sid} = State,
	NewState =
		try
			deal_recv_data(State, Sid, Bin) %处理接受到的消息   
		catch E:R-> ?log_error("login routing error E=~p,R=~p,Call=~p",[E,R,erlang:get_stacktrace()]),
			State
		end,			
	{noreply, NewState};

% 消息太大 一次tcp传不完
handle_info({tcp, _WsSwocket, Bin}, #state{ws_state = unfinished,sid = Sid} = State)->
        ReceivedData = list_to_binary([erlang:get (unfinished_data), Bin]),
        case erlang:get (data_length) + 4 - size(ReceivedData) > 0  of
            true ->
                erlang:put (unfinished_data, ReceivedData),
                {noreply, State};
            false ->
                MakeProtoLen = erlang:get (data_length) + 4,
                NewState = State#state{ws_state = ready},
                erlang:put (data_length, 0),
                erlang:put (unfinished_data, <<>>),
                <<MaskProtoData:MakeProtoLen/binary, LeftBinData/binary>> = ReceivedData,
                NewState1 = handle_data (NewState, MaskProtoData, Sid),
                case LeftBinData of
                    <<>>->
                        {noreply, NewState1};
                    LeftBinData->
                        NewState2 = deal_recv_data(NewState1, Sid, LeftBinData),
                        {noreply, NewState2}
                end
	end;

handle_info({tcp_closed, _Socket}, #state{uid = Uid,aid=Aid} =State) ->
	?log_trace("tcp_closed uid=~p,aid=~p,reson=~p",[Uid,Aid,"tcp closed"]),
    {stop, normal, State}.
handle_cast({amend_mynet_hid,Uid}, State) ->
	{noreply, State#state{uid = Uid, hid = 0}};

handle_cast({set_val, Aid, Uid, Hid, Step},  State) ->
    {noreply, State#state{aid = Aid, uid = Uid, hid = Hid, step = Step}};
handle_cast({discon, Reason}, #state{uid = Uid,aid=Aid} = State) ->
	?log_warning("discon uid=~p,aid=~p,reson=~p",[Uid,Aid,Reason]),
    gen_tcp:close(State#state.ws_socket),
    {stop, normal, State};

handle_cast({accept, Sock}, State) ->
	?debug("accept"),
    case gen_tcp:accept(Sock) of
        {ok, Socket} ->
			?debug("accepted"),
            inet:setopts(Socket, [binary, {active, true}]),
            gate_way_sup:relay(Sock),
			notify_add_con(),
            {noreply, State#state{ws_socket = Socket}};

        {error, Reason} ->
            ?log_error("accept error, Reason = ~p ~n", [Reason]),
            gate_way_sup:relay(Sock),
            {stop, accept_error, State};
		_R->
			?log("accept_error"),
			 {stop, accept_error, State}	
    end;

handle_cast(flush, #state{ws_socket = Socket, prev = Prev} = State) ->
    P = list_to_binary(lists:reverse(Prev)),
    gen_tcp:send(Socket, P),
    {noreply, State#state{send = 0, prev = 0}};


% ?send会回到这里
handle_cast({send, Data}, #state{ws_socket=WsSwocket} = State) ->
	New_Data= try
				jsx:encode(Data) %转换为json
			catch E1:R1 -> ?log_error("login routing error E=~p,R=~p,Call=~p",[E1,R1,erlang:get_stacktrace()])
			end,
	Frame = try
			build_frame (New_Data)
		   catch E2:R2 -> ?log_error("login routing error E=~p,R=~p,Call=~p",[E2,R2,erlang:get_stacktrace()])
		   end,	
	case gen_tcp:send (WsSwocket, Frame) of %发送消息
		ok ->
			{noreply, State#state{send = 1}};
		{error, Reason} -> {stop, Reason, State}
	end;

handle_cast(Msg,#state{uid = Uid,aid = Aid} = State) ->
	?log_error("mynet can not match uid=~p,aid=~p,msg=~p",[Uid,Aid,Msg]),
     {noreply, State}.

terminate(_Reason, State) ->
    close_tcp(State),
    ok.

code_change(_OldVsn, State, _Extra) ->    
    {ok, State}.

handle_call(_Request, _From, State) ->    
    {reply, ok, State}.

close_tcp(#state{uid = Uid, sid = Sid, hid = Hid}) ->	
	?debug("closetcp######~nUid=~p~nSid=~p~nHid=~p~n",[Uid,Sid,Hid]),
    if 
        Hid == 0 -> gen_server:cast({global, login}, {tcp_closed, Sid}); % 删除login表
        is_pid(Hid) -> 
			gen_server:cast({global, login}, {tcp_closed, Sid}),
			gen_server:cast(Hid, {tcp_closed, Uid, Sid});
        true -> gen_server:cast({global, Hid}, {tcp_closed, Uid, Sid}) 
    end,
	notify_discon().

get_ip(Socket)->
	case inet:peername(Socket) of
		{ok,{Address,_Port}}->Address;
		_-> {0,0,0,0}
	end.
%% 接受验证过的json数据 在这个函数里把数据转发
on_packet_recv( #state{ws_socket = Socket,sid = Sid, uid = Uid, hid = Hid}, Data) ->	
	?debug("Data=~p~n,Hid=~p~n,Sid=~p~n",[Data,Hid,Sid]),
	case Data of
		[{?PT_CODE,?PT_REQ_HEART}]-> %心跳 
			Cmd = [{?PT_RET_CODE,?PT_RET_HEART}],  
			?send(Sid, Cmd); %回应心跳 TODO 
		[{?PT_CODE,?PT_REQ_DISCON}]-> %结束连接 TODO
			Cmd = [{?PT_RET_CODE,?PT_RET_DISCON}], 
			?send(Sid, Cmd), %回应断线
			?discon(Sid, discon, 100); 
%% 			close_tcp(State); 
		_ ->
			if 
				Hid == 0 ->
					Ip = get_ip(Socket),
					gen_server:cast({global, login}, {recv, Sid, Uid, Ip, Data}); %向login节点发送消息
				is_pid(Hid) ->
					gen_server:cast(Hid, {recv, Sid, Uid, Data}); %登录成功之后 向agent节点发送消息
				true ->
					gen_server:cast({global, Hid}, {recv, Sid, Uid, Data})
			end
	end.

unmask(PayloadData) ->
    <<Masking:4/binary, MaskedData/binary>> = PayloadData,
    unmask(MaskedData, Masking).


unmask(MaskedData, Masking) ->
    unmask(MaskedData, Masking, <<>>).


unmask(MaskedData, Masking = <<MA:8, MB:8, MC:8, MD:8>>, Acc) ->
    case size(MaskedData) of
        0 -> Acc;
        1 ->
            <<A:8>> = MaskedData,
            <<Acc/binary, (MA bxor A)>>;
        2 ->
            <<A:8, B:8>> = MaskedData,
            <<Acc/binary, (MA bxor A), (MB bxor B)>>;
        3 ->
            <<A:8, B:8, C:8>> = MaskedData,
            <<Acc/binary, (MA bxor A), (MB bxor B), (MC bxor C)>>;
        _Other ->
            <<A:8, B:8, C:8, D:8, Rest/binary>> = MaskedData,
            Acc1 = <<Acc/binary, (MA bxor A), (MB bxor B), (MC bxor C), (MD bxor D)>>,
            unmask(Rest, Masking, Acc1)
    end.


%% 发送消息时对Data进行转换
build_frame (Content) ->
    Bin = unicode:characters_to_binary (Content), %转换为二进制
    DataLength = size (Bin),
    build_frame (DataLength, Bin).
build_frame (DataLength, Bin) when DataLength =< 125 ->
    <<1:1, 0:3, 1:4, 0:1, DataLength:7, Bin/binary>>;
build_frame (DataLength, Bin) when DataLength >= 125, DataLength =< 65535 ->
    <<1:1, 0:3, 1:4, 0:1, 126:7, DataLength:16, Bin/binary>>;
build_frame (DataLength, Bin) when DataLength > 65535 ->
    <<1:1, 0:3, 1:4, 0:1, 127:7, DataLength:64, Bin/binary>>.

% 处理数据
handle_data(State, PayloadData, Sid) ->
	PayloadOriginalData = unmask (PayloadData),%解码数据
	case unicode:characters_to_list (PayloadOriginalData) of %转换为列表
		{incomplete, _, _} -> %未完成
			State;
		RawPayloadContent ->
			case unicode:characters_to_binary(RawPayloadContent) of
				{error, _Bin, _Rest} ->
					State;
				{incomplete, _Bin, _Rest} ->
					State;
				PayloadContent ->	
					?debug("PayloadContent=~p~n",[PayloadContent]),
					
					case check_client_data(PayloadContent) of %判断是否是json
						true ->							
							Data =
								try
									jsx:decode(PayloadContent)
								catch E1:R1 -> ?log_error("login routing error E=~p,R=~p,Call=~p",[E1,R1,erlang:get_stacktrace()])
								end,
							on_packet_recv(State, Data),	
							State;
%% 							case erlang:is_integer(Data) of
%% 								false->	
%% 									?debug("~n~p~n",[Data]),
%% 									on_packet_recv(State, Data),					
%% 									State;
%% 								_->?log_error("Json_dn=~p",[Data]),
%% %% 								    ?discon (Sid, discon, 100),
%% 								    State	
%% 							end;	
						_->?log_error("not json"),
						   ?discon (Sid, discon, 100),
						   State	
					end
			end
	end .

check_client_data(<<>>)-> 
	?debug("error data"),
	false;
check_client_data(Data) when length(Data)>0->
	jsx:is_json(Data).
%% 处理消息 
deal_recv_data(State, Uuid, OldBin)->
	Bin = list_to_binary([erlang:get(unfinish_bin), OldBin]),
	case size(Bin) > 2 of
		false->
			erlang:put(unfinish_bin, Bin),
			State;
		true->
			erlang:put(unfinish_bin, <<>>),
			<<_Fin:1, _Rsv:3, _Opcode:4, _Mask:1, Len:7, Rest/binary>> = Bin,
			case Len of
				126 ->
					<<PayloadLength:16, RestData/binary>> = Rest;
				127 ->
					<<PayloadLength:64, RestData/binary>> = Rest;
				_ ->
					PayloadLength = Len,
					RestData = Rest
			end,
			case PayloadLength+4 > size(RestData) of
				true ->
					NewState = State#state{ws_state = unfinished},
					erlang:put (data_length, PayloadLength),
					erlang:put (unfinished_data, RestData),
					NewState;
				false ->
					MakeProtoLen = PayloadLength+4,
					<<MaskProtoData:MakeProtoLen/binary, LeftBinData/binary>> = RestData,
					NewState1 = handle_data(State, MaskProtoData, Uuid),
					case LeftBinData of
						<<>>->
							NewState1;
						LeftBinData->
							deal_recv_data(NewState1, Uuid, LeftBinData)
					end
			end
	end.

notify_add_con() ->
%% 	MynetID=db:get_all_config(mynet_id),
	gen_server:cast({global, gate_way_mng}, {add_con, 1}).

notify_discon() ->
%% 	MynetID=db:get_all_config(mynet_id),
	gen_server:cast({global, gate_way_mng}, {discon, 1}).

