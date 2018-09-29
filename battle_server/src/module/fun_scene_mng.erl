-module(fun_scene_mng).
-include("common.hrl").

-export([do_init/0,do_close/0,do_call/1,do_info/1,do_time/1,do_msg/1]).
-export([broadcast_scene_msg/1,broadcast_scene_msg/2,is_scene_exist/1]).

-record(scene_svr, {idx = 0, pid =0,max_scene=0,scene=0}).
-record(scene,  {id,owner=0, type= 0,module = 0,pid=0,num=0,scene_idx=0,create_time=0,all_time=0,status=0,status_time=0}). 

-define(SCENE_RUN_ON_TIME,1000).

do_init()-> 
	?log("init==============="),
	ets:new(scene_svr, [set,public,named_table,{keypos, #scene_svr.idx}]),
	ets:new(scene, [set,public,named_table,{keypos, #scene.id}]),
	ok.
do_close() -> ok.

do_call({scene_ctr_add, Index, Pid, MaxScene}) ->
	case ets:lookup(scene_svr, Index) of
		[_Old] ->
			?log_trace("scene_ctr_add find old index:~p",[Index]),
			{error, duplicate_index};
		_ ->
			?log_trace("scene_ctr_add,index=~p,max_scene=~p",[Index,MaxScene]),
			ets:insert(scene_svr, #scene_svr{idx=Index,pid=Pid, max_scene=MaxScene, scene=0}),
			erlang:monitor(process, Pid),
			ok
	end;
do_call(_Msg) -> ok.
do_info({'DOWN', _MonitorRef, process, Pid, Info}) ->
	?log_warning("process down,pid=~p,info=~p",[Pid,Info]),
	case ets:match_object(scene_svr, #scene_svr{pid=Pid,_ = '_'}) of
		[#scene_svr{idx=Index}] ->
			?log_warning("scene_ctr down,index=~p",[Index]),
			ets:delete(scene_svr, Index),
			lists:foreach(fun(#scene{id=ID}) ->
								  ets:delete(scene, ID),
								  server_tools:send_to_agent_mng({kick_usr_by_scene_index, Index})
						  end,
						  ets:match_object(scene, #scene{_ = '_', scene_idx = Index}));
		_ -> skip
	end;
do_info(_Info) -> ok.


do_msg({scene_ctr_add, Index, Pid, MaxScene}) ->
	case ets:lookup(scene_svr, Index) of
		[_Old] ->
			?debug("scene_ctr_add find old index:~p",[Index]),
			{error, duplicate_index};
		_ ->
			?debug("scene_ctr_add,index=~p,max_scene=~p",[Index,MaxScene]),
			ets:insert(scene_svr, #scene_svr{idx=Index,pid=Pid, max_scene=MaxScene, scene=0}),
			ok
	end;
do_msg({scene_ctr_del, Index}) ->
	case ets:lookup(scene_svr, Index) of
		[_Old] ->
			?debug("scene_ctr_del,index=~p",[Index]),
			ets:delete(scene_svr, Index);
		_ -> skip
	end;

do_msg({scene_add,{ID,Key,Scene,Hid,Idx,UsrInfoList}})->
	?debug("fun_scenemng scene_add data=~p",[{ID,Key,Scene,Hid,Idx,UsrInfoList}]),	
	server_tools:send_to_agent_mng({ask_usrs_to_start_fly, UsrInfoList,Scene,ID});
	
%% 	AllTime = case data_scene_config:get_scene(Scene) of
%% 				  #st_scene_config{life_time = LifeTime} ->
%% 					  if
%% 						  LifeTime > 10 -> LifeTime * 1000;
%% 						  true -> 10 * 1000
%% 					  end;
%% 				  _ -> 30 * ?ONE_MIN_SECONDS * 1000
%% 			  end,
%% 	
%% 	Now = util:longunixtime(),	
%% 	case ets:lookup(scene,ID) of
%% 		[_OldScene] ->
%% 			ets:insert(scene, #scene{id = ID,owner=Key, type = Scene,pid=Hid,num=0,scene_idx=Idx
%% 							   ,create_time=Now,all_time=AllTime,status=create,status_time=Now});
%% 		_ -> 
%% 			case ets:lookup(scene_svr, Idx) of
%% 				[Scenesvr = #scene_svr{scene = Cur}] -> 				
%% 					ets:insert(scene_svr, Scenesvr#scene_svr{scene = Cur + 1}),
%% 					ets:insert(scene, #scene{id = ID,owner=Key, type = Scene,pid=Hid,num=0,scene_idx=Idx
%% 										,create_time=Now,all_time=AllTime,status=create,status_time=Now});
%% 				_ -> skip
%% 			end
%% 	end;
do_msg({scene_del,ID})-> 
	?debug("scene_del ID=~p",[ID]),
	case ets:lookup(scene,ID) of
		[Scene=#scene{}] -> 
			ets:delete(scene, ID),
			case ets:lookup(scene_svr, Scene#scene.scene_idx) of
				[Scenesvr = #scene_svr{scene = Cur}] when Cur > 0 -> 
					ets:insert(scene_svr, Scenesvr#scene_svr{scene = Cur - 1});
				_ -> skip
			end;
		_ -> skip
	end;
do_msg({scene_chg_num,ID,Num})-> 
	case ets:lookup(scene, ID) of
		[Scene=#scene{status=OldState,num=OldNum}] when erlang:is_record(Scene, scene)->	
			?debug("scene_chg_num data............. = ~p",[{ID,Num,OldNum}]),
			case OldState of
				create ->
					if
						Num >= OldNum -> ets:insert(scene, Scene#scene{num = Num,status = run,status_time = util:longunixtime()});
						true -> ets:insert(scene, Scene#scene{num = Num})
					end;
				{hang,PrevState} ->
					if
						Num >= OldNum -> ets:insert(scene, Scene#scene{num = Num,status = PrevState,status_time = util:longunixtime()});
						true -> ets:insert(scene, Scene#scene{num = Num})
					end;
				_ -> ets:insert(scene, Scene#scene{num = Num})
			end;
		_ -> skip
	end;
do_msg({start_fly,UsrInfoList,{id,SceneId},_SceneData}) ->
	?debug("=============fly==============="),
	case ets:lookup(scene,SceneId) of
		[#scene{type=SceneType}] ->
			server_tools:send_to_agent_mng({ask_usrs_to_start_fly, UsrInfoList,SceneType,SceneId});
		_ -> ?log_warning("start_fly_by_scene_id failed,scene_id=~p,usr_info_list=~p", [SceneId,UsrInfoList])
	end;
do_msg({start_fly,UsrInfoList,Scene,SceneData}) -> 
	?debug("start_fly,UsrInfoList=~p,Scene=~p,SceneData=~p",[UsrInfoList,Scene,SceneData]);
%% 	case data_scene_config:get_scene(Scene) of
%% 		#st_scene_config{sort = ?SCENE_SORT_CITY,max_agent= Max,full_create = Create} ->
%% 			Key = {system_city,Scene},
%% 			case ets:match_object(scene, #scene{_ = '_',owner = Key}) of
%% 				Scenes when erlang:is_list(Scenes) -> 
%% 					case get_best_scene(Scenes,1,Max,no) of
%% 						no -> 
%% 							if
%% 								Create == 1 -> req_create_scene(Key,UsrInfoList,Scene,SceneData);
%% 								true -> ?log_warning("scene is full,scene=~p" , [Scene])
%% 							end;
%% 						{#scene{id = SceneId},_} ->
%% 							server_tools:send_to_agent_mng({ask_usrs_to_start_fly, UsrInfoList,Scene,SceneId})
%% 					end;	
%% 				R1 -> ?log_error("req_create_scene match error R = ~p",[R1])
%% 			end;
%% 		#st_scene_config{sort = ?SCENE_SORT_PEACE,max_agent= Max,full_create = Create} ->
%% 			Key = {system_outdoor,Scene},
%% 			case ets:match_object(scene, #scene{_ = '_',owner = Key}) of
%% 				Scenes when erlang:is_list(Scenes) -> 
%% 					case get_best_scene(Scenes,1,Max,no) of
%% 						no -> 
%% 							if
%% 								Create == 1 -> req_create_scene(Key,UsrInfoList,Scene,SceneData);
%% 								true -> ?log_warning("scene is full,scene=~p" , [Scene])
%% 							end;
%% 						{#scene{id = SceneId},_} ->
%% 							server_tools:send_to_agent_mng({ask_usrs_to_start_fly, UsrInfoList,Scene,SceneId})
%% 					end;	
%% 				R1 -> ?log_error("req_create_scene match error R = ~p",[R1])
%% 			end;
%% 		#st_scene_config{sort = ?SCENE_SORT_SCUFFLE,max_agent= Max,full_create = Create} ->
%% 			Key = {system_outdoor,Scene},
%% 			case ets:match_object(scene, #scene{_ = '_',owner = Key}) of
%% 				Scenes when erlang:is_list(Scenes) -> 
%% 					case get_best_scene(Scenes,1,Max,no) of
%% 						no -> 
%% 							if
%% 								Create == 1 -> req_create_scene(Key,UsrInfoList,Scene,SceneData);
%% 								true -> ?log_warning("scene is full,scene=~p" , [Scene])
%% 							end;
%% 						{#scene{id = SceneId},_} ->
%% 							server_tools:send_to_agent_mng({ask_usrs_to_start_fly, UsrInfoList,Scene,SceneId})
%% 					end;	
%% 				R1 -> ?log_error("req_create_scene match error R = ~p",[R1])
%% 			end;
%% 		#st_scene_config{sort =Sort} when Sort ==?SCENE_SORT_COPY orelse Sort==?SCENE_SORT_STORY 
%% 										  orelse Sort==?SCENE_SORT_ACTIVITY orelse Sort==?SCENE_SORT_ANCIENT->
%% 			case UsrInfoList of
%% 				[{Uid,_Seq,_Pos,_} | _Next] ->
%% 					Key = case lists:keyfind(owner, 1, SceneData) of
%% 							  {owner, {team, TeamId}} -> {team_copy, TeamId, Scene};
%% 							  {owner, {guild, GuildId}} -> {guild_copy, GuildId, Scene};
%% 							  {owner, {common_copy, Id}} -> {common_copy, Id, Scene};
%% 							  _ -> {user_copy, Uid, Scene, erlang:make_ref()}
%% 						  end,
%% 					case ets:match_object(scene, #scene{_ = '_',owner = Key}) of
%% 						[] -> req_create_scene(Key,UsrInfoList,Scene,SceneData);
%% 						[#scene{id = SceneId}] -> server_tools:send_to_agent_mng({ask_usrs_to_start_fly, UsrInfoList,Scene,SceneId});
%% 						_ -> ?log_error("req_create_scene error Key=~p,Scene=~p",[Key,Scene])
%% 					end;					
%% 				_ ->  ?log_error("req_create_scene error UsrInfoList=~p,Scene=~p",[UsrInfoList,Scene])
%% 			end;		
%% 		#st_scene_config{sort = ?SCENE_SORT_ARENA} ->
%% 			case UsrInfoList of
%% 				[{Uid,_Seq,_Pos,_} | _Next] ->
%% 					Key = case lists:keyfind(owner, 1, SceneData) of
%% 							  {owner, {team, TeamId}} -> {team_copy, TeamId, Scene};
%% 							  {owner, {guild, GuildId}} -> {guild_copy, GuildId, Scene};
%% 							  {owner, {common_copy, Id}} -> {common_copy, Id, Scene};
%% 							  _ -> {user_copy, Uid, Scene, erlang:make_ref()}
%% 						  end,			
%% 					case ets:match_object(scene, #scene{_ = '_',owner = Key}) of
%% 						[] -> req_create_scene(Key,UsrInfoList,Scene,SceneData);
%% 						[#scene{id = SceneId}] -> server_tools:send_to_agent_mng({ask_usrs_to_start_fly, UsrInfoList,Scene,SceneId});
%% 						_ -> ?log_error("req_create_scene error Key=~p,Scene=~p",[Key,Scene])
%% 					end;					
%% 				_ ->  ?log_error("req_create_scene error UsrInfoList=~p,Scene=~p",[UsrInfoList,Scene])
%% 			end;
%% 		R1 -> ?log_error("req_create_scene match error R = ~p",[R1])
%% 	end;
%% 让玩家进入场景，并通知agentmng修改玩家场景                                                                    
do_msg({enter_scene, SceneID,Uid,Sid,Seq,EnterSceneData})->	
	?debug("enter_scene ID..............................=~p,Uid=~p",[SceneID,Uid]),
	case ets:lookup(scene,SceneID) of
		[#scene{pid=ScenePid,scene_idx = SceneIdx,type=SceneType}] ->
			server_tools:send_to_agent_mng({usr_in_scene,Uid,SceneID,SceneType,ScenePid,SceneIdx}),
			server_tools:send_to_scene(ScenePid, {usr_enter_scene, Uid,Sid,Seq,EnterSceneData});
		_ -> error
	end;
do_msg({hang_scene, SceneID}) ->
	case ets:lookup(scene,SceneID) of
		[Scene] ->
			if
				Scene#scene.status == run orelse Scene#scene.status == create ->
					ets:insert(scene, Scene#scene{status={hang, Scene#scene.status}});
				true -> skip
			end;
		_ -> skip
	end;
do_msg({resume_scene, SceneID}) ->
	case ets:lookup(scene,SceneID) of
		[Scene = #scene{status={hang,PrevStatus}}] ->
			ets:insert(scene, Scene#scene{status=PrevStatus});
		_ -> skip
	end;
			
do_msg(Msg) ->
	?debug("unknown msg,msg=~p",[Msg]).

do_time(Now) -> ok.
%% 	Fun = fun(Scene = #scene{id = Id,type=Scene_Type,owner =Owner,num=Num,pid=SceneHid,create_time=CTime,all_time=AllTime,status=Status,status_time=Stime}) ->
%% 				  case Status of
%% 					  create -> 
%% 						  if
%% 							  Now - Stime > 300 * 1000 ->
%% 								  ets:insert(scene,Scene#scene{status = run,status_time = Now});
%% 							  true -> skip
%% 						  end;
%% 					  run ->
%% 						  if					
%% 							  Num == 0 ->
%% 								  case Owner of
%% 									  {system_city,_} -> 
%% 										  MyList = ets:match_object(scene, #scene{owner = Owner,_='_'}),
%% 										  case can_del(MyList,Id) of%%还有城镇类场景
%% 											  true -> 
%% %% 												  ?log("Scene id = ~p run->del1",[Id]),
%% 												  ets:insert(scene,Scene#scene{status = del,status_time = Now});
%% 											  _ -> skip
%% 										  end;
%% 									  {system_outdoor,_} ->
%% 										  MyList = ets:match_object(scene, #scene{owner = Owner, _='_'}),
%% 										  case can_del(MyList,Id) of%%还有户外类场景
%% 											  true -> 
%% %% 												  ?log("Scene id = ~p run->del1",[Id]),
%% 												  ets:insert(scene,Scene#scene{status = del,status_time = Now});
%% 											  _ -> skip
%% 										  end;										  
%% 									  _ -> 
%% %% 										  ?log("Scene id = ~p run->del2",[Id]),
%% 										  NeedDel =
%% 										  case data_scene_config:get_scene(Scene_Type) of
%% 											  #st_scene_config{destroy_if_empty = 1} ->true;				  
%% 											  _ ->
%% 												  	if
%% 											 			 Now - CTime > AllTime -> true;
%% 														 true -> false
%% 													end
%% 										  end,
%% 										  if
%% 											  NeedDel == true -> 
%% 												  ets:insert(scene,Scene#scene{status = del,status_time = Now});
%% 											  true -> skip
%% 										  end
%% 								  end;
%% 							  true -> 
%% 								  case Owner of
%% 									  {system_city,_} -> skip;
%% 									  {system_outdoor,_} -> skip;
%% 									  _ -> 
%% 										  if
%% 											  Now - CTime > AllTime ->  %%kick...
%% %% 												  ?log("Scene id = ~p run->ended",[Id]),
%% 												  ets:insert(scene,Scene#scene{status = ended,status_time = Now});
%% 											  true -> skip
%% 										  end
%% 								  end
%% 						  end;
%% 					  {hang, _PrevStatus} ->
%% 						  case Owner of
%% 							  {system_city,_} -> skip;
%% 							  {system_outdoor,_} -> skip;
%% 							  _ -> 
%% 								  if
%% 									  Now - CTime > AllTime ->  
%% 										  %% 	?log("Scene id = ~p hang->ended",[Id]),
%% 										  ets:insert(scene,Scene#scene{status = ended,status_time = Now});
%% 									  true -> skip
%% 								  end
%% 						  end;
%% 					  ended -> 
%% 						  if
%% 							  Now - Stime > 10 * 1000 -> %%kick...
%% %% 								  ?log("Scene id = ~p ended->kick",[Id]),								  
%% %% 								  gen_server:cast(SceneHid, {time_finish}),%%通知客户端场景运行时间到了	
%% 								  ets:insert(scene,Scene#scene{status = kick,status_time = Now});
%% 							  true -> skip
%% 						  end;					  
%% 					  kick -> 
%% 						  if					
%% 							  Num == 0 ->
%% 								  case Owner of
%% 									  {system_city,_} -> skip;
%% 									  {system_outdoor,_} -> skip;
%% 									  _ -> 
%% %% 										  ?log("Scene id = ~p kick->kicked",[Id]),
%% 										  ets:insert(scene,Scene#scene{status = del, status_time = Now})
%% 								  end;
%% 							  true ->
%% %% 								  ?log("Scene id = ~p kick->kicked",[Id]),
%% 								  server_tools:send_to_scene(SceneHid, {kick_all_usr}),%%踢掉所有人								  
%% 								  ets:insert(scene,Scene#scene{status = kicked, status_time = Now})
%% 						  end;
%% 					  kicked -> 
%% 						  if
%% 							  Num == 0 ->
%% 								  case Owner of
%% 									  {system_city,_} -> skip;
%% 									  {system_outdoor,_} -> skip;
%% 									  _ -> 
%% %% 										  ?log("Scene id = ~p kicked->del",[Id]),
%% 										  ets:insert(scene,Scene#scene{status = del,status_time = Now})
%% 								  end;
%% 							  true  ->
%% 								  if
%% 									  Now - Stime > 5 * 1000 -> 
%% %% 										  ?log("Scene id = ~p kicked->del2",[Id]),
%% 										  ets:insert(scene,Scene#scene{status = del,status_time = Now});
%% 									  true -> skip
%% 								  end
%% 						  end;
%% 					  del -> 
%% 						  if
%% 							  Now - Stime > 1 * 1000 -> 
%% 								  server_tools:send_to_scene(SceneHid, stop);							  
%% 							  true -> skip
%% 						  end;
%% 					  _ -> skip
%% 				  end
%% 		  end,
%% 	SceneList = ets:match_object(scene, #scene{_ = '_'}),
%% 	lists:foreach(Fun, SceneList),
%% 	?SCENE_RUN_ON_TIME.


req_create_scene(Key,UsrInfoList,Scene,SceneData) ->
	?debug("req_create_scene,~p",[Scene]),
	Scenesvrs = ets:match_object(scene_svr, #scene_svr{_ = '_'}),
	case get_best(Scenesvrs,no) of
		no ->  ?log_error("scene create error Scenesvrs = ~p",[Scenesvrs]);
		{ok,ScenesvrHid,_} -> server_tools:send_to_scene_ctr(ScenesvrHid, {req_create_scene,{Key,UsrInfoList,Scene,SceneData}})
	end.


get_best([],R) -> R;
get_best([This|Next],no) -> 
	if
		This#scene_svr.scene < This#scene_svr.max_scene -> get_best(Next,{ok,This#scene_svr.pid,{This#scene_svr.scene,This#scene_svr.max_scene}});
		true -> get_best(Next,no)
	end;
get_best([This|Next],{ok,OldHid,{OldScene,OldMaxScene}}) -> 
	if
		This#scene_svr.scene < This#scene_svr.max_scene -> 
			if
				This#scene_svr.scene < OldScene -> get_best(Next,{ok,This#scene_svr.pid,{This#scene_svr.scene,This#scene_svr.max_scene}});
				true -> get_best(Next,{ok,OldHid,{OldScene,OldMaxScene}})
			end;
		true -> {ok,OldHid,{OldScene,OldMaxScene}}
	end.

get_best_scene([],_Num,_Max,R) -> R;
get_best_scene([This | Next],Num,Max,no) -> 
	if
		This#scene.num < Max -> get_best_scene(Next,Num,Max,{This,This#scene.num});
		true -> get_best_scene(Next,Num,Max,no)
	end;
get_best_scene([This | Next],Num,Max,{Old,OldNum}) ->
	if
		This#scene.num  < Max -> 
			if
				OldNum < This#scene.num -> get_best_scene(Next,Num,Max,{This,This#scene.num});
				true ->  get_best_scene(Next,Num,Max,{Old,OldNum})
			end;
		true -> get_best_scene(Next,Num,Max,{Old,OldNum})
	end.

can_del(MyList,Id)->
	DeList = lists:keydelete(Id, #scene.id, MyList),
	find_can(DeList).

find_can([]) -> false;
find_can([#scene{status = del,num = 0} | _Next]) -> false;
find_can([#scene{status = _Status,num = 0} | _Next]) -> true;
find_can([_This | Next]) -> find_can(Next).

is_scene_exist(Id) ->
	case ets:lookup(scene, Id) of
		[_Scene] -> true;
		_ -> false
	end.

broadcast_scene_msg(Msg) ->
	SceneList = ets:match_object(scene, #scene{_ = '_'}),
	lists:foreach(fun(#scene{pid=ScenePid}) -> server_tools:send_to_scene(ScenePid, Msg) end, SceneList).
broadcast_scene_msg(Msg, SceneType) ->
	SceneList = ets:match_object(scene, #scene{type=SceneType, _ = '_'}),
	lists:foreach(fun(#scene{pid=ScenePid}) -> server_tools:send_to_scene(ScenePid, Msg) end, SceneList).
