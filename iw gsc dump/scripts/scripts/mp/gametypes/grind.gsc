/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\gametypes\grind.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 28
 * Decompile Time: 1446 ms
 * Timestamp: 10/27/2023 12:12:34 AM
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
		scripts\mp\_utility::registerroundswitchdvar(level.gametype,0,0,9);
		scripts\mp\_utility::registertimelimitdvar(level.gametype,10);
		scripts\mp\_utility::registerscorelimitdvar(level.gametype,85);
		scripts\mp\_utility::registerroundlimitdvar(level.gametype,1);
		scripts\mp\_utility::registerwinlimitdvar(level.gametype,1);
		scripts\mp\_utility::registernumlivesdvar(level.gametype,0);
		scripts\mp\_utility::registerhalftimedvar(level.gametype,0);
	}

	updategametypedvars();
	level.var_1C26 = [];
	level.var_26F2 = [];
	level.dogtagsplayer = [];
	scripts\mp\gametypes\obj_grindzone::init();
	level.teambased = 1;
	level.onstartgametype = ::onstartgametype;
	level.getspawnpoint = ::getspawnpoint;
	level.onnormaldeath = ::onnormaldeath;
	level.onspawnplayer = ::onspawnplayer;
	level.conf_fx["vanish"] = loadfx("vfx/core/impacts/small_snowhit");
}

//Function Number: 2
initializematchrules()
{
	scripts\mp\_utility::setcommonrulesfrommatchdata();
	setdynamicdvar("scr_grind_bankTime",getmatchrulesdata("grindData","bankTime"));
	setdynamicdvar("scr_grind_bankRate",getmatchrulesdata("grindData","bankRate"));
	setdynamicdvar("scr_grind_bankCaptureTime",getmatchrulesdata("grindData","bankCaptureTime"));
	setdynamicdvar("scr_grind_megaBankLimit",getmatchrulesdata("grindData","megaBankLimit"));
	setdynamicdvar("scr_grind_bankBonus",getmatchrulesdata("grindData","megaBankBonus"));
	setdynamicdvar("scr_grind_halftime",0);
	scripts\mp\_utility::registerhalftimedvar("grind",0);
	setdynamicdvar("scr_grind_promode",0);
}

//Function Number: 3
onstartgametype()
{
	setclientnamemode("auto_change");
	if(!isdefined(game["switchedsides"]))
	{
		game["switchedsides"] = 0;
	}

	scripts\mp\_utility::setobjectivetext("allies",&"OBJECTIVES_WAR");
	scripts\mp\_utility::setobjectivetext("axis",&"OBJECTIVES_WAR");
	if(level.splitscreen)
	{
		scripts\mp\_utility::setobjectivescoretext("allies",&"OBJECTIVES_WAR");
		scripts\mp\_utility::setobjectivescoretext("axis",&"OBJECTIVES_WAR");
	}
	else
	{
		scripts\mp\_utility::setobjectivescoretext("allies",&"OBJECTIVES_WAR_SCORE");
		scripts\mp\_utility::setobjectivescoretext("axis",&"OBJECTIVES_WAR_SCORE");
	}

	scripts\mp\_utility::setobjectivehinttext("allies",&"OBJECTIVES_WAR_HINT");
	scripts\mp\_utility::setobjectivehinttext("axis",&"OBJECTIVES_WAR_HINT");
	initspawns();
	createtags();
	level.dogtagallyonusecb = ::dogtagallyonusecb;
	var_00[0] = level.gametype;
	var_00[1] = "dom";
	scripts\mp\_gameobjects::main(var_00);
	createzones();
	level thread onplayerconnect();
	level thread removetagsongameended();
}

//Function Number: 4
updategametypedvars()
{
	scripts\mp\gametypes\common::updategametypedvars();
	level.banktime = scripts\mp\_utility::dvarfloatvalue("bankTime",2,0,10);
	level.bankrate = scripts\mp\_utility::dvarintvalue("bankRate",1,1,10);
	level.bankcapturetime = scripts\mp\_utility::dvarintvalue("bankCaptureTime",0,0,10);
	level.megabanklimit = scripts\mp\_utility::dvarintvalue("megaBankLimit",5,5,15);
	level.megabankbonus = scripts\mp\_utility::dvarintvalue("megaBankBonus",150,0,750);
}

//Function Number: 5
onspawnplayer()
{
	if(isdefined(self.tagscarried))
	{
		self setclientomnvar("ui_grind_tags",self.tagscarried);
	}
}

//Function Number: 6
createtags()
{
	level.dogtags = [];
	for(var_00 = 0;var_00 < 30;var_00++)
	{
		var_01[0] = spawn("script_model",(0,0,0));
		var_01[0] setmodel("dogtags_iw7_foe");
		var_01[1] = spawn("script_model",(0,0,0));
		var_01[1] setmodel("dogtags_iw7_friend");
		var_01[0] scriptmodelplayanim("mp_dogtag_spin");
		var_01[1] scriptmodelplayanim("mp_dogtag_spin");
		var_01[0] hide();
		var_01[1] hide();
		var_01[0] setasgametypeobjective();
		var_01[1] setasgametypeobjective();
		var_02 = spawn("trigger_radius",(0,0,0),0,32,32);
		var_02.var_336 = "trigger_dogtag";
		var_02 hide();
		var_03 = spawnstruct();
		var_03.type = "useObject";
		var_03.curorigin = var_02.origin;
		var_03.entnum = var_02 getentitynumber();
		var_03.lastusedtime = 0;
		var_03.visuals = var_01;
		var_03.offset3d = (0,0,16);
		var_03.trigger = var_02;
		var_03.triggertype = "proximity";
		var_03 scripts\mp\_gameobjects::allowuse("none");
		level.dogtags[level.dogtags.size] = var_03;
	}
}

//Function Number: 7
gettag()
{
	var_00 = level.dogtags[0];
	var_01 = gettime();
	foreach(var_03 in level.dogtags)
	{
		if(!isdefined(var_03.lastusedtime))
		{
			continue;
		}

		if(var_03.interactteam == "none")
		{
			var_00 = var_03;
			break;
		}

		if(var_03.lastusedtime < var_01)
		{
			var_01 = var_03.lastusedtime;
			var_00 = var_03;
		}
	}

	var_00 notify("reset");
	var_00 scripts\mp\_gameobjects::initializetagpathvariables();
	var_00.lastusedtime = gettime();
	return var_00;
}

//Function Number: 8
spawntag(param_00,param_01)
{
	var_02 = param_00 + (0,0,14);
	var_03 = (0,randomfloat(360),0);
	var_04 = anglestoforward(var_03);
	var_05 = randomfloatrange(30,150);
	var_06 = var_02 + var_05 * var_04;
	var_02 = playerphysicstrace(var_02,var_06);
	var_07 = gettag();
	var_07.curorigin = var_02;
	var_07.trigger.origin = var_02;
	var_07.visuals[0].origin = var_02;
	var_07.visuals[1].origin = var_02;
	var_07.trigger show();
	var_07 scripts\mp\_gameobjects::allowuse("any");
	var_07.visuals[0] thread showtoteam(var_07,scripts\mp\_utility::getotherteam(param_01));
	var_07.visuals[1] thread showtoteam(var_07,param_01);
	var_07.visuals[0] setasgametypeobjective();
	var_07.visuals[1] setasgametypeobjective();
	playsoundatpos(var_02,"mp_grind_token_drop");
	return var_07;
}

//Function Number: 9
showtoteam(param_00,param_01)
{
	param_00 endon("death");
	param_00 endon("reset");
	self hide();
	foreach(var_03 in level.players)
	{
		if(playercanusetags(var_03))
		{
			if(var_03.team == param_01)
			{
				self showtoplayer(var_03);
			}

			if(var_03.team == "spectator" && param_01 == "allies")
			{
				self showtoplayer(var_03);
			}
		}
	}

	for(;;)
	{
		level scripts\engine\utility::waittill_any_3("joined_team","update_phase_visibility");
		self hide();
		foreach(var_03 in level.players)
		{
			if(playercanusetags(var_03))
			{
				if(var_03.team == param_01)
				{
					self showtoplayer(var_03);
				}
			}

			if(var_03.team == "spectator" && param_01 == "allies")
			{
				self showtoplayer(var_03);
			}

			if(param_00.victimteam == var_03.team && var_03 == param_00.var_4F)
			{
				scripts\mp\objidpoolmanager::minimap_objective_state(param_00.objid,"invisible");
			}
		}
	}
}

//Function Number: 10
playercanusetags(param_00)
{
	if(scripts/mp/equipment/phase_shift::isentityphaseshifted(param_00))
	{
		return 0;
	}

	return 1;
}

//Function Number: 11
func_BA31(param_00)
{
	level endon("game_ended");
	param_00 endon("deleted");
	param_00 endon("reset");
	for(;;)
	{
		param_00.trigger waittill("trigger",var_01);
		if(!scripts\mp\_utility::isreallyalive(var_01))
		{
			continue;
		}

		if(var_01 scripts\mp\_utility::isusingremote() || isdefined(var_01.spawningafterremotedeath))
		{
			continue;
		}

		if(isdefined(var_01.classname) && var_01.classname == "script_vehicle")
		{
			continue;
		}

		if(isagent(var_01) && isdefined(var_01.triggerportableradarping))
		{
			var_01 = var_01.triggerportableradarping;
		}

		if(!scripts/mp/equipment/phase_shift::areentitiesinphase(param_00,var_01))
		{
			continue;
		}

		param_00.visuals[0] hide();
		param_00.visuals[1] hide();
		param_00.trigger hide();
		param_00.curorigin = (0,0,1000);
		param_00.trigger.origin = (0,0,1000);
		param_00.visuals[0].origin = (0,0,1000);
		param_00.visuals[1].origin = (0,0,1000);
		param_00 scripts\mp\_gameobjects::allowuse("none");
		if(param_00.team != var_01.team)
		{
			var_01 playersettagcount(var_01.tagscarried + 1);
			var_01 thread scripts\mp\_utility::giveunifiedpoints("tag_collected");
		}

		var_01 playsound("mp_killconfirm_tags_pickup");
		if(isdefined(level.supportcranked) && level.supportcranked)
		{
			if(isdefined(var_01.cranked) && var_01.cranked)
			{
				var_01 scripts\mp\_utility::setcrankedplayerbombtimer("kill");
			}
			else
			{
				var_01 scripts\mp\_utility::oncranked(undefined,var_01);
			}
		}

		playsoundatpos(var_01.origin,"mp_grind_token_pickup");
		break;
	}
}

//Function Number: 12
onplayerconnect()
{
	for(;;)
	{
		level waittill("connected",var_00);
		var_00.isscoring = 0;
		var_00 thread monitorjointeam();
	}
}

//Function Number: 13
playersettagcount(param_00)
{
	self.tagscarried = param_00;
	self.objective_additionalentity = param_00;
	if(param_00 > 999)
	{
		param_00 = 999;
	}

	self setclientomnvar("ui_grind_tags",param_00);
}

//Function Number: 14
monitorjointeam()
{
	self endon("disconnect");
	for(;;)
	{
		scripts\engine\utility::waittill_any_3("joined_team","joined_spectators");
		playersettagcount(0);
		if(self.team == "allies")
		{
			level.var_1C26 = scripts\engine\utility::array_add(level.var_1C26,self);
			continue;
		}

		if(self.team == "axis")
		{
			level.var_26F2 = scripts\engine\utility::array_add(level.var_26F2,self);
		}
	}
}

//Function Number: 15
hidehudelementongameend(param_00)
{
	level waittill("game_ended");
	if(isdefined(param_00))
	{
		param_00.alpha = 0;
	}
}

//Function Number: 16
createzones()
{
	level.var_13FC1 = [];
	var_00 = getentarray("grind_location","targetname");
	foreach(var_02 in var_00)
	{
		level.var_13FC1[level.var_13FC1.size] = var_02;
	}

	level.objectives = level.var_13FC1;
	for(var_04 = 0;var_04 < level.var_13FC1.size;var_04++)
	{
		var_05 = scripts\mp\gametypes\obj_grindzone::setupobjective(var_04);
		var_05 thread runzonethink();
		level.var_13FC1[var_04].useobj = var_05;
		var_05.levelflag = level.var_13FC1[var_04];
	}
}

//Function Number: 17
isinzone(param_00,param_01)
{
	if(scripts\mp\_utility::isreallyalive(param_00) && param_00 istouching(param_01.trigger) && param_01.ownerteam == param_00.team)
	{
		return 1;
	}

	return 0;
}

//Function Number: 18
runzonethink()
{
	level endon("game_ended");
	self endon("stop_trigger" + self.label);
	for(;;)
	{
		self.trigger waittill("trigger",var_00);
		if(self.stalemate)
		{
			continue;
		}

		if(isagent(var_00))
		{
			continue;
		}

		if(!isplayer(var_00))
		{
			continue;
		}

		if(var_00.isscoring)
		{
			continue;
		}

		var_00.isscoring = 1;
		level thread processscoring(var_00,self);
	}
}

//Function Number: 19
removetagsongameended()
{
	level waittill("game_ended");
	foreach(var_01 in level.players)
	{
		if(!isdefined(var_01))
		{
			continue;
		}

		if(!isdefined(var_01.tagscarried))
		{
			continue;
		}

		var_01.tagscarried = 0;
	}
}

//Function Number: 20
processscoring(param_00,param_01)
{
	while(param_00.tagscarried && isinzone(param_00,param_01) && !param_01.stalemate)
	{
		param_00 playsoundtoplayer("mp_grind_token_banked",param_00);
		if(param_00.tagscarried >= level.megabanklimit)
		{
			scoreamount(param_00,level.megabanklimit);
			var_02 = scripts\mp\_rank::getscoreinfovalue("tag_score");
			var_02 = var_02 * level.megabanklimit;
			param_00 thread scripts\mp\_utility::giveunifiedpoints("mega_bank",param_00.var_394,var_02 + level.megabankbonus);
			param_00 scripts\mp\_missions::func_D991("ch_mega_bank");
		}
		else
		{
			var_03 = level.bankrate;
			if(var_03 > param_00.tagscarried)
			{
				var_03 = param_00.tagscarried;
			}

			scoreamount(param_00,var_03);
			for(var_04 = 0;var_04 < var_03;var_04++)
			{
				param_00 thread scripts\mp\_utility::giveunifiedpoints("tag_score");
			}
		}

		if(isdefined(level.supportcranked) && level.supportcranked && isdefined(param_00.cranked) && param_00.cranked)
		{
			param_00 scripts\mp\_utility::setcrankedplayerbombtimer("kill");
		}

		param_00 scripts\mp\_missions::processchallenge("ch_grinder");
		wait(level.banktime);
	}

	param_01 scripts\mp\gametypes\obj_grindzone::setneutralicons();
	param_00.isscoring = 0;
}

//Function Number: 21
scoreamount(param_00,param_01)
{
	param_00 playersettagcount(param_00.tagscarried - param_01);
	scripts\mp\_gamescore::giveteamscoreforobjective(param_00.team,param_01,0);
	param_00 scripts\mp\_utility::incperstat("confirmed",param_01);
	param_00 scripts\mp\_persistence::statsetchild("round","confirmed",param_00.pers["confirmed"]);
	param_00 scripts\mp\_utility::setextrascore0(param_00.pers["confirmed"]);
}

//Function Number: 22
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

//Function Number: 23
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

//Function Number: 24
onnormaldeath(param_00,param_01,param_02,param_03,param_04)
{
	scripts\mp\gametypes\common::onnormaldeath(param_00,param_01,param_02,param_03,param_04);
	level thread droptags(param_00,param_01);
}

//Function Number: 25
droptags(param_00,param_01)
{
	if(isagent(param_00))
	{
		return;
	}

	if(param_00.tagscarried > 9)
	{
		var_02 = 10;
	}
	else if(param_01.tagscarried > 0)
	{
		var_02 = param_01.tagscarried;
	}
	else
	{
		var_02 = 0;
	}

	for(var_03 = 0;var_03 < var_02;var_03++)
	{
		var_04 = spawntag(param_00.origin,param_00.team);
		var_04.team = param_00.team;
		var_04.victim = param_00;
		var_04.var_4F = param_01;
		level notify("new_tag_spawned",var_04);
		level thread func_BA31(var_04);
	}

	var_05 = param_00.tagscarried - var_02;
	var_05 = int(max(0,var_05));
	param_00 playersettagcount(var_05);
}

//Function Number: 26
dogtagallyonusecb(param_00)
{
	if(isplayer(param_00))
	{
		param_00 scripts\mp\_utility::setextrascore1(param_00.pers["denied"]);
	}
}

//Function Number: 27
removepoint()
{
	self endon("game_ended");
	for(;;)
	{
		if(getdvar("scr_devRemoveDomFlag","") != "")
		{
			var_00 = getdvar("scr_devRemoveDomFlag","");
			foreach(var_02 in level.var_13FC1)
			{
				if(isdefined(var_02.useobj.label) && var_02.useobj.label == var_00)
				{
					var_02.useobj notify("stop_trigger" + var_02.useobj.label);
					var_02.useobj scripts\mp\_gameobjects::allowuse("none");
					var_02.useobj.trigger = undefined;
					var_02.useobj notify("deleted");
					var_02.useobj.visibleteam = "none";
					var_02.useobj scripts\mp\_gameobjects::set2dicon("friendly",undefined);
					var_02.useobj scripts\mp\_gameobjects::set3dicon("friendly",undefined);
					var_02.useobj scripts\mp\_gameobjects::set2dicon("enemy",undefined);
					var_02.useobj scripts\mp\_gameobjects::set3dicon("enemy",undefined);
					var_03 = [];
					for(var_04 = 0;var_04 < level.objectives.size;var_04++)
					{
						if(level.objectives[var_04].script_label != var_00)
						{
							var_03[var_03.size] = level.objectives[var_04];
						}
					}

					level.objectives = var_03;
					var_03 = [];
					for(var_04 = 0;var_04 < level.var_13FC1.size;var_04++)
					{
						if(level.var_13FC1[var_04].useobj.label != var_00)
						{
							var_03[var_03.size] = level.var_13FC1[var_04];
						}
					}

					level.var_13FC1 = var_03;
					break;
				}
			}

			setdynamicdvar("scr_devRemoveDomFlag","");
		}

		wait(1);
	}
}

//Function Number: 28
placepoint()
{
	self endon("game_ended");
	for(;;)
	{
		if(getdvar("scr_devPlaceDomFlag","") != "")
		{
			var_00 = getdvar("scr_devPlaceDomFlag","");
			var_01 = undefined;
			var_02 = getentarray("grind_location","targetname");
			foreach(var_04 in var_02)
			{
				if("_" + var_04.script_label == var_00)
				{
					var_01 = var_04;
				}
			}

			var_01.origin = level.players[0].origin;
			var_01.ownerteam = "neutral";
			var_06 = var_01.origin + (0,0,32);
			var_07 = var_01.origin + (0,0,-32);
			var_08 = bullettrace(var_06,var_07,0,undefined);
			var_01.origin = var_08["position"];
			var_01.upangles = vectortoangles(var_08["normal"]);
			var_01.missionfailed = anglestoforward(var_01.upangles);
			var_01.setdebugorigin = anglestoright(var_01.upangles);
			var_09[0] = spawn("script_model",var_01.origin);
			var_09[0].angles = var_01.angles;
			level.objectives[level.objectives.size] = var_01;
			level.var_13FC1[level.var_13FC1.size] = var_01;
			var_0A = spawn("trigger_radius",var_01.origin,0,90,128);
			var_0A.script_label = var_01.script_label;
			var_01 = var_0A;
			var_0B = scripts\mp\_gameobjects::createuseobject("neutral",var_01,var_09,(0,0,100));
			var_0C = var_00;
			var_0B.label = var_0C;
			var_0B thread runzonethink();
			var_0B scripts\mp\_gameobjects::allowuse("enemy");
			var_0B scripts\mp\_gameobjects::setusetime(level.bankcapturetime);
			var_0B scripts\mp\_gameobjects::setusetext(&"MP_SECURING_POSITION");
			var_0B scripts\mp\_gameobjects::set2dicon("friendly","waypoint_defend" + var_0C);
			var_0B scripts\mp\_gameobjects::set3dicon("friendly","waypoint_defend" + var_0C);
			var_0B scripts\mp\_gameobjects::set2dicon("enemy","waypoint_captureneutral" + var_0C);
			var_0B scripts\mp\_gameobjects::set3dicon("enemy","waypoint_captureneutral" + var_0C);
			var_0B scripts\mp\_gameobjects::setvisibleteam("any");
			var_0B scripts\mp\_gameobjects::cancontestclaim(1);
			var_0B.onuse = ::scripts\mp\gametypes\obj_grindzone::zone_onuse;
			var_0B.onbeginuse = ::scripts\mp\gametypes\obj_grindzone::zone_onusebegin;
			var_0B.onunoccupied = ::scripts\mp\gametypes\obj_grindzone::zone_onunoccupied;
			var_0B.oncontested = ::scripts\mp\gametypes\obj_grindzone::zone_oncontested;
			var_0B.onuncontested = ::scripts\mp\gametypes\obj_grindzone::zone_onuncontested;
			var_0B.claimgracetime = level.bankcapturetime * 1000;
			var_06 = var_0B.visuals[0].origin + (0,0,32);
			var_07 = var_0B.visuals[0].origin + (0,0,-32);
			var_0D = scripts\common\trace::create_contents(1,1,1,1,0,1,1);
			var_0E = [];
			var_08 = scripts\common\trace::ray_trace(var_06,var_07,var_0E,var_0D);
			var_0B.baseeffectpos = var_08["position"];
			var_0F = vectortoangles(var_08["normal"]);
			var_0F = -1 * var_0F;
			var_0B.baseeffectforward = anglestoforward(var_0F);
			var_0B scripts\mp\gametypes\obj_grindzone::setneutral();
			for(var_10 = 0;var_10 < level.objectives.size;var_10++)
			{
				level.objectives[var_10].useobj = var_0B;
				var_0B.levelflag = level.objectives[var_10];
			}

			level.var_13FC1[level.var_13FC1.size].useobj = var_0B;
			setdynamicdvar("scr_devPlaceDomFlag","");
		}

		wait(1);
	}
}