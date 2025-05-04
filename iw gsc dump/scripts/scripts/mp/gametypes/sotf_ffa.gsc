/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\gametypes\sotf_ffa.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 40
 * Decompile Time: 2044 ms
 * Timestamp: 10/27/2023 12:13:09 AM
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
		scripts\mp\_utility::registerscorelimitdvar(level.gametype,65);
		scripts\mp\_utility::registertimelimitdvar(level.gametype,10);
		scripts\mp\_utility::registerroundlimitdvar(level.gametype,1);
		scripts\mp\_utility::registerwinlimitdvar(level.gametype,1);
		scripts\mp\_utility::registernumlivesdvar(level.gametype,0);
		scripts\mp\_utility::registerhalftimedvar(level.gametype,0);
		level.matchrules_randomize = 0;
		level.matchrules_damagemultiplier = 0;
		level.matchrules_vampirism = 0;
	}

	setplayerloadout();
	function_01CC("ffa");
	level.teambased = 0;
	level.overridecrateusetime = 500;
	level.onplayerscore = ::onplayerscore;
	level.onprecachegametype = ::onprecachegametype;
	level.onstartgametype = ::onstartgametype;
	level.getspawnpoint = ::getspawnpoint;
	level.onspawnplayer = ::onspawnplayer;
	level.onnormaldeath = ::onnormaldeath;
	level.customcratefunc = ::sotfcratecontents;
	level.cratekill = ::cratekill;
	level.pickupweaponhandler = ::pickupweaponhandler;
	level.iconvisall = ::iconvisall;
	level.objvisall = ::objvisall;
	level.supportintel = 0;
	level.supportnuke = 0;
	level.vehicleoverride = "littlebird_neutral_mp";
	level.usedlocations = [];
	level.emptylocations = 1;
	level.assists_disabled = 1;
	if(level.matchrules_damagemultiplier || level.matchrules_vampirism)
	{
		level.modifyplayerdamage = ::scripts\mp\_damage::gamemodemodifyplayerdamage;
	}

	game["dialog"]["gametype"] = "hunted";
	if(getdvarint("g_hardcore"))
	{
		game["dialog"]["gametype"] = "hc_" + game["dialog"]["gametype"];
	}

	game["dialog"]["offense_obj"] = "sotf_hint";
	game["dialog"]["defense_obj"] = "sotf_hint";
}

//Function Number: 2
initializematchrules()
{
	scripts\mp\_utility::setcommonrulesfrommatchdata();
	setdynamicdvar("scr_sotf_ffa_crateamount",getmatchrulesdata("sotfFFAData","crateAmount"));
	setdynamicdvar("scr_sotf_ffa_crategunamount",getmatchrulesdata("sotfFFAData","crateGunAmount"));
	setdynamicdvar("scr_sotf_ffa_cratetimer",getmatchrulesdata("sotfFFAData","crateDropTimer"));
	setdynamicdvar("scr_sotf_ffa_roundlimit",1);
	scripts\mp\_utility::registerroundlimitdvar("sotf_ffa",1);
	setdynamicdvar("scr_sotf_ffa_winlimit",1);
	scripts\mp\_utility::registerwinlimitdvar("sotf_ffa",1);
	setdynamicdvar("scr_sotf_ffa_halftime",0);
	scripts\mp\_utility::registerhalftimedvar("sotf_ffa",0);
	setdynamicdvar("scr_sotf_ffa_promode",0);
}

//Function Number: 3
onprecachegametype()
{
	level._effect["signal_chest_drop"] = loadfx("vfx/iw7/_requests/mp/vfx_debug_warning.vfx");
	level._effect["signal_chest_drop_mover"] = loadfx("vfx/iw7/_requests/mp/vfx_debug_warning.vfx");
}

//Function Number: 4
onstartgametype()
{
	setclientnamemode("auto_change");
	var_00 = &"OBJECTIVES_DM";
	var_01 = &"OBJECTIVES_DM_SCORE";
	var_02 = &"OBJECTIVES_DM_HINT";
	scripts\mp\_utility::setobjectivetext("allies",var_00);
	scripts\mp\_utility::setobjectivetext("axis",var_00);
	if(level.splitscreen)
	{
		scripts\mp\_utility::setobjectivescoretext("allies",var_00);
		scripts\mp\_utility::setobjectivescoretext("axis",var_00);
	}
	else
	{
		scripts\mp\_utility::setobjectivescoretext("allies",var_01);
		scripts\mp\_utility::setobjectivescoretext("axis",var_01);
	}

	scripts\mp\_utility::setobjectivehinttext("allies",var_02);
	scripts\mp\_utility::setobjectivehinttext("axis",var_02);
	initspawns();
	var_03 = [];
	scripts\mp\_gameobjects::main(var_03);
	level thread sotf();
}

//Function Number: 5
initspawns()
{
	scripts\mp\_spawnlogic::setactivespawnlogic("FreeForAll");
	level.spawnmins = (0,0,0);
	level.spawnmaxs = (0,0,0);
	scripts\mp\_spawnlogic::addspawnpoints("allies","mp_dm_spawn");
	scripts\mp\_spawnlogic::addspawnpoints("axis","mp_dm_spawn");
	level.mapcenter = scripts\mp\_spawnlogic::findboxcenter(level.spawnmins,level.spawnmaxs);
	function_01B4(level.mapcenter);
}

//Function Number: 6
setplayerloadout()
{
	definechestweapons();
	var_00 = getrandomweapon(level.pistolarray);
	var_01 = scripts\mp\_utility::getweaponrootname(var_00["name"]);
	var_02 = tablelookup("mp/sotfWeapons.csv",2,var_01,0);
	setomnvar("ui_sotf_pistol",int(var_02));
	level.sotf_loadouts["axis"]["loadoutPrimary"] = "none";
	level.sotf_loadouts["axis"]["loadoutPrimaryAttachment"] = "none";
	level.sotf_loadouts["axis"]["loadoutPrimaryAttachment2"] = "none";
	level.sotf_loadouts["axis"]["loadoutPrimaryCamo"] = "none";
	level.sotf_loadouts["axis"]["loadoutPrimaryReticle"] = "none";
	level.sotf_loadouts["axis"]["loadoutSecondary"] = var_00["name"];
	level.sotf_loadouts["axis"]["loadoutSecondaryAttachment"] = "none";
	level.sotf_loadouts["axis"]["loadoutSecondaryAttachment2"] = "none";
	level.sotf_loadouts["axis"]["loadoutSecondaryCamo"] = "none";
	level.sotf_loadouts["axis"]["loadoutSecondaryReticle"] = "none";
	level.sotf_loadouts["axis"]["loadoutEquipment"] = "throwingknife_mp";
	level.sotf_loadouts["axis"]["loadoutOffhand"] = "flash_grenade_mp";
	level.sotf_loadouts["axis"]["loadoutStreakType"] = "assault";
	level.sotf_loadouts["axis"]["loadoutKillstreak1"] = "none";
	level.sotf_loadouts["axis"]["loadoutKillstreak2"] = "none";
	level.sotf_loadouts["axis"]["loadoutKillstreak3"] = "none";
	level.sotf_loadouts["axis"]["loadoutJuggernaut"] = 0;
	level.sotf_loadouts["axis"]["loadoutPerks"] = ["specialty_longersprint","specialty_extra_deadly"];
	level.sotf_loadouts["allies"] = level.sotf_loadouts["axis"];
}

//Function Number: 7
getspawnpoint()
{
	var_00 = scripts\mp\_spawnlogic::getteamspawnpoints(self.team);
	if(level.ingraceperiod)
	{
		var_01 = scripts\mp\_spawnlogic::getspawnpoint_random(var_00);
	}
	else
	{
		var_01 = scripts\mp\_spawnscoring::getspawnpoint(var_01);
	}

	return var_01;
}

//Function Number: 8
onspawnplayer()
{
	self.pers["class"] = "gamemode";
	self.pers["lastClass"] = "";
	self.class = self.pers["class"];
	self.lastclass = self.pers["lastClass"];
	self.pers["gamemodeLoadout"] = level.sotf_loadouts[self.pers["team"]];
	level notify("sotf_player_spawned",self);
	if(!isdefined(self.eventvalue))
	{
		self.eventvalue = scripts\mp\_rank::getscoreinfovalue("kill");
		scripts\mp\_utility::setextrascore0(self.eventvalue);
	}

	self.oldprimarygun = undefined;
	self.newprimarygun = undefined;
	thread waitloadoutdone();
}

//Function Number: 9
waitloadoutdone()
{
	level endon("game_ended");
	self endon("disconnect");
	self waittill("giveLoadout");
	var_00 = self getcurrentweapon();
	self setweaponammostock(var_00,0);
	self.oldprimarygun = var_00;
	thread pickupweaponhandler();
}

//Function Number: 10
onplayerscore(param_00,param_01)
{
	param_01.var_4D = param_01 scripts\mp\_utility::getpersstat("longestStreak");
	if(param_00 != "super_kill" && issubstr(param_00,"kill"))
	{
		var_02 = scripts\mp\_rank::getscoreinfovalue("score_increment");
		return var_02;
	}

	return 0;
}

//Function Number: 11
onnormaldeath(param_00,param_01,param_02,param_03,param_04)
{
	scripts\mp\gametypes\common::onnormaldeath(param_00,param_01,param_02,param_03,param_04);
	param_01 perkwatcher();
	var_05 = 0;
	foreach(var_07 in level.players)
	{
		if(isdefined(var_07.destroynavrepulsor) && var_07.destroynavrepulsor > var_05)
		{
			var_05 = var_07.destroynavrepulsor;
		}
	}
}

//Function Number: 12
sotf()
{
	level thread startspawnchest();
}

//Function Number: 13
startspawnchest()
{
	level endon("game_ended");
	self endon("disconnect");
	var_00 = getdvarint("scr_sotf_ffa_crateamount",3);
	var_01 = getdvarint("scr_sotf_ffa_cratetimer",30);
	level waittill("sotf_player_spawned",var_02);
	for(;;)
	{
		if(!isalive(var_02))
		{
			var_02 = findnewowner(level.players);
			if(!isdefined(var_02))
			{
				continue;
			}

			continue;
		}

		while(isalive(var_02))
		{
			if(level.emptylocations)
			{
				for(var_03 = 0;var_03 < var_00;var_03++)
				{
					level thread spawnchests(var_02);
				}

				level thread showcratesplash("sotf_crates_incoming");
				wait(var_01);
				continue;
			}

			wait(0.05);
		}
	}
}

//Function Number: 14
showcratesplash(param_00)
{
	foreach(var_02 in level.players)
	{
		var_02 thread scripts\mp\_hud_message::showsplash(param_00);
	}
}

//Function Number: 15
findnewowner(param_00)
{
	foreach(var_02 in param_00)
	{
		if(isalive(var_02))
		{
			return var_02;
		}
	}

	level waittill("sotf_player_spawned",var_04);
	return var_04;
}

//Function Number: 16
spawnchests(param_00)
{
	var_01 = scripts\engine\utility::getstructarray("sotf_chest_spawnpoint","targetname");
	var_02 = getrandompoint(var_01);
	if(isdefined(var_02))
	{
		playfxatpoint(var_02);
		level thread scripts\mp\killstreaks\_airdrop::doflyby(param_00,var_02,randomfloat(360),"airdrop_sotf");
	}
}

//Function Number: 17
playfxatpoint(param_00)
{
	var_01 = param_00 + (0,0,30);
	var_02 = param_00 + (0,0,-1000);
	var_03 = bullettrace(var_01,var_02,0,undefined);
	var_04 = var_03["position"] + (0,0,1);
	var_05 = var_03["entity"];
	if(isdefined(var_05))
	{
		for(var_06 = var_05 getlinkedparent();isdefined(var_06);var_06 = var_05 getlinkedparent())
		{
			var_05 = var_06;
		}
	}

	if(isdefined(var_05))
	{
		var_07 = spawn("script_model",var_04);
		var_07 setmodel("tag_origin");
		var_07.angles = (90,randomintrange(-180,179),0);
		var_07 linkto(var_05);
		thread playlinkedsmokeeffect(scripts\engine\utility::getfx("signal_chest_drop_mover"),var_07);
		return;
	}

	playfx(scripts\engine\utility::getfx("signal_chest_drop"),var_04);
}

//Function Number: 18
playlinkedsmokeeffect(param_00,param_01)
{
	level endon("game_ended");
	wait(0.05);
	playfxontag(param_00,param_01,"tag_origin");
	wait(6);
	stopfxontag(param_00,param_01,"tag_origin");
	wait(0.05);
	param_01 delete();
}

//Function Number: 19
getcenterpoint(param_00)
{
	var_01 = undefined;
	var_02 = undefined;
	foreach(var_04 in param_00)
	{
		var_05 = distance2dsquared(level.mapcenter,var_04.origin);
		if(!isdefined(var_01) || var_05 < var_02)
		{
			var_01 = var_04;
			var_02 = var_05;
		}
	}

	level.usedlocations[level.usedlocations.size] = var_01.origin;
	return var_01.origin;
}

//Function Number: 20
getrandompoint(param_00)
{
	var_01 = [];
	for(var_02 = 0;var_02 < param_00.size;var_02++)
	{
		var_03 = 0;
		if(isdefined(level.usedlocations) && level.usedlocations.size > 0)
		{
			foreach(var_05 in level.usedlocations)
			{
				if(param_00[var_02].origin == var_05)
				{
					var_03 = 1;
					break;
				}
			}

			if(var_03)
			{
				continue;
			}

			var_01[var_01.size] = param_00[var_02].origin;
			continue;
		}

		var_01[var_01.size] = param_00[var_02].origin;
	}

	if(var_01.size > 0)
	{
		var_07 = randomint(var_01.size);
		var_08 = var_01[var_07];
		level.usedlocations[level.usedlocations.size] = var_08;
		return var_08;
	}

	level.emptylocations = 0;
	return undefined;
}

//Function Number: 21
definechestweapons()
{
	var_00 = [];
	var_01 = [];
	for(var_02 = 0;tablelookupbyrow("mp/sotfWeapons.csv",var_02,0) != "";var_02++)
	{
		var_03 = tablelookupbyrow("mp/sotfWeapons.csv",var_02,2);
		var_04 = tablelookupbyrow("mp/sotfWeapons.csv",var_02,1);
		var_05 = isselectableweapon(var_03);
		if(isdefined(var_04) && var_05 && var_04 == "weapon_pistol")
		{
			var_06 = 30;
			var_00[var_00.size]["name"] = var_03;
			var_00[var_00.size - 1]["weight"] = var_06;
			continue;
		}

		if(isdefined(var_04) && var_05 && var_04 == "weapon_shotgun" || var_04 == "weapon_smg" || var_04 == "weapon_assault" || var_04 == "weapon_sniper" || var_04 == "weapon_dmr" || var_04 == "weapon_lmg" || var_04 == "weapon_projectile")
		{
			var_06 = 0;
			switch(var_04)
			{
				case "weapon_shotgun":
					var_06 = 35;
					break;

				case "weapon_assault":
				case "weapon_smg":
					var_06 = 25;
					break;

				case "weapon_dmr":
				case "weapon_sniper":
					var_06 = 15;
					break;

				case "weapon_lmg":
					var_06 = 10;
					break;

				case "weapon_projectile":
					var_06 = 30;
					break;
			}

			var_01[var_01.size]["name"] = var_03 + "_mp";
			var_01[var_01.size - 1]["group"] = var_04;
			var_01[var_01.size - 1]["weight"] = var_06;
			continue;
		}

		continue;
	}

	var_01 = sortbyweight(var_01);
	level.pistolarray = var_00;
	level.weaponarray = var_01;
}

//Function Number: 22
sotfcratecontents(param_00,param_01)
{
	scripts\mp\killstreaks\_airdrop::addcratetype("airdrop_sotf","sotf_weapon",100,::sotfcratethink,param_00,param_00,&"KILLSTREAKS_HINTS_WEAPON_PICKUP");
}

//Function Number: 23
sotfcratethink(param_00)
{
	self endon("death");
	self endon("restarting_physics");
	level endon("game_ended");
	if(isdefined(game["strings"][self.cratetype + "_hint"]))
	{
		var_01 = game["strings"][self.cratetype + "_hint"];
	}
	else
	{
		var_01 = &"PLATFORM_GET_KILLSTREAK";
	}

	var_02 = "icon_hunted";
	scripts\mp\killstreaks\_airdrop::cratesetupforuse(var_01,var_02);
	thread scripts\mp\killstreaks\_airdrop::crateallcapturethink();
	childthread cratewatcher(60);
	childthread playerjoinwatcher();
	var_03 = 0;
	var_04 = getdvarint("scr_sotf_ffa_crategunamount",1);
	for(;;)
	{
		self waittill("captured",var_05);
		var_05 playlocalsound("ammo_crate_use");
		var_06 = getrandomweapon(level.weaponarray);
		var_06 = getrandomattachments(var_06);
		var_07 = var_05.lastdroppableweaponobj;
		var_08 = var_05 getrunningforwardpainanim(var_07);
		if(var_06 == var_07)
		{
			var_05 givestartammo(var_06);
			var_05 setweaponammostock(var_06,var_08);
		}
		else
		{
			if(isdefined(var_07) && var_07 != "none")
			{
				var_09 = var_05 dropitem(var_07);
				if(isdefined(var_09) && var_08 > 0)
				{
					var_09.var_336 = "dropped_weapon";
				}
			}

			var_05 giveweapon(var_06,0,0,0,1);
			var_05 setweaponammostock(var_06,0);
			var_05 scripts\mp\_utility::_switchtoweaponimmediate(var_06);
			if(var_05 getweaponammoclip(var_06) == 1)
			{
				var_05 setweaponammostock(var_06,1);
			}

			var_05.oldprimarygun = var_06;
		}

		var_03++;
		var_04 = var_04 - 1;
		if(var_04 > 0)
		{
			foreach(var_05 in level.players)
			{
				scripts\mp\_entityheadicons::setheadicon(var_05,"blitz_time_0" + var_04 + "_blue",(0,0,24),14,14,undefined,undefined,undefined,undefined,undefined,0);
				self.crateheadicon = "blitz_time_0" + var_04 + "_blue";
			}
		}

		if(self.cratetype == "sotf_weapon" && var_03 == getdvarint("scr_sotf_ffa_crategunamount",1))
		{
			scripts\mp\killstreaks\_airdrop::deletecrateold();
		}
	}
}

//Function Number: 24
cratewatcher(param_00)
{
	wait(param_00);
	while(isdefined(self.inuse) && self.inuse)
	{
		scripts\engine\utility::waitframe();
	}

	scripts\mp\killstreaks\_airdrop::deletecrateold();
}

//Function Number: 25
playerjoinwatcher()
{
	for(;;)
	{
		level waittill("connected",var_00);
		if(!isdefined(var_00))
		{
			continue;
		}

		scripts\mp\_entityheadicons::setheadicon(var_00,self.crateheadicon,(0,0,24),14,14,undefined,undefined,undefined,undefined,undefined,0);
	}
}

//Function Number: 26
cratekill(param_00)
{
	for(var_01 = 0;var_01 < level.usedlocations.size;var_01++)
	{
		if(param_00 != level.usedlocations[var_01])
		{
			continue;
		}

		level.usedlocations = scripts\engine\utility::array_remove(level.usedlocations,param_00);
	}

	level.emptylocations = 1;
}

//Function Number: 27
isselectableweapon(param_00)
{
	var_01 = tablelookup("mp/sotfWeapons.csv",2,param_00,3);
	var_02 = tablelookup("mp/sotfWeapons.csv",2,param_00,4);
	if(var_01 == "TRUE" && var_02 == "" || getdvarint(var_02,0) == 1)
	{
		return 1;
	}

	return 0;
}

//Function Number: 28
getrandomweapon(param_00)
{
	var_01 = setbucketval(param_00);
	var_02 = randomint(level.weaponmaxval["sum"]);
	var_03 = undefined;
	for(var_04 = 0;var_04 < var_01.size;var_04++)
	{
		if(!var_01[var_04]["weight"])
		{
			continue;
		}

		if(var_01[var_04]["weight"] > var_02)
		{
			var_03 = var_01[var_04];
			break;
		}
	}

	return var_03;
}

//Function Number: 29
getrandomattachments(param_00)
{
	var_01 = [];
	var_02 = [];
	var_03 = [];
	var_04 = scripts\mp\_utility::getweaponrootname(param_00["name"]);
	var_05 = scripts\mp\_utility::getweaponattachmentarrayfromstats(var_04);
	if(var_05.size > 0)
	{
		var_06 = randomint(5);
		for(var_07 = 0;var_07 < var_06;var_07++)
		{
			var_01 = getvalidattachments(param_00,var_02,var_05);
			if(var_01.size == 0)
			{
				break;
			}

			var_08 = randomint(var_01.size);
			var_02[var_02.size] = var_01[var_08];
			var_09 = scripts\mp\_utility::attachmentmap_tounique(var_01[var_08],var_04);
			var_03[var_03.size] = var_09;
		}

		var_0A = scripts\mp\_utility::getweapongroup(param_00["name"]);
		if(var_0A == "weapon_dmr" || var_0A == "weapon_sniper" || var_04 == "iw6_dlcweap02")
		{
			var_0B = 0;
			foreach(var_0D in var_02)
			{
				if(scripts\mp\_utility::getattachmenttype(var_0D) == "rail")
				{
					var_0B = 1;
					break;
				}
			}

			if(!var_0B)
			{
				var_0F = strtok(var_04,"_")[1];
				var_03[var_03.size] = var_0F + "scope";
			}
		}

		if(var_03.size > 0)
		{
			var_03 = scripts\engine\utility::alphabetize(var_03);
			foreach(var_11 in var_03)
			{
				param_00["name"] = param_00["name"] + "_" + var_11;
			}
		}
	}

	return param_00["name"];
}

//Function Number: 30
getvalidattachments(param_00,param_01,param_02)
{
	var_03 = [];
	foreach(var_05 in param_02)
	{
		if(var_05 == "gl" || var_05 == "shotgun")
		{
			continue;
		}

		var_06 = attachmentcheck(var_05,param_01);
		if(!var_06)
		{
			continue;
		}

		var_03[var_03.size] = var_05;
	}

	return var_03;
}

//Function Number: 31
attachmentcheck(param_00,param_01)
{
	for(var_02 = 0;var_02 < param_01.size;var_02++)
	{
		if(param_00 == param_01[var_02] || !scripts\mp\_utility::attachmentscompatible(param_00,param_01[var_02]))
		{
			return 0;
		}
	}

	return 1;
}

//Function Number: 32
checkscopes(param_00)
{
	foreach(var_02 in param_00)
	{
		if(var_02 == "thermal" || var_02 == "vzscope" || var_02 == "acog" || var_02 == "ironsight")
		{
			return 1;
		}
	}

	return 0;
}

//Function Number: 33
pickupweaponhandler()
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	for(;;)
	{
		scripts\engine\utility::waitframe();
		var_00 = self getweaponslistprimaries();
		if(var_00.size > 1)
		{
			foreach(var_02 in var_00)
			{
				if(var_02 == self.oldprimarygun)
				{
					var_03 = self getrunningforwardpainanim(var_02);
					var_04 = self dropitem(var_02);
					if(isdefined(var_04) && var_03 > 0)
					{
						var_04.var_336 = "dropped_weapon";
					}

					break;
				}
			}

			var_00 = scripts\engine\utility::array_remove(var_00,self.oldprimarygun);
			self.oldprimarygun = var_00[0];
		}
	}
}

//Function Number: 34
loginckillchain()
{
	self.pers["killChains"]++;
	scripts\mp\_persistence::statsetchild("round","killChains",self.pers["killChains"]);
}

//Function Number: 35
perkwatcher()
{
	if(level.allowperks)
	{
		switch(self.streakpoints)
		{
			case 2:
				scripts\mp\_utility::giveperk("specialty_fastsprintrecovery");
				thread scripts\mp\_hud_message::showsplash("specialty_fastsprintrecovery_sotf",self.streakpoints);
				thread loginckillchain();
				break;

			case 3:
				scripts\mp\_utility::giveperk("specialty_lightweight");
				thread scripts\mp\_hud_message::showsplash("specialty_lightweight_sotf",self.streakpoints);
				thread loginckillchain();
				break;

			case 4:
				scripts\mp\_utility::giveperk("specialty_stalker");
				thread scripts\mp\_hud_message::showsplash("specialty_stalker_sotf",self.streakpoints);
				thread loginckillchain();
				break;

			case 5:
				scripts\mp\_utility::giveperk("specialty_regenfaster");
				thread scripts\mp\_hud_message::showsplash("specialty_regenfaster_sotf",self.streakpoints);
				thread loginckillchain();
				break;

			case 6:
				scripts\mp\_utility::giveperk("specialty_deadeye");
				thread scripts\mp\_hud_message::showsplash("specialty_deadeye_sotf",self.streakpoints);
				thread loginckillchain();
				break;
		}
	}
}

//Function Number: 36
iconvisall(param_00,param_01)
{
	foreach(var_03 in level.players)
	{
		param_00 scripts\mp\_entityheadicons::setheadicon(var_03,param_01,(0,0,24),14,14,undefined,undefined,undefined,undefined,undefined,0);
		self.crateheadicon = param_01;
	}
}

//Function Number: 37
objvisall(param_00)
{
	scripts\mp\objidpoolmanager::minimap_objective_playermask_showtoall(param_00);
}

//Function Number: 38
setbucketval(param_00)
{
	level.weaponmaxval["sum"] = 0;
	var_01 = param_00;
	for(var_02 = 0;var_02 < var_01.size;var_02++)
	{
		if(!var_01[var_02]["weight"])
		{
			continue;
		}

		level.weaponmaxval["sum"] = level.weaponmaxval["sum"] + var_01[var_02]["weight"];
		var_01[var_02]["weight"] = level.weaponmaxval["sum"];
	}

	return var_01;
}

//Function Number: 39
sortbyweight(param_00)
{
	var_01 = [];
	var_02 = [];
	for(var_03 = 1;var_03 < param_00.size;var_03++)
	{
		var_04 = param_00[var_03]["weight"];
		var_01 = param_00[var_03];
		for(var_05 = var_03 - 1;var_05 >= 0 && is_weight_a_less_than_b(param_00[var_05]["weight"],var_04);var_05--)
		{
			var_02 = param_00[var_05];
			param_00[var_05] = var_01;
			param_00[var_05 + 1] = var_02;
		}
	}

	return param_00;
}

//Function Number: 40
is_weight_a_less_than_b(param_00,param_01)
{
	return param_00 < param_01;
}