/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\gametypes\infect.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 42
 * Decompile Time: 2069 ms
 * Timestamp: 10/27/2023 12:12:39 AM
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
		scripts\mp\_utility::registertimelimitdvar(level.gametype,10);
		scripts\mp\_utility::setoverridewatchdvar("scorelimit",0);
		scripts\mp\_utility::registerroundlimitdvar(level.gametype,1);
		scripts\mp\_utility::registerwinlimitdvar(level.gametype,1);
		scripts\mp\_utility::registernumlivesdvar(level.gametype,0);
		scripts\mp\_utility::registerhalftimedvar(level.gametype,0);
		level.numinitialinfected = 1;
		level.matchrules_damagemultiplier = 0;
		level.survivorprimaryweapon = "iw7_spasc";
	}

	updategametypedvars();
	level thread setspecialloadouts();
	level.ignorekdrstats = 1;
	level.teambased = 1;
	level.supportintel = 0;
	level.disableforfeit = 1;
	level.nobuddyspawns = 1;
	level.onstartgametype = ::onstartgametype;
	level.onspawnplayer = ::onspawnplayer;
	level.getspawnpoint = ::getspawnpoint;
	level.onplayerkilled = ::onplayerkilled;
	level.ondeadevent = ::ondeadevent;
	level.ontimelimit = ::ontimelimit;
	level.bypassclasschoicefunc = ::alwaysgamemodeclass;
	if(level.matchrules_damagemultiplier)
	{
		level.modifyplayerdamage = ::scripts\mp\_damage::gamemodemodifyplayerdamage;
	}

	game["dialog"]["gametype"] = "infected";
	if(getdvarint("g_hardcore"))
	{
		game["dialog"]["gametype"] = "hc_" + game["dialog"]["gametype"];
	}

	game["dialog"]["offense_obj"] = "survive";
}

//Function Number: 2
initializematchrules()
{
	scripts\mp\_utility::setcommonrulesfrommatchdata();
	setdynamicdvar("scr_infect_numInitialInfected",getmatchrulesdata("infectData","numInitialInfected"));
	setdynamicdvar("scr_infect_weaponSurvivorPrimary",getmatchrulesdata("infectData","weaponSurvivorPrimary"));
	setdynamicdvar("scr_infect_weaponSurvivorSecondary",getmatchrulesdata("infectData","weaponSurvivorSecondary"));
	setdynamicdvar("scr_infect_lethalSurvivor",getmatchrulesdata("infectData","lethalSurvivor"));
	setdynamicdvar("scr_infect_tacticalSurvivor",getmatchrulesdata("infectData","tacticalSurvivor"));
	setdynamicdvar("scr_infect_superSurvivor",getmatchrulesdata("infectData","superSurvivor"));
	setdynamicdvar("scr_infect_weaponInfectPrimary",getmatchrulesdata("infectData","weaponInfectPrimary"));
	setdynamicdvar("scr_infect_weaponInfectSecondary",getmatchrulesdata("infectData","weaponInfectSecondary"));
	setdynamicdvar("scr_infect_lethalInfect",getmatchrulesdata("infectData","lethalInfect"));
	setdynamicdvar("scr_infect_tacticalInfect",getmatchrulesdata("infectData","tacticalInfect"));
	setdynamicdvar("scr_infect_weaponInitialPrimary",getmatchrulesdata("infectData","weaponInitialPrimary"));
	setdynamicdvar("scr_infect_weaponInitialSecondary",getmatchrulesdata("infectData","weaponInitialSecondary"));
	setdynamicdvar("scr_infect_superInfect",getmatchrulesdata("infectData","superInfect"));
	setdynamicdvar("scr_infect_infectExtraTimePerKill",getmatchrulesdata("infectData","infectExtraTimePerKill"));
	setdynamicdvar("scr_infect_survivorAliveScore",getmatchrulesdata("infectData","survivorAliveScore"));
	setdynamicdvar("scr_infect_survivorScoreTime",getmatchrulesdata("infectData","survivorScoreTime"));
	setdynamicdvar("scr_infect_survivorScorePerTick",getmatchrulesdata("infectData","survivorScorePerTick"));
	setdynamicdvar("scr_infect_infectStreakBonus",getmatchrulesdata("infectData","infectStreakBonus"));
	setdynamicdvar("scr_infect_enableInfectedTracker",getmatchrulesdata("infectData","enableInfectedTracker"));
	setdynamicdvar("scr_infect_enablePing",getmatchrulesdata("infectData","enablePing"));
	setdynamicdvar("scr_team_fftype",0);
	setdynamicdvar("scr_infect_promode",0);
}

//Function Number: 3
onstartgametype()
{
	setclientnamemode("auto_change");
	scripts\mp\_utility::setobjectivetext("allies",&"OBJECTIVES_INFECT");
	scripts\mp\_utility::setobjectivetext("axis",&"OBJECTIVES_INFECT");
	if(level.splitscreen)
	{
		scripts\mp\_utility::setobjectivescoretext("allies",&"OBJECTIVES_INFECT");
		scripts\mp\_utility::setobjectivescoretext("axis",&"OBJECTIVES_INFECT");
	}
	else
	{
		scripts\mp\_utility::setobjectivescoretext("allies",&"OBJECTIVES_INFECT_SCORE");
		scripts\mp\_utility::setobjectivescoretext("axis",&"OBJECTIVES_INFECT_SCORE");
	}

	scripts\mp\_utility::setobjectivehinttext("allies",&"OBJECTIVES_INFECT_HINT");
	scripts\mp\_utility::setobjectivehinttext("axis",&"OBJECTIVES_INFECT_HINT");
	initspawns();
	var_00[0] = level.gametype;
	scripts\mp\_gameobjects::main(var_00);
	level.quickmessagetoall = 1;
	level.blockweapondrops = 1;
	level.infect_allowsuicide = 0;
	level.infect_skipsounds = 0;
	level.infect_chosefirstinfected = 0;
	level.infect_choosingfirstinfected = 0;
	level.infect_awardedfinalsurvivor = 0;
	level.infect_countdowninprogress = 0;
	level.infect_teamscores["axis"] = 0;
	level.infect_teamscores["allies"] = 0;
	level.infect_players = [];
	level thread onplayerconnect();
}

//Function Number: 4
updategametypedvars()
{
	scripts\mp\gametypes\common::updategametypedvars();
	level.numinitialinfected = scripts\mp\_utility::dvarintvalue("numInitialInfected",1,1,6);
	level.survivorprimaryweapon = getdvar("scr_infect_weaponSurvivorPrimary","iw7_spasc");
	level.survivorsecondaryweapon = getdvar("scr_infect_weaponSurvivorSecondary","iw7_g18");
	level.survivorlethal = getdvar("scr_infect_lethalSurvivor","power_tripMine");
	level.survivortactical = getdvar("scr_infect_tacticalSurvivor","power_concussionGrenade");
	level.survivorsuper = getdvar("scr_infect_superSurvivor","super_phaseshift");
	level.infectedprimaryweapon = getdvar("scr_infect_weaponInfectPrimary","iw7_knife");
	level.infectedsecondaryweapon = getdvar("scr_infect_weaponInfectSecondary","iw7_fists");
	level.initialprimaryweapon = getdvar("scr_infect_weaponInitialPrimary","iw7_spasc");
	level.initialsecondaryweapon = getdvar("scr_infect_weaponInitialSecondary","iw7_g18");
	level.infectedlethal = getdvar("scr_infect_lethalInfect","power_throwingKnife");
	level.infectedtactical = getdvar("scr_infect_tacticalInfect","power_tacInsert");
	level.infectedsuper = getdvar("scr_infect_superInfect","super_reaper");
	level.infectextratimeperkill = scripts\mp\_utility::dvarfloatvalue("infectExtraTimePerKill",30,0,60);
	level.survivoralivescore = scripts\mp\_utility::dvarintvalue("survivorAliveScore",25,0,100);
	level.survivorscoretime = scripts\mp\_utility::dvarfloatvalue("survivorScoreTime",30,0,60);
	level.survivorscorepertick = scripts\mp\_utility::dvarintvalue("survivorScorePerTick",50,0,100);
	level.infectstreakbonus = scripts\mp\_utility::dvarintvalue("infectStreakBonus",50,0,100);
	level.enableinfectedtracker = scripts\mp\_utility::dvarintvalue("enableInfectedTracker",0,0,1);
	level.enableping = scripts\mp\_utility::dvarintvalue("enablePing",0,0,1);
	level.allweapons = [];
	level.allweapons[level.allweapons.size] = level.survivorprimaryweapon;
	level.allweapons[level.allweapons.size] = level.survivorsecondaryweapon;
	level.allweapons[level.allweapons.size] = level.infectedprimaryweapon;
	level.allweapons[level.allweapons.size] = level.infectedsecondaryweapon;
	level.allweapons[level.allweapons.size] = level.initialprimaryweapon;
	level.allweapons[level.allweapons.size] = level.initialsecondaryweapon;
	level.survivorprimaryweapon = stripweapsuffix(level.survivorprimaryweapon);
	level.survivorsecondaryweapon = stripweapsuffix(level.survivorsecondaryweapon);
	level.infectedprimaryweapon = stripweapsuffix(level.infectedprimaryweapon);
	level.infectedsecondaryweapon = stripweapsuffix(level.infectedsecondaryweapon);
	level.initialprimaryweapon = stripweapsuffix(level.initialprimaryweapon);
	level.initialsecondaryweapon = stripweapsuffix(level.initialsecondaryweapon);
}

//Function Number: 5
stripweapsuffix(param_00)
{
	if(issubstr(param_00,"mpr"))
	{
		param_00 = scripts\mp\_utility::strip_suffix(param_00,"_mpr");
	}
	else if(issubstr(param_00,"mpl"))
	{
		param_00 = scripts\mp\_utility::strip_suffix(param_00,"_mpl");
	}
	else
	{
		param_00 = scripts\mp\_utility::strip_suffix(param_00,"_mp");
	}

	return param_00;
}

//Function Number: 6
onplayerconnect()
{
	for(;;)
	{
		level waittill("connected",var_00);
		var_00.gamemodefirstspawn = 1;
		var_00.gamemodejoinedatstart = 1;
		var_00.infectedrejoined = 0;
		var_00.waitedtospawn = 0;
		if(!scripts\mp\_utility::gameflag("prematch_done") || level.infect_countdowninprogress)
		{
			var_00.waitedtospawn = 1;
		}

		var_00.pers["class"] = "gamemode";
		var_00.pers["lastClass"] = "";
		var_00.class = var_00.pers["class"];
		var_00.lastclass = var_00.pers["lastClass"];
		var_00 loadweaponsforplayer(level.allweapons);
		if(scripts\mp\_utility::gameflag("prematch_done"))
		{
			var_00.gamemodejoinedatstart = 0;
			if(isdefined(level.infect_chosefirstinfected) && level.infect_chosefirstinfected)
			{
				var_00.survivalstarttime = gettime();
			}
		}

		if(isdefined(level.infect_players[var_00.name]))
		{
			var_00.infectedrejoined = 1;
		}

		if(isdefined(var_00.isinitialinfected))
		{
			var_00.pers["gamemodeLoadout"] = level.infect_loadouts["axis_initial"];
		}
		else if(var_00.infectedrejoined)
		{
			var_00.pers["gamemodeLoadout"] = level.infect_loadouts["axis"];
		}
		else
		{
			var_00.pers["gamemodeLoadout"] = level.infect_loadouts["allies"];
			var_00 setrandomrigifscout();
		}

		var_00 thread monitorsurvivaltime();
	}
}

//Function Number: 7
givesurvivortimescore()
{
	level endon("game_ended");
	for(;;)
	{
		wait(level.survivorscoretime);
		foreach(var_01 in level.players)
		{
			if(var_01.team == "allies")
			{
				var_01 thread scripts\mp\_utility::giveunifiedpoints("survivor",undefined,level.survivorscorepertick);
			}
		}
	}
}

//Function Number: 8
initspawns()
{
	scripts\mp\_spawnlogic::setactivespawnlogic("TDM");
	level.spawnmins = (0,0,0);
	level.spawnmaxs = (0,0,0);
	scripts\mp\_spawnlogic::addspawnpoints("allies","mp_tdm_spawn");
	scripts\mp\_spawnlogic::addspawnpoints("allies","mp_tdm_spawn_secondary",1,1);
	scripts\mp\_spawnlogic::addspawnpoints("axis","mp_tdm_spawn");
	scripts\mp\_spawnlogic::addspawnpoints("axis","mp_tdm_spawn_secondary",1,1);
	level.mapcenter = scripts\mp\_spawnlogic::findboxcenter(level.spawnmins,level.spawnmaxs);
	function_01B4(level.mapcenter);
}

//Function Number: 9
alwaysgamemodeclass()
{
	return "gamemode";
}

//Function Number: 10
getspawnpoint()
{
	if(isplayer(self) && self.gamemodefirstspawn)
	{
		self.gamemodefirstspawn = 0;
		self.pers["class"] = "gamemode";
		self.pers["lastClass"] = "";
		self.class = self.pers["class"];
		self.lastclass = self.pers["lastClass"];
		var_00 = "allies";
		if(self.infectedrejoined)
		{
			var_00 = "axis";
		}

		scripts\mp\_menus::addtoteam(var_00,1);
		thread monitordisconnect();
	}

	if(level.ingraceperiod)
	{
		var_01 = scripts\mp\_spawnlogic::getspawnpointarray("mp_tdm_spawn");
		var_02 = scripts\mp\_spawnlogic::getspawnpoint_random(var_01);
	}
	else
	{
		var_01 = scripts\mp\_spawnlogic::getteamspawnpoints(self.pers["team"]);
		var_03 = scripts\mp\_spawnlogic::getteamfallbackspawnpoints(self.pers["team"]);
		var_02 = scripts\mp\_spawnscoring::getspawnpoint(var_01,var_03);
	}

	return var_02;
}

//Function Number: 11
onspawnplayer()
{
	self.teamchangedthisframe = undefined;
	self.infect_spawnpos = self.origin;
	self.infectedkillsthislife = 0;
	updateteamscores();
	if(!level.infect_choosingfirstinfected)
	{
		level.infect_choosingfirstinfected = 1;
		level thread choosefirstinfected();
	}

	if(!scripts\mp\_utility::gameflag("prematch_done") || level.infect_countdowninprogress)
	{
		self.waitedtospawn = 0;
	}

	if(self.infectedrejoined)
	{
		if(!level.infect_allowsuicide)
		{
			level notify("infect_stopCountdown");
			level.infect_chosefirstinfected = 1;
			level.infect_allowsuicide = 1;
			foreach(var_01 in level.players)
			{
				if(isdefined(var_01.infect_isbeingchosen))
				{
					var_01.infect_isbeingchosen = undefined;
				}
			}
		}

		foreach(var_01 in level.players)
		{
			if(isdefined(var_01.isinitialinfected))
			{
				var_01 thread setinitialtonormalinfected();
			}
		}

		if(level.infect_teamscores["axis"] == 1)
		{
			self.isinitialinfected = 1;
		}

		initsurvivaltime(1);
	}

	thread onspawnfinished();
	level notify("spawned_player");
}

//Function Number: 12
spawnwithplayersecondary()
{
	var_00 = self getweaponslistprimaries();
	var_01 = self getcurrentprimaryweapon();
	if(var_00.size > 1)
	{
		if(scripts\mp\_weapons::isknifeonly(var_01))
		{
			foreach(var_03 in var_00)
			{
				if(var_03 != var_01)
				{
					self setspawnweapon(var_03);
				}
			}
		}
	}
}

//Function Number: 13
setdefaultammoclip(param_00)
{
	var_01 = 1;
	if(isdefined(self.isinitialinfected))
	{
		if(scripts\mp\_utility::isusingdefaultclass(param_00,1))
		{
			var_01 = 0;
		}
	}
	else if(scripts\mp\_utility::isusingdefaultclass(param_00,0))
	{
		var_01 = 0;
	}

	return var_01;
}

//Function Number: 14
onspawnfinished()
{
	self endon("death");
	self endon("disconnect");
	self waittill("giveLoadout");
	if(scripts\mp\_utility::istrue(self.waitedtospawn))
	{
		self.waitedtospawn = 0;
		wait(0.1);
		self suicide();
	}

	self.last_infected_class = self.infected_class;
	self.var_2049 = 0;
	self.var_204A = 0;
	if(self.pers["team"] == "allies")
	{
		if(level.enableping)
		{
			scripts\mp\_utility::giveperk("specialty_boom");
		}

		spawnwithplayersecondary();
		var_00 = "primary";
		var_01 = scripts\mp\_powers::getcurrentequipment(var_00);
		if(isdefined(var_01))
		{
			scripts\mp\_powers::removepower(var_01);
		}

		scripts\mp\_powers::givepower(level.survivorlethal,var_00,0);
		var_00 = "secondary";
		var_01 = scripts\mp\_powers::getcurrentequipment(var_00);
		if(isdefined(var_01))
		{
			scripts\mp\_powers::removepower(var_01);
		}

		scripts\mp\_powers::givepower(level.survivortactical,var_00,0);
		managefists(level.survivorprimaryweapon,level.survivorsecondaryweapon);
	}
	else if(self.pers["team"] == "axis")
	{
		if(level.enableping)
		{
			scripts\mp\_utility::giveperk("specialty_boom");
		}

		refundinfectedsuper();
		thread setinfectedmsg();
		if(!level.supportdoublejump_MAYBE)
		{
			var_02 = 1.1;
		}
		else
		{
			var_02 = 1.05;
		}

		var_03 = int(floor(level.infect_teamscores["axis"] / 3));
		var_03 = var_03 * 0.012;
		var_02 = var_02 - var_03;
		self.overrideweaponspeed_speedscale = var_02;
		scripts\mp\_weapons::updatemovespeedscale();
		var_00 = "primary";
		var_01 = scripts\mp\_powers::getcurrentequipment(var_00);
		if(isdefined(var_01))
		{
			scripts\mp\_powers::removepower(var_01);
		}

		scripts\mp\_powers::givepower(level.infectedlethal,var_00,0);
		if(level.infectedtactical != "power_tacInsert")
		{
			var_00 = "secondary";
			var_01 = scripts\mp\_powers::getcurrentequipment(var_00);
			if(isdefined(var_01))
			{
				scripts\mp\_powers::removepower(var_01);
			}

			scripts\mp\_powers::givepower(level.infectedtactical,var_00,0);
		}
		else
		{
			scripts\mp\_utility::giveperk("specialty_tacticalinsertion");
		}

		if(scripts\mp\_utility::istrue(self.isinitialinfected))
		{
			managefists(level.initialprimaryweapon,level.initialsecondaryweapon);
		}
		else
		{
			managefists(level.infectedprimaryweapon,level.infectedsecondaryweapon);
		}

		self setscriptablepartstate("infected","active",0);
	}

	giveextrainfectedperks();
	var_04 = scripts\mp\_utility::getweaponrootname(self.loadoutprimary);
	if(var_04 != "iw7_knife")
	{
		self giveweapon("iw7_knife_mp_infect");
		self assignweaponmeleeslot("iw7_knife_mp_infect");
		if(self.loadoutsecondary == "iw7_knife")
		{
			scripts\mp\_utility::takeweaponwhensafe("iw7_knife_mp");
			self giveweapon("iw7_knife_mp_infect2");
		}
	}

	self.faux_spawn_infected = undefined;
}

//Function Number: 15
managefists(param_00,param_01)
{
	if(param_00 != "iw7_fists" || param_01 != "iw7_fists")
	{
		if(param_00 == "none" && param_01 == "none")
		{
			return;
		}

		scripts\mp\_utility::takeweaponwhensafe("iw7_fists_mp");
	}
}

//Function Number: 16
giveextrainfectedperks()
{
	if(self.pers["team"] == "allies")
	{
		var_00 = ["specialty_fastreload","passive_gore","passive_nuke","passive_refresh"];
	}
	else if(scripts\mp\_utility::istrue(self.isinitialinfected))
	{
		var_00 = ["specialty_longersprint","specialty_quickdraw","specialty_falldamage","specialty_bulletaccuracy","specialty_quickswap"];
	}
	else
	{
		var_00 = ["specialty_longersprint","specialty_quickdraw","specialty_falldamage"];
	}

	foreach(var_02 in var_00)
	{
		scripts\mp\_utility::giveperk(var_02);
	}
}

//Function Number: 17
setinfectedmodels()
{
}

//Function Number: 18
setinfectedmsg()
{
	if(isdefined(self.isinitialinfected))
	{
		if(!isdefined(self.showninfected) || !self.showninfected)
		{
			thread scripts\mp\_rank::scoreeventpopup("first_infected");
			self.showninfected = 1;
			return;
		}

		return;
	}

	if(isdefined(self.changingtoregularinfected))
	{
		self.changingtoregularinfected = undefined;
		if(isdefined(self.changingtoregularinfectedbykill))
		{
			self.changingtoregularinfectedbykill = undefined;
			thread scripts\mp\_utility::giveunifiedpoints("first_infected");
			return;
		}

		return;
	}

	if(!isdefined(self.showninfected) || !self.showninfected)
	{
		thread scripts\mp\_rank::scoreeventpopup("got_infected");
		self.showninfected = 1;
		return;
	}
}

//Function Number: 19
choosefirstinfected()
{
	level endon("game_ended");
	level endon("infect_stopCountdown");
	level endon("force_end");
	level.infect_allowsuicide = 0;
	scripts\mp\_utility::gameflagwait("prematch_done");
	level.infect_countdowninprogress = 1;
	scripts\mp\_hostmigration::waitlongdurationwithhostmigrationpause(1);
	setomnvar("ui_match_start_text","first_infected_in");
	var_00 = 15;
	while(var_00 > 0 && !level.gameended)
	{
		setomnvar("ui_match_start_countdown",var_00);
		var_00--;
		scripts\mp\_hostmigration::waitlongdurationwithhostmigrationpause(1);
	}

	setomnvar("ui_match_start_countdown",0);
	level.infect_countdowninprogress = 0;
	var_01 = [];
	foreach(var_03 in level.players)
	{
		if(scripts\mp\_utility::matchmakinggame() && level.players.size > 1 && var_03 ishost())
		{
			continue;
		}

		if(var_03.team == "spectator")
		{
			continue;
		}

		if(!var_03.hasspawned)
		{
			continue;
		}

		var_01[var_01.size] = var_03;
	}

	var_05 = undefined;
	if(var_01.size <= level.numinitialinfected && var_01.size > 1)
	{
		level.numinitialinfected = var_01.size - 1;
	}

	for(var_06 = 0;var_06 < level.numinitialinfected;var_06++)
	{
		var_05 = var_01[randomint(var_01.size)];
		var_05 setfirstinfected(1);
		var_01 = scripts\engine\utility::array_remove(var_01,var_05);
	}

	level.infect_allowsuicide = 1;
	foreach(var_03 in level.players)
	{
		if(var_03 == var_05)
		{
			continue;
		}

		var_03.survivalstarttime = gettime();
	}
}

//Function Number: 20
setfirstinfected(param_00)
{
	self endon("disconnect");
	self endon("death");
	if(param_00)
	{
		self.infect_isbeingchosen = 1;
	}

	while(!scripts\mp\_utility::isreallyalive(self) || scripts\mp\_utility::isusingremote())
	{
		wait(0.05);
	}

	if(isdefined(self.iscarrying) && self.iscarrying == 1)
	{
		self notify("force_cancel_placement");
		wait(0.05);
	}

	while(self ismantling())
	{
		wait(0.05);
	}

	if(scripts\mp\_utility::isjuggernaut())
	{
		self notify("lost_juggernaut");
		wait(0.05);
	}

	while(!isalive(self))
	{
		scripts\engine\utility::waitframe();
	}

	if(param_00)
	{
		scripts\mp\_menus::addtoteam("axis",undefined,1);
		thread monitordisconnect();
		level.infect_chosefirstinfected = 1;
		self.infect_isbeingchosen = undefined;
		updateteamscores();
		self playlocalsound("breathing_better_c6");
	}

	self.isinitialinfected = 1;
	self.pers["gamemodeLoadout"] = level.infect_loadouts["axis_initial"];
	if(isdefined(self.setspawnpoint))
	{
		scripts\mp\perks\_perkfunctions::deleteti(self.setspawnpoint);
	}

	var_01 = spawn("script_model",self.origin);
	var_01.angles = self.angles;
	var_01.playerspawnpos = self.origin;
	var_01.notti = 1;
	self.setspawnpoint = var_01;
	self notify("faux_spawn");
	self.faux_spawn_stance = self getstance();
	self.faux_spawn_infected = 1;
	waittillframeend;
	thread scripts\mp\_playerlogic::spawnplayer(1);
	if(param_00)
	{
		level.infect_players[self.name] = 1;
	}

	foreach(var_03 in level.players)
	{
		var_03 thread scripts\mp\_hud_message::showsplash("first_infected");
	}

	level thread scripts\mp\_utility::teamplayercardsplash("callout_first_infected",self);
	if(!level.infect_skipsounds)
	{
		scripts\mp\_utility::playsoundonplayers("mp_enemy_obj_captured");
		level.infect_skipsounds = 1;
	}

	self iprintlnbold(&"SPLASHES_INFECT_ALL");
	initsurvivaltime(1);
}

//Function Number: 21
setinitialtonormalinfected(param_00,param_01)
{
	level endon("game_ended");
	self endon("death");
	self.isinitialinfected = undefined;
	self.changingtoregularinfected = 1;
	if(isdefined(param_00))
	{
		self.changingtoregularinfectedbykill = 1;
	}

	while(!scripts\mp\_utility::isreallyalive(self))
	{
		wait(0.05);
	}

	if(isdefined(self.iscarrying) && self.iscarrying == 1)
	{
		self notify("force_cancel_placement");
		wait(0.05);
	}

	while(self ismantling())
	{
		wait(0.05);
	}

	if(scripts\mp\_utility::isjuggernaut())
	{
		self notify("lost_juggernaut");
		wait(0.05);
	}

	while(self ismeleeing())
	{
		wait(0.05);
	}

	while(!scripts\mp\_utility::isreallyalive(self))
	{
		wait(0.05);
	}

	self.pers["gamemodeLoadout"] = level.infect_loadouts["axis"];
	if(isdefined(self.setspawnpoint))
	{
		scripts\mp\perks\_perkfunctions::deleteti(self.setspawnpoint);
	}

	var_02 = spawn("script_model",self.origin);
	var_02.angles = self.angles;
	var_02.playerspawnpos = self.origin;
	var_02.notti = 1;
	self.setspawnpoint = var_02;
	self notify("faux_spawn");
	self.faux_spawn_stance = self getstance();
	self.faux_spawn_infected = 1;
	scripts\engine\utility::waitframe();
	thread scripts\mp\_playerlogic::spawnplayer(1);
}

//Function Number: 22
onplayerkilled(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09)
{
	if(level.gameended)
	{
		return;
	}

	var_0A = 0;
	var_0B = 0;
	if(self.team == "axis")
	{
		self setscriptablepartstate("infected","neutral",0);
	}

	if(self.team == "allies" && isdefined(param_01))
	{
		if(isplayer(param_01) && param_01 != self)
		{
			var_0A = 1;
		}
		else if(level.infect_allowsuicide && param_01 == self || !isplayer(param_01))
		{
			var_0A = 1;
			var_0B = 1;
		}
	}

	if(isplayer(param_01) && param_01.team == "allies" && param_01 != self)
	{
		param_01 thread scripts\mp\perks\_weaponpassives::func_8974(param_01,self);
		param_01 scripts\mp\_utility::incperstat("killsAsSurvivor",1);
		param_01 scripts\mp\_persistence::statsetchild("round","killsAsSurvivor",param_01.pers["killsAsSurvivor"]);
	}
	else if(isplayer(param_01) && param_01.team == "axis" && param_01 != self)
	{
		param_01 scripts\mp\_utility::incperstat("killsAsInfected",1);
		param_01 scripts\mp\_persistence::statsetchild("round","killsAsInfected",param_01.pers["killsAsInfected"]);
		if(isplayer(param_01))
		{
			param_01 scripts\mp\_utility::setextrascore1(param_01.pers["killsAsInfected"]);
		}
	}

	if(var_0A)
	{
		thread delayedprocesskill(param_01,var_0B);
		if(var_0B)
		{
			foreach(var_0D in level.players)
			{
				if(isdefined(var_0D.isinitialinfected))
				{
					var_0D thread setinitialtonormalinfected();
				}
			}
		}
		else if(isdefined(param_01.isinitialinfected))
		{
			foreach(var_0D in level.players)
			{
				if(isdefined(var_0D.isinitialinfected))
				{
					var_0D thread setinitialtonormalinfected(1);
				}
			}
		}
		else if(level.infectstreakbonus > 0)
		{
			if(!isdefined(param_01.infectedkillsthislife))
			{
				param_01.infectedkillsthislife = 1;
			}
			else
			{
				param_01.var_941A++;
			}

			param_01 thread scripts\mp\_utility::giveunifiedpoints("infected_survivor",undefined,level.infectstreakbonus * param_01.infectedkillsthislife);
		}
		else
		{
			param_01 thread scripts\mp\_utility::giveunifiedpoints("infected_survivor");
		}

		if(scripts\mp\_utility::getwatcheddvar("timelimit") != 0)
		{
			if(!isdefined(level.extratime))
			{
				level.extratime = level.infectextratimeperkill / 60;
			}
			else
			{
				level.extratime = level.extratime + level.infectextratimeperkill / 60;
			}
		}

		setsurvivaltime(1);
		return;
	}

	if(isbot(self))
	{
		self.classcallback = "gamemode";
	}

	if(isdefined(self.isinitialinfected))
	{
		self.pers["gamemodeLoadout"] = level.infect_loadouts["axis_initial"];
		self.infected_class = "axis_initial";
	}
	else
	{
		self.pers["gamemodeLoadout"] = level.infect_loadouts[self.pers["team"]];
		self.infected_class = self.pers["team"];
	}

	if(self.pers["team"] == "allies")
	{
		setrandomrigifscout();
	}
}

//Function Number: 23
delayedprocesskill(param_00,param_01)
{
	wait(0.15);
	self.teamchangedthisframe = 1;
	scripts\mp\_menus::addtoteam("axis");
	updateteamscores();
	level.infect_players[self.name] = 1;
	thread monitordisconnect();
	if(level.infect_teamscores["allies"] > 1)
	{
		scripts\mp\_utility::playsoundonplayers("mp_enemy_obj_captured","allies");
		scripts\mp\_utility::playsoundonplayers("mp_war_objective_taken","axis");
		thread scripts\mp\_utility::teamplayercardsplash("callout_got_infected",self,"allies");
		if(!param_01)
		{
			thread scripts\mp\_utility::teamplayercardsplash("callout_infected",param_00,"axis");
			if(!isdefined(level.survivorscoreevent))
			{
				level.survivorscoreevent = scripts\mp\_rank::getscoreinfovalue("survivor");
			}
			else
			{
				level.survivorscoreevent = level.survivorscoreevent + level.survivoralivescore;
			}

			foreach(var_03 in level.players)
			{
				if(!scripts\mp\_utility::isreallyalive(var_03) || self.sessionstate == "spectator")
				{
					continue;
				}

				if(var_03.team == "allies" && var_03 != self && distance(var_03.infect_spawnpos,var_03.origin) > 32)
				{
					var_03 thread scripts\mp\_utility::giveunifiedpoints("survivor",undefined,level.survivorscoreevent);
				}

				if(var_03.team == "axis" && var_03 != param_00 && var_03 != self)
				{
					var_03 thread scripts\mp\_utility::giveunifiedpoints("assist",undefined,50);
				}
			}
		}
	}
	else if(level.infect_teamscores["allies"] == 1)
	{
		onfinalsurvivor();
	}
	else if(level.infect_teamscores["allies"] == 0)
	{
		onsurvivorseliminated();
	}

	if(isbot(self))
	{
		self.classcallback = "gamemode";
	}

	if(isdefined(self.isinitialinfected))
	{
		self.pers["gamemodeLoadout"] = level.infect_loadouts["axis_initial"];
		self.infected_class = "axis_initial";
		return;
	}

	self.pers["gamemodeLoadout"] = level.infect_loadouts[self.pers["team"]];
	self.infected_class = self.pers["team"];
}

//Function Number: 24
onfinalsurvivor()
{
	scripts\mp\_utility::playsoundonplayers("mp_obj_captured");
	foreach(var_01 in level.players)
	{
		if(!isdefined(var_01))
		{
			continue;
		}

		if(var_01.team == "allies")
		{
			var_01 thread scripts\mp\_rank::scoreeventpopup("final_survivor");
			if(!level.infect_awardedfinalsurvivor)
			{
				if(var_01.gamemodejoinedatstart && isdefined(var_01.infect_spawnpos) && distance(var_01.infect_spawnpos,var_01.origin) > 32)
				{
					var_01 thread scripts\mp\_utility::giveunifiedpoints("final_survivor");
				}

				level.infect_awardedfinalsurvivor = 1;
			}

			thread scripts\mp\_utility::teamplayercardsplash("callout_final_survivor",var_01);
			if(!var_01 scripts\mp\_utility::isjuggernaut())
			{
				level thread finalsurvivoruav(var_01);
			}

			break;
		}
	}
}

//Function Number: 25
finalsurvivoruav(param_00)
{
	level endon("game_ended");
	param_00 endon("disconnect");
	param_00 endon("eliminated");
	level endon("infect_lateJoiner");
	level thread enduavonlatejoiner(param_00);
	var_01 = 0;
	level.createprintchannel["axis"] = "normal_radar";
	foreach(var_03 in level.players)
	{
		if(var_03.team == "axis")
		{
			var_03.createprintchannel = "normal_radar";
		}
	}

	var_05 = getuavstrengthlevelneutral();
	scripts\mp\killstreaks\_uav::_setteamradarstrength("axis",var_05 + 1);
	for(;;)
	{
		var_06 = param_00.origin;
		wait(4);
		if(var_01)
		{
			setteamradar("axis",0);
			var_01 = 0;
		}

		wait(6);
		if(distance(var_06,param_00.origin) < 200)
		{
			setteamradar("axis",1);
			var_01 = 1;
			foreach(var_03 in level.players)
			{
				var_03 playlocalsound("recondrone_tag");
			}
		}
	}
}

//Function Number: 26
enduavonlatejoiner(param_00)
{
	level endon("game_ended");
	param_00 endon("disconnect");
	param_00 endon("eliminated");
	for(;;)
	{
		if(level.infect_teamscores["allies"] > 1)
		{
			level notify("infect_lateJoiner");
			wait(0.05);
			setteamradar("axis",0);
			break;
		}

		wait(0.05);
	}
}

//Function Number: 27
monitordisconnect()
{
	level endon("game_ended");
	self endon("eliminated");
	self notify("infect_monitor_disconnect");
	self endon("infect_monitor_disconnect");
	var_00 = self.team;
	if(!isdefined(var_00) && isdefined(self.bot_team))
	{
		var_00 = self.bot_team;
	}

	self waittill("disconnect");
	updateteamscores();
	if(isdefined(self.infect_isbeingchosen) || level.infect_chosefirstinfected)
	{
		if(level.infect_teamscores["axis"] && level.infect_teamscores["allies"])
		{
			if(var_00 == "allies" && level.infect_teamscores["allies"] == 1)
			{
				onfinalsurvivor();
			}
			else if(var_00 == "axis" && level.infect_teamscores["axis"] == 1)
			{
				foreach(var_02 in level.players)
				{
					if(var_02 != self && var_02.team == "axis")
					{
						var_02 setfirstinfected(0);
					}
				}
			}
		}
		else if(level.infect_teamscores["allies"] == 0)
		{
			if(scripts\mp\_utility::istrue(level.hostmigration))
			{
				scripts\mp\_hostmigration::waittillhostmigrationdone();
			}

			onsurvivorseliminated();
		}
		else if(level.infect_teamscores["axis"] == 0)
		{
			if(level.infect_teamscores["allies"] == 1)
			{
				level thread scripts\mp\_gamelogic::endgame("allies",game["end_reason"]["axis_eliminated"]);
			}
			else if(level.infect_teamscores["allies"] > 1)
			{
				level.infect_chosefirstinfected = 0;
				level thread choosefirstinfected();
			}
		}
	}
	else if(level.infect_countdowninprogress && level.infect_teamscores["allies"] == 0 && level.infect_teamscores["axis"] == 0)
	{
		level notify("infect_stopCountdown");
		level.infect_choosingfirstinfected = 0;
		setomnvar("ui_match_start_countdown",0);
	}

	self.isinitialinfected = undefined;
}

//Function Number: 28
ondeadevent(param_00)
{
}

//Function Number: 29
ontimelimit()
{
	level thread scripts\mp\_gamelogic::endgame("allies",game["end_reason"]["time_limit_reached"]);
}

//Function Number: 30
onsurvivorseliminated()
{
	level thread scripts\mp\_gamelogic::endgame("axis",game["end_reason"]["allies_eliminated"]);
}

//Function Number: 31
getteamsize(param_00)
{
	var_01 = 0;
	foreach(var_03 in level.players)
	{
		if(var_03.sessionstate == "spectator" && !var_03.clearstartpointtransients)
		{
			continue;
		}

		if(var_03.team == param_00)
		{
			var_01++;
		}
	}

	return var_01;
}

//Function Number: 32
updateteamscores()
{
	level.infect_teamscores["allies"] = getteamsize("allies");
	game["teamScores"]["allies"] = level.infect_teamscores["allies"];
	setteamscore("allies",level.infect_teamscores["allies"]);
	level.infect_teamscores["axis"] = getteamsize("axis");
	game["teamScores"]["axis"] = level.infect_teamscores["axis"];
	setteamscore("axis",level.infect_teamscores["axis"]);
}

//Function Number: 33
setspecialloadouts()
{
	wait(0.05);
	if(!isdefined(level.survivorprimaryweapon) || level.survivorprimaryweapon == "")
	{
		level.survivorprimaryweapon = "iw7_spasc";
	}

	if(!isdefined(level.survivorsecondaryweapon) || level.survivorsecondaryweapon == "")
	{
		level.survivorsecondaryweapon = "iw7_g18";
	}

	if(!isdefined(level.infectedprimaryweapon) || level.infectedprimaryweapon == "")
	{
		level.infectedprimaryweapon = "iw7_knife";
	}

	if(!isdefined(level.infectedsecondaryweapon) || level.infectedsecondaryweapon == "")
	{
		level.infectedsecondaryweapon = "iw7_fists";
	}

	if(!isdefined(level.initialprimaryweapon) || level.initialprimaryweapon == "")
	{
		level.initialprimaryweapon = "iw7_spasc";
	}

	if(isdefined(level.infectedprimaryweapon) && level.infectedprimaryweapon == "iw7_knife")
	{
		level.infectedprimaryweapon = "iw7_knife_mp_infect2";
		if(isdefined(level.infectedsecondaryweapon) && level.infectedsecondaryweapon == "iw7_knife")
		{
			level.infectedsecondaryweapon = "none";
		}
	}

	if(!isdefined(level.initialsecondaryweapon) || level.initialsecondaryweapon == "")
	{
		level.initialsecondaryweapon = "iw7_g18";
	}

	addsurvivorattachmentsprimary(level.survivorprimaryweapon);
	addsurvivorattachmentssecondary(level.survivorsecondaryweapon);
	addinitialattachmentsprimary(level.initialprimaryweapon);
	addinitialattachmentssecondary(level.initialsecondaryweapon);
	if(!isdefined(level.survivorlethal) || level.survivorlethal == "")
	{
		level.survivorlethal = "power_tripMine";
	}

	if(!isdefined(level.survivortactical) || level.survivortactical == "")
	{
		level.survivortactical = "power_concussionGrenade";
	}

	if(!isdefined(level.infectedlethal) || level.infectedlethal == "")
	{
		level.infectedlethal = "power_throwingKnife";
	}

	if(!isdefined(level.infectedtactical) || level.infectedtactical == "")
	{
		level.infectedtactical = "none";
	}

	level.infect_allyrigs = [];
	level.infect_allyrigs[level.infect_allyrigs.size] = "archetype_assault";
	level.infect_allyrigs[level.infect_allyrigs.size] = "archetype_heavy";
	level.infect_allyrigs[level.infect_allyrigs.size] = "archetype_engineer";
	level.infect_allyrigs[level.infect_allyrigs.size] = "archetype_sniper";
	level.infect_allyrigs[level.infect_allyrigs.size] = "archetype_assassin";
	if(scripts\mp\_utility::isusingdefaultclass("allies",0))
	{
		level.infect_loadouts["allies"] = scripts\mp\_utility::getmatchrulesspecialclass("allies",0);
	}
	else
	{
		level.infect_loadouts["allies"]["loadoutPrimary"] = level.survivorprimaryweapon;
		level.infect_loadouts["allies"]["loadoutPrimaryAttachment"] = level.attachmentsurvivorprimary;
		level.infect_loadouts["allies"]["loadoutPrimaryAttachment2"] = "none";
		level.infect_loadouts["allies"]["loadoutPrimaryCamo"] = "none";
		level.infect_loadouts["allies"]["loadoutPrimaryReticle"] = "none";
		level.infect_loadouts["allies"]["loadoutSecondary"] = level.survivorsecondaryweapon;
		level.infect_loadouts["allies"]["loadoutSecondaryAttachment"] = level.attachmentsurvivorsecondary;
		level.infect_loadouts["allies"]["loadoutSecondaryAttachment2"] = level.attachmentsurvivorsecondarytwo;
		level.infect_loadouts["allies"]["loadoutSecondaryCamo"] = "none";
		level.infect_loadouts["allies"]["loadoutSecondaryReticle"] = "none";
		level.infect_loadouts["allies"]["loadoutPowerPrimary"] = level.survivorlethal;
		level.infect_loadouts["allies"]["loadoutPowerSecondary"] = level.survivortactical;
		level.infect_loadouts["allies"]["loadoutSuper"] = level.survivorsuper;
		level.infect_loadouts["allies"]["loadoutStreakType"] = "assault";
		level.infect_loadouts["allies"]["loadoutKillstreak1"] = "none";
		level.infect_loadouts["allies"]["loadoutKillstreak2"] = "none";
		level.infect_loadouts["allies"]["loadoutKillstreak3"] = "none";
		level.infect_loadouts["allies"]["loadoutJuggernaut"] = 0;
		level.infect_loadouts["allies"]["loadoutPerks"] = ["specialty_scavenger","specialty_quieter"];
		level.infect_loadouts["allies"]["loadoutGesture"] = "playerData";
		level.infect_loadouts["allies"]["loadoutRigTrait"] = "specialty_null";
		if(level.enableping)
		{
			level.infect_loadouts["allies"]["loadoutRigTrait"] = "specialty_boom";
		}
	}

	if(scripts\mp\_utility::isusingdefaultclass("axis",1))
	{
		level.infect_loadouts["axis_initial"] = scripts\mp\_utility::getmatchrulesspecialclass("axis",1);
		level.infect_loadouts["axis_initial"]["loadoutStreakType"] = "assault";
		level.infect_loadouts["axis_initial"]["loadoutKillstreak1"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutKillstreak2"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutKillstreak3"] = "none";
	}
	else
	{
		level.infect_loadouts["axis_initial"]["loadoutArchetype"] = "archetype_scout";
		level.infect_loadouts["axis_initial"]["loadoutPrimary"] = level.initialprimaryweapon;
		level.infect_loadouts["axis_initial"]["loadoutPrimaryAttachment"] = level.attachmentinitialprimary;
		level.infect_loadouts["axis_initial"]["loadoutPrimaryAttachment2"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryCamo"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryReticle"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutSecondary"] = level.initialsecondaryweapon;
		level.infect_loadouts["axis_initial"]["loadoutSecondaryAttachment"] = level.attachmentinitialsecondary;
		level.infect_loadouts["axis_initial"]["loadoutSecondaryAttachment2"] = level.attachmentinitialsecondarytwo;
		level.infect_loadouts["axis_initial"]["loadoutSecondaryCamo"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryReticle"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutPowerPrimary"] = level.infectedlethal;
		level.infect_loadouts["axis_initial"]["loadoutPowerSecondary"] = level.infectedtactical;
		level.infect_loadouts["axis_initial"]["loadoutSuper"] = level.infectedsuper;
		level.infect_loadouts["axis_initial"]["loadoutStreakType"] = "assault";
		level.infect_loadouts["axis_initial"]["loadoutKillstreak1"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutKillstreak2"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutKillstreak3"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutJuggernaut"] = 0;
		level.infect_loadouts["axis_initial"]["loadoutPerks"] = ["specialty_quieter"];
		level.infect_loadouts["axis_initial"]["loadoutGesture"] = "playerData";
		level.infect_loadouts["axis_initial"]["loadoutRigTrait"] = "specialty_null";
		if(level.enableinfectedtracker)
		{
			level.infect_loadouts["axis_initial"]["loadoutPerks"][level.infect_loadouts["axis_initial"]["loadoutPerks"].size] = "specialty_tracker";
		}
	}

	if(scripts\mp\_utility::isusingdefaultclass("axis",0))
	{
		level.infect_loadouts["axis"] = scripts\mp\_utility::getmatchrulesspecialclass("axis",0);
		level.infect_loadouts["axis"]["loadoutStreakType"] = "assault";
		level.infect_loadouts["axis"]["loadoutKillstreak1"] = "none";
		level.infect_loadouts["axis"]["loadoutKillstreak2"] = "none";
		level.infect_loadouts["axis"]["loadoutKillstreak3"] = "none";
		return;
	}

	level.infect_loadouts["axis"]["loadoutArchetype"] = "archetype_scout";
	level.infect_loadouts["axis"]["loadoutPrimary"] = level.infectedprimaryweapon;
	level.infect_loadouts["axis"]["loadoutPrimaryAttachment"] = "none";
	level.infect_loadouts["axis"]["loadoutPrimaryAttachment2"] = "none";
	level.infect_loadouts["axis"]["loadoutPrimaryCamo"] = "none";
	level.infect_loadouts["axis"]["loadoutPrimaryReticle"] = "none";
	level.infect_loadouts["axis"]["loadoutSecondary"] = level.infectedsecondaryweapon;
	level.infect_loadouts["axis"]["loadoutSecondaryAttachment"] = "none";
	level.infect_loadouts["axis"]["loadoutSecondaryAttachment2"] = "none";
	level.infect_loadouts["axis"]["loadoutSecondaryCamo"] = "none";
	level.infect_loadouts["axis"]["loadoutSecondaryReticle"] = "none";
	level.infect_loadouts["axis"]["loadoutPowerPrimary"] = level.infectedlethal;
	level.infect_loadouts["axis"]["loadoutPowerSecondary"] = level.infectedtactical;
	level.infect_loadouts["axis"]["loadoutSuper"] = level.infectedsuper;
	level.infect_loadouts["axis"]["loadoutStreakType"] = "assault";
	level.infect_loadouts["axis"]["loadoutKillstreak1"] = "none";
	level.infect_loadouts["axis"]["loadoutKillstreak2"] = "none";
	level.infect_loadouts["axis"]["loadoutKillstreak3"] = "none";
	level.infect_loadouts["axis"]["loadoutJuggernaut"] = 0;
	level.infect_loadouts["axis"]["loadoutPerks"] = ["specialty_quieter"];
	level.infect_loadouts["axis"]["loadoutGesture"] = "playerData";
	level.infect_loadouts["axis"]["loadoutRigTrait"] = "specialty_null";
	if(level.enableinfectedtracker)
	{
		level.infect_loadouts["axis"]["loadoutPerks"][level.infect_loadouts["axis"]["loadoutPerks"].size] = "specialty_tracker";
	}
}

//Function Number: 34
addsurvivorattachmentsprimary(param_00)
{
	level.attachmentsurvivorprimary = "none";
	var_01 = scripts\mp\_utility::getweapongroup(param_00);
	if(var_01 == "weapon_shotgun")
	{
		level.attachmentsurvivorprimary = "barrelrange";
		return;
	}

	if(var_01 == "weapon_assault" || var_01 == "weapon_smg" || var_01 == "weapon_lmg" || var_01 == "weapon_pistol" || param_00 == "iw7_m1c")
	{
		level.attachmentsurvivorprimary = "highcal";
	}
}

//Function Number: 35
addinitialattachmentsprimary(param_00)
{
	level.attachmentinitialprimary = "none";
	var_01 = scripts\mp\_utility::getweapongroup(param_00);
	if(var_01 == "weapon_shotgun")
	{
		level.attachmentinitialprimary = "barrelrange";
		return;
	}

	if(var_01 == "weapon_assault" || var_01 == "weapon_smg" || var_01 == "weapon_lmg" || var_01 == "weapon_pistol" || param_00 == "iw7_m1c")
	{
		level.attachmentinitialprimary = "highcal";
	}
}

//Function Number: 36
addsurvivorattachmentssecondary(param_00)
{
	level.attachmentsurvivorsecondary = "none";
	level.attachmentsurvivorsecondarytwo = "none";
	var_01 = scripts\mp\_utility::getweapongroup(param_00);
	if(var_01 == "weapon_pistol")
	{
		level.attachmentsurvivorsecondary = "highcal";
	}

	if(scripts\mp\_utility::matchmakinggame())
	{
		if(param_00 == "iw7_g18c")
		{
			level.attachmentsurvivorsecondary = "akimbo";
			level.attachmentsurvivorsecondarytwo = "highcal";
		}
	}
}

//Function Number: 37
addinitialattachmentssecondary(param_00)
{
	level.attachmentinitialsecondary = "none";
	level.attachmentinitialsecondarytwo = "none";
	var_01 = scripts\mp\_utility::getweapongroup(param_00);
	if(var_01 == "weapon_pistol")
	{
		level.attachmentinitialsecondary = "highcal";
	}

	if(scripts\mp\_utility::matchmakinggame())
	{
		if(param_00 == "iw7_g18c")
		{
			level.attachmentinitialsecondary = "akimbo";
			level.attachmentinitialsecondarytwo = "highcal";
		}
	}
}

//Function Number: 38
monitorsurvivaltime()
{
	self endon("death");
	self endon("disconnect");
	self endon("infected");
	level endon("game_ended");
	for(;;)
	{
		if(!level.infect_chosefirstinfected || !isdefined(self.survivalstarttime) || !isalive(self))
		{
			wait(0.05);
			continue;
		}

		setsurvivaltime(0);
		wait(1);
	}
}

//Function Number: 39
initsurvivaltime(param_00)
{
	scripts\mp\_utility::setextrascore0(0);
	if(isdefined(param_00) && param_00)
	{
		self notify("infected");
	}
}

//Function Number: 40
setsurvivaltime(param_00)
{
	if(!isdefined(self.survivalstarttime))
	{
		self.survivalstarttime = self.spawntime;
	}

	var_01 = int(gettime() - self.survivalstarttime / 1000);
	if(var_01 > 999)
	{
		var_01 = 999;
	}

	scripts\mp\_utility::setextrascore0(var_01);
	if(isdefined(param_00) && param_00)
	{
		self notify("infected");
	}
}

//Function Number: 41
refundinfectedsuper()
{
	var_00 = self.super;
	if(isdefined(var_00))
	{
		var_01 = scripts\mp\_supers::getsupermaxcooldownmsec() / 10;
		scripts\mp\_supers::func_DE3A(var_01);
	}
}

//Function Number: 42
setrandomrigifscout()
{
	self.infected_archtype = "archetype_scout";
	if(!isbot(self))
	{
		self.infected_archtype = scripts\mp\_class::cac_getcharacterarchetype();
	}

	if(self.infected_archtype == "archetype_scout")
	{
		self.pers["gamemodeLoadout"]["loadoutArchetype"] = level.infect_allyrigs[randomint(level.infect_allyrigs.size)];
	}
}