-ifndef('__MACRO_H__').
-define('__MACRO_H__', true).

% resources

% channel



%%装备部位
-define(Eqp_BASE,10000).
-define(Sarmor,10001).
-define(Body,10002).
-define(Gaiter,10003).
-define(Bracers,10004).
-define(Belt,10005).
-define(Shoes,10006).
-define(Head,10007).
-define(Necklace,10008).
-define(Badge,10009).
-define(Ring,10010).
-define(Weapon,10011).
-define(Glove,10012).

-define(Purple,4).
-define(Orange,5).

%%仙盟
-define(NORMAL_MEMBER,0).
-define(DEPUTY_LEADER,1).
-define(LEADER,2).

-define(GUILD_NAME_MIN_LEN,2).
-define(GUILD_NAME_MAX_LEN,6).

%%快捷购买
-define(NO_GUIK_BUY,0). 
-define(GUIK_BUY,1). 

% code
-define(TRUE, true).
-define(FALSE, false).
-define(CONTINUE, continue).
-define(UNDEFINED, undefined).
-define(OK, ok).
-define(SKIP, skip).
-define(RETURN, return).
-define(ERROR, error).

% system
-define(MAX_PLAYER_LEV,166).

-define(DIFF_SECONDS_1970_1900, 2208988800).
-define(DIFF_SECONDS_0000_1900, 62167219200).
-define(ONE_DAY_SECONDS,        86400).
-define(ONE_HOUR_SECONDS,		3600).
-define(ONE_MIN_SECONDS,		60).
-define(LEAVE_FIGHT_TIME,5).

%% 场景
-define(SCENE_SORT_CITY,"CITY").
-define(SCENE_SORT_PEACE,"PEACEFIELD").
-define(SCENE_SORT_SCUFFLE,"SCUFFLEFIELD").
-define(SCENE_SORT_COPY,"DUNGEONS").
-define(SCENE_SORT_ARENA,"ARENA").



%%服务器时间(秒)
-define(NOW, util:unixtime()).
%% 服务器实体sort
-define(SPIRIT_SORT_NULL,no).
-define(SPIRIT_SORT_NPC,npc).
-define(SPIRIT_SORT_ITEM,sceneitem).
-define(SPIRIT_SORT_MONSTER,monster).
-define(SPIRIT_SORT_USR,usr).
-define(SPIRIT_SORT_PET,pet).
-define(SPIRIT_SORT_MODEL,model).
-define(SPIRIT_SORT_PICKABLE_ITEM,scene_pickable_item).
-define(SPIRIT_SORT_ROBOT, robot).


%%系统消息发送者
-define(GM1,"GM").
-define(GM2,"系统").
%%邮件类型 
-define(PERSONAL_MAIL,1).
-define(GM_MAIL,2).

%%系统邮件文本(服务端决定标题，客户端决定内容) 
-define(GEM_MAIL,1).


%%藏宝阁抽奖类型
-define(OPEN_BOX1,1).
-define(OPEN_BOX2,2).
-define(OPEN_BOX3,3).

%%消息类型
-define(World,1).
-define(Team,2).
-define(Guild,3).
-define(Private,4).
-define(System,5). 
-define(Special,6). 

%% 转发系统消息的ID
-define(Sys_msg_Type1,1).%%战力第1的人上线
-define(Sys_msg_Type2,2).%%等级第1的人上线
-define(Sys_msg_Type3,3).%%恶人第1的人上线
-define(Sys_msg_Type4,4).%%场景boss刷新
-define(Sys_msg_Type5,5).%%场景，封印boss被杀死掉落的紫色品质以上的装备
-define(Sys_msg_Type6,6).%%玩家被PK死亡后掉落装备
-define(Sys_msg_Type7,7).%%玩家装备强化到8，12，16，20，24，28，32级
-define(Sys_msg_Type8,8).%%幸运+6以上每次成功+幸运
-define(Sys_msg_Type9,9).%%开始运镖
-define(Sys_msg_Type10,10).%%运镖成功
-define(Sys_msg_Type11,11).%%仙盟篝火水晶被摧毁
-define(Sys_msg_Type12,12).%%领取特惠周卡
-define(Sys_msg_Type13,13).%%领取至尊周卡
-define(Sys_msg_Type14,14).%%VIP提升
-define(Sys_msg_Type15,15).%%领取首充奖励
-define(Sys_msg_Type16,16).%%激活第一个翅膀
-define(Sys_msg_Type17,17).%%创建仙盟
-define(Sys_msg_Type18,18).%%玩家加入仙盟
-define(Sys_msg_Type19,19).%%玩家激活时装
-define(Sys_msg_Type20,20).%%领取爱心礼包
-define(Sys_msg_Type21,21).%%装备橙炼为品质5
-define(Sys_msg_Type22,22).%%坐骑进阶
-define(Sys_msg_Type23,23).%%战力排行第一名更换
-define(Sys_msg_Type24,24).%%等级排行第一名更换
-define(Sys_msg_Type25,25).%%铸魂3倍奖励
-define(Sys_msg_Type26,26).%%封神之战进入第四层
-define(Sys_msg_Type27,27).%%封神之战进入第五层
-define(Sys_msg_Type28,28).%%封神之战获得或转移绝世宝剑
-define(Sys_msg_Type29,29).%%武道会开始
-define(Sys_msg_Type30,30).%%封神之战结束
-define(Sys_msg_Type31,31).%%成为魔头
-define(Sys_msg_Type32,32).%%无尽任意副本全服第一个三星
-define(Sys_msg_Type33,33).%%水晶活动中打开高级宝箱
-define(Sys_msg_Type34,34).%%荒野奇袭活动开启
-define(Sys_msg_Type35,35).%%荒野奇袭活动结束
-define(Sys_msg_Type36,36).%%宠物资质达到41以上每提升一级
-define(Sys_msg_Type37,37).%%封印boss被击杀
-define(Sys_msg_Type38,38).%%突破转生
-define(Sys_msg_Type39,39).%%地宫boss出现
-define(Sys_msg_Type40,40).%%蓝色及蓝色以上天魂达到8星
-define(Sys_msg_Type41,41).%%升阶到橙色
-define(Sys_msg_Type42,42).%%乱杀人被雷击
-define(Sys_msg_Type43,43).%%击杀攻城boss
-define(Sys_msg_Type44,44).%%玩家被PK死亡后
-define(Sys_msg_Type45,45).%%玩家连续击杀2人后
-define(Sys_msg_Type46,46).%%神圣晶石活动开始了！
-define(Sys_msg_Type47,47).%%神圣晶石活动结束了！
-define(Sys_msg_Type48,48).%%每日运镖活动开始了！
-define(Sys_msg_Type49,49).%%每日运镖活动结束了！
-define(Sys_msg_Type50,50).%%仙盟篝火活动开始了！
-define(Sys_msg_Type51,51).%%仙盟篝火活动结束了！
-define(Sys_msg_Type52,52).%%武道会活动结束了！
-define(Sys_msg_Type53,53).%%封神之战开始了！
-define(Sys_msg_Type54,54).%%仙域守护活动开始了！
-define(Sys_msg_Type55,55).%%仙域守护活动结束了！
-define(Sys_msg_Type56,56).%%怪物攻城活动开始了！
-define(Sys_msg_Type57,57).%%怪物攻城活动结束了！
-define(Sys_msg_Type58,58).%%仙盟运镖活动开始了！
-define(Sys_msg_Type59,59).%%仙盟运镖活动结束了！
-define(Sys_msg_Type60,60).%%仙盟攻城活动开始了！
-define(Sys_msg_Type61,61).%%仙盟攻城活动结束了！
-define(Sys_msg_Type62,62).%%仙域争霸开始
-define(Sys_msg_Type63,63).%%仙域争霸结束
-define(Sys_msg_Type64,64).%%物品上架


	
%% 职业
-define(PROF_WARRIOR, 1). % 战士
-define(PROF_MAGE, 2). %法师
-define(PROF_ASSASSIN, 3). %刺客


 


%% 属性
-define(PROPERTY_ATKUP,1).%% 攻击上限
-define(PROPERTY_ATKDOWN,2).%% 攻击下限
-define(PROPERTY_DEFUP,3).%% 防御上限
-define(PROPERTY_DEFDOWN,4).%% 防御下限
-define(PROPERTY_HPLIMIT,5).%% 生命上限
-define(PROPERTY_MPLIMIT,6).%% 法力上限
-define(PROPERTY_HIT,7).%% 命中
-define(PROPERTY_DOD,8).%% 闪避
-define(PROPERTY_CRI,9).%% 暴击
-define(PROPERTY_TOUGH,10).%% 韧性
-define(PROPERTY_ADDHURT,11). %% 增伤
-define(PROPERTY_REDUCEHURT,12). %%免伤
-define(PROPERTY_LUCKY, 13). %%幸运
-define(PROPERTY_SLA, 14). %%杀戮值
-define(PROPERTY_ATK, 15). %%攻击
-define(PROPERTY_DEF, 16). %%防御
-define(PROPERTY_JUSTICE, 17). %%正义值
-define(PROPERTY_PKLEVEL, 18). %%杀戮等级
-define(PROPERTY_PKMODE, 19).  %%PK模式

-define(PROPERTY_MOVESPD,100).%% 移速
-define(PROPERTY_LEV,101).%% 等级
-define(PROPERTY_HP,102).%% 生命
-define(PROPERTY_MP,103).%% 法力
-define(PROPERTY_EXP,104).%% 经验
-define(PROPERTY_LEVLIMIT,105).%% 等级上限
-define(PROPERTY_EXPNEEDED,106).%% 经验上限
-define(PROPERTY_MODEL_CLOTHES,107).%% 时装
-define(PROPERTY_TITLE,108).%% 称号
-define(PROPERTY_FIGHT_SCORE,109). %%战斗力
-define(PROPERTY_CAMP, 110). %% 阵营  
-define(PROPERTY_RIDE_ID,111). %%坐骑id
-define(PROPERTY_SKIN_ID, 112). %%坐骑皮肤\
-define(PROPERTY_WING_ID, 113). %%翅膀
-define(PROPERTY_WING_LEV, 114). %%翅膀



-define(PROPERTY_BINDING_COIN,300).%% 绑定金币
-define(PROPERTY_UNBINGDING_COIN,301).%% 未绑定的金币
-define(PROPERTY_LIJIN,302).%% 礼金
-define(PROPERTY_YUANBAO,303).%% 元宝
-define(PROPERTY_REPAIR,304).%% 修为
-define(PROPERTY_SAVVY,305).   %%悟性
-define(PROPERTY_ANIMA,306). %%灵气
-define(PROPERTY_XIAN_Qi,307). %%仙气
-define(PROPERTY_EXPLOIT ,308). %%功勋
-define(PROPERTY_REPUTATION ,309). %%声望
-define(PROPERTY_INTEGRAL ,310). %%积分
-define(PROPERTY_VIP_EXP ,311). %%VIP经验
-define(PROPERTY_CONTRIBUTE ,312). %%仙盟贡献




%% 阵营关系
-define(RELATION_FRIEND,0).	%%友善
-define(RELATION_ENEMY,1).	%%敌对
-define(RELATION_NEUTRAL,2).%%中立
-define(RELATION_TEAM,3).	%%组队

-define(ARROW_SKILL, "ARROW").%%弹道
-define(TRAP_SKILL, "TRAP").%%陷阱
-define(ITSELF_SKILL, "SKILL").%%本身
-define(BUFF_SKILL, "BUFF").%%本身
-define(ALL_SKILL, "ALL").%%所有

%% 被动技能触发事件
-define(PS_EVT_INIT, 5).	%% 技能初始化时

-define(PS_EVT_HIT_TAG,1).	%% 命中目标
-define(PS_EVT_BE_HIT,2).	%% 被命中

-define(PS_EVT_CRI_HIT_TAG,3).	%%	造成暴击
-define(PS_EVT_BE_CRI_HIT,4).	%%	被暴击

%%物品放入背包的默认绑定参数
-define(DEFAUT_BIND,no). 



%%资源


-define(RESOUCE_SYCEE,1).%%元宝
-define(RESOUCE_CASH, 2).%%礼金
-define(RESOUCE_EXP,3).%%经验
-define(RESOUCE_STAMINA,4).%%体力
-define(RESOUCE_BINDING_COPPER_COIN,5).%%绑定铜币
-define(RESOUCE_UNBINDING_COPPER_COIN,6).%未绑定铜币
-define(RESOUCE_SAVVY,7).   %%悟性
-define(RESOUCE_SKILL_POINT,8).  %%技能点
-define(RESOUCE_REPAIR ,9). %%修为
-define(RESOUCE_ANIMA,10). %%灵气
-define(RESOUCE_XIAN_Qi,11). %%仙气
-define(RESOUCE_EXPLOIT ,12). %%功勋
-define(RESOUCE_REPUTATION ,13). %%声望
-define(RESOUCE_INTEGRAL ,14). %%积分
-define(RESOUCE_VIP_EXP ,15). %%VIP经验
-define(RESOUCE_CONTRIBUTE ,16). %%仙盟贡献 
-define(RESOUCE_INTIMACY ,17). %%亲密度 

%%绑定 
-define(Binding,1).
-define(Un_Binding,0).

%% 排行榜
-define(RANKLIST_TYPE_SCORE, 1).		%%战力榜
-define(RANKLIST_TYPE_LEVEL, 2).		%%等级榜
-define(RANKLIST_TYPE_PET, 3).			%%宠物榜
-define(RANKLIST_TYPE_MOUNT, 4).		%%坐骑榜
-define(RANKLIST_TYPE_ENDLESS, 5).		%%无尽榜
-define(RANKLIST_TYPE_GUILD, 6).		%%公会榜
-define(RANKLIST_TYPE_WING, 7).			%%仙羽榜
-define(RANKLIST_TYPE_FLOWER_SEND, 8).	%%送花榜
-define(RANKLIST_TYPE_FLOWER_RECV, 9).	%%收花榜
-define(RANKLIST_TYPE_EVIL, 10).		%%恶人榜
-define(RANKLIST_TYPE_HERO, 11).		%%英雄榜
-define(RANKLIST_TYPE_ARENA, 12).		%%竞技榜
-define(RANKLIST_TYPE_BUDOKAI, 13).		%%武道会榜
-define(RANKLIST_TYPE_GUILD_CART_ESCORT, 14). %%公会运镖





%%与角色VIP等级相关控制次数(每天都会刷新)的类型
 -define(COPY_NUM,1).     %%
 -define(CAST_SOUL_NUM,2). %%
 -define(RELIVE_TIME,3). %%
 -define(DART_NUM,4). %%
 -define(TEST_TASK,5). %%


%%ViP使用权限 
-define(StorehouseAccess,6). %%随身仓库
-define(Ring_task,7). %%跑环任务权限
-define(Li_huoyun,8). %%火云洞开启
-define(Arena_CD,9). %%竞技场面CD
-define(Automatic_buy,9). %%挂机自动购买
-define(Free_transfer,10). %%免费传送
-define(Shopping_mall,11). %%商城购买珍贵道具
-define(Mopping_free,12). %%免费扫荡

%%VIP加成
-define(Hurt_reduce,13). 
-define(Exp_addition,14).
-define(Bag_time,15).
-define(Warehouse_num,16).



%% 


%%快捷购买
-define(QUICK_BUY,1).
-define(NO_QUICK_BUY,0).
-define(PUT_ON,1).
-define(GET_OFF,0).
-define(NO_ACTIVATE,0).
-define(ACTIVATE_OK,1).
-define(ACTION_TEAM_ASK,1).   %%我请求别人组队， 我是队长
-define(ACTION_TEAM_REQ,2).  %% 我向别人申请加入队伍
-define(ACTION_TEAM_QUIT,3). %%退出队伍
-define(ACTION_TEAM_LEADER_CHG,4).   %%队长更换
-define(ACTION_TEAM_RECRUIT_FRIEND,5).  %%招募好友
-define(ACTION_RECRUIT_FRIEND_REPLY,6).  %%招募好友对方应答


%%  -define(ACTION_TEAM_TARGET_CHG,2002). %%队伍目标改变
-define(ACTION_TEAM_KICK_USR,5).
-define(UP_OK,1).
-define(UP_DEFEAT,0).
-define(COMMOM_REST_HOUR,0).
-define(GET_OK,1).
-define(NO_GET,0).
-define(PREPARE_OK,1).
-define(CANCLE_OK,2).
-define(THREE_STAR,3).
-define(TWO_STAR,2).
-define(ONE_STAR,1).
-define(WIN,1).
-define(DEFEAT,0).
-define(USR_KILL_ROBOT,1).
-define(ROBOT_KILL_USR,2).
-define(USR_KILL_USR,3).
-define(USR,0).
-define(ROBOT,1).
%%场景type
-define(SCENE_TYPE_ARENA,160001).

%%NPC交互距离
-define(NPC_INTERACT_DIS, 7).


%% PK模式
-define(PKMODE_PEACE, 1). %%和平模式
-define(PKMODE_ALL, 2).	  %%全体模式
-define(PKMODE_TEAM, 3).  %%组队模式
-define(PKMODE_GUILD, 4). %%仙盟模式
-define(PKMODE_JUSTICE, 5).  %%善恶模式

%% PK等级
-define(PKLEVEL_WHITE, 1). %%白名（普通）
-define(PKLEVEL_YELLOW, 2).	%%黄名（恶徒）
-define(PKLEVEL_RED, 3).	%%红名（魔头）
-define(PKLEVEL_BLUE, 4).	%%蓝名（侠士）
-define(PKLEVEL_PURPLE, 5). %%紫名（英雄）

%%任务状态
-define(NO_ACCEPT_STATE,0). %%未接取
-define(ACCEPT_STATE,1). %%接取
-define(CAN_FINISH_STATE,2).%%能完成
-define(FINISH_STATE,3).%%已提交完成


-define(TASK_SCENE1,[100011,100012,100013,100014]).
-define(TASK_SCENE2,[100021,100023]).


-define(Guild_battle_end_time,guild_battle_end_time).

%% 任务条件类型
-define(TASK_KILL_MON,1001). 						%%击杀指定类型
-define(TASK_KILL_TYPE,1002). 						%%目标场景中杀死boss级别怪物次数
-define(TASK_KILL_NUM,1003). 						%%杀死野外BOSS次数（包括的场景id为100011、10002、10003、10004）
-define(TASK_KILL_NUM1,1004). 						%%目标场景中杀死30或更高等级怪物次数
-define(TASK_KILL_NUM2,1005). 						%%目标场景中杀死35或更高等级怪物次数
-define(TASK_KILL_NUM3,1006). 						%%目标场景中杀死40或更高等级怪物次数
-define(TASK_KILL_NUM4,1007). 						%%目标场景中杀死45或更高等级怪物次数
-define(TASK_KILL_NUM5,1008). 						%%目标场景中杀死50或更高等级怪物次数
-define(TASK_KILL_NUM6,1009). 						%%杀死目标BOSS	
-define(TASK_PASS_COPY,2001). 						%%通关任意副本指定次数
-define(TASK_PASS_COPY_GRUP,2003). 			%%通关任意副本组中副本指定次数
-define(TASK_PASS_SPECIFY_ACTIVITY,2002). 	%%参加指定活动
-define(VIP_LEV,3001). 										%%玩家VIP等级
-define(RESOURCE_ADD_EVENT,4001).				%%资源收集
-define(PET_STRENTHEN,5001).						%%宠物强化
-define(TASK_IMP_ACT,6002).             			 	%%强化行为 
-define(TASK_SCENE_ITEM,8001).						%%互动【指定类型】【指定次数】的场景物品
-define(MOUNT_CULTRUE,14001).         			%%坐骑培养
-define(FINISH_TARGET_TASK,17001).        		%%完成指定任务
-define(EQUIP_CLEAR,18001).         					%%装备洗练
-define(EQUIP_DECOMPOSE,18002). 				%%装备分解
-define(WU_JIN_SHI_LIAN,20002). 					%%无尽试练的次数
-define(PK_ACT,20003). 									%%竞技场的次数
-define(SHOP_ACT,20004). 								%%商城的购买次数


-define(TALK_TO_NPC,19001).                          %%跟NPC对话
-define(TASK_SCENE_ITEM2,8002).					%%采集道具	
-define(EQUIP,20001).                 %%穿装备

%%怪物分类 
-define(NORMAL_MONSTER,0). 
-define(ELITIST_MONSTER,1).
-define(BOSS_MONSTER,2).


%% -define(TASK_PASS_DUNGEONS_COPY,2003). 		%%通关指定剧情副本指定次数
%% -define(TASK_TEAM_PASS_COPY,2004).     		%%组队通关任意副本指定次数
%% -define(TASK_TEAM_PASS_SPECIFY_COPY,2005). 	%%组队通关指定副本指定次数
%% -define(TASK_OWN_PROP,4002).				%%拥有指定属
%% -define(TASK_OWN_SKILL,5002).				%%拥有指定主动技�
%% -define(TASK_UP_SPECIFY_SKILL,5003).		%%提升指定主动技�
%% -define(TASK_UP_PASSIVE_SKILL,5004).		%%提升任意被动技�
%% -define(TASK_OWN_PASSIVE_SKILL,5005).		%%拥有指定被动技�
%% -define(TASK_UP_SPECIFY_PASSIVE_SKILL,5006).%%提升指定被动技�
%% -define(TASK_COMMIT_ITEM,3001). 			%%提交指定物品
%% -define(TASK_OWN_ITEM,3002).        		%%拥有指定物品
%% -define(TASK_USE_ITEM,3003).       			%%使用指定物品



%% -define(TASK_EQU_ACT,6001).              	%%装备指定部位的装� 1-10装备

%% -define(TASK_COMP_ACT,6003).             	%%合成行为
%% -define(TASK_MOVE_POS,7001).				%%到达指定场景的指定地�



%%每天刷新时间
-define(AUTO_REFRESH_TIME,0).
%%任务
-define(SORT_MAINTASK, 1).%%主线
-define(SORT_BRANCH_TASK, 2).%%支线
-define(SORT_SURROUND_TASK, 3).%%跑环任务
-define(SORT_SHILIAN_TASK, 4).%%试炼任务
-define(SORT_JIEYI_TASK, 5).%%结义任务
%%活跃度
-define(ACTIVITY_IMPROVE,1).%%强化
-define(ACTIVITY_GEM_CHARGE,2).%%宝石充能
-define(ACTIVITY_COINS_PLAY,3).%%金币玩法
-define(ACTIVITY_EXP_REWARDS,4).%%经验奖励玩法
-define(ACTIVITY_KILL_HOSTILE_CAMP,5).%%杀死敌对阵营的玩家
-define(ACTIVITY_TASK_WANTED,6).%%悬赏
-define(ACTIVITY_ARCHAEOLOGY,7).%%考古
-define(ACTIVITY_COPY,8).%%完成任意副本3次
-define(ACTIVITY_YXSL,9).%% 参与一次英雄试炼
-define(ACTIVITY_PRAYER,10).%%进行一次抽奖
-define(ACTIVITY_LIKE,11).%% 对好友点赞1次
-define(ACTIVITY_FEEDING_MOUNT,12).%% 13 喂养5次坐骑
-define(ACTIVITY_VOTE,13).%%进行一次投票
-define(ACTIVITY_CAMP_TASK,14).%% 完成5次阵营人物 
-define(ACTIVITY_LOST_ITEM,15).%%提升1遗物等级
-define(ACTIVITY_MASTERY,16).%%提升1次专精等级
-define(ACTIVITY_GUILD_DONATE,17).%% 进行1次公会捐献

%%物品获取途径
-define(ITEM_WAY_ACTIVITY, 1).%%活跃度添加物品
-define(ITEM_WAY_COPY_RESULT, 2).%%副本结算添加物品
-define(ITEM_WAY_WORSHIP, 3).%%膜拜
-define(ITEM_WAY_MILITARY_DAY, 4).%%军衔每日奖励
-define(ITEM_WAY_CHAPTER, 5).%%章节
-define(ITEM_WAY_GM, 6).%%GM
-define(ITEM_WAY_RECYCLE, 7).%%回收
-define(ITEM_WAY_LIKE, 8).%%点赞
-define(ITEM_WAY_BY_LIKE, 9).%%被点赞
-define(ITEM_WAY_SEVEN_DAYS_REWARDS, 10).%%七日登陆奖励
-define(ITEM_WAY_LEV_REWARDS, 11).%%等级奖励
-define(ITEM_WAY_SINGN, 12).%%签到获取的奖励（当日）累积签到奖励
-define(ITEM_WAY_ACCUMULATE_SINGN, 13).%%累积签到奖励
-define(ITEM_WAY_STORE, 14).%%商店
-define(ITEM_WAY_TASK_CAMP, 15).%%阵营任务
-define(ITEM_WAY_TASK_WANTED, 16).%%悬赏任务
-define(ITEM_WAY_TASK, 17).%%任务
-define(ITEM_WAY_DIE_MONSTER, 18).%%杀怪
-define(ITEM_WAY_ARCHAEOLOGY, 19).%%考古
-define(ITEM_WAY_DRAW, 20).%%抽奖
-define(ITEM_WAY_REVIVE, 21).%%复活
-define(ITEM_WAY_REVENGE, 22).%%寻仇
-define(ITEM_WAY_ENTOURAGE, 23).%%佣兵
-define(ITEM_WAY_GEM, 24).%%宝石
-define(ITEM_WAY_USE, 25).%%使用物品
-define(ITEM_WAY_INTENSIFY, 26).%%强化
-define(ITEM_WAY_BREAK, 27).%%突破
-define(ITEM_WAY_STAR, 28).%%升星
-define(ITEM_WAY_LEARN_SKILL, 29).%%学习技能
-define(ITEM_WAY_UNLOCK_RUNE, 30).%%激活符文
-define(ITEM_WAY_LOST_ITEM, 31).%%遗失之物
-define(ITEM_WAY_MILITARY, 32).%%军衔
-define(ITEM_WAY_RIDE, 33).%%坐骑
-define(ITEM_WAY_SELL,34).%%出售物品
-define(ITEM_WAY_SCENE_DROP,35).%%场景掉落物品
-define(ITEM_WAY_CHAT,36).%%聊天

-define(REWARDS_DAY,1).%%签到
-define(REWARDS_LEV,2).%%等级
-define(REWARDS_ONLINE,3).%%在线

-define(STATE_ONLINE, 0).%%在线
-define(STATE_OFFLINE,1).%%离线

%%活动副本类型
-define(COPY_SORT_ENDLESS,"ENDLESS").
-define(COPY_SORT_SINGLE_MANY,"SINGLE_MANY").
-define(COPY_SORT_QUELL_DEMON,"QUELL_DEMON").
-define(COPY_SORT_GUILD_GUARD,"GUILD_GUARD").
-define(COPY_SORT_SEAL_BOSS,"SEAL_BOSS").

%%活动场景
-define(ACT_SCENE_QUELL_DEMON, 100002).
-define(ACT_SCENE_BUDO, 160004).
-define(ACT_SCENE_GUILD_BATTLE, 150007).
-define(ACT_SCENE_FENG_SHEN, 160003).
-define(ACT_SCENE_GUILD_BONFIRE,150004).
-define(ACT_SCENE_GUILD_GUARD_1,150001).
-define(ACT_SCENE_GUILD_GUARD_2,150005).
-define(ACT_SCENE_GUILD_GUARD_3,150006).
-define(ACT_SCENE_GUILD_STORM_CITY,150002).
%%活动ID
-define(ACT_ID_QUELL_DEMON, 1).
-define(ACT_ID_FENG_SHEN,2).     %%封神之路
-define(ACT_ID_CART_ESCORT, 3).	 %% 单人运镖
-define(ACT_ID_GUILD_BONFIRE,4). %%仙盟篝火
-define(ACT_ID_GUILD_GUARD,6).  %%仙盟守护
-define(ACT_ID_GUILD_CART_ESCORT, 9). %% 仙盟运镖
-define(ACT_ID_GUILD_STORM_CITY,10).  


%%BOSS挑战
-define(BOSS_TYPE_UNDERGROUND_PALACE,1).
-define(BOSS_TYPE_SCENE,2).
-define(BOSS_TYPE_SEAL,3).
-define(BOSS_TYPE_SMELTTERS,4). %熔恶BOss 
-define(BOSS_TYPE_LI_SMELTTERS,5).  %%里熔恶

%%封神之路
-define(KILL_MONSTER,1).
-define(KILL_USR,2).
-define(START_OK,1).	

-define(ITEM_COLOUR_VIOLET,4).

%%称号
-define(TITLE_BUDO,1).            %%  1.武道会结束的排名
-define(TITLE_GUILD_GUARD,2).     %%  每周仙域争霸结束，仙盟排名
-define(TITLE_XIANMO,3).          %%  仙魔幻境结束的排名
-define(TITLE_XIANMO_KILL,4).     %% 仙魔幻境结束的杀人排名
-define(TITLE_ACHIEVEMENT_1,5).   %% 完成成就类型1等级3
-define(TITLE_UP_LEV,6).             %%  升级时的等级
-define(TITLE_FIGHT,7).           %%.战力提升时的战力值
-define(TITLE_ACHIEVEMENT_4,8).   %%  .完成成就类型4等级3
-define(TITLE_ACHIEVEMENT_5,9).   %%  .完成成就类型5等级3
-define(TITLE_ACHIEVEMENT_6,10).  %%  完成成就类型6等级2
-define(TITLE_GEM,11).            %%镶嵌5级以上（含5级）的宝石成功时，所有装备镶嵌5级以上（含5级）宝石的数量
-define(TITLE_EQUIP_RECAST,12).   %%.装备洗练出橙色属性时，检查所有装备的橙色属性数量
-define(TITLE_PET_GROW_UP,13).    %%.宠物成长提升时，判断成长等级
-define(TITLE_PET_APTITUDE,14).   %%.宠物资质提升时，判断资质等级
-define(TITLE_RIDE_LEV,15).       %%坐骑进阶时，判断坐骑进阶等级
-define(TITLE_COPY_AMOUNT,16).        %%..通关副本时判断通关副本次数
-define(TITLE_GUILD_CONTRIBUTE,17).   %%.获得仙盟贡献时，检查该玩家的仙盟贡献总值
-define(TITLE_MODEL_CLOTHES,18).      %%.获得时装时，判断时装的数量
-define(TITLE_PET_LIAN_HUN,19).       %%.宠物炼魂成功时，判断炼魂的等级
-define(TITLE_TASK,20).               %%.完成主线任务时，主线任务ID判断
-define(TITLE_FENGSHEN_RANK,21).      %%.封神之战结束时，判断封神排行
-define(TITLE_FLY_UP,22).             %%.飞升系统开启或提升境界时，判断境界的等级
-define(TITLE_COMPANION_INTIMACY,23). %%.仙侣亲密度提升时，判断仙侣亲密度值
-define(TITLE_STORM_CITY,24).         %%.攻城战结束后，自己公会拥有城池时判断玩家的职位
-define(TITLE_PET_UP_LEV,25).         %%.宠物成长等级提升，判断宠物等级，该判断所增加属性只对宠物有效！



%%%%%%%%%%%%%%%%%%%%%%% 成就 
-define(ACHIEVEMENT_COPPER_COIN,1).            %%  1 消耗绑定铜钱时，消耗绑定铜钱的总量
-define(ACHIEVEMENT_UP_LEV,2).                 %%  等级提升时，判断等级
-define(ACHIEVEMENT_UP_FIGHT,3).               %%  战斗力提升时，判断战斗力
-define(ACHIEVEMENT_UP_SKILL,4).               %% 技能升级时，判断达到指定等级的技能个数
-define(ACHIEVEMENT_EQUIP,5).                  %% 装备强化升级时，判断达到指定强化等级的装备个数
-define(ACHIEVEMENT_EQUIP_LEV_NUM,6).          %%   穿装备成功时，判断达到指定装备等级的装备的个数
-define(ACHIEVEMENT_GEM_LEV_NUM,7).            %%.镶嵌宝石成功时，判断达到指定的级的宝石的个数
-define(ACHIEVEMENT_EQUIP_PROPERTY_NUM,8).     %%  洗练出橙色属性并替换时，判断达到橙色属性的个数
-define(ACHIEVEMENT_PET_GROW_UP,9).            %%  .宠物成长等级提升时，判断该宠物的成长等级。
-define(ACHIEVEMENT_PET_LING_XIU,10).          %% .宠物灵修成功时，判断该宠物达到指定灵修等级的灵修个数
-define(ACHIEVEMENT_PET_APTITUDE,11).          %% 宠物资质等级提升时，判断资质等级
-define(ACHIEVEMENT_RIDE_LEV,12).              %%.坐骑升级时，判断坐骑的阶段和等级
-define(ACHIEVEMENT_COPY_AMOUNT,13).           %%.通关副本时，判断通关副本的次数
-define(ACHIEVEMENT_GUILD_CONTRIBUTE,14).      %%.捐献帮贡时，判断该角色捐献帮贡的累计值
-define(ACHIEVEMENT_MODELE_CLOTHES,15).        %%获得永久时装时，判断该角色获得的永久时装的个数



%%奖励
-define(REWARD_TYPE_LEV,1).
-define(REWARD_TYPE_ONLINE,2).


%% 红点状态
-define(RED_DOT_STATE_NORMAL, 1).		%% 有红点
-define(RED_DOT_STATE_CLEAR, 0).		%% 红点清除

%%%  更新红点类型
-define(RED_DOT_ACHIEVEMENT,1).	%% 成就
-define(RED_DOT_FIRST_RECHARGE, 2). %% 首充

-endif.