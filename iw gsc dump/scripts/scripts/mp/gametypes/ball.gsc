/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\gametypes\ball.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 53
 * Decompile Time: 2723 ms
 * Timestamp: 10/27/2023 12:12:18 AM
*******************************************************************/

//Function Number: 1
main()
{
	scripts\mp\_globallogic::init();
	scripts\mp\_globallogic::setupcallbacks();
	if(function_011C())
	{
		level.initializematchrules = ::initializematchrules;
		[[ level.initializematchrules ]]();
		level thread scripts\mp\_utility::reinitializematchrulesonmigration();
	}
	else
	{
		scripts\mp\_utility::registerscorelimitdvar(level.gametype,20);
		scripts\mp\_utility::registertimelimitdvar(level.gametype,5);
		scripts\mp\_utility::registerroundlimitdvar(level.gametype,2);
		scripts\mp\_utility::registerroundswitchdvar(level.gametype,1,0,1);
		scripts\mp\_utility::registerwinlimitdvar(level.gametype,0);
		scripts\mp\_utility::registernumlivesdvar(level.gametype,0);
		level.matchrules_damagemultiplier = 0;
	}

	level.carrierarmor = 100;
	updategametypedvars();
	level.teambased = 1;
	level.objectivebased = 0;
	level.var_112BF = 0;
	level.onprecachegametype = ::onprecachegametype;
	level.onstartgametype = ::onstartgametype;
	level.getspawnpoint = ::getspawnpoint;
	level.onplayerkilled = ::onplayerkilled;
	level.onspawnplayer = ::onspawnplayer;
	level.spawnnodetype = "mp_ball_spawn";
	level.ballreset = 1;
	level.scorefrozenuntil = 0;
	level.ballpickupscorefrozen = 0;
	if(level.matchrules_damagemultiplier)
	{
		level.modifyplayerdamage = ::scripts\mp\_damage::gamemodemodifyplayerdamage;
	}

	game["dialog"]["gametype"] = "uplink";
	if(getdvarint("g_hardcore"))
	{
		game["dialog"]["gametype"] = "hc_" + game["dialog"]["gametype"];
	}

	game["dialog"]["drone_reset"] = "ul_obj_respawned";
	game["dialog"]["you_own_drone"] = "ally_own_drone";
	game["dialog"]["ally_own_drone"] = "ally_own_drone";
	game["dialog"]["enemy_own_drone"] = "enemy_own_drone";
	game["dialog"]["ally_throw_score"] = "ally_throw_score";
	game["dialog"]["ally_carry_score"] = "ally_carry_score";
	game["dialog"]["enemy_throw_score"] = "enemy_throw_score";
	game["dialog"]["enemy_carry_score"] = "enemy_carry_score";
	game["dialog"]["pass_complete"] = "friendly_pass";
	game["dialog"]["pass_intercepted"] = "pass_intercepted";
	game["dialog"]["ally_drop_drone"] = "ally_drop_drone";
	game["dialog"]["enemy_drop_drone"] = "enemy_drop_drone";
	game["dialog"]["ally_drone_half"] = "halfway_enemy";
	game["dialog"]["enemy_drone_half"] = "halfway_friendly";
	game["dialog"]["offense_obj"] = "capture_obj";
	game["dialog"]["defense_obj"] = "capture_obj";
}

//Function Number: 2
initializematchrules()
{
	scripts\mp\_utility::setcommonrulesfrommatchdata();
	setdynamicdvar("scr_ball_scoreCarry",getmatchrulesdata("ballData","scoreCarry"));
	setdynamicdvar("scr_ball_scoreThrow",getmatchrulesdata("ballData","scoreThrow"));
	setdynamicdvar("scr_ball_satelliteCount",getmatchrulesdata("ballData","satelliteCount"));
	setdynamicdvar("scr_ball_practiceMode",getmatchrulesdata("ballData","practiceMode"));
	setdynamicdvar("scr_ball_possessionResetCondition",getmatchrulesdata("ballCommonData","possessionResetCondition"));
	setdynamicdvar("scr_ball_possessionResetTime",getmatchrulesdata("ballCommonData","possessionResetTime"));
	setdynamicdvar("scr_ball_idleResetTime",getmatchrulesdata("ballCommonData","idleResetTime"));
	setdynamicdvar("scr_ball_explodeOnExpire",getmatchrulesdata("ballCommonData","explodeOnExpire"));
	setdynamicdvar("scr_ball_armorMod",getmatchrulesdata("ballCommonData","armorMod"));
	setdynamicdvar("scr_ball_showEnemyCarrier",getmatchrulesdata("ballCommonData","showEnemyCarrier"));
	setdynamicdvar("scr_ball_promode",0);
}

//Function Number: 3
onprecachegametype()
{
	game["bomb_dropped_sound"] = "mp_uplink_ball_pickedup_enemy";
	game["bomb_recovered_sound"] = "mp_uplink_ball_pickedup_friendly";
}

//Function Number: 4
onstartgametype()
{
	var_00 = scripts\mp\_utility::inovertime();
	var_01 = game["overtimeRoundsPlayed"] == 0;
	var_02 = scripts\mp\_utility::istimetobeatvalid();
	if(var_00)
	{
		if(var_01)
		{
			setomnvar("ui_round_hint_override_attackers",1);
			setomnvar("ui_round_hint_override_defenders",1);
		}
		else if(var_02)
		{
			setomnvar("ui_round_hint_override_attackers",scripts\engine\utility::ter_op(game["timeToBeatTeam"] == game["attackers"],2,3));
			setomnvar("ui_round_hint_override_defenders",scripts\engine\utility::ter_op(game["timeToBeatTeam"] == game["defenders"],2,3));
		}
		else
		{
			setomnvar("ui_round_hint_override_attackers",4);
			setomnvar("ui_round_hint_override_defenders",4);
		}
	}

	if(!isdefined(game["switchedsides"]))
	{
		game["switchedsides"] = 0;
	}

	if(game["switchedsides"])
	{
		var_03 = game["attackers"];
		var_04 = game["defenders"];
		game["attackers"] = var_04;
		game["defenders"] = var_03;
	}

	scripts\mp\_utility::setobjectivetext("allies",&"OBJECTIVES_BALL");
	scripts\mp\_utility::setobjectivetext("axis",&"OBJECTIVES_BALL");
	if(level.splitscreen)
	{
		scripts\mp\_utility::setobjectivescoretext("allies",&"OBJECTIVES_BALL");
		scripts\mp\_utility::setobjectivescoretext("axis",&"OBJECTIVES_BALL");
	}
	else
	{
		scripts\mp\_utility::setobjectivescoretext("allies",&"OBJECTIVES_BALL_SCORE");
		scripts\mp\_utility::setobjectivescoretext("axis",&"OBJECTIVES_BALL_SCORE");
	}

	scripts\mp\_utility::setobjectivehinttext("allies",&"OBJECTIVES_BALL_HINT");
	scripts\mp\_utility::setobjectivehinttext("axis",&"OBJECTIVES_BALL_HINT");
	setclientnamemode("auto_change");
	scripts\mp\gametypes\obj_ball::ball_default_origins();
	var_05[0] = level.gametype;
	var_05[1] = "dom";
	var_05[2] = "ball";
	scripts\mp\_gameobjects::main(var_05);
	level thread run_ball();
	level thread onplayerconnect();
	if(level.possessionresetcondition != 0)
	{
		scripts\mp\gametypes\obj_ball::initballtimer();
	}
}

//Function Number: 5
updategametypedvars()
{
	scripts\mp\gametypes\common::updategametypedvars();
	level.scorecarry = scripts\mp\_utility::dvarintvalue("scoreCarry",2,1,9);
	level.scorethrow = scripts\mp\_utility::dvarintvalue("scoreThrow",1,1,9);
	level.satellitecount = scripts\mp\_utility::dvarintvalue("satelliteCount",1,1,5);
	level.practicemode = scripts\mp\_utility::dvarintvalue("practiceMode",0,0,1);
	level.possessionresetcondition = scripts\mp\_utility::dvarintvalue("possessionResetCondition",0,0,2);
	level.possessionresettime = scripts\mp\_utility::dvarfloatvalue("possessionResetTime",0,0,150);
	level.explodeonexpire = scripts\mp\_utility::dvarintvalue("explodeOnExpire",0,0,1);
	level.idleresettime = scripts\mp\_utility::dvarfloatvalue("idleResetTime",15,0,60);
	level.armormod = scripts\mp\_utility::dvarfloatvalue("armorMod",1,0,2);
	level.showenemycarrier = scripts\mp\_utility::dvarintvalue("showEnemyCarrier",5,0,6);
	level.carrierarmor = int(level.carrierarmor * level.armormod);
}

//Function Number: 6
ball_goal_useobject()
{
	foreach(var_02, var_01 in level.ball_goals)
	{
		var_01.trigger = spawn("trigger_radius",var_01.origin - (0,0,var_01.fgetarg),0,var_01.fgetarg,var_01.fgetarg * 2);
		var_01.useobject = scripts\mp\_gameobjects::createuseobject(var_02,var_01.trigger,[],(0,0,var_01.fgetarg * 2.1));
		var_01.useobject.objective_icon = var_01;
		var_01.useobject scripts\mp\_gameobjects::set2dicon("friendly","waypoint_blitz_defend");
		var_01.useobject scripts\mp\_gameobjects::set2dicon("enemy","waypoint_blitz_goal");
		var_01.useobject scripts\mp\_gameobjects::set3dicon("friendly","waypoint_blitz_defend");
		var_01.useobject scripts\mp\_gameobjects::set3dicon("enemy","waypoint_blitz_goal");
		var_01.useobject scripts\mp\_gameobjects::setvisibleteam("any");
		var_01.useobject scripts\mp\_gameobjects::allowuse("enemy");
		var_01.useobject scripts\mp\_gameobjects::setkeyobject(level.balls);
		var_01.useobject scripts\mp\_gameobjects::setusetime(0);
		var_01.useobject scripts\mp\_gameobjects::cancontestclaim(1);
		var_01.useobject.onuse = ::ball_carrier_touched_goal;
		var_01.useobject.canuseobject = ::ball_goal_can_use;
		var_01.useobject.oncontested = ::ball_goal_contested;
		var_01.useobject.onuncontested = ::ball_goal_uncontested;
		var_01.killcament = spawn("script_model",var_01.origin + (0,0,20));
		var_01.killcament setscriptmoverkillcam("explosive");
	}
}

//Function Number: 7
ball_get_path_dist(param_00,param_01)
{
	if(scripts\mp\_spawnlogic::ispathdataavailable())
	{
		var_02 = function_00C0(param_00,param_01,999999);
		if(isdefined(var_02) && var_02 >= 0)
		{
			return var_02;
		}
	}

	return distance(param_00,param_01);
}

//Function Number: 8
ball_goal_fx()
{
	foreach(var_01 in level.ball_goals)
	{
		var_01.score_fx["friendly"] = spawnfx(scripts\engine\utility::getfx("ball_goal_activated_friendly"),var_01.origin,(1,0,0));
		var_01.score_fx["enemy"] = spawnfx(scripts\engine\utility::getfx("ball_goal_activated_enemy"),var_01.origin,(1,0,0));
	}

	level thread ball_play_fx_joined_team();
	foreach(var_04 in level.players)
	{
		ball_goal_fx_for_player(var_04);
	}

	thread goal_watch_game_ended();
}

//Function Number: 9
onplayerconnect()
{
	level endon("game_ended");
	for(;;)
	{
		level waittill("connected",var_00);
		thread onplayerspawned(var_00);
		if(scripts\mp\_utility::istrue(level.practicemode) && var_00 ishost())
		{
			var_00 thread scripts\mp\gametypes\obj_ball::practicenotify();
			var_00 thread scripts\mp\gametypes\obj_ball::moveballtoplayer();
		}
	}
}

//Function Number: 10
onplayerspawned(param_00)
{
	param_00 waittill("spawned");
	param_00 scripts\mp\_utility::setextrascore0(0);
	if(isdefined(param_00.pers["touchdowns"]))
	{
		param_00 scripts\mp\_utility::setextrascore0(param_00.pers["touchdowns"]);
	}

	param_00 scripts\mp\_utility::setextrascore1(0);
	if(isdefined(param_00.pers["fieldgoals"]))
	{
		param_00 scripts\mp\_utility::setextrascore1(param_00.pers["fieldgoals"]);
	}
}

//Function Number: 11
initspawns()
{
	scripts\mp\_spawnlogic::setactivespawnlogic("Uplink");
	level.spawnmins = (0,0,0);
	level.spawnmaxs = (0,0,0);
	scripts\mp\_spawnlogic::addstartspawnpoints("mp_ball_spawn_allies_start");
	scripts\mp\_spawnlogic::addstartspawnpoints("mp_ball_spawn_axis_start");
	level.mapcenter = scripts\mp\_spawnlogic::findboxcenter(level.spawnmins,level.spawnmaxs);
	function_01B4(level.mapcenter);
	var_00 = scripts\mp\_spawnlogic::getspawnpointarray(level.spawnnodetype);
	var_01 = scripts\mp\_spawnlogic::getspawnpointarray(level.spawnnodetype + "_secondary");
	var_02 = assignteamspawns(var_00);
	var_03 = assignteamspawns(var_01);
	scripts\mp\_spawnlogic::registerspawnpoints("allies",var_02["allies"]);
	scripts\mp\_spawnlogic::registerspawnpoints("allies",var_03["allies"],1);
	scripts\mp\_spawnlogic::registerspawnpoints("axis",var_02["axis"]);
	scripts\mp\_spawnlogic::registerspawnpoints("axis",var_03["axis"],1);
}

//Function Number: 12
assignteamspawns(param_00)
{
	var_01 = [];
	var_01["allies"] = [];
	var_01["axis"] = [];
	if(!isdefined(level.maxspawndisttohomebase))
	{
		level.maxspawndisttohomebase = [];
		level.maxspawndisttohomebase["allies"] = 0;
		level.maxspawndisttohomebase["axis"] = 0;
	}

	var_02 = level.ball_goals["allies"].origin;
	var_03 = level.ball_goals["axis"].origin;
	foreach(var_05 in param_00)
	{
		var_06 = getspawnpointdist(var_05,var_02);
		var_07 = getspawnpointdist(var_05,var_03);
		var_05.disttohomebase = [];
		var_05.disttohomebase["allies"] = var_06;
		var_05.disttohomebase["axis"] = var_07;
		var_08 = max(var_06,var_07);
		var_09 = min(var_06,var_07);
		if(abs(var_08 - var_09) / var_08 < 0.2)
		{
			var_01["allies"][var_01["allies"].size] = var_05;
			var_01["axis"][var_01["axis"].size] = var_05;
		}
		else if(var_07 < var_06)
		{
			var_01["axis"][var_01["axis"].size] = var_05;
		}
		else
		{
			var_01["allies"][var_01["allies"].size] = var_05;
		}

		if(var_06 > level.maxspawndisttohomebase["allies"])
		{
			level.maxspawndisttohomebase["allies"] = var_06;
		}

		if(var_07 > level.maxspawndisttohomebase["axis"])
		{
			level.maxspawndisttohomebase["axis"] = var_07;
		}
	}

	return var_01;
}

//Function Number: 13
getspawnpointdist(param_00,param_01)
{
	var_02 = function_00C0(param_00.origin,param_01,16000);
	if(var_02 < 0)
	{
		var_02 = distance(param_00.origin,param_01);
	}

	return var_02;
}

//Function Number: 14
getspawnpoint()
{
	var_00 = self.pers["team"];
	if(scripts\mp\_spawnlogic::shoulduseteamstartspawn())
	{
		if(game["switchedsides"])
		{
			var_00 = scripts\mp\_utility::getotherteam(var_00);
		}

		var_01 = scripts\mp\_spawnlogic::getspawnpointarray(level.spawnnodetype + "_" + var_00 + "_start");
		var_02 = scripts\mp\_spawnlogic::getspawnpoint_startspawn(var_01);
	}
	else
	{
		var_01 = scripts\mp\_spawnlogic::getteamspawnpoints(var_02);
		var_03 = scripts\mp\_spawnlogic::getteamfallbackspawnpoints(var_01);
		var_04 = [];
		var_05["homeBaseTeam"] = var_00;
		var_05["maxDistToHomeBase"] = level.maxspawndisttohomebase[var_00];
		var_02 = scripts\mp\_spawnscoring::getspawnpoint(var_01,var_03,var_05);
	}

	return var_02;
}

//Function Number: 15
run_ball()
{
	level.ball_starts = [];
	level.balls = [];
	level.ballbases = [];
	scripts\mp\_utility::func_98D3();
	ball_create_team_goal("allies");
	ball_create_team_goal("axis");
	level._effect["ball_trail"] = loadfx("vfx/core/mp/core/vfx_uplink_ball_trail.vfx");
	level._effect["ball_idle"] = loadfx("vfx/core/mp/core/vfx_uplink_ball_idle.vfx");
	level._effect["ball_download_end"] = loadfx("vfx/core/mp/core/vfx_uplink_ball_download_end.vfx");
	level._effect["ball_goal_enemy"] = loadfx("vfx/core/mp/core/vfx_uplink_goal_orng.vfx");
	level._effect["ball_goal_friendly"] = loadfx("vfx/core/mp/core/vfx_uplink_goal_cyan.vfx");
	level._effect["ball_goal_activated_enemy"] = loadfx("vfx/core/mp/core/vfx_uplink_goal_actv_orng.vfx");
	level._effect["ball_goal_activated_friendly"] = loadfx("vfx/core/mp/core/vfx_uplink_goal_actv_cyan.vfx");
	level._effect["ball_teleport"] = loadfx("vfx/core/mp/core/vfx_uplink_ball_teleport.vfx");
	level thread ball_connect_watch();
	scripts\mp\gametypes\obj_ball::ball_init_map_min_max();
	scripts\mp\gametypes\obj_ball::ball_create_ball_starts();
	for(var_00 = 0;var_00 < level.satellitecount;var_00++)
	{
		scripts\mp\gametypes\obj_ball::ball_spawn(var_00);
	}

	thread scripts\mp\gametypes\obj_ball::hideballsongameended();
	ball_goal_useobject();
	ball_goal_fx();
	initspawns();
	thread removeuplinkgoal();
	thread placeuplinkgoal();
	level.ball = level.balls[0];
}

//Function Number: 16
ball_find_ground(param_00)
{
	var_01 = self.origin + (0,0,32);
	var_02 = self.origin + (0,0,-1000);
	var_03 = scripts\common\trace::create_contents(1,1,1,1,0,1,1);
	var_04 = [];
	var_05 = scripts\common\trace::ray_trace(var_01,var_02,var_04,var_03);
	self.ground_origin = var_05["position"];
	return var_05["fraction"] != 0 && var_05["fraction"] != 1;
}

//Function Number: 17
ball_create_team_goal(param_00)
{
	var_01 = param_00;
	if(game["switchedsides"])
	{
		var_01 = scripts\mp\_utility::getotherteam(var_01);
	}

	var_02 = scripts\engine\utility::getstruct("ball_goal_" + var_01,"targetname");
	if(isdefined(var_02))
	{
		var_02 = checkpostshipgoalplacement(var_02,param_00);
		var_02 ball_find_ground();
	}
	else
	{
		var_02 = spawnstruct();
		switch(level.script)
		{
			default:
				break;
		}

		if(!isdefined(var_02.origin))
		{
			var_02.origin = level.default_goal_origins[param_00];
		}

		var_02 ball_find_ground();
	}

	if(scripts\mp\_utility::istrue(level.tactical))
	{
		var_02.origin = var_02.ground_origin + (0,0,130);
	}
	else if(scripts\mp\_utility::istrue(level.supportdoublejump_MAYBE))
	{
		if(level.mapname == "mp_frontier")
		{
			var_02.origin = var_02.ground_origin + (0,0,180);
		}
		else
		{
			var_02.origin = var_02.ground_origin + (0,0,190);
		}
	}
	else
	{
		var_02.origin = var_02.ground_origin + (0,0,130);
	}

	var_02.fgetarg = 60;
	var_02.team = param_00;
	var_02.ball_in_goal = 0;
	var_02.highestspawndistratio = 0;
	level.ball_goals[param_00] = var_02;
}

//Function Number: 18
checkpostshipgoalplacement(param_00,param_01)
{
	if(level.mapname == "mp_desert")
	{
		var_02 = (2125,71,370.344);
		if(!game["switchedsides"] && param_01 == "axis")
		{
			param_00.origin = var_02;
		}
		else if(game["switchedsides"] && param_01 == "allies")
		{
			param_00.origin = var_02;
		}
	}

	if(level.mapname == "mp_metropolis")
	{
		if(!game["switchedsides"] && param_01 == "axis")
		{
			param_00.origin = (-2039,-1464,123);
		}
		else if(game["switchedsides"] && param_01 == "allies")
		{
			param_00.origin = (-2039,-1464,123);
		}
	}

	if(level.mapname == "mp_fallen")
	{
		if(!game["switchedsides"] && param_01 == "axis")
		{
			param_00.origin = (2752,1429,988);
		}
		else if(game["switchedsides"] && param_01 == "allies")
		{
			param_00.origin = (2752,1429,988);
		}

		if(!game["switchedsides"] && param_01 == "allies")
		{
			param_00.origin = (-1866,1698,988);
		}
		else if(game["switchedsides"] && param_01 == "axis")
		{
			param_00.origin = (-1866,1698,988);
		}
	}

	return param_00;
}

//Function Number: 19
ball_connect_watch()
{
	for(;;)
	{
		level waittill("connected",var_00);
		var_00 thread scripts\mp\gametypes\obj_ball::ball_player_on_connect();
	}
}

//Function Number: 20
ball_physics_touch_goal()
{
	var_00 = self.visuals[0];
	self endon("pass_end");
	self endon("pickup_object");
	self endon("physics_finished");
	if(level.gametype != "tdef")
	{
		ball_touch_goal_watch(var_00);
	}
}

//Function Number: 21
ball_pass_touch_goal()
{
	var_00 = self.visuals[0];
	self endon("pass_end");
	if(level.gametype != "tdef")
	{
		ball_touch_goal_watch(var_00);
	}
}

//Function Number: 22
ball_touch_goal_watch(param_00)
{
	self endon("pass_end");
	self endon("pickup_object");
	self endon("physics_finished");
	for(;;)
	{
		foreach(var_05, var_02 in level.ball_goals)
		{
			if(self.lastcarrierteam == var_05)
			{
				continue;
			}

			if(!var_02.useobject ball_goal_can_use())
			{
				continue;
			}

			var_03 = distance(param_00.origin,var_02.origin);
			if(var_03 <= var_02.fgetarg)
			{
				thread ball_touched_goal(var_02);
				param_00 notify("pass_end");
				return;
			}

			if(isdefined(param_00.origin_prev))
			{
				var_04 = line_interect_sphere(param_00.origin_prev,param_00.origin,var_02.origin,var_02.fgetarg);
				if(var_04)
				{
					thread ball_touched_goal(var_02);
					param_00 notify("pass_end");
					return;
				}
			}
		}

		scripts\engine\utility::waitframe();
	}
}

//Function Number: 23
ball_goal_can_use(param_00)
{
	var_01 = self.objective_icon;
	if(var_01.ball_in_goal)
	{
		return 0;
	}

	return 1;
}

//Function Number: 24
ball_goal_contested()
{
	ball_waypoint_contest();
}

//Function Number: 25
ball_goal_uncontested(param_00)
{
	goal_waypoint();
}

//Function Number: 26
ball_carrier_touched_goal(param_00)
{
	if(!isdefined(param_00) || !isdefined(param_00.carryobject))
	{
		return;
	}

	if(isdefined(level.scorefrozenuntil) && level.scorefrozenuntil > gettime())
	{
		return;
	}

	if(istimeup())
	{
		return;
	}

	if(level.gameended)
	{
		return;
	}

	param_00 notify("goal_scored");
	var_01 = level.scorecarry;
	param_00 thread scripts\mp\_awards::givemidmatchaward("mode_uplink_dunk");
	ball_check_assist(param_00,1);
	param_00 scripts\mp\_utility::incperstat("touchdowns",1);
	param_00 scripts\mp\_persistence::statsetchild("round","touchdowns",param_00.pers["touchdowns"]);
	if(isplayer(param_00))
	{
		param_00 scripts\mp\_utility::setextrascore0(param_00.pers["touchdowns"]);
		param_00 thread scripts\mp\_matchdata::loggameevent("dunk",param_00.origin);
	}

	var_02 = self.objective_icon.team;
	var_03 = scripts\mp\_utility::getotherteam(var_02);
	scripts\mp\_utility::statusdialog("enemy_carry_score",var_02,1);
	scripts\mp\_utility::statusdialog("ally_carry_score",var_03,1);
	ball_play_score_fx(self.objective_icon);
	ball_score_sound(var_03,1);
	var_04 = param_00.carryobject;
	var_04.lastcarrierscored = 1;
	var_04 scripts\mp\gametypes\obj_ball::ball_set_dropped(1,self.trigger.origin,1);
	var_04 thread ball_score_event(self.objective_icon);
	ball_give_score(var_03,var_01);
	scripts\mp\_utility::setmlgannouncement(1,var_03,param_00 getentitynumber());
}

//Function Number: 27
should_record_final_score_cam(param_00,param_01)
{
	var_02 = scripts\mp\_gamescore::_getteamscore(param_00);
	var_03 = scripts\mp\_gamescore::_getteamscore(scripts\mp\_utility::getotherteam(param_00));
	return var_02 + param_01 >= var_03;
}

//Function Number: 28
line_interect_sphere(param_00,param_01,param_02,param_03)
{
	var_04 = vectornormalize(param_01 - param_00);
	var_05 = vectordot(var_04,param_00 - param_02);
	var_05 = var_05 * var_05;
	var_06 = param_00 - param_02;
	var_06 = var_06 * var_06;
	var_07 = param_03 * param_03;
	return var_05 - var_06 + var_07 >= 0;
}

//Function Number: 29
ball_touched_goal(param_00)
{
	if(isdefined(level.scorefrozenuntil) && level.scorefrozenuntil > gettime())
	{
		return;
	}

	if(istimeup())
	{
		return;
	}

	if(level.gameended)
	{
		return;
	}

	ball_play_score_fx(param_00);
	var_01 = level.scorethrow;
	var_02 = param_00.team;
	var_03 = scripts\mp\_utility::getotherteam(var_02);
	scripts\mp\_utility::statusdialog("enemy_throw_score",var_02,1);
	scripts\mp\_utility::statusdialog("ally_throw_score",var_03,1);
	if(isdefined(self.lastcarrier))
	{
		self.lastcarrierscored = 1;
		self.lastcarrier thread scripts\mp\_awards::givemidmatchaward("mode_uplink_fieldgoal");
		ball_check_assist(self.lastcarrier,0);
		self.lastcarrier scripts\mp\_utility::incperstat("fieldgoals",1);
		self.lastcarrier scripts\mp\_persistence::statsetchild("round","fieldgoals",self.lastcarrier.pers["fieldgoals"]);
		if(isplayer(self.lastcarrier))
		{
			self.lastcarrier scripts\mp\_utility::setextrascore1(self.lastcarrier.pers["fieldgoals"]);
			self.lastcarrier thread scripts\mp\_matchdata::loggameevent("fieldgoal",self.lastcarrier.origin);
		}
	}

	if(isdefined(self.killcament))
	{
		self.killcament unlink();
	}

	ball_score_sound(var_03,0);
	thread ball_score_event(param_00);
	ball_give_score(var_03,var_01);
	if(isdefined(self.lastcarrier))
	{
		scripts\mp\_utility::setmlgannouncement(0,var_03,self.lastcarrier getentitynumber());
		return;
	}

	scripts\mp\_utility::setmlgannouncement(0,var_03);
}

//Function Number: 30
istimeup()
{
	var_00 = scripts\mp\_utility::getwatcheddvar("timelimit");
	if(var_00 != 0)
	{
		var_01 = scripts\mp\_gamelogic::gettimeremaining();
		if(var_01 <= 0)
		{
			return 1;
		}
	}

	return 0;
}

//Function Number: 31
ball_give_score(param_00,param_01)
{
	level scripts\mp\_gamescore::giveteamscoreforobjective(param_00,param_01,0);
}

//Function Number: 32
ball_score_event(param_00)
{
	level thread scorefrozentimer();
	self notify("score_event");
	if(scripts\mp\_utility::istrue(level.practicemode))
	{
		foreach(var_02 in level.players)
		{
			if(var_02 ishost())
			{
				var_02 thread scripts\mp\gametypes\obj_ball::moveballtoplayer();
				break;
			}
		}
	}

	self.in_goal = 1;
	param_00.ball_in_goal = 1;
	var_04 = self.visuals[0];
	if(isdefined(self.projectile))
	{
		self.projectile delete();
	}

	var_04 physicslaunchserver(var_04.origin,(0,0,0));
	var_04 physicsstopserver();
	scripts\mp\_gameobjects::allowcarry("none");
	scripts\mp\gametypes\obj_ball::ball_waypoint_upload();
	var_05 = 0.4;
	var_06 = 1.2;
	var_07 = 1;
	var_08 = var_05 + var_07;
	var_09 = var_08 + var_06;
	var_04 moveto(param_00.origin,var_05,0,var_05);
	var_04 rotatevelocity((1080,1080,0),var_09,var_09,0);
	wait(var_08);
	var_04 movez(4000,var_06,var_06 * 0.1,0);
	wait(var_06);
	param_00.ball_in_goal = 0;
	scripts\mp\gametypes\obj_ball::ball_return_home(0,0);
}

//Function Number: 33
ball_check_assist(param_00,param_01)
{
	if(!isdefined(param_00.passtime) || !isdefined(param_00.passplayer))
	{
		return;
	}

	if(param_00.passtime + 3000 < gettime())
	{
		return;
	}

	if(param_01)
	{
		param_00.passplayer thread scripts\mp\_awards::givemidmatchaward("mode_uplink_allyoop");
	}
}

//Function Number: 34
ball_play_score_fx(param_00)
{
	param_00.score_fx["friendly"] hide();
	param_00.score_fx["enemy"] hide();
	foreach(var_02 in level.players)
	{
		var_03 = ball_get_view_team(var_02);
		if(var_03 == param_00.team)
		{
			param_00.score_fx["friendly"] showtoplayer(var_02);
			continue;
		}

		param_00.score_fx["enemy"] showtoplayer(var_02);
	}

	triggerfx(param_00.score_fx["friendly"]);
	triggerfx(param_00.score_fx["enemy"]);
}

//Function Number: 35
ball_waypoint_reset()
{
	scripts\mp\_gameobjects::set2dicon("friendly","waypoint_reset_marker");
	scripts\mp\_gameobjects::set2dicon("enemy","waypoint_reset_marker");
	scripts\mp\_gameobjects::set3dicon("friendly","waypoint_reset_marker");
	scripts\mp\_gameobjects::set3dicon("enemy","waypoint_reset_marker");
}

//Function Number: 36
ball_waypoint_contest()
{
	scripts\mp\_gameobjects::set2dicon("friendly","waypoint_uplink_contested");
	scripts\mp\_gameobjects::set2dicon("enemy","waypoint_uplink_contested");
	scripts\mp\_gameobjects::set3dicon("friendly","waypoint_uplink_contested");
	scripts\mp\_gameobjects::set3dicon("enemy","waypoint_uplink_contested");
}

//Function Number: 37
goal_waypoint()
{
	scripts\mp\_gameobjects::set2dicon("friendly","waypoint_blitz_defend");
	scripts\mp\_gameobjects::set2dicon("enemy","waypoint_blitz_goal");
	scripts\mp\_gameobjects::set3dicon("friendly","waypoint_blitz_defend");
	scripts\mp\_gameobjects::set3dicon("enemy","waypoint_blitz_goal");
}

//Function Number: 38
ball_score_sound(param_00,param_01)
{
	if(param_01)
	{
		scripts\mp\gametypes\obj_ball::ball_play_local_team_sound(param_00,"mp_uplink_goal_carried_friendly","mp_uplink_goal_carried_enemy");
		return;
	}

	scripts\mp\gametypes\obj_ball::ball_play_local_team_sound(param_00,"mp_uplink_goal_friendly","mp_uplink_goal_enemy");
}

//Function Number: 39
scorefrozentimer()
{
	level endon("game_ended");
	level.scorefrozenuntil = gettime() + 10000;
	foreach(var_01 in level.ball_goals)
	{
		var_01 thread dogoalreset();
	}
}

//Function Number: 40
dogoalreset()
{
	self.useobject ball_waypoint_reset();
	level scripts\engine\utility::waittill_any_timeout_1(10,"goal_ready");
	self.useobject goal_waypoint();
}

//Function Number: 41
ball_on_connect()
{
	for(;;)
	{
		level waittill("connected",var_00);
		var_00.ball_goal_fx = [];
		var_00 thread player_on_disconnect();
	}
}

//Function Number: 42
player_on_disconnect()
{
	self waittill("disconnect");
	player_delete_ball_goal_fx();
}

//Function Number: 43
ball_goal_fx_for_player(param_00)
{
	var_01 = ball_get_view_team(param_00);
	param_00 player_delete_ball_goal_fx();
	foreach(var_06, var_03 in level.ball_goals)
	{
		var_04 = scripts\engine\utility::ter_op(var_06 == var_01,"ball_goal_friendly","ball_goal_enemy");
		var_05 = function_01E1(scripts\engine\utility::getfx(var_04),var_03.origin,param_00,(1,0,0));
		var_05 setfxkilldefondelete();
		param_00.ball_goal_fx[var_04] = var_05;
		triggerfx(var_05);
	}
}

//Function Number: 44
ball_get_view_team(param_00)
{
	var_01 = param_00.team;
	if(var_01 != "allies" && var_01 != "axis")
	{
		if(param_00 ismlgspectator())
		{
			var_01 = param_00 getmlgspectatorteam();
		}
		else
		{
			var_01 = "allies";
		}
	}

	return var_01;
}

//Function Number: 45
player_delete_ball_goal_fx()
{
	if(isdefined(self.ball_goal_fx))
	{
		foreach(var_01 in self.ball_goal_fx)
		{
			if(isdefined(var_01))
			{
				var_01 delete();
			}
		}
	}
}

//Function Number: 46
goal_watch_game_ended()
{
	level waittill("bro_shot_start");
	foreach(var_01 in level.players)
	{
		var_01 player_delete_ball_goal_fx();
	}
}

//Function Number: 47
ball_play_fx_joined_team()
{
	for(;;)
	{
		level waittill("joined_team",var_00);
		ball_goal_fx_for_player(var_00);
	}
}

//Function Number: 48
onplayerkilled(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09)
{
	var_0A = self;
	var_0B = 0;
	if(!isdefined(param_01) || !isdefined(param_01.team) || !isdefined(var_0A) || !isdefined(var_0A.team))
	{
		return;
	}

	if(param_01 == var_0A)
	{
		return;
	}

	if(param_01.team == var_0A.team)
	{
		return;
	}

	var_0C = param_01.origin;
	var_0D = 0;
	if(isdefined(param_00))
	{
		var_0C = param_00.origin;
		var_0D = param_00 == param_01;
	}

	if(isdefined(param_01) && isplayer(param_01) && param_01.pers["team"] != var_0A.pers["team"])
	{
		if(isdefined(param_01.ball_carried) && var_0D)
		{
			param_01 thread scripts\mp\_awards::givemidmatchaward("mode_uplink_kill_with_ball");
			var_0B = 1;
		}

		if(isdefined(var_0A.ball_carried))
		{
			param_01 thread scripts\mp\_awards::givemidmatchaward("mode_uplink_kill_carrier");
			param_01 scripts\mp\_utility::incperstat("defends",1);
			param_01 scripts\mp\_persistence::statsetchild("round","defends",param_01.pers["defends"]);
			thread scripts\mp\_matchdata::loginitialstats(param_09,"carrying");
			scripts\mp\gametypes\obj_ball::updatetimers("neutral",1,0);
			var_0B = 1;
		}
	}

	if(!var_0B)
	{
		var_0E = 0;
		foreach(var_10 in level.balls)
		{
			var_0E = distsquaredcheck(var_0C,var_0A.origin,var_10.curorigin);
			if(var_0E && param_01.team != var_0A.team)
			{
				if(var_10.ownerteam == var_0A.team)
				{
					param_01 thread scripts\mp\_awards::givemidmatchaward("mode_x_assault");
				}
				else if(var_10.ownerteam == param_01.team)
				{
					param_01 thread scripts\mp\_awards::givemidmatchaward("mode_x_defend");
				}

				break;
			}
		}

		if(!var_0E)
		{
			foreach(var_15, var_13 in level.ball_goals)
			{
				var_14 = distsquaredcheck(var_0C,var_0A.origin,var_13.trigger.origin);
				if(var_14)
				{
					if(var_15 == var_0A.team)
					{
						param_01 thread scripts\mp\_awards::givemidmatchaward("mode_x_assault");
						continue;
					}

					param_01 thread scripts\mp\_awards::givemidmatchaward("mode_x_defend");
				}
			}
		}
	}
}

//Function Number: 49
distsquaredcheck(param_00,param_01,param_02)
{
	var_03 = distancesquared(param_02,param_00);
	var_04 = distancesquared(param_02,param_01);
	if(var_03 < 90000 || var_04 < 90000)
	{
		return 1;
	}

	return 0;
}

//Function Number: 50
onspawnplayer()
{
	self.teleporting = 0;
}

//Function Number: 51
hidehudelementongameend(param_00)
{
	level waittill("game_ended");
	if(isdefined(param_00))
	{
		param_00.alpha = 0;
	}
}

//Function Number: 52
removeuplinkgoal()
{
	self endon("game_ended");
	for(;;)
	{
		if(getdvar("scr_devRemoveDomFlag","") != "")
		{
			var_00 = getdvar("scr_devRemoveDomFlag","");
			if(var_00 == "_a")
			{
				var_01 = "allies";
			}
			else
			{
				var_01 = "axis";
			}

			level.ball_goals[var_01].useobject scripts\mp\_gameobjects::allowuse("none");
			level.ball_goals[var_01].useobject.trigger = undefined;
			level.ball_goals[var_01].useobject notify("deleted");
			foreach(var_03 in level.players)
			{
				var_03 player_delete_ball_goal_fx();
			}

			level.ball_goals[var_01].useobject.visibleteam = "none";
			level.ball_goals[var_01].useobject scripts\mp\_gameobjects::set2dicon("friendly",undefined);
			level.ball_goals[var_01].useobject scripts\mp\_gameobjects::set3dicon("friendly",undefined);
			level.ball_goals[var_01].useobject scripts\mp\_gameobjects::set2dicon("enemy",undefined);
			level.ball_goals[var_01].useobject scripts\mp\_gameobjects::set3dicon("enemy",undefined);
			setdynamicdvar("scr_devRemoveDomFlag","");
		}

		wait(1);
	}
}

//Function Number: 53
placeuplinkgoal()
{
	self endon("game_ended");
	for(;;)
	{
		if(getdvar("scr_devPlaceDomFlag","") != "")
		{
			var_00 = getdvar("scr_devPlaceDomFlag","");
			if(var_00 == "_a")
			{
				var_01 = "allies";
			}
			else
			{
				var_01 = "axis";
			}

			var_02 = spawnstruct();
			var_02.origin = level.players[0].origin;
			var_02.origin = var_02.origin + (0,0,190);
			var_02.fgetarg = 50;
			var_02.team = var_01;
			var_02.ball_in_goal = 0;
			var_02.highestspawndistratio = 0;
			level.ball_goals[var_01] = var_02;
			var_02.trigger = spawn("trigger_radius",var_02.origin - (0,0,var_02.fgetarg),0,var_02.fgetarg,var_02.fgetarg * 2);
			var_02.useobject = scripts\mp\_gameobjects::createuseobject(var_01,var_02.trigger,[],(0,0,var_02.fgetarg * 2.1));
			var_02.useobject.objective_icon = var_02;
			var_02.useobject scripts\mp\_gameobjects::set2dicon("friendly","waypoint_blitz_defend");
			var_02.useobject scripts\mp\_gameobjects::set2dicon("enemy","waypoint_blitz_goal");
			var_02.useobject scripts\mp\_gameobjects::set3dicon("friendly","waypoint_blitz_defend");
			var_02.useobject scripts\mp\_gameobjects::set3dicon("enemy","waypoint_blitz_goal");
			var_02.useobject scripts\mp\_gameobjects::setvisibleteam("any");
			var_02.useobject scripts\mp\_gameobjects::allowuse("enemy");
			var_02.useobject scripts\mp\_gameobjects::setkeyobject(level.balls);
			var_02.useobject scripts\mp\_gameobjects::setusetime(0);
			var_02.useobject scripts\mp\_gameobjects::cancontestclaim(1);
			var_02.useobject.onuse = ::ball_carrier_touched_goal;
			var_02.useobject.canuseobject = ::ball_goal_can_use;
			var_02.useobject.oncontested = ::ball_goal_contested;
			var_02.useobject.onuncontested = ::ball_goal_uncontested;
			var_02.killcament = spawn("script_model",var_02.origin + (0,0,20));
			var_02.killcament setscriptmoverkillcam("explosive");
			ball_goal_fx();
			setdynamicdvar("scr_devPlaceDomFlag","");
		}

		wait(1);
	}
}