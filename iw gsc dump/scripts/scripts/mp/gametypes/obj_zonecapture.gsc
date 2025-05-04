/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\gametypes\obj_zonecapture.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 30
 * Decompile Time: 1531 ms
 * Timestamp: 10/27/2023 12:12:59 AM
*******************************************************************/

//Function Number: 1
func_8B4A(param_00)
{
	var_01 = level.objectives[param_00];
	var_02 = [];
	var_02[0] = var_01;
	var_01 = postshipmodifiedkothzones(var_01);
	var_01.gameobject = scripts\mp\_gameobjects::createuseobject("neutral",var_01,var_02,(0,0,0));
	var_01.gameobject scripts\mp\_gameobjects::disableobject();
	var_01.gameobject scripts\mp\_gameobjects::set2dicon("mlg",undefined);
	var_01.gameobject scripts\mp\_gameobjects::set3dicon("mlg",undefined);
	var_01.gameobject.claimgracetime = level.zonecapturetime * 1000;
	var_01.gameobject scripts\mp\_gameobjects::cancontestclaim(1);
	if(level.usehqrules)
	{
		var_01.gameobject scripts\mp\_gameobjects::mustmaintainclaim(0);
	}
	else
	{
		var_01.gameobject scripts\mp\_gameobjects::mustmaintainclaim(1);
	}

	var_01.gameobject.id = "hardpoint";
	var_01.useobj = var_01.gameobject;
	if(isdefined(var_01.target))
	{
		var_01.useobj thread assignchevrons(var_01.target,var_01.script_label);
	}

	return var_01;
}

//Function Number: 2
postshipmodifiedkothzones(param_00)
{
	if(level.mapname == "mp_parkour")
	{
		if(param_00.script_label == "1")
		{
			param_00.origin = param_00.origin + (0,0,135);
		}
	}

	if(level.mapname == "mp_fallen")
	{
		if(param_00.script_label == "3")
		{
			param_00.origin = param_00.origin - (0,0,50);
		}
	}

	if(level.mapname == "mp_junk")
	{
		if(param_00.script_label == "4")
		{
			param_00.origin = param_00.origin - (0,7,0);
		}
	}

	return param_00;
}

//Function Number: 3
assignchevrons(param_00,param_01)
{
	wait(1);
	var_02 = 0;
	var_03 = getscriptablearray(param_00,"targetname");
	if(level.mapname == "mp_parkour")
	{
		if(param_01 == "1")
		{
			var_02 = 1;
		}
	}

	if(!var_02)
	{
		var_04 = [];
		foreach(var_06 in var_03)
		{
			var_07 = var_04.size;
			var_04[var_07] = var_06;
			var_04[var_07].numchevrons = 1;
			if(isdefined(var_06.script_noteworthy))
			{
				if(var_06.script_noteworthy == "2")
				{
					var_04[var_07].numchevrons = 2;
					continue;
				}

				if(var_06.script_noteworthy == "3")
				{
					var_04[var_07].numchevrons = 3;
					continue;
				}

				if(var_06.script_noteworthy == "4")
				{
					var_04[var_07].numchevrons = 4;
				}
			}
		}
	}
	else
	{
		var_04 = postshipmodifychevrons(var_02);
	}

	self.chevrons = var_04;
}

//Function Number: 4
updatechevrons(param_00)
{
	self notify("updateChevrons");
	self endon("updateChevrons");
	while(!isdefined(self.chevrons))
	{
		wait(0.05);
	}

	foreach(var_02 in self.chevrons)
	{
		for(var_03 = 0;var_03 < var_02.numchevrons;var_03++)
		{
			var_02 setscriptablepartstate("chevron_" + var_03,param_00);
		}
	}
}

//Function Number: 5
activatezone()
{
	self.onuse = ::zone_onuse;
	self.onbeginuse = ::zone_onusebegin;
	self.onuseupdate = ::zone_onuseupdate;
	self.onenduse = ::zone_onuseend;
	self.onunoccupied = ::zone_onunoccupied;
	self.oncontested = ::zone_oncontested;
	self.onuncontested = ::zone_onuncontested;
	level thread scripts\mp\gametypes\koth::awardcapturepoints();
}

//Function Number: 6
deactivatezone()
{
	self.onuse = undefined;
	self.onbeginuse = undefined;
	self.onuseupdate = undefined;
	self.onunoccupied = undefined;
	self.oncontested = undefined;
	self.onuncontested = undefined;
	thread updatechevrons("off");
}

//Function Number: 7
zonetimerwait()
{
	level endon("game_ended");
	level endon("dev_force_zone");
	var_00 = int(level.zonemovetime * 1000 + gettime());
	thread hp_move_soon();
	level thread handlehostmigration(var_00);
	scripts\mp\_hostmigration::waitlongdurationwithhostmigrationpause(level.zonemovetime);
}

//Function Number: 8
hp_move_soon()
{
	level endon("game_ended");
	if(int(level.zonemovetime) > 12)
	{
		var_00 = level.zonemovetime - 12;
		scripts\mp\_hostmigration::waitlongdurationwithhostmigrationpause(var_00);
		level scripts\mp\_utility::statusdialog("hp_move_soon","allies");
		level scripts\mp\_utility::statusdialog("hp_move_soon","axis");
	}
}

//Function Number: 9
handlehostmigration(param_00)
{
	level endon("game_ended");
	level endon("bomb_defused");
	level endon("game_ended");
	level endon("disconnect");
	level waittill("host_migration_begin");
	setomnvar("ui_uplink_timer_stopped",1);
	var_01 = scripts\mp\_hostmigration::waittillhostmigrationdone();
	setomnvar("ui_uplink_timer_stopped",0);
	if(var_01 > 0)
	{
		setomnvar("ui_hardpoint_timer",level.zoneendtime + var_01);
		return;
	}

	setomnvar("ui_hardpoint_timer",level.zoneendtime);
}

//Function Number: 10
hardpoint_setneutral()
{
	self notify("flag_neutral");
	scripts\mp\_gameobjects::setownerteam("neutral");
	playhardpointneutralfx();
	thread updatechevrons("idle");
}

//Function Number: 11
trackgametypevips()
{
	thread cleanupgametypevips();
	level endon("game_ended");
	level endon("zone_moved");
	for(;;)
	{
		foreach(var_01 in level.players)
		{
			if(var_01 istouching(self.trigger))
			{
				var_01 setgametypevip(1);
				continue;
			}

			var_01 setgametypevip(0);
		}

		wait(0.5);
	}
}

//Function Number: 12
cleanupgametypevips()
{
	level scripts\engine\utility::waittill_any_3("game_ended","zone_moved");
	foreach(var_01 in level.players)
	{
		var_01 setgametypevip(0);
	}
}

//Function Number: 13
zone_onuse(param_00)
{
	if(level.usehqrules && self.ownerteam != "neutral")
	{
		level notify("zone_destroyed");
		level.zone.gameobject scripts\mp\_gameobjects::setvisibleteam("none");
		level scripts\mp\gametypes\koth::updateservericons("zone_shift",0);
		level scripts\mp\_utility::statusdialog("obj_destroyed",self.ownerteam,1);
		level scripts\mp\_utility::statusdialog("obj_captured",param_00.team,1);
		return;
	}

	var_01 = param_00.team;
	var_02 = scripts\mp\_gameobjects::getownerteam();
	var_03 = scripts\mp\_utility::getotherteam(var_01);
	var_04 = gettime();
	if(!level.timerstoppedforgamemode && level.pausemodetimer)
	{
		level scripts\mp\_gamelogic::pausetimer();
	}

	level.usestartspawns = 0;
	var_05 = 0;
	level.zone.gameobject scripts\mp\_gameobjects::setzonestatusicons(level.icondefend,level.iconcapture);
	level scripts\mp\gametypes\koth::updateservericons(var_01,0);
	if(!isdefined(level.lastcaptureteam) || level.lastcaptureteam != var_01)
	{
		if(level.gametype == "koth")
		{
			level scripts\mp\_utility::statusdialog("hp_captured_friendly",var_01,1);
			level scripts\mp\_utility::statusdialog("hp_captured_enemy",var_03,1);
		}
		else
		{
			level scripts\mp\_utility::statusdialog("friendly_zone_control",var_01,1);
			level scripts\mp\_utility::statusdialog("enemy_zone_control",var_03,1);
		}

		var_06 = [];
		var_07 = getarraykeys(self.touchlist[var_01]);
		for(var_08 = 0;var_08 < var_07.size;var_08++)
		{
			var_06[var_07[var_08]] = self.touchlist[var_01][var_07[var_08]];
		}

		level thread scripts\mp\gametypes\koth::give_capture_credit(var_06,var_04,var_01,level.lastcaptureteam);
	}

	thread scripts\mp\_utility::printandsoundoneveryone(var_01,var_03,undefined,undefined,"mp_dom_flag_captured",undefined,param_00);
	foreach(var_0A in level.players)
	{
		showcapturedhardpointeffecttoplayer(var_01,var_0A);
	}

	level.zone.gameobject thread updatechevrons(var_01);
	thread func_8B4C();
	level.var_911E = var_01;
	if(!isdefined(level.lastcaptureteam) || var_01 != level.lastcaptureteam)
	{
		scripts\mp\_utility::setmlgannouncement(6,var_01,param_00 getentitynumber());
	}

	scripts\mp\_gameobjects::setownerteam(var_01);
	self.var_3A3D++;
	level.lastcaptureteam = var_01;
	if(level.usehqrules)
	{
		level.zone.gameobject scripts\mp\_gameobjects::allowuse("enemy");
	}
	else
	{
		level.zone.gameobject scripts\mp\_gameobjects::allowuse("none");
	}

	level notify("zone_captured");
	level notify("zone_captured" + var_01);
}

//Function Number: 14
zone_onusebegin(param_00)
{
	self.didstatusnotify = 0;
	scripts\mp\_gameobjects::setusetime(level.zonecapturetime);
	thread scripts\mp\_gameobjects::useobjectdecay(param_00.team);
	if(level.zonecapturetime > 0)
	{
		self.prevownerteam = level.otherteam[param_00.team];
		scripts\mp\_gameobjects::setzonestatusicons(level.iconlosing,level.icontaking);
	}
}

//Function Number: 15
zone_onuseupdate(param_00,param_01,param_02,param_03)
{
	if(!level.timerstoppedforgamemode && level.pausemodetimer)
	{
		level scripts\mp\_gamelogic::pausetimer();
	}

	var_04 = scripts\mp\_gameobjects::getownerteam();
	var_05 = scripts\mp\_utility::getotherteam(param_00);
	if(param_01 > 0.05 && param_02 && !self.didstatusnotify)
	{
		if(var_04 == "neutral")
		{
			scripts\mp\_utility::statusdialog("hp_capturing_friendly",param_00);
			scripts\mp\_utility::statusdialog("hp_capturing_enemy",var_05);
		}
		else
		{
			scripts\mp\_utility::statusdialog("hp_capturing_enemy",var_04,1);
			scripts\mp\_utility::statusdialog("hp_capturing_friendly",param_00);
		}

		self.didstatusnotify = 1;
	}
}

//Function Number: 16
zone_onuseend(param_00,param_01,param_02)
{
	if(!param_02)
	{
		if(level.timerstoppedforgamemode && level.pausemodetimer)
		{
			level scripts\mp\_gamelogic::resumetimer();
		}
	}

	if(isplayer(param_01))
	{
		param_01 setclientomnvar("ui_objective_state",0);
		param_01.ui_dom_securing = undefined;
	}

	var_03 = level.zone.gameobject scripts\mp\_gameobjects::getownerteam();
	if(var_03 == "neutral")
	{
		level.zone.gameobject scripts\mp\_gameobjects::setzonestatusicons(level.iconneutral);
		foreach(param_01 in level.players)
		{
			level.zone.gameobject showzoneneutralbrush(param_01);
		}
	}
	else
	{
		level.zone.gameobject scripts\mp\_gameobjects::setzonestatusicons(level.icondefend,level.iconcapture);
		foreach(param_01 in level.players)
		{
			level.zone.gameobject showcapturedhardpointeffecttoplayer(var_03,param_01);
		}
	}

	if(!param_02)
	{
		if(level.timerstoppedforgamemode && level.pausemodetimer)
		{
			level scripts\mp\_gamelogic::resumetimer();
		}
	}
}

//Function Number: 17
zone_onunoccupied()
{
	if(level.usehqrules && self.ownerteam != "neutral")
	{
		return;
	}

	level notify("zone_destroyed");
	level.var_911E = "neutral";
	if(level.timerstoppedforgamemode && level.pausemodetimer)
	{
		level scripts\mp\_gamelogic::resumetimer();
	}

	if(self.numtouching["axis"] == 0 && self.numtouching["allies"] == 0)
	{
		level.zone.gameobject.wasleftunoccupied = 1;
		level scripts\mp\gametypes\koth::updateservericons("neutral",0);
		level.zone.gameobject scripts\mp\_gameobjects::setzonestatusicons(level.iconneutral);
		level.zone.gameobject playhardpointneutralfx();
		level.zone.gameobject thread updatechevrons("idle");
	}
}

//Function Number: 18
zone_oncontested()
{
	scripts\mp\_utility::setmlgannouncement(7,"free");
	if(level.timerstoppedforgamemode && level.pausemodetimer)
	{
		level scripts\mp\_gamelogic::resumetimer();
	}

	var_00 = level.zone.gameobject scripts\mp\_gameobjects::getownerteam();
	level.zone.gameobject scripts\mp\_gameobjects::setzonestatusicons(level.iconcontested);
	level scripts\mp\gametypes\koth::updateservericons(var_00,1);
	level.zone.gameobject thread updatechevrons("contested");
	foreach(var_02 in level.players)
	{
		level.zone.gameobject showcapturedhardpointeffecttoplayer(var_00,var_02);
	}

	if(var_00 == "neutral")
	{
		var_04 = self.claimteam;
	}
	else
	{
		var_04 = var_01;
	}

	scripts\mp\_utility::statusdialog("hp_contested",var_04,1);
	level.zone.gameobject thread scripts\mp\_matchdata::loggameevent("hill_contested",level.zone.origin);
}

//Function Number: 19
zone_onuncontested(param_00)
{
	if(!level.timerstoppedforgamemode && level.pausemodetimer)
	{
		level scripts\mp\_gamelogic::pausetimer();
	}

	var_01 = level.zone.gameobject scripts\mp\_gameobjects::getownerteam();
	if(param_00 == "none" || var_01 == "neutral")
	{
		level.zone.gameobject scripts\mp\_gameobjects::setzonestatusicons(level.iconneutral);
		foreach(var_03 in level.players)
		{
			level.zone.gameobject showzoneneutralbrush(var_03);
		}

		level.zone.gameobject thread scripts\mp\_matchdata::loggameevent("hill_empty",level.zone.origin);
	}
	else
	{
		level.zone.gameobject scripts\mp\_gameobjects::setzonestatusicons(level.icondefend,level.iconcapture);
		foreach(var_03 in level.players)
		{
			level.zone.gameobject showcapturedhardpointeffecttoplayer(var_01,var_03);
		}

		level.zone.gameobject thread scripts\mp\_matchdata::loggameevent("hill_uncontested",level.zone.origin);
	}

	var_07 = scripts\engine\utility::ter_op(var_01 == "neutral","idle",var_01);
	level.zone.gameobject thread updatechevrons(var_07);
	level scripts\mp\gametypes\koth::updateservericons(var_01,0);
}

//Function Number: 20
setcrankedtimerzonecap(param_00)
{
	if(isdefined(level.supportcranked) && level.supportcranked && isdefined(param_00.cranked) && param_00.cranked)
	{
		param_00 scripts\mp\_utility::setcrankedplayerbombtimer("assist");
	}
}

//Function Number: 21
playhardpointneutralfx()
{
	foreach(var_01 in level.players)
	{
		if(level.usehpzonebrushes)
		{
			showzoneneutralbrush(var_01);
		}
	}
}

//Function Number: 22
showcapturedhardpointeffecttoplayer(param_00,param_01)
{
	var_02 = param_01.team;
	var_03 = param_01 ismlgspectator();
	if(var_03)
	{
		var_02 = param_01 getmlgspectatorteam();
	}

	if(level.usehpzonebrushes)
	{
		if(level.zone.gameobject.stalemate)
		{
			showzonecontestedbrush(param_01);
			return;
		}

		if(var_02 == param_00)
		{
			showzonefriendlybrush(param_01);
			return;
		}

		showzoneenemybrush(param_01);
		return;
	}
}

//Function Number: 23
showzoneneutralbrush(param_00)
{
	level.zone.gameobject.friendlybrush hidefromplayer(param_00);
	level.zone.gameobject.enemybrush hidefromplayer(param_00);
	level.zone.gameobject.contestedbrush hidefromplayer(param_00);
	level.zone.gameobject.neutralbrush showtoplayer(param_00);
}

//Function Number: 24
showzonefriendlybrush(param_00)
{
	level.zone.gameobject.friendlybrush showtoplayer(param_00);
	level.zone.gameobject.enemybrush hidefromplayer(param_00);
	level.zone.gameobject.contestedbrush hidefromplayer(param_00);
	level.zone.gameobject.neutralbrush hidefromplayer(param_00);
}

//Function Number: 25
showzoneenemybrush(param_00)
{
	level.zone.gameobject.friendlybrush hidefromplayer(param_00);
	level.zone.gameobject.enemybrush showtoplayer(param_00);
	level.zone.gameobject.contestedbrush hidefromplayer(param_00);
	level.zone.gameobject.neutralbrush hidefromplayer(param_00);
}

//Function Number: 26
showzonecontestedbrush(param_00)
{
	level.zone.gameobject.friendlybrush hidefromplayer(param_00);
	level.zone.gameobject.enemybrush hidefromplayer(param_00);
	level.zone.gameobject.contestedbrush showtoplayer(param_00);
	level.zone.gameobject.neutralbrush hidefromplayer(param_00);
}

//Function Number: 27
hideplayerspecificbrushes(param_00)
{
	self.friendlybrush hidefromplayer(param_00);
	self.enemybrush hidefromplayer(param_00);
	self.neutralbrush hidefromplayer(param_00);
	self.contestedbrush hidefromplayer(param_00);
}

//Function Number: 28
func_8B4C()
{
	level endon("game_ended");
	self endon("flag_neutral");
	for(;;)
	{
		level waittill("joined_team",var_00);
		if(var_00.team != "spectator" && level.zone.gameobject.ownerteam != "neutral")
		{
			level.zone.gameobject showcapturedhardpointeffecttoplayer(level.zone.gameobject.ownerteam,var_00);
		}
	}
}

//Function Number: 29
postshipmodifychevrons(param_00)
{
	if(level.mapname == "mp_parkour")
	{
		var_01 = [];
		var_02 = [];
		var_03 = spawn("script_model",(176,-240,308));
		var_03 setmodel("hp_chevron_scriptable");
		var_03 = createvisualsinfo(var_03,(176,-240,308),(0,90,0),param_00);
		var_02[var_02.size] = var_03;
		var_04 = spawn("script_model",(112,-240,308));
		var_04 setmodel("hp_chevron_scriptable");
		var_04 = createvisualsinfo(var_04,(112,-240,308),(0,90,0),param_00);
		var_02[var_02.size] = var_04;
		var_05 = spawn("script_model",(48,-240,308));
		var_05 setmodel("hp_chevron_scriptable");
		var_05 = createvisualsinfo(var_05,(48,-240,308),(0,90,0),param_00);
		var_02[var_02.size] = var_05;
		var_06 = spawn("script_model",(-16,-240,308));
		var_06 setmodel("hp_chevron_scriptable");
		var_06 = createvisualsinfo(var_06,(-16,-240,308),(0,90,0),param_00);
		var_02[var_02.size] = var_06;
		var_07 = spawn("script_model",(-80,-240,308));
		var_07 setmodel("hp_chevron_scriptable");
		var_07 = createvisualsinfo(var_07,(-80,-240,308),(0,90,0),param_00);
		var_02[var_02.size] = var_07;
		var_08 = spawn("script_model",(-144,-240,308));
		var_08 setmodel("hp_chevron_scriptable");
		var_08 = createvisualsinfo(var_08,(-144,-240,308),(0,90,0),param_00);
		var_02[var_02.size] = var_08;
		var_09 = spawn("script_model",(-176,-192,308));
		var_09 setmodel("hp_chevron_scriptable");
		var_09 = createvisualsinfo(var_09,(-176,-192,308),(0,0,0),param_00);
		var_02[var_02.size] = var_09;
		var_0A = spawn("script_model",(-176,-128,308));
		var_0A setmodel("hp_chevron_scriptable");
		var_0A = createvisualsinfo(var_0A,(-176,-128,308),(0,0,0),param_00);
		var_02[var_02.size] = var_0A;
		var_0B = spawn("script_model",(-176,-64,308));
		var_0B setmodel("hp_chevron_scriptable");
		var_0B = createvisualsinfo(var_0B,(-176,-64,308),(0,0,0),param_00);
		var_02[var_02.size] = var_0B;
		var_0C = spawn("script_model",(-176,0,308));
		var_0C setmodel("hp_chevron_scriptable");
		var_0C = createvisualsinfo(var_0C,(-176,0,308),(0,0,0),param_00);
		var_02[var_02.size] = var_0C;
		var_0D = spawn("script_model",(-176,64,308));
		var_0D setmodel("hp_chevron_scriptable");
		var_0D = createvisualsinfo(var_0D,(-176,64,308),(0,0,0),param_00);
		var_02[var_02.size] = var_0D;
		var_0E = spawn("script_model",(-176,128,308));
		var_0E setmodel("hp_chevron_scriptable");
		var_0E = createvisualsinfo(var_0E,(-176,128,308),(0,0,0),param_00);
		var_02[var_02.size] = var_0E;
		var_0F = spawn("script_model",(-176,192,308));
		var_0F setmodel("hp_chevron_scriptable");
		var_0F = createvisualsinfo(var_0F,(-176,192,308),(0,0,0),param_00);
		var_02[var_02.size] = var_0F;
		var_10 = spawn("script_model",(-144,240,308));
		var_10 setmodel("hp_chevron_scriptable");
		var_10 = createvisualsinfo(var_10,(-144,240,308),(0,270,0),param_00);
		var_02[var_02.size] = var_10;
		var_11 = spawn("script_model",(-80,240,308));
		var_11 setmodel("hp_chevron_scriptable");
		var_11 = createvisualsinfo(var_11,(-80,240,308),(0,270,0),param_00);
		var_02[var_02.size] = var_11;
		var_12 = spawn("script_model",(-16,240,308));
		var_12 setmodel("hp_chevron_scriptable");
		var_12 = createvisualsinfo(var_12,(-16,240,308),(0,270,0),param_00);
		var_02[var_02.size] = var_12;
		var_13 = spawn("script_model",(48,240,308));
		var_13 setmodel("hp_chevron_scriptable");
		var_13 = createvisualsinfo(var_13,(48,240,308),(0,270,0),param_00);
		var_02[var_02.size] = var_13;
		var_14 = spawn("script_model",(112,240,308));
		var_14 setmodel("hp_chevron_scriptable");
		var_14 = createvisualsinfo(var_14,(112,240,308),(0,270,0),param_00);
		var_02[var_02.size] = var_14;
		var_15 = spawn("script_model",(176,240,308));
		var_15 setmodel("hp_chevron_scriptable");
		var_15 = createvisualsinfo(var_15,(176,240,308),(0,270,0),param_00);
		var_02[var_02.size] = var_15;
		foreach(var_17 in var_02)
		{
			var_18 = var_01.size;
			var_01[var_18] = var_17;
			var_01[var_18].numchevrons = 1;
		}

		return var_01;
	}
}

//Function Number: 30
createvisualsinfo(param_00,param_01,param_02,param_03)
{
	param_00.origin = param_01;
	param_00.angles = param_02;
	return param_00;
}