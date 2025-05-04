/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\cp\utility.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 354
 * Decompile Time: 17063 ms
 * Timestamp: 10/27/2023 12:10:48 AM
*******************************************************************/

//Function Number: 1
_giveweapon(param_00,param_01,param_02,param_03)
{
	if(!isdefined(param_01))
	{
		param_01 = -1;
	}

	if(!isdefined(param_03))
	{
		param_03 = 0;
	}

	if(issubstr(param_00,"+akimbo") || issubstr(param_00,"+g18pap2") || isdefined(param_02) && param_02 == 1)
	{
		self giveweapon(param_00,param_01,1,-1,param_03);
	}
	else
	{
		self giveweapon(param_00,param_01,0,-1,param_03);
	}

	thread updatelaststandpistol(param_00);
	return param_00;
}

//Function Number: 2
updatelaststandpistol(param_00)
{
	if(isdefined(param_00))
	{
		if(isdefined(level.last_stand_weapons))
		{
			var_01 = getweaponbasename(param_00);
			if(scripts\engine\utility::array_contains(level.last_stand_weapons,var_01))
			{
				self.last_stand_pistol = param_00;
				return;
			}
		}
	}

	var_02 = self getweaponslistall();
	var_03 = getweaponbasename(self.last_stand_pistol);
	var_04 = 0;
	foreach(var_06 in var_02)
	{
		var_07 = getweaponbasename(var_06);
		if(var_07 == var_03)
		{
			var_04 = 1;
			return;
		}
	}

	if(!var_04)
	{
		if(isdefined(level.last_stand_weapons))
		{
			foreach(var_06 in var_02)
			{
				var_07 = getweaponbasename(var_06);
				for(var_0A = level.last_stand_weapons.size - 1;var_0A > -1;var_0A--)
				{
					if(var_07 == level.last_stand_weapons[var_0A])
					{
						var_04 = 1;
						self.last_stand_pistol = var_06;
						return;
					}
				}
			}
		}

		var_0C = getrawbaseweaponname(self.default_starting_pistol);
		if(isdefined(self.weapon_build_models[var_0C]))
		{
			self.last_stand_pistol = self.weapon_build_models[var_0C];
			return;
		}

		self.last_stand_pistol = self.default_starting_pistol;
	}
}

//Function Number: 3
giveperk(param_00)
{
	if(issubstr(param_00,"specialty_weapon_"))
	{
		_setperk(param_00);
		return;
	}

	_setperk(param_00);
	_setextraperks(param_00);
}

//Function Number: 4
_hasperk(param_00)
{
	var_01 = self.perks;
	if(!isdefined(var_01))
	{
		return 0;
	}

	if(isdefined(var_01[param_00]))
	{
		return 1;
	}

	return 0;
}

//Function Number: 5
_setperk(param_00)
{
	self.perks[param_00] = 1;
	self.perksperkname[param_00] = param_00;
	var_01 = level.perksetfuncs[param_00];
	if(isdefined(var_01))
	{
		self thread [[ var_01 ]]();
	}

	self setperk(param_00,!isdefined(level.scriptperks[param_00]));
}

//Function Number: 6
_unsetperk(param_00)
{
	self.perks[param_00] = undefined;
	self.perksperkname[param_00] = undefined;
	if(isdefined(level.perkunsetfuncs[param_00]))
	{
		self thread [[ level.perkunsetfuncs[param_00] ]]();
	}

	self unsetperk(param_00,!isdefined(level.scriptperks[param_00]));
}

//Function Number: 7
_setextraperks(param_00)
{
	if(param_00 == "specialty_stun_resistance")
	{
		giveperk("specialty_empimmune");
	}

	if(param_00 == "specialty_hardline")
	{
		giveperk("specialty_assists");
	}

	if(param_00 == "specialty_incog")
	{
		giveperk("specialty_spygame");
		giveperk("specialty_coldblooded");
		giveperk("specialty_noscopeoutline");
		giveperk("specialty_heartbreaker");
	}

	if(param_00 == "specialty_blindeye")
	{
		giveperk("specialty_noplayertarget");
	}

	if(param_00 == "specialty_sharp_focus")
	{
		giveperk("specialty_reducedsway");
	}

	if(param_00 == "specialty_quickswap")
	{
		giveperk("specialty_fastoffhand");
	}
}

//Function Number: 8
_clearperks()
{
	foreach(var_02, var_01 in self.perks)
	{
		if(isdefined(level.perkunsetfuncs[var_02]))
		{
			self [[ level.perkunsetfuncs[var_02] ]]();
		}
	}

	self.perks = [];
	self.perksperkname = [];
	self getplayerlookattarget();
}

//Function Number: 9
clearlowermessages()
{
	if(isdefined(self.lowermessages))
	{
		for(var_00 = 0;var_00 < self.lowermessages.size;var_00++)
		{
			self.lowermessages[var_00] = undefined;
		}
	}

	if(!isdefined(self.lowermessage))
	{
		return;
	}

	updatelowermessage();
}

//Function Number: 10
setlowermessage(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09)
{
	if(!isdefined(param_03))
	{
		param_03 = 1;
	}

	if(!isdefined(param_02))
	{
		param_02 = 0;
	}

	if(!isdefined(param_04))
	{
		param_04 = 0;
	}

	if(!isdefined(param_05))
	{
		param_05 = 0;
	}

	if(!isdefined(param_06))
	{
		param_06 = 0.85;
	}

	if(!isdefined(param_07))
	{
		param_07 = 3;
	}

	if(!isdefined(param_08))
	{
		param_08 = 0;
	}

	if(!isdefined(param_09))
	{
		param_09 = 1;
	}

	addlowermessage(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09);
	updatelowermessage();
}

//Function Number: 11
play_bink_video(param_00,param_01,param_02)
{
	level thread play_bink_video_internal(param_00,param_01,param_02);
}

//Function Number: 12
play_bink_video_internal(param_00,param_01,param_02)
{
	foreach(var_04 in level.players)
	{
		var_04 freezecontrolswrapper(1);
	}

	setomnvar("bink_video_active",1);
	playcinematicforall(param_00);
	wait(param_01);
	setomnvar("bink_video_active",0);
	foreach(var_04 in level.players)
	{
		var_04 freezecontrolswrapper(0);
		if(!isdefined(param_02) || !param_02)
		{
			var_04 thread player_black_screen(0,1,0.5,1);
		}
	}
}

//Function Number: 13
updatelowermessage()
{
	self endon("disconnect");
	if(!isdefined(self))
	{
		return;
	}

	var_00 = getlowermessage();
	if(!isdefined(var_00))
	{
		if(isdefined(self.lowermessage))
		{
			self.lowermessage.alpha = 0;
			self.lowermessage settext("");
			if(isdefined(self.lowertimer))
			{
				self.lowertimer.alpha = 0;
			}
		}

		return;
	}

	self.lowermessage settext(var_00.text);
	self.lowermessage.alpha = 0.85;
	self.lowertimer.alpha = 1;
	self.lowermessage.hidewhenindemo = var_00.hidewhenindemo;
	self.lowermessage.hidewheninmenu = var_00.hidewheninmenu;
	if(var_00.shouldfade)
	{
		self.lowermessage fadeovertime(min(var_00.fadetoalphatime,60));
		self.lowermessage.alpha = var_00.fadetoalphatime;
	}

	if(var_00.time > 0 && var_00.showtimer)
	{
		self.lowertimer settimer(max(var_00.time - gettime() - var_00.addtime / 1000,0.1));
		return;
	}

	if(var_00.time > 0 && !var_00.showtimer)
	{
		self.lowertimer settext("");
		self.lowermessage fadeovertime(min(var_00.time,60));
		self.lowermessage.alpha = 0;
		thread clearondeath(var_00);
		thread clearafterfade(var_00);
		return;
	}

	self.lowertimer settext("");
}

//Function Number: 14
addlowermessage(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09)
{
	var_0A = undefined;
	foreach(var_0C in self.lowermessages)
	{
		if(var_0C.name == param_00)
		{
			if(var_0C.text == param_01 && var_0C.priority == param_03)
			{
				return;
			}

			var_0A = var_0C;
			break;
		}
	}

	if(!isdefined(var_0A))
	{
		var_0A = spawnstruct();
		self.lowermessages[self.lowermessages.size] = var_0A;
	}

	var_0A.name = param_00;
	var_0A.text = param_01;
	var_0A.time = param_02;
	var_0A.addtime = gettime();
	var_0A.priority = param_03;
	var_0A.showtimer = param_04;
	var_0A.shouldfade = param_05;
	var_0A.fadetoalphatime = param_06;
	var_0A.fadetoalphatime = param_07;
	var_0A.hidewhenindemo = param_08;
	var_0A.hidewheninmenu = param_09;
	sortlowermessages();
}

//Function Number: 15
sortlowermessages()
{
	for(var_00 = 1;var_00 < self.lowermessages.size;var_00++)
	{
		var_01 = self.lowermessages[var_00];
		var_02 = var_01.priority;
		for(var_03 = var_00 - 1;var_03 >= 0 && var_02 > self.lowermessages[var_03].priority;var_03--)
		{
			self.lowermessages[var_03 + 1] = self.lowermessages[var_03];
		}

		self.lowermessages[var_03 + 1] = var_01;
	}
}

//Function Number: 16
getlowermessage()
{
	if(!isdefined(self.lowermessages))
	{
		return undefined;
	}

	return self.lowermessages[0];
}

//Function Number: 17
clearondeath(param_00)
{
	self notify("message_cleared");
	self endon("message_cleared");
	self endon("disconnect");
	level endon("game_ended");
	self waittill("death");
	clearlowermessage(param_00.name);
}

//Function Number: 18
clearafterfade(param_00)
{
	wait(param_00.time);
	clearlowermessage(param_00.name);
	self notify("message_cleared");
}

//Function Number: 19
clearlowermessage(param_00)
{
	removelowermessage(param_00);
	updatelowermessage();
}

//Function Number: 20
removelowermessage(param_00)
{
	if(isdefined(self.lowermessages))
	{
		for(var_01 = self.lowermessages.size;var_01 > 0;var_01--)
		{
			if(self.lowermessages[var_01 - 1].name != param_00)
			{
				continue;
			}

			var_02 = self.lowermessages[var_01 - 1];
			for(var_03 = var_01;var_03 < self.lowermessages.size;var_03++)
			{
				if(isdefined(self.lowermessages[var_03]))
				{
					self.lowermessages[var_03 - 1] = self.lowermessages[var_03];
				}
			}

			self.lowermessages[self.lowermessages.size - 1] = undefined;
		}

		sortlowermessages();
	}
}

//Function Number: 21
freezecontrolswrapper(param_00)
{
	if(isdefined(level.hostmigrationtimer))
	{
		self.hostmigrationcontrolsfrozen = 1;
		self freezecontrols(1);
		return;
	}

	self freezecontrols(param_00);
	self.controlsfrozen = param_00;
}

//Function Number: 22
setthirdpersondof(param_00)
{
	if(param_00)
	{
		self setdepthoffield(0,110,512,4096,6,1.8);
		return;
	}

	self setdepthoffield(0,0,512,512,4,0);
}

//Function Number: 23
setusingremote(param_00)
{
	if(isdefined(self.carryicon))
	{
		self.carryicon.alpha = 0;
	}

	self.usingremote = param_00;
	if(scripts\engine\utility::isoffhandweaponsallowed())
	{
		scripts\engine\utility::allow_offhand_weapons(0);
	}

	self notify("using_remote");
}

//Function Number: 24
isusingremote()
{
	return isdefined(self.usingremote);
}

//Function Number: 25
updatesessionstate(param_00,param_01)
{
	self.sessionstate = param_00;
	if(!isdefined(param_01))
	{
		param_01 = "";
	}

	self.getgrenadefusetime = param_01;
	self setclientomnvar("ui_session_state",param_00);
}

//Function Number: 26
getuniqueid()
{
	if(isdefined(self.pers["guid"]))
	{
		return self.pers["guid"];
	}

	var_00 = self getguid();
	if(var_00 == "0000000000000000")
	{
		if(isdefined(level.guidgen))
		{
			level.var_86BF++;
		}
		else
		{
			level.guidgen = 1;
		}

		var_00 = "script" + level.guidgen;
	}

	self.pers["guid"] = var_00;
	return self.pers["guid"];
}

//Function Number: 27
gameflagset(param_00)
{
	game["flags"][param_00] = 1;
	level notify(param_00);
}

//Function Number: 28
gameflaginit(param_00,param_01)
{
	game["flags"][param_00] = param_01;
}

//Function Number: 29
gameflag(param_00)
{
	return game["flags"][param_00];
}

//Function Number: 30
gameflagwait(param_00)
{
	while(!gameflag(param_00))
	{
		level waittill(param_00);
	}
}

//Function Number: 31
matchmakinggame()
{
	return level.onlinegame && !getdvarint("xblive_privatematch");
}

//Function Number: 32
inovertime()
{
	return isdefined(game["status"]) && game["status"] == "overtime";
}

//Function Number: 33
initlevelflags()
{
	if(!isdefined(level.levelflags))
	{
		level.levelflags = [];
	}
}

//Function Number: 34
initgameflags()
{
	if(!isdefined(game["flags"]))
	{
		game["flags"] = [];
	}
}

//Function Number: 35
func_F305()
{
	if(!scripts\engine\utility::add_init_script("platform",::func_F305))
	{
		return;
	}

	if(!isdefined(level.console))
	{
		level.console = getdvar("consoleGame") == "true";
	}
	else
	{
	}

	if(!isdefined(level.var_13E0F))
	{
		level.var_13E0F = getdvar("xenonGame") == "true";
	}
	else
	{
	}

	if(!isdefined(level.var_DADB))
	{
		level.var_DADB = getdvar("ps3Game") == "true";
	}
	else
	{
	}

	if(!isdefined(level.var_13E0E))
	{
		level.var_13E0E = getdvar("xb3Game") == "true";
	}
	else
	{
	}

	if(!isdefined(level.var_DADC))
	{
		level.var_DADC = getdvar("ps4Game") == "true";
	}
}

//Function Number: 36
isenemy(param_00)
{
	if(level.teambased)
	{
		return isplayeronenemyteam(param_00);
	}

	return isplayerffaenemy(param_00);
}

//Function Number: 37
isplayeronenemyteam(param_00)
{
	return param_00.team != self.team;
}

//Function Number: 38
isplayerffaenemy(param_00)
{
	if(isdefined(param_00.triggerportableradarping))
	{
		return param_00.triggerportableradarping != self;
	}

	return param_00 != self;
}

//Function Number: 39
notusableforjoiningplayers(param_00)
{
	self notify("notusablejoiningplayers");
	self endon("death");
	level endon("game_ended");
	param_00 endon("disconnect");
	param_00 endon("death");
	self endon("notusablejoiningplayers");
	for(;;)
	{
		level waittill("player_spawned",var_01);
		if(isdefined(var_01) && var_01 != param_00)
		{
			self disableplayeruse(var_01);
		}
	}
}

//Function Number: 40
setselfusable(param_00)
{
	self makeusable();
	foreach(var_02 in level.players)
	{
		if(var_02 != param_00)
		{
			self disableplayeruse(var_02);
			continue;
		}

		self enableplayeruse(var_02);
	}
}

//Function Number: 41
isenvironmentweapon(param_00)
{
	if(!isdefined(param_00))
	{
		return 0;
	}

	if(param_00 == "turret_minigun_mp")
	{
		return 1;
	}

	return 0;
}

//Function Number: 42
issuperweapon(param_00)
{
	if(!isdefined(param_00))
	{
		return 0;
	}

	if(isdefined(level.superweapons) && isdefined(level.superweapons[param_00]))
	{
		return 1;
	}

	return 0;
}

//Function Number: 43
strip_suffix(param_00,param_01)
{
	if(param_00.size <= param_01.size)
	{
		return param_00;
	}

	if(getsubstr(param_00,param_00.size - param_01.size,param_00.size) == param_01)
	{
		return getsubstr(param_00,0,param_00.size - param_01.size);
	}

	return param_00;
}

//Function Number: 44
playteamfxforclient(param_00,param_01,param_02,param_03,param_04,param_05)
{
	var_06 = undefined;
	if(self.team != param_00)
	{
		var_06 = function_01E1(scripts\engine\utility::getfx(param_03),param_01,self);
	}
	else
	{
		var_06 = function_01E1(scripts\engine\utility::getfx(param_02),param_01,self);
	}

	if(isdefined(var_06))
	{
		triggerfx(var_06);
	}

	var_06 thread delayentdelete(param_04);
	if(isdefined(param_05) && param_05)
	{
		var_06 thread deleteonplayerdeathdisconnect(self);
	}

	return var_06;
}

//Function Number: 45
delayentdelete(param_00)
{
	self endon("death");
	wait(param_00);
	if(isdefined(self))
	{
		self delete();
	}
}

//Function Number: 46
deleteonplayerdeathdisconnect(param_00)
{
	self endon("death");
	param_00 scripts\engine\utility::waittill_any_3("death","disconnect");
	self delete();
}

//Function Number: 47
isstrstart(param_00,param_01)
{
	return getsubstr(param_00,0,param_01.size) == param_01;
}

//Function Number: 48
isreallyalive(param_00)
{
	if(isalive(param_00) && !isdefined(param_00.fauxdeath))
	{
		return 1;
	}

	return 0;
}

//Function Number: 49
getbaseweaponname(param_00)
{
	var_01 = strtok(param_00,"_");
	if(var_01[0] == "iw5" || var_01[0] == "iw6" || var_01[0] == "iw7")
	{
		param_00 = var_01[0] + "_" + var_01[1];
	}
	else if(var_01[0] == "alt")
	{
		param_00 = var_01[1] + "_" + var_01[2];
	}

	return param_00;
}

//Function Number: 50
getzbaseweaponname(param_00,param_01)
{
	var_02 = strtok(param_00,"_");
	if(var_02[0] == "iw5" || var_02[0] == "iw6" || var_02[0] == "iw7")
	{
		if(isdefined(param_01) && param_01 > 1)
		{
			param_00 = var_02[0] + "_z" + var_02[1] + param_01;
		}
		else
		{
			param_00 = var_02[0] + "_z" + var_02[1];
		}
	}
	else if(var_02[0] == "alt")
	{
		if(isdefined(param_01) && param_01 > 1)
		{
			param_00 = var_02[1] + "_z" + var_02[2] + param_01;
		}
		else
		{
			param_00 = var_02[1] + "_z" + var_02[2];
		}
	}

	return param_00;
}

//Function Number: 51
get_closest_entrance(param_00)
{
	var_01 = sortbydistance(level.window_entrances,param_00);
	foreach(var_03 in var_01)
	{
		if(var_03.enabled)
		{
			return var_03;
		}
	}

	return undefined;
}

//Function Number: 52
entrance_is_fully_repaired(param_00)
{
	if(!isdefined(param_00.barrier))
	{
		return 1;
	}

	var_01 = scripts/cp/zombies/zombie_entrances::func_7B13(param_00);
	if(!isdefined(var_01))
	{
		return 1;
	}

	return 0;
}

//Function Number: 53
is_weapon_purchase_disabled()
{
	return scripts\engine\utility::istrue(level.weapon_purchase_disabled);
}

//Function Number: 54
get_attachment_from_interaction(param_00)
{
	var_01 = param_00.randomintrange.model;
	var_02 = "arkblue";
	var_03 = "stun_ammo";
	switch(var_01)
	{
		case "attachment_zmb_arcane_muzzlebrake_wm":
			var_02 = "arcane_base";
			break;

		default:
			break;
	}

	return var_02;
}

//Function Number: 55
are_any_consumables_active()
{
	foreach(var_01 in self.consumables)
	{
		if(var_01.on == 1)
		{
			return 1;
		}
	}

	return 0;
}

//Function Number: 56
getrawbaseweaponname(param_00)
{
	var_01 = strtok(param_00,"_");
	if(var_01[0] == "iw5" || var_01[0] == "iw6" || var_01[0] == "iw7")
	{
		param_00 = var_01[1];
	}
	else if(var_01[0] == "alt")
	{
		param_00 = var_01[2];
	}

	return param_00;
}

//Function Number: 57
getintproperty(param_00,param_01)
{
	var_02 = param_01;
	var_02 = getdvarint(param_00,param_01);
	return var_02;
}

//Function Number: 58
leaderdialogonplayer(param_00,param_01,param_02,param_03)
{
	if(!isdefined(game["dialog"][param_00]))
	{
		return;
	}

	var_04 = self.pers["team"];
	if(isdefined(var_04) && var_04 == "axis" || var_04 == "allies")
	{
		var_05 = game["voice"][var_04] + game["dialog"][param_00];
		self _meth_8252(var_05,param_00,2,param_01,param_02,param_03);
	}
}

//Function Number: 59
_setactionslot(param_00,param_01,param_02)
{
	self.saved_actionslotdata[param_00].type = param_01;
	self.saved_actionslotdata[param_00].randomintrange = param_02;
	self setactionslot(param_00,param_01,param_02);
}

//Function Number: 60
getkillstreakweapon(param_00)
{
	return tablelookup(level.global_tables["killstreakTable"].path,level.global_tables["killstreakTable"].ref_col,param_00,level.global_tables["killstreakTable"].weapon_col);
}

//Function Number: 61
_objective_delete(param_00)
{
	function_0154(param_00);
	if(!isdefined(level.reclaimedreservedobjectives))
	{
		level.reclaimedreservedobjectives = [];
		level.reclaimedreservedobjectives[0] = param_00;
		return;
	}

	level.reclaimedreservedobjectives[level.reclaimedreservedobjectives.size] = param_00;
}

//Function Number: 62
touchingbadtrigger(param_00)
{
	var_01 = getentarray("trigger_hurt","classname");
	foreach(var_03 in var_01)
	{
		if(self istouching(var_03) && level.mapname != "mp_mine" || var_03.var_F5 > 0)
		{
			return 1;
		}
	}

	var_05 = getentarray("radiation","targetname");
	foreach(var_03 in var_05)
	{
		if(self istouching(var_03))
		{
			return 1;
		}
	}

	if(isdefined(param_00) && param_00 == "gryphon")
	{
		var_08 = getentarray("gryphonDeath","targetname");
		foreach(var_03 in var_08)
		{
			if(self istouching(var_03))
			{
				return 1;
			}
		}
	}

	return 0;
}

//Function Number: 63
playsoundinspace(param_00,param_01,param_02)
{
	if(isdefined(param_00))
	{
		if(isarray(param_00))
		{
			param_00 = scripts\engine\utility::random(param_00);
		}

		var_03 = lookupsoundlength(param_00);
		playsoundatpos(param_01,param_00);
		if(isdefined(param_02))
		{
			wait(var_03 / 1000);
		}

		return var_03;
	}
}

//Function Number: 64
play_random_sound_in_space(param_00,param_01,param_02)
{
	if(isdefined(param_00))
	{
		if(!isarray(param_00))
		{
			var_03 = [];
			var_03[0] = param_00;
			param_00 = var_03[0];
		}

		var_04 = scripts\engine\utility::random(param_00);
		var_05 = lookupsoundlength(var_04);
		playsoundatpos(param_01,var_04);
		if(isdefined(param_02))
		{
			wait(var_05);
		}

		return var_05;
	}
}

//Function Number: 65
play_looping_sound_on_ent(param_00)
{
	if(soundexists(param_00))
	{
		self playloopsound(param_00);
	}
}

//Function Number: 66
stop_looping_sound_on_ent(param_00)
{
	if(soundexists(param_00))
	{
		self stoploopsound(param_00);
	}
}

//Function Number: 67
playdeathsound()
{
	var_00 = randomintrange(1,8);
	var_01 = "generic";
	if(self getstruct_delete())
	{
		var_01 = "female";
	}

	if(self.team == "axis")
	{
		var_02 = var_01 + "_death_russian_" + var_00;
		if(soundexists(var_02))
		{
			self playsound(var_02);
			return;
		}

		return;
	}

	var_02 = var_02 + "_death_american_" + var_01;
	if(soundexists(var_02))
	{
		self playsound(var_02);
	}
}

//Function Number: 68
isfmjdamage(param_00,param_01,param_02)
{
	return isdefined(param_02) && param_02 _hasperk("specialty_bulletpenetration") && isdefined(param_01) && scripts\engine\utility::isbulletdamage(param_01);
}

//Function Number: 69
ischangingweapon()
{
	return isdefined(self.changingweapon);
}

//Function Number: 70
getattachmenttype(param_00)
{
	if(!isdefined(param_00))
	{
		return "none";
	}

	var_01 = tablelookup("mp/attachmentTable.csv",4,param_00,2);
	if(!isdefined(var_01) || isdefined(var_01) && var_01 == "")
	{
		var_02 = getdvar("g_gametype");
		if(var_02 == "zombie")
		{
			var_01 = tablelookup("cp/zombies/zombie_attachmentTable.csv",4,param_00,2);
		}
	}

	return var_01;
}

//Function Number: 71
weaponhasattachment(param_00,param_01)
{
	if(!isdefined(param_00) || param_00 == "none" || param_00 == "")
	{
		return 0;
	}

	var_02 = getweaponattachmentsbasenames(param_00);
	foreach(var_04 in var_02)
	{
		if(var_04 == param_01)
		{
			return 1;
		}
	}

	return 0;
}

//Function Number: 72
getweaponattachmentsbasenames(param_00)
{
	var_01 = function_00E3(param_00);
	foreach(var_04, var_03 in var_01)
	{
		var_01[var_04] = attachmentmap_tobase(var_03);
	}

	return var_01;
}

//Function Number: 73
attachmentmap_tobase(param_00)
{
	if(isdefined(level.attachmentmap_uniquetobase[param_00]))
	{
		param_00 = level.attachmentmap_uniquetobase[param_00];
	}

	return param_00;
}

//Function Number: 74
bot_is_fireteam_mode()
{
	var_00 = function_001F() == 2;
	if(var_00)
	{
		if(!level.teambased || level.gametype != "war" && level.gametype != "dom")
		{
			return 0;
		}

		return 1;
	}

	return 0;
}

//Function Number: 75
isjuggernaut()
{
	if(isdefined(self.isjuggernaut) && self.isjuggernaut == 1)
	{
		return 1;
	}

	if(isdefined(self.isjuggernautdef) && self.isjuggernautdef == 1)
	{
		return 1;
	}

	if(isdefined(self.isjuggernautgl) && self.isjuggernautgl == 1)
	{
		return 1;
	}

	if(isdefined(self.isjuggernautrecon) && self.isjuggernautrecon == 1)
	{
		return 1;
	}

	if(isdefined(self.isjuggernautmaniac) && self.isjuggernautmaniac == 1)
	{
		return 1;
	}

	if(isdefined(self.isjuggernautlevelcustom) && self.isjuggernautlevelcustom == 1)
	{
		return 1;
	}

	return 0;
}

//Function Number: 76
attachmentmap_tounique(param_00,param_01)
{
	var_02 = getweaponrootname(param_01);
	if(var_02 != param_01)
	{
		var_03 = getweaponbasename(param_01);
		var_04 = strtok(var_03,"_");
		var_05 = "mp" + getsubstr(var_04[2],2,var_04[2].size);
		var_06 = var_04[0];
		for(var_07 = 1;var_07 < var_04.size;var_07++)
		{
			if(var_07 == 2)
			{
				var_06 = var_06 + "_" + var_05;
				continue;
			}

			var_06 = var_06 + "_" + var_04[var_07];
		}

		if(isdefined(level.attachmentmap_basetounique[var_03]) && isdefined(level.attachmentmap_uniquetobase[param_00]) && isdefined(level.attachmentmap_basetounique[var_03][level.attachmentmap_uniquetobase[param_00]]))
		{
			var_08 = level.attachmentmap_uniquetobase[param_00];
			return level.attachmentmap_basetounique[var_03][var_08];
		}
		else if(isdefined(level.attachmentmap_basetounique[var_07]) && isdefined(level.attachmentmap_uniquetobase[param_01]) && isdefined(level.attachmentmap_basetounique[var_07][level.attachmentmap_uniquetobase[param_01]]))
		{
			var_08 = level.attachmentmap_uniquetobase[param_01];
			return level.attachmentmap_basetounique[var_06][var_08];
		}
		else if(isdefined(level.attachmentmap_basetounique[var_04]) && isdefined(level.attachmentmap_basetounique[var_04][param_01]))
		{
			return level.attachmentmap_basetounique[var_04][param_01];
		}
		else if(isdefined(level.attachmentmap_basetounique[var_07]) && isdefined(level.attachmentmap_basetounique[var_07][param_01]))
		{
			return level.attachmentmap_basetounique[var_07][param_01];
		}
		else if(var_05.size > 3)
		{
			var_09 = var_05[0] + "_" + var_05[1] + "_" + var_05[2];
			if(isdefined(level.attachmentmap_basetounique[var_09]) && isdefined(level.attachmentmap_basetounique[var_09][param_01]))
			{
				return level.attachmentmap_basetounique[var_09][param_01];
			}
			else
			{
				var_0A = strtok(var_07,"_");
				var_0B = var_0A[0] + "_" + var_0A[1] + "_" + var_0A[2];
				if(isdefined(level.attachmentmap_basetounique[var_0B]) && isdefined(level.attachmentmap_basetounique[var_0B][param_01]))
				{
					return level.attachmentmap_basetounique[var_0B][param_01];
				}
			}
		}
	}

	if(isdefined(level.attachmentmap_basetounique[var_03]) && isdefined(level.attachmentmap_basetounique[var_03][param_01]))
	{
		return level.attachmentmap_basetounique[var_03][param_01];
	}
	else
	{
		var_0C = weapongroupmap(var_03);
		if(isdefined(var_0C) && isdefined(level.attachmentmap_basetounique[var_0C]) && isdefined(level.attachmentmap_basetounique[var_0C][param_01]))
		{
			return level.attachmentmap_basetounique[var_0C][param_01];
		}
	}

	return param_01;
}

//Function Number: 77
weapongroupmap(param_00)
{
	if(isdefined(level.weaponmapdata[param_00]) && isdefined(level.weaponmapdata[param_00].group))
	{
		return level.weaponmapdata[param_00].group;
	}

	return undefined;
}

//Function Number: 78
iskillstreakweapon(param_00)
{
	if(!isdefined(param_00))
	{
		return 0;
	}

	if(param_00 == "none")
	{
		return 0;
	}

	if(scripts\engine\utility::isdestructibleweapon(param_00))
	{
		return 0;
	}

	if(issubstr(param_00,"killstreak"))
	{
		return 1;
	}

	if(issubstr(param_00,"remote_tank_projectile"))
	{
		return 1;
	}

	if(issubstr(param_00,"minijackal_"))
	{
		return 1;
	}

	if(isdefined(level.killstreakweildweapons) && isdefined(level.killstreakweildweapons[param_00]))
	{
		return 1;
	}

	if(scripts\engine\utility::isairdropmarker(param_00))
	{
		return 1;
	}

	var_01 = function_0244(param_00);
	if(isdefined(var_01) && var_01 == "exclusive")
	{
		return 1;
	}

	return 0;
}

//Function Number: 79
clearusingremote()
{
	if(isdefined(self.carryicon))
	{
		self.carryicon.alpha = 1;
	}

	self.usingremote = undefined;
	if(!scripts\engine\utility::isoffhandweaponsallowed())
	{
		scripts\engine\utility::allow_offhand_weapons(1);
	}

	var_00 = self getcurrentweapon();
	if(var_00 == "none" || iskillstreakweapon(var_00))
	{
		var_01 = scripts\engine\utility::getlastweapon();
		if(isreallyalive(self))
		{
			if(!self hasweapon(var_01))
			{
				var_01 = getfirstprimaryweapon();
			}

			self switchtoweapon(var_01);
		}
	}

	freezecontrolswrapper(0);
	self notify("stopped_using_remote");
}

//Function Number: 80
getfirstprimaryweapon()
{
	var_00 = self getweaponslistprimaries();
	return var_00[0];
}

//Function Number: 81
set_visionset_for_watching_players(param_00,param_01,param_02,param_03,param_04,param_05)
{
	var_06 = get_players_watching(param_04,param_05);
	foreach(var_08 in var_06)
	{
		var_08 notify("changing_watching_visionset");
		if(isdefined(param_03) && param_03)
		{
			var_08 visionsetmissilecamforplayer(param_00,param_01);
		}
		else
		{
			var_08 visionsetnakedforplayer(param_00,param_01);
		}

		if(param_00 != "" && isdefined(param_02))
		{
			var_08 thread reset_visionset_on_team_change(self,param_01 + param_02);
			var_08 thread reset_visionset_on_disconnect(self);
			if(var_08 isinkillcam())
			{
				var_08 thread reset_visionset_on_spawn();
			}
		}
	}
}

//Function Number: 82
get_players_watching(param_00,param_01)
{
	if(!isdefined(param_00))
	{
		param_00 = 0;
	}

	if(!isdefined(param_01))
	{
		param_01 = 0;
	}

	var_02 = self getentitynumber();
	var_03 = [];
	foreach(var_05 in level.players)
	{
		if(var_05 == self)
		{
			continue;
		}

		var_06 = 0;
		if(!param_01)
		{
			if(var_05.team == "spectator" || var_05.sessionstate == "spectator")
			{
				var_07 = var_05 getspectatingplayer();
				if(isdefined(var_07) && var_07 == self)
				{
					var_06 = 1;
				}
			}

			if(var_05.missile_createrepulsorent == var_02)
			{
				var_06 = 1;
			}
		}

		if(!param_00)
		{
			if(var_05.setclientmatchdatadef == var_02)
			{
				var_06 = 1;
			}
		}

		if(var_06)
		{
			var_03[var_03.size] = var_05;
		}
	}

	return var_03;
}

//Function Number: 83
reset_visionset_on_team_change(param_00,param_01)
{
	self endon("changing_watching_visionset");
	var_02 = gettime();
	var_03 = self.team;
	while(gettime() - var_02 < param_01 * 1000)
	{
		if(self.team != var_03 || !scripts\engine\utility::array_contains(param_00 get_players_watching(),self))
		{
			self visionsetnakedforplayer("",0);
			self notify("changing_visionset");
			break;
		}

		wait(0.05);
	}
}

//Function Number: 84
reset_visionset_on_disconnect(param_00)
{
	self endon("changing_watching_visionset");
	param_00 waittill("disconnect");
	if(isdefined(level.vision_set_override))
	{
		self visionsetnakedforplayer(level.vision_set_override,0);
		return;
	}

	self visionsetnakedforplayer("",0);
}

//Function Number: 85
reset_visionset_on_spawn()
{
	self endon("disconnect");
	self waittill("spawned");
	if(isdefined(level.vision_set_override))
	{
		self visionsetnakedforplayer(level.vision_set_override,0);
		return;
	}

	self visionsetnakedforplayer("",0);
}

//Function Number: 86
isinkillcam()
{
	return self.clearstartpointtransients;
}

//Function Number: 87
func_F6DB(param_00,param_01,param_02)
{
	if(!isdefined(level.console) || !isdefined(level.var_13E0E) || !isdefined(level.var_DADC))
	{
		func_F305();
	}

	if(func_9BEE())
	{
		setdvar(param_00,param_02);
		return;
	}

	setdvar(param_00,param_01);
}

//Function Number: 88
func_9BEE()
{
	if(level.var_13E0E || level.var_DADC || !level.console)
	{
		return 1;
	}

	return 0;
}

//Function Number: 89
createfontstring(param_00,param_01,param_02)
{
	if(!isdefined(param_02) || !param_02)
	{
		var_03 = newclienthudelem(self);
	}
	else
	{
		var_03 = newhudelem();
	}

	var_03.elemtype = "font";
	var_03.font = param_00;
	var_03.fontscale = param_01;
	var_03.basefontscale = param_01;
	var_03.x = 0;
	var_03.y = 0;
	var_03.width = 0;
	var_03.height = int(level.fontheight * param_01);
	var_03.xoffset = 0;
	var_03.yoffset = 0;
	var_03.children = [];
	var_03 setparent(level.uiparent);
	var_03.hidden = 0;
	return var_03;
}

//Function Number: 90
setparent(param_00)
{
	if(isdefined(self.parent) && self.parent == param_00)
	{
		return;
	}

	if(isdefined(self.parent))
	{
		self.parent removechild(self);
	}

	self.parent = param_00;
	self.parent addchild(self);
	if(isdefined(self.point))
	{
		setpoint(self.point,self.relativepoint,self.xoffset,self.yoffset);
		return;
	}

	setpoint("TOPLEFT");
}

//Function Number: 91
removechild(param_00)
{
	param_00.parent = undefined;
	if(self.children[self.children.size - 1] != param_00)
	{
		self.children[param_00.index] = self.children[self.children.size - 1];
		self.children[param_00.index].index = param_00.index;
	}

	self.children[self.children.size - 1] = undefined;
	param_00.index = undefined;
}

//Function Number: 92
addchild(param_00)
{
	param_00.index = self.children.size;
	self.children[self.children.size] = param_00;
	removedestroyedchildren();
}

//Function Number: 93
removedestroyedchildren()
{
	if(isdefined(self.childchecktime) && self.childchecktime == gettime())
	{
		return;
	}

	self.childchecktime = gettime();
	var_00 = [];
	foreach(var_02 in self.children)
	{
		if(!isdefined(var_02))
		{
			continue;
		}

		var_02.index = var_00.size;
		var_00[var_00.size] = var_02;
	}

	self.children = var_00;
}

//Function Number: 94
setpoint(param_00,param_01,param_02,param_03,param_04)
{
	if(!isdefined(param_04))
	{
		param_04 = 0;
	}

	var_05 = getparent();
	if(param_04)
	{
		self moveovertime(param_04);
	}

	if(!isdefined(param_02))
	{
		param_02 = 0;
	}

	self.xoffset = param_02;
	if(!isdefined(param_03))
	{
		param_03 = 0;
	}

	self.yoffset = param_03;
	self.point = param_00;
	self.alignx = "center";
	self.aligny = "middle";
	if(issubstr(param_00,"TOP"))
	{
		self.aligny = "top";
	}

	if(issubstr(param_00,"BOTTOM"))
	{
		self.aligny = "bottom";
	}

	if(issubstr(param_00,"LEFT"))
	{
		self.alignx = "left";
	}

	if(issubstr(param_00,"RIGHT"))
	{
		self.alignx = "right";
	}

	if(!isdefined(param_01))
	{
		param_01 = param_00;
	}

	self.relativepoint = param_01;
	var_06 = "center_adjustable";
	var_07 = "middle";
	if(issubstr(param_01,"TOP"))
	{
		var_07 = "top_adjustable";
	}

	if(issubstr(param_01,"BOTTOM"))
	{
		var_07 = "bottom_adjustable";
	}

	if(issubstr(param_01,"LEFT"))
	{
		var_06 = "left_adjustable";
	}

	if(issubstr(param_01,"RIGHT"))
	{
		var_06 = "right_adjustable";
	}

	if(var_05 == level.uiparent)
	{
		self.horzalign = var_06;
		self.vertalign = var_07;
	}
	else
	{
		self.horzalign = var_05.horzalign;
		self.vertalign = var_05.vertalign;
	}

	if(strip_suffix(var_06,"_adjustable") == var_05.alignx)
	{
		var_08 = 0;
		var_09 = 0;
	}
	else if(var_08 == "center" || var_07.alignx == "center")
	{
		var_08 = int(var_07.width / 2);
		if(var_07 == "left_adjustable" || var_06.alignx == "right")
		{
			var_09 = -1;
		}
		else
		{
			var_09 = 1;
		}
	}
	else
	{
		var_08 = var_07.width;
		if(var_07 == "left_adjustable")
		{
			var_09 = -1;
		}
		else
		{
			var_09 = 1;
		}
	}

	self.x = var_05.x + var_08 * var_09;
	if(strip_suffix(var_07,"_adjustable") == var_05.aligny)
	{
		var_0A = 0;
		var_0B = 0;
	}
	else if(var_09 == "middle" || var_07.aligny == "middle")
	{
		var_0A = int(var_07.height / 2);
		if(var_08 == "top_adjustable" || var_06.aligny == "bottom")
		{
			var_0B = -1;
		}
		else
		{
			var_0B = 1;
		}
	}
	else
	{
		var_0A = var_07.height;
		if(var_08 == "top_adjustable")
		{
			var_0B = -1;
		}
		else
		{
			var_0B = 1;
		}
	}

	self.y = var_05.y + var_0A * var_0B;
	self.x = self.x + self.xoffset;
	self.y = self.y + self.yoffset;
	switch(self.elemtype)
	{
		case "bar":
			setpointbar(param_00,param_01,param_02,param_03);
			break;
	}

	updatechildren();
}

//Function Number: 95
getparent()
{
	return self.parent;
}

//Function Number: 96
setpointbar(param_00,param_01,param_02,param_03)
{
	self.bar.horzalign = self.horzalign;
	self.bar.vertalign = self.vertalign;
	self.bar.alignx = "left";
	self.bar.aligny = self.aligny;
	self.bar.y = self.y;
	if(self.alignx == "left")
	{
		self.bar.x = self.x;
	}
	else if(self.alignx == "right")
	{
		self.bar.x = self.x - self.width;
	}
	else
	{
		self.bar.x = self.x - int(self.width / 2);
	}

	if(self.aligny == "top")
	{
		self.bar.y = self.y;
	}
	else if(self.aligny == "bottom")
	{
		self.bar.y = self.y;
	}

	updatebar(self.bar.frac);
}

//Function Number: 97
updatebar(param_00,param_01)
{
	if(self.elemtype == "bar")
	{
		updatebarscale(param_00,param_01);
	}
}

//Function Number: 98
updatebarscale(param_00,param_01)
{
	var_02 = int(self.width * param_00 + 0.5);
	if(!var_02)
	{
		var_02 = 1;
	}

	self.bar.frac = param_00;
	self.bar setshader(self.bar.shader,var_02,self.height);
	if(isdefined(param_01) && var_02 < self.width)
	{
		if(param_01 > 0)
		{
			self.bar scaleovertime(1 - param_00 / param_01,self.width,self.height);
		}
		else if(param_01 < 0)
		{
			self.bar scaleovertime(param_00 / -1 * param_01,1,self.height);
		}
	}

	self.bar.rateofchange = param_01;
	self.bar.lastupdatetime = gettime();
}

//Function Number: 99
updatechildren()
{
	for(var_00 = 0;var_00 < self.children.size;var_00++)
	{
		var_01 = self.children[var_00];
		var_01 setpoint(var_01.point,var_01.relativepoint,var_01.xoffset,var_01.yoffset);
	}
}

//Function Number: 100
createicon(param_00,param_01,param_02,param_03)
{
	if(!isdefined(param_03))
	{
		var_04 = newclienthudelem(self);
	}
	else
	{
		var_04 = newhudelem();
	}

	var_04.elemtype = "icon";
	var_04.x = 0;
	var_04.y = 0;
	var_04.width = param_01;
	var_04.height = param_02;
	var_04.basewidth = var_04.width;
	var_04.baseheight = var_04.height;
	var_04.xoffset = 0;
	var_04.yoffset = 0;
	var_04.children = [];
	var_04 setparent(level.uiparent);
	var_04.hidden = 0;
	if(isdefined(param_00))
	{
		var_04 setshader(param_00,param_01,param_02);
		var_04.shader = param_00;
	}

	return var_04;
}

//Function Number: 101
destroyelem()
{
	var_00 = [];
	for(var_01 = 0;var_01 < self.children.size;var_01++)
	{
		if(isdefined(self.children[var_01]))
		{
			var_00[var_00.size] = self.children[var_01];
		}
	}

	for(var_01 = 0;var_01 < var_00.size;var_01++)
	{
		var_00[var_01] setparent(getparent());
	}

	if(self.elemtype == "bar" || self.elemtype == "bar_shader")
	{
		self.bar destroy();
	}

	self destroy();
}

//Function Number: 102
showelem()
{
	if(!self.hidden)
	{
		return;
	}

	self.hidden = 0;
	if(self.elemtype == "bar" || self.elemtype == "bar_shader")
	{
		if(self.alpha != 0.5)
		{
			self.alpha = 0.5;
		}

		self.bar.hidden = 0;
		if(self.bar.alpha != 1)
		{
			self.bar.alpha = 1;
			return;
		}

		return;
	}

	if(self.alpha != 1)
	{
		self.alpha = 1;
	}
}

//Function Number: 103
hideelem()
{
	if(self.hidden)
	{
		return;
	}

	self.hidden = 1;
	if(self.alpha != 0)
	{
		self.alpha = 0;
	}

	if(self.elemtype == "bar" || self.elemtype == "bar_shader")
	{
		self.bar.hidden = 1;
		if(self.bar.alpha != 0)
		{
			self.bar.alpha = 0;
		}
	}
}

//Function Number: 104
createprimaryprogressbartext(param_00,param_01,param_02,param_03)
{
	if(isagent(self))
	{
		return undefined;
	}

	if(!isdefined(param_00))
	{
		param_00 = 0;
	}

	if(!isdefined(param_01))
	{
		param_01 = -25;
	}

	if(self issplitscreenplayer())
	{
		param_01 = param_01 + 20;
	}

	var_04 = level.primaryprogressbarfontsize;
	var_05 = "default";
	if(isdefined(param_02))
	{
		var_04 = param_02;
	}

	if(isdefined(param_03))
	{
		var_05 = param_03;
	}

	var_06 = createfontstring(var_05,var_04);
	var_06 setpoint("CENTER",undefined,level.primaryprogressbartextx + param_00,level.primaryprogressbartexty + param_01);
	var_06.sort = -1;
	return var_06;
}

//Function Number: 105
createprimaryprogressbar(param_00,param_01,param_02,param_03)
{
	if(isagent(self))
	{
		return undefined;
	}

	if(!isdefined(param_00))
	{
		param_00 = 0;
	}

	if(!isdefined(param_01))
	{
		param_01 = -25;
	}

	if(self issplitscreenplayer())
	{
		param_01 = param_01 + 20;
	}

	if(!isdefined(param_02))
	{
		param_02 = level.primaryprogressbarwidth;
	}

	if(!isdefined(param_03))
	{
		param_03 = level.primaryprogressbarheight;
	}

	var_04 = createbar((1,1,1),param_02,param_03);
	var_04 setpoint("CENTER",undefined,level.primaryprogressbarx + param_00,level.primaryprogressbary + param_01);
	return var_04;
}

//Function Number: 106
createbar(param_00,param_01,param_02,param_03)
{
	var_04 = newclienthudelem(self);
	var_04.x = 0;
	var_04.y = 0;
	var_04.frac = 0;
	var_04.color = param_00;
	var_04.sort = -2;
	var_04.shader = "progress_bar_fill";
	var_04 setshader("progress_bar_fill",param_01,param_02);
	var_04.hidden = 0;
	if(isdefined(param_03))
	{
		var_04.flashfrac = param_03;
	}

	var_05 = newclienthudelem(self);
	var_05.elemtype = "bar";
	var_05.width = param_01;
	var_05.height = param_02;
	var_05.xoffset = 0;
	var_05.yoffset = 0;
	var_05.bar = var_04;
	var_05.children = [];
	var_05.sort = -3;
	var_05.color = (0,0,0);
	var_05.alpha = 0.5;
	var_05 setparent(level.uiparent);
	var_05 setshader("progress_bar_bg",param_01 + 4,param_02 + 4);
	var_05.hidden = 0;
	return var_05;
}

//Function Number: 107
isgameparticipant(param_00)
{
	if(isaigameparticipant(param_00))
	{
		return 1;
	}

	if(isplayer(param_00))
	{
		return 1;
	}

	return 0;
}

//Function Number: 108
isaigameparticipant(param_00)
{
	if(isagent(param_00) && isdefined(param_00.agent_gameparticipant) && param_00.agent_gameparticipant == 1)
	{
		return 1;
	}

	if(isbot(param_00))
	{
		return 1;
	}

	return 0;
}

//Function Number: 109
setteamheadicon(param_00,param_01)
{
	if(!level.teambased)
	{
		return;
	}

	if(!isdefined(self.entityheadiconteam))
	{
		self.entityheadiconteam = "none";
		self.entityheadicon = undefined;
	}

	var_02 = game["entity_headicon_" + param_00];
	self.entityheadiconteam = param_00;
	if(isdefined(param_01))
	{
		self.entityheadiconoffset = param_01;
	}
	else
	{
		self.entityheadiconoffset = (0,0,0);
	}

	self notify("kill_entity_headicon_thread");
	if(param_00 == "none")
	{
		if(isdefined(self.entityheadicon))
		{
			self.entityheadicon destroy();
		}

		return;
	}

	var_03 = newteamhudelem(param_00);
	var_03.archived = 1;
	var_03.x = self.origin[0] + self.entityheadiconoffset[0];
	var_03.y = self.origin[1] + self.entityheadiconoffset[1];
	var_03.var_3A6 = self.origin[2] + self.entityheadiconoffset[2];
	var_03.alpha = 0.8;
	var_03 setshader(var_02,10,10);
	var_03 setwaypoint(0,0,0,1);
	self.entityheadicon = var_03;
	thread keepiconpositioned();
	thread destroyheadiconsondeath();
}

//Function Number: 110
setplayerheadicon(param_00,param_01)
{
	if(level.teambased)
	{
		return;
	}

	if(!isdefined(self.entityheadiconteam))
	{
		self.entityheadiconteam = "none";
		self.entityheadicon = undefined;
	}

	self notify("kill_entity_headicon_thread");
	if(!isdefined(param_00))
	{
		if(isdefined(self.entityheadicon))
		{
			self.entityheadicon destroy();
		}

		return;
	}

	var_02 = param_00.team;
	self.entityheadiconteam = var_02;
	if(isdefined(param_01))
	{
		self.entityheadiconoffset = param_01;
	}
	else
	{
		self.entityheadiconoffset = (0,0,0);
	}

	var_03 = game["entity_headicon_" + var_02];
	var_04 = newclienthudelem(param_00);
	var_04.archived = 1;
	var_04.x = self.origin[0] + self.entityheadiconoffset[0];
	var_04.y = self.origin[1] + self.entityheadiconoffset[1];
	var_04.var_3A6 = self.origin[2] + self.entityheadiconoffset[2];
	var_04.alpha = 0.8;
	var_04 setshader(var_03,10,10);
	var_04 setwaypoint(0,0,0,1);
	self.entityheadicon = var_04;
	thread keepiconpositioned();
	thread destroyheadiconsondeath();
}

//Function Number: 111
keepiconpositioned()
{
	self.entityheadicon linkwaypointtotargetwithoffset(self,self.entityheadiconoffset);
}

//Function Number: 112
destroyheadiconsondeath()
{
	self endon("kill_entity_headicon_thread");
	self waittill("death");
	if(!isdefined(self.entityheadicon))
	{
		return;
	}

	self.entityheadicon destroy();
}

//Function Number: 113
setheadicon(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A)
{
	if(isgameparticipant(param_00) && !isplayer(param_00))
	{
		return;
	}

	if(!isdefined(self.entityheadicons))
	{
		self.entityheadicons = [];
	}

	if(!isdefined(param_05))
	{
		param_05 = 1;
	}

	if(!isdefined(param_06))
	{
		param_06 = 0.05;
	}

	if(!isdefined(param_07))
	{
		param_07 = 1;
	}

	if(!isdefined(param_08))
	{
		param_08 = 1;
	}

	if(!isdefined(param_09))
	{
		param_09 = 0;
	}

	if(!isdefined(param_0A))
	{
		param_0A = 1;
	}

	if(!isplayer(param_00) && param_00 == "none")
	{
		foreach(var_0D, var_0C in self.entityheadicons)
		{
			if(isdefined(var_0C))
			{
				var_0C destroy();
			}

			self.entityheadicons[var_0D] = undefined;
		}

		return;
	}

	if(isplayer(param_03))
	{
		if(isdefined(self.entityheadicons[param_03.guid]))
		{
			self.entityheadicons[param_03.guid] destroy();
			self.entityheadicons[param_03.guid] = undefined;
		}

		if(param_04 == "")
		{
			return;
		}

		if(isdefined(param_03.team))
		{
			if(isdefined(self.entityheadicons[param_03.team]))
			{
				self.entityheadicons[param_03.team] destroy();
				self.entityheadicons[param_03.team] = undefined;
			}
		}

		var_0C = newclienthudelem(param_03);
		self.entityheadicons[param_02.guid] = var_0D;
	}
	else
	{
		if(isdefined(self.entityheadicons[param_03]))
		{
			self.entityheadicons[param_03] destroy();
			self.entityheadicons[param_03] = undefined;
		}

		if(param_04 == "")
		{
			return;
		}

		foreach(var_0E in self.entityheadicons)
		{
			if(var_10 == "axis" || var_10 == "allies")
			{
				continue;
			}

			var_0F = getplayerforguid(var_10);
			if(var_0F.team == param_01)
			{
				self.entityheadicons[var_10] destroy();
				self.entityheadicons[var_10] = undefined;
			}
		}

		var_0C = newteamhudelem(param_01);
		self.entityheadicons[param_01] = var_0C;
	}

	if(!isdefined(param_04) || !isdefined(param_05))
	{
		param_04 = 10;
		param_05 = 10;
	}

	var_0C.archived = param_06;
	var_0C.x = self.origin[0] + param_03[0];
	var_0C.y = self.origin[1] + param_03[1];
	var_0C.var_3A6 = self.origin[2] + param_03[2];
	var_0C.alpha = 0.85;
	var_0C setshader(param_02,param_04,param_05);
	var_0C setwaypoint(param_08,param_09,param_0A,var_0B);
	var_0C thread keeppositioned(self,param_03,param_07);
	thread destroyiconsondeath();
	if(isplayer(param_01))
	{
		var_0C thread destroyonownerdisconnect(param_01);
	}

	if(isplayer(self))
	{
		var_0C thread destroyonownerdisconnect(self);
	}

	return var_0C;
}

//Function Number: 114
showheadicon(param_00)
{
	foreach(var_02 in param_00)
	{
		if(isdefined(var_02))
		{
			var_02.alpha = 0.85;
		}
	}
}

//Function Number: 115
hideheadicon(param_00)
{
	foreach(var_02 in param_00)
	{
		if(isdefined(var_02))
		{
			var_02.alpha = 0;
		}
	}
}

//Function Number: 116
getplayerforguid(param_00)
{
	foreach(var_02 in level.players)
	{
		if(var_02.guid == param_00)
		{
			return var_02;
		}
	}

	return undefined;
}

//Function Number: 117
keeppositioned(param_00,param_01,param_02)
{
	self endon("death");
	param_00 endon("death");
	param_00 endon("disconnect");
	var_03 = isdefined(param_00.classname) && !isownercarepakage(param_00);
	if(var_03)
	{
		self linkwaypointtotargetwithoffset(param_00,param_01);
	}

	for(;;)
	{
		if(!isdefined(param_00))
		{
			return;
		}

		if(!var_03)
		{
			var_04 = param_00.origin;
			self.x = var_04[0] + param_01[0];
			self.y = var_04[1] + param_01[1];
			self.var_3A6 = var_04[2] + param_01[2];
		}

		if(param_02 > 0.05)
		{
			self.alpha = 0.85;
			self fadeovertime(param_02);
			self.alpha = 0;
		}

		wait(param_02);
	}
}

//Function Number: 118
isownercarepakage(param_00)
{
	return isdefined(param_00.var_336) && param_00.var_336 == "care_package";
}

//Function Number: 119
destroyiconsondeath()
{
	self notify("destroyIconsOnDeath");
	self endon("destroyIconsOnDeath");
	self waittill("death");
	if(!isdefined(self.entityheadicons))
	{
		return;
	}

	foreach(var_01 in self.entityheadicons)
	{
		if(!isdefined(var_01))
		{
			continue;
		}

		var_01 destroy();
	}
}

//Function Number: 120
destroyonownerdisconnect(param_00)
{
	self endon("death");
	param_00 waittill("disconnect");
	self destroy();
}

//Function Number: 121
_suicide()
{
	if(!isusingremote() && !isdefined(self.fauxdeath))
	{
		self suicide();
	}
}

//Function Number: 122
player_lua_progressbar(param_00,param_01,param_02,param_03,param_04,param_05)
{
	var_06 = lua_progress_bar_think(param_00,param_01,param_02,param_03,param_04,param_05);
	return var_06;
}

//Function Number: 123
lua_progress_bar_think(param_00,param_01,param_02,param_03,param_04,param_05)
{
	self.curprogress = 0;
	self.inuse = 1;
	self.userate = 1;
	self.usetime = param_01;
	param_00 thread create_lua_progress_bar(self,param_03);
	param_00.hasprogressbar = 1;
	var_06 = lua_progress_bar_think_loop(param_00,self,param_02,param_04,param_05);
	if(isalive(param_00))
	{
		param_00.hasprogressbar = 0;
	}

	if(!isdefined(self))
	{
		return 0;
	}

	self.inuse = 0;
	self.curprogress = 0;
	return var_06;
}

//Function Number: 124
create_lua_progress_bar(param_00,param_01)
{
	self endon("disconnect");
	self setclientomnvar("ui_securing",param_01);
	var_02 = -1;
	while(isreallyalive(self) && isdefined(param_00) && param_00.inuse && !level.gameended)
	{
		if(var_02 != param_00.userate)
		{
			if(param_00.curprogress > param_00.usetime)
			{
				param_00.curprogress = param_00.usetime;
			}
		}

		var_02 = param_00.userate;
		self setclientomnvar("ui_securing_progress",param_00.curprogress / param_00.usetime);
		wait(0.05);
	}

	wait(0.5);
	self setclientomnvar("ui_securing_progress",0);
	self setclientomnvar("ui_securing",0);
}

//Function Number: 125
lua_progress_bar_think_loop(param_00,param_01,param_02,param_03,param_04)
{
	while(!level.gameended && isdefined(self) && isreallyalive(param_00) && param_00 usebuttonpressed() || isdefined(param_03) || param_00 attackbuttonpressed() && isdefined(param_04) && should_continue_progress_bar_think(param_00))
	{
		wait(0.05);
		if(isdefined(param_01) && isdefined(param_02))
		{
			if(distancesquared(param_00.origin,param_01.origin) > param_02)
			{
				return 0;
			}
		}

		self.curprogress = self.curprogress + 50 * self.userate;
		self.userate = 1;
		if(self.curprogress >= self.usetime)
		{
			param_00 setclientomnvar("ui_securing_progress",1);
			return isreallyalive(param_00);
		}
	}

	return 0;
}

//Function Number: 126
should_continue_progress_bar_think(param_00)
{
	if(isdefined(level.should_continue_progress_bar_think))
	{
		return [[ level.should_continue_progress_bar_think ]](param_00);
	}

	if(scripts\engine\utility::istrue(param_00.in_afterlife_arcade))
	{
		return 1;
	}

	return !scripts\cp\cp_laststand::player_in_laststand(param_00);
}

//Function Number: 127
isplayingsolo()
{
	if(getmaxclients() == 1)
	{
		return 1;
	}

	return 0;
}

//Function Number: 128
removefromparticipantsarray()
{
	var_00 = 0;
	for(var_01 = 0;var_01 < level.participants.size;var_01++)
	{
		if(level.participants[var_01] == self)
		{
			var_00 = 1;
			while(var_01 < level.participants.size - 1)
			{
				level.participants[var_01] = level.participants[var_01 + 1];
				var_01++;
			}

			level.participants[var_01] = undefined;
			break;
		}
	}
}

//Function Number: 129
removefromcharactersarray()
{
	var_00 = 0;
	for(var_01 = 0;var_01 < level.characters.size;var_01++)
	{
		if(level.characters[var_01] == self)
		{
			var_00 = 1;
			while(var_01 < level.characters.size - 1)
			{
				level.characters[var_01] = level.characters[var_01 + 1];
				var_01++;
			}

			level.characters[var_01] = undefined;
			break;
		}
	}
}

//Function Number: 130
removefromspawnedgrouparray()
{
	if(isdefined(self.group_name))
	{
		if(isdefined(level.spawned_group) && isdefined(level.spawned_group[self.group_name]))
		{
			level.spawned_group[self.group_name] = scripts\engine\utility::array_remove(level.spawned_group[self.group_name],self);
		}
	}
}

//Function Number: 131
createtimer(param_00,param_01)
{
	var_02 = newclienthudelem(self);
	var_02.elemtype = "timer";
	var_02.font = param_00;
	var_02.fontscale = param_01;
	var_02.basefontscale = param_01;
	var_02.x = 0;
	var_02.y = 0;
	var_02.width = 0;
	var_02.height = int(level.fontheight * param_01);
	var_02.xoffset = 0;
	var_02.yoffset = 0;
	var_02.children = [];
	var_02 setparent(level.uiparent);
	var_02.hidden = 0;
	return var_02;
}

//Function Number: 132
_detachall()
{
	self detachall();
}

//Function Number: 133
is_valid_perk(param_00)
{
	var_01 = getarraykeys(level.alien_perks["perk_0"]);
	if(scripts\engine\utility::array_contains(var_01,param_00))
	{
		return 1;
	}

	var_02 = getarraykeys(level.alien_perks["perk_1"]);
	if(scripts\engine\utility::array_contains(var_02,param_00))
	{
		return 1;
	}

	var_03 = getarraykeys(level.alien_perks["perk_2"]);
	return scripts\engine\utility::array_contains(var_03,param_00);
}

//Function Number: 134
is_consumable_active(param_00)
{
	if(isdefined(level.consumable_active_override))
	{
		return [[ level.consumable_active_override ]](param_00);
	}

	if(isdefined(self.consumables) && isdefined(self.consumables[param_00]) && isdefined(self.consumables[param_00].on) && self.consumables[param_00].on == 1)
	{
		return 1;
	}

	return 0;
}

//Function Number: 135
notify_used_consumable(param_00)
{
	self notify(self.consumables[param_00].usednotify);
}

//Function Number: 136
notify_timeup_consumable(param_00)
{
	self notify(level.consumables[param_00].timeupnotify);
}

//Function Number: 137
drawline(param_00,param_01,param_02,param_03)
{
	var_04 = int(param_02 * 20);
	for(var_05 = 0;var_05 < var_04;var_05++)
	{
		wait(0.05);
	}
}

//Function Number: 138
is_upgrade_enabled(param_00)
{
	if(!is_using_extinction_tokens())
	{
		return 0;
	}

	if(self getplayerdata("cp","upgrades_enabled_flags",param_00))
	{
		return 1;
	}

	return 0;
}

//Function Number: 139
allow_player_teleport(param_00,param_01)
{
	if(param_00)
	{
		if(!isdefined(self.teleportdisableflags) && isdefined(param_01))
		{
			foreach(var_03 in self.teleportdisableflags)
			{
				if(var_03 == param_01)
				{
					self.teleportdisableflags = scripts\engine\utility::array_remove(self.teleportdisableflags,param_01);
				}
			}
		}

		self.var_55E3--;
		if(!self.disabledteleportation)
		{
			self.teleportdisableflags = [];
			self.can_teleport = 1;
			self notify("can_teleport");
			return;
		}

		return;
	}

	if(!isdefined(self.teleportdisableflags))
	{
		self.teleportdisableflags = [];
	}

	if(isdefined(param_01))
	{
		self.teleportdisableflags[self.teleportdisableflags.size] = param_01;
	}

	if(!isdefined(self.disabledteleportation))
	{
		self.disabledteleportation = 0;
	}

	self.var_55E3++;
	self.can_teleport = 0;
}

//Function Number: 140
issprintenabled()
{
	return !isdefined(self.disabledsprint) || !self.disabledsprint;
}

//Function Number: 141
isweaponfireenabled()
{
	return !isdefined(self.disabledfire) || !self.disabledfire;
}

//Function Number: 142
ismeleeenabled()
{
	return !isdefined(self.disabledmelee) || !self.disabledmelee;
}

//Function Number: 143
isteleportenabled()
{
	return !isdefined(self.disabledteleportation) || !self.disabledteleportation;
}

//Function Number: 144
allow_player_interactions(param_00)
{
	if(param_00)
	{
		self.var_55CD--;
		if(!self.disabledinteractions)
		{
			self.interactions_disabled = undefined;
			return;
		}

		return;
	}

	self.var_55CD++;
	self.interactions_disabled = 1;
}

//Function Number: 145
areinteractionsenabled()
{
	return self.disabledinteractions < 1;
}

//Function Number: 146
_linkto(param_00,param_01,param_02,param_03,param_04)
{
	if(!isdefined(param_02))
	{
		param_02 = "tag_origin";
	}

	if(!isdefined(param_03))
	{
		param_03 = (0,0,0);
	}

	if(!isdefined(param_04))
	{
		param_04 = (0,0,0);
	}

	if(!isdefined(self.playerlinkedcounter))
	{
		self.playerlinkedcounter = 0;
	}

	self.playerlinkedcounter++;
	if(self.playerlinkedcounter == 1)
	{
		self linkto(param_01,param_02,param_03,param_04);
	}
}

//Function Number: 147
_unlink()
{
	if(isplayerlinked())
	{
		self.playerlinkedcounter--;
		if(self.playerlinkedcounter <= 0)
		{
			self.playerlinkedcounter = 0;
			self unlink();
		}
	}
}

//Function Number: 148
isplayerlinked()
{
	return isdefined(self.playerlinkedcounter) && self.playerlinkedcounter > 0;
}

//Function Number: 149
enable_infinite_ammo(param_00)
{
	if(param_00)
	{
		self.infiniteammocounter++;
		self setclientomnvar("zm_ui_unlimited_ammo",1);
		return;
	}

	if(self.infiniteammocounter > 0)
	{
		self.infiniteammocounter--;
	}

	if(!self.infiniteammocounter)
	{
		self setclientomnvar("zm_ui_unlimited_ammo",0);
	}
}

//Function Number: 150
isinfiniteammoenabled()
{
	return self.infiniteammocounter >= 1;
}

//Function Number: 151
allow_player_ignore_me(param_00)
{
	if(param_00)
	{
		self.ignorme_count++;
		self.ignoreme = 1;
		return;
	}

	self.ignorme_count--;
	if(!self.ignorme_count)
	{
		self.ignoreme = 0;
	}
}

//Function Number: 152
isignoremeenabled()
{
	return self.ignorme_count >= 1;
}

//Function Number: 153
force_usability_enabled()
{
	self.disabledusability = 0;
	self enableusability();
}

//Function Number: 154
is_using_extinction_tokens()
{
	return 0;
	if(getdvarint("extinction_tokens_enabled") > 0)
	{
		return 1;
	}

	return 0;
}

//Function Number: 155
coop_getweaponclass(param_00)
{
	if(!isdefined(param_00) || isdefined(param_00) && param_00 == "none")
	{
		return "none";
	}

	var_01 = getbaseweaponname(param_00);
	var_02 = tablelookup(level.statstable,4,var_01,1);
	if(var_02 == "" && isdefined(level.game_mode_statstable))
	{
		if(isdefined(param_00))
		{
			var_01 = getbaseweaponname(param_00);
			var_02 = tablelookup(level.game_mode_statstable,4,var_01,2);
		}
	}

	if(isenvironmentweapon(param_00))
	{
		var_02 = "weapon_mg";
	}
	else if(param_00 == "none")
	{
		var_02 = "other";
	}
	else if(var_02 == "")
	{
		var_02 = "other";
	}

	return var_02;
}

//Function Number: 156
is_holding_deployable()
{
	return self.is_holding_deployable;
}

//Function Number: 157
has_special_weapon()
{
	return self.has_special_weapon;
}

//Function Number: 158
filloffhandweapons(param_00,param_01)
{
	var_02 = self getweaponslistoffhands();
	var_03 = 0;
	var_04 = undefined;
	var_05 = 0;
	foreach(var_07 in var_02)
	{
		if(var_07 != param_00)
		{
			if(var_07 != "none" && var_07 != "alienthrowingknife_mp" && var_07 != "alientrophy_mp" && var_07 != "iw6_aliendlc21_mp")
			{
				self takeweapon(var_07);
			}

			continue;
		}

		if(isdefined(var_07) && var_07 != "none")
		{
			var_05 = self getrunningforwardpainanim(var_07);
			self setweaponammostock(var_07,var_05 + param_01);
			var_03 = 1;
			break;
		}
	}

	if(var_03 == 0)
	{
		_giveweapon(param_00);
		self setweaponammostock(param_00,param_01);
	}
}

//Function Number: 159
getequipmenttype(param_00)
{
	switch(param_00)
	{
		case "arc_grenade_mp":
		case "zom_repulsor_mp":
		case "splash_grenade_zm":
		case "splash_grenade_mp":
		case "impalement_spike_mp":
		case "mortar_shelljugg_mp":
		case "proximity_explosive_mp":
		case "bouncingbetty_mp":
		case "throwingknifesmokewall_mp":
		case "throwingknifec4_mp":
		case "throwingknife_mp":
		case "claymore_mp":
		case "cluster_grenade_zm":
		case "semtex_zm":
		case "semtex_mp":
		case "c4_zm":
		case "frag_grenade_mp":
		case "frag_grenade_zm":
			var_01 = "lethal";
			break;

		case "ztransponder_mp":
		case "transponder_mp":
		case "blackout_grenade_mp":
		case "player_trophy_system_mp":
		case "proto_ricochet_device_mp":
		case "emp_grenade_mp":
		case "trophy_mp":
		case "mobile_radar_mp":
		case "gravity_grenade_mp":
		case "alienflare_mp":
		case "concussion_grenade_mp":
		case "smoke_grenadejugg_mp":
		case "smoke_grenade_mp":
		case "thermobaric_grenade_mp":
		case "portal_generator_zm":
		case "portal_generator_mp":
		case "flash_grenade_mp":
			var_01 = "tactical";
			break;

		default:
			var_01 = undefined;
			break;
	}

	return var_01;
}

//Function Number: 160
giveperkoffhand(param_00)
{
	if(param_00 == "none" || param_00 == "specialty_null")
	{
		self give_player_xp("none");
		return;
	}

	self.secondarygrenade = param_00;
	if(issubstr(param_00,"_mp"))
	{
		switch(param_00)
		{
			case "splash_grenade_zm":
			case "splash_grenade_mp":
			case "mortar_shelljugg_mp":
			case "cluster_grenade_zm":
			case "semtex_zm":
			case "semtex_mp":
			case "frag_grenade_mp":
			case "frag_grenade_zm":
				self give_player_xp("frag");
				break;

			case "throwingknifejugg_mp":
			case "throwingknifesmokewall_mp":
			case "throwingknifec4_mp":
			case "throwingknife_mp":
			case "c4_zm":
				self give_player_xp("throwingknife");
				break;

			case "player_trophy_system_mp":
			case "proto_ricochet_device_mp":
			case "emp_grenade_mp":
			case "trophy_mp":
			case "mobile_radar_mp":
			case "alienflare_mp":
			case "thermobaric_grenade_mp":
			case "flash_grenade_mp":
				self give_player_xp("flash");
				break;

			case "concussion_grenade_mp":
			case "smoke_grenadejugg_mp":
			case "smoke_grenade_mp":
				self give_player_xp("smoke");
				break;

			case "ztransponder_mp":
			case "transponder_mp":
			case "zom_repulsor_mp":
			default:
				self give_player_xp("other");
				break;
		}

		_giveweapon(param_00,0);
		switch(param_00)
		{
			case "ztransponder_mp":
			case "transponder_mp":
			case "player_trophy_system_mp":
			case "proto_ricochet_device_mp":
			case "emp_grenade_mp":
			case "trophy_mp":
			case "mobile_radar_mp":
			case "gravity_grenade_mp":
			case "alienflare_mp":
			case "concussion_grenade_mp":
			case "smoke_grenade_mp":
			case "thermobaric_grenade_mp":
			case "flash_grenade_mp":
				self setweaponammoclip(param_00,1);
				break;

			default:
				self givestartammo(param_00);
				break;
		}

		_setperk(param_00);
		return;
	}

	_setperk(param_00);
}

//Function Number: 161
_launchgrenade(param_00,param_01,param_02,param_03,param_04,param_05)
{
	var_06 = self launchgrenade(param_00,param_01,param_02,param_03,param_05);
	if(!isdefined(param_04))
	{
		var_06.notthrown = 1;
	}
	else
	{
		var_06.notthrown = param_04;
	}

	var_06 setotherent(self);
	return var_06;
}

//Function Number: 162
blockperkfunction(param_00)
{
	if(!isdefined(self.perksblocked[param_00]))
	{
		self.perksblocked[param_00] = 1;
	}
	else
	{
		self.perksblocked[param_00]++;
	}

	if(self.perksblocked[param_00] == 1 && _hasperk(param_00))
	{
		foreach(var_06, var_02 in level.extraperkmap)
		{
			if(param_00 == var_06)
			{
				foreach(var_04 in var_02)
				{
					if(!isdefined(self.perksblocked[var_04]))
					{
						self.perksblocked[var_04] = 1;
						continue;
					}

					self.perksblocked[var_04]++;
					if(self.perksblocked[var_04] == 1)
					{
					}
				}

				break;
			}
		}
	}
}

//Function Number: 163
unblockperkfunction(param_00)
{
	self.perksblocked[param_00]--;
	if(self.perksblocked[param_00] == 0)
	{
		self.perksblocked[param_00] = undefined;
		if(_hasperk(param_00))
		{
			foreach(var_06, var_02 in level.extraperkmap)
			{
				if(param_00 == var_06)
				{
					foreach(var_04 in var_02)
					{
						self.perksblocked[var_04]--;
						if(self.perksblocked[var_04] == 0)
						{
							self.perksblocked[var_04] = undefined;
						}
					}

					break;
				}
			}
		}
	}
}

//Function Number: 164
getweaponclass(param_00)
{
	var_01 = getbaseweaponname(param_00);
	var_02 = level.statstable;
	var_03 = tablelookup(var_02,4,var_01,1);
	if(var_03 == "")
	{
		var_04 = strip_suffix(param_00,"_zm");
		var_03 = tablelookup(var_02,4,var_04,1);
	}

	if(var_03 == "" && isdefined(level.game_mode_statstable))
	{
		var_04 = strip_suffix(param_00,"_zm");
		var_03 = tablelookup(level.game_mode_statstable,4,var_04,1);
	}

	if(isenvironmentweapon(param_00))
	{
		var_03 = "weapon_mg";
	}
	else if(iskillstreakweapon(param_00))
	{
		var_03 = "killstreak";
	}
	else if(issuperweapon(param_00))
	{
		var_03 = "super";
	}
	else if(param_00 == "none")
	{
		var_03 = "other";
	}
	else if(var_03 == "")
	{
		var_03 = "other";
	}

	return var_03;
}

//Function Number: 165
removedamagemodifier(param_00,param_01)
{
	if(!isdefined(param_01))
	{
		param_01 = 1;
	}

	if(param_01)
	{
		if(!isdefined(self.additivedamagemodifiers))
		{
			return;
		}

		self.additivedamagemodifiers[param_00] = undefined;
		return;
	}

	if(!isdefined(self.multiplicativedamagemodifiers))
	{
		return;
	}

	self.multiplicativedamagemodifiers[param_00] = undefined;
}

//Function Number: 166
adddamagemodifier(param_00,param_01,param_02)
{
	if(!isdefined(param_02))
	{
		param_02 = 1;
	}

	if(param_02)
	{
		if(!isdefined(self.additivedamagemodifiers))
		{
			self.additivedamagemodifiers = [];
		}

		self.additivedamagemodifiers[param_00] = param_01;
		return;
	}

	if(!isdefined(self.multiplicativedamagemodifiers))
	{
		self.multiplicativedamagemodifiers = [];
	}

	self.multiplicativedamagemodifiers[param_00] = param_01;
}

//Function Number: 167
getdamagemodifiertotal()
{
	var_00 = 1;
	if(isdefined(self.additivedamagemodifiers))
	{
		foreach(var_02 in self.additivedamagemodifiers)
		{
			var_00 = var_00 + var_02 - 1;
		}
	}

	var_04 = 1;
	if(isdefined(self.multiplicativedamagemodifiers))
	{
		foreach(var_02 in self.multiplicativedamagemodifiers)
		{
			var_04 = var_04 * var_02;
		}
	}

	return var_00 * var_04;
}

//Function Number: 168
isinventoryprimaryweapon(param_00)
{
	switch(function_0244(param_00))
	{
		case "altmode":
		case "primary":
			return 1;

		default:
			return 0;
	}
}

//Function Number: 169
_enablecollisionnotifies(param_00)
{
	if(!isdefined(self.enabledcollisionnotifies))
	{
		self.enabledcollisionnotifies = 0;
	}

	if(param_00)
	{
		if(self.enabledcollisionnotifies == 0)
		{
			self enablecollisionnotifies(1);
		}

		self.var_6262++;
	}
	else
	{
		if(self.enabledcollisionnotifies == 1)
		{
			self enablecollisionnotifies(0);
		}

		self.var_6262--;
	}
}

//Function Number: 170
has_tag(param_00,param_01)
{
	if(!isdefined(param_00))
	{
		return 0;
	}

	var_02 = function_00BC(param_00);
	for(var_03 = 0;var_03 < var_02;var_03++)
	{
		if(tolower(function_00BF(param_00,var_03)) == tolower(param_01))
		{
			return 1;
		}
	}

	return 0;
}

//Function Number: 171
is_trap(param_00,param_01,param_02)
{
	if(isdefined(param_01) && param_01 == "iw7_beamtrap_zm" || param_01 == "iw7_escapevelocity_zm" || param_01 == "iw7_rockettrap_zm" || param_01 == "iw7_discotrap_zm" || param_01 == "iw7_chromosphere_zm" || param_01 == "iw7_buffertrap_zm" || param_01 == "iw7_electrictrap_zm" || param_01 == "iw7_fantrap_zm" || param_01 == "iw7_hydranttrap_zm" || param_01 == "iw7_lasertrap_zm" || param_01 == "iw7_raintrap_zm" || param_01 == "iw7_theatertrap_zm" || param_01 == "iw7_fridgetrap_zm" || param_01 == "iw7_electrotrap_zm")
	{
		return 1;
	}

	if(!isdefined(param_00))
	{
		return 0;
	}

	if(isdefined(param_02) && scripts\engine\utility::istrue(param_02.fridge_trap_marked))
	{
		return 1;
	}

	if(isdefined(param_00.tesla_type))
	{
		return 1;
	}

	if(!isdefined(param_00.script_noteworthy) && !isdefined(param_00.var_336))
	{
		return 0;
	}

	if(isdefined(param_00.var_336) && param_00.var_336 == "fence_generator" || param_00.var_336 == "puddle_generator")
	{
		return 1;
	}

	if(isdefined(param_00.script_noteworthy) && param_00.script_noteworthy == "fire_trap")
	{
		return 1;
	}

	return 0;
}

//Function Number: 172
riotshieldname()
{
	var_00 = self getweaponslist("primary");
	if(!self.hasriotshield)
	{
		return;
	}

	foreach(var_02 in var_00)
	{
		if(function_024C(var_02) == "riotshield")
		{
			return var_02;
		}
	}
}

//Function Number: 173
player_has_special_ammo(param_00,param_01)
{
	return isdefined(param_00.special_ammo_type) && param_00.special_ammo_type == param_01;
}

//Function Number: 174
has_stun_ammo(param_00)
{
	if(isdefined(self.special_ammo_type))
	{
		return player_has_special_ammo(self,"stun_ammo");
	}

	if(!isdefined(param_00))
	{
		var_01 = self getcurrentweapon();
	}
	else
	{
		var_01 = var_01;
	}

	if(var_01 == "none")
	{
		var_01 = self getweaponslistprimaries()[0];
	}

	var_02 = getrawbaseweaponname(var_01);
	if(isdefined(self.special_ammocount) && isdefined(self.special_ammocount[var_02]) && self.special_ammocount[var_02] > 0)
	{
		return 1;
	}

	if(isdefined(self.special_ammocount_comb) && isdefined(self.special_ammocount_comb[var_02]) && self.special_ammocount_comb[var_02] > 0)
	{
		return 1;
	}

	return 0;
}

//Function Number: 175
is_ricochet_damage()
{
	return level.ricochetdamage;
}

//Function Number: 176
is_hardcore_mode()
{
	return level.hardcoremode;
}

//Function Number: 177
is_casual_mode()
{
	return level.casualmode == 1;
}

//Function Number: 178
isriotshield(param_00)
{
	if(param_00 == "none")
	{
		return 0;
	}

	return function_024C(param_00) == "riotshield";
}

//Function Number: 179
isaltmodeweapon(param_00)
{
	if(!isdefined(param_00) || param_00 == "none")
	{
		return 0;
	}

	return function_0244(param_00) == "altmode";
}

//Function Number: 180
hasriotshield()
{
	var_00 = 0;
	var_01 = self getweaponslistprimaries();
	foreach(var_03 in var_01)
	{
		if(isriotshield(var_03))
		{
			var_00 = 1;
			break;
		}
	}

	return var_00;
}

//Function Number: 181
is_empty_string(param_00)
{
	return param_00 == "";
}

//Function Number: 182
func_F225(param_00,param_01)
{
	if(isdefined(param_01))
	{
		self notify(param_00,param_01);
		return;
	}

	self notify(param_00);
}

//Function Number: 183
notifyafterframeend(param_00,param_01)
{
	self waittill(param_00);
	waittillframeend;
	self notify(param_01);
}

//Function Number: 184
player_last_death_pos()
{
	level endon("game_ended");
	self endon("death");
	self endon("disconnect");
	self.last_death_pos = self.origin;
	for(;;)
	{
		self waittill("damage");
		self.last_death_pos = self.origin;
	}
}

//Function Number: 185
isheadshot(param_00,param_01,param_02,param_03)
{
	if(isdefined(param_03))
	{
		if(isdefined(param_03.triggerportableradarping))
		{
			if(param_03.var_9F == "script_vehicle")
			{
				return 0;
			}

			if(param_03.var_9F == "misc_turret")
			{
				return 0;
			}

			if(param_03.var_9F == "script_model")
			{
				return 0;
			}
		}

		if(isdefined(param_03.agent_type))
		{
			if(param_03.agent_type == "dog" || param_03.agent_type == "alien")
			{
				return 0;
			}
		}
	}

	return (param_01 == "head" || param_01 == "helmet" || param_01 == "neck") && param_02 != "MOD_MELEE" && param_02 != "MOD_IMPACT" && param_02 != "MOD_SCARAB" && param_02 != "MOD_CRUSH" && !isenvironmentweapon(param_00);
}

//Function Number: 186
getteamarray(param_00,param_01)
{
	var_02 = [];
	if(!isdefined(param_01) || param_01)
	{
		foreach(var_04 in level.characters)
		{
			if(var_04.team == param_00)
			{
				var_02[var_02.size] = var_04;
			}
		}
	}
	else
	{
		foreach(var_04 in level.players)
		{
			if(var_04.team == param_00)
			{
				var_02[var_02.size] = var_04;
			}
		}
	}

	return var_02;
}

//Function Number: 187
getotherteam(param_00)
{
	if(level.multiteambased)
	{
	}

	if(param_00 == "allies")
	{
		return "axis";
	}
	else if(param_00 == "axis")
	{
		return "allies";
	}
	else
	{
		return "none";
	}
}

//Function Number: 188
waittill_any_ents_return(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B,param_0C,param_0D)
{
	self endon("death");
	var_0E = spawnstruct();
	param_00 childthread scripts\engine\utility::waittill_string(param_01,var_0E);
	if(isdefined(param_02) && isdefined(param_03))
	{
		param_02 childthread scripts\engine\utility::waittill_string(param_03,var_0E);
	}

	if(isdefined(param_04) && isdefined(param_05))
	{
		param_04 childthread scripts\engine\utility::waittill_string(param_05,var_0E);
	}

	if(isdefined(param_06) && isdefined(param_07))
	{
		param_06 childthread scripts\engine\utility::waittill_string(param_07,var_0E);
	}

	if(isdefined(param_08) && isdefined(param_09))
	{
		param_08 childthread scripts\engine\utility::waittill_string(param_09,var_0E);
	}

	if(isdefined(param_0A) && isdefined(param_0B))
	{
		param_0A childthread scripts\engine\utility::waittill_string(param_0B,var_0E);
	}

	if(isdefined(param_0C) && isdefined(param_0D))
	{
		param_0C childthread scripts\engine\utility::waittill_string(param_0D,var_0E);
	}

	var_0E waittill("returned",var_0F);
	var_0E notify("die");
	return var_0F;
}

//Function Number: 189
waittill_any_ents_or_timeout_return(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B,param_0C,param_0D,param_0E)
{
	self endon("death");
	var_0F = spawnstruct();
	param_01 childthread scripts\engine\utility::waittill_string(param_02,var_0F);
	if(isdefined(param_03) && isdefined(param_04))
	{
		param_03 childthread scripts\engine\utility::waittill_string(param_04,var_0F);
	}

	if(isdefined(param_05) && isdefined(param_06))
	{
		param_05 childthread scripts\engine\utility::waittill_string(param_06,var_0F);
	}

	if(isdefined(param_07) && isdefined(param_08))
	{
		param_07 childthread scripts\engine\utility::waittill_string(param_08,var_0F);
	}

	if(isdefined(param_09) && isdefined(param_0A))
	{
		param_09 childthread scripts\engine\utility::waittill_string(param_0A,var_0F);
	}

	if(isdefined(param_0B) && isdefined(param_0C))
	{
		param_0B childthread scripts\engine\utility::waittill_string(param_0C,var_0F);
	}

	if(isdefined(param_0D) && isdefined(param_0E))
	{
		param_0D childthread scripts\engine\utility::waittill_string(param_0E,var_0F);
	}

	var_0F childthread scripts\engine\utility::_timeout(param_00);
	var_0F waittill("returned",var_10);
	var_0F notify("die");
	return var_10;
}

//Function Number: 190
player_black_screen(param_00,param_01,param_02,param_03,param_04)
{
	self endon("disconnect");
	self endon("intermission");
	self endon("death");
	var_05 = "black";
	if(scripts\engine\utility::istrue(param_04))
	{
		var_05 = "white";
	}

	self.player_black_screen = newclienthudelem(self);
	self.player_black_screen.x = 0;
	self.player_black_screen.y = 0;
	self.player_black_screen setshader(var_05,640,480);
	self.player_black_screen.alignx = "left";
	self.player_black_screen.aligny = "top";
	self.player_black_screen.sort = 1;
	self.player_black_screen.horzalign = "fullscreen";
	self.player_black_screen.vertalign = "fullscreen";
	self.player_black_screen.alpha = 0;
	self.player_black_screen.foreground = 1;
	if(!scripts\engine\utility::istrue(param_03))
	{
		self.player_black_screen fadeovertime(param_00);
	}

	self.player_black_screen.alpha = 1;
	if(!scripts\engine\utility::istrue(param_03))
	{
		wait(param_00 + 0.05);
	}

	wait(param_01);
	self.player_black_screen fadeovertime(param_02);
	self.player_black_screen.alpha = 0;
	wait(param_02 + 0.05);
	self.player_black_screen destroy();
}

//Function Number: 191
riotshield_hasweapon()
{
	var_00 = 0;
	var_01 = self getweaponslistprimaries();
	foreach(var_03 in var_01)
	{
		if(isriotshield(var_03))
		{
			var_00 = 1;
			break;
		}
	}

	return var_00;
}

//Function Number: 192
riotshield_attach(param_00,param_01)
{
	var_02 = undefined;
	if(param_00)
	{
		self.riotshieldmodel = param_01;
		var_02 = "tag_weapon_right";
	}
	else
	{
		self.riotshieldmodelstowed = param_01;
		var_02 = "tag_shield_back";
	}

	self attachshieldmodel(param_01,var_02);
	self.hasriotshield = riotshield_hasweapon();
}

//Function Number: 193
launchshield(param_00,param_01)
{
	if(isdefined(self.hasriotshieldequipped) && self.hasriotshieldequipped)
	{
		if(isdefined(self.riotshieldmodel))
		{
			riotshield_detach(1);
			return;
		}

		if(isdefined(self.riotshieldmodelstowed))
		{
			riotshield_detach(0);
			return;
		}
	}
}

//Function Number: 194
riotshield_detach(param_00)
{
	var_01 = undefined;
	var_02 = undefined;
	if(param_00)
	{
		var_01 = self.riotshieldmodel;
		var_02 = "tag_weapon_right";
	}
	else
	{
		var_01 = self.riotshieldmodelstowed;
		var_02 = "tag_shield_back";
	}

	self detachshieldmodel(var_01,var_02);
	if(param_00)
	{
		self.riotshieldmodel = undefined;
	}
	else
	{
		self.riotshieldmodelstowed = undefined;
	}

	self.hasriotshield = riotshield_hasweapon();
}

//Function Number: 195
riotshield_move(param_00)
{
	var_01 = undefined;
	var_02 = undefined;
	var_03 = undefined;
	if(param_00)
	{
		var_03 = self.riotshieldmodel;
		var_01 = "tag_weapon_right";
		var_02 = "tag_shield_back";
	}
	else
	{
		var_03 = self.riotshieldmodelstowed;
		var_01 = "tag_shield_back";
		var_02 = "tag_weapon_right";
	}

	self moveshieldmodel(var_03,var_01,var_02);
	if(param_00)
	{
		self.riotshieldmodelstowed = var_03;
		self.riotshieldmodel = undefined;
		return;
	}

	self.riotshieldmodel = var_03;
	self.riotshieldmodelstowed = undefined;
}

//Function Number: 196
riotshield_clear()
{
	self.hasriotshieldequipped = 0;
	self.hasriotshield = 0;
	self.riotshieldmodelstowed = undefined;
	self.riotshieldmodel = undefined;
}

//Function Number: 197
remove_crafting_item()
{
	self setclientomnvar("zombie_souvenir_piece_index",0);
	if(isdefined(level.crafting_remove_func))
	{
		self [[ level.crafting_remove_func ]]();
	}

	self.current_crafting_struct = undefined;
}

//Function Number: 198
store_weapons_status(param_00,param_01)
{
	self.copy_fullweaponlist = self getweaponslistall();
	self.copy_weapon_current = get_current_weapon(self,param_01);
	self.copy_weapon_level = [];
	var_02 = [];
	foreach(var_04 in self.copy_fullweaponlist)
	{
		if(!isstrstart(var_04,"alt_"))
		{
			var_02[var_02.size] = var_04;
		}
	}

	self.copy_fullweaponlist = var_02;
	foreach(var_04 in self.copy_fullweaponlist)
	{
		self.copy_weapon_ammo_clip[var_04] = self getweaponammoclip(var_04);
		self.copy_weapon_ammo_stock[var_04] = self getweaponammostock(var_04);
		if(issubstr(var_04,"akimbo"))
		{
			self.copy_weapon_ammo_clip_left[var_04] = self getweaponammoclip(var_04,"left");
		}

		if(isdefined(self.pap[getrawbaseweaponname(var_04)]))
		{
			self.copy_weapon_level[var_04] = self.pap[getrawbaseweaponname(var_04)].lvl;
		}
	}

	if(isdefined(param_00))
	{
		var_08 = [];
		foreach(var_04 in self.copy_fullweaponlist)
		{
			var_0A = 0;
			foreach(var_0C in param_00)
			{
				if(var_04 == var_0C)
				{
					var_0A = 1;
					break;
				}
				else if(getweaponbasename(var_04) == var_0C)
				{
					var_0A = 1;
					break;
				}
			}

			if(var_0A)
			{
				continue;
			}

			var_08[var_08.size] = var_04;
		}

		self.copy_fullweaponlist = var_08;
		foreach(var_0C in param_00)
		{
			if(self.copy_weapon_current == var_0C)
			{
				self.copy_weapon_current = "none";
				break;
			}
		}
	}
}

//Function Number: 199
get_current_weapon(param_00,param_01)
{
	var_02 = param_00 getcurrentweapon();
	if(scripts\engine\utility::istrue(param_01) && is_melee_weapon(var_02))
	{
		var_02 = param_00 getweaponslistall()[1];
	}

	return var_02;
}

//Function Number: 200
is_melee_weapon(param_00,param_01)
{
	switch(param_00)
	{
		case "iw7_knife_zm_disco":
		case "iw7_knife_zm_cleaver":
		case "iw7_knife_zm_crowbar":
		case "iw7_knife_zm_elvira":
		case "iw7_knife_zm_rebel":
		case "iw7_knife_zm_soldier":
		case "iw7_knife_zm_scientist":
		case "iw7_knife_zm_schoolgirl":
		case "alt_iw7_knife_zm_survivor":
		case "alt_iw7_knife_zm_grunge":
		case "alt_iw7_knife_zm_hiphop":
		case "alt_iw7_knife_zm_raver":
		case "alt_iw7_knife_zm_chola":
		case "iw7_knife_zm_survivor":
		case "iw7_knife_zm_grunge":
		case "iw7_knife_zm_hiphop":
		case "iw7_knife_zm_raver":
		case "iw7_knife_zm_chola":
		case "alt_iw7_knife_zm_vgirl":
		case "alt_iw7_knife_zm_rapper":
		case "alt_iw7_knife_zm_nerd":
		case "alt_iw7_knife_zm_jock":
		case "alt_iw7_knife_zm":
		case "iw7_knife_zm_vgirl":
		case "iw7_knife_zm_rapper":
		case "iw7_knife_zm_nerd":
		case "iw7_knife_zm_jock":
		case "alt_iw7_knife_zm_hoff":
		case "iw7_knife_zm_hoff":
		case "iw7_knife_zm_wyler":
		case "iw7_knife_zm":
			return 1;

		case "iw7_katana_zm_pap2":
		case "iw7_katana_zm_pap1":
		case "iw7_nunchucks_zm_pap2":
		case "iw7_nunchucks_zm_pap1":
		case "iw7_katana_zm":
		case "iw7_nunchucks_zm":
		case "iw7_axe_zm_pap2":
		case "iw7_axe_zm_pap1":
		case "iw7_axe_zm":
		case "iw7_fists_zm_kevinsmith":
		case "iw7_fists_zm_raver":
		case "iw7_fists_zm_hiphop":
		case "iw7_fists_zm_grunge":
		case "iw7_fists_zm_chola":
		case "iw7_fists_zm":
			if(scripts\engine\utility::istrue(param_01))
			{
				return 0;
			}
			else
			{
				return 1;
			}
	
			break;

		default:
			return 0;
	}
}

//Function Number: 201
is_primary_melee_weapon(param_00)
{
	switch(param_00)
	{
		case "iw7_katana_zm_pap2":
		case "iw7_katana_zm_pap1":
		case "iw7_nunchucks_zm_pap2":
		case "iw7_nunchucks_zm_pap1":
		case "iw7_katana_zm":
		case "iw7_nunchucks_zm":
		case "iw7_axe_zm_pap2":
		case "iw7_axe_zm_pap1":
		case "iw7_axe_zm":
			return 1;
	}

	return 0;
}

//Function Number: 202
restore_weapons_status(param_00)
{
	if(!isdefined(self.copy_fullweaponlist) || !isdefined(self.copy_weapon_current) || !isdefined(self.copy_weapon_ammo_clip) || !isdefined(self.copy_weapon_ammo_stock))
	{
	}

	var_01 = self getweaponslistall();
	foreach(var_03 in var_01)
	{
		if(!scripts\engine\utility::array_contains(self.copy_fullweaponlist,var_03) && !in_inclusion_list(param_00,var_03))
		{
			self takeweapon(var_03);
		}
	}

	foreach(var_03 in self.copy_fullweaponlist)
	{
		if(!self hasweapon(var_03))
		{
			var_06 = function_00E3(var_03);
			var_07 = getcurrentcamoname(var_03);
			self giveweapon(scripts\cp\cp_weapon::return_weapon_name_with_like_attachments(var_03,undefined,var_06,undefined,var_07),-1,0,-1,1);
		}

		if(isdefined(self.powerprimarygrenade) && self.powerprimarygrenade == var_03)
		{
			self assignweaponoffhandprimary(var_03);
		}

		if(isdefined(self.powersecondarygrenade) && self.powersecondarygrenade == var_03)
		{
			self gold_tooth_3_pickup(var_03);
		}

		if(isdefined(self.specialoffhandgrenade) && self.specialoffhandgrenade == var_03)
		{
			self assignweaponoffhandspecial(var_03);
		}

		if(isdefined(self.copy_weapon_ammo_clip[var_03]))
		{
			self setweaponammoclip(var_03,self.copy_weapon_ammo_clip[var_03]);
		}

		if(isdefined(self.copy_weapon_ammo_clip_left))
		{
			if(isdefined(self.copy_weapon_ammo_clip_left[var_03]))
			{
				self setweaponammoclip(var_03,self.copy_weapon_ammo_clip_left[var_03],"left");
			}
		}

		if(isdefined(self.copy_weapon_ammo_stock[var_03]))
		{
			self setweaponammostock(var_03,self.copy_weapon_ammo_stock[var_03]);
		}

		if(isdefined(self.copy_weapon_level[var_03]))
		{
			var_08 = spawnstruct();
			var_08.lvl = self.copy_weapon_level[var_03];
			self.pap[getrawbaseweaponname(var_03)] = var_08;
		}
	}

	var_0A = self.copy_weapon_current;
	if(!isdefined(var_0A) || var_0A == "none")
	{
		foreach(var_0C in self.copy_fullweaponlist)
		{
			if(scripts\cp\cp_weapon::isbulletweapon(var_0C))
			{
				var_0A = var_0C;
				break;
			}
		}
	}

	if(scripts\engine\utility::isweaponswitchallowed())
	{
		self switchtoweaponimmediate(var_0A);
	}

	self.copy_fullweaponlist = undefined;
	self.copy_weapon_current = undefined;
	self.copy_weapon_ammo_clip = undefined;
	self.copy_weapon_ammo_stock = undefined;
	self.copy_weapon_ammo_clip_left = undefined;
	if(isdefined(level.arcade_last_stand_power_func))
	{
		self [[ level.arcade_last_stand_power_func ]]();
	}
}

//Function Number: 203
restore_primary_weapons_only(param_00)
{
	if(!isdefined(self.copy_fullweaponlist) || !isdefined(self.copy_weapon_current) || !isdefined(self.copy_weapon_ammo_clip) || !isdefined(self.copy_weapon_ammo_stock))
	{
	}

	self.primary_weapons = [];
	var_01 = 0;
	foreach(var_03 in self.copy_fullweaponlist)
	{
		if(isinventoryprimaryweapon(var_03))
		{
			self.primary_weapons[var_01] = var_03;
			var_01 = var_01 + 1;
		}
	}

	var_05 = 0;
	foreach(var_03 in self.primary_weapons)
	{
		if(var_05 < 3)
		{
			if(isstrstart(var_03,"alt_"))
			{
				continue;
			}

			if(!self hasweapon(var_03))
			{
				if(issubstr(var_03,"knife_"))
				{
					self giveweapon(var_03,-1,0,-1,1);
				}
				else
				{
					var_07 = getcurrentcamoname(var_03);
					var_08 = function_00E3(var_03);
					self giveweapon(scripts\cp\cp_weapon::return_weapon_name_with_like_attachments(var_03,undefined,var_08,undefined,var_07),-1,0,-1,1);
				}
			}

			self setweaponammoclip(var_03,self.copy_weapon_ammo_clip[var_03]);
			self setweaponammostock(var_03,self.copy_weapon_ammo_stock[var_03]);
			if(isdefined(self.copy_weapon_level[var_03]))
			{
				var_09 = spawnstruct();
				var_09.lvl = self.copy_weapon_level[var_03];
				self.pap[getrawbaseweaponname(var_03)] = var_09;
			}

			var_05++;
		}
	}

	var_0B = self.copy_weapon_current;
	if(!isdefined(var_0B) || !self hasweapon(var_0B) || var_0B == "none")
	{
		var_0B = getweapontoswitchbackto();
	}

	self switchtoweaponimmediate(var_0B);
	self.copy_fullweaponlist = undefined;
	self.copy_weapon_current = undefined;
	self.copy_weapon_ammo_clip = undefined;
	self.copy_weapon_ammo_stock = undefined;
}

//Function Number: 204
clear_weapons_status()
{
	self.copy_fullweaponlist = [];
	self.copy_weapon_current = "none";
	self.copy_weapon_ammo_clip = [];
	self.copy_weapon_ammo_clip_left = [];
	self.copy_weapon_ammo_stock = [];
	self.copy_weapon_level = [];
}

//Function Number: 205
add_to_weapons_status(param_00,param_01,param_02,param_03)
{
	foreach(var_05 in param_00)
	{
		self.copy_fullweaponlist[self.copy_fullweaponlist.size] = var_05;
		self.copy_weapon_ammo_clip[var_05] = param_01[var_05];
		self.copy_weapon_ammo_stock[var_05] = param_02[var_05];
	}

	self.copy_weapon_current = param_03;
}

//Function Number: 206
in_inclusion_list(param_00,param_01)
{
	if(!isdefined(param_00))
	{
		return 0;
	}

	return scripts\engine\utility::array_contains(param_00,param_01);
}

//Function Number: 207
vec_multiply(param_00,param_01)
{
	return (param_00[0] * param_01,param_00[1] * param_01,param_00[2] * param_01);
}

//Function Number: 208
restore_super_weapon()
{
	self giveweapon("super_default_zm");
	self assignweaponoffhandspecial("super_default_zm");
	self.specialoffhandgrenade = "super_default_zm";
	if(scripts\engine\utility::istrue(self.consumable_meter_full))
	{
		self setweaponammoclip("super_default_zm",1);
	}
}

//Function Number: 209
is_zombie_agent()
{
	return isagent(self) && isdefined(self.species) && self.species == "humanoid" || self.species == "zombie";
}

//Function Number: 210
is_zombies_mode()
{
	return level.gametype == "zombie";
}

//Function Number: 211
coop_mode_has(param_00)
{
	if(!isdefined(level.coop_mode_feature))
	{
		return 0;
	}

	return isdefined(level.coop_mode_feature[param_00]);
}

//Function Number: 212
coop_mode_enable(param_00)
{
	if(!isdefined(level.coop_mode_feature))
	{
		level.coop_mode_feature = [];
	}

	foreach(var_02 in param_00)
	{
		level.coop_mode_feature[var_02] = 1;
	}
}

//Function Number: 213
make_entity_sentient_cp(param_00,param_01)
{
	if(!isdefined(param_01))
	{
		param_01 = 1;
	}

	if(param_01)
	{
		return self makeentitysentient(param_00,1);
	}

	return self makeentitysentient(param_00);
}

//Function Number: 214
get_attacker_as_player(param_00)
{
	if(isdefined(param_00))
	{
		if(isplayer(param_00))
		{
			return param_00;
		}

		if(isdefined(param_00.triggerportableradarping) && isplayer(param_00.triggerportableradarping))
		{
			return param_00.triggerportableradarping;
		}
	}

	return undefined;
}

//Function Number: 215
removeexcludedattachments(param_00)
{
	if(isdefined(level.excludedattachments))
	{
		foreach(var_02 in level.excludedattachments)
		{
			foreach(var_04 in param_00)
			{
				if(attachmentmap_tobase(var_04) == var_02)
				{
					param_00 = scripts\engine\utility::array_remove(param_00,var_04);
				}
			}
		}
	}

	return param_00;
}

//Function Number: 216
getrandomweaponattachments(param_00,param_01,param_02)
{
	var_03 = [];
	if(weaponhaspassive(param_00,param_01,"passive_random_attachments"))
	{
		if(0)
		{
			var_04 = getavailableattachments(param_00,param_02,0);
			var_03[var_03.size] = var_04[randomint(var_04.size)];
		}
		else
		{
			var_05 = int(max(0,5 - param_02.size));
			if(var_05 > 0)
			{
				var_06 = randomintrange(1,var_05 + 1);
				var_03 = buildrandomattachmentarray(param_00,var_06,param_02);
			}
		}
	}

	return var_03;
}

//Function Number: 217
weaponhaspassive(param_00,param_01,param_02)
{
	var_03 = getweaponpassives(param_00,param_01);
	if(!isdefined(var_03) || var_03.size <= 0)
	{
		return 0;
	}

	foreach(var_05 in var_03)
	{
		if(param_02 == var_05)
		{
			return 1;
		}
	}

	return 0;
}

//Function Number: 218
buildrandomattachmentarray(param_00,param_01,param_02)
{
	var_03 = [];
	var_04 = scripts\cp\cp_weapon::getattachmenttypeslist(param_00,param_02);
	if(var_04.size > 0)
	{
		var_03 = [];
		var_05 = scripts\engine\utility::array_randomize_objects(var_04);
		foreach(var_0A, var_07 in var_05)
		{
			if(param_01 <= 0)
			{
				break;
			}

			var_08 = 1;
			switch(var_0A)
			{
				case "undermount":
				case "barrel":
					var_08 = 1;
					break;

				case "rail":
				case "pap":
				case "perk":
					var_08 = 0;
					break;

				default:
					var_08 = randomintrange(1,param_01 + 1);
					break;
			}

			if(var_08 > 0)
			{
				if(var_08 > var_07.size)
				{
					var_08 = var_07.size;
				}

				param_01 = param_01 - var_08;
				var_07 = scripts\engine\utility::array_randomize_objects(var_07);
				while(var_08 > 0)
				{
					var_09 = var_07[var_07.size - var_08];
					if(!issubstr(var_09,"ark") && !issubstr(var_09,"arcane"))
					{
						var_03[var_03.size] = var_09;
					}

					var_08--;
				}
			}
		}
	}

	return var_03;
}

//Function Number: 219
getavailableattachments(param_00,param_01,param_02)
{
	if(!isdefined(param_02))
	{
		param_02 = 1;
	}

	var_03 = getweaponattachmentarrayfromstats(param_00);
	var_04 = [];
	foreach(var_06 in var_03)
	{
		var_07 = getattachmenttype(var_06);
		if(!param_02 && var_07 == "rail")
		{
			continue;
		}

		if(isdefined(param_01) && listhasattachment(param_01,var_06))
		{
			continue;
		}

		var_04[var_04.size] = var_06;
	}

	return var_04;
}

//Function Number: 220
listhasattachment(param_00,param_01)
{
	foreach(var_03 in param_00)
	{
		if(var_03 == param_01)
		{
			return 1;
		}
	}

	return 0;
}

//Function Number: 221
getweaponattachmentarrayfromstats(param_00)
{
	param_00 = getweaponrootname(param_00);
	if(!isdefined(level.weaponattachments))
	{
		level.weaponattachments = [];
	}

	if(!isdefined(level.weaponattachments[param_00]))
	{
		var_01 = [];
		for(var_02 = 0;var_02 <= 19;var_02++)
		{
			var_03 = tablelookup("mp/statsTable.csv",4,param_00,10 + var_02);
			if(var_03 == "")
			{
				break;
			}

			var_01[var_01.size] = var_03;
		}

		level.weaponattachments[param_00] = var_01;
	}

	return level.weaponattachments[param_00];
}

//Function Number: 222
getweaponpaintjobid(param_00)
{
	return -1;
}

//Function Number: 223
getweaponcamo(param_00)
{
	var_01 = self getplayerdata("cp","zombiePlayerLoadout","zombiePlayerWeaponModels",param_00,"camo");
	if(isdefined(var_01) && var_01 != "none")
	{
		return var_01;
	}

	return "none";
}

//Function Number: 224
getweaponcosmeticattachment(param_00)
{
	var_01 = self getplayerdata("cp","zombiePlayerLoadout","zombiePlayerWeaponModels",param_00,"cosmeticAttachment");
	if(isdefined(var_01) && var_01 != "none")
	{
		return var_01;
	}

	return "none";
}

//Function Number: 225
getweaponreticle(param_00)
{
	var_01 = self getplayerdata("cp","zombiePlayerLoadout","zombiePlayerWeaponModels",param_00,"reticle");
	if(isdefined(var_01) && var_01 != "none")
	{
		return var_01;
	}

	return "none";
}

//Function Number: 226
excludeweaponfromregularweaponchecks(param_00)
{
	if(param_00 == "iw7_entangler_zm" || param_00 == "iw7_entangler2_zm")
	{
		return 1;
	}

	if(issubstr(param_00,"venomx") || issubstr(param_00,"nunchucks") || issubstr(param_00,"katana"))
	{
		return 1;
	}

	return 0;
}

//Function Number: 227
mpbuildweaponname(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08)
{
	var_09 = weaponattachdefaultmap(param_00);
	var_0A = buildweaponassetname(param_00,param_04);
	if(isdefined(param_04) && param_04 >= 0 && !excludeweaponfromregularweaponchecks(var_0A))
	{
		var_0B = getrandomweaponattachments(var_0A,param_04,param_01);
		if(var_0B.size > 0)
		{
			param_01 = scripts\engine\utility::array_combine_unique(param_01,var_0B);
		}
	}

	var_0C = coop_getweaponclass(var_0A);
	if(isdefined(var_09))
	{
		param_01 = scripts\engine\utility::array_combine_unique(param_01,var_09);
	}

	param_01 = weaponattachremoveextraattachments(param_01);
	param_01 = removeexcludedattachments(param_01);
	for(var_0D = 0;var_0D < param_01.size;var_0D++)
	{
		param_01[var_0D] = attachmentmap_tounique(param_01[var_0D],var_0A);
	}

	if(isdefined(var_09))
	{
		for(var_0D = 0;var_0D < var_09.size;var_0D++)
		{
			var_09[var_0D] = attachmentmap_tounique(var_09[var_0D],var_0A);
		}
	}

	if(isdefined(var_09))
	{
		param_01 = scripts\engine\utility::array_combine_unique(param_01,var_09);
	}

	if(isdefined(param_04) && param_04 >= 0 && !excludeweaponfromregularweaponchecks(var_0A))
	{
		var_0E = getweaponvariantattachments(var_0A,param_04);
		if(var_0E.size > 0)
		{
			param_01 = scripts\engine\utility::array_combine_unique(param_01,var_0E);
		}
	}

	param_01 = scripts\engine\utility::array_remove(param_01,"none");
	if(isdefined(param_08) && param_08 != "none")
	{
		param_01[param_01.size] = param_08;
	}

	if(param_01.size > 0)
	{
		param_01 = filterattachments(param_01);
	}

	var_0F = [];
	foreach(var_11 in param_01)
	{
		var_12 = attachmentmap_toextra(var_11);
		if(isdefined(var_12))
		{
			var_0F[var_0F.size] = attachmentmap_tounique(var_12,var_0A);
		}
	}

	if(var_0F.size > 0)
	{
		param_01 = scripts\engine\utility::array_combine_unique(param_01,var_0F);
	}

	if(param_01.size > 0)
	{
		param_01 = scripts\engine\utility::alphabetize(param_01);
	}

	var_0A = reassign_weapon_name(var_0A,param_01);
	foreach(var_15 in param_01)
	{
		var_0A = var_0A + "+" + var_15;
	}

	if(issubstr(var_0A,"iw7"))
	{
		var_0A = buildweaponnamecamo(var_0A,param_02,param_04);
		var_17 = 0;
		if(isholidayweapon(var_0A,param_04) || issummerholidayweapon(var_0A,param_04))
		{
			var_17 = isholidayweaponusingdefaultscope(var_0A,param_01);
		}

		if(var_17)
		{
			var_0A = var_0A + "+scope1";
		}
		else
		{
			var_0A = buildweaponnamereticle(var_0A,param_03);
		}

		var_0A = buildweaponnamevariantid(var_0A,param_04);
	}

	return var_0A;
}

//Function Number: 228
reassign_weapon_name(param_00,param_01)
{
	if(isdefined(level.weapon_upgrade_path) && isdefined(level.weapon_upgrade_path[getweaponbasename(param_00)]))
	{
		return param_00;
	}
	else
	{
		switch(param_00)
		{
			case "iw7_machete_mp":
				if(scripts\engine\utility::istrue(self.base_weapon))
				{
					param_00 = "iw7_machete_mp";
				}
				else if((isdefined(self.pap[getrawbaseweaponname(param_00)]) && self.pap[getrawbaseweaponname(param_00)].lvl == 1) || scripts\engine\utility::istrue(self.ephemeral_downgrade))
				{
					if(scripts\engine\utility::istrue(self.bang_bangs))
					{
						param_00 = "iw7_machete_mp";
					}
					else
					{
						param_00 = "iw7_machete_mp_pap1";
					}
				}
				else if(isdefined(self.pap[getrawbaseweaponname(param_00)]) && self.pap[getrawbaseweaponname(param_00)].lvl == 2)
				{
					if(scripts\engine\utility::istrue(self.bang_bangs))
					{
						param_00 = "iw7_machete_mp_pap1";
					}
					else
					{
						param_00 = "iw7_machete_mp_pap2";
					}
				}
				else if(isdefined(self.pap[getrawbaseweaponname(param_00)]) && self.pap[getrawbaseweaponname(param_00)].lvl == 3)
				{
					param_00 = "iw7_machete_mp_pap2";
				}
				break;

			case "iw7_two_headed_axe_mp":
				if(scripts\engine\utility::istrue(self.base_weapon))
				{
					param_00 = "iw7_two_headed_axe_mp";
				}
				else if((isdefined(self.pap[getrawbaseweaponname(param_00)]) && self.pap[getrawbaseweaponname(param_00)].lvl == 1) || scripts\engine\utility::istrue(self.ephemeral_downgrade))
				{
					if(scripts\engine\utility::istrue(self.bang_bangs))
					{
						param_00 = "iw7_two_headed_axe_mp";
					}
					else
					{
						param_00 = "iw7_two_headed_axe_mp_pap1";
					}
				}
				else if(isdefined(self.pap[getrawbaseweaponname(param_00)]) && self.pap[getrawbaseweaponname(param_00)].lvl == 2)
				{
					if(scripts\engine\utility::istrue(self.bang_bangs))
					{
						param_00 = "iw7_two_headed_axe_mp_pap1";
					}
					else
					{
						param_00 = "iw7_two_headed_axe_mp_pap2";
					}
				}
				else if(isdefined(self.pap[getrawbaseweaponname(param_00)]) && self.pap[getrawbaseweaponname(param_00)].lvl == 3)
				{
					param_00 = "iw7_two_headed_axe_mp_pap2";
				}
				break;

			case "iw7_spiked_bat_mp":
				if(scripts\engine\utility::istrue(self.base_weapon))
				{
					param_00 = "iw7_spiked_bat_mp";
				}
				else if((isdefined(self.pap[getrawbaseweaponname(param_00)]) && self.pap[getrawbaseweaponname(param_00)].lvl == 1) || scripts\engine\utility::istrue(self.ephemeral_downgrade))
				{
					if(scripts\engine\utility::istrue(self.bang_bangs))
					{
						param_00 = "iw7_spiked_bat_mp";
					}
					else
					{
						param_00 = "iw7_spiked_bat_mp_pap1";
					}
				}
				else if(isdefined(self.pap[getrawbaseweaponname(param_00)]) && self.pap[getrawbaseweaponname(param_00)].lvl == 2)
				{
					if(scripts\engine\utility::istrue(self.bang_bangs))
					{
						param_00 = "iw7_spiked_bat_mp_pap1";
					}
					else
					{
						param_00 = "iw7_spiked_bat_mp_pap2";
					}
				}
				else if(isdefined(self.pap[getrawbaseweaponname(param_00)]) && self.pap[getrawbaseweaponname(param_00)].lvl == 3)
				{
					param_00 = "iw7_spiked_bat_mp_pap2";
				}
				break;

			case "iw7_golf_club_mp":
				if(scripts\engine\utility::istrue(self.base_weapon))
				{
					param_00 = "iw7_golf_club_mp";
				}
				else if((isdefined(self.pap[getrawbaseweaponname(param_00)]) && self.pap[getrawbaseweaponname(param_00)].lvl == 1) || scripts\engine\utility::istrue(self.ephemeral_downgrade))
				{
					if(scripts\engine\utility::istrue(self.bang_bangs))
					{
						param_00 = "iw7_golf_club_mp";
					}
					else
					{
						param_00 = "iw7_golf_club_mp_pap1";
					}
				}
				else if(isdefined(self.pap[getrawbaseweaponname(param_00)]) && self.pap[getrawbaseweaponname(param_00)].lvl == 2)
				{
					if(scripts\engine\utility::istrue(self.bang_bangs))
					{
						param_00 = "iw7_golf_club_mp_pap1";
					}
					else
					{
						param_00 = "iw7_golf_club_mp_pap2";
					}
				}
				else if(isdefined(self.pap[getrawbaseweaponname(param_00)]) && self.pap[getrawbaseweaponname(param_00)].lvl == 3)
				{
					param_00 = "iw7_golf_club_mp_pap2";
				}
				break;

			case "iw7_axe_zm":
				if(scripts\engine\utility::array_contains(param_01,"axepap1"))
				{
					param_00 = "iw7_axe_zm_pap1";
				}
				else if(scripts\engine\utility::array_contains(param_01,"axepap2"))
				{
					param_00 = "iw7_axe_zm_pap2";
				}
				break;

			case "iw7_katana_zm":
				if(scripts\engine\utility::array_contains(param_01,"katanapap1"))
				{
					param_00 = "iw7_katana_zm_pap1";
				}
				else if(scripts\engine\utility::array_contains(param_01,"katanapap2"))
				{
					param_00 = "iw7_katana_zm_pap2";
				}
				break;

			case "iw7_nunchucks_zm":
				if(scripts\engine\utility::array_contains(param_01,"nunchuckspap1"))
				{
					param_00 = "iw7_nunchucks_zm_pap1";
				}
				else if(scripts\engine\utility::array_contains(param_01,"nunchuckspap2"))
				{
					param_00 = "iw7_nunchucks_zm_pap2";
				}
				break;

			case "iw7_forgefreeze_zm":
				if(scripts\engine\utility::array_contains(param_01,"freezepap1"))
				{
					param_00 = "iw7_forgefreeze_zm_pap1";
				}
				else if(scripts\engine\utility::array_contains(param_01,"freezepap2"))
				{
					param_00 = "iw7_forgefreeze_zm_pap2";
				}
				break;

			case "iw7_shredder_zm":
				if(scripts\engine\utility::array_contains(param_01,"shredderpap1"))
				{
					param_00 = "iw7_shredder_zm_pap1";
				}
				break;

			case "iw7_dischord_zm":
				if(scripts\engine\utility::array_contains(param_01,"dischordpap1"))
				{
					param_00 = "iw7_dischord_zm_pap1";
				}
				break;

			case "iw7_facemelter_zm":
				if(scripts\engine\utility::array_contains(param_01,"fmpap1"))
				{
					param_00 = "iw7_facemelter_zm_pap1";
				}
				break;

			case "iw7_headcutter_zm":
				if(scripts\engine\utility::array_contains(param_01,"hcpap1"))
				{
					param_00 = "iw7_headcutter_zm_pap1";
				}
				break;
		}
	}

	return param_00;
}

//Function Number: 229
get_weapon_variant_id(param_00,param_01)
{
	var_02 = getbaseweaponname(param_01);
	if(function_02D9("mp","LoadoutWeapon",var_02) && weaponhasvariants(var_02))
	{
		return param_00 getplayerdata("cp","zombiePlayerLoadout","zombiePlayerWeaponModels",var_02,"variantID");
	}

	return -1;
}

//Function Number: 230
weaponhasvariants(param_00)
{
	if(!isdefined(param_00))
	{
		return 0;
	}

	switch(param_00)
	{
		case "iw7_glprox":
		case "iw7_lockon":
		case "iw7_chargeshot":
		case "iw7_axe":
		case "iw7_g18c":
		case "iw7_arclassic":
		case "iw7_spasc":
		case "iw7_cheytacc":
		case "iw7_ump45c":
		case "iw7_m1c":
			return 0;

		default:
			return 1;
	}
}

//Function Number: 231
weaponattachremoveextraattachments(param_00)
{
	var_01 = [];
	foreach(var_03 in param_00)
	{
		if(isdefined(level.attachmentextralist[var_03]))
		{
			continue;
		}

		var_01[var_01.size] = var_03;
	}

	return var_01;
}

//Function Number: 232
weaponattachdefaultmap(param_00)
{
	if(isdefined(level.weaponmapdata[param_00]) && isdefined(level.weaponmapdata[param_00].attachdefaults))
	{
		return level.weaponmapdata[param_00].attachdefaults;
	}

	return undefined;
}

//Function Number: 233
buildweaponassetname(param_00,param_01)
{
	if(excludeweaponfromregularweaponchecks(param_00) || !isdefined(param_01) || param_01 < 0)
	{
		switch(param_00)
		{
			case "iw7_two_headed_axe":
			case "iw7_spiked_bat":
			case "iw7_machete":
			case "iw7_golf_club":
				return param_00 + "_mp";

			case "iw7_golf_club_mp":
			case "iw7_spiked_bat_mp":
			case "iw7_two_headed_axe_mp":
			case "iw7_machete_mp":
			case "super_default_zm":
				return param_00;

			case "iw7_ake":
				return param_00 + "_zml";

			case "iw7_crb":
				return param_00 + "_zml";

			case "iw7_sonic":
				return param_00 + "_zmr";

			case "iw7_ump45":
				return param_00 + "_zml";

			case "iw7_ripper":
				return param_00 + "_zmr";

			case "iw7_g18":
				return param_00 + "_zmr";

			case "iw7_spas":
				return param_00 + "_zmr";

			case "iw7_cheytac":
				return param_00 + "_zmr";

			case "iw7_venomx_zm_pap2":
			case "iw7_venomx_zm_pap1":
			case "iw7_venomx_zm":
			case "iw7_katana_zm_pap2":
			case "iw7_katana_zm_pap1":
			case "iw7_nunchucks_zm_pap2":
			case "iw7_nunchucks_zm_pap1":
			case "iw7_katana_zm":
			case "iw7_nunchucks_zm":
				return param_00;
		}

		return param_00 + "_zm";
	}

	switch(param_00)
	{
		case "iw7_venomx_zm_pap2":
		case "iw7_venomx_zm_pap1":
		case "iw7_venomx_zm":
		case "iw7_katana_zm_pap2":
		case "iw7_katana_zm_pap1":
		case "iw7_nunchucks_zm_pap2":
		case "iw7_nunchucks_zm_pap1":
		case "iw7_katana_zm":
		case "iw7_nunchucks_zm":
			return param_00;

		default:
			var_02 = getweaponassetfromrootweapon(param_00,param_01);
			return var_02;
	}
}

//Function Number: 234
getweaponassetfromrootweapon(param_00,param_01)
{
	var_02 = "mp/loot/weapon/" + param_00 + ".csv";
	var_03 = tablelookup(var_02,0,param_01,20);
	return var_03;
}

//Function Number: 235
getweaponvariantattachments(param_00,param_01)
{
	var_02 = [];
	var_03 = getweaponpassives(param_00,param_01);
	if(isdefined(var_03))
	{
		foreach(var_05 in var_03)
		{
			var_06 = getpassiveattachment(var_05);
			if(!isdefined(var_06))
			{
				continue;
			}

			var_02[var_02.size] = var_06;
		}
	}

	return var_02;
}

//Function Number: 236
getpassiveattachment(param_00)
{
	var_01 = getpassivestruct(param_00);
	if(!isdefined(var_01) || !isdefined(var_01.attachmentroll))
	{
		return undefined;
	}

	return var_01.attachmentroll;
}

//Function Number: 237
getweaponpassives(param_00,param_01)
{
	return getpassivesforweapon(param_00,param_01);
}

//Function Number: 238
getpassivesforweapon(param_00,param_01)
{
	var_02 = getlootinfoforweapon(param_00,param_01);
	if(isdefined(var_02))
	{
		return var_02.passives;
	}

	return undefined;
}

//Function Number: 239
getlootinfoforweapon(param_00,param_01)
{
	var_02 = getweaponrootname(param_00);
	if(!isdefined(level.lootweaponcache))
	{
		level.lootweaponcache = [];
	}

	if(isdefined(level.lootweaponcache[var_02]) && isdefined(level.lootweaponcache[var_02][param_01]))
	{
		var_03 = level.lootweaponcache[var_02][param_01];
		return var_03;
	}

	var_03 = cachelootweaponweaponinfo(param_01,var_03,var_02);
	if(isdefined(var_03))
	{
		return var_03;
	}

	return undefined;
}

//Function Number: 240
getweaponrootname(param_00)
{
	var_01 = strtok(param_00,"_");
	if(weapon_is_dlc_melee(param_00))
	{
		param_00 = var_01[0];
		for(var_02 = 1;var_02 < var_01.size - 1;var_02++)
		{
			param_00 = param_00 + "_" + var_01[var_02];
		}
	}
	else if(weapon_is_dlc2_melee(param_00))
	{
		return param_00;
	}
	else if(weapon_is_venomx(param_00))
	{
		return param_00;
	}
	else if(var_01[0] == "iw6" || var_01[0] == "iw7")
	{
		param_00 = var_01[0] + "_" + var_01[1];
	}
	else if(var_01[0] == "alt")
	{
		param_00 = var_01[1] + "_" + var_01[2];
	}

	return param_00;
}

//Function Number: 241
weapon_is_venomx(param_00)
{
	return issubstr(param_00,"venomx");
}

//Function Number: 242
weapon_is_dlc2_melee(param_00)
{
	return issubstr(param_00,"katana") || issubstr(param_00,"nunchucks");
}

//Function Number: 243
weapon_is_dlc_melee(param_00)
{
	return issubstr(param_00,"two_headed") || issubstr(param_00,"spiked_bat") || issubstr(param_00,"machete") || issubstr(param_00,"golf_club");
}

//Function Number: 244
cachelootweaponweaponinfo(param_00,param_01,param_02)
{
	if(!isdefined(level.lootweaponcache[param_01]))
	{
		level.lootweaponcache[param_01] = [];
	}

	var_03 = function_02C3(param_00);
	var_04 = readweaponinfofromtable(var_03,param_02);
	level.lootweaponcache[param_01][param_02] = var_04;
	return var_04;
}

//Function Number: 245
readweaponinfofromtable(param_00,param_01)
{
	var_02 = tablelookuprownum(param_00,0,param_01);
	var_03 = spawnstruct();
	var_03.ref = tablelookupbyrow(param_00,var_02,1);
	var_03.weaponasset = tablelookupbyrow(param_00,var_02,20);
	var_03.passives = [];
	for(var_04 = 0;var_04 < 3;var_04++)
	{
		var_05 = tablelookupbyrow(param_00,var_02,21 + var_04);
		if(isdefined(var_05) && var_05 != "")
		{
			var_03.passives[var_03.passives.size] = var_05;
		}
	}

	return var_03;
}

//Function Number: 246
filterattachments(param_00)
{
	var_01 = [];
	if(isdefined(param_00))
	{
		foreach(var_03 in param_00)
		{
			var_04 = 1;
			foreach(var_06 in var_01)
			{
				if(var_03 == var_06)
				{
					var_04 = 0;
					break;
				}

				if(!attachmentscompatible(var_03,var_06))
				{
					var_04 = 0;
					break;
				}
			}

			if(var_04)
			{
				var_01[var_01.size] = var_03;
			}
		}
	}

	return var_01;
}

//Function Number: 247
attachmentscompatible(param_00,param_01)
{
	param_00 = attachmentmap_tobase(param_00);
	param_01 = attachmentmap_tobase(param_01);
	var_02 = 1;
	if(param_00 == param_01)
	{
		var_02 = 0;
	}
	else if(isdefined(level.attachmentmap_conflicts))
	{
		var_03 = scripts\engine\utility::alphabetize([param_00,param_01]);
		var_02 = !isdefined(level.attachmentmap_conflicts[var_03[0] + "_" + var_03[1]]);
	}
	else if(param_00 != "none" && param_01 != "none")
	{
		var_04 = tablelookuprownum("mp/attachmentcombos.csv",0,param_01);
		if(tablelookup("mp/attachmentcombos.csv",0,param_00,var_04) == "no")
		{
			var_02 = 0;
		}
	}

	return var_02;
}

//Function Number: 248
attachmentmap_toextra(param_00)
{
	var_01 = undefined;
	if(isdefined(level.attachmentmap_uniquetoextra[param_00]))
	{
		var_01 = level.attachmentmap_uniquetoextra[param_00];
	}

	return var_01;
}

//Function Number: 249
getpassivestruct(param_00)
{
	if(!isdefined(level.passivemap[param_00]))
	{
		return undefined;
	}

	var_01 = level.passivemap[param_00];
	return var_01;
}

//Function Number: 250
map_check(param_00)
{
	if(!isdefined(param_00))
	{
		return 1;
	}

	switch(param_00)
	{
		case 0:
			if(level.script == "cp_zmb")
			{
				return 1;
			}
			else
			{
				return 0;
			}
	
			break;

		case 1:
			if(level.script == "cp_rave")
			{
				return 1;
			}
			else
			{
				return 0;
			}
	
			break;

		case 2:
			if(level.script == "cp_disco")
			{
				return 1;
			}
			else
			{
				return 0;
			}
	
			break;

		case 3:
			if(level.script == "cp_town")
			{
				return 1;
			}
			else
			{
				return 0;
			}
	
			break;

		case 4:
			if(level.script == "cp_final")
			{
				return 1;
			}
			else
			{
				return 0;
			}
	
			break;

		default:
			return 1;
	}
}

//Function Number: 251
buildweaponname(param_00,param_01,param_02,param_03,param_04)
{
	if(isstrstart(param_00,"iw7_"))
	{
		param_02 = 0;
	}

	var_05 = [];
	foreach(var_07 in param_01)
	{
		var_05[var_05.size] = attachmentmap_tounique(var_07,param_00);
	}

	var_09 = getrawbaseweaponname(param_00);
	var_0A = param_00;
	var_0B = var_09 == "kbs" || var_09 == "cheytac" || var_09 == "m8" || var_09 == "ripper" || var_09 == "erad" || var_09 == "ar57";
	if(var_0B)
	{
		var_0C = 0;
		foreach(var_07 in var_05)
		{
			if(getattachmenttype(var_07) == "rail")
			{
				var_0C = 1;
				break;
			}
		}

		if(!var_0C)
		{
			var_05[var_05.size] = var_09 + "scope";
		}
	}

	if(var_05.size > 0)
	{
		var_0F = scripts\engine\utility::array_remove_duplicates(var_05);
		var_05 = scripts\engine\utility::alphabetize(var_0F);
	}

	foreach(var_07 in var_05)
	{
		var_0A = var_0A + "+" + var_07;
	}

	if(issubstr(var_0A,"iw6") || issubstr(var_0A,"iw7"))
	{
		var_0A = buildweaponnamecamo(var_0A,param_02);
		if(param_04 != "weapon_sniper" && isdefined(param_03))
		{
			var_0A = buildweaponnamereticle(var_0A,param_03);
		}
	}
	else if(!scripts\cp\cp_weapon::isvalidzombieweapon(var_0A + "_zm"))
	{
		var_0A = param_00 + "_zm";
	}
	else
	{
		var_0A = buildweaponnamecamo(var_0A,param_02);
		var_0A = buildweaponnamereticle(var_0A,param_03);
		var_0A = var_0A + "_zm";
	}

	return var_0A;
}

//Function Number: 252
buildweaponnamevariantid(param_00,param_01)
{
	if(!isdefined(param_01) || param_01 < 0)
	{
		return param_00;
	}

	if(excludeweaponfromregularweaponchecks(param_00))
	{
		return param_00;
	}

	param_00 = param_00 + "+loot" + param_01;
	return param_00;
}

//Function Number: 253
isholidayweapon(param_00,param_01)
{
	if(!isdefined(param_01) || param_01 < 0)
	{
		return 0;
	}

	if(param_01 == 6)
	{
		var_02 = getweaponrootname(param_00);
		return var_02 == "iw7_ripper" || var_02 == "iw7_lmg03" || var_02 == "iw7_ar57";
	}

	return 0;
}

//Function Number: 254
issummerholidayweapon(param_00,param_01)
{
	if(!isdefined(param_01) || param_01 < 0)
	{
		return 0;
	}

	var_02 = getweaponrootname(param_00);
	if(param_01 == 8)
	{
		return var_02 == "iw7_erad" || var_02 == "iw7_ake" || var_02 == "iw7_sdflmg";
	}

	if(param_01 == 5)
	{
		return var_02 == "iw7_mod2187" || var_02 == "iw7_longshot";
	}

	return 0;
}

//Function Number: 255
ishalloweenholidayweapon(param_00,param_01)
{
	if(!isdefined(param_01) || param_01 < 0)
	{
		return 0;
	}

	var_02 = getweaponrootname(param_00);
	if(param_01 == 9)
	{
		return var_02 == "iw7_kbs" || var_02 == "iw7_ripper" || var_02 == "iw7_m4";
	}

	if(param_01 == 8)
	{
		return var_02 == "iw7_mod2187";
	}

	if(param_01 == 7)
	{
		return var_02 == "iw7_mag";
	}

	if(param_01 == 6)
	{
		return var_02 == "iw7_minilmg";
	}

	return 0;
}

//Function Number: 256
ismark2weapon(param_00)
{
	if(!isdefined(param_00))
	{
		return 0;
	}

	return param_00 >= 32;
}

//Function Number: 257
isholidayweaponusingdefaultscope(param_00,param_01)
{
	var_02 = attachmentmap_tounique("scope",getweaponbasename(param_00));
	return isdefined(var_02) && scripts\engine\utility::array_contains(param_01,var_02);
}

//Function Number: 258
is_pap_camo(param_00)
{
	if(isdefined(level.pap_1_camo) && param_00 == level.pap_1_camo)
	{
		return 1;
	}
	else if(isdefined(level.pap_2_camo) && param_00 == level.pap_2_camo)
	{
		return 1;
	}

	return 0;
}

//Function Number: 259
buildweaponnamecamo(param_00,param_01,param_02)
{
	var_03 = -1;
	var_04 = isdefined(param_01) && is_pap_camo(param_01);
	if(param_00 == "iw7_nunchucks_zm_pap1" || param_00 == "iw7_nunchucks_zm_pap2")
	{
		return param_00 + "+camo" + 222;
	}

	if(excludeweaponfromregularweaponchecks(param_00))
	{
		if(param_00 == "iw7_nunchucks_zm" || param_00 == "iw7_katana_zm")
		{
			return param_00;
		}
	}

	if(!var_04)
	{
		if(isholidayweapon(param_00,param_02))
		{
			var_03 = int(tablelookup("mp/camoTable.csv",1,"camo89",scripts\engine\utility::getcamotablecolumnindex("weapon_index")));
			return param_00 + "+camo" + var_03;
		}
		else if(issummerholidayweapon(param_00,param_02))
		{
			var_03 = int(tablelookup("mp/camoTable.csv",1,"camo230",scripts\engine\utility::getcamotablecolumnindex("weapon_index")));
			return param_00 + "+camo" + var_03;
		}
		else if(ishalloweenholidayweapon(param_00,param_02))
		{
			var_03 = int(tablelookup("mp/camoTable.csv",1,"camo242",scripts\engine\utility::getcamotablecolumnindex("weapon_index")));
			return param_00 + "+camo" + var_03;
		}
		else if((!isdefined(param_01) || param_01 == "none") && ismark2weapon(param_02))
		{
			var_05 = getweaponqualitybyid(param_00,param_02);
			var_06 = undefined;
			switch(var_05)
			{
				case 1:
							var_06 = "camo99";
							break;

				case 2:
							var_06 = "camo101";
							break;

				case 3:
							var_06 = "camo102";
							break;

				case 4:
							var_06 = "camo103";
							break;

				default:
							break;
			}

			var_03 = int(tablelookup("mp/camoTable.csv",1,var_06,scripts\engine\utility::getcamotablecolumnindex("weapon_index")));
			return param_00 + "+camo" + var_03;
		}
	}

	if(!isdefined(var_03))
	{
		var_05 = 0;
	}
	else
	{
		var_05 = int(tablelookup("mp/camoTable.csv",1,var_03,scripts\engine\utility::getcamotablecolumnindex("weapon_index")));
	}

	if(var_05 <= 0)
	{
		var_05 = getweaponqualitybyid(param_02,var_04);
		var_06 = undefined;
		switch(var_05)
		{
			case 1:
				var_06 = "camo24";
				break;

			case 2:
				var_06 = "camo19";
				break;

			case 3:
				var_06 = "camo18";
				break;

			default:
				break;
		}

		if(isdefined(var_06))
		{
			var_03 = int(tablelookup("mp/camoTable.csv",1,var_06,scripts\engine\utility::getcamotablecolumnindex("weapon_index")));
		}
		else
		{
			return param_00;
		}
	}

	return param_00 + "+camo" + var_03;
}

//Function Number: 260
getweaponqualitybyid(param_00,param_01)
{
	if(!isdefined(param_01) || param_01 < 0 || excludeweaponfromregularweaponchecks(param_00))
	{
		return 0;
	}

	var_02 = function_02C3(param_00);
	var_03 = int(tablelookup(var_02,0,param_01,4));
	return var_03;
}

//Function Number: 261
buildweaponnamereticle(param_00,param_01)
{
	if(!isdefined(param_01))
	{
		return param_00;
	}

	if(excludeweaponfromregularweaponchecks(param_00))
	{
		return param_00;
	}

	var_02 = int(tablelookup("mp/reticleTable.csv",1,param_01,5));
	if(!isdefined(var_02) || var_02 == 0)
	{
		return param_00;
	}

	param_00 = param_00 + "+scope" + var_02;
	return param_00;
}

//Function Number: 262
has_zombie_perk(param_00)
{
	if(!isdefined(self.zombies_perks))
	{
		return 0;
	}

	return scripts\engine\utility::istrue(self.zombies_perks[param_00]);
}

//Function Number: 263
drawsphere(param_00,param_01,param_02,param_03)
{
	var_04 = int(param_02 * 20);
	for(var_05 = 0;var_05 < var_04;var_05++)
	{
		wait(0.05);
	}
}

//Function Number: 264
set_alien_emissive(param_00,param_01)
{
	var_02 = self.maxemissive - self.defaultemissive;
	var_03 = param_01 * var_02 + self.defaultemissive;
	self getrandomhovernodesaroundtargetpos(param_00,var_03);
}

//Function Number: 265
get_adjusted_armor(param_00,param_01)
{
	if(param_00 + level.deployablebox_vest_rank[param_01] > level.deployablebox_vest_max)
	{
		return level.deployablebox_vest_max;
	}

	return param_00 + level.deployablebox_vest_rank[param_01];
}

//Function Number: 266
alien_mode_has(param_00)
{
	param_00 = tolower(param_00);
	if(!isdefined(level.alien_mode_feature))
	{
		return 0;
	}

	if(!isdefined(level.alien_mode_feature[param_00]))
	{
		return 0;
	}

	return level.alien_mode_feature[param_00];
}

//Function Number: 267
enable_alien_scripted()
{
	self.alien_scripted = 1;
	self notify("alien_main_loop_restart");
}

//Function Number: 268
array_remove_index(param_00,param_01,param_02)
{
	var_03 = [];
	foreach(var_07, var_05 in param_00)
	{
		if(var_07 == param_01)
		{
			continue;
		}

		if(scripts\engine\utility::istrue(param_02))
		{
			var_06 = var_07;
		}
		else
		{
			var_06 = var_03.size;
		}

		var_03[var_06] = var_05;
	}

	return var_03;
}

//Function Number: 269
is_normal_upright(param_00)
{
	var_01 = (0,0,1);
	var_02 = 0.85;
	return vectordot(param_00,var_01) > var_02;
}

//Function Number: 270
get_synch_direction_list(param_00)
{
	if(!isdefined(self.synch_attack_setup))
	{
		return [];
	}

	if(!isdefined(self.synch_attack_setup.synch_directions))
	{
		return [];
	}

	if(!self.synch_attack_setup.type_specific)
	{
		return self.synch_attack_setup.synch_directions;
	}

	var_01 = scripts\cp\cp_agent_utils::get_agent_type(param_00);
	if(!isdefined(self.synch_attack_setup.synch_directions[var_01]))
	{
		var_02 = "Synch attack on " + self.synch_attack_setup.identifier + " doesn\'t handle type: " + var_01;
	}

	return self.synch_attack_setup.synch_directions[var_01];
}

//Function Number: 271
getrandomindex(param_00)
{
	var_01 = 0;
	foreach(var_03 in param_00)
	{
		var_01 = var_01 + var_03;
	}

	var_05 = randomintrange(0,var_01);
	var_01 = 0;
	foreach(var_07, var_03 in param_00)
	{
		var_01 = var_01 + var_03;
		if(var_05 <= var_01)
		{
			return var_07;
		}
	}

	return 0;
}

//Function Number: 272
get_closest_living_player()
{
	var_00 = 1073741824;
	var_01 = undefined;
	foreach(var_03 in level.players)
	{
		var_04 = distancesquared(self.origin,var_03.origin);
		if(isreallyalive(var_03) && var_04 < var_00)
		{
			var_01 = var_03;
			var_00 = var_04;
		}
	}

	return var_01;
}

//Function Number: 273
get_array_of_valid_players(param_00,param_01)
{
	var_02 = [];
	foreach(var_04 in level.players)
	{
		if(var_04 is_valid_player())
		{
			var_02[var_02.size] = var_04;
		}
	}

	if(!isdefined(param_00) || !param_00)
	{
		return var_02;
	}

	return scripts\engine\utility::get_array_of_closest(param_01,var_02);
}

//Function Number: 274
is_valid_player(param_00)
{
	if(!isplayer(self))
	{
		return 0;
	}

	if(!isdefined(self))
	{
		return 0;
	}

	if(!isdefined(param_00) && scripts\cp\cp_laststand::player_in_laststand(self))
	{
		return 0;
	}

	if(!isalive(self))
	{
		return 0;
	}

	if(self.sessionstate == "spectator")
	{
		return 0;
	}

	return 1;
}

//Function Number: 275
any_player_nearby(param_00,param_01)
{
	foreach(var_03 in level.players)
	{
		if(distancesquared(var_03.origin,param_00) < param_01)
		{
			return 1;
		}
	}

	return 0;
}

//Function Number: 276
timeoutvofunction_pain(param_00,param_01)
{
	wait(param_01);
	level notify(param_00 + "_timed_out");
}

//Function Number: 277
player_pain_vo(param_00)
{
	self endon("disconnect");
	level endon("pain_vo_timed_out");
	level thread timeoutvofunction_pain("pain_vo",3.5);
	var_01 = 5500;
	var_02 = gettime();
	if(!isdefined(self.next_pain_vo_time))
	{
		self.next_pain_vo_time = var_02 + randomintrange(var_01,var_01 + 2000);
	}
	else if(var_02 < self.next_pain_vo_time)
	{
		return;
	}

	while(scripts\cp\cp_music_and_dialog::vo_is_playing())
	{
		wait(0.1);
	}

	if(isdefined(self.vo_prefix))
	{
		if(soundexists(self.vo_prefix + "plr_pain"))
		{
			self playlocalsound(self.vo_prefix + "plr_pain");
		}
		else if(soundexists(self.vo_prefix + "pain"))
		{
			self playlocalsound(self.vo_prefix + "pain");
		}
	}

	var_03 = "injured_pain_vocal";
	if(isdefined(param_00))
	{
		if(isdefined(param_00.agent_type))
		{
			switch(param_00.agent_type)
			{
				case "crab_mini":
					var_03 = "injured_pain_crabgoon";
					break;

				case "crab_brute":
					var_03 = "injured_pain_radactivecrab";
					break;

				case "crab_boss":
					var_03 = "injured_pain_radboss";
					break;

				case "skater":
					var_03 = "injured_pain_skater";
					break;

				case "ratking":
					var_03 = scripts\engine\utility::random(["injured_pain_ratking1","injured_pain_ratking2","injured_pain_ratking3"]);
					break;

				case "zombie_clown":
					var_03 = "injured_pain_clown";
					break;

				case "alien_rhino":
					var_03 = scripts\engine\utility::random(["injured_pain_rhino1","injured_pain_rhino2","injured_pain_rhino3"]);
					break;

				case "alien_phantom":
				case "alien_goon":
					var_03 = "injured_pain_crytpid";
					break;

				default:
					var_03 = "injured_pain_vocal";
					break;
			}
		}
	}

	if(self.vo_prefix == "p6_" && var_03 == "injured_pain_clown")
	{
		scripts\cp\cp_vo::try_to_play_vo(var_03,"zmb_comment_vo");
	}
	else
	{
		scripts\cp\cp_vo::try_to_play_vo(var_03,"zmb_comment_vo");
	}

	self.next_pain_vo_time = var_02 + randomintrange(var_01,var_01 + 1500);
}

//Function Number: 278
player_pain_breathing_sfx()
{
	level endon("game_ended");
	self endon("disconnect");
	if(is_playing_pain_breathing_sfx(self))
	{
		return;
	}

	if(above_pain_breathing_sfx_threshold(self))
	{
		return;
	}

	set_is_playing_pain_breathing_sfx(self,1);
	var_00 = get_pain_breathing_sfx_alias(self);
	if(isdefined(var_00))
	{
		if(soundexists(var_00))
		{
			while(!above_pain_breathing_sfx_threshold(self) && !level.gameended)
			{
				if(!scripts\engine\utility::istrue(self.vo_system_playing_vo))
				{
					self playlocalsound(var_00);
				}

				wait(1.5);
			}
		}

		set_is_playing_pain_breathing_sfx(self,0);
	}
}

//Function Number: 279
is_playing_pain_breathing_sfx(param_00)
{
	return scripts\engine\utility::istrue(param_00.is_playing_pain_breathing_sfx);
}

//Function Number: 280
above_pain_breathing_sfx_threshold(param_00)
{
	var_01 = 0.3;
	return param_00.health / param_00.maxhealth > var_01;
}

//Function Number: 281
set_is_playing_pain_breathing_sfx(param_00,param_01)
{
	param_00.is_playing_pain_breathing_sfx = param_01;
}

//Function Number: 282
get_pain_breathing_sfx_alias(param_00)
{
	if(!level.gameended)
	{
		if(param_00.vo_prefix == "p1_")
		{
			return "p1_plr_pain";
		}

		if(param_00.vo_prefix == "p2_")
		{
			return "p2_plr_pain";
		}

		if(param_00.vo_prefix == "p3_")
		{
			return "p3_plr_pain";
		}

		if(param_00.vo_prefix == "p4_")
		{
			return "p4_plr_pain";
		}

		if(param_00.vo_prefix == "p5_")
		{
			return "p5_plr_pain";
		}

		if(param_00.vo_prefix == "p6_")
		{
			return "p5_plr_pain";
		}

		return "p3_plr_pain";
	}
}

//Function Number: 283
pointvscone(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07)
{
	var_08 = param_00 - param_01;
	var_09 = vectordot(var_08,param_02);
	var_0A = vectordot(var_08,param_03);
	if(var_09 > param_04)
	{
		return 0;
	}

	if(var_09 < param_05)
	{
		return 0;
	}

	if(isdefined(param_07))
	{
		if(abs(var_0A) > param_07)
		{
			return 0;
		}
	}

	if(scripts\engine\utility::anglebetweenvectors(param_02,var_08) > param_06)
	{
		return 0;
	}

	return 1;
}

//Function Number: 284
playvoforpillage(param_00)
{
	var_01 = param_00.vo_prefix + "good_loot";
	if(scripts\cp\cp_vo::alias_2d_version_exists(param_00,var_01))
	{
		param_00 playlocalsound(scripts\cp\cp_vo::get_alias_2d_version(param_00,var_01));
		return;
	}

	if(soundexists(var_01))
	{
		param_00 playlocalsound(var_01);
	}
}

//Function Number: 285
deployable_box_onuse_message(param_00)
{
	var_01 = "";
	if(isdefined(param_00) && isdefined(param_00.boxtype) && isdefined(level.boxsettings[param_00.boxtype].eventstring))
	{
		var_01 = level.boxsettings[param_00.boxtype].eventstring;
	}

	thread setlowermessage("deployable_use",var_01,3);
}

//Function Number: 286
is_goon(param_00)
{
	switch(param_00)
	{
		case "goon4":
		case "goon3":
		case "goon2":
		case "goon":
			return 1;

		default:
			return 0;
	}
}

//Function Number: 287
mark_dangerous_nodes(param_00,param_01,param_02)
{
	function_0139(param_00,param_01,1);
	wait(param_02);
	function_0139(param_00,param_01,0);
}

//Function Number: 288
healthregeninit(param_00)
{
	level.healthregendisabled = param_00;
}

//Function Number: 289
alien_health_per_player_init()
{
	level.alien_health_per_player_scalar = [];
	level.alien_health_per_player_scalar[1] = 0.9;
	level.alien_health_per_player_scalar[2] = 1;
	level.alien_health_per_player_scalar[3] = 1.3;
	level.alien_health_per_player_scalar[4] = 1.8;
}

//Function Number: 290
playerhealthregen()
{
	self endon("death");
	self endon("disconnect");
	self endon("joined_team");
	self endon("joined_spectators");
	self endon("faux_spawn");
	level endon("game_ended");
	for(;;)
	{
		scripts\engine\utility::waittill_any_3("damage","health_perk_upgrade");
		if(!canregenhealth())
		{
			continue;
		}

		var_00 = scripts\cp\cp_laststand::gethealthcap();
		var_01 = self.health / var_00;
		if(var_01 >= 1)
		{
			self.health = var_00;
			continue;
		}

		thread healthregen(gettime(),var_01);
		thread breathingmanager(gettime(),var_01);
	}
}

//Function Number: 291
healthregen(param_00,param_01)
{
	self notify("healthRegeneration");
	self endon("healthRegeneration");
	self endon("death");
	self endon("disconnect");
	self endon("joined_team");
	self endon("joined_spectators");
	level endon("game_ended");
	while(isdefined(self.selfdamaging) && self.selfdamaging)
	{
		wait(0.2);
	}

	if(ishealthregendisabled())
	{
		return;
	}

	var_02 = spawnstruct();
	getregendata(var_02);
	scripts\engine\utility::waittill_any_timeout_1(var_02.activatetime,"force_regeneration");
	for(;;)
	{
		var_03 = scripts\cp\cp_laststand::gethealthcap();
		var_02 = spawnstruct();
		getregendata(var_02);
		if(!scripts/cp/perks/perkfunctions::has_fragile_relic_and_is_sprinting())
		{
			param_01 = self.health / self.maxhealth;
			if(self.health < int(var_03))
			{
				if(param_01 + var_02.regenamount > int(1))
				{
					self.health = int(var_03);
				}
				else
				{
					self.health = int(self.maxhealth * param_01 + var_02.regenamount);
				}
			}
			else
			{
				break;
			}
		}

		scripts\engine\utility::waittill_any_timeout_1(var_02.waittimebetweenregen,"force_regeneration");
	}

	self notify("healed");
	scripts\cp\cp_globallogic::player_init_invulnerability();
	resetattackerlist();
}

//Function Number: 292
breathingmanager(param_00,param_01)
{
	self notify("breathingManager");
	self endon("breathingManager");
	self endon("death");
	self endon("disconnect");
	self endon("joined_team");
	self endon("joined_spectators");
	level endon("game_ended");
	if(isusingremote())
	{
		return;
	}

	if(!isplayer(self))
	{
		return;
	}

	self.breathingstoptime = param_00 + 6000 * self.regenspeed;
	wait(6 * self.regenspeed);
	if(!level.gameended)
	{
		if(self.vo_prefix == "p1_")
		{
			if(!scripts\engine\utility::istrue(self.vo_system_playing_vo))
			{
				self playlocalsound("p1_breathing_better");
				return;
			}

			return;
		}

		if(self.vo_prefix == "p2_")
		{
			if(!scripts\engine\utility::istrue(self.vo_system_playing_vo))
			{
				self playlocalsound("p2_breathing_better");
				return;
			}

			return;
		}

		if(self.vo_prefix == "p3_")
		{
			if(!scripts\engine\utility::istrue(self.vo_system_playing_vo))
			{
				self playlocalsound("p3_breathing_better");
				return;
			}

			return;
		}

		if(self.vo_prefix == "p4_")
		{
			if(!scripts\engine\utility::istrue(self.vo_system_playing_vo))
			{
				self playlocalsound("p4_breathing_better");
				return;
			}

			return;
		}

		if(self.vo_prefix == "p5_")
		{
			if(!scripts\engine\utility::istrue(self.vo_system_playing_vo))
			{
				self playlocalsound("p5_breathing_better");
				return;
			}

			return;
		}

		if(self.vo_prefix == "p6_")
		{
			if(!scripts\engine\utility::istrue(self.vo_system_playing_vo))
			{
				self playlocalsound("p5_breathing_better");
				return;
			}

			return;
		}

		if(!scripts\engine\utility::istrue(self.vo_system_playing_vo))
		{
			self playlocalsound("p3_breathing_better");
			return;
		}

		return;
	}
}

//Function Number: 293
getregendata(param_00)
{
	level.longregentime = 5000;
	level.healthoverlaycutoff = 0.2;
	level.invultime_preshield = 0.35;
	level.invultime_onshield = 0.5;
	level.invultime_postshield = 0.3;
	level.playerhealth_regularregendelay = 2400;
	level.worthydamageratio = 0.1;
	self.prestigehealthregennerfscalar = scripts/cp/perks/prestige::prestige_getslowhealthregenscalar();
	if(self.prestigehealthregennerfscalar == 1)
	{
		if(is_consumable_active("faster_health_regen_upgrade") || isdefined(level.purify_active) && level.purify_active >= 1)
		{
			param_00.activatetime = 0.45;
			param_00.waittimebetweenregen = 0.045;
			param_00.regenamount = 0.1;
			return;
		}

		if(self.health <= 45)
		{
			param_00.activatetime = 5;
			param_00.waittimebetweenregen = 0.05;
			param_00.regenamount = 0.1;
			return;
		}

		param_00.activatetime = 2.4;
		param_00.waittimebetweenregen = 0.1;
		param_00.regenamount = 0.1;
		return;
	}

	param_00.activatetime = 2.4 * self.prestigehealthregennerfscalar;
	param_00.waittimebetweenregen = 0.1 * self.prestigehealthregennerfscalar;
	param_00.regenamount = 0.1;
}

//Function Number: 294
resetattackerlist(param_00)
{
	self endon("disconnect");
	self endon("death");
	level endon("game_ended");
	wait(1.75);
	resetattackerlist_internal();
}

//Function Number: 295
resetattackerlist_internal()
{
	self.attackers = [];
	self.attackerdata = [];
}

//Function Number: 296
canregenhealth()
{
	if(scripts\cp\cp_laststand::player_in_laststand(self))
	{
		return 0;
	}

	return 1;
}

//Function Number: 297
playerpainbreathingsound()
{
	level endon("game_ended");
	self endon("death");
	self endon("disconnect");
	self endon("joined_team");
	self endon("joined_spectators");
	wait(2);
	for(;;)
	{
		wait(0.2);
		if(shouldplaypainbreathingsound())
		{
			if(self.vo_prefix == "p1_")
			{
				if(soundexists("Fem_breathing_hurt"))
				{
					self playlocalsound("Fem_breathing_hurt");
				}
			}
			else
			{
				self playlocalsound("breathing_hurt");
			}

			wait(0.784);
			wait(0.1 + randomfloat(0.8));
		}
	}
}

//Function Number: 298
shouldplaypainbreathingsound()
{
	if(ishealthregendisabled() || isusingremote() || isdefined(self.breathingstoptime) && gettime() < self.breathingstoptime || self.health > self.maxhealth * 0.55 || level.gameended)
	{
		return 0;
	}

	return 1;
}

//Function Number: 299
ishealthregendisabled()
{
	return (isdefined(level.healthregendisabled) && level.healthregendisabled) || isdefined(self.healthregendisabled) && self.healthregendisabled;
}

//Function Number: 300
playerarmor()
{
	self endon("death");
	self endon("disconnect");
	self endon("joined_team");
	self endon("joined_spectators");
	self endon("faux_spawn");
	self endon("game_ended");
	if(!isdefined(self.bodyarmorhp))
	{
		self.bodyarmorhp = 0;
	}

	self setplayerdata("cp","alienSession","armor",0);
	var_00 = 0;
	for(;;)
	{
		scripts\engine\utility::waittill_any_3("player_damaged","enable_armor");
		if(!isdefined(self.bodyarmorhp))
		{
			if(var_00 > 0)
			{
				self setplayerdata("cp","alienSession","armor",0);
				var_00 = 0;
			}

			continue;
		}

		if(var_00 != self.bodyarmorhp)
		{
			var_01 = int(self.bodyarmorhp);
			self setplayerdata("cp","alienSession","armor",var_01);
			var_00 = self.bodyarmorhp;
		}
	}
}

//Function Number: 301
allow_secondary_offhand_weapons(param_00)
{
	if(param_00)
	{
		if(!isdefined(self.disabledsecondaryoffhandweapons))
		{
			self.disabledsecondaryoffhandweapons = 0;
		}

		self.var_55DF--;
		if(!self.disabledsecondaryoffhandweapons)
		{
			self enableoffhandsecondaryweapons();
			return;
		}

		return;
	}

	if(!isdefined(self.disabledsecondaryoffhandweapons))
	{
		self.disabledsecondaryoffhandweapons = 0;
	}

	self.var_55DF++;
	self disableoffhandsecondaryweapons();
}

//Function Number: 302
register_physics_collisions()
{
	self endon("death");
	self endon("stop_phys_sounds");
	for(;;)
	{
		self waittill("collision",var_00,var_01,var_02,var_03,var_04,var_05,var_06,var_07);
		level notify("physSnd",self,var_00,var_01,var_02,var_03,var_04,var_05,var_06,var_07);
	}
}

//Function Number: 303
global_physics_sound_monitor()
{
	level notify("physics_monitor");
	level endon("physics_monitor");
	for(;;)
	{
		level waittill("physSnd",var_00,var_01,var_02,var_03,var_04,var_05,var_06,var_07,var_08);
		if(isdefined(var_00) && isdefined(var_00.phys_sound_func))
		{
			level thread [[ var_00.phys_sound_func ]](var_00,var_01,var_02,var_03,var_04,var_05,var_06,var_07,var_08);
		}
	}
}

//Function Number: 304
register_physics_collision_func(param_00,param_01)
{
	param_00.phys_sound_func = param_01;
}

//Function Number: 305
addtotraplist()
{
	if(!scripts\engine\utility::array_contains(level.placed_crafted_traps,self))
	{
		level.placed_crafted_traps = scripts\engine\utility::array_add_safe(level.placed_crafted_traps,self);
	}

	level.placed_crafted_traps = scripts\engine\utility::array_removeundefined(level.placed_crafted_traps);
}

//Function Number: 306
removefromtraplist()
{
	if(scripts\engine\utility::array_contains(level.placed_crafted_traps,self))
	{
		level.placed_crafted_traps = scripts\engine\utility::array_remove(level.placed_crafted_traps,self);
	}

	level.placed_crafted_traps = scripts\engine\utility::array_removeundefined(level.placed_crafted_traps);
}

//Function Number: 307
ent_is_near_equipment(param_00)
{
	var_01 = 16384;
	if(level.turrets.size)
	{
		var_02 = sortbydistance(level.turrets,param_00.origin);
		if(distance2dsquared(var_02[0].origin,param_00.origin) < var_01)
		{
			return 1;
		}
	}

	if(isdefined(level.placed_crafted_traps) && level.placed_crafted_traps.size)
	{
		foreach(var_04 in level.placed_crafted_traps)
		{
			if(!isdefined(var_04))
			{
				continue;
			}

			if(distance2dsquared(var_04.origin,param_00.origin) < var_01)
			{
				return 1;
			}
		}
	}

	if(isdefined(level.near_equipment_func))
	{
		return [[ level.near_equipment_func ]](param_00);
	}

	return 0;
}

//Function Number: 308
set_crafted_inventory_item(param_00,param_01,param_02)
{
	if(isdefined(param_02.current_crafted_inventory))
	{
		param_02.current_crafted_inventory = undefined;
	}

	param_02.current_crafted_inventory = spawnstruct();
	param_02.current_crafted_inventory.randomintrange = param_00;
	param_02.current_crafted_inventory.restore_func = param_01;
}

//Function Number: 309
remove_crafted_item_from_inventory(param_00)
{
	param_00 setclientomnvar("zom_crafted_weapon",0);
	param_00.current_crafted_inventory = undefined;
}

//Function Number: 310
is_escape_gametype()
{
	return level.gametype == "escape";
}

//Function Number: 311
item_handleownerdisconnect(param_00)
{
	self endon("death");
	level endon("game_ended");
	self notify(param_00);
	self endon(param_00);
	self.triggerportableradarping waittill("disconnect");
	foreach(var_02 in level.players)
	{
		if(var_02 is_valid_player(1))
		{
			self.triggerportableradarping = var_02;
			if(self.classname != "script_model")
			{
				self setsentryowner(self.triggerportableradarping);
			}

			break;
		}
	}

	thread item_handleownerdisconnect(param_00);
}

//Function Number: 312
restore_player_perk()
{
	if(isdefined(self.restoreperk))
	{
		giveperk(self.restoreperk);
		self.restoreperk = undefined;
	}
}

//Function Number: 313
wait_restore_player_perk()
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	wait(0.05);
	restore_player_perk();
}

//Function Number: 314
remove_player_perks()
{
	if(_hasperk("specialty_explosivebullets"))
	{
		self.restoreperk = "specialty_explosivebullets";
		_unsetperk("specialty_explosivebullets");
	}
}

//Function Number: 315
item_timeout(param_00,param_01,param_02)
{
	self endon("death");
	level endon("game_ended");
	if(!isdefined(self.lifespan))
	{
		self.lifespan = param_01;
	}

	if(isdefined(param_00))
	{
		self.lifespan = param_00;
	}

	while(self.lifespan)
	{
		wait(1);
		scripts\cp\cp_hostmigration::waittillhostmigrationdone();
		if(!isdefined(self.carriedby))
		{
			self.lifespan = max(0,self.lifespan - 1);
		}
	}

	while(isdefined(self) && isdefined(self.inuseby))
	{
		wait(0.05);
	}

	if(isdefined(self.zap_model))
	{
		self.zap_model delete();
	}

	if(isdefined(param_02))
	{
		self notify(param_02);
		return;
	}

	self notify("death");
}

//Function Number: 316
item_oncarrierdeath(param_00)
{
	self endon("placed");
	self endon("death");
	param_00 endon("disconnect");
	var_01 = param_00 scripts\engine\utility::waittill_any_return("death","last_stand");
	param_00 notify("force_cancel_placement");
}

//Function Number: 317
item_oncarrierdisconnect(param_00)
{
	self endon("placed");
	self endon("death");
	param_00 endon("last_stand");
	param_00 waittill("disconnect");
	if(isdefined(self.carriedgascan))
	{
		self.carriedgascan delete();
	}
	else if(isdefined(self.carriedmedusa))
	{
		self.carriedmedusa delete();
	}
	else if(isdefined(self.carried_trap))
	{
		self.carried_trap delete();
	}
	else if(isdefined(self.carriedboombox))
	{
		self.carriedboombox delete();
	}
	else if(isdefined(self.carried_fireworks_trap))
	{
		self.carried_fireworks_trap delete();
	}
	else if(isdefined(self.carriedrevocator))
	{
		self.carriedrevocator delete();
	}

	self delete();
}

//Function Number: 318
item_ongameended(param_00)
{
	self endon("placed");
	self endon("death");
	param_00 endon("last_stand");
	level waittill("game_ended");
	self delete();
}

//Function Number: 319
should_be_affected_by_trap(param_00,param_01,param_02)
{
	if(!isdefined(param_00))
	{
		return 0;
	}

	if(!isalive(param_00))
	{
		return 0;
	}

	if(!isagent(param_00))
	{
		return 0;
	}

	if(!isdefined(param_00.agent_type))
	{
		return 0;
	}

	if(!isdefined(param_00.isactive) || !param_00.isactive)
	{
		return 0;
	}

	if(!isdefined(param_01) && isdefined(param_00.entered_playspace) && !param_00.entered_playspace)
	{
		return 0;
	}

	if(scripts\engine\utility::istrue(param_00.marked_for_death))
	{
		return 0;
	}

	if(!isdefined(param_00.team))
	{
		return 0;
	}

	if(param_00.agent_type == "zombie_brute" || param_00.agent_type == "zombie_ghost" || param_00.agent_type == "zombie_grey")
	{
		return 0;
	}

	if(param_00.agent_type == "alien_phantom" || param_00.agent_type == "alien_rhino")
	{
		return 0;
	}

	if(!scripts\engine\utility::istrue(param_02) && scripts\engine\utility::istrue(param_00.is_suicide_bomber))
	{
		return 0;
	}

	if(scripts\engine\utility::istrue(param_00.is_coaster_zombie))
	{
		return 0;
	}

	return 1;
}

//Function Number: 320
set_quest_icon(param_00)
{
	increment_num_of_quest_piece_completed();
	set_quest_icon_internal(param_00);
}

//Function Number: 321
set_quest_icon_internal(param_00)
{
	setomnvarbit("zombie_quest_piece",param_00,1);
	setclientmatchdata("questPieces","quest_piece_" + param_00,1);
}

//Function Number: 322
unset_zm_quest_icon(param_00)
{
	unset_quest_icon_internal(param_00);
}

//Function Number: 323
unset_quest_icon_internal(param_00)
{
	setomnvarbit("zombie_quest_piece",param_00,0);
}

//Function Number: 324
set_completed_quest_mark(param_00)
{
	setomnvarbit("zm_completed_quest_marks",param_00,1);
}

//Function Number: 325
increment_num_of_quest_piece_completed()
{
	if(!isdefined(level.num_of_quest_pieces_completed))
	{
		level.num_of_quest_pieces_completed = 0;
	}

	level.num_of_quest_pieces_completed++;
	if(level.script == "cp_zmb")
	{
		if(level.num_of_quest_pieces_completed == level.cp_zmb_number_of_quest_pieces)
		{
			foreach(var_01 in level.players)
			{
				var_01 scripts/cp/zombies/achievement::update_achievement("STICKER_COLLECTOR",24);
			}
		}
	}
}

//Function Number: 326
playplayerandnpcsounds(param_00,param_01,param_02)
{
	param_00 playlocalsound(param_01);
	param_00 playsoundtoteam(param_02,"allies",param_00);
	param_00 playsoundtoteam(param_02,"axis",param_00);
}

//Function Number: 327
roundup(param_00)
{
	if(param_00 - int(param_00) >= 0.5)
	{
		return int(param_00 + 1);
	}

	return int(param_00);
}

//Function Number: 328
damage_over_time(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08)
{
	if(!should_apply_dot(param_00))
	{
		return;
	}

	param_00 endon("death");
	if(!isdefined(param_03))
	{
		param_03 = 600;
	}

	if(!isdefined(param_02))
	{
		param_02 = 5;
	}

	if(!isdefined(param_04))
	{
		param_04 = "MOD_UNKNOWN";
	}

	if(!isdefined(param_05))
	{
		param_05 = "iw7_dot_zm";
	}

	if(isdefined(param_07))
	{
		param_00 setscriptablestateflag(param_00,param_07,1);
		if(isdefined(level.scriptablestatefunc))
		{
			param_00 thread [[ level.scriptablestatefunc ]](param_00);
		}
	}

	var_09 = 0;
	var_0A = 6;
	var_0B = param_02 / var_0A;
	var_0C = param_03 / var_0A;
	for(var_0D = 0;var_0D < var_0A;var_0D++)
	{
		wait(var_0B);
		if(isalive(param_00))
		{
			param_00.flame_damage_time = gettime() + 500;
			if(param_00.health - var_0C <= 0)
			{
				if(isdefined(param_08))
				{
					level notify(param_08);
				}
			}

			if(isdefined(param_01))
			{
				param_00 dodamage(var_0C,param_00.origin,param_01,param_01,param_04,param_05);
				continue;
			}

			param_00 dodamage(var_0C,param_00.origin,undefined,undefined,param_04,param_05);
		}
	}

	if(isdefined(param_07))
	{
		param_00 setscriptablestateflag(param_00,param_07);
	}

	if(scripts\engine\utility::istrue(param_00.marked_for_death))
	{
		param_00.marked_for_death = undefined;
	}

	if(scripts\engine\utility::istrue(param_00.flame_damage_time))
	{
		param_00.flame_damage_time = undefined;
	}
}

//Function Number: 329
setscriptablestateflag(param_00,param_01,param_02)
{
	switch(param_01)
	{
		case "combinedArcane":
		case "combinedarcane":
			if(scripts\engine\utility::istrue(param_02))
			{
				param_00.is_afflicted = 1;
			}
			else
			{
				param_00.is_afflicted = undefined;
			}
			break;

		case "burning":
			if(scripts\engine\utility::istrue(param_02))
			{
				param_00.is_burning = param_02;
			}
			else
			{
				param_00.is_burning = undefined;
			}
			break;

		case "electrified":
			if(scripts\engine\utility::istrue(param_02))
			{
				param_00.is_electrified = param_02;
				param_00.allowpain = 1;
				param_00.stun_hit_time = gettime() + 3000;
			}
			else
			{
				param_00.is_electrified = undefined;
				param_00.allowpain = 0;
			}
			break;

		case "shocked":
			if(scripts\engine\utility::istrue(param_02))
			{
				param_00.stunned = param_02;
			}
			else
			{
				param_00.stunned = undefined;
			}
			break;

		case "chemBurn":
		case "chemburn":
			if(scripts\engine\utility::istrue(param_02))
			{
				param_00.is_chem_burning = 1;
			}
			else
			{
				param_00.is_chem_burning = undefined;
			}
			break;

		default:
			break;
	}
}

//Function Number: 330
should_apply_dot(param_00)
{
	if(isdefined(param_00.agent_type) && param_00.agent_type == "c6" || param_00.agent_type == "zombie_brute" || param_00.agent_type == "zombie_grey" || param_00.agent_type == "zombie_ghost")
	{
		return 0;
	}

	return 1;
}

//Function Number: 331
update_trap_placement_internal(param_00,param_01,param_02,param_03,param_04)
{
	self endon("death");
	self endon("force_cancel_placement");
	self endon("disconnect");
	level endon("game_ended");
	var_05 = param_02.carriedtrapoffset;
	var_06 = param_02.carriedtrapangles;
	var_07 = param_02.placementradius;
	var_08 = param_02.placementheighttolerance;
	var_09 = param_02.modelplacement;
	var_0A = param_02.modelplacementfailed;
	var_0B = param_02.placecancelablestring;
	var_0C = param_02.placestring;
	var_0D = param_02.cannotplacestring;
	param_00 endon("placed");
	param_00 endon("death");
	param_00.canbeplaced = 1;
	var_0E = -1;
	for(;;)
	{
		var_0F = self canplayerplacesentry(1,var_07);
		param_00.origin = var_0F["origin"];
		param_00.angles = var_0F["angles"];
		param_01.origin = param_00.origin + var_05;
		param_01.angles = param_00.angles + var_06;
		if(isdefined(self.onslide))
		{
			param_00.canbeplaced = 0;
		}
		else
		{
			param_00.canbeplaced = self isonground() && var_0F["result"] && abs(param_00.origin[2] - self.origin[2]) < var_08;
		}

		if(ent_is_near_equipment(param_00))
		{
			param_00.canbeplaced = 0;
		}

		if(isdefined(param_03) && isdefined(level.discotrap_active) && isdefined(level.dance_floor_volume))
		{
			if(param_00 istouching(level.dance_floor_volume))
			{
				param_00.canbeplaced = 0;
			}
		}

		if(isdefined(var_0F["entity"]))
		{
			param_00.moving_platform = var_0F["entity"];
		}
		else
		{
			param_00.moving_platform = undefined;
		}

		if(param_00.canbeplaced != var_0E)
		{
			if(param_00.canbeplaced)
			{
				if(!isdefined(param_04))
				{
					param_01 setmodel(var_09);
				}

				if(isdefined(param_00.firstplacement))
				{
					self forceusehinton(var_0B);
				}
				else
				{
					self forceusehinton(var_0C);
				}
			}
			else
			{
				if(!isdefined(param_04))
				{
					param_01 setmodel(var_0A);
				}

				self forceusehinton(var_0D);
			}
		}

		var_0E = param_00.canbeplaced;
		wait(0.05);
	}
}

//Function Number: 332
usegrenadegesture(param_00,param_01)
{
	if(param_00 cangiveandfireoffhand(param_00 getvalidtakeweapon()) && !param_00 isgestureplaying())
	{
		param_00 setweaponammostock(param_01,1);
		param_00 giveandfireoffhand(param_01);
	}
}

//Function Number: 333
is_codxp()
{
	return getdvar("scr_codxp","") != "";
}

//Function Number: 334
too_close_to_other_interactions(param_00)
{
	var_01 = sortbydistance(level.current_interaction_structs,param_00);
	if(distancesquared(var_01[0].origin,param_00) < 9216)
	{
		return 1;
	}

	return 0;
}

//Function Number: 335
getweapontoswitchbackto()
{
	if(isdefined(self.last_weapon))
	{
		var_00 = self.last_weapon;
	}
	else
	{
		var_00 = self getcurrentweapon();
	}

	var_01 = 0;
	var_02 = level.additional_laststand_weapon_exclusion;
	if(var_00 == "none")
	{
		var_01 = 1;
	}
	else if(scripts\engine\utility::array_contains(var_02,var_00))
	{
		var_01 = 1;
	}
	else if(scripts\engine\utility::array_contains(var_02,getweaponbasename(var_00)))
	{
		var_01 = 1;
	}
	else if(is_melee_weapon(var_00,1) || isdefined(level.primary_melee_weapons) && scripts\engine\utility::array_contains(level.primary_melee_weapons,var_00))
	{
		var_01 = 1;
	}

	if(var_01)
	{
		var_03 = self getweaponslistall();
		for(var_04 = 0;var_04 < var_03.size;var_04++)
		{
			if(var_03[var_04] == "none")
			{
				continue;
			}
			else if(scripts\engine\utility::array_contains(var_02,var_03[var_04]))
			{
				continue;
			}
			else if(scripts\engine\utility::array_contains(var_02,getweaponbasename(var_03[var_04])))
			{
				continue;
			}
			else if(is_melee_weapon(var_03[var_04],1) || isdefined(level.primary_melee_weapons) && scripts\engine\utility::array_contains(level.primary_melee_weapons,var_03[var_04]))
			{
				continue;
			}
			else if(!scripts\cp\cp_weapon::isprimaryweapon(var_03[var_04]))
			{
				continue;
			}
			else
			{
				var_01 = 0;
				var_00 = var_03[var_04];
				break;
			}
		}
	}

	if(var_01)
	{
		var_00 = "iw7_fists_zm";
		if(!self hasweapon(var_00))
		{
			_giveweapon(var_00,undefined,undefined,1);
		}
	}

	return var_00;
}

//Function Number: 336
getvalidtakeweapon(param_00)
{
	var_01 = self getcurrentweapon();
	var_02 = 0;
	var_03 = level.additional_laststand_weapon_exclusion;
	if(isdefined(param_00))
	{
		var_03 = scripts\engine\utility::array_combine(param_00,var_03);
	}

	if(var_01 == "none")
	{
		var_02 = 1;
	}
	else if(scripts\engine\utility::array_contains(var_03,var_01))
	{
		var_02 = 1;
	}
	else if(scripts\engine\utility::array_contains(var_03,getweaponbasename(var_01)))
	{
		var_02 = 1;
	}
	else if(is_melee_weapon(var_01,1))
	{
		var_02 = 1;
	}

	if(isdefined(self.last_valid_weapon) && self hasweapon(self.last_valid_weapon) && var_02)
	{
		var_01 = self.last_valid_weapon;
		if(var_01 == "none")
		{
			var_02 = 1;
		}
		else if(scripts\engine\utility::array_contains(var_03,var_01))
		{
			var_02 = 1;
		}
		else if(scripts\engine\utility::array_contains(var_03,getweaponbasename(var_01)))
		{
			var_02 = 1;
		}
		else if(is_melee_weapon(var_01,1))
		{
			var_02 = 1;
		}
		else
		{
			var_02 = 0;
		}
	}

	if(var_02)
	{
		var_04 = self getweaponslistall();
		for(var_05 = 0;var_05 < var_04.size;var_05++)
		{
			if(var_04[var_05] == "none")
			{
				continue;
			}
			else if(scripts\engine\utility::array_contains(var_03,var_04[var_05]))
			{
				continue;
			}
			else if(scripts\engine\utility::array_contains(var_03,getweaponbasename(var_04[var_05])))
			{
				continue;
			}
			else if(is_melee_weapon(var_04[var_05],1))
			{
				continue;
			}
			else
			{
				var_02 = 0;
				var_01 = var_04[var_05];
				break;
			}
		}
	}

	return var_01;
}

//Function Number: 337
getcurrentcamoname(param_00)
{
	var_01 = function_00E5(param_00);
	if(!isdefined(var_01))
	{
		return undefined;
	}

	switch(var_01)
	{
		case "camo0":
			return "camo00";

		case "camo1":
			return "camo01";

		case "camo2":
			return "camo02";

		case "camo3":
			return "camo03";

		case "camo4":
			return "camo04";

		case "camo5":
			return "camo05";

		case "camo6":
			return "camo06";

		case "camo7":
			return "camo07";

		case "camo8":
			return "camo08";

		case "camo9":
			return "camo09";

		default:
			return var_01;
	}

	return undefined;
}

//Function Number: 338
add_to_notify_queue(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08)
{
	if(!isdefined(self.notify_queue))
	{
		self.notify_queue = [];
	}

	if(!isdefined(self.notify_queue[param_00]))
	{
		self.notify_queue[param_00] = 0;
	}
	else
	{
		if(param_00 == "weapon_hit_enemy")
		{
			var_09 = gettime();
			if(isdefined(self.last_notify_time) && self.last_notify_time == var_09)
			{
				return;
			}
			else
			{
				self.last_notify_time = var_09;
			}
		}

		self.notify_queue[param_00]++;
	}

	if(self.notify_queue[param_00] > 0)
	{
		wait(0.05 * self.notify_queue[param_00]);
	}

	self notify(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08);
	waittillframeend;
	if(isdefined(self.notify_queue[param_00]))
	{
		self.notify_queue[param_00]--;
		if(self.notify_queue[param_00] < 1)
		{
			self.notify_queue[param_00] = undefined;
		}
	}
}

//Function Number: 339
take_fists_weapon(param_00)
{
	foreach(var_02 in param_00 getweaponslistall())
	{
		if(issubstr(var_02,"iw7_fists"))
		{
			param_00 takeweapon(var_02);
		}
	}
}

//Function Number: 340
playlocalsound_safe(param_00)
{
	if(soundexists(param_00))
	{
		self playlocalsound(param_00);
	}
}

//Function Number: 341
stoplocalsound_safe(param_00)
{
	if(soundexists(param_00))
	{
		self stoplocalsound(param_00);
	}
}

//Function Number: 342
playsoundatpos_safe(param_00,param_01)
{
	if(soundexists(param_01))
	{
		playsoundatpos(param_00,param_01);
	}
}

//Function Number: 343
agentcantbeignored()
{
	return isdefined(self.agent_type) && isdefined(level.ignoreimmune) && scripts\engine\utility::array_contains(level.ignoreimmune,self.agent_type);
}

//Function Number: 344
agentisfnfimmune()
{
	return isdefined(self.agent_type) && isdefined(level.fnfimmune) && scripts\engine\utility::array_contains(level.fnfimmune,self.agent_type);
}

//Function Number: 345
agentisinstakillimmune()
{
	return isdefined(self.agent_type) && isdefined(level.instakillimmune) && scripts\engine\utility::array_contains(level.instakillimmune,self.agent_type);
}

//Function Number: 346
agentisspecialzombie()
{
	return isdefined(self.agent_type) && isdefined(level.specialzombie) && scripts\engine\utility::array_contains(level.specialzombie,self.agent_type);
}

//Function Number: 347
firegesturegrenade(param_00,param_01)
{
	var_02 = param_00 getcurrentweapon();
	if(cangiveandfireoffhand(var_02))
	{
		param_00 setweaponammostock(param_01,1);
		param_00 giveandfireoffhand(param_01);
	}
}

//Function Number: 348
cangiveandfireoffhand(param_00)
{
	if(!isdefined(param_00))
	{
		return 1;
	}

	if(isdefined(level.invalid_gesture_weapon))
	{
		if(isdefined(level.invalid_gesture_weapon[getweaponbasename(param_00)]))
		{
			return 0;
		}

		return 1;
	}

	return 1;
}

//Function Number: 349
play_interaction_gesture(param_00)
{
	if(!isdefined(param_00))
	{
		param_00 = "iw7_powerlever_zm";
	}

	if(getweaponbasename(self getcurrentweapon()) != "iw7_penetrationrail_mp")
	{
		thread firegesturegrenade(self,param_00);
	}
}

//Function Number: 350
deactivatebrushmodel(param_00,param_01)
{
	param_00 notsolid();
	if(scripts\engine\utility::istrue(param_01))
	{
		param_00 hide();
	}
}

//Function Number: 351
rankingenabled()
{
	if(!isplayer(self))
	{
		return 0;
	}

	return level.onlinegame && !self.usingonlinedataoffline;
}

//Function Number: 352
bufferednotify(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09)
{
	thread bufferednotify_internal(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09);
}

//Function Number: 353
bufferednotify_internal(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09)
{
	self endon("disconnect");
	level endon("game_ended");
	var_0A = "bufferedNotify_" + param_00;
	self notify(var_0A);
	self endon(var_0A);
	if(!isdefined(self.bufferednotifications))
	{
		self.bufferednotifications = [];
	}

	if(!isdefined(self.bufferednotifications[param_00]))
	{
		self.bufferednotifications[param_00] = [];
	}

	var_0B = spawnstruct();
	var_0B.var_C8E5 = param_01;
	var_0B.var_C8E6 = param_02;
	var_0B.var_C8E7 = param_03;
	var_0B.var_C8E8 = param_04;
	var_0B.var_C8E9 = param_05;
	var_0B.var_C8EA = param_06;
	var_0B.var_C8EB = param_07;
	var_0B.var_C8EC = param_08;
	var_0B.param9 = param_09;
	self.bufferednotifications[param_00][self.bufferednotifications[param_00].size] = var_0B;
	waittillframeend;
	while(self.bufferednotifications[param_00].size > 0)
	{
		var_0B = self.bufferednotifications[param_00][0];
		self notify(param_00,var_0B.var_C8E5,var_0B.var_C8E6,var_0B.var_C8E7,var_0B.var_C8E8,var_0B.var_C8E9,var_0B.var_C8EA,var_0B.var_C8EB,var_0B.var_C8EC,var_0B.param9);
		self.bufferednotifications[param_00] = array_remove_index(self.bufferednotifications[param_00],0);
		wait(0.05);
	}
}

//Function Number: 354
debugprintline(param_00)
{
}