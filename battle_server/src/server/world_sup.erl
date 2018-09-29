-module(world_sup).
-behaviour(supervisor).
-export([start/0,start_link/0,init/1]).
-include("common.hrl").

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

start() ->
    ?MODULE:start_link().

init([]) ->
	SvrList = [	
			   {scene_ctr, {scene_ctr, start_link, []}, permanent, 5000, worker, [scene_ctr]},
			   {scene_sup, {scene_sup, start_link, []}, permanent, 5000, supervisor, [scene_sup]},
			   {gate_way_sup, {gate_way_sup,start_link,[]}, permanent, 5000, supervisor, [gate_way_sup]},
			   {agent_mng,  {world_svr, start_link, [agent_mng, fun_agent_mng]},permanent, 5000, worker, [world_svr]},
			   {scene_mng, 	{world_svr,start_link,[scene_mng,fun_scene_mng]},permanent, 5000, worker, [world_svr]}
			  ],
    RestartStrategy = {one_for_one, 3, 10},
	
	?log("Info:public_sup init"),
	{ok, {RestartStrategy, SvrList}}.



