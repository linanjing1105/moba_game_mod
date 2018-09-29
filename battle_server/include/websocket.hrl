%%%-----------------------------------
%%% @Author		: linanjing
%%% @Created	: 2018/9/26
%%% @Doc		: websocket相关
%%%-----------------------------------
-record(websocket_state,{
			pid,				% 本进程PID
			socket,				% 本进程Socket
			accid,				% 玩家登陆ID
			accname,			% 玩家登陆账号
			role_pid,			% 玩家逻辑进程PID
			via = 0,			% 玩家登录来源(0 web, 1 微端)
			bin = <<>>,			% 剩余Bin(粘包)
			flag = 0 			% 登录阶段(0 未登录，1 已登录， 2 未创建角色，3 选择角色)
	}).
-define(TCP_OPTIONS, [binary, {packet, 0},
					  {active, false},
					  {reuseaddr, true}, 
					  {nodelay, false},
					  {delay_send, true},
					  {send_timeout, 5000}, 
					  {keepalive, true}, 
					  {exit_on_close, true}]).

-define(PT_CODE,<<"code">>).
-define(PT_RET_CODE,<<"ret_code">>).
-define(PT_TOKEN,<<"token">>).




-define(PT_REQ_HEART,1001).
-define(PT_RET_HEART,10001).
-define(PT_REQ_DISCON,1002).
-define(PT_RET_DISCON,10002).
-define(PT_REQ_LOGIN,1003).
