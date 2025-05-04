/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\gametypes\dd.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 33
 * Decompile Time: 1699 ms
 * Timestamp: 10/27/2023 12:12:25 AM
*******************************************************************/

//Function Number: 1
main()
{
	if(getdvar("mapname") == "mp_background")
	{
		return;
	}

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
		scripts\mp\_utility::registerroundswitchdvar(level.gametype,1,0,9);
		scripts\mp\_utility::registertimelimitdvar(level.gametype,3);
		scripts\mp\_utility::registerscorelimitdvar(level.gametype,0);
		scripts\mp\_utility::registerroundlimitdvar(level.gametype,3);
		scripts\mp\_utility::registerwinlimitdvar(level.gametype,2);
		scripts\mp\_utility::registernumlivesdvar(level.gametype,0);
		scripts\mp\_utility::registerhalftimedvar(level.gametype,0);
		scripts\mp\_utility::func_F7D3(2);
		level.matchrules_damagemultiplier = 0;
		level.matchrules_vampirism = 0;
	}

	updategametypedvars();
	level.objectivebased = 1;
	level.teambased = 1;
	level.onprecachegametype = ::onprecachegametype;
	level.onstartgametype = ::onstartgametype;
	level.getspawnpoint = ::getspawnpoint;
	level.onspawnplayer = ::onspawnplayer;
	level.ondeadevent = ::ondeadevent;
	level.ontimelimit = ::ontimelimit;
	level.onnormaldeath = ::onnormaldeath;
	level.gamemodemaydropweapon = ::scripts\mp\_utility::isplayeroutsideofanybombsite;
	if(level.matchrules_damagemultiplier || level.matchrules_vampirism)
	{
		level.modifyplayerdamage = ::scripts\mp\_damage::gamemodemodifyplayerdamage;
	}

	level.var_4DA2 = 1;
	level.bombsplanted = 0;
	level.ddbombmodel = [];
	level.aplanted = 0;
	level.bplanted = 0;
	scripts\mp\gametypes\obj_bombzone::setbombtimeromnvars();
	game["dialog"]["gametype"] = "demolition";
	if(getdvarint("g_hardcore"))
	{
		game["dialog"]["gametype"] = "hc_" + game["dialog"]["gametype"];
	}
	else if(getdvarint("camera_thirdPerson"))
	{
		game["dialog"]["gametype"] = "thirdp_" + game["dialog"]["gametype"];
	}
	else if(getdvarint("scr_diehard"))
	{
		game["dialog"]["gametype"] = "dh_" + game["dialog"]["gametype"];
	}
	else if(getdvarint("scr_" + level.gametype + "_promode"))
	{
		game["dialog"]["gametype"] = game["dialog"]["gametype"] + "_pro";
	}

	game["dialog"]["offense_obj"] = "obj_destroy";
	game["dialog"]["defense_obj"] = "obj_defend";
	setomnvar("ui_bomb_timer_endtime_a",0);
	setomnvar("ui_bomb_timer_endtime_b",0);
	setomnvar("ui_bomb_planted_a",0);
	setomnvar("ui_bomb_planted_b",0);
}

//Function Number: 2
initializematchrules()
{
	scripts\mp\_utility::setcommonrulesfrommatchdata();
	setdynamicdvar("scr_dd_bombtimer",getmatchrulesdata("bombData","bombTimer"));
	setdynamicdvar("scr_dd_planttime",getmatchrulesdata("bombData","plantTime"));
	setdynamicdvar("scr_dd_defusetime",getmatchrulesdata("bombData","defuseTime"));
	setdynamicdvar("scr_dd_silentPlant",getmatchrulesdata("bombData","silentPlant"));
	setdynamicdvar("scr_dd_extratime",getmatchrulesdata("demData","extraTime"));
	setdynamicdvar("scr_dd_overtimeLimit",getmatchrulesdata("demData","overtimeLimit"));
	setdynamicdvar("scr_dd_halftime",0);
	scripts\mp\_utility::registerhalftimedvar("dd",0);
	setdynamicdvar("scr_dd_promode",0);
}

//Function Number: 3
onprecachegametype()
{
	game["bomb_dropped_sound"] = "mp_war_objective_lost";
	game["bomb_recovered_sound"] = "mp_war_objective_taken";
}

//Function Number: 4
onstartgametype()
{
	if(game["roundsPlayed"] == 2)
	{
		game["status"] = "overtime";
		setdvar("ui_overtime",1);
	}

	if(scripts\mp\_utility::inovertime())
	{
		setomnvar("ui_round_hint_override_attackers",1);
		setomnvar("ui_round_hint_override_defenders",1);
	}

	if(!isdefined(game["switchedsides"]))
	{
		game["switchedsides"] = 0;
	}

	if(game["switchedsides"])
	{
		var_00 = game["attackers"];
		var_01 = game["defenders"];
		game["attackers"] = var_01;
		game["defenders"] = var_00;
	}

	level.usestartspawns = 1;
	setclientnamemode("manual_change");
	if(scripts\mp\_utility::inovertime())
	{
		game["dialog"]["defense_obj"] = "obj_destroy";
	}

	level._effect["bomb_explosion"] = loadfx("vfx/iw7/_requests/mp/vfx_bombardment_strike_explosion");
	level._effect["vehicle_explosion"] = loadfx("vfx/core/expl/small_vehicle_explosion_new.vfx");
	level._effect["building_explosion"] = loadfx("vfx/iw7/_requests/mp/vfx_debug_warning.vfx");
	scripts\mp\_utility::setobjectivetext(game["attackers"],&"OBJECTIVES_DD_ATTACKER");
	scripts\mp\_utility::setobjectivetext(game["defenders"],&"OBJECTIVES_DD_DEFENDER");
	if(level.splitscreen)
	{
		scripts\mp\_utility::setobjectivescoretext(game["attackers"],&"OBJECTIVES_DD_ATTACKER");
		scripts\mp\_utility::setobjectivescoretext(game["defenders"],&"OBJECTIVES_DD_DEFENDER");
	}
	else
	{
		scripts\mp\_utility::setobjectivescoretext(game["attackers"],&"OBJECTIVES_DD_ATTACKER_SCORE");
		scripts\mp\_utility::setobjectivescoretext(game["defenders"],&"OBJECTIVES_DD_DEFENDER_SCORE");
	}

	if(scripts\mp\_utility::inovertime())
	{
		scripts\mp\_utility::setobjectivehinttext(game["attackers"],&"OBJECTIVES_DD_OVERTIME_HINT");
		scripts\mp\_utility::setobjectivehinttext(game["defenders"],&"OBJECTIVES_DD_OVERTIME_HINT");
	}
	else
	{
		scripts\mp\_utility::setobjectivehinttext(game["attackers"],&"OBJECTIVES_DD_ATTACKER_HINT");
		scripts\mp\_utility::setobjectivehinttext(game["defenders"],&"OBJECTIVES_DD_DEFENDER_HINT");
	}

	thread func_13849();
	var_02 = scripts\mp\_utility::getwatcheddvar("winlimit");
	var_03[0] = "dd";
	var_03[1] = "dd_bombzone";
	var_03[2] = "blocker";
	scripts\mp\_gameobjects::main(var_03);
	thread bombs();
	scripts\mp\_utility::func_98D3();
}

//Function Number: 5
initspawns()
{
	scripts\mp\_spawnlogic::setactivespawnlogic("TDM");
	level.spawnmins = (0,0,0);
	level.spawnmaxs = (0,0,0);
	scripts\mp\_spawnlogic::addstartspawnpoints("mp_dd_spawn_attacker");
	scripts\mp\_spawnlogic::addstartspawnpoints("mp_dd_spawn_defender");
	if(!isdefined(level.var_10DF1))
	{
		scripts\mp\_spawnlogic::addstartspawnpoints("mp_sd_spawn_attacker");
		scripts\mp\_spawnlogic::addstartspawnpoints("mp_sd_spawn_defender");
	}

	scripts\mp\_spawnlogic::addspawnpoints(game["defenders"],"mp_dd_spawn_defender");
	scripts\mp\_spawnlogic::addspawnpoints(game["defenders"],"mp_dd_spawn_defender_a",1);
	scripts\mp\_spawnlogic::addspawnpoints(game["defenders"],"mp_dd_spawn_defender_b",1);
	scripts\mp\_spawnlogic::addspawnpoints(game["attackers"],"mp_dd_spawn_attacker");
	scripts\mp\_spawnlogic::addspawnpoints(game["attackers"],"mp_dd_spawn_attacker_a",1);
	scripts\mp\_spawnlogic::addspawnpoints(game["attackers"],"mp_dd_spawn_attacker_b",1);
	scripts\mp\_spawnlogic::addspawnpoints(game["attackers"],"mp_tdm_spawn");
	level.var_1069E = scripts\mp\_spawnlogic::getspawnpointarray("mp_dd_spawn_defender");
	level.var_1069F = scripts\mp\_spawnlogic::getspawnpointarray("mp_dd_spawn_defender_a");
	level.var_1069F = scripts\engine\utility::array_combine(level.var_1069E,level.var_1069F);
	level.var_106A0 = scripts\mp\_spawnlogic::getspawnpointarray("mp_dd_spawn_defender_b");
	level.var_106A0 = scripts\engine\utility::array_combine(level.var_1069E,level.var_106A0);
	level.var_106A1 = scripts\engine\utility::array_combine(level.var_1069E,level.var_1069F,level.var_106A0);
	level.var_10644 = scripts\mp\_spawnlogic::getspawnpointarray("mp_dd_spawn_attacker");
	level.var_10645 = scripts\mp\_spawnlogic::getspawnpointarray("mp_dd_spawn_attacker_a");
	level.var_10645 = scripts\engine\utility::array_combine(level.var_10644,level.var_10645);
	level.var_10646 = scripts\mp\_spawnlogic::getspawnpointarray("mp_dd_spawn_attacker_b");
	level.var_10646 = scripts\engine\utility::array_combine(level.var_10644,level.var_10646);
	level.var_10647 = scripts\engine\utility::array_combine(level.var_10644,level.var_10645,level.var_10646);
	level.var_106A2 = scripts\mp\_spawnlogic::getspawnpointarray("mp_dd_spawn_defender_start");
	level.var_10648 = scripts\mp\_spawnlogic::getspawnpointarray("mp_dd_spawn_attacker_start");
	level.mapcenter = scripts\mp\_spawnlogic::findboxcenter(level.spawnmins,level.spawnmaxs);
	function_01B4(level.mapcenter);
}

//Function Number: 6
getspawnpointdist(param_00,param_01)
{
	var_02 = function_00C0(param_00.origin,param_01,16000);
	if(var_02 < 0)
	{
		var_02 = distance(param_00.origin,param_01);
	}

	return var_02;
}

//Function Number: 7
func_13849()
{
	level endon("game_end");
	for(;;)
	{
		if(level.ingraceperiod == 0)
		{
			break;
		}

		wait(0.05);
	}

	level.usestartspawns = 0;
}

//Function Number: 8
getspawnpoint()
{
	var_00 = self.pers["team"];
	if(level.usestartspawns)
	{
		if(var_00 == game["attackers"])
		{
			var_01 = scripts\mp\_spawnlogic::getspawnpoint_random(level.var_10648);
		}
		else
		{
			var_01 = scripts\mp\_spawnlogic::getspawnpoint_random(level.var_106A2);
		}
	}
	else
	{
		var_02 = undefined;
		if(var_00 == game["attackers"])
		{
			if(scripts\mp\_utility::inovertime())
			{
				var_02 = level.var_10644;
			}
			else if(!level.aplanted && !level.bplanted)
			{
				var_02 = level.var_10644;
			}
			else if(level.aplanted && !level.bplanted)
			{
				var_02 = level.var_10645;
			}
			else if(level.bplanted && !level.aplanted)
			{
				var_02 = level.var_10646;
			}
			else
			{
				var_02 = level.var_10644;
			}

			var_03 = level.var_10647;
			var_01 = scripts\mp\_spawnscoring::getspawnpoint(var_02,var_03);
		}
		else
		{
			if(scripts\mp\_utility::inovertime())
			{
				var_03 = level.var_1069E;
			}
			else if(!level.aplanted && !level.bplanted)
			{
				var_03 = level.var_1069E;
			}
			else if(level.aplanted && !level.bplanted)
			{
				var_03 = level.var_1069F;
			}
			else if(level.bplanted && !level.aplanted)
			{
				var_03 = level.var_106A0;
			}
			else
			{
				var_03 = level.var_1069E;
			}

			var_03 = level.var_106A1;
			var_01 = scripts\mp\_spawnscoring::getspawnpoint(var_02,var_03);
		}
	}

	return var_01;
}

//Function Number: 9
onspawnplayer()
{
	if(scripts\mp\_utility::matchmakinggame())
	{
		scripts\mp\gametypes\common::onspawnplayer();
	}

	if(scripts\mp\_utility::inovertime() || self.pers["team"] == game["attackers"])
	{
		self setclientomnvar("ui_carrying_bomb",1);
		self.isplanting = 0;
		self.isdefusing = 0;
		self.isbombcarrier = 1;
	}
	else
	{
		self.isplanting = 0;
		self.isdefusing = 0;
		self.isbombcarrier = 0;
	}

	if(isdefined(self.pers["plants"]))
	{
		scripts\mp\_utility::setextrascore0(self.pers["plants"]);
	}
	else
	{
		scripts\mp\_utility::setextrascore0(0);
	}

	if(isdefined(self.pers["defuses"]))
	{
		scripts\mp\_utility::setextrascore1(self.pers["defuses"]);
	}
	else
	{
		scripts\mp\_utility::setextrascore1(0);
	}

	level notify("spawned_player");
}

//Function Number: 10
hidecarryiconongameend()
{
	self endon("disconnect");
	level waittill("game_ended");
	if(isdefined(self.carryicon))
	{
		self.carryicon.alpha = 0;
	}
}

//Function Number: 11
func_4DA3(param_00,param_01)
{
	thread scripts\mp\_gamelogic::endgame(param_00,param_01);
}

//Function Number: 12
ondeadevent(param_00)
{
	if(level.bombexploded > 0 || level.bombdefused)
	{
		return;
	}

	if(param_00 == "all")
	{
		if(level.bombplanted)
		{
			func_4DA3(game["attackers"],game["end_reason"][game["defenders"] + "_eliminated"]);
			return;
		}

		func_4DA3(game["defenders"],game["end_reason"][game["attackers"] + "_eliminated"]);
		return;
	}

	if(param_00 == game["attackers"])
	{
		if(level.bombplanted)
		{
			return;
		}

		level thread func_4DA3(game["defenders"],game["end_reason"][game["attackers"] + "_eliminated"]);
		return;
	}

	if(param_00 == game["defenders"])
	{
		level thread func_4DA3(game["attackers"],game["end_reason"][game["defenders"] + "_eliminated"]);
		return;
	}
}

//Function Number: 13
onnormaldeath(param_00,param_01,param_02,param_03,param_04)
{
	scripts\mp\gametypes\common::onnormaldeath(param_00,param_01,param_02,param_03,param_04);
	var_05 = param_00.team;
	if(param_00.isplanting)
	{
		thread scripts\mp\_matchdata::loginitialstats(param_02,"planting");
		param_01 scripts\mp\_utility::incperstat("defends",1);
		param_01 scripts\mp\_persistence::statsetchild("round","defends",param_01.pers["defends"]);
	}
	else if(param_00.isdefusing)
	{
		thread scripts\mp\_matchdata::loginitialstats(param_02,"defusing");
		param_01 scripts\mp\_utility::incperstat("defends",1);
		param_01 scripts\mp\_persistence::statsetchild("round","defends",param_01.pers["defends"]);
	}

	scripts\mp\gametypes\obj_bombzone::bombzone_awardgenericbombzonemedals(param_01,param_00);
}

//Function Number: 14
ontimelimit()
{
	if(scripts\mp\_utility::inovertime())
	{
		func_4DA3("tie",game["end_reason"]["time_limit_reached"]);
		return;
	}

	func_4DA3(game["defenders"],game["end_reason"]["time_limit_reached"]);
}

//Function Number: 15
updategametypedvars()
{
	scripts\mp\gametypes\common::updategametypedvars();
	level.planttime = scripts\mp\_utility::dvarfloatvalue("planttime",5,0,20);
	level.defusetime = scripts\mp\_utility::dvarfloatvalue("defusetime",5,0,20);
	level.bombtimer = scripts\mp\_utility::dvarintvalue("bombtimer",45,1,300);
	level.var_4DA5 = scripts\mp\_utility::dvarfloatvalue("extraTime",2,0,5);
	level.var_C82B = scripts\mp\_utility::dvarfloatvalue("overtimeLimit",1,0,5);
	scripts\mp\_utility::func_F7D3(level.var_C82B);
	level.silentplant = scripts\mp\_utility::dvarintvalue("silentPlant",0,0,1);
}

//Function Number: 16
func_132A2(param_00)
{
	var_01 = "";
	if(param_00.size != 3)
	{
		var_02 = 0;
		var_03 = 0;
		var_04 = 0;
		foreach(var_06 in param_00)
		{
			if(issubstr(tolower(var_06.script_label),"a"))
			{
				var_02 = 1;
				continue;
			}

			if(issubstr(tolower(var_06.script_label),"b"))
			{
				var_03 = 1;
				continue;
			}

			if(issubstr(tolower(var_06.script_label),"c"))
			{
				var_04 = 1;
			}
		}

		if(!var_02)
		{
			var_01 = var_01 + " A ";
		}

		if(!var_03)
		{
			var_01 = var_01 + " B ";
		}

		if(!var_04)
		{
			var_01 = var_01 + " C ";
		}
	}

	if(var_01 != "")
	{
	}
}

//Function Number: 17
bombs()
{
	level.bombplanted = 0;
	level.bombdefused = 0;
	level.bombexploded = 0;
	level.multibomb = 1;
	level.bombzones = [];
	var_00 = getentarray("dd_bombzone","targetname");
	level.objectives = var_00;
	func_132A2(var_00);
	for(var_01 = 0;var_01 < var_00.size;var_01++)
	{
		var_02 = scripts\mp\gametypes\obj_bombzone::bombzone_setupobjective(var_01);
		if(isdefined(var_02))
		{
			var_02.onbeginuse = ::onbeginuse;
			var_02.onenduse = ::onenduse;
			var_02.onuse = ::onuseplantobject;
			level.bombzones[level.bombzones.size] = var_02;
		}
	}

	for(var_01 = 0;var_01 < level.bombzones.size;var_01++)
	{
		var_03 = [];
		for(var_04 = 0;var_04 < level.bombzones.size;var_04++)
		{
			if(var_04 != var_01)
			{
				var_03[var_03.size] = level.bombzones[var_04];
			}
		}

		level.bombzones[var_01].otherbombzones = var_03;
	}

	thread initspawns();
}

//Function Number: 18
onbeginuse(param_00)
{
	scripts\mp\gametypes\obj_bombzone::bombzone_onbeginuse(param_00);
}

//Function Number: 19
onenduse(param_00,param_01,param_02)
{
	scripts\mp\gametypes\obj_bombzone::bombzone_onenduse(param_00,param_01,param_02);
}

//Function Number: 20
onuseplantobject(param_00)
{
	scripts\mp\gametypes\obj_bombzone::bombzone_onuseplantobject(param_00);
}

//Function Number: 21
setupkillcament()
{
	var_00 = spawn("script_origin",self.origin);
	var_00.angles = self.angles;
	var_00 rotateyaw(-45,0.05);
	wait(0.05);
	var_01 = self.origin + (0,0,5);
	var_02 = self.origin + anglestoforward(var_00.angles) * 100 + (0,0,128);
	var_03 = bullettrace(var_01,var_02,0,self);
	self.killcament = spawn("script_model",var_03["position"]);
	self.killcament setscriptmoverkillcam("explosive");
	var_00 delete();
}

//Function Number: 22
func_E249()
{
	if(scripts\mp\_utility::inovertime())
	{
		scripts\mp\_gameobjects::setownerteam("neutral");
		scripts\mp\_gameobjects::allowuse("any");
		var_00 = "waypoint_target_b";
		var_01 = "waypoint_target_b";
	}
	else
	{
		scripts\mp\_gameobjects::allowuse("enemy");
		var_00 = "waypoint_defend" + self.label;
		var_01 = "waypoint_target" + self.label;
	}

	self.id = "bomb_zone";
	scripts\mp\_gameobjects::setusetime(level.planttime);
	scripts\mp\_gameobjects::setusetext(&"MP_PLANTING_EXPLOSIVE");
	scripts\mp\_gameobjects::setusehinttext(&"PLATFORM_HOLD_TO_PLANT_EXPLOSIVES");
	scripts\mp\_gameobjects::set2dicon("friendly",var_00);
	scripts\mp\_gameobjects::set3dicon("friendly",var_00);
	scripts\mp\_gameobjects::set2dicon("enemy",var_01);
	scripts\mp\_gameobjects::set3dicon("enemy",var_01);
	scripts\mp\_gameobjects::setvisibleteam("any");
	self.useweapon = "briefcase_bomb_mp";
	self.bombexploded = undefined;
}

//Function Number: 23
func_FAAE()
{
	if(scripts\mp\_utility::inovertime())
	{
		var_00 = "waypoint_defuse";
		var_01 = "waypoint_defend";
	}
	else
	{
		var_00 = "waypoint_defuse" + self.label;
		var_01 = "waypoint_defend" + self.label;
	}

	scripts\mp\_gameobjects::allowuse("friendly");
	scripts\mp\_gameobjects::setusetime(level.defusetime);
	scripts\mp\_gameobjects::setusetext(&"MP_DEFUSING_EXPLOSIVE");
	scripts\mp\_gameobjects::setusehinttext(&"PLATFORM_HOLD_TO_DEFUSE_EXPLOSIVES");
	scripts\mp\_gameobjects::setkeyobject(undefined);
	scripts\mp\_gameobjects::set2dicon("friendly",var_00);
	scripts\mp\_gameobjects::set3dicon("friendly",var_00);
	scripts\mp\_gameobjects::set2dicon("enemy",var_01);
	scripts\mp\_gameobjects::set3dicon("enemy",var_01);
	scripts\mp\_gameobjects::setvisibleteam("any");
}

//Function Number: 24
oncantuse(param_00)
{
	param_00 iprintlnbold(&"MP_BOMBSITE_IN_USE");
}

//Function Number: 25
onreset()
{
}

//Function Number: 26
bombplanted(param_00,param_01)
{
	param_00 endon("defused");
	var_02 = param_01.team;
	level.bombsplanted = level.bombsplanted + 1;
	func_F66E();
	scripts\mp\_gamelogic::pausetimer();
	level.timepausestart = gettime();
	level.timelimitoverride = 1;
	level.bombplanted = 1;
	level.destroyedobject = param_00;
	if(level.destroyedobject.label == "_a")
	{
		level.aplanted = 1;
	}
	else
	{
		level.bplanted = 1;
	}

	level.destroyedobject.bombplanted = 1;
	level.tickingobject = param_00.visuals[0];
	func_5D23(param_01,param_00.label);
	param_00.bombdefused = 0;
	param_00 scripts\mp\_gameobjects::allowuse("none");
	param_00 scripts\mp\_gameobjects::setvisibleteam("none");
	if(scripts\mp\_utility::inovertime())
	{
		param_00 scripts\mp\_gameobjects::setownerteam(level.otherteam[param_01.team]);
	}

	param_00 func_FAAE();
	param_00 bombtimerwait(param_00);
	param_00 thread func_2C59(param_01,"explode",var_02);
}

//Function Number: 27
func_2C59(param_00,param_01,param_02)
{
	level.bombsplanted = level.bombsplanted - 1;
	if(self.label == "_a")
	{
		level.aplanted = 0;
	}
	else
	{
		level.bplanted = 0;
	}

	restarttimer();
	scripts\mp\gametypes\obj_bombzone::setbombtimeromnvars();
	if(level.gameended)
	{
		return;
	}

	if(param_01 == "explode")
	{
		self.bombexploded = 1;
		if(!scripts\mp\_utility::inovertime() && level.bombexploded < 2 && level.var_4DA5 > 0)
		{
			level.extratime = level.bombexploded * level.var_4DA5;
			var_03 = scripts\mp\_gamelogic::gettimeremaining();
			function_01AF(gettime() + int(var_03));
		}

		wait(2);
		if(scripts\mp\_utility::inovertime() || level.bombexploded > 1)
		{
			func_4DA3(param_02,game["end_reason"]["target_destroyed"]);
			return;
		}

		if(level.var_4DA5 > 0)
		{
			level thread scripts\mp\_utility::teamplayercardsplash("callout_time_added",param_00);
			return;
		}

		return;
	}

	param_00 notify("bomb_defused" + self.label);
	self notify("defused");
	func_E249();
}

//Function Number: 28
func_F66E()
{
	if(level.bombsplanted == 1)
	{
		setomnvar("ui_bomb_timer",2);
		return;
	}

	if(level.bombsplanted == 2)
	{
		setomnvar("ui_bomb_timer",3);
		return;
	}

	setomnvar("ui_bomb_timer",0);
}

//Function Number: 29
func_5D23(param_00,param_01)
{
	var_02 = bullettrace(param_00.origin + (0,0,20),param_00.origin - (0,0,2000),0,param_00);
	var_03 = randomfloat(360);
	var_04 = (cos(var_03),sin(var_03),0);
	var_04 = vectornormalize(var_04 - var_02["normal"] * vectordot(var_04,var_02["normal"]));
	var_05 = vectortoangles(var_04);
	level.ddbombmodel[param_01] = spawn("script_model",var_02["position"]);
	level.ddbombmodel[param_01].angles = var_05;
	level.ddbombmodel[param_01] setmodel("prop_suitcase_bomb");
}

//Function Number: 30
restarttimer()
{
	if(scripts\mp\_utility::inovertime())
	{
		if(level.bombexploded == 1)
		{
			return;
		}
	}
	else if(level.bombexploded > 1)
	{
		return;
	}

	if(level.bombsplanted <= 0)
	{
		scripts\mp\_gamelogic::resumetimer();
		level.timepaused = gettime() - level.timepausestart;
		level.timelimitoverride = 0;
	}
}

//Function Number: 31
bombtimerwait(param_00)
{
	level endon("game_ended");
	level endon("bomb_defused" + param_00.label);
	if(scripts\mp\_utility::inovertime())
	{
		param_00.var_13845 = level.bombtimer;
	}
	else
	{
		param_00.var_13845 = level.bombtimer;
	}

	level thread func_12E43(param_00);
	while(param_00.var_13845 >= 0)
	{
		param_00.var_13845--;
		if(param_00.var_13845 >= 0)
		{
			wait(1);
		}

		scripts\mp\_hostmigration::waittillhostmigrationdone();
	}
}

//Function Number: 32
func_12E43(param_00)
{
	level endon("game_ended");
	level endon("disconnect");
	level endon("bomb_defused" + param_00.label);
	level endon("bomb_exploded" + param_00.label);
	var_01 = param_00.var_13845 * 1000 + gettime();
	setdvar("ui_bombtimer" + param_00.label,var_01);
	level waittill("host_migration_begin");
	var_02 = scripts\mp\_hostmigration::waittillhostmigrationdone();
	if(var_02 > 0)
	{
		setdvar("ui_bombtimer" + param_00.label,var_01 + var_02);
	}
}

//Function Number: 33
bombdefused(param_00)
{
	level.tickingobject scripts\mp\_gamelogic::stoptickingsound();
	param_00.bombdefused = 1;
	level notify("bomb_defused" + param_00.label);
}