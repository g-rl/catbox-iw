/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\menus.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 25
 * Decompile Time: 1101 ms
 * Timestamp: 10/27/2023 12:20:53 AM
*******************************************************************/

//Function Number: 1
init()
{
	if(!isdefined(game["gamestarted"]))
	{
		game["menu_team"] = "team_marinesopfor";
		if(level.multiteambased)
		{
			game["menu_team"] = "team_mt_options";
		}

		if(scripts\mp\utility::bot_is_fireteam_mode())
		{
			level.fireteam_menu = "class_commander_" + level.gametype;
			game["menu_class"] = level.fireteam_menu;
			game["menu_class_allies"] = level.fireteam_menu;
			game["menu_class_axis"] = level.fireteam_menu;
		}
		else
		{
			game["menu_class"] = "class";
			game["menu_class_allies"] = "class_marines";
			game["menu_class_axis"] = "class_opfor";
		}

		game["menu_changeclass_allies"] = "changeclass_marines";
		game["menu_changeclass_axis"] = "changeclass_opfor";
		if(level.multiteambased)
		{
			for(var_00 = 0;var_00 < level.teamnamelist.size;var_00++)
			{
				var_01 = "menu_class_" + level.teamnamelist[var_00];
				var_02 = "menu_changeclass_" + level.teamnamelist[var_00];
				game[var_01] = game["menu_class_allies"];
				game[var_02] = "changeclass_marines";
			}
		}

		game["menu_changeclass"] = "changeclass";
		if(level.console)
		{
			game["menu_controls"] = "ingame_controls";
			if(level.splitscreen)
			{
				if(level.multiteambased)
				{
					for(var_00 = 0;var_00 < level.teamnamelist.size;var_00++)
					{
						var_01 = "menu_class_" + level.teamnamelist[var_00];
						var_02 = "menu_changeclass_" + level.teamnamelist[var_00];
						game[var_01] = game[var_01] + "_splitscreen";
						game[var_02] = game[var_02] + "_splitscreen";
					}
				}

				game["menu_team"] = game["menu_team"] + "_splitscreen";
				game["menu_class_allies"] = game["menu_class_allies"] + "_splitscreen";
				game["menu_class_axis"] = game["menu_class_axis"] + "_splitscreen";
				game["menu_changeclass_allies"] = game["menu_changeclass_allies"] + "_splitscreen";
				game["menu_changeclass_axis"] = game["menu_changeclass_axis"] + "_splitscreen";
				game["menu_controls"] = game["menu_controls"] + "_splitscreen";
				game["menu_changeclass_defaults_splitscreen"] = "changeclass_splitscreen_defaults";
				game["menu_changeclass_custom_splitscreen"] = "changeclass_splitscreen_custom";
			}
		}

		precachestring(&"MP_HOST_ENDED_GAME");
		precachestring(&"MP_HOST_ENDGAME_RESPONSE");
	}

	level thread onplayerconnect();
	level thread watchforbootmoviecomplete();
	level thread setintrocamnetworkmodel();
}

//Function Number: 2
onplayerconnect()
{
	for(;;)
	{
		level waittill("connected",var_00);
		var_00 thread watchforclasschange();
		var_00 thread watchforteamchange();
		var_00 thread watchforleavegame();
		var_00 thread func_13A67();
	}
}

//Function Number: 3
setintrocamnetworkmodel()
{
	function_031D(1);
	level waittill("prematch_over");
	function_031D(0);
}

//Function Number: 4
watchforbootmoviecomplete()
{
	self endon("disconnect");
	level endon("game_ended");
	var_00 = 0;
	for(;;)
	{
		level waittill("rigBootFinished");
		var_00++;
		if(level.var_4533 <= var_00)
		{
			level notify("allRigsBooted");
			break;
		}
	}
}

//Function Number: 5
getclasschoice(param_00)
{
	var_01 = undefined;
	if(param_00 > 100)
	{
		var_02 = param_00 - 100;
		var_01 = "default" + var_02;
	}
	else
	{
		var_01 = "custom" + param_00;
	}

	return var_01;
}

//Function Number: 6
preloadandqueueclass(param_00)
{
	var_01 = spawnstruct();
	scripts\mp\playerlogic::getplayerassets(var_01,param_00);
	scripts\mp\playerlogic::loadplayerassets(var_01);
}

//Function Number: 7
watchforclasschange()
{
	self endon("disconnect");
	level endon("game_ended");
	for(;;)
	{
		self waittill("luinotifyserver",var_00,var_01);
		if(var_00 != "class_select")
		{
			continue;
		}

		if(getdvarint("systemlink") && getdvarint("xblive_competitionmatch") && self ismlgspectator())
		{
			self setclientomnvar("ui_options_menu",0);
			continue;
		}

		var_02 = isai(self) || issubstr(self.name,"tcBot");
		if(!var_02)
		{
			if(!isai(self) && "" + var_01 != "callback")
			{
				self setclientomnvar("ui_loadout_selected",var_01);
			}
		}

		if(isdefined(self.waitingtoselectclass) && self.waitingtoselectclass)
		{
			continue;
		}

		if(!scripts\mp\utility::allowclasschoice() || scripts\mp\utility::showfakeloadout())
		{
			continue;
		}

		if("" + var_01 != "callback")
		{
			if(isdefined(self.pers["isBot"]) && self.pers["isBot"])
			{
				self.pers["class"] = var_01;
				self.class = var_01;
			}
			else
			{
				var_03 = var_01 + 1;
				var_03 = getclasschoice(var_03);
				if(!isdefined(self.pers["class"]) || var_03 == self.pers["class"])
				{
					continue;
				}

				self.pers["class"] = var_03;
				self.class = var_03;
				preloadandqueueclass(var_03);
				if(scripts\mp\class::shouldallowinstantclassswap())
				{
					scripts\mp\class::giveloadoutswap();
				}
				else if(isalive(self))
				{
					self iprintlnbold(game["strings"]["change_class"]);
				}
			}

			continue;
		}

		menuclass("callback");
	}
}

//Function Number: 8
watchforleavegame()
{
	self endon("disconnect");
	level endon("game_ended");
	for(;;)
	{
		self waittill("luinotifyserver",var_00,var_01);
		if(var_00 != "end_game")
		{
			continue;
		}

		level thread scripts\mp\gamelogic::forceend(var_01);
	}
}

//Function Number: 9
watchforteamchange()
{
	self endon("disconnect");
	level endon("game_ended");
	for(;;)
	{
		self waittill("luinotifyserver",var_00,var_01);
		if(var_00 != "team_select")
		{
			continue;
		}

		if(scripts\mp\utility::matchmakinggame())
		{
			continue;
		}

		var_02 = 0;
		if(var_01 >= 3)
		{
			var_02 = 1;
		}

		if(var_02)
		{
			self setclientomnvar("ui_spectator_selected",1);
			self setclientomnvar("ui_loadout_selected",-1);
			self.spectating_actively = 1;
		}
		else
		{
			self setclientomnvar("ui_spectator_selected",-1);
			self.spectating_actively = 0;
		}

		var_03 = self ismlgspectator();
		var_04 = !var_03 && isdefined(self.team) && self.team == "spectator";
		var_05 = (var_03 && var_01 == 3) || var_04 && var_01 == 4;
		if(var_01 == 4)
		{
			var_01 = 3;
			self setmlgspectator(1);
		}
		else
		{
			self setmlgspectator(0);
		}

		self setclientomnvar("ui_team_selected",var_01);
		if(var_01 == 0)
		{
			var_01 = "axis";
		}
		else if(var_01 == 1)
		{
			var_01 = "allies";
		}
		else if(var_01 == 2)
		{
			var_01 = "random";
		}
		else
		{
			var_01 = "spectator";
		}

		if(!var_05 && isdefined(self.pers["team"]) && var_01 == self.pers["team"])
		{
			continue;
		}

		self setclientomnvar("ui_loadout_selected",-1);
		thread logteamselection(var_01);
		if(var_01 == "axis")
		{
			thread setteam("axis");
			continue;
		}

		if(var_01 == "allies")
		{
			thread setteam("allies");
			continue;
		}

		if(var_01 == "random")
		{
			thread autoassign();
			continue;
		}

		if(var_01 == "spectator")
		{
			thread setspectator(var_05);
		}
	}
}

//Function Number: 10
autoassign()
{
	if(level.gametype == "infect")
	{
		thread setteam("allies");
		return;
	}

	if(function_0280() && isdefined(self.bot_team))
	{
		thread setteam(self.bot_team);
		return;
	}

	if(!isdefined(self.team))
	{
		if(self ismlgspectator())
		{
			thread setspectator();
		}
		else if(level.teamcount["axis"] < level.teamcount["allies"])
		{
			thread setteam("axis");
		}
		else if(level.teamcount["allies"] < level.teamcount["axis"])
		{
			thread setteam("allies");
		}
		else if(getteamscore("allies") > getteamscore("axis"))
		{
			thread setteam("axis");
		}
		else
		{
			thread setteam("allies");
		}

		return;
	}

	if(self ismlgspectator())
	{
		thread setspectator();
		return;
	}

	if(level.teamcount["axis"] < level.teamcount["allies"] && self.team != "axis")
	{
		thread setteam("axis");
		return;
	}

	if(level.teamcount["allies"] < level.teamcount["axis"] && self.team != "allies")
	{
		thread setteam("allies");
		return;
	}

	if(level.teamcount["allies"] == level.teamcount["axis"])
	{
		if(getteamscore("allies") > getteamscore("axis") && self.team != "axis")
		{
			thread setteam("axis");
			return;
		}

		if(self.team != "allies")
		{
			thread setteam("allies");
			return;
		}

		return;
	}
}

//Function Number: 11
setteam(param_00)
{
	self endon("disconnect");
	if(!isai(self) && level.teambased && !scripts\mp\teams::getjointeampermissions(param_00) && !scripts\mp\utility::lobbyteamselectenabled())
	{
		return;
	}

	if(level.ingraceperiod && !self.hasdonecombat)
	{
		self.hasspawned = 0;
		self.pers["lives"] = scripts\mp\utility::getgametypenumlives();
	}

	if(self.sessionstate == "playing")
	{
		self.switching_teams = 1;
		self.joining_team = param_00;
		self.leaving_team = self.pers["team"];
	}

	addtoteam(param_00);
	if(scripts\mp\utility::isragdollzerog())
	{
		self lockdeathcamera(1);
	}

	if(self.sessionstate == "playing")
	{
		self suicide();
	}

	waitforclassselect();
	endrespawnnotify();
	if(self.sessionstate == "spectator")
	{
		if(game["state"] == "postgame")
		{
			return;
		}

		if(game["state"] == "playing" && !scripts\mp\utility::isinkillcam())
		{
			if(isdefined(self.waitingtospawnamortize) && self.waitingtospawnamortize)
			{
				return;
			}

			thread scripts\mp\playerlogic::spawnclient();
		}

		thread scripts\mp\spectating::setspectatepermissions();
	}

	self notify("okToSpawn");
}

//Function Number: 12
setspectator(param_00)
{
	if((!isdefined(param_00) || !param_00) && isdefined(self.pers["team"]) && self.pers["team"] == "spectator")
	{
		return;
	}

	if(isalive(self))
	{
		self.switching_teams = 1;
		self.joining_team = "spectator";
		self.leaving_team = self.pers["team"];
		self suicide();
	}

	self notify("becameSpectator");
	addtoteam("spectator");
	self.pers["class"] = undefined;
	self.class = undefined;
	thread scripts\mp\playerlogic::spawnspectator();
}

//Function Number: 13
waitforclassselect()
{
	self endon("disconnect");
	level endon("game_ended");
	self.waitingtoselectclass = 1;
	for(;;)
	{
		if(scripts\mp\utility::allowclasschoice() || scripts\mp\utility::showfakeloadout() && !isai(self))
		{
			if(!self ismlgspectator())
			{
				scripts\mp\utility::setlowermessage("spawn_info",game["strings"]["must_select_loadout_to_spawn"],undefined,undefined,undefined,undefined,undefined,undefined,1);
			}

			self waittill("luinotifyserver",var_00,var_01);
		}
		else
		{
			bypassclasschoice();
			break;
		}

		if(var_00 != "class_select")
		{
			continue;
		}

		if(self.team == "spectator")
		{
			continue;
		}

		if("" + var_01 != "callback")
		{
			if(isdefined(self.pers["isBot"]) && self.pers["isBot"])
			{
				self.pers["class"] = var_01;
				self.class = var_01;
			}
			else
			{
				var_01 = var_01 + 1;
				self.pers["class"] = getclasschoice(var_01);
				self.class = getclasschoice(var_01);
			}

			self.waitingtoselectclass = 0;
		}
		else
		{
			self.waitingtoselectclass = 0;
			menuclass("callback");
		}

		break;
	}
}

//Function Number: 14
beginclasschoice(param_00)
{
	var_01 = self.pers["team"];
	if(scripts\mp\utility::allowclasschoice() || scripts\mp\utility::showfakeloadout() && !isai(self))
	{
		self setclientomnvar("ui_options_menu",2);
		if(!self ismlgspectator())
		{
			waitforclassselect();
		}

		endrespawnnotify();
		if(self.sessionstate == "spectator")
		{
			if(game["state"] == "postgame")
			{
				return;
			}

			if(game["state"] == "playing" && !scripts\mp\utility::isinkillcam())
			{
				if(isdefined(self.waitingtospawnamortize) && self.waitingtospawnamortize)
				{
					return;
				}

				thread scripts\mp\playerlogic::spawnclient();
			}

			thread scripts\mp\spectating::setspectatepermissions();
		}

		self.connecttime = gettime();
		self notify("okToSpawn");
	}
	else
	{
		thread bypassclasschoice();
	}

	if(!isalive(self))
	{
		thread scripts\mp\playerlogic::predictabouttospawnplayerovertime(0.1);
	}
}

//Function Number: 15
bypassclasschoice()
{
	self.selectedclass = 1;
	self.waitingtoselectclass = 0;
	if(!isbot(self) && scripts\mp\utility::rankingenabled())
	{
		if(level.gametype == "infect" || isdefined(level.aonrules) && level.aonrules > 0)
		{
			scripts\mp\utility::setlowermessage("spawn_info",game["strings"]["press_to_spawn"],undefined,undefined,undefined,undefined,undefined,undefined,1);
			self notifyonplayercommand("pressToSpawn","+usereload");
			self notifyonplayercommand("pressToSpawn","+activate");
			self waittill("pressToSpawn");
		}
	}

	if(isdefined(level.bypassclasschoicefunc))
	{
		var_00 = self [[ level.bypassclasschoicefunc ]]();
		self.class = var_00;
		return;
	}

	self.class = "class0";
}

//Function Number: 16
beginteamchoice()
{
	self setclientomnvar("ui_options_menu",1);
}

//Function Number: 17
menuspectator()
{
	if(isdefined(self.pers["team"]) && self.pers["team"] == "spectator")
	{
		return;
	}

	if(isalive(self))
	{
		self.switching_teams = 1;
		self.joining_team = "spectator";
		self.leaving_team = self.pers["team"];
		self suicide();
	}

	addtoteam("spectator");
	self.pers["class"] = undefined;
	self.class = undefined;
	thread scripts\mp\playerlogic::spawnspectator();
}

//Function Number: 18
menuclass(param_00)
{
	var_01 = self.pers["team"];
	var_02 = scripts\mp\class::getclasschoice(param_00);
	var_03 = scripts\mp\class::getweaponchoice(param_00);
	if(var_02 == "restricted")
	{
		beginclasschoice();
		return;
	}

	if(isdefined(self.pers["class"]) && self.pers["class"] == var_02 && isdefined(self.pers["primary"]) && self.pers["primary"] == var_03)
	{
		return;
	}

	if(self.sessionstate == "playing")
	{
		if(isdefined(self.pers["lastClass"]) && isdefined(self.pers["class"]))
		{
			self.pers["lastClass"] = self.pers["class"];
			self.lastclass = self.pers["lastClass"];
		}

		self.pers["class"] = var_02;
		self.class = var_02;
		self.pers["primary"] = var_03;
		if(game["state"] == "postgame")
		{
			return;
		}

		if(level.ingraceperiod && !self.hasdonecombat)
		{
			scripts\mp\class::setclass(self.pers["class"]);
			self.weaponispreferreddrop = undefined;
			self.tag_stowed_hip = undefined;
			scripts\mp\class::giveloadout(self.pers["team"],self.pers["class"]);
		}
		else
		{
			self iprintlnbold(game["strings"]["change_class"]);
		}
	}
	else
	{
		if(isdefined(self.pers["lastClass"]) && isdefined(self.pers["class"]))
		{
			self.pers["lastClass"] = self.pers["class"];
			self.lastclass = self.pers["lastClass"];
		}

		self.pers["class"] = var_02;
		self.class = var_02;
		self.pers["primary"] = var_03;
		if(game["state"] == "postgame")
		{
			return;
		}

		if(game["state"] == "playing" && !scripts\mp\utility::isinkillcam())
		{
			thread scripts\mp\playerlogic::spawnclient();
		}
	}

	thread scripts\mp\spectating::setspectatepermissions();
}

//Function Number: 19
addtoteam(param_00,param_01,param_02)
{
	if(isdefined(self.team))
	{
		scripts\mp\playerlogic::removefromteamcount();
		if(isdefined(param_02) && param_02)
		{
			scripts\mp\playerlogic::decrementalivecount(self.team);
		}
	}

	if(isdefined(self.pers["team"]) && self.pers["team"] != "" && self.pers["team"] != "spectator")
	{
		self.pers["last_team"] = self.pers["team"];
	}

	self.pers["team"] = param_00;
	self.team = param_00;
	if((!scripts\mp\utility::matchmakinggame() || isdefined(self.pers["isBot"]) || !scripts\mp\utility::allowteamassignment()) && !function_0303())
	{
		if(level.teambased)
		{
			self.sessionteam = param_00;
		}
		else if(param_00 == "spectator")
		{
			self.sessionteam = "spectator";
		}
		else
		{
			self.sessionteam = "none";
		}
	}

	if(game["state"] != "postgame")
	{
		scripts\mp\playerlogic::addtoteamcount();
		if(isdefined(param_02) && param_02)
		{
			scripts\mp\playerlogic::incrementalivecount(self.team);
		}
	}

	if(function_0303())
	{
		setmatchdata("players",self.clientid,"team",param_00);
	}

	scripts\mp\utility::updateobjectivetext();
	if(isdefined(param_01) && param_01)
	{
		waittillframeend;
	}

	scripts\mp\utility::updatemainmenu();
	if(param_00 == "spectator")
	{
		self notify("joined_spectators");
		level notify("joined_team",self);
		return;
	}

	self notify("joined_team");
	level notify("joined_team",self);
}

//Function Number: 20
endrespawnnotify()
{
	self.waitingtospawn = 0;
	self notify("end_respawn");
}

//Function Number: 21
logteamselection(param_00)
{
	if(getdvarint("scr_playtest",0) == 0)
	{
		return;
	}

	if(param_00 != "random")
	{
		iprintlnbold("" + self.name + " did not select auto-assign");
	}
}

//Function Number: 22
func_13A67()
{
	thread func_13A69();
	thread func_13A6A();
	thread func_13A6B();
}

//Function Number: 23
func_13A69()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("luinotifyserver",var_00,var_01);
		if(var_00 == "rig_selected")
		{
			self.var_E535 = spawnstruct();
			self.var_E535.setprintchannel = var_01;
		}
	}
}

//Function Number: 24
func_13A6A()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("luinotifyserver",var_00,var_01);
		if(var_00 == "super_selected")
		{
			if(isdefined(self.var_E535))
			{
				self.var_E535.var_11261 = var_01;
				continue;
			}
		}
	}
}

//Function Number: 25
func_13A6B()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("luinotifyserver",var_00,var_01);
		if(var_00 == "trait_selected")
		{
			if(isdefined(self.var_E535))
			{
				self.var_E535.var_11B2D = var_01;
				if(isdefined(self.var_E535.setprintchannel) && isdefined(self.var_E535.var_11261))
				{
					var_02 = level.archetypes[self.var_E535.setprintchannel];
					var_03 = level.var_11264[self.var_E535.var_11261];
					var_04 = level.var_CA5E[self.var_E535.var_11B2D];
					scripts\mp\class::changearchetype(var_02,var_03,var_04);
				}
				else
				{
				}

				continue;
			}
		}
	}
}