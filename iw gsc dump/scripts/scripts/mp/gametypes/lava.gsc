/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\gametypes\lava.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 10
 * Decompile Time: 580 ms
 * Timestamp: 10/27/2023 12:12:42 AM
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
		scripts\mp\_utility::registerroundswitchdvar(level.gametype,0,0,9);
		scripts\mp\_utility::registertimelimitdvar(level.gametype,10);
		scripts\mp\_utility::registerscorelimitdvar(level.gametype,75);
		scripts\mp\_utility::registerroundlimitdvar(level.gametype,1);
		scripts\mp\_utility::registerwinlimitdvar(level.gametype,1);
		scripts\mp\_utility::registernumlivesdvar(level.gametype,0);
		scripts\mp\_utility::registerhalftimedvar(level.gametype,0);
		level.matchrules_damagemultiplier = 0;
		level.matchrules_vampirism = 0;
	}

	level.teambased = 1;
	level.onstartgametype = ::onstartgametype;
	level.getspawnpoint = ::getspawnpoint;
	level.onnormaldeath = ::onnormaldeath;
	level.onsuicidedeath = ::onsuicidedeath;
	if(level.matchrules_damagemultiplier || level.matchrules_vampirism)
	{
		level.modifyplayerdamage = ::scripts\mp\_damage::gamemodemodifyplayerdamage;
	}

	game["dialog"]["gametype"] = "tm_death";
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

	game["strings"]["overtime_hint"] = &"MP_FIRST_BLOOD";
	level thread watchplayerconnect();
}

//Function Number: 2
initializematchrules()
{
	scripts\mp\_utility::setcommonrulesfrommatchdata();
	setdynamicdvar("scr_lava_roundswitch",0);
	scripts\mp\_utility::registerroundswitchdvar("lava",0,0,9);
	setdynamicdvar("scr_lava_roundlimit",1);
	scripts\mp\_utility::registerroundlimitdvar("lava",1);
	setdynamicdvar("scr_lava_winlimit",1);
	scripts\mp\_utility::registerwinlimitdvar("lava",1);
	setdynamicdvar("scr_lava_halftime",0);
	scripts\mp\_utility::registerhalftimedvar("lava",0);
	setdynamicdvar("scr_lava_promode",0);
}

//Function Number: 3
onstartgametype()
{
	setclientnamemode("auto_change");
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

	scripts\mp\_utility::setobjectivetext("allies",&"OBJECTIVES_LAVA");
	scripts\mp\_utility::setobjectivetext("axis",&"OBJECTIVES_LAVA");
	if(level.splitscreen)
	{
		scripts\mp\_utility::setobjectivescoretext("allies",&"OBJECTIVES_LAVA");
		scripts\mp\_utility::setobjectivescoretext("axis",&"OBJECTIVES_LAVA");
	}
	else
	{
		scripts\mp\_utility::setobjectivescoretext("allies",&"OBJECTIVES_LAVA_SCORE");
		scripts\mp\_utility::setobjectivescoretext("axis",&"OBJECTIVES_LAVA_SCORE");
	}

	scripts\mp\_utility::setobjectivehinttext("allies",&"OBJECTIVES_LAVA_HINT");
	scripts\mp\_utility::setobjectivehinttext("axis",&"OBJECTIVES_LAVA_HINT");
	initspawns();
	var_02[0] = level.gametype;
	scripts\mp\_gameobjects::main(var_02);
}

//Function Number: 4
initspawns()
{
	scripts\mp\_spawnlogic::setactivespawnlogic("TDM");
	level.spawnmins = (0,0,0);
	level.spawnmaxs = (0,0,0);
	scripts\mp\_spawnlogic::addstartspawnpoints("mp_tdm_spawn_allies_start");
	scripts\mp\_spawnlogic::addstartspawnpoints("mp_tdm_spawn_axis_start");
	scripts\mp\_spawnlogic::addspawnpoints("allies","mp_tdm_spawn");
	scripts\mp\_spawnlogic::addspawnpoints("axis","mp_tdm_spawn");
	level.mapcenter = scripts\mp\_spawnlogic::findboxcenter(level.spawnmins,level.spawnmaxs);
	function_01B4(level.mapcenter);
}

//Function Number: 5
getspawnpoint()
{
	var_00 = self.pers["team"];
	if(game["switchedsides"])
	{
		var_00 = scripts\mp\_utility::getotherteam(var_00);
	}

	if(scripts\mp\_spawnlogic::shoulduseteamstartspawn())
	{
		var_01 = scripts\mp\_spawnlogic::getspawnpointarray("mp_tdm_spawn_" + var_00 + "_start");
		var_02 = scripts\mp\_spawnlogic::getspawnpoint_startspawn(var_01);
	}
	else
	{
		var_01 = scripts\mp\_spawnlogic::getteamspawnpoints(var_02);
		var_02 = scripts\mp\_spawnscoring::getspawnpoint(var_02);
	}

	return var_02;
}

//Function Number: 6
onsuicidedeath(param_00)
{
	var_01 = scripts\mp\_rank::getscoreinfovalue("score_increment");
	level scripts\mp\_gamescore::giveteamscoreforobjective(scripts\mp\_utility::getotherteam(param_00.pers["team"]),var_01,0);
}

//Function Number: 7
onnormaldeath(param_00,param_01,param_02,param_03,param_04)
{
	scripts\mp\gametypes\common::onnormaldeath(param_00,param_01,param_02,param_03,param_04);
}

//Function Number: 8
ontimelimit()
{
	if(game["status"] == "overtime")
	{
		var_00 = "forfeit";
	}
	else if(game["teamScores"]["allies"] == game["teamScores"]["axis"])
	{
		var_00 = "overtime";
	}
	else if(game["teamScores"]["axis"] > game["teamScores"]["allies"])
	{
		var_00 = "axis";
	}
	else
	{
		var_00 = "allies";
	}

	thread scripts\mp\_gamelogic::endgame(var_00,game["end_reason"]["time_limit_reached"]);
}

//Function Number: 9
watchplayerconnect()
{
	for(;;)
	{
		level waittill("connected",var_00);
		var_00 watchplayeronground();
	}
}

//Function Number: 10
watchplayeronground()
{
	self endon("disconnect");
	for(;;)
	{
		if(scripts\mp\_utility::isreallyalive(self))
		{
			if(self isonground() & !self gold_teeth_hint_func())
			{
				self dodamage(8,self.origin,self,undefined,"MOD_SUICIDE");
				wait(1);
			}
		}

		scripts\engine\utility::waitframe();
	}
}