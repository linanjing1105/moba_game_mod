%% Author: mmo
%% Created: 2011-12-29
%% Description: TODO: Add description to sm
-module(sm).

%%
%% Include files
%%
-include("common.hrl").

%%
%% Exported Functions
%%
-export([makeall/0,install/0,check/0,reconnect/1,topN/2]).
-export([select/2,select/3,selectall/1,update/3,get_max_ply/0, set_max_ply/1, add_max_ply/1,get_login_data/2,disable_login/0,enable_login/0,shutdown/0]).

%%
%% API Functions
%%

makeall()->
	systools:make_script("world").


install()->
	mnesia:stop(),
	mnesia:delete_schema([node()]),
	mnesia:create_schema([node()]),
	mnesia:start(),
	
	{atomic, ok} = mnesia:create_table(config, [{ram_copies, [node()]}, {attributes, record_info(fields, config)}]),
	{atomic, ok} = mnesia:create_table(sql_config, [{ram_copies, [node()]}, {attributes, record_info(fields, sql_config)}]),
	{atomic, ok} = mnesia:create_table(sql_key_static, [{ram_copies, [node()]}, {attributes, record_info(fields, sql_key_static)}]),
	
	{atomic, ok} = mnesia:create_table(cache, [{ram_copies, [node()]}, {attributes, record_info(fields, cache)}]),
	{atomic, ok} = mnesia:create_table(ply, [{ram_copies, [node()]}, {attributes, record_info(fields, ply)}, {index, [aid,name]}]),
	{atomic, ok} = mnesia:create_table(guild_req_list, [{ram_copies, [node()]}, {attributes, record_info(fields, guild_req_list)}]),
	{atomic, ok} = mnesia:create_table(guild_store_access, [{ram_copies, [node()]}, {attributes, record_info(fields, guild_store_access)}]),
	{atomic, ok} = mnesia:create_table(treasure_house, [{ram_copies, [node()]}, {attributes, record_info(fields, treasure_house)}]),
	{atomic, ok} = mnesia:create_table(first_guild_battle_data, [{ram_copies, [node()]}, {attributes, record_info(fields, first_guild_battle_data)}]),
	{atomic, ok} = mnesia:create_table(final_guild_battle_data, [{ram_copies, [node()]}, {attributes, record_info(fields, final_guild_battle_data)}]),
	{atomic, ok} = mnesia:create_table(keepsake_copy, [{ram_copies, [node()]}, {attributes, record_info(fields, keepsake_copy)}]),
    {atomic, ok} = mnesia:create_table(chat_off_line, [{ram_copies, [node()]},{attributes,record_info(fields,chat_off_line)},{index, [uid]}]),

	{atomic, ok} = mnesia:create_table(account, [{ram_copies, [node()]}, {attributes, record_info(fields, account)}, {index, [username]}]),
	{atomic, ok} = mnesia:create_table(usr, [{ram_copies, [node()]}, {attributes, record_info(fields, usr)}, {index, [acc_id,name]}]),
	{atomic, ok} = mnesia:create_table(item, [{ram_copies, [node()]}, {attributes, record_info(fields, item)}, {index, [uid,guild_belong]}]),
	{atomic, ok} = mnesia:create_table(resource_main, [{ram_copies, [node()]}, {attributes, record_info(fields, resource_main)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(normal_skill, [{ram_copies, [node()]}, {attributes, record_info(fields, normal_skill)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(usr_skill_list, [{ram_copies, [node()]}, {attributes, record_info(fields, usr_skill_list)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(pet, [{ram_copies, [node()]}, {attributes, record_info(fields, pet)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(pet_skill, [{ram_copies, [node()]}, {attributes, record_info(fields, pet_skill)}, {index, [pet_id]}]),
	{atomic, ok} = mnesia:create_table(buff, [{ram_copies, [node()]}, {attributes, record_info(fields, buff)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(model_clothes, [{ram_copies, [node()]}, {attributes, record_info(fields, model_clothes)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(wing, [{ram_copies, [node()]}, {attributes, record_info(fields, wing)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(magic_weapon, [{ram_copies, [node()]}, {attributes, record_info(fields, magic_weapon)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(task, [{ram_copies, [node()]}, {attributes, record_info(fields, task)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(wanted_task, [{ram_copies, [node()]}, {attributes, record_info(fields, wanted_task)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(train_task, [{ram_copies, [node()]}, {attributes, record_info(fields, train_task)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(title, [{ram_copies, [node()]}, {attributes, record_info(fields, title)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(usr_rides, [{ram_copies, [node()]}, {attributes, record_info(fields, usr_rides)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(usr_rides_skin, [{ram_copies, [node()]}, {attributes, record_info(fields, usr_rides_skin)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(mail, [{ram_copies, [node()]}, {attributes, record_info(fields, mail)}, {index, [receive_uid]}]),
	{atomic, ok} = mnesia:create_table(cast_soul, [{ram_copies, [node()]}, {attributes, record_info(fields, cast_soul)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(recast_property, [{ram_copies, [node()]}, {attributes, record_info(fields, recast_property)}, {index, [uid,equip_id]}]),
	{atomic, ok} = mnesia:create_table(endless_challenge_record, [{ram_copies, [node()]}, {attributes, record_info(fields, endless_challenge_record)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(endless_star, [{ram_copies, [node()]}, {attributes, record_info(fields, endless_star)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(single_many_copy, [{ram_copies, [node()]}, {attributes, record_info(fields, single_many_copy)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(single_star, [{ram_copies, [node()]}, {attributes, record_info(fields, single_star)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(shop_record, [{ram_copies, [node()]}, {attributes, record_info(fields, shop_record)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(activity, [{ram_copies, [node()]}, {attributes, record_info(fields, activity)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(guild, [{ram_copies, [node()]}, {attributes, record_info(fields, guild)}]),
	{atomic, ok} = mnesia:create_table(guild_member, [{ram_copies, [node()]}, {attributes, record_info(fields, guild_member)}, {index, [guild_id,uid]}]),
	{atomic, ok} = mnesia:create_table(guild_event_log, [{ram_copies, [node()]}, {attributes, record_info(fields, guild_event_log)}, {index, [guild_id]}]),
	{atomic, ok} = mnesia:create_table(fly_up, [{ram_copies, [node()]}, {attributes, record_info(fields, fly_up)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(usr_arena, [{ram_copies, [node()]}, {attributes, record_info(fields, usr_arena)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(arena_log, [{ram_copies, [node()]}, {attributes, record_info(fields, arena_log)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(guild_item_log, [{ram_copies, [node()]}, {attributes, record_info(fields, guild_item_log)}, {index, [guild_id]}]),
    {atomic, ok} = mnesia:create_table(seal_boss_challenge, [{ram_copies, [node()]}, {attributes, record_info(fields, seal_boss_challenge)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(keepsake, [{ram_copies, [node()]}, {attributes, record_info(fields, keepsake)}, {index, [uid,target_uid]}]),
	{atomic, ok} = mnesia:create_table(ranklist_score, [{ram_copies, [node()]}, {attributes, record_info(fields, ranklist_score)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(ranklist_level, [{ram_copies, [node()]}, {attributes, record_info(fields, ranklist_level)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(ranklist_pet, [{ram_copies, [node()]}, {attributes, record_info(fields, ranklist_pet)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(ranklist_mount, [{ram_copies, [node()]}, {attributes, record_info(fields, ranklist_mount)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(ranklist_endless, [{ram_copies, [node()]}, {attributes, record_info(fields, ranklist_endless)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(ranklist_guild, [{ram_copies, [node()]}, {attributes, record_info(fields, ranklist_guild)}, {index, [guild_id]}]),
	{atomic, ok} = mnesia:create_table(ranklist_wing, [{ram_copies, [node()]}, {attributes, record_info(fields, ranklist_wing)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(ranklist_flower_send, [{ram_copies, [node()]}, {attributes, record_info(fields, ranklist_flower_send)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(ranklist_flower_recv, [{ram_copies, [node()]}, {attributes, record_info(fields, ranklist_flower_recv)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(ranklist_evil, [{ram_copies, [node()]}, {attributes, record_info(fields, ranklist_evil)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(ranklist_hero, [{ram_copies, [node()]}, {attributes, record_info(fields, ranklist_hero)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(ranklist_arena, [{ram_copies, [node()]}, {attributes, record_info(fields, ranklist_arena)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(sworn_brother, [{ram_copies, [node()]}, {attributes, record_info(fields, sworn_brother)}]),
	{atomic, ok} = mnesia:create_table(relation, [{ram_copies, [node()]}, {attributes, record_info(fields, relation)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(sworn_brother_reward, [{ram_copies, [node()]}, {attributes, record_info(fields, sworn_brother_reward)}, {index, [uid]}]),
	{atomic, ok} = mnesia:create_table(quell_demon_pagoda, [{ram_copies, [node()]},{attributes,record_info(fields,quell_demon_pagoda)},{index, [uid]}]),
	{atomic, ok} = mnesia:create_table(shelve, [{ram_copies, [node()]},{attributes,record_info(fields,shelve)},{index, [uid]}]),
	{atomic, ok} = mnesia:create_table(worship, [{ram_copies, [node()]},{attributes,record_info(fields,worship)},{index, [uid]}]),
	{atomic, ok} = mnesia:create_table(worship_model, [{ram_copies, [node()]},{attributes,record_info(fields,worship_model)},{index, [uid]}]),
	{atomic, ok} = mnesia:create_table(storm_city_own, [{ram_copies, [node()]},{attributes,record_info(fields,storm_city_own)}]),
	{atomic, ok} = mnesia:create_table(storm_city_apply, [{ram_copies, [node()]},{attributes,record_info(fields,storm_city_apply)}]),
	{atomic, ok} = mnesia:create_table(storm_city_astrict, [{ram_copies, [node()]},{attributes,record_info(fields,storm_city_astrict)},{index, [uid]}]),
	{atomic, ok} = mnesia:create_table(rand_box_reward, [{ram_copies, [node()]},{attributes,record_info(fields,rand_box_reward)},{index, [uid]}]),
	{atomic, ok} = mnesia:create_table(vip_manager, [{ram_copies, [node()]},{attributes,record_info(fields,vip_manager)},{index, [uid]}]),
	{atomic, ok} = mnesia:create_table(recharge_record, [{ram_copies, [node()]},{attributes,record_info(fields,recharge_record)},{index, [uid]}]),
	{atomic, ok} = mnesia:create_table(daily_recharge_record, [{ram_copies, [node()]},{attributes,record_info(fields,daily_recharge_record)},{index, [uid]}]),
	{atomic, ok} = mnesia:create_table(offline_recharge_record, [{ram_copies, [node()]},{attributes,record_info(fields,offline_recharge_record)},{index, [uid]}]),
	{atomic, ok} = mnesia:create_table(login_reward, [{ram_copies, [node()]},{attributes,record_info(fields,login_reward)},{index, [uid]}]),
	{atomic, ok} = mnesia:create_table(everyday_reward, [{ram_copies, [node()]},{attributes,record_info(fields,everyday_reward)},{index, [uid]}]),
	{atomic, ok} = mnesia:create_table(guild_battle_info, [{ram_copies, [node()]},{attributes,record_info(fields,guild_battle_info)},{index, [battle_index]}]),
	{atomic, ok} = mnesia:create_table(usr_cd_key, [{ram_copies, [node()]},{attributes,record_info(fields,usr_cd_key)},{index, [uid]}]),
	{atomic, ok} = mnesia:create_table(usr_flower, [{ram_copies, [node()]},{attributes,record_info(fields,usr_flower)},{index, [uid]}]),
	{atomic, ok} = mnesia:create_table(lev_reward, [{ram_copies, [node()]},{attributes,record_info(fields,lev_reward)},{index, [uid]}]),
	{atomic, ok} = mnesia:create_table(online_reward, [{ram_copies, [node()]},{attributes,record_info(fields,online_reward)},{index, [uid]}]),
	{atomic, ok} = mnesia:create_table(liveness, [{ram_copies, [node()]},{attributes,record_info(fields,liveness)},{index, [uid]}]),
	{atomic, ok} = mnesia:create_table(operation_activity, [{ram_copies, [node()]},{attributes,record_info(fields,operation_activity)},{index, [act_id]}]),
	{atomic, ok} = mnesia:create_table(operation_activity_detail, [{ram_copies, [node()]},{attributes,record_info(fields,operation_activity_detail)},{index, [act_id]}]),
	{atomic, ok} = mnesia:create_table(operation_activity_reward, [{ram_copies, [node()]},{attributes,record_info(fields,operation_activity_reward)},{index, [uid]}]),
	{atomic, ok} = mnesia:create_table(operation_act_data, [{ram_copies, [node()]},{attributes,record_info(fields,operation_act_data)}]),
	{atomic, ok} = mnesia:create_table(open_server_gift_activity, [{ram_copies, [node()]},{attributes,record_info(fields,open_server_gift_activity)},{index, [act_id]}]),
	{atomic, ok} = mnesia:create_table(open_server_gift_ware, [{ram_copies, [node()]},{attributes,record_info(fields,open_server_gift_ware)},{index, [act_id]}]),
	{atomic, ok} = mnesia:create_table(open_server_gift_buy_record, [{ram_copies, [node()]},{attributes,record_info(fields,open_server_gift_buy_record)},{index, [uid]}]),
	{atomic, ok} = mnesia:create_table(new_function_open, [{ram_copies, [node()]},{attributes,record_info(fields,new_function_open)},{index, [uid]}]),
	{atomic, ok} = mnesia:create_table(love_reward, [{ram_copies, [node()]},{attributes,record_info(fields,love_reward)},{index, [uid]}]),
	{atomic, ok} = mnesia:create_table(weekcard_reward, [{ram_copies, [node()]},{attributes,record_info(fields,weekcard_reward)},{index, [uid]}]),
	{atomic, ok} = mnesia:create_table(guild_cart_escort_data, [{ram_copies, [node()]},{attributes,record_info(fields,guild_cart_escort_data)}]),
	{atomic, ok} = mnesia:create_table(achievement, [{ram_copies, [node()]},{attributes,record_info(fields,achievement)},{index, [uid]}]),


	mnesia:stop().

reconnect(Dbm) ->
    case net_adm:ping(Dbm) of
		pong -> io:format("connect ok~n");
		_ -> io:format("connect fail")
	end.


check() ->
	gen_server:cast({global, dbm}, {check}).

selectall(Tab) ->
	select(Tab, "*", all).

select(Tab, FiltStr) ->
	select(Tab, "*", FiltStr).

select(Tab, Columns, FiltStr) ->
	TabStr = util:to_list(Tab),
	ColList = mnesia:table_info(Tab, attributes),
	WhereStr =
	case FiltStr of
	all -> {?OK, ""};
	_ ->
		FiltCount = string:words(FiltStr, $,),
		TempL = lists:seq(1, FiltCount),
		FWhere =
		fun(N, Ret) ->
			Filt = string:sub_word(FiltStr, N, $,),
			{ok,Scanned,_} = erl_scan:string(Filt),
			Col = element(3, lists:nth(1, Scanned)),
			Oper = element(1, lists:nth(2, Scanned)),
			Value = element(3, lists:nth(3, Scanned)),
	
			case Ret of
			{?ERROR, Reason} -> {?ERROR, Reason};
			{?OK, RetStr} ->
				case get_col_pos(ColList, Col, 1) of
				0 -> {?ERROR, "Error:column " ++ util:to_list(Col) ++ " not found in record " ++ TabStr};
				Pos when is_integer(Value) -> {?OK, RetStr ++ ",element(" ++ integer_to_list(Pos+1) ++ ",X)" ++ util:to_list(Oper) ++ util:to_list(Value)};
				Pos -> {?OK, RetStr ++ ",element(" ++ integer_to_list(Pos+1) ++ ",X)" ++ util:to_list(Oper) ++ "<<\"" ++ util:to_list(Value) ++ "\">>"}
				end
			end
		end,
		lists:foldl(FWhere, {?OK, ""}, TempL)
	end,
	
	SelectColumn =
	case Columns of
	"*" -> "X";
	_ ->
		ColCount = string:words(Columns, $,),
		TempL1 = lists:seq(1, ColCount),
		FCol =
		fun(N, Ret) ->
			Col = util:to_atom(string:sub_word(Columns, N, $,)),
	
			case Ret of
			{?ERROR, Reason} -> {?ERROR, Reason};
			{?OK, RetStr} ->
				case get_col_pos(ColList, Col, 1) of
				0 -> {?ERROR, "Error:column " ++ util:to_list(Col) ++ " not found in record " ++ TabStr};
				Pos when length(RetStr) =:= 0 -> {?OK, RetStr ++ "element(" ++ integer_to_list(Pos+1) ++ ",X)"};
				Pos -> {?OK, RetStr ++ ",element(" ++ integer_to_list(Pos+1) ++ ",X)"}
				end
			end
		end,
		
		ColStr1 = lists:foldl(FCol, {?OK, ""}, TempL1),
		case ColStr1 of
		{?OK, Str} -> "{" ++ Str ++ "}";
		{?ERROR, Why} -> io:format("~s~n", [Why]),"X"
		end
	end,
	%ColStr = "{" ++ SelectColumn ++ "}",
	case WhereStr of
	{?OK, EndStr} ->
		End = EndStr ++ "])).",
		S = "db:do(qlc:q([" ++ SelectColumn ++ " || X<-mnesia:table("++TabStr++")" ++ End,
		io:format("exec ~s~n", [S]),
		exe_str(S);
	{?ERROR, Msg} -> Msg
	end.

update(Tab, Expr, Where) ->
	RecordList = select(Tab, Where),
	case length(RecordList) > 0 of
	?TRUE ->
		Fdo =
		fun(Record) ->
			%Record = lists:nth(1, RecordList),
			TabStr = util:to_list(Tab),
			ColList = mnesia:table_info(Tab, attributes),
			FiltCount = string:words(Expr, $,),
			TempL = lists:seq(1, FiltCount),
			F =
			fun(N, Ret) ->
				Filt = string:sub_word(Expr, N, $,),
				{ok,Scanned,_} = erl_scan:string(Filt),
				Col = element(3, lists:nth(1, Scanned)),
				Value = element(3, lists:nth(3, Scanned)),
				io:format("Col=~p,Value=~p~n",[Col,Value]),
				case Ret of
				{?ERROR, Reason} -> {?ERROR, Reason};
				{?OK, RetRec} ->
					case get_col_pos(ColList, Col, 1) of
					0 -> {?ERROR, "Error:column " ++ util:to_list(Col) ++ " not found in record " ++ TabStr};
					Pos when is_integer(Value) -> {?OK, setelement(Pos+1, RetRec, Value)};
					Pos -> {?OK, setelement(Pos+1, RetRec, util:to_binary(Value))}
					end
				end
			end,
			Result = lists:foldl(F, {?OK, Record}, TempL),
			case Result of
			{?OK, Rec} ->
				io:format("newrecord ~w~n", [Rec]),
				db:put(Rec);
			{?ERROR, Msg} -> io:format("~s~n", [Msg])
			end
		end,
		lists:foreach(Fdo, RecordList);
	?FALSE when length(RecordList) =:= 0 -> "Error:record not found"
	end.

get_col_pos(L, _Colname, N) when N > length(L) -> 0;
get_col_pos(L, Colname, N) ->
	%io:format("aaa=~p~n", [Colname]),
	case lists:nth(N, L) =:= util:to_atom(Colname) of
	?TRUE -> N;
	?FALSE -> get_col_pos(L, Colname, N+1)
	end.

exe_str(Str) ->
	{ok,Scanned,_} = erl_scan:string(Str),
	{ok,Parsed} = erl_parse:parse_exprs(Scanned),
	{value, Value,_} = erl_eval:exprs(Parsed,[]),
	Value.

get_login_data(Acc, Psw) ->
	Data = "1347933926.98",
	Key = "DNF2NJFT64ETYJUM",
	Ret = util:md5(lists:concat([util:to_list(Acc), "&", util:to_list(Psw), "&", util:to_list(Data), Key])),
	{Data, Ret}.

%% get_max_ply() -> {ok, MaxPly}
get_max_ply() ->
	login_svr:get_max_ply().

%% set_max_ply() -> {ok, MaxPly} | {error, Reason}
set_max_ply(Value) ->
	login_svr:set_max_ply(Value).

%% add_max_ply() -> {ok, MaxPly} | {error, Reason}
add_max_ply(Value) ->
	login_svr:add_max_ply(Value).

disable_login() ->
	 gen_server:cast({global, login}, {enable_login, false}).

enable_login() ->
	 gen_server:cast({global, login}, {enable_login, true}).


%% getnowonline()->
%% 	L=db:dirty_match(ply,#ply{_='_'}),
%% 	erlang:length(L).
%% 
%% kick_all_usr() ->
%% 	case db:tran_match(ply, #ply{_ = '_'}) of
%% 		[] -> skip;
%% 		List ->
%% 			lists:foreach(fun(#ply{sid=Sid,uid=Uid}) -> record_back(Uid),?discon(Sid, shutdown, 1) end, List)
%% 	end,
%% 	gen_server:cast({global, login}, {kick_all_usr}).

shutdown() ->
	gen_server:cast({global, agent_mng}, {shutdown}).



topN(N, binary)->
        [{P, M, process_info(P, [registered_name, initial_call,current_function, dictionary]), B} ||
        {P, M, B} <- lists:sublist(processes_sorted_by_binary(),N)];
topN(N, memory)->
	 [{P, M, process_info(P, [registered_name, initial_call,current_function, dictionary])} ||
        {P, M} <- lists:sublist(processes_sorted_by_memory(),N)];
topN(N, msg_queue_len) ->
	 [{P, M, process_info(P, [registered_name, initial_call,current_function, dictionary])} ||
        {P, M} <- lists:sublist(processes_sorted_by_msg_queue_len(),N)].

processes_sorted_by_binary()->
	L =
     [case process_info(P, binary) of
              {_, Bins} ->
                 SortedBins = lists:usort(Bins),
                 {_, Sizes, _} = lists:unzip3(SortedBins),
                 {P, lists:sum(Sizes), []};
              _ ->
                {P, 0, []}
         end ||P <- processes()],
	 lists:reverse(lists:keysort(2,L)).
processes_sorted_by_memory() ->
	L =
	 [case process_info(P, memory) of
              {_, Size} -> {P, Size};
              _ -> {P, 0}
         end ||P <- processes()],
	 lists:reverse(lists:keysort(2,L)).
processes_sorted_by_msg_queue_len() ->
	L =
	 [case process_info(P, message_queue_len) of
              {_, Len} -> {P, Len};
              _ -> {P, 0}
         end ||P <- processes()],
	lists:reverse(lists:keysort(2,L)).

	