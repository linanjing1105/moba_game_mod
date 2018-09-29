%% @author Administrator
%% @doc @todo Add description to fun_gate_way_mng.


-module(fun_gate_way_mng).
-include("common.hrl").
%% ====================================================================
%% API functions
%% ====================================================================
-export([do_msg/1]).



%% ====================================================================
%% Internal functions
%% ====================================================================


do_msg(Msg)->
	?debug("Msg=~p~n",[Msg]). 
	