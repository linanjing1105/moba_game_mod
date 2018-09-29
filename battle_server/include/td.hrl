-ifndef('__TD_H__').
-define('__TD_H__', true).
%%,pass_last_ref_time=0
-record(account,{id,username,password,platform}).
-record(usr,{id,acc_id = 0,name="",prof=0,exp=0,lev = 1,hp=1,mp= 1,can_use_bags=60,unlock_bags=0,init_bags=1,init_time=0,save_pos="",
			 vip_lev=0,fight_score=0,vip_exp=0,vip_reward="",xiu_wei_num=0,last_reset_time=0,keepsake_id=0,sla=0,justice=0,last_login_time=0,
			 white_name_kill_times=0,red_name_kill_times=0,reborn_num=0,ride_skin_lev=0,ride_skin_exp=0,pk_mode=1,create_time=0,
			 first_recharge_status=0,copy_amount=0}).
-record(item,{id,uid,type=0,num=0,pos=0,bind=0,get_way=0,get_time=0,bind_time=0,check_time=0,lev=0,color=0,break_state=0,star=0
			 ,equOne=0,equTwo=0,equThree=0,equFour=0,luck=0,strenthen_exp=0,gem_type="",recast_exp=0,guild_belong=0}).
-record(recast_property,{id=0,uid=0,equip_id=0,special_equ="",spare_Equone="",spare_Equtwo="",spare_Equthree="",
						spare_Equfour="",spare_Equfive="",
						 spare_Equsix="",spare_Equseven="",spare_Equeight=""}).
-record(resource_main,{id=0,uid=0,cash=0,binding_copper_coin=0,
						copper_coin=0,sycee=0,savvy=0,skill_point=0,repair=0,
						anima=0,xianqi=0,exploit=0,reputation=0,intergral=0,contribute=0}).
-record(normal_skill,{id=0,uid=0,skill_id=0,skill_lev=0}).
-record(usr_skill_list,{id=0,uid=0,skill_1=0,skill_2=0,skill_3=0,skill_4=0}).
-record(pet,{id=0,uid=0,pet_type=0,fight_state=0,aptitude=0,grow_up_lev=0,pet_name ="",tian_soul_num=0,di_soul_num=0,life_soul_num=0,
			 tian_soul=0,di_soul=0,life_soul=0,grow_up_exp=0,aptitude_exp=0}).
-record(magic_weapon,{id=0,uid=0,type=0,skill="",strenth_lev=0,strenth_star=0,
				strenth_exp=0,zhuling_lev=0,zhuling_star=0,zhuling_exp=0,active=0,equ=0}). 
-record(pet_skill,{id=0,pet_id=0,skill_id=0}).
-record(buff, {id,uid,type=0,power=0,time=0}).
-record(model_clothes,{id,uid,model_clothes_id=0,own_state=0,put_state=0,try_time=0}).   %%时装
-record(wing,{id=0,uid=0,wing_id=0,lev=0,exp=0,passivity_skill=0,put_state=0}).
-record(title, {id,uid=0,title_id=0,start_time=0,put_state=0,own_state=0}).
-record(usr_rides, {id=0, uid=0,ride_id=0,lev=0,ride_state=0,ride_own=0}).
-record(usr_rides_skin,{id=0,uid,skin_id=0,skin_state=0,start_time=0}).
-record(task,{id,uid=0,task_id=0,step=0,state=0,condition1=0,condition2=0,condition3=0,accept_time=0,task_sort=0}).
-record(rand_day_task,{id,pid=0,one=0,two=0,thr=0,fou=0,fiv=0,six=0,sev=0,eig=0,nin=0,ten=0}).
-record(wanted_task,{id=0,uid=0,star=0,wanted_num=0,reset_num=0,wanted_time=0,draw_rewards=0,double_exp=1,
									finish_task_id=""}).
-record(train_task,{id=0,uid=0,train_num=0,train_time=0}).
-record(mail,{id=0,type=0,send_uid=0,read_state=0,send_name="",receive_uid=0,send_time=0,text_type=0,system_args="",
							expire_time=0,item_ids="", title="", content="",resource_ids=""}).
-record(cast_soul,{id=0,uid=0,base_num1=0,base_num2=0,base_num3=0,base_num4=0,base_num5,advanced_num1=0,advanced_num2=0,advanced_num3=0,
				   advanced_num4=0,advanced_num5=0,last_reset_time=0}).
-record(endless_challenge_record,{id=0,uid=0,pass_id=0,star_num=0,pass_state=0,pass_time=0}).
-record(shop_record,{id=0,commodity_id=0,uid=0,num=0,get_way=0,action_time=0}).
-record(endless_star,{id=0,uid=0,chapter_id=0,star_id=0,state=0}).
-record(single_many_copy,{id=0,uid=0,copy_id=0,challenge_num=0,buy_num=0}).
-record(single_star,{id=0,uid=0,copy_type=0,star_num=0}).
-record(activity, {id,uid,act_id,cur_times=0,last_reset_time=0}).
-record(guild,{id,name="",purpose="",lev=0,member=0,exp=0,content="",leader_name="",receive_all_member=0,receive_fight=0,resource_add=0,
               guard_start=0,guard_start_copy=0,fresh_time=0}). 
-record(guild_member,{id,uid=0,name="",guild_id=0,position=0,tribute=0,all_tribute=0,skill_id1=0,skill_id2=0,
				skill_id3=0,skill_id4=0,skill_id5=0,skill_id6=0,skill_id7=0,get_salary=0,fight_score=0,add_coin=0,add_sycee=0,last_login_time=0}). 
-record(guild_event_log, {id, guild_id=0, event=0, arg="", time=0}).
-record(fly_up,{id,uid=0,fly_up_lev=0,xiu_xing_time=0,last_reset_time=0,sycee_buy_time=0}).
-record(usr_arena,{id,uid=0,integral=0,challenge_num=0,last_challenge_time=0,last_res_time=0,reward_state=0,reward_rank=0}). 
-record(arena_log,{id=0,uid=0,log_id=0,arg,last_challenge_time=0}).
-record(guild_item_log,{id,guild_id=0,uid=0,item_type=0,action=0,name=""}).
-record(keepsake,{id,uid=0,target_uid=0,target_name="",target_lev=0,target_prof=0,creat_time=0,type=0,lev=0,exp=0,marry_again=0,res_copy_num=0,target_res_copy_num=0}).
%% -record(boss_challenge,{id,boss_id=0,last_res_time=0,state=0,kill_uid=0}).
-record(seal_boss_challenge,{id=0,uid=0,boss_id=0,surplus_time=0,start_time=0,last_res_time=0,state=0}).
-record(relation,{id=0,uid=0,sort=0,relation_uid= 0,relation_name="",relation_lev=0,relation_prof=0,intimacy=0}).
-record(guild_battle_info,{id=0,battle_index=0,group_one="",group_two="",group_three="",champion_name="",guild_id_str="",open_state=0}).



%% 所有排行榜的结构，最后一个字段都必须是last_update_rank
-record(ranklist_score, {id,uid,name,value,last_update_rank}).
-record(ranklist_level, {id,uid,name,value,last_update_rank}).
-record(ranklist_pet, {id,uid,name,value,last_update_rank}).
-record(ranklist_mount, {id,uid,name,value,last_update_rank}).
-record(ranklist_endless, {id,uid,name,value,last_update_rank}).
-record(ranklist_guild, {id,guild_id,name,value1,value2,last_update_rank}).
-record(ranklist_wing, {id,uid,name,value1,value2,last_update_rank}).
-record(ranklist_flower_send, {id,uid,name,value,last_update_rank}).
-record(ranklist_flower_recv, {id,uid,name,value,last_update_rank}).
-record(ranklist_evil, {id,uid,name,value,last_update_rank}).
-record(ranklist_hero, {id,uid,name,value,last_update_rank}).
-record(ranklist_arena, {id,uid,name,prof,value1,value2,last_update_rank}).

-record(sworn_brother, {id,brother_one_id=0,brother_one_lev=0,one_prof=0,brother_one_name="", brother_two_id=0, two_prof=0,brother_two_lev=0,brother_two_name="",
					   						brother_three_id=0,brother_three_lev=0,three_prof=0,brother_three_name="",friendship_one_and_two=0,friendship_one_and_three=0,
											friendship_two_and_three=0,oath="",task_integer=0,fried_ship_lev=0,task="",
											brother_one_task="",brother_two_task="",brother_three_task=""}).
-record(sworn_brother_reward,{id,uid=0,sworn_brother_id=0,reward=""}).
-record(shelve,{id,uid=0,type=0,num=0,item_id=0,price=0,currency_type=0,expire_time=0}).
-record(quell_demon_pagoda,{id,uid=0,cur_tier=0,last_reset_time=0}).
-record(worship, {id,uid=0,last_reset_time=0}).
-record(worship_model, {id,uid=0,name="",prof=0,equips="",times=0}).
-record(storm_city_own,{id=0,guild_name,castellan=0}).
-record(storm_city_apply,{id=0,guild_id=0}).   %%公会报名
-record(storm_city_astrict,{id=0,uid=0,item_id=0,buy_num=0,last_ref_time=0}).
-record(everyday_reward,{id,uid,mask=0,reward_id=0,cur_day=0}).   %%新人奖励
-record(rand_box_reward,{id=0,uid=0,type=0}).
-record(vip_manager,{id=0,uid=0,vip_lev=0,copy_num="",cast_soul_num=0,reliveTime=0,dart_num=0,test_task=0}).
-record(recharge_record, {id,uid,total_amount=0,daily_amount=0,days=0,max_amount=0}).
-record(daily_recharge_record,{id,uid,day,amount}).
-record(offline_recharge_record, {id,uid,type}).
-record(login_reward,{id,uid=0,flag_normal=0,flag_vip=0}).
-record(usr_cd_key, {id=0, uid=0,type=0,num=0}).
-record(usr_flower,{id=0,uid=0,receive_flower=0,send_flower=0}).    
-record(lev_reward,{id=0,uid=0,get_reward_lev=0}).
-record(online_reward,{id ,uid,reward_id =0,start_time=0,last_ref_time=0}).     %%玩家在线奖励 
-record(achievement,{id,uid,achievement_id =0,num =0,reward_state=0}).    %%成就�
-record(liveness,{id=0,uid=0,liveness_id=0,condition=0,state=0}).

-record(operation_activity, {id,act_id,act_type,name,start_time,end_time,desc}).
-record(operation_activity_detail, {id,act_id,item_info,conditions,desc}).
-record(operation_activity_reward, {id,uid,detail_id,flag}).
-record(open_server_gift_activity, {id,act_id,start_time,end_time}).
-record(open_server_gift_ware, {id,act_id,name,item_type,orig_price,cur_price,max_buy_amount}).
-record(open_server_gift_buy_record, {id,uid,ware_id,amount}).
-record(new_function_open,{id,open_id,uid}).
-record(love_reward,{id,uid,num=0,stage=0,diamo=0,reward_id_str="",state=0}).
-record(weekcard_reward, {id,uid=0,type=0,rest_reward_times=0,last_reward_day=0,last_active_day=0}).

-define(Tabs,
		[
		 [account | record_info(fields, account)],
		 [usr | record_info(fields, usr)], 
		 [item | record_info(fields, item)], 
		 [resource_main | record_info(fields, resource_main)],
		 [normal_skill | record_info(fields, normal_skill)],
		 [usr_skill_list | record_info(fields, usr_skill_list)],
		 [pet | record_info(fields, pet)],
		 [pet_skill | record_info(fields, pet_skill)],
		 [buff | record_info(fields, buff)],
		 [model_clothes | record_info(fields, model_clothes)],
		 [wing | record_info(fields, wing)],  
		 [magic_weapon | record_info(fields, magic_weapon)],
		 [task | record_info(fields, task)],
		 [wanted_task | record_info(fields, wanted_task)],
		 [train_task | record_info(fields, train_task)],
		 [title | record_info(fields, title)],  
		 [usr_rides | record_info(fields, usr_rides)], 
		 [usr_rides_skin | record_info(fields, usr_rides_skin)], 
		 [mail | record_info(fields, mail)] ,
		 [cast_soul | record_info(fields, cast_soul)], 
		 [recast_property | record_info(fields, recast_property)],
		 [endless_challenge_record | record_info(fields, endless_challenge_record)],
		 [shop_record | record_info(fields, shop_record)],
		 [endless_star | record_info(fields, endless_star)],
		 [single_many_copy | record_info(fields, single_many_copy)],
		 [single_star | record_info(fields, single_star)],
		 [activity | record_info(fields, activity)],		 
		 [guild | record_info(fields, guild)],
		 [guild_member | record_info(fields, guild_member)],
		 [fly_up | record_info(fields, fly_up)],
		 [guild_event_log | record_info(fields, guild_event_log)],
		 [guild_item_log | record_info(fields, guild_item_log)],
		 [keepsake | record_info(fields, keepsake)],		 
		 [usr_arena | record_info(fields, usr_arena)],
		 [guild_event_log | record_info(fields, guild_event_log)],
		 [guild_item_log | record_info(fields, guild_item_log)],
		 [arena_log | record_info(fields, arena_log)],
		 [ranklist_score | record_info(fields, ranklist_score)],
		 [ranklist_level | record_info(fields, ranklist_level)],
		 [ranklist_pet | record_info(fields, ranklist_pet)],
		 [ranklist_mount | record_info(fields, ranklist_mount)],
		 [ranklist_endless | record_info(fields, ranklist_endless)],
		 [ranklist_guild | record_info(fields, ranklist_guild)],
		 [ranklist_wing | record_info(fields, ranklist_wing)],
		 [ranklist_flower_send | record_info(fields, ranklist_flower_send)],
		 [ranklist_flower_recv | record_info(fields, ranklist_flower_recv)],
		 [ranklist_evil | record_info(fields, ranklist_evil)],
		 [ranklist_hero | record_info(fields, ranklist_hero)],
		 [ranklist_arena | record_info(fields, ranklist_arena)],
		 [sworn_brother | record_info(fields, sworn_brother)],
		 [sworn_brother_reward | record_info(fields, sworn_brother_reward)],
		 [seal_boss_challenge | record_info(fields, seal_boss_challenge)],
		 [relation | record_info(fields, relation)],
		 [usr_flower | record_info(fields, usr_flower)],
 		 [quell_demon_pagoda | record_info(fields, quell_demon_pagoda)],
		 [shelve | record_info(fields, shelve)],
		 [worship | record_info(fields, worship)],
		 [worship_model | record_info(fields, worship_model)],
		 [storm_city_own | record_info(fields, storm_city_own)],
		 [storm_city_apply | record_info(fields, storm_city_apply)],
		 [storm_city_astrict | record_info(fields, storm_city_astrict)],
		 [rand_box_reward | record_info(fields, rand_box_reward)],
		 [vip_manager | record_info(fields, vip_manager)],
		 [recharge_record | record_info(fields, recharge_record)],
		 [daily_recharge_record | record_info(fields, daily_recharge_record)],
		 [offline_recharge_record | record_info(fields, offline_recharge_record)],
		 [login_reward | record_info(fields, login_reward)],
		 [everyday_reward | record_info(fields, everyday_reward)],
		 [guild_battle_info | record_info(fields, guild_battle_info)],
		 [usr_cd_key | record_info(fields, usr_cd_key)],
		 [lev_reward | record_info(fields, lev_reward)],
		 [online_reward | record_info(fields, online_reward)],
		 [operation_activity | record_info(fields, operation_activity)],
		 [liveness | record_info(fields, liveness)],
		 [operation_activity_detail | record_info(fields, operation_activity_detail)],
		 [operation_activity_reward | record_info(fields, operation_activity_reward)],
		 [new_function_open | record_info(fields, new_function_open)],
		 [achievement | record_info(fields, achievement)],
		 [love_reward | record_info(fields, love_reward)],
		 [open_server_gift_activity | record_info(fields, open_server_gift_activity)],
		 [open_server_gift_ware | record_info(fields, open_server_gift_ware)],
		 [open_server_gift_buy_record | record_info(fields, open_server_gift_buy_record)],
		 [weekcard_reward | record_info(fields, weekcard_reward)]
		]).

-define(StartLoadList,
		[
		 relation,
		 worship_model,
		 offline_recharge_record,
		 usr_flower,
		 operation_activity,
		 operation_activity_detail,
		 open_server_gift_activity,
		 open_server_gift_ware
		 ]).

-define(PlyLoadList, 
		[{usr,id},
		 {item,uid},
		 {normal_skill,uid},
		 {usr_skill_list,uid},
		 {pet,uid},
		 {resource_main,uid},
		 {buff,uid},
		 {model_clothes,uid},
		 {wing,uid},
		 {title,uid},
		 {magic_weapon,uid},
		 {task,uid},
		 {wanted_task,uid},
		 {train_task,uid},	 
		 {usr_rides,uid},
		 {usr_rides_skin,uid},
		 {cast_soul,uid},
		 {recast_property,uid},
		 {endless_challenge_record,uid},
		 {shop_record,uid},
		 {endless_star,uid},
	 	 {single_many_copy,uid},
	 	 {single_star,uid},
		 {activity, uid},
		 {fly_up, uid},
		 {usr_arena, uid},
		 {arena_log, uid},
		 {quell_demon_pagoda,uid},
		 {worship,uid},
		 {storm_city_astrict,uid},
		 {rand_box_reward,uid},
		 {vip_manager,uid},
		 {recharge_record,uid},
		 {daily_recharge_record,uid},
		 {login_reward,uid},
		 {everyday_reward,uid},
		 {usr_cd_key,uid},
		 {lev_reward,uid},
		 {sworn_brother_reward,uid}, 
		 {online_reward,uid},
		{operation_activity_reward,uid},
		{new_function_open,uid},
		{achievement,uid},
		{love_reward,uid},
		{new_function_open,uid},
		{love_reward,uid},
		{weekcard_reward,uid},
		 {liveness,uid}
		]).



-define(WorldTabs,
		[
		 guild,
		 guild_member,
		 guild_event_log,
		 guild_item_log,
		 single_many_copy,
		 endless_challenge_record,
		 mail,
		 usr_arena,
		 arena_log,
		 sworn_brother,
		 seal_boss_challenge,
		 shelve,
		 storm_city_own,
		 storm_city_apply,
		 title,
		 guild_battle_info,
		 usr_flower,
	 	 keepsake
		]).


-define(AgentTabs,
		[
		 usr,
		 normal_skill,
		 usr_skill_list,
		 magic_weapon,
		 task,
		 wanted_task,
		 train_task,
		recast_property,
		 shop_record,
		 login_reward,
		 usr_cd_key
		]).

-define(SceneTabs,
		[
		 ]).








-endif. %%-ifndef('__TD_H__').