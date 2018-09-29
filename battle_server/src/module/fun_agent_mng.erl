-module(fun_agent_mng).

-include("common.hrl").

-export([do_init/0,do_close/0,do_call/1,do_info/1,do_time/1,do_msg/1,start_fly/3,force_kick_usr/2,on_online_report_timer/0]).
-export([agent_msg_by_uid/2,scene_msg_by_uid/2,agent_call_by_uid/2, scene_call_by_uid/2]).

-record(agent_svr, {idx = 0, pid =0,maxagent=0,agent=0}).


do_init()-> 
	?debug("fun_agent_mng init"),
%% 	init_agent_svr_info(),
%% 	fun_copy_id:init(),
%%  	fun_guild:init(),
%%  	fun_activity_mng:init(),
%% 	fun_recharge:init(),
%% 	ativity_new_mng:init(),
%% 	fun_relation_ex:init_relation(), 	
%% 	init_server_start_time(),
%% 	init_online_report_timer(),
%% 	fun_reconnect_mng:init(),	
%% 	activity_guild_battle:init(),	
%% 	fun_ban:init(),
	put(init_status, true).
	
  

process_pt(pt_team_ans_ask_d025,Seq,Pt,Sid,Uid) -> 
	?debug("get team_ans_ask Pt = ~p,Sid = ~p,uid=~p",[Pt,Sid,Uid]),
	Leader = Pt#pt_team_ans_ask.ans_uid, 
	Ans = case Pt#pt_team_ans_ask.ans of
			  0 -> false;
			  _ -> true
		  end,
	fun_team:proc_pt_ask_ans(Uid, Leader, Ans, Seq);

process_pt(pt_req_ranklist_d600,Seq,Pt,Sid,Uid) ->
	fun_ranklist:show_ranklist(Sid,Uid,Seq,Pt#pt_req_ranklist.type,Pt#pt_req_ranklist.page);
process_pt(pt_req_shelve_items_d549,Seq,Pt,Sid,Uid) ->
	fun_market:do_msg({req_shelve_items, Uid, Sid, Pt#pt_req_shelve_items.sort, Pt#pt_req_shelve_items.lev,
					   Pt#pt_req_shelve_items.color, Pt#pt_req_shelve_items.currency,
					   Pt#pt_req_shelve_items.prof, Pt#pt_req_shelve_items.index, Pt#pt_req_shelve_items.page,Seq});
process_pt(pt_req_buy_shelve_item_d551,Seq,Pt,_Sid,Uid) ->
	fun_market:do_msg({buy_shelve_item, Uid, Pt#pt_req_buy_shelve_item.id, Pt#pt_req_buy_shelve_item.num, Seq});
process_pt(pt_req_dump_shelve_item_d552,Seq,Pt,_Sid,Uid) ->
	fun_market:do_msg({dump_shelve_item, Uid, Pt#pt_req_dump_shelve_item.id, Seq});
process_pt(pt_req_get_my_shelve_item_info_d553,Seq,_Pt,Sid,Uid) ->
	fun_market:do_msg({req_my_shelve_items, Uid,Sid,Seq});
process_pt(pt_req_order_da00,Seq,Pt,Sid,Uid) ->
	fun_recharge:req_order(Sid, Uid, Pt#pt_req_order.type, Seq);
process_pt(pt_req_guild_liveness_info_d50d,Seq,_Pt,Sid,Uid) ->
	fun_guild:req_guild_liveness_info(Uid, Sid, Seq);
process_pt(PtName,_Seq,_Pt,_Sid,_Uid) ->
	?log_warning("unprocessed proto:~p",[PtName]).


do_close() -> ok.

do_time(_Time) ->ok.


do_call({agent_ctr_start, {Idx,Pid,MaxAgent}}) ->
	?debug("agent_ctr_start,idx=~p,pid=~p,max_agent=~p",[Idx,Pid,MaxAgent]),
	set_agent_svr_info(#agent_svr{idx=Idx,pid=Pid,maxagent=MaxAgent,agent=0}),
	erlang:monitor(process, Pid),
	ok;
%% do_call({agent_ctr_close, Idx}) ->
%%   	?debug("agent_ctr_close,idx=~p", [Idx]),
%% 	del_agent_svr_info(Idx),
%% 	ok;
do_call({shutdown}) ->
	?debug("call ...............shutdown"),
	fun_gateway_mng:shutdown();
%% 	fun_ranklist:sync_all();
do_call({check_init}) ->
	case get(init_status) of
		true -> true;
		_ -> false
	end;
do_call(_Msg) -> ok.

do_info({timeout, TimerRef, {xtimer_callback, Arg}}) ->
	try
		xtimer:on_timer(TimerRef, Arg)
	catch E:R ->?log_error("timeout error,data=~p,E=~p,R=~p,stack=~p",[Arg,E,R,erlang:get_stacktrace()])
	end;
do_info({'DOWN', _MonitorRef, process, Pid, Info}) ->
	?log_warning("process down,pid=~p,info=~p",[Pid,Info]),
	case match_agent_svr_info(#agent_svr{pid=Pid,_ = '_'}) of
		[#agent_svr{idx=Idx,agent=CurNum}] ->
			?log_warning("agent_ctr down,idx=~p,pid=~p,num=~p",[Idx,Pid,CurNum]),
			del_agent_svr_info(Idx),
			do_msg({kick_usr_by_agent_index, Idx});
		_ -> skip
	end;
do_info(_Info) ->
	?debug("unknown info,info=~p",[_Info]),
	ok.


%% do_msg({agent_ctr_start, {Idx,Pid,MaxAgent}}) ->
%% 	?debug("agent_ctr_start,idx=~p,pid=~p,max_agent=~p",[Idx,Pid,MaxAgent]),
%% 	set_agent_svr_info(#agent_svr{idx=Idx,pid=Pid,maxagent=MaxAgent,agent=0});	
do_msg({get_new_activity_info,Sid,CheckList})->
	fun_activity_new:send_new_activity_info(Sid,CheckList);
do_msg({check_chanel_mail,Uid})->
	fun_mail:on_login(Uid);
do_msg({ancient_update_damage,Uid,Data,KillBoss})->
	?debug("ancient_update_damage=~p",[{Data,KillBoss}]),
	fun_ancient_battlefield:update_ancient_dmg(Uid, Data,KillBoss);
do_msg({ancient_end,Uid,Status,Scene})->		
	fun_ancient_battlefield:ancient_end(Uid,Status,Scene);
do_msg({ancient_start,Uid,Msg,Sta,Diff,Scene})->	
	fun_ancient_battlefield:init_dmg(Uid,Msg,Sta,Diff,Scene);
do_msg({update_guild_battle_info,Guild_id,_Name,Integer})->
	activity_guild_battle:update_guild_battle_data(Guild_id, Integer);
do_msg({set_battle_start,T1,T2,T3})->
	activity_guild_battle:gm_set_battle_time(T1, T2, T3);
do_msg({set_battle_start})->
	activity_guild_battle:on_activity_start();
do_msg({end_fisrt_battle})-> 
	activity_guild_battle:first_battle_end();
do_msg({end_final_battle})->
	activity_guild_battle:on_activity_end(12);

do_msg({send_battle_end_time,Uid,Scene_Pid})->
	activity_guild_battle:send_battle_end_time(Uid,Scene_Pid);
	
do_msg({get_chat,Uid,Type,Content,Target_Name,Data,Seq})->
	fun_chat:get_chat(Uid, Type, Content, Target_Name, Data, Seq);
do_msg({update_last_login_time,Uid})->
	fun_guild:update_last_login_time(Uid);
do_msg({send_mail,Uid,Sid,Seq,Title,Content,R_name}) ->
	fun_mail:req_send_mail(Uid, Sid, R_name, Seq, Title, Content, ?PERSONAL_MAIL, []);
do_msg({agree_join_guild,Uid,Sid,Seq,Uid_list,Action}) ->
	fun_guild:agree_join_guild(Uid_list, Uid, Sid, Seq,Action);
do_msg({treasure,Uid,Sid,Seq,Type_list}) ->
	 fun_treasurehouse:check_record(Uid, Type_list,Sid, Seq);
do_msg({req_treasure_record,Uid,Sid,Seq}) ->
fun_treasurehouse:req_treasure_record(Uid, Sid, Seq);

do_msg({req_guild_battle_index,Sid,Seq})->
	activity_guild_battle:get_guild_battle_index(Sid, Seq);
do_msg({req_guild_battle_info,_Uid,Sid,Index,Seq})->
	activity_guild_battle:get_guild_battle_info(Index, Sid, Seq);
do_msg({req_enter_guild_battle,Uid,_Seq,Sid})->
	case activity_guild_battle:check_can_enter_copy(Uid,Sid) of
		{true,Copy_id,Pos}->
			do_msg({common_copy_fly, Copy_id, [{Uid,Pos}], ?ACT_SCENE_GUILD_BATTLE});
		_->skip
	end;

do_msg({req_enter_companion_copy,Uid,Pos,Scene,Copy_id})->
	do_msg({common_copy_fly, Copy_id, [{Uid,Pos}], Scene});

do_msg({refresh_contribute,Uid})->
	fun_guild:auth_update_member(Uid);
do_msg({guild_store_item,Uid,Item,Sid, Seq})->
	fun_guild:guild_store_item(Uid, Item, Sid, Seq);
do_msg({get_mail_items,Uid,Sid,Seq,ID_list})->
		fun_mail:client_req_get_mail_item(Uid, Sid, Seq, ID_list);

do_msg({req_join_guild,Uid,Sid,Seq,ID_list,Fight}) ->
	fun_guild:req_join_guild(ID_list, Uid, Sid, Seq,Fight);
do_msg({agent_req_del_mail,Uid,Sid,Seq,ID_list}) ->
	fun_mail:agent_req_del_mail(Uid, Sid, ID_list, Seq);
do_msg({req_kick_guild_member,Target_id,Uid,Sid,Seq}) ->
	fun_guild:kick_member(Uid, Target_id, Sid, Seq); 
do_msg({leader_req_change_guild_purpose,Uid,Sid,Seq,Purpose}) ->
	fun_guild:req_change_purpose(Uid, Purpose, Sid, Seq);
do_msg({req_guild_items_log,Uid,Sid,Seq,Page}) ->
	fun_guild:req_guild_item_log(Uid, Sid, Seq,Page);
do_msg({normal_member_req_check_out_guild_item,Uid,Sid,Seq,Item_id}) ->
	fun_guild:nomal_member_req_get_check_out_item(Uid, Item_id, Sid, Seq);
do_msg({leader_req_clear_guild_items,Uid,Sid,Seq}) ->
		fun_guild:leader_req_clear_guild_items(Uid, Sid, Seq);
do_msg({leader_req_check_out_item_action,Uid,Sid,Target_id,Item_id,Action,Seq}) ->
	fun_guild:leader_req_check_access_strore_action(Uid, Target_id,Item_id, Action,Sid,Seq);
do_msg({leader_req_guild_item_action_ask_list,Uid,Sid,Seq}) ->
	fun_guild:leader_req_guild_store_req_list(Uid, Sid, Seq);
do_msg({leader_req_clear_ask_join_guild_list,Uid,Sid,Seq}) ->
	fun_guild:leader_req_clear_join_list(Uid, Sid, Seq);
do_msg({req_add_all_receive_state,Uid,Sid,Seq,Fight,Open_state}) ->
	fun_guild:leader_req_add_receive_all_member(Uid, Sid, Seq,Fight,Open_state);  
do_msg({req_guild_skill_update,Skill_id,Uid,Sid,Seq}) -> 
	fun_guild:update_guild_skill(Uid, Sid, Skill_id, Seq);
do_msg({req_guild_contribute_info,Uid,Sid,Seq}) -> 
	fun_guild:req_guild_contribute_info(Uid, Sid, Seq);
do_msg({guild_contribute,Uid,Sid,Seq,Type,NeedItems,RewardItems}) ->
	fun_guild:guild_contribute(Uid, Sid, Seq, Type, NeedItems, RewardItems);
do_msg({guild_liveness_task_finish,Uid,LivenessAdd}) ->
	fun_guild:liveness_task_finish(Uid,LivenessAdd);

do_msg({req_guild_skill,Uid,Sid,Seq}) ->
	fun_guild:req_guild_skill(Uid, Sid, Seq);
do_msg({req_change_guild_member,Target_id,Pos,Uid,Sid,Seq}) ->
	fun_guild:req_change_member(Uid, Sid, Target_id, Pos, Sid, Seq);
do_msg({receive_mail,Uid,Sid,Seq}) ->
	fun_mail:agent_req_receive_mails(Uid, Sid, Seq);
do_msg({read_mail,Uid,Sid,ID,Seq}) ->
	fun_mail:client_req_read_mail(Uid, Sid, ID, Seq);
 do_msg({req_guild_log,Uid, Sid, Seq, Page}) ->
	fun_guild:req_guild_log(Uid, Sid, Seq, Page);
 do_msg({req_quilt_guild,Uid, Sid, Seq}) ->
	fun_guild:req_quit_guid(Uid, Sid, Seq);
 do_msg({req_join_list,Uid,Sid,Seq}) ->
fun_guild:req_join_list(Uid, Sid, Seq);
 do_msg({req_guild_list,Page,Uid, Sid, Seq}) -> 
		fun_guild:req_guild_list(Page,Uid, Sid, Seq);

do_msg({agent_ctr_close, Idx}) ->
	?debug("agent_ctr_close,idx=~p", [Idx]),
	del_agent_svr_info(Idx);
do_msg({process_pt, PtModule, Seq, Pt, Sid, Uid}) ->
	process_pt(PtModule,Seq,Pt,Sid,Uid);
do_msg({let_it_in, Sid,Ip,Seq,Aid,Uid,Args}) ->
	?debug("fun_agent_mng let_it_in Aid=~p,Uid=~p",[Aid,Uid]),
	Agentsvrs = match_agent_svr_info(#agent_svr{_ = '_'}),
	case get_best(Agentsvrs,no) of
		 {ok,AgentCentHid,_} -> 
			?debug("find ctr = ~p",[AgentCentHid]),
			server_tools:send_to_agent_ctr(AgentCentHid, {let_it_in, Sid,Ip,Seq,Aid,Uid,Args});
		R -> 
			?log_trace("fun_agent_mng let_it_in no game,get_best:R=~p~n",[R]),			
			?discon(Sid,nogame,0)
	end;
do_msg({get_guild_package_info,Uid, Sid, Seq})->
	fun_guild:req_get_guild_package_info(Uid, Sid, Seq);
do_msg({req_guild_salary,Uid, Sid, Seq})->
		fun_guild:req_guild_salary(Uid, Sid, Seq);
do_msg({create_guild,Uid,_Figtht_Score,Sid,Seq,Name,Purpose,Type})->
			fun_guild:create_guild(Uid, Sid, Name, Seq, Purpose, Type); 
do_msg({req_guild_info,Uid,Sid,Seq})->
			fun_guild:req_guild_info(Uid, Sid, Seq);
do_msg({req_guild_member_info,Uid,Sid,Seq})->
			fun_guild:req_guild_member_info(Uid, Sid, Seq);
do_msg({req_move_guild_item,Uid,Sid,Item_id,Action,Seq})-> 
			fun_guild:req_move_item(Uid, Item_id, Seq, Sid, Action);
do_msg({agent_in,Usr,Sid,Ip,InitData,AgentHid,AgentIndex,GatewayIndex}) ->ok;
%% 	?debug("agent_in uid=~p",[Usr#usr.id]),
%% 	case db:dirty_get(ply, Usr#usr.id) of
%% 		[OldPly=#ply{}] ->
%% 			?log_warning("agent_in player already exist,ply=~p,",[OldPly]);
%% 		_ -> skip
%% 	end,
%% 	db:dirty_put(#ply{uid=Usr#usr.id, aid=Usr#usr.acc_id, sid=Sid, name=Usr#usr.name,
%% 					  lev=Usr#usr.lev, ip=Ip, agent_pid=AgentHid,agent_idx=AgentIndex,
%% 					  gateway_index=GatewayIndex,fight_score=InitData#agent_init_data.fight_score}),
%% 	case get_agent_svr_info(AgentIndex) of
%% 		[Agentsvr = #agent_svr{agent = Cur}] ->
%% 			set_agent_svr_info(Agentsvr#agent_svr{agent = Cur + 1});
%% 		_ -> skip
%% 	end,
%% 	fun_recharge:on_login(Usr#usr.id);
%% 	fun_ranklist:on_login(Usr#usr.id),
%% 	fun_mail:on_login(Usr#usr.id),
%% 	fun_title:on_login(Usr#usr.id),
%% 	put(max_ply_num, max(get(max_ply_num), length(db:dirty_match(ply, #ply{_='_'})))),
%% 	case db:dirty_get(account, Usr#usr.acc_id) of
%% 		[#account{username=AccName,source_id=SourceId}] ->
%% 			fun_plat_interface_gms:report(?GMS_EVT_LOGIN, {AccName,Usr#usr.id,Usr#usr.name,SourceId,Ip});
%% 		_ -> skip
%% 	end;

do_msg({agent_out, Uid, AgentPid}) ->	ok;
%% 	?debug("agent_out uid=~p",[Uid]),
%% 	case db:dirty_get(ply,Uid) of
%% 		[Ply] -> 
%% %% 			fun_reconnect_mng:on_logout(Ply),
%% %% 			fun_guild:delet_guild_ask_record(Uid),
%% 			case get_agent_svr_info(Ply#ply.agent_idx) of
%% 				[Agentsvr = #agent_svr{agent = Cur}] when Cur > 0 ->
%% 					set_agent_svr_info(Agentsvr#agent_svr{agent = Cur - 1});
%% 				_ -> skip
%% 			end,
%% 			if
%% 				is_pid(Ply#ply.scene_pid) -> server_tools:send_to_scene(Ply#ply.scene_pid, {agent_out, Uid});
%% 				true ->
%% 					?debug("agent_out no scene,uid=~p",[Uid]),
%% 					server_tools:send_to_agent(Ply#ply.agent_pid, agent_out_complete)
%% 			end,
%% 			db:dirty_del(ply,Uid),
%% 			fun_ancient_battlefield:ancient_end(Uid,1,Ply#ply.scene_type),
%% 			server_tools:send_to_offline_agent_mng({agent_out, Uid}),
%% 			case db:dirty_get(account, Ply#ply.aid) of
%% 				[#account{username=AccName,source_id=SourceId}] ->
%% 					case db:dirty_get(usr, Ply#ply.uid) of
%% 						[#usr{last_login_time=LastLoginTime}]->
%% 							fun_plat_interface_gms:report(?GMS_EVT_LOGOUT, {AccName,Uid,Ply#ply.name,SourceId,Ply#ply.ip,LastLoginTime});
%% 						_->skip
%% 					end;
%% 				_ -> skip
%% 			end;
%% 		_ ->
%% 			?log_warning("agent out no ply,uid=~p",[Uid]),
%% 			case is_pid(AgentPid) of
%% 				true ->
%% 					server_tools:send_to_agent(AgentPid, agent_out_complete);
%% 				_ -> skip
%% 			end
%% 	end;
%% do_msg({kick_usr_by_gateway_index, Index}) ->ok;
%% 	lists:foreach(
%% 		fun(#ply{uid=Uid}) ->
%% 			force_kick_usr(Uid, gateway_down)
%% 		end, db:dirty_match(ply, #ply{gateway_index=Index, _='_'}));

do_msg({kick_usr_by_agent_index, Index}) ->
	lists:foreach(
		fun(#ply{uid=Uid}) ->
			force_kick_usr(Uid, agent_ctr_down)
		end, db:dirty_match(ply, #ply{agent_idx=Index, _='_'}));

do_msg({kick_usr_by_scene_index, Index}) ->
	lists:foreach(
		fun(#ply{uid=Uid}) ->
			force_kick_usr(Uid, scene_ctr_down)
		end, db:dirty_match(ply, #ply{scene_idx=Index, _='_'}));

do_msg({fly_on_login, Uid, Seq, {DefaultScene,DefaultPos}}) ->
	do_msg({fly, 0, Uid, Seq, {DefaultScene,DefaultPos}});
%% 	case fun_reconnect_mng:get_reconnect_info(Uid) of
%% 		{ok, {SceneId,_Scene,Pos}} ->
%% 			case fun_scene_mng:is_scene_exist(SceneId) of
%% 				true -> do_msg({fly_by_scene_id, 0, Uid, Seq, {SceneId,Pos}});
%% 				_ -> do_msg({fly, 0, Uid, Seq, {DefaultScene,DefaultPos}})
%% 			end;do_msg({fly, 0, Uid, Seq, {DefaultScene,DefaultPos}})
%% 		_ ->?log("fly.............."), 
%% 	end;
%%其他进程要求某个玩家飞到制定场景,用于登陆，玩家切换场景等
do_msg({fly_by_scene_id, _Sid,Uid,Seq, {SceneId,Pos}}) ->
	start_fly([{Uid,Seq,Pos,{ply_scene_data}}],{id,SceneId},[]);
do_msg({fly, _Sid,Uid,Seq, {Scene,Pos}}) ->
	start_fly([{Uid,Seq,Pos,{ply_scene_data}}],Scene,[]);
do_msg({fly, _Sid,Uid,Seq, {Scene,Pos}, CreateArgs}) ->
	start_fly([{Uid,Seq,Pos,{ply_scene_data}}],Scene,CreateArgs);
%%队伍副本
do_msg({team_fly, TeamId, UserInfoList, Scene}) ->
	do_msg({team_fly, TeamId, UserInfoList, Scene, []});
do_msg({team_fly, TeamId, UserInfoList, Scene, CreateArgs}) ->
	InfoList = [{Uid,0,Pos,no} || {Uid,Pos} <- UserInfoList],
	start_fly(InfoList, Scene, [{owner, {team, TeamId}}|CreateArgs]);
%%公会副本
do_msg({guild_fly, GuildId, UserInfoList, Scene}) ->
	do_msg({guild_fly, GuildId, UserInfoList, Scene, []});
do_msg({guild_fly, GuildId, UserInfoList, Scene, CreateArgs}) ->
	InfoList = [{Uid,0,Pos,no} || {Uid,Pos} <- UserInfoList],
	start_fly(InfoList, Scene, [{owner, {guild, GuildId}}|CreateArgs]);
%%通用多人副本,不同副本的CopyId由调用者来保证唯一�
do_msg({common_copy_fly, CopyId, UserInfoList, Scene}) ->
	do_msg({common_copy_fly, CopyId, UserInfoList, Scene, []});
do_msg({common_copy_fly, CopyId, UserInfoList, Scene, CreateArgs}) ->
	InfoList = [{Uid,0,Pos,no} || {Uid,Pos} <- UserInfoList],
	start_fly(InfoList, Scene, [{owner, {common_copy, CopyId}}|CreateArgs]);

%%场景管理发来通知，场景已经准备好，让需求的人进去吧,同时清除掉原来场景的
%% do_msg({ask_usrs_to_start_fly, UsrInfoList,{NeedUid,NeedSeq},Scene,SceneId}) ->
do_msg({ask_usrs_to_start_fly, UsrInfoList,Scene,SceneId}) ->  
	?debug("ask_usrs_to_start_fly UsrInfoList= ~p~n",[UsrInfoList]),
	Fun = fun({Uid,Seq,Pos,_PlyData}) -> 
				  case db:dirty_get(ply, Uid) of
					  [Ply = #ply{sid = Sid,agent_pid = AgentHid,scene_pid = SceneHid} | _] -> 
						  if
							  is_pid(SceneHid) -> server_tools:send_to_scene(SceneHid, {usr_leave_scene, Uid});
							  true -> skip
						  end,
						  db:dirty_put(Ply#ply{scene_pid=0,scene_idx = 0,scene_id=0}),
						  server_tools:send_to_agent(AgentHid, {start_fly, Sid,Uid,Seq,SceneId,{Scene,Pos}});
%% 						  if
%% 							  Uid == NeedUid -> gen_server:cast(AgentHid, {start_fly, Sid,Uid,Seq, SceneId,{Scene,Pos}});
%% 							  true -> gen_server:cast(AgentHid, {start_fly, Sid,Uid,Seq, SceneId,{Scene,Pos}})
%% 						  end;
					  _ -> skip
				  end						  
		  end,
	lists:foreach(Fun, UsrInfoList);
do_msg({on_scene_created, _SceneID, ScenePid, SceneType}) ->
	fun_activity_mng:on_scene_created(ScenePid, SceneType);
do_msg({usr_in_scene,Uid,SceneId,SceneType,SceneHid,SceneIdx}) ->
	?debug("usr_in_scene uid=~p,SceneId=~p,SceneHid=~p,SceneType=~p",[Uid,SceneId,SceneHid,SceneType]),
	case db:dirty_get(ply, Uid) of
		[Ply | _] -> 
			db:dirty_put(Ply#ply{scene_pid=SceneHid,scene_idx = SceneIdx,scene_id=SceneId,scene_type=SceneType});
		_ -> skip
	end;
do_msg({usr_out_scene,Uid,SceneId}) ->	
	?debug("usr_out_scene uid=~p,SceneId=~p",[Uid,SceneId]),
	case db:dirty_get(ply, Uid) of
		[Ply = #ply{scene_id=SceneId} | _] -> 
			db:dirty_put(Ply#ply{scene_pid=0,scene_idx = 0,scene_id=0});
		_ -> skip
	end;

do_msg({req_team,Sid,Uid,Seq,State,Data}) ->ok;
%%     case State of
%% 		?ACTION_TEAM_ASK ->
%% 						   case util:get_usr_online(Data) of
%% 							   ?STATE_OFFLINE -> ?error_report(Sid,"lixian_zudui",Seq);
%% 							   _ ->fun_team:proc_pt_ask_enter_team(Uid,Data,Seq)
%% 						   end;
%% 		?ACTION_TEAM_REQ -> fun_team:proc_pt_req_enter_team_by_member(Uid,Data,Seq);
%% 		?ACTION_TEAM_QUIT ->fun_team:proc_pt_quit_team(Uid, Seq);
%% 		?ACTION_TEAM_LEADER_CHG -> fun_team:proc_pt_team_leader_change(Uid,Data,Seq);
%% 		?ACTION_TEAM_KICK_USR->fun_team:proc_pt_team_kick_usr(Uid,Sid,Seq,Data);
%% 		?ACTION_TEAM_DISSOLVE->fun_team:proc_pt_dissolve_team(Uid,Sid,Seq);	
%% 		_ -> skip
%% 	end;

do_msg({req_single_team,Uid}) ->
	fun_team:req_single_team(Uid);

do_msg({req_recruit_friend_team,Uid,Seq,Oth_uid}) ->
	fun_team:proc_pt_ask_enter_team(Uid,Oth_uid,Seq,?ACTION_TEAM_RECRUIT_FRIEND);
     
do_msg({get_off_lin_chat,Uid,Sid,Seq})->
	fun_chat:get_off_line_chat(Uid, Sid, Seq);

do_msg({check_team_length,Uid}) ->
	fun_team:check_team_length(Uid);

do_msg({ask_recruit_friend_reply,Uid,Seq,Leader,Ans_state}) ->ok;
%% 	if Ans_state == ?WORLD_RECRUIT ->
%% 		   fun_team:proc_pt_world_recruit_ans(Uid, Leader, Seq,?TRUE);
%% 	   true ->
%% 		   Ans = case Ans_state of
%% 					 0 -> false;
%% 					 _ -> true
%% 				 end,
%% 		   fun_team:proc_pt_ask_ans(Uid, Leader, Ans, Seq,?ACTION_RECRUIT_FRIEND_REPLY)
%% 	end;

do_msg({leader_req_world_recruit,Uid,Sid,Seq}) ->
	fun_team:leader_req_world_recruit(Uid,Sid,Seq);

do_msg({req_usr_arena_info,Uid,Sid,Seq}) ->
	fun_usr_arena:req_usr_arena_info(Uid,Sid,Seq);
	
do_msg({challenge_win_arena,Uid,Sid,Robot_Uid,CD_state}) ->
   fun_usr_arena:challenge_win_arena(Uid,Sid,Robot_Uid,CD_state);

do_msg({challenge_defeat_arena,Uid,Sid,Robot_Uid,CD_state}) ->
    fun_usr_arena:challenge_defeat_arena(Uid,Sid,Robot_Uid,CD_state);

do_msg({req_search_usr_info,Uid,Sid,Seq,Find_str}) ->
	fun_relation_ex:req_search_usr_info(Uid,Sid,Seq,Find_str);

do_msg({req_do_something_friend,Uid,Seq,State,Uid_list}) ->
	fun_relation_ex:req_do_something_friend(Uid,Seq,State,Uid_list);

do_msg({req_recommend_friend,Uid,Sid,Seq,State}) ->
	fun_relation_ex:req_recommend_friend(Uid,Sid,Seq,State);

do_msg({del_add_friend_when_time,Uid,FirstLogin}) ->
	fun_relation_ex:del_add_friend_when_time(Uid,FirstLogin);

do_msg({refresh_help_times,Uid}) ->
	fun_relation_ex:refresh_help_times(Uid);

do_msg({req_look_others_message,Uid,Sid,Seq,Others}) ->
	fun_relation_ex:check_look_others_relation(Uid,Sid,Seq,Others);

do_msg({check_friend_help_fight,Uid,Sid,Seq,MapId,Way,HeroIdList,OthId,Help_Hero}) ->
	fun_relation_ex:check_friend_help_fight(Uid,Sid,Seq,MapId,Way,HeroIdList,OthId,Help_Hero);

do_msg({updata_friends_hero_help,Uid,Others}) ->
	fun_relation_ex:updata_friends_hero_help(Uid,Others);

do_msg({updata_friend_help_hero_id,Uid,Help_Heroid}) ->
	fun_relation_ex:updata_friend_help_hero_id(Uid,Help_Heroid);

do_msg({updata_friend_help_hero_fight,Uid,Help_fight}) ->
	fun_relation_ex:updata_friend_help_hero_fight(Uid,Help_fight);

do_msg({req_lool_rank_usr,RequesterId,Seq,Req_Type,TargetId}) ->
	fun_usr_info:req_lool_rank_usr(RequesterId,Req_Type,TargetId,Seq);

do_msg({req_apply_budo,Uid,Sid,Seq}) ->
	activity_budo:req_apply_budo(Uid,Sid,Seq);

do_msg({budo_loser,Uid,Sid,Atk_Uid,Robot_State}) ->
	activity_budo:budo_loser(Uid,Sid,Atk_Uid,Robot_State);

do_msg({budo_win,Uid,Sid,Bekill_uid,Robot_State}) ->
	activity_budo:budo_win(Uid,Sid,Bekill_uid,Robot_State);

do_msg({budo_match_state,Uid,State}) ->
	activity_budo:put_budo_match_state(Uid,State);

do_msg({req_budo_page_info,Uid,Sid,Seq,Type}) ->
	activity_budo:req_budo_apply_or_log(Uid,Sid,Seq,Type);

do_msg({update_budo_state,Uid,Robot_Uid}) ->
	activity_budo:put_budo_state(Uid,Robot_Uid,0);

do_msg({update_usr_budo_state,Uid}) ->
	activity_budo:update_usr_budo_state(Uid,0);

do_msg({start_guild_cart_escort, GuildId, ScenePid}) ->
	activity_guild_cart_escort:start_cart_escort_in_agent_mng(GuildId, ScenePid);
do_msg({send_exploit_reward,Dict_list}) ->
	activity_fengshen_war:send_exploit_reward(Dict_list);

do_msg({start_fly_fengshen_copy,Uid,Sid}) ->
	activity_fengshen_war:start_fly_fengshen_copy(Uid,Sid);

do_msg({update_cart_escort_info, Uid, ScenePid}) ->
	activity_cart_escort:update_cart_escort_info(Uid, ScenePid);
do_msg({req_cart_pos, Uid, Seq}) ->
	activity_cart_escort:client_req_cart_pos(Uid,Seq);
do_msg({req_guild_cart_pos, Uid, Seq}) ->
	activity_guild_cart_escort:client_req_cart_pos(Uid,Seq);
do_msg({look_other_guild_bonfire,Uid,Sid,Seq}) ->
	activity_guild_bonfire:get_other_guild_bonfire(Uid,Sid,Seq);

do_msg({start_fly_guild_bonfire,Uid,Sid,Type, Val}) ->
	activity_guild_bonfire:start_fly_guild_bonfire(Uid, Sid, Type, Val);

do_msg({delete_usr_join_dict,Uid}) ->
	activity_guild_bonfire:delete_usr_join_dict(Uid);

%% do_msg({send_to_all_guild_member,Guild_id,New_Hp,Atkuid}) ->
%% 	activity_guild_bonfire:send_to_all_guild_member(Guild_id,New_Hp,Atkuid);

do_msg({add_exp_addition_to_member,Guild_id,Atk_Uid}) ->
	activity_guild_bonfire:add_exp_addition_to_atkmember(Guild_id,Atk_Uid);

do_msg({bonfire_timing_add_exp,Uidlist,Scenepid}) ->
	activity_guild_bonfire:bonfire_timing_add_exp(Uidlist,Scenepid);

do_msg({bonfire_check_join_usr,Uid,Scene}) ->
	activity_guild_bonfire:bonfire_check_join_usr(Uid,Scene);

do_msg({send_bonfire_info_to_client,Uid,Sid,My_Guild_id,Owner_guildid,Jingshi_hp}) ->
	activity_guild_bonfire:send_bonfire_info_to_client(Uid,Sid,My_Guild_id,Owner_guildid,Jingshi_hp);

do_msg({bonfire_game_over,Uid,Sid}) ->
	activity_guild_bonfire:bonfire_game_over(Uid,Sid);

do_msg({update_ranklist_guild_cart_escort, GuildId, Name, Score}) ->
	fun_ranklist:update_ranklist_guild_cart_escort(GuildId, Name, Score);
do_msg({init_agentmng_rank_dict,Uid}) ->
	activity_guild_guard:init_agentmng_rank_dict(Uid);

do_msg({guild_guard_game_over,Guild_id}) ->
	activity_guild_guard:guild_guard_game_over(Guild_id);

do_msg({update_ranklist_evil, Uid, Name, Times}) ->
	fun_ranklist:update_ranklist_evil(Uid, Name, Times);

do_msg({update_ranklist_hero, Uid, Name, Times}) ->
	fun_ranklist:update_ranklist_hero(Uid, Name, Times);

do_msg({update_ranklist_pet, Uid, Name, Fight_score}) ->
	fun_ranklist:update_ranklist_pet(Uid, Name, Fight_score);

do_msg({update_ranklist_mount, Uid, Name, New_Lev}) ->
	 fun_ranklist:update_ranklist_mount(Uid, Name,New_Lev);

do_msg({update_ranklist_endless, Uid, Name, Pass_id}) ->
	 fun_ranklist:update_ranklist_endless(Uid, Name,Pass_id);

do_msg({update_ranklist_wing, Uid, Name, Wing_ID,Lev}) ->
	 fun_ranklist:update_ranklist_wing(Uid, Name,Wing_ID,Lev);

do_msg({update_ranklist_arena, Uid, Name, Prof,Integral,Score}) ->
	 fun_ranklist:update_ranklist_arena(Uid, Name, Prof,Integral,Score);

do_msg({clear_usr_ranklits_info, Uid, Type}) ->
	fun_ranklist:remove_from_ranklist(Type, Uid);

do_msg({update_fight_score, Uid, Score}) ->
	case db:dirty_get(ply,Uid) of	
		[Ply] -> 
			db:dirty_put(Ply#ply{fight_score=Score}),
%% 			fun_ranklist:update_ranklist_score(Uid, Ply#ply.name, Score),
			fun_guild:update_guild_figth_score(Uid, Score);
		_ -> skip
	end;

do_msg({update_level, Uid, Level}) ->
	case db:dirty_get(ply,Uid) of	
		[Ply] -> 
			db:dirty_put(Ply#ply{lev=Level}),
%% 			fun_ranklist:update_ranklist_level(Uid, Ply#ply.name, Level),
			fun_guild:on_member_level_up(Uid, Level);
		_ -> skip
	end;

do_msg({update_friend_relation_lev, Uid, Level}) ->
	case db:dirty_get(ply,Uid) of	
		[_Ply] -> 
			fun_relation_ex:updata_friend_lev(Uid, Level);
		_ -> skip
	end;

do_msg({reply_reconnect_info, Uid, SceneId, ScenePid, SceneType, Pos}) ->
	fun_reconnect_mng:add_reconnect_info(Uid, SceneId, ScenePid, SceneType, Pos);
	
do_msg({timing_update_scene_rank,Guild_id,Dict_List}) ->
	activity_guild_guard:timing_update_scene_rank(Guild_id,Dict_List);

do_msg({guild_guard_win,Difficulty,Scene}) ->
	activity_guild_guard:guild_guard_win(Difficulty,Scene);

do_msg({guild_guard_defeat,Difficulty,Scene,Cur_wave_num}) ->
	activity_guild_guard:guild_guard_defeat(Difficulty,Scene,Cur_wave_num);

%% do_msg({update_guild_guard,Uid}) ->
%% 	activity_guild_guard:update_guild_guard_start(Uid);

do_msg({req_get_ranklist,Uid,Sid,Seq}) ->
	activity_guild_guard:req_get_ranklist(Uid,Sid,Seq);

do_msg({req_start_guild_guard,Uid,Sid,Seq,Type}) ->
	activity_guild_guard:req_start_guild_guard(Uid,Sid,Seq,Type);

do_msg({req_fly_guild_guard,Uid,Sid,Type}) ->
	activity_guild_guard:req_fly_guild_guard(Uid,Sid,Type);

do_msg({sync_guild_guard_start_time,Uid,Sid,Seq}) ->
	activity_guild_guard:sync_guild_guard_start_time(Uid,Sid,Seq);

do_msg({sync_guild_battle_time,Uid,Sid,Seq}) ->
	activity_guild_battle:login_sync_guild_battle_time(Uid,Sid,Seq);

do_msg({update_castellan,Win_Uid}) ->
	activity_guild_storm_city:update_castellan(Win_Uid);

do_msg({empty_storm_city_title}) ->
	fun_title:remove_server_same_type_title(?TITLE_STORM_CITY);

%% do_msg({guard_guild_win_update_castellan}) ->
%% 	activity_guild_storm_city:guard_guild_win_update_castellan();

do_msg({update_guild_tribute,Sid,Uid,Contribute,Seq}) ->
	if
		Contribute>0->
	
		fun_guild:update_tribute_for_add(Uid,Sid ,Contribute,Seq);
		true->
		fun_guild:update_tribute_for_reduce(Uid, Contribute)
	end;
do_msg({send_ui_info,Uid,Sid,Seq}) ->
	activity_guild_storm_city:send_ui_info(Uid,Sid,Seq);

do_msg({send_apply_list,Sid,Seq}) ->
	activity_guild_storm_city:send_apply_list(Sid,Seq);

do_msg({req_apply,Uid,Sid,Seq}) ->
	activity_guild_storm_city:req_apply(Uid,Sid,Seq);

do_msg({req_fly_guild_storm_city,Uid,Sid}) ->
	activity_guild_storm_city:req_fly_guild_storm_city(Uid,Sid);

do_msg({empty_apply_list}) ->
	activity_guild_storm_city:empty_apply_list();

do_msg({check_update_castellan}) ->
	activity_guild_storm_city:agentmng_check_update_castellan();

do_msg({check_can_add_title,Uid,Type,Amount}) ->
	fun_title:check_can_add_title(Uid,Type,Amount);

do_msg({req_title_list,Uid}) ->
	fun_title:req_title_list(Uid);

do_msg({market_msg, Msg}) ->
	fun_market:do_msg(Msg);

do_msg({update_monster_info, Type, KillTime}) ->
	fun_scene_monster:update_monster_info(Type, KillTime);

do_msg({req_guild_expand, Uid, Sid, Seq, Expand_Num, Guild_ID, Quick})->
	fun_guild:req_guild_expand(Uid, Sid, Guild_ID, Expand_Num, Quick, Seq);

do_msg({http_request, FromPid, Msg}) ->
	fun_http_handler:http_msg(FromPid, Msg);

do_msg({req_fly_snatch_soldier,Uid,Sid,Seq}) ->
	activity_snatch_soldier:req_fly_snatch_soldier(Uid,Sid,Seq);

do_msg({mountain_of_flames_init_camp,Uid,Sid,Seq,Scene_pid}) ->
	activity_mountain_of_flames:mountain_of_flames_init_camp(Uid,Sid,Seq,Scene_pid);
do_msg({lucky_wheel_update_reward, Uid, Seq, RewardList, NeedSycee}) ->
	fun_lucky_wheel:update_reward(Uid, Seq, RewardList, NeedSycee);

do_msg({req_fly_mountain_of_flames,Uid,Sid,Seq}) ->
	activity_mountain_of_flames:start_fly_mountain_of_flames(Uid,Sid,Seq);

do_msg({update_amount_score_to_agentmng,Sncen_UL}) ->
	activity_mountain_of_flames:update_amount_score_to_agentmng(Sncen_UL);

do_msg({update_amount_score,AtkCamp,Addscore}) ->
	activity_mountain_of_flames:update_amount_score(AtkCamp,Addscore);

do_msg({check_win_camp,ScenePid}) ->
	activity_mountain_of_flames:check_win_camp(ScenePid);

do_msg({leave_mountain_flames_put_Dict,Uid}) ->
	activity_mountain_of_flames:agent_out_put_dict(Uid);
do_msg({lucky_wheel_update_record, RecInfoList}) ->
	fun_lucky_wheel:update_record(RecInfoList);

do_msg({mountain_of_flames_reward,Uid,Reward}) ->
	activity_mountain_of_flames:mountain_flames_game_over_reward(Uid,Reward);
do_msg({update_ranklist_treasure, Uid, Name, Prof, Times}) ->
	fun_ranklist:update_ranklist_treasure(Uid, Name, Prof, Times);

do_msg({update_new_name,Uid,New_name,Old_Name}) ->
	update_new_name(Uid,New_name,Old_Name);

do_msg({ask_join_guild,Uid,Sid, Seq, Target_uid}) ->
	fun_guild:ask_join_guild(Uid,Sid, Seq, Target_uid);

do_msg({ask_join_guild_answer,Uid,Sid, Seq, Answer}) ->
	fun_guild:ask_join_guild_answer(Uid,Sid, Seq, Answer);

do_msg(_Msg) ->
	?log_warning("unknown msg,msg=~p",[_Msg]),
	ok.

init_agent_svr_info() ->
	ets:new(agent_svr, [set,public,named_table,{keypos, #agent_svr.idx}]).
get_agent_svr_info(Idx) ->
	ets:lookup(agent_svr, Idx).
match_agent_svr_info(Pat) ->
	ets:match_object(agent_svr, Pat).
set_agent_svr_info(Data) ->
	ets:insert(agent_svr, Data).
del_agent_svr_info(Idx) ->
	ets:delete(agent_svr, Idx).

get_best([],R) -> R;
get_best([This|Next],no) -> 
	if
		This#agent_svr.agent < This#agent_svr.maxagent -> get_best(Next,{ok,This#agent_svr.pid,{This#agent_svr.agent,This#agent_svr.maxagent}});
		true -> get_best(Next,no)
	end;
get_best([This|Next],{ok,OldHid,{OldAgent,OldMaxAgent}}) -> 
	if
		This#agent_svr.agent < This#agent_svr.maxagent -> 
			if
				This#agent_svr.agent < OldAgent -> get_best(Next,{ok,This#agent_svr.pid,{This#agent_svr.agent,This#agent_svr.maxagent}});
				true -> get_best(Next,{ok,OldHid,{OldAgent,OldMaxAgent}})
			end;
		true -> {ok,OldHid,{OldAgent,OldMaxAgent}}
	end.

start_fly(UsrInfoList,Scene,SceneData) ->
	?debug("start_fly data = ~p",[{UsrInfoList,Scene,SceneData}]),
	server_tools:send_to_scene_mng({start_fly, UsrInfoList,Scene,SceneData}).





agent_msg_by_uid(Uid, Msg) ->
	case db:dirty_get(ply,Uid) of	
		[#ply{agent_pid=Pid}] when is_pid(Pid) -> server_tools:send_to_agent(Pid, Msg);
			_R-> ?log("agent_msg_by_uid send failed,uid=~p,msg=~p",[Uid, Msg]), skip
	end.

scene_msg_by_uid(Uid,Msg)->
	case db:dirty_get(ply,Uid) of	
		[#ply{scene_pid=ScenePid}] when is_pid(ScenePid) -> server_tools:send_to_scene(ScenePid,Msg);
		_R-> ?log("scene_msg_by_uid send failed,uid=~p,msg=~p",[Uid, Msg]),skip
	end.

%% only for test
agent_call_by_uid(Uid,{M,F,A})->
	case db:dirty_get(ply,Uid) of	
		[#ply{agent_pid=Pid}] when is_pid(Pid) -> server_tools:apply_call(Pid, M, F, A);
		_R-> 
			?log("scenehid_exception data=~p",[_R]),
			{error, no_ply}
	end.

scene_call_by_uid(Uid,{M,F,A})->
	case db:dirty_get(ply,Uid) of	
		[#ply{scene_pid=ScenePid}] when is_pid(ScenePid) -> server_tools:apply_call(ScenePid, M, F, A);
		_R-> 
			?log("scenehid_exception data=~p",[_R]),
			{error, no_ply}
	end.

init_server_start_time() ->skip.
%% 	db:load_all(server_open),  
%% 	case db:dirty_match(server_open, #server_open{_ = '_'}) of
%% 		[]->db:insert(#server_open{start_time=util:unixtime()});
%% 		L when length(L) > 0 -> skip
%% 	end.


force_kick_usr(Uid, Reason) ->ok.
%% 	case db:dirty_get(ply, Uid) of
%% 		[#ply{agent_pid=AgentPid, sid=Sid, gateway_index=GwIdx}] ->
%% 			erlang:spawn(
%% 			  fun() ->
%% 					Ret = 
%% 					try
%% 						case server_tools:call_persist(Sid, {discon, Reason}, 1000, 1) of
%% 							ok -> true;
%% 							Other ->
%% 								?log_warning("call failed,ret=~p",[Other]),
%% 								false
%% 						end	
%% 					catch E:R ->
%% 						?log_error("force_kick error,E=~p,R=~p,sid=~p,uid=~p,agent_pid=~p",[E,R,Sid,Uid,AgentPid]),
%% 						false
%% 					end,
%% 					
%% 					case Ret of
%% 						true -> skip;
%% 						_ ->
%% 							%% gateway节点异常终止,尝试直接关闭agent
%% 							Ret1 = 
%% 							try
%% 								case server_tools:call_persist(AgentPid, gateway_tcp_closed, 1000, 1) of
%% 									ok -> true;
%% 									Other1 ->
%% 										?log_warning("call failed,ret=~p",[Other1]),
%% 										false
%% 								end	
%% 							catch E1:R1 ->
%% 								?log_error("on_close error,E=~p,R=~p,sid=~p,uid=~p,agent_pid=~p",[E1,R1,Sid,Uid,AgentPid]),
%% 								false
%% 							end,
%% 							case Ret1 of
%% 								true -> skip;
%% 								_ -> 
%% 									server_tools:send_to_login({gateway_tcp_closed, Sid}),
%% 									server_tools:send_to_agent_mng({agent_out, Uid, AgentPid})
%% 							end,
%% 							server_tools:send_to_login({gateway_conn_dec, GwIdx})
%% 					end
%% 			  end);
%% 		_ ->
%% 			server_tools:send_to_login({del_login_data_by_uid, Uid})
%% 	end.
				
init_online_report_timer() ->
	put(max_ply_num, 0),
	xtimer:start_timer_persist(300*1000, {?MODULE, on_online_report_timer}).

on_online_report_timer() ->ok.
%% 	fun_plat_interface_gms:report(?GMS_EVT_ONLINE, {length(db:dirty_match(ply, #ply{_='_'})), get(max_ply_num)}).

update_new_name(Uid,New_name,_Old_Name) ->ok.
%% 	case db:dirty_get(ply, Uid) of
%% 		[Ply = #ply{}|_]->
%% 			db:dirty_put(Ply#ply{name=util:to_binary(New_name)}),
%% 			case db:dirty_get(guild_member, Uid, #guild_member.uid) of
%% 				[GuildMember = #guild_member{position=Pos,guild_id=Guild_id}] ->
%% 					db:dirty_put(GuildMember#guild_member{name=util:to_binary(New_name)}),
%% 					if Pos == ?LEADER -> 
%% 						   case db:dirty_get(guild, Guild_id) of
%% 							   [Guild=#guild{}]->
%% 								   db:dirty_put(Guild#guild{leader_name=util:to_binary(New_name)});
%% 							   _ -> skip
%% 						   end;
%% 					   true -> skip
%% 					end;						
%% 				_->skip
%% 			end,           
%%             fun_relation_ex:updata_friend_info_change_name(Uid, New_name);
%% 		_ ->skip
%% 	end.

