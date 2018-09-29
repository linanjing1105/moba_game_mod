-module(world_app).

-include("common.hrl").

-export([start/2,stop/1]).

start(_StartType, _StartArgs) ->    
    {ok, Name} = application:get_env(name),
    {ok, Cookie} = application:get_env(cookie),
	?log("Name=~p~n",[Name]),
	?log("Cookie=~p~n",[Cookie]),
    net_kernel:start([Name, longnames]),
    erlang:set_cookie(node(), Cookie),	
	do_start().


stop(_State) ->
    ok.




do_start()-> 
	inets:start(),
    case world_sup:start_link() of      
        {ok, Pid} -> {ok, Pid};
        Other ->     {error, Other}
    end.



