/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\gametypes\koth.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 43
 * Decompile Time: 2138 ms
 * Timestamp: 10/27/2023 12:12:41 AM
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
		scripts\mp\_utility::registertimelimitdvar(level.gametype,30);
		scripts\mp\_utility::registerscorelimitdvar(level.gametype,300);
		scripts\mp\_utility::registerroundlimitdvar(level.gametype,1);
		scripts\mp\_utility::registerwinlimitdvar(level.gametype,1);
		scripts\mp\_utility::registernumlivesdvar(level.gametype,0);
		scripts\mp\_utility::registerhalftimedvar(level.gametype,0);
		level.matchrules_damagemultiplier = 0;
		level.matchrules_vampirism = 0;
	}

	updategametypedvars();
	level.hpstarttime = 0;
	level.scoreperplayer = undefined;
	level.teambased = 1;
	if(scripts\mp\_utility::isanymlgmatch())
	{
		level.var_112BF = 0;
	}

	level.onstartgametype = ::onstartgametype;
	level.getspawnpoint = ::getspawnpoint;
	level.onspawnplayer = ::onspawnplayer;
	level.onplayerkilled = ::onplayerkilled;
	level.onrespawndelay = ::getrespawndelay;
	level.lastcaptime = gettime();
	level.alliescapturing = [];
	level.axiscapturing = [];
	level.lastcaptureteam = undefined;
	level.previousclosespawnent = undefined;
	if(level.matchrules_damagemultiplier || level.matchrules_vampirism)
	{
		level.modifyplayerdamage = ::scripts\mp\_damage::gamemodemodifyplayerdamage;
	}

	game["dialog"]["gametype"] = "hardpoint";
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

	game["dialog"]["offense_obj"] = "capture_obj";
	game["dialog"]["defense_obj"] = "capture_obj";
	game["dialog"]["obj_destroyed"] = "obj_destroyed";
	game["dialog"]["obj_captured"] = "obj_captured";
	thread onplayerconnect();
	thread writeplayerrotationscoretomatchdataongameend();
}

//Function Number: 2
initializematchrules()
{
	scripts\mp\_utility::setcommonrulesfrommatchdata();
	setdynamicdvar("scr_koth_zoneLifetime",getmatchrulesdata("kothData","zoneLifetime"));
	setdynamicdvar("scr_koth_zoneCaptureTime",getmatchrulesdata("kothData","zoneCaptureTime"));
	setdynamicdvar("scr_koth_zoneActivationDelay",getmatchrulesdata("kothData","zoneActivationDelay"));
	setdynamicdvar("scr_koth_randomLocationOrder",getmatchrulesdata("kothData","randomLocationOrder"));
	setdynamicdvar("scr_koth_additiveScoring",getmatchrulesdata("kothData","additiveScoring"));
	setdynamicdvar("scr_koth_pauseTime",getmatchrulesdata("kothData","pauseTime"));
	setdynamicdvar("scr_koth_delayPlayer",getmatchrulesdata("kothData","delayPlayer"));
	setdynamicdvar("scr_koth_useHQRules",getmatchrulesdata("kothData","useHQRules"));
	setdynamicdvar("scr_koth_halftime",0);
	scripts\mp\_utility::registerhalftimedvar("koth",0);
}

//Function Number: 3
onstartgametype()
{
	scripts\mp\_utility::setobjectivetext("allies",&"OBJECTIVES_KOTH");
	scripts\mp\_utility::setobjectivetext("axis",&"OBJECTIVES_KOTH");
	if(level.splitscreen)
	{
		scripts\mp\_utility::setobjectivescoretext("allies",&"OBJECTIVES_KOTH");
		scripts\mp\_utility::setobjectivescoretext("axis",&"OBJECTIVES_KOTH");
	}
	else
	{
		scripts\mp\_utility::setobjectivescoretext("allies",&"OBJECTIVES_KOTH_SCORE");
		scripts\mp\_utility::setobjectivescoretext("axis",&"OBJECTIVES_KOTH_SCORE");
	}

	scripts\mp\_utility::setobjectivehinttext("allies",&"OBJECTIVES_KOTH_HINT");
	scripts\mp\_utility::setobjectivehinttext("axis",&"OBJECTIVES_KOTH_HINT");
	setclientnamemode("auto_change");
	var_00[0] = "hardpoint";
	var_00[1] = "tdm";
	scripts\mp\_gameobjects::main(var_00);
	level thread setupzones();
	level thread setupzoneareabrushes();
	initspawns();
	level thread hardpointmainloop();
}

//Function Number: 4
updategametypedvars()
{
	scripts\mp\gametypes\common::updategametypedvars();
	level.zoneduration = scripts\mp\_utility::dvarfloatvalue("zoneLifetime",60,0,300);
	level.zonecapturetime = scripts\mp\_utility::dvarfloatvalue("zoneCaptureTime",0,0,30);
	level.zoneactivationdelay = scripts\mp\_utility::dvarfloatvalue("zoneActivationDelay",0,0,60);
	level.zonerandomlocationorder = scripts\mp\_utility::dvarintvalue("randomLocationOrder",0,0,1);
	level.zoneadditivescoring = scripts\mp\_utility::dvarintvalue("additiveScoring",0,0,1);
	level.pausemodetimer = scripts\mp\_utility::dvarintvalue("pauseTime",1,0,1);
	level.delayplayer = scripts\mp\_utility::dvarintvalue("delayPlayer",0,0,1);
	level.usehqrules = scripts\mp\_utility::dvarintvalue("useHQRules",0,0,1);
}

//Function Number: 5
seticonnames()
{
	level.icontarget = "waypoint_hardpoint_target";
	level.iconneutral = "koth_neutral";
	level.iconcapture = "koth_enemy";
	level.icondefend = "koth_friendly";
	level.iconcontested = "waypoint_hardpoint_contested";
	level.icontaking = "waypoint_taking_chevron";
	level.iconlosing = "waypoint_hardpoint_losing";
}

//Function Number: 6
hardpointmainloop()
{
	level endon("game_ended");
	seticonnames();
	setomnvar("ui_uplink_timer_stopped",1);
	setomnvar("ui_hardpoint_timer",0);
	level.zone = getfirstzone();
	level.kothhillrotation = 0;
	level.zone.gameobject scripts\mp\gametypes\obj_zonecapture::activatezone();
	level.favorclosespawnent = level.zone;
	level.zone.gameobject.var_19 = 1;
	level.zone.gameobject scripts\mp\_gameobjects::setvisibleteam("any");
	level.zone.gameobject scripts\mp\_gameobjects::setzonestatusicons(level.icontarget);
	level.zone.gameobject thread scripts\mp\_matchdata::loggameevent("hill_moved",level.zone.origin);
	scripts\mp\_utility::gameflagwait("prematch_done");
	level.zoneendtime = int(gettime() + 5000);
	setomnvar("ui_hardpoint_timer",level.zoneendtime);
	setomnvar("ui_uplink_timer_stopped",0);
	wait(5);
	scripts\mp\_utility::statusdialog("hp_new_location","allies");
	scripts\mp\_utility::statusdialog("hp_new_location","axis");
	scripts\mp\_utility::playsoundonplayers("mp_killstreak_radar");
	for(;;)
	{
		if(!isdefined(level.mapcalloutsready))
		{
			level thread setupzonecallouts();
		}

		level.objectivesetorder = 1;
		waittillframeend;
		level.zone.gameobject scripts\mp\_gameobjects::enableobject();
		level.zone.gameobject.capturecount = 0;
		if(getdvarint("com_codcasterEnabled",0) == 1)
		{
			level.zone.gameobject thread scripts\mp\gametypes\obj_zonecapture::trackgametypevips();
		}

		scripts\mp\_spawnlogic::clearlastteamspawns();
		hqactivatenextzone();
		scripts\mp\_spawnlogic::clearlastteamspawns();
		hpcaptureloop();
		var_00 = level.zone.gameobject scripts\mp\_gameobjects::getownerteam();
		if(level.timerstoppedforgamemode && level.pausemodetimer)
		{
			level scripts\mp\_gamelogic::resumetimer();
		}

		level.lastcaptureteam = undefined;
		level.zone.gameobject killhardpointvfx();
		level.zone.gameobject.var_19 = 0;
		if(level.usehpzonebrushes)
		{
			foreach(var_02 in level.players)
			{
				level.zone.gameobject scripts\mp\gametypes\obj_zonecapture::hideplayerspecificbrushes(var_02);
			}
		}

		level.zone.gameobject scripts\mp\_gameobjects::disableobject();
		level.zone.gameobject scripts\mp\_gameobjects::allowuse("none");
		level.zone.gameobject scripts\mp\_gameobjects::setownerteam("neutral");
		updateservericons("zone_shift",0);
		level notify("zone_reset");
		spawn_next_zone();
		if(level.gametype == "grnd" && level.kothhillrotation == 1)
		{
			scripts\mp\killstreaks\_airdrop::dropzoneaddcratetypes();
		}

		wait(0.5);
		if(level.usehqrules)
		{
			thread forcespawnplayers();
		}

		wait(0.5);
	}
}

//Function Number: 7
killhardpointvfx()
{
	foreach(var_01 in level.players)
	{
		foreach(var_03 in var_01._hardpointeffect)
		{
			var_01._hardpointeffect = scripts\engine\utility::array_remove(var_01._hardpointeffect,var_03);
			if(isdefined(var_03))
			{
				var_03 delete();
			}
		}
	}

	if(isdefined(self.neutralhardpointfx) && self.neutralhardpointfx.size > 0)
	{
		foreach(var_03 in self.neutralhardpointfx)
		{
			var_03 delete();
		}
	}

	self.neutralhardpointfx = [];
}

//Function Number: 8
getfirstzone()
{
	var_00 = level.zones[0];
	level.prevzoneindex = 0;
	return var_00;
}

//Function Number: 9
getnextzone()
{
	if(level.zonerandomlocationorder)
	{
		var_13["allies"] = (0,0,0);
		var_13["axis"] = (0,0,0);
		var_01 = scripts\mp\_utility::getpotentiallivingplayers();
		foreach(var_03 in var_01)
		{
			if(var_03.team == "spectator")
			{
				continue;
			}

			var_13[var_03.team] = var_13[var_03.team] + var_03.origin;
		}

		var_05 = scripts\mp\_utility::getteamarray("allies");
		var_06 = max(var_05.size,1);
		var_07 = scripts\mp\_utility::getteamarray("axis");
		var_08 = max(var_07.size,1);
		var_09["allies"] = var_13["allies"] / var_06;
		var_09["axis"] = var_13["axis"] / var_08;
		if(!isdefined(level.prevzonelist) || isdefined(level.prevzonelist) && level.prevzonelist.size == level.zones.size - 1)
		{
			level.prevzonelist = [];
		}

		level.prevzonelist[level.prevzonelist.size] = level.prevzoneindex;
		var_0A = 0.7;
		var_0B = 0.3;
		var_0C = undefined;
		var_0D = undefined;
		for(var_0E = 0;var_0E < level.zones.size;var_0E++)
		{
			var_0F = 0;
			foreach(var_11 in level.prevzonelist)
			{
				if(var_0E == var_11)
				{
					var_0F = 1;
					break;
				}
			}

			if(var_0F)
			{
				continue;
			}

			var_13 = level.zones[var_0E];
			var_14 = distance2dsquared(var_13.gameobject.curorigin,var_09["allies"]);
			var_15 = distance2dsquared(var_13.gameobject.curorigin,var_09["axis"]);
			var_16 = distance2dsquared(var_13.gameobject.curorigin,level.zone.gameobject.curorigin);
			var_17 = var_14 + var_15 * var_0A + var_16 * var_0B;
			if(!isdefined(var_0D) || var_17 > var_0D)
			{
				var_0D = var_17;
				var_0C = var_0E;
			}
		}

		var_13 = level.zones[var_0C];
		level.prevzoneindex = var_0C;
	}
	else
	{
		var_18 = level.prevzoneindex + 1 % level.zones.size;
		var_13 = level.zones[var_18];
		level.prevzoneindex = var_18;
	}

	return var_13;
}

//Function Number: 10
spawn_next_zone()
{
	writecurrentrotationteamscore();
	scripts\mp\_utility::setmlgannouncement(5,"free");
	level.zone.gameobject scripts\mp\gametypes\obj_zonecapture::deactivatezone();
	level.zone = getnextzone();
	level.kothhillrotation++;
	level.zone.gameobject scripts\mp\gametypes\obj_zonecapture::activatezone();
	level.favorclosespawnent = level.zone;
	level.zone.gameobject.var_19 = 1;
	level.zone.gameobject.lastactivatetime = gettime();
	var_00 = int(level.zone.script_label);
	level.zone.gameobject.neutralbrush = level.neutralzonebrushes[var_00 - 1];
	level.zone.gameobject.friendlybrush = level.friendlyzonebrushes[var_00 - 1];
	level.zone.gameobject.enemybrush = level.enemyzonebrushes[var_00 - 1];
	level.zone.gameobject.contestedbrush = level.contestedzonebrushes[var_00 - 1];
	if(level.zoneactivationdelay > 0)
	{
		level.zone.gameobject scripts\mp\_gameobjects::setzonestatusicons(level.icontarget);
	}
	else
	{
		level.zone.gameobject scripts\mp\_gameobjects::setzonestatusicons(level.iconneutral);
	}

	level.zone.gameobject thread scripts\mp\_matchdata::loggameevent("hill_moved",level.zone.origin);
}

//Function Number: 11
hqactivatenextzone()
{
	scripts\mp\_utility::statusdialog("hp_new_location","allies");
	scripts\mp\_utility::statusdialog("hp_new_location","axis");
	scripts\mp\_utility::playsoundonplayers("mp_killstreak_radar");
	level.zone.gameobject thread scripts\mp\gametypes\obj_zonecapture::hardpoint_setneutral();
	level.zone.gameobject scripts\mp\_gameobjects::allowuse("none");
	if(level.zoneactivationdelay)
	{
		level.zone.gameobject scripts\mp\_gameobjects::setzonestatusicons(level.icontarget);
		updateservericons("zone_activation_delay",0);
		level.zoneendtime = int(gettime() + 1000 * level.zoneactivationdelay);
		setomnvar("ui_hardpoint_timer",level.zoneendtime);
	}

	wait(level.zoneactivationdelay);
	level.zone.gameobject scripts\mp\_gameobjects::setzonestatusicons(level.iconneutral);
	updateservericons("neutral",0);
	if(level.zoneduration)
	{
		updateservericons("neutral",0);
		if(level.usehqrules)
		{
			thread locktimeruntilcap();
			return;
		}

		thread movezoneaftertime(level.zoneduration);
		level.zoneendtime = int(gettime() + 1000 * level.zoneduration);
		setomnvar("ui_hardpoint_timer",level.zoneendtime);
		return;
	}

	level.zonedestroyedbytimer = 0;
}

//Function Number: 12
locktimeruntilcap()
{
	level endon("zone_captured");
	for(;;)
	{
		level.zoneendtime = int(gettime() + 1000 * level.zoneduration);
		setomnvar("ui_hardpoint_timer",level.zoneendtime);
		wait(0.05);
	}
}

//Function Number: 13
hpcaptureloop()
{
	level endon("game_ended");
	level endon("zone_moved");
	level.hpstarttime = gettime();
	for(;;)
	{
		level.zone.gameobject scripts\mp\_gameobjects::allowuse("enemy");
		level.zone.gameobject scripts\mp\_gameobjects::setvisibleteam("any");
		level.zone.gameobject scripts\mp\_gameobjects::setusetext(&"MP_SECURING_POSITION");
		if(!level.usehqrules)
		{
			level.zone.gameobject thread scripts\mp\gametypes\obj_zonecapture::hardpoint_setneutral();
			level.zone.gameobject scripts\mp\_gameobjects::cancontestclaim(1);
		}

		if(isdefined(level.matchrules_droptime) && level.matchrules_droptime)
		{
			level thread scripts\mp\gametypes\grnd::randomdrops();
		}

		var_00 = level scripts\engine\utility::waittill_any_return("zone_captured","zone_destroyed");
		if(var_00 == "zone_destroyed")
		{
			continue;
		}

		var_01 = level.zone.gameobject scripts\mp\_gameobjects::getownerteam();
		thread func_12F03();
		if(level.usehqrules && level.zoneduration > 0)
		{
			thread movezoneaftertime(level.zoneduration);
		}

		level waittill("zone_destroyed",var_02);
		level.spawndelay = undefined;
		if(isdefined(var_02))
		{
			level.zone.gameobject scripts\mp\_gameobjects::setownerteam(var_02);
		}
		else
		{
			level.zone.gameobject scripts\mp\_gameobjects::setownerteam("none");
		}

		if(level.usehqrules)
		{
			break;
		}
	}
}

//Function Number: 14
func_12F03()
{
	level endon("game_ended");
	level endon("zone_moved");
	level endon("zone_destroyed");
	var_00 = gettime();
	if(level.zoneduration > 0)
	{
		var_01 = var_00 + level.zoneduration * 1000;
	}
	else
	{
		var_01 = var_01 + scripts\mp\_utility::gettimelimit() * 60 * 1000 - scripts\mp\_utility::gettimepassed();
	}

	var_02 = var_00;
	while(var_02 < var_01)
	{
		var_02 = gettime();
		level.spawndelay = var_01 - var_02 / 1000;
		wait(0.05);
	}
}

//Function Number: 15
initspawns()
{
	scripts\mp\_spawnlogic::setactivespawnlogic("Hardpoint");
	level.spawnmins = (0,0,0);
	level.spawnmaxs = (0,0,0);
	scripts\mp\_spawnlogic::addstartspawnpoints("mp_koth_spawn_allies_start");
	scripts\mp\_spawnlogic::addstartspawnpoints("mp_koth_spawn_axis_start");
	scripts\mp\_spawnlogic::addspawnpoints("allies","mp_koth_spawn",1);
	scripts\mp\_spawnlogic::addspawnpoints("allies","mp_koth_spawn_secondary",1,1);
	scripts\mp\_spawnlogic::addspawnpoints("axis","mp_koth_spawn",1);
	scripts\mp\_spawnlogic::addspawnpoints("axis","mp_koth_spawn_secondary",1,1);
	if(!isdefined(level.spawnpoints))
	{
		scripts\mp\_spawnlogic::addspawnpoints("allies","mp_tdm_spawn");
		scripts\mp\_spawnlogic::addspawnpoints("allies","mp_tdm_spawn_secondary",1,1);
		scripts\mp\_spawnlogic::addspawnpoints("axis","mp_tdm_spawn");
		scripts\mp\_spawnlogic::addspawnpoints("axis","mp_tdm_spawn_secondary",1,1);
	}

	level.mapcenter = scripts\mp\_spawnlogic::findboxcenter(level.spawnmins,level.spawnmaxs);
	function_01B4(level.mapcenter);
	var_00 = [];
	foreach(var_02 in level.zones)
	{
		var_02.furthestspawndistsq = 0;
		var_02.spawnpoints = [];
		var_02.fallbackspawnpoints = [];
		var_00[var_02.script_label] = var_02;
	}

	foreach(var_05 in level.spawnpoints)
	{
		calculatespawndisttozones(var_05);
		var_06 = scripts\mp\_spawnlogic::getoriginidentifierstring(var_05);
		if(isdefined(level.kothextraprimaryspawnpoints) && isdefined(level.kothextraprimaryspawnpoints[var_06]))
		{
			foreach(var_08 in level.kothextraprimaryspawnpoints[var_06])
			{
				var_02 = var_00[var_08];
				var_02.spawnpoints[var_02.spawnpoints.size] = var_05;
			}
		}

		var_0A = 0;
		var_0B = var_05.classname == "mp_koth_spawn";
		var_0C = var_05.classname == "mp_koth_spawn_secondary";
		if(var_0B || var_0C)
		{
			if(isdefined(var_05.script_noteworthy) && var_05.script_noteworthy != "")
			{
				var_0A = 1;
				var_0D = strtok(var_05.script_noteworthy," ");
				foreach(var_08 in var_0D)
				{
					if(!postshipmodifiedzones(var_08))
					{
						var_02 = var_00[var_08];
						if(var_0B)
						{
							var_02.spawnpoints[var_02.spawnpoints.size] = var_05;
							continue;
						}

						var_02.fallbackspawnpoints[var_02.fallbackspawnpoints.size] = var_05;
					}
				}
			}
		}

		if(!var_0A)
		{
			foreach(var_02 in level.zones)
			{
				if(var_0B)
				{
					var_02.spawnpoints[var_02.spawnpoints.size] = var_05;
					continue;
				}

				var_02.fallbackspawnpoints[var_02.fallbackspawnpoints.size] = var_05;
			}
		}
	}
}

//Function Number: 16
calculatespawndisttozones(param_00)
{
	param_00.distsqtokothzones = [];
	foreach(var_02 in level.zones)
	{
		var_03 = function_00C0(param_00.origin,var_02.baseorigin,5000);
		if(var_03 < 0)
		{
			var_03 = scripts\engine\utility::distance_2d_squared(param_00.origin,var_02.baseorigin);
		}
		else
		{
			var_03 = var_03 * var_03;
		}

		param_00.distsqtokothzones[var_02 getentitynumber()] = var_03;
		if(var_03 > var_02.furthestspawndistsq)
		{
			var_02.furthestspawndistsq = var_03;
		}
	}
}

//Function Number: 17
comparezoneindexes(param_00,param_01)
{
	var_02 = int(param_00.script_label);
	var_03 = int(param_01.script_label);
	if(!isdefined(var_02) && !isdefined(var_03))
	{
		return 0;
	}

	if(!isdefined(var_02) && isdefined(var_03))
	{
		return 1;
	}

	if(isdefined(var_02) && !isdefined(var_03))
	{
		return 0;
	}

	if(var_02 > var_03)
	{
		return 1;
	}

	return 0;
}

//Function Number: 18
getzonearray(param_00)
{
	var_01 = getentarray(param_00,"targetname");
	if(!isdefined(var_01) || var_01.size == 0)
	{
		return undefined;
	}

	var_02 = 1;
	for(var_03 = var_01.size;var_02;var_03--)
	{
		var_02 = 0;
		for(var_04 = 0;var_04 < var_03 - 1;var_04++)
		{
			if(comparezoneindexes(var_01[var_04],var_01[var_04 + 1]))
			{
				var_05 = var_01[var_04];
				var_01[var_04] = var_01[var_04 + 1];
				var_01[var_04 + 1] = var_05;
				var_02 = 1;
			}
		}
	}

	return var_01;
}

//Function Number: 19
setupzones()
{
	scripts\mp\_utility::func_98D3();
	level.zones = [];
	level.var_13FC6 = [];
	var_00 = getzonearray("hardpoint_zone");
	if(level.mapname == "mp_fallen")
	{
		var_00 = scripts\engine\utility::array_remove(var_00,var_00[var_00.size - 1]);
	}

	level.zones = [];
	for(var_01 = 0;var_01 < var_00.size;var_01++)
	{
		level.zones[level.zones.size] = var_00[var_01];
	}

	level.objectives = level.zones;
	for(var_01 = 0;var_01 < level.zones.size;var_01++)
	{
		var_02 = scripts\mp\gametypes\obj_zonecapture::func_8B4A(var_01);
		level.zones[var_01].useobj = var_02;
		var_02.levelflag = level.zones[var_01];
		level.var_13FC6[level.var_13FC6.size] = var_02;
	}

	level.var_1BEB = level.zones;
	var_03 = scripts\mp\_spawnlogic::getspawnpointarray("mp_koth_spawn_axis_start");
	var_04 = scripts\mp\_spawnlogic::getspawnpointarray("mp_koth_spawn_allies_start");
	level.areanynavvolumesloaded["allies"] = var_04[0].origin;
	level.areanynavvolumesloaded["axis"] = var_03[0].origin;
	return 1;
}

//Function Number: 20
setupzoneareabrushes()
{
	level.neutralzonebrushes = [];
	level.friendlyzonebrushes = [];
	level.enemyzonebrushes = [];
	level.contestedzonebrushes = [];
	var_00 = getzonearray("hardpoint_zone_visual");
	var_01 = getzonearray("hardpoint_zone_visual_contest");
	var_02 = getzonearray("hardpoint_zone_visual_friend");
	var_03 = getzonearray("hardpoint_zone_visual_enemy");
	if(!isdefined(var_00))
	{
		level.usehpzonebrushes = 0;
	}
	else
	{
		level.usehpzonebrushes = 1;
	}

	if(level.usehpzonebrushes)
	{
		for(var_04 = 0;var_04 < var_00.size;var_04++)
		{
			level.neutralzonebrushes[level.neutralzonebrushes.size] = var_00[var_04];
			level.neutralzonebrushes[var_04] hide();
		}

		for(var_04 = 0;var_04 < var_01.size;var_04++)
		{
			level.contestedzonebrushes[level.contestedzonebrushes.size] = var_01[var_04];
			level.contestedzonebrushes[var_04] hide();
		}

		for(var_04 = 0;var_04 < var_02.size;var_04++)
		{
			level.friendlyzonebrushes[level.friendlyzonebrushes.size] = var_02[var_04];
			level.friendlyzonebrushes[var_04] hide();
		}

		for(var_04 = 0;var_04 < var_03.size;var_04++)
		{
			level.enemyzonebrushes[level.enemyzonebrushes.size] = var_03[var_04];
			level.enemyzonebrushes[var_04] hide();
		}

		postshipmodifiedzonebrushes();
		thread matchbrushestozones();
	}
}

//Function Number: 21
postshipmodifiedzonebrushes()
{
	if(level.mapname == "mp_parkour")
	{
		for(var_00 = 0;var_00 < level.neutralzonebrushes.size;var_00++)
		{
			if(level.neutralzonebrushes[var_00].script_label == "1")
			{
				level.neutralzonebrushes[var_00] hide();
				var_01 = spawn("script_model",(0,0,0));
				var_01 setmodel("mp_parkour_hardpoint_floor_01");
				var_01.angles = (0,0,0);
				var_01.script_label = "1";
				level.neutralzonebrushes[var_00] = var_01;
			}
		}

		for(var_00 = 0;var_00 < level.contestedzonebrushes.size;var_00++)
		{
			if(level.contestedzonebrushes[var_00].script_label == "1")
			{
				level.contestedzonebrushes[var_00] hide();
				var_02 = spawn("script_model",(0,0,0));
				var_02 setmodel("mp_parkour_hardpoint_floor_01_contest");
				var_02.angles = (0,0,0);
				var_02.script_label = "1";
				level.contestedzonebrushes[var_00] = var_02;
			}
		}

		for(var_00 = 0;var_00 < level.friendlyzonebrushes.size;var_00++)
		{
			if(level.friendlyzonebrushes[var_00].script_label == "1")
			{
				level.friendlyzonebrushes[var_00] hide();
				var_03 = spawn("script_model",(0,0,0));
				var_03 setmodel("mp_parkour_hardpoint_floor_01_friend");
				var_03.angles = (0,0,0);
				var_03.script_label = "1";
				level.friendlyzonebrushes[var_00] = var_03;
			}
		}

		for(var_00 = 0;var_00 < level.enemyzonebrushes.size;var_00++)
		{
			if(level.enemyzonebrushes[var_00].script_label == "1")
			{
				level.enemyzonebrushes[var_00] hide();
				var_04 = spawn("script_model",(0,0,0));
				var_04 setmodel("mp_parkour_hardpoint_floor_01_enemy");
				var_04.angles = (0,0,0);
				var_04.script_label = "1";
				level.enemyzonebrushes[var_00] = var_04;
			}
		}
	}
}

//Function Number: 22
matchbrushestozones()
{
	for(var_00 = 0;var_00 < level.zones.size;var_00++)
	{
		var_01 = level.zones[var_00];
		var_01.gameobject.neutralbrush = level.neutralzonebrushes[var_00];
		var_01.gameobject.enemybrush = level.enemyzonebrushes[var_00];
		var_01.gameobject.contestedbrush = level.contestedzonebrushes[var_00];
		var_01.gameobject.friendlybrush = level.friendlyzonebrushes[var_00];
	}
}

//Function Number: 23
setupzonecallouts()
{
	var_00 = undefined;
	var_01 = undefined;
	var_02 = level.zone.gameobject.visuals[0];
	if(level.mapname == "mp_afghan")
	{
		if(var_02.script_label == "1")
		{
			var_02.script_noteworthy = "crash_middle";
		}
	}

	foreach(var_04 in level.calloutglobals.areatriggers)
	{
		var_00 = function_010F(var_02.baseorigin,var_04);
		var_01 = isdefined(var_02.script_noteworthy) && isdefined(var_04.script_noteworthy) && var_02.script_noteworthy == var_04.script_noteworthy;
		if(var_00 || var_01)
		{
			var_05 = level.calloutglobals.areaidmap[var_04.script_noteworthy];
			foreach(var_07 in level.players)
			{
				if(isdefined(var_05))
				{
					var_07 setclientomnvar("ui_hp_callout_id",var_05);
				}
			}

			break;
		}
	}
}

//Function Number: 24
forcespawnplayers()
{
	var_00 = level.players;
	for(var_01 = 0;var_01 < var_00.size;var_01++)
	{
		var_02 = var_00[var_01];
		if(!isdefined(var_02) || isalive(var_02))
		{
			continue;
		}

		var_02 notify("force_spawn");
		wait(0.1);
	}
}

//Function Number: 25
getspawnpoint()
{
	var_00 = self.pers["team"];
	if(scripts\mp\_spawnlogic::shoulduseteamstartspawn())
	{
		var_01 = scripts\mp\_spawnlogic::getspawnpointarray("mp_koth_spawn_" + var_00 + "_start");
		var_02 = scripts\mp\_spawnlogic::getspawnpoint_startspawn(var_01);
	}
	else
	{
		var_01 = func_E172(level.zone.spawnpoints);
		var_03 = func_E172(level.zone.fallbackspawnpoints);
		var_04 = getkothzonedeadzonedist();
		var_05 = [];
		var_05["activeKOTHZoneNumber"] = level.zone getentitynumber();
		var_05["maxSquaredDistToObjective"] = level.zone.furthestspawndistsq;
		var_05["kothZoneDeadzoneDistSq"] = var_04 * var_04;
		var_05["closestEnemyInfluenceDistSq"] = 12250000;
		var_02 = scripts\mp\_spawnscoring::getspawnpoint(var_01,var_03,var_05);
	}

	return var_02;
}

//Function Number: 26
getkothzonedeadzonedist()
{
	return 1000;
}

//Function Number: 27
func_E172(param_00)
{
	var_01 = [];
	if(isdefined(param_00))
	{
		foreach(var_03 in param_00)
		{
			if(!function_010F(var_03.origin,level.zone))
			{
				var_01[var_01.size] = var_03;
			}
		}
	}

	return var_01;
}

//Function Number: 28
onspawnplayer()
{
	scripts\mp\_utility::clearlowermessage("hq_respawn");
	self.forcespawnnearteammates = undefined;
}

//Function Number: 29
movezoneaftertime(param_00)
{
	level endon("game_ended");
	level endon("zone_reset");
	level endon("dev_force_zone");
	level.zonemovetime = param_00;
	level.zonedestroyedbytimer = 0;
	scripts\mp\gametypes\obj_zonecapture::zonetimerwait();
	level.zonedestroyedbytimer = 1;
	level notify("zone_moved");
	level notify("zone_destroyed");
}

//Function Number: 30
onplayerkilled(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09)
{
	if(!isplayer(param_01) || param_01.team == self.team)
	{
		return;
	}

	if(param_01 == self)
	{
		return;
	}

	if(!isdefined(level.zone))
	{
		return;
	}

	var_0A = level.zone.gameobject.ownerteam;
	if(!isdefined(var_0A))
	{
		return;
	}

	if(isdefined(param_04) && scripts\mp\_utility::iskillstreakweapon(param_04))
	{
		return;
	}

	var_0B = self;
	var_0C = 0;
	var_0D = param_01.team;
	if(level.zonecapturetime > 0 && param_01 istouching(level.zone.gameobject.trigger))
	{
		if(var_0A != var_0D)
		{
			var_0C = 1;
		}
	}

	if(var_0D != var_0A)
	{
		if(var_0B istouching(level.zone.gameobject.trigger))
		{
			param_01.lastkilltime = gettime();
			if(var_0C)
			{
				param_01 thread scripts\mp\_utility::giveunifiedpoints("capture_kill");
			}

			param_01 thread scripts\mp\_awards::givemidmatchaward("mode_x_assault");
			thread scripts\mp\_matchdata::loginitialstats(param_09,"defending");
			return;
		}

		return;
	}

	if(param_01 istouching(level.zone.gameobject.trigger))
	{
		if(var_0C)
		{
			param_01 thread scripts\mp\_utility::giveunifiedpoints("capture_kill");
		}

		param_01 thread scripts\mp\_awards::givemidmatchaward("mode_x_defend");
		param_01 scripts\mp\_utility::incperstat("defends",1);
		param_01 scripts\mp\_persistence::statsetchild("round","defends",param_01.pers["defends"]);
		param_01 scripts\mp\_utility::setextrascore1(param_01.pers["defends"]);
	}
}

//Function Number: 31
give_capture_credit(param_00,param_01,param_02,param_03)
{
	level endon("game_ended");
	level.lastcaptime = gettime();
	var_04 = level.zone.gameobject scripts\mp\_gameobjects::getearliestclaimplayer();
	if(isdefined(var_04.triggerportableradarping))
	{
		var_04 = var_04.triggerportableradarping;
	}

	if(isplayer(var_04))
	{
		if(!isscoreboosting(var_04))
		{
			var_04 thread scripts\mp\_matchdata::loggameevent("capture",var_04.origin);
			var_04 thread scripts\mp\_awards::givemidmatchaward("mode_hp_secure");
			if(isdefined(level.zone.gameobject.lastactivatetime) && gettime() - level.zone.gameobject.lastactivatetime <= 2100)
			{
				var_04 thread scripts\mp\_awards::givemidmatchaward("mode_hp_quick_cap");
			}

			if(var_04.lastkilltime + 500 > gettime())
			{
			}
			else
			{
				var_04 scripts\mp\gametypes\obj_zonecapture::setcrankedtimerzonecap(var_04);
			}
		}
	}

	var_05 = getarraykeys(param_00);
	for(var_06 = 0;var_06 < var_05.size;var_06++)
	{
		var_07 = param_00[var_05[var_06]].player;
		var_07 updatecapsperminute(param_03);
		if(!isscoreboosting(var_07))
		{
			var_07 scripts\mp\_utility::incperstat("captures",1);
			var_07 scripts\mp\_persistence::statsetchild("round","captures",var_07.pers["captures"]);
		}
		else
		{
		}

		wait(0.05);
	}
}

//Function Number: 32
awardcapturepoints()
{
	level endon("game_ended");
	level endon("zone_reset");
	level endon("zone_moved");
	level notify("awardCapturePointsRunning");
	level endon("awardCapturePointsRunning");
	var_00 = 1;
	var_01 = 1;
	while(!level.gameended)
	{
		var_02 = 0;
		while(var_02 < var_00)
		{
			wait(0.05);
			scripts\mp\_hostmigration::waittillhostmigrationdone();
			var_02 = var_02 + 0.05;
			if(level.zone.gameobject.stalemate)
			{
				var_02 = 0;
			}
		}

		var_03 = level.zone.gameobject scripts\mp\_gameobjects::getownerteam();
		if(var_03 == "neutral")
		{
			continue;
		}

		if(level.usehqrules)
		{
			if(level.zoneadditivescoring)
			{
				var_01 = level.zone.gameobject.touchlist[var_03].size;
			}

			scripts\mp\_gamescore::giveteamscoreforobjective(var_03,var_01,0);
			continue;
		}

		if(!level.zone.gameobject.stalemate && !level.gameended)
		{
			if(level.zoneadditivescoring)
			{
				var_01 = level.zone.gameobject.touchlist[var_03].size;
			}

			scripts\mp\_gamescore::giveteamscoreforobjective(var_03,var_01,0);
			foreach(var_05 in level.zone.gameobject.touchlist[var_03])
			{
				var_05.player scripts\mp\_utility::incperstat("objTime",1);
				if(isdefined(var_05.player.timebyrotation[level.kothhillrotation]))
				{
					var_05.player.timebyrotation[level.kothhillrotation]++;
				}
				else
				{
					var_05.player.timebyrotation[level.kothhillrotation] = 1;
				}

				var_05.player scripts\mp\_persistence::statsetchild("round","objTime",var_05.player.pers["objTime"]);
				var_05.player scripts\mp\_utility::setextrascore0(var_05.player.pers["objTime"]);
				var_05.player scripts\mp\_gamescore::giveplayerscore("koth_in_obj",10);
			}
		}
	}
}

//Function Number: 33
updatecapsperminute(param_00)
{
	if(!isdefined(self.capsperminute))
	{
		self.numcaps = 0;
		self.capsperminute = 0;
	}

	if(!isdefined(param_00) || param_00 == "neutral")
	{
		return;
	}

	self.var_C21D++;
	var_01 = scripts\mp\_utility::gettimepassed() / -5536;
	if(isplayer(self) && isdefined(self.timeplayed["total"]))
	{
		var_01 = self.timeplayed["total"] / 60;
	}

	self.capsperminute = self.numcaps / var_01;
	if(self.capsperminute > self.numcaps)
	{
		self.capsperminute = self.numcaps;
	}
}

//Function Number: 34
isscoreboosting(param_00)
{
	if(!level.rankedmatch)
	{
		return 0;
	}

	if(param_00.capsperminute > 6)
	{
		return 1;
	}

	return 0;
}

//Function Number: 35
onplayerconnect()
{
	for(;;)
	{
		level waittill("connected",var_00);
		var_00._hardpointeffect = [];
		var_00.numcaps = 0;
		var_00.capsperminute = 0;
		var_00.timebyrotation = [];
		var_00 scripts\mp\_utility::setextrascore0(0);
		if(isdefined(var_00.pers["objTime"]))
		{
			var_00 scripts\mp\_utility::setextrascore0(var_00.pers["objTime"]);
		}

		var_00 scripts\mp\_utility::setextrascore1(0);
		if(isdefined(var_00.pers["defends"]))
		{
			var_00 scripts\mp\_utility::setextrascore1(var_00.pers["defends"]);
		}

		thread onplayerspawned(var_00);
		foreach(var_02 in level.zones)
		{
			if(level.usehpzonebrushes)
			{
				var_02.gameobject scripts\mp\gametypes\obj_zonecapture::hideplayerspecificbrushes(var_00);
			}
		}

		var_00 thread refreshfreecamhardpointfx();
	}
}

//Function Number: 36
onplayerspawned(param_00)
{
	for(;;)
	{
		param_00 waittill("spawned");
		foreach(var_02 in level.zones)
		{
			if(isdefined(var_02.gameobject.var_19) && var_02.gameobject.var_19)
			{
				if(var_02.gameobject.ownerteam == "neutral")
				{
					var_02.gameobject scripts\mp\gametypes\obj_zonecapture::playhardpointneutralfx();
					continue;
				}

				var_02.gameobject scripts\mp\gametypes\obj_zonecapture::showcapturedhardpointeffecttoplayer(var_02.gameobject.ownerteam,param_00);
			}
		}
	}
}

//Function Number: 37
updateservericons(param_00,param_01)
{
	var_02 = -1;
	if(param_01)
	{
		var_02 = -2;
	}
	else
	{
		switch(param_00)
		{
			case "allies":
			case "axis":
				var_03 = thread getownerteamplayer(param_00);
				if(isdefined(var_03))
				{
					var_02 = var_03 getentitynumber();
				}
				break;

			case "zone_activation_delay":
				var_02 = -3;
				break;

			case "zone_shift":
			default:
				break;
		}
	}

	setomnvar("ui_hardpoint",var_02);
}

//Function Number: 38
getownerteamplayer(param_00)
{
	var_01 = undefined;
	foreach(var_03 in level.players)
	{
		if(var_03.team == param_00)
		{
			var_01 = var_03;
			break;
		}
	}

	return var_01;
}

//Function Number: 39
refreshfreecamhardpointfx()
{
	self endon("disconnect");
	level endon("game_ended");
	for(;;)
	{
		self waittill("luinotifyserver",var_00,var_01);
		if(var_00 == "mlg_view_change")
		{
			foreach(var_03 in level.zones)
			{
				if(var_03.gameobject.ownerteam != "neutral")
				{
					var_03.gameobject scripts\mp\gametypes\obj_zonecapture::showcapturedhardpointeffecttoplayer(var_03.gameobject.ownerteam,self);
				}
			}
		}
	}
}

//Function Number: 40
getrespawndelay()
{
	if(!level.delayplayer)
	{
		return undefined;
	}

	var_00 = level.zone.gameobject.ownerteam;
	if(isdefined(var_00))
	{
		if(self.pers["team"] == var_00)
		{
			if(!level.spawndelay)
			{
				return undefined;
			}

			return level.spawndelay;
		}
	}
}

//Function Number: 41
postshipmodifiedzones(param_00)
{
	if(level.mapname == "mp_fallen" && param_00 == "5")
	{
		return 1;
	}

	return 0;
}

//Function Number: 42
writeplayerrotationscoretomatchdataongameend()
{
	level waittill("game_ended");
	foreach(var_01 in level.players)
	{
		if(isdefined(var_01))
		{
			foreach(var_04, var_03 in var_01.timebyrotation)
			{
				if(var_04 < 14)
				{
					if(var_03 > 255)
					{
						var_03 = 255;
					}

					setmatchdata("players",var_01.clientid,"kothRotationScores",var_04,var_03);
				}
			}
		}
	}

	writecurrentrotationteamscore();
}

//Function Number: 43
writecurrentrotationteamscore()
{
	if(level.kothhillrotation < 24)
	{
		setmatchdata("alliesRoundScore",level.kothhillrotation,getteamscore("allies"));
		setmatchdata("axisRoundScore",level.kothhillrotation,getteamscore("axis"));
	}
}