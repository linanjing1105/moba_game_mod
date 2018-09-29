-module(gate_way_sup).
-behaviour(supervisor).
-include("common.hrl").
-export([start_link/0]).
-export([init/1]).
-export([start/0]).
-export([add/1,relay/1]).

%%--------------------------------------------------------------------
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

start() ->
    ?MODULE:start_link([]).

init([]) ->
	?debug("gate_way_sup start"),
    Children = {gate_way, {gate_way, start_link, []}, temporary, 2000, worker, [gate_way]},
    RestartStrategy = {simple_one_for_one, 10, 10},
	{ok, Port} = application:get_env(port),	
	timer:apply_after(2000, ?MODULE, add, [Port]),
    {ok, {RestartStrategy, [Children]}}.
   



add(Port) ->
	?debug("Port=~p",[Port]),
    case gen_tcp:listen(Port, ?TCP_OPTIONS) of 
        {ok, Sock} ->
			?debug("Sock=~p",[Sock]),
            relay(Sock);
        {error, Reason} ->
			?log_error("listen error Reason = ~p",[Reason]),
            {stop, {cannot_listen, Reason}}
    end.
relay(Sock) ->
    {ok, Pid} = supervisor:start_child(?MODULE, [test]),
    gen_tcp:controlling_process( Sock, Pid ),
    gen_server:cast(Pid, {accept, Sock}).

