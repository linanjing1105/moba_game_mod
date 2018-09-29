-ifndef('__RECORD_H__').
-define('__RECORD_H__', true).

-record(cache,  {uid,cached = 0}).

-record(ply, {uid, aid = 0,sid=0,name="",prof=0,lev=0,ip={0,0,0,0},accname="",agent_pid=0,agent_idx=0,scene_pid=0,scene_idx = 0,scene_id=0,
				scene_type=0,hp=0,hp_limit=0,fight_score=0}).



-record(battle_property,{  
						 hpLimit= 0,mpLimit= 0,atkUp=0,atkDown=0,defUp=0,defDown=0,
						 cri= 0,tough= 0,hit= 0,dod= 0,addHurt=0,reduceHurt=0,
						 lucky=0,moveSpd=0,atk=0,def=0}).

-record(scene_spirit_ex,{id,sort=0,name="no"
						 ,pos={0,0,0},dir=180,camp=1,hp=0,mp=0,die=false
						 ,stifle=0,buffs=[],cds=[]
						 ,move_data=0,damage_data=0,skill_data=0,skill_aleret_data=0
						 ,property = {}
						 ,data = {},passive_skill_data = [],map_cell = no}).
-record(scene_usr_ex,{pid
					  ,sid
					  ,prof=0
					  ,lev=0
					  ,pk_mode=0
					  ,pet_id=0
					  ,equip_list=[]
					  ,skill_list=[]
					  ,model_clothes_id=[]
					  ,wing_id=0
					  ,wing_lev=0
					  ,team = {}
					  ,title_id=0
					  ,prev_save_pos=""
					  ,recently_be_atk_info=[]
					  ,guild_id=0
					  ,guild_name=""
					  ,sla=0
					  ,justice=0
					  ,pk_level=0
					  ,red_name_kill_times=0
					  ,white_name_kill_times=0
					  ,vip_revive_times=0
					  ,magic_weapon_id=0
					  ,magic_strength_lev=0
					  ,magic_strength_star=0,
					  ride_state=0,
					  ride_type=0,
					  currskin=0
					 }).
-record(scene_monster_ex, {type=0
						   ,ai_module=0
						   ,ai_data=0
						   ,ai_time =0
						   ,ai_enabled=true
						   ,ontime_start=0
						   ,ontime_check=0
						   ,ontime_off=0
						   ,script=0	
						   ,owner = 0
						   ,birth_pos={0,0,0}
						   ,send_client=true
						   ,refresh_rule=0
						   ,cart_data=0
						   ,recover_timer=0}).
-record(scene_pet_ex,{
							type = 0,
							name = "",
							skill_list = [],
							owner_id=0
						   }).
-record(scene_robot_ex,{
						prof=0,
					    lev=0,
						equip_list=[],
						skill_list=[],
						model_clothes_id=0,
						wing_id=0,
						wing_lev=0,
						ai_module=0,
						ai_data=0,
						ai_time=0,
						ai_enabled=true					
						}).
-record(scene_item_ex,{type=0,length,high=0,width=0,
						send_client=true,refresh_rule=0}).
-record(scene_pickable_item_ex,{type,amount=0,owner=[],from_id=0,pick_protect_time=0,is_picking=false,raw_item=no,bind=0}).
-record(scene_model_ex,{prof=0,src_uid=0,equip_list=[]}).

-record(chat_off_line,{send_id=0,uid=0,send_name=0,content="",item_id=0,scene=0,x=0,y=0,z=0,time=0,item_type=0}).
-record(scene_cd,{type=0,start=0,lenth=0}).
-record(scene_buff,{type=0,power=0,mix_lev=0,start=0,lenth=0,effect_time=0,buff_adder=0,from_skill={0,0,0}}).
-record(agent_init_data,{fight_score=0}).
-record(enter_scene_data,{usr={},a_hid=0,pos={0,0,0},property={},equip_list=[],skill_list=[],passive_skill=[],model_clothes_id=[],title_id=0,guild_name="",guild_id=0,
						  buffs=[],enter_scene_times=0,magic_weapon_id=0,magic_strength_lev=0,magic_strength_star=0,pet_fightinfo={},ride_state=0,
								   ride_type=0,currskin=0,wing_id=0,wing_lev=0}).
-record(robot_mirror_data,{name="",prof=0,lev=0,property={},equip_list=[],skill_list=[],passive_skill=[],model_clothes_id=0}).
-record(usr_info, {uid,name,prof,lev,vip_lev=0,property,battle=0,equip_list,model_clothes_id,title_id,skill_list,passive_skill_list,pet_info={},
                   ride_type=0,ride_lev=0,guild_name="",slaughter=0,luck_num=0,wing_id=0,wing_lev=0,fight_score=0,ride_skin_id=0}).
-record(move_data,{start_time = 0,all_time = 0,to_pos = 0,move_speed = 0,next = 0}).
-record(skill_data,{start_time = 0,yz_start = 0, yz_time = 0,bt_start = 0, bt_time = 0,wd_start = 0 ,wd_time = 0 ,move_sort = 0,move_speed = 0,move_data = 0}).
-record(damage_data,{start_time = 0, jz_time = 0,move_start = 0,move_sort = 0,move_speed = 0,move_data = 0}).
-record(ai_data, {id=0,type=0,scene=0,x=0,y=0,z=0,status=0,target=0,hatred_list=[],move_dir=no,move_time=0,
					still_partrol_points=[],create_time=0,born_pos={0,0,0},atk_pos={0,0,0},can_atk_time=0,escape_pos=[],rush_path=[],guards=[]}).
-record(cart_data, {module=no,owner={},dest_pos={0,0,0},destroy_time=0}).
-record(team, {id, leader_id = 0, scene = 0, target = 0, members = [], be_req_list = [],max_ply=10,min_lev=1,need_verify=1}).
-record(team_member, {id, team_id = 0, ask_list = [], req_list = [],be_ask_list = []}).

-record(guild_req_list, {id, req_list = []}).
-record(treasure_house, {id, type_record = []}).
-record(guild_store_access,{id,req_list=[],access_list=[]}).
-record(first_guild_battle_data,{id=0,name="",integer=0,copy_id=0,state=0,pos=[],time=0}).
-record(final_guild_battle_data,{id=0,name="",integer=0,copy_id=0,state=0,pos=[],time=0}).
-record(keepsake_copy,{uid=0,copy_id=0}).
-record(operation_act_data, {act_id,data,details,is_running}).
-record(operation_detail_data, {id,index,desc,items_info,conditions}).
-record(guild_cart_escort_data, {guild_id,cart_id=0,times=0,score=0}).



-endif.  %%-ifndef('__RECORD_H__').