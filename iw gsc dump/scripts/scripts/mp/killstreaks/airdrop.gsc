/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\killstreaks\airdrop.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 112
 * Decompile Time: 5067 ms
 * Timestamp: 10/27/2023 12:28:06 AM
*******************************************************************/

//Function Number: 1
init()
{
	level._effect["airdrop_crate_destroy"] = loadfx("vfx/iw7/core/mp/killstreaks/vfx_dp_pickup_dust.vfx");
	level._effect["airdrop_dust_kickup"] = loadfx("vfx/iw7/core/mp/killstreaks/vfx_dp_pickup_dust.vfx");
	level._effect["drone_explode"] = loadfx("vfx/iw7/core/mp/killstreaks/vfx_dp_exp.vfx");
	level._effect["crate_explode"] = loadfx("vfx/iw7/_requests/mp/killstreak/vfx_drone_pkg_exp_vari.vfx");
	precachempanim("juggernaut_carepackage");
	setairdropcratecollision("airdrop_crate");
	setairdropcratecollision("care_package");
	scripts\mp\killstreaks\_killstreaks::registerkillstreak("dronedrop",::func_1AA2,undefined,undefined,::tryuseairdrop,undefined,::func_1A9F);
	var_00 = ["passive_bomb_trap","passive_decreased_cost","passive_increased_cost","passive_reroll","passive_high_roller","passive_low_roller"];
	scripts\mp\_killstreak_loot::func_DF07("dronedrop",var_00);
	level.numdropcrates = 0;
	level.littlebirds = [];
	level.cratetypes = [];
	level.cratemaxval = [];
	addcratetype("dronedrop","venom",85,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_VENOM_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("dronedrop","uav",85,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_UAV_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("dronedrop","counter_uav",70,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_COUNTER_UAV_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("dronedrop","drone_hive",70,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_ORBITAL_DEPLOYMENT_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("dronedrop","ball_drone_backup",65,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_BALL_DRONE_BACKUP_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("dronedrop","bombardment",65,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_BOMBARDMENT_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("dronedrop","precision_airstrike",65,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_PRECISION_AIRSTRIKE_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("dronedrop","sentry_shock",45,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_SENTRY_SHOCK_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("dronedrop","jackal",25,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_JACKAL_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("dronedrop","thor",10,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_THOR_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("dronedrop","directional_uav",5,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_DIRECTIONAL_UAV_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("dronedrop","remote_c8",5,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_RC8_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("dronedrop","minijackal",5,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_MINI_JACKAL_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("dronedrop_grnd","venom",35,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_VENOM_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("dronedrop_grnd","uav",30,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_UAV_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("dronedrop_grnd","counter_uav",25,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_COUNTER_UAV_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("dronedrop_grnd","drone_hive",25,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_ORBITAL_DEPLOYMENT_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("dronedrop_grnd","ball_drone_backup",25,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_BALL_DRONE_BACKUP_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("dronedrop_grnd","bombardment",20,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_BOMBARDMENT_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("dronedrop_grnd","precision_airstrike",20,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_PRECISION_AIRSTRIKE_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("dronedrop_grnd","sentry_shock",15,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_SENTRY_SHOCK_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("dronedrop_trap","bomb_trap",100,::killstreakbombcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",undefined,undefined,"care_package_iw7_dummy");
	addcratetype("dronedrop_reroll","venom",85,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",undefined,&"KILLSTREAKS_HINTS_VENOM_REROLL","care_package_iw7_dummy");
	addcratetype("dronedrop_reroll","uav",85,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",undefined,&"KILLSTREAKS_HINTS_UAV_REROLL","care_package_iw7_dummy");
	addcratetype("dronedrop_reroll","counter_uav",70,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",undefined,&"KILLSTREAKS_HINTS_COUNTER_UAV_REROLL","care_package_iw7_dummy");
	addcratetype("dronedrop_reroll","drone_hive",70,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",undefined,&"KILLSTREAKS_HINTS_ORBITAL_DEPLOYMENT_REROLL","care_package_iw7_dummy");
	addcratetype("dronedrop_reroll","ball_drone_backup",65,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",undefined,&"KILLSTREAKS_HINTS_BALL_DRONE_BACKUP_REROLL","care_package_iw7_dummy");
	addcratetype("dronedrop_reroll","bombardment",65,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",undefined,&"KILLSTREAKS_HINTS_BOMBARDMENT_REROLL","care_package_iw7_dummy");
	addcratetype("dronedrop_reroll","precision_airstrike",65,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",undefined,&"KILLSTREAKS_HINTS_PRECISION_AIRSTRIKE_REROLL","care_package_iw7_dummy");
	addcratetype("dronedrop_reroll","sentry_shock",5,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",undefined,&"KILLSTREAKS_HINTS_SENTRY_SHOCK_REROLL","care_package_iw7_dummy");
	addcratetype("dronedrop_reroll","jackal",5,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",undefined,&"KILLSTREAKS_HINTS_JACKAL_REROLL","care_package_iw7_dummy");
	addcratetype("dronedrop_reroll","thor",5,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",undefined,&"KILLSTREAKS_HINTS_THOR_REROLL","care_package_iw7_dummy");
	addcratetype("dronedrop_reroll","directional_uav",1,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",undefined,&"KILLSTREAKS_HINTS_DIRECTIONAL_UAV_REROLL","care_package_iw7_dummy");
	addcratetype("dronedrop_reroll","remote_c8",1,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",undefined,&"KILLSTREAKS_HINTS_RC8_REROLL","care_package_iw7_dummy");
	addcratetype("dronedrop_reroll","minijackal",1,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",undefined,&"KILLSTREAKS_HINTS_MINI_JACKAL_REROLL","care_package_iw7_dummy");
	addcratetype("dronedrop_highroll","sentry_shock",15,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_SENTRY_SHOCK_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("dronedrop_highroll","jackal",15,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_JACKAL_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("dronedrop_highroll","thor",10,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_THOR_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("dronedrop_highroll","directional_uav",10,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_DIRECTIONAL_UAV_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("dronedrop_highroll","remote_c8",5,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_RC8_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("dronedrop_highroll","minijackal",5,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_MINI_JACKAL_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("jackaldrop","venom",85,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_VENOM_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("jackaldrop","uav",85,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_UAV_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("jackaldrop","counter_uav",70,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_COUNTER_UAV_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("jackaldrop","drone_hive",70,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_ORBITAL_DEPLOYMENT_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("jackaldrop","ball_drone_backup",65,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_BALL_DRONE_BACKUP_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("jackaldrop","bombardment",65,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_BOMBARDMENT_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("jackaldrop","precision_airstrike",65,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_PRECISION_AIRSTRIKE_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("jackaldrop","sentry_shock",5,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_SENTRY_SHOCK_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("jackaldrop","jackal",5,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_JACKAL_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("jackaldrop","thor",5,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_THOR_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("jackaldrop","directional_uav",1,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_DIRECTIONAL_UAV_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("jackaldrop","remote_c8",1,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_RC8_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("jackaldrop","minijackal",1,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_MINI_JACKAL_PICKUP",undefined,"care_package_iw7_dummy");
	if(isdefined(level.customcratefunc))
	{
		[[ level.customcratefunc ]]("care_package_iw7_un_wm","care_package_iw7_ca_wm");
	}

	if(isdefined(level.mapcustomcratefunc))
	{
		[[ level.mapcustomcratefunc ]]();
	}

	generatemaxweightedcratevalue();
	var_01 = spawnstruct();
	var_01.scorepopup = "destroyed_airdrop";
	var_01.vodestroyed = "dronedrop_destroyed";
	var_01.callout = "callout_destroyed_airdrop";
	var_01.samdamagescale = 0.09;
	level.heliconfigs["airdrop"] = var_01;
	scripts\mp\_rank::registerscoreinfo("little_bird","value",200);
	level setupcaptureflares();
	level.carepackagedropnodes = getentarray("carepackage_drop_area","targetname");
}

//Function Number: 2
generatemaxweightedcratevalue()
{
	foreach(var_06, var_01 in level.cratetypes)
	{
		level.cratemaxval[var_06] = 0;
		foreach(var_03 in var_01)
		{
			var_04 = var_03.type;
			if(!level.cratetypes[var_06][var_04].raw_weight)
			{
				level.cratetypes[var_06][var_04].weight = level.cratetypes[var_06][var_04].raw_weight;
				continue;
			}

			level.cratemaxval[var_06] = level.cratemaxval[var_06] + level.cratetypes[var_06][var_04].raw_weight;
			level.cratetypes[var_06][var_04].weight = level.cratemaxval[var_06];
		}
	}
}

//Function Number: 3
changecrateweight(param_00,param_01,param_02)
{
	if(!isdefined(level.cratetypes[param_00]) || !isdefined(level.cratetypes[param_00][param_01]))
	{
		return;
	}

	level.cratetypes[param_00][param_01].raw_weight = param_02;
	generatemaxweightedcratevalue();
}

//Function Number: 4
setairdropcratecollision(param_00)
{
	var_01 = getentarray(param_00,"targetname");
	if(!isdefined(var_01) || var_01.size == 0)
	{
		return;
	}

	level.airdropcratecollision = getent(var_01[0].target,"targetname");
	foreach(var_03 in var_01)
	{
		var_03 deletecrateold();
	}
}

//Function Number: 5
addcratetype(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08)
{
	if(!isdefined(param_04))
	{
		param_04 = "care_package_iw7_un_wm";
	}

	if(!isdefined(param_05))
	{
		param_05 = "care_package_iw7_ca_wm";
	}

	if(!isdefined(param_08))
	{
		param_08 = "care_package_iw7_dummy";
	}

	level.cratetypes[param_00][param_01] = spawnstruct();
	level.cratetypes[param_00][param_01].droptype = param_00;
	level.cratetypes[param_00][param_01].type = param_01;
	level.cratetypes[param_00][param_01].raw_weight = param_02;
	level.cratetypes[param_00][param_01].weight = param_02;
	level.cratetypes[param_00][param_01].func = param_03;
	level.cratetypes[param_00][param_01].model_name_friendly = param_04;
	level.cratetypes[param_00][param_01].model_name_enemy = param_05;
	level.cratetypes[param_00][param_01].model_name_dummy = param_08;
	if(isdefined(param_06))
	{
		game["strings"][param_01 + "_hint"] = param_06;
	}

	if(isdefined(param_07))
	{
		game["strings"][param_01 + "_rerollHint"] = param_07;
	}
}

//Function Number: 6
getrandomcratetype(param_00)
{
	var_01 = randomint(level.cratemaxval[param_00]);
	var_02 = undefined;
	foreach(var_04 in level.cratetypes[param_00])
	{
		var_05 = var_04.type;
		if(!level.cratetypes[param_00][var_05].weight)
		{
			continue;
		}

		var_02 = var_05;
		if(level.cratetypes[param_00][var_05].weight > var_01)
		{
			break;
		}
	}

	return var_02;
}

//Function Number: 7
getcratetypefordroptype(param_00)
{
	switch(param_00)
	{
		case "airdrop_sentry_minigun":
			return "sentry";

		case "airdrop_predator_missile":
			return "predator_missile";

		case "airdrop_juggernaut":
			return "airdrop_juggernaut";

		case "airdrop_juggernaut_def":
			return "airdrop_juggernaut_def";

		case "airdrop_juggernaut_gl":
			return "airdrop_juggernaut_gl";

		case "airdrop_juggernaut_recon":
			return "airdrop_juggernaut_recon";

		case "airdrop_juggernaut_maniac":
			return "airdrop_juggernaut_maniac";

		case "airdrop_remote_tank":
			return "remote_tank";

		case "airdrop_lase":
			return "lasedStrike";

		case "dronedrop_trap":
			return "bomb_trap";

		case "airdrop_sotf":
		case "airdrop_grnd_mega":
		case "airdrop_grnd":
		case "airdrop_mega":
		case "airdrop_escort":
		case "airdrop_support":
		case "dronedrop_highroll":
		case "jackaldrop":
		case "dronedrop_reroll":
		case "dronedrop_grnd":
		case "airdrop_assault":
		case "airdrop":
		case "dronedrop":
		default:
			if(isdefined(level.getrandomcratetypeforgamemode))
			{
				return [[ level.getrandomcratetypeforgamemode ]](param_00);
			}
			return getrandomcratetype(param_00);
	}
}

//Function Number: 8
tryuseairdrop(param_00)
{
	var_01 = param_00.streakname;
	var_02 = var_01;
	var_03 = undefined;
	if(!isdefined(var_02))
	{
		var_02 = "airdrop";
	}

	var_04 = 1;
	if((level.littlebirds.size >= 4 || level.fauxvehiclecount >= 4) && var_02 != "airdrop_mega" && !issubstr(tolower(var_02),"juggernaut"))
	{
		scripts\mp\_hud_message::showerrormessage("KILLSTREAKS_AIR_SPACE_TOO_CROWDED");
		return 0;
	}
	else if(scripts\mp\_utility::currentactivevehiclecount() >= scripts\mp\_utility::maxvehiclesallowed() || level.fauxvehiclecount + var_04 >= scripts\mp\_utility::maxvehiclesallowed())
	{
		scripts\mp\_hud_message::showerrormessage("KILLSTREAKS_TOO_MANY_VEHICLES");
		return 0;
	}
	else if(var_02 == "airdrop_lase" && isdefined(level.lasedstrikecrateactive) && level.lasedstrikecrateactive)
	{
		scripts\mp\_hud_message::showerrormessage("KILLSTREAKS_AIR_SPACE_TOO_CROWDED");
		return 0;
	}

	return 1;
}

//Function Number: 9
func_1AA2(param_00)
{
	param_00.var_1AA0 = param_00.streakname;
	scripts\mp\_utility::incrementfauxvehiclecount();
	var_01 = scripts\mp\killstreaks\_target_marker::_meth_819B(param_00);
	if(!isdefined(var_01.location))
	{
		scripts\mp\_utility::decrementfauxvehiclecount();
		return 0;
	}

	scripts\mp\_matchdata::logkillstreakevent(param_00.var_1AA0,self.origin);
	func_1AA1(var_01,param_00.var_1AA0,param_00);
	return 1;
}

//Function Number: 10
func_1AA1(param_00,param_01,param_02)
{
	switch(param_01)
	{
		case "dronedrop":
			level func_581F(self,param_00,randomfloat(360),param_01,param_02);
			break;
	}
}

//Function Number: 11
func_1A9E(param_00,param_01)
{
	param_01 thread airdropdetonateonstuck();
	param_01.triggerportableradarping = self;
	param_00.var_1AA0 = param_00.streakname;
	scripts\mp\_utility::incrementfauxvehiclecount();
	thread func_4FC3();
	param_01 thread airdropmarkeractivate(param_00.var_1AA0);
	scripts\mp\_matchdata::logkillstreakevent(param_00.var_1AA0,self.origin);
	param_00.var_1A9E = 1;
	return 1;
}

//Function Number: 12
airdropmarkeractivate(param_00,param_01)
{
	level endon("game_ended");
	self notify("airDropMarkerActivate");
	self endon("airDropMarkerActivate");
	self waittill("explode",var_02);
	var_03 = self.triggerportableradarping;
	if(!isdefined(var_03))
	{
		return;
	}

	if(var_03 scripts\mp\_utility::iskillstreakdenied())
	{
		return;
	}

	if(issubstr(tolower(param_00),"escort_airdrop") && isdefined(level.chopper))
	{
		return;
	}

	wait(0.05);
	if(issubstr(tolower(param_00),"juggernaut"))
	{
		level doc130flyby(var_03,var_02,randomfloat(360),param_00);
		return;
	}

	if(issubstr(tolower(param_00),"escort_airdrop"))
	{
		var_03 scripts\mp\killstreaks\_escortairdrop::func_6CE4(param_01,var_02,randomfloat(360),"escort_airdrop");
		return;
	}

	if(param_00 == "dronedrop")
	{
		level func_581F(var_03,var_02,randomfloat(360),param_00);
		return;
	}

	level doflyby(var_03,var_02,randomfloat(360),param_00);
}

//Function Number: 13
func_1A9F(param_00)
{
	if(isdefined(param_00.var_1AA0) && !issubstr(param_00.var_1AA0,"juggernaut") && !scripts\mp\_utility::istrue(param_00.var_1A9E))
	{
		scripts\mp\_utility::decrementfauxvehiclecount();
	}
}

//Function Number: 14
func_4FC3()
{
	self endon("airDropMarkerActivate");
	self waittill("death");
	scripts\mp\_utility::decrementfauxvehiclecount();
}

//Function Number: 15
initairdropcrate()
{
	self.inuse = 0;
	self hide();
	if(isdefined(self.target))
	{
		self.collision = getent(self.target,"targetname");
		self.collision notsolid();
		return;
	}

	self.collision = undefined;
}

//Function Number: 16
deleteonownerdeath(param_00)
{
	wait(0.25);
	self linkto(param_00,"tag_origin",(0,0,0),(0,0,0));
	param_00 waittill("death");
	self delete();
}

//Function Number: 17
crateteammodelupdater()
{
	self endon("death");
	self hide();
	foreach(var_01 in level.players)
	{
		if(var_01.team != "spectator")
		{
			self showtoplayer(var_01);
		}
	}

	for(;;)
	{
		level waittill("joined_team");
		self hide();
		foreach(var_01 in level.players)
		{
			if(var_01.team != "spectator")
			{
				self showtoplayer(var_01);
			}
		}
	}
}

//Function Number: 18
cratemodelteamupdater(param_00)
{
	self endon("death");
	self hide();
	foreach(var_02 in level.players)
	{
		if(var_02.team == "spectator")
		{
			if(param_00 == "allies")
			{
				self showtoplayer(var_02);
			}

			continue;
		}

		if(var_02.team == param_00)
		{
			self showtoplayer(var_02);
		}
	}

	for(;;)
	{
		level waittill("joined_team");
		self hide();
		foreach(var_02 in level.players)
		{
			if(var_02.team == "spectator")
			{
				if(param_00 == "allies")
				{
					self showtoplayer(var_02);
				}

				continue;
			}

			if(var_02.team == param_00)
			{
				self showtoplayer(var_02);
			}
		}
	}
}

//Function Number: 19
cratemodelenemyteamsupdater(param_00)
{
	self endon("death");
	self hide();
	foreach(var_02 in level.players)
	{
		if(var_02.team != param_00)
		{
			self showtoplayer(var_02);
		}
	}

	for(;;)
	{
		level waittill("joined_team");
		self hide();
		foreach(var_02 in level.players)
		{
			if(var_02.team != param_00)
			{
				self showtoplayer(var_02);
			}
		}
	}
}

//Function Number: 20
cratemodelplayerupdater(param_00,param_01)
{
	self endon("death");
	self hide();
	foreach(var_03 in level.players)
	{
		if(param_01 && isdefined(param_00) && var_03 != param_00)
		{
			continue;
		}

		if(!param_01 && isdefined(param_00) && var_03 == param_00)
		{
			continue;
		}

		self showtoplayer(var_03);
	}

	for(;;)
	{
		level waittill("joined_team");
		self hide();
		foreach(var_03 in level.players)
		{
			if(param_01 && isdefined(param_00) && var_03 != param_00)
			{
				continue;
			}

			if(!param_01 && isdefined(param_00) && var_03 == param_00)
			{
				continue;
			}

			self showtoplayer(var_03);
		}
	}
}

//Function Number: 21
crateuseteamupdater(param_00)
{
	self endon("death");
	for(;;)
	{
		setusablebyteam(param_00);
		level waittill("joined_team");
	}
}

//Function Number: 22
crateuseteamupdater_multiteams(param_00)
{
	self endon("death");
	for(;;)
	{
		setusablebyotherteams(param_00);
		level waittill("joined_team");
	}
}

//Function Number: 23
crateusejuggernautupdater()
{
	if(!issubstr(self.cratetype,"juggernaut"))
	{
		return;
	}

	self endon("death");
	level endon("game_ended");
	for(;;)
	{
		level waittill("juggernaut_equipped",var_00);
		self disableplayeruse(var_00);
		thread crateusepostjuggernautupdater(var_00);
	}
}

//Function Number: 24
crateusepostjuggernautupdater(param_00)
{
	self endon("death");
	level endon("game_ended");
	param_00 endon("disconnect");
	param_00 waittill("death");
	self enableplayeruse(param_00);
}

//Function Number: 25
createairdropcrate(param_00,param_01,param_02,param_03,param_04,param_05)
{
	var_06 = spawn("script_model",param_03);
	var_06.curprogress = 0;
	var_06.usetime = 0;
	var_06.userate = 0;
	var_06.team = self.team;
	var_06.destination = param_04;
	var_06.id = "care_package";
	var_06 give_player_tickets(1);
	if(isdefined(param_00))
	{
		var_06.triggerportableradarping = param_00;
		var_06 setotherent(param_00);
	}
	else
	{
		var_06.triggerportableradarping = undefined;
	}

	var_06.cratetype = param_02;
	var_06.droptype = param_01;
	var_06.var_336 = "care_package";
	var_06 _meth_85C8(1);
	var_07 = "care_package_iw7_dummy";
	if(isdefined(level.custom_dummy_crate_model))
	{
		var_07 = level.custom_dummy_crate_model;
	}

	var_06 setmodel(var_07);
	if(param_02 == "airdrop_jackpot")
	{
		var_06.friendlymodel = spawn("script_model",param_03);
		var_06.friendlymodel setmodel(level.cratetypes[param_01][param_02].model_name_friendly);
		var_06.friendlymodel thread deleteonownerdeath(var_06);
	}
	else
	{
		var_06.friendlymodel = spawn("script_model",param_03);
		var_06.friendlymodel setmodel(level.cratetypes[param_01][param_02].model_name_friendly);
		if(isdefined(level.highlightairdrop) && level.highlightairdrop)
		{
			if(!isdefined(param_05))
			{
				param_05 = 2;
			}

			var_06.friendlymodel hudoutlineenable(param_05,0,0);
			var_06.outlinecolor = param_05;
		}

		var_06.enemymodel = spawn("script_model",param_03);
		var_06.enemymodel setmodel(level.cratetypes[param_01][param_02].model_name_enemy);
		var_06.friendlymodel setentityowner(var_06);
		var_06.enemymodel setentityowner(var_06);
		var_06.friendlymodel thread deleteonownerdeath(var_06);
		if(level.teambased)
		{
			var_06.friendlymodel thread cratemodelteamupdater(var_06.team);
		}
		else
		{
			var_06.friendlymodel thread cratemodelplayerupdater(param_00,1);
		}

		var_06.enemymodel thread deleteonownerdeath(var_06);
		if(level.multiteambased)
		{
			var_06.enemymodel thread cratemodelenemyteamsupdater(var_06.team);
		}
		else if(level.teambased)
		{
			var_06.enemymodel thread cratemodelteamupdater(level.otherteam[var_06.team]);
		}
		else
		{
			var_06.enemymodel thread cratemodelplayerupdater(param_00,0);
		}
	}

	var_06.inuse = 0;
	var_06.killcament = spawn("script_model",var_06.origin + (0,0,300),0,1);
	var_06.killcament setscriptmoverkillcam("explosive");
	var_06.killcament linkto(var_06);
	level.var_C223++;
	var_06 thread dropcrateexistence(param_04);
	level notify("createAirDropCrate",var_06);
	return var_06;
}

//Function Number: 26
dropcrateexistence(param_00)
{
	level endon("game_ended");
	self waittill("death");
	if(isdefined(level.cratekill))
	{
		[[ level.cratekill ]](param_00);
	}

	level.var_C223--;
}

//Function Number: 27
cratesetupforuse(param_00,param_01,param_02,param_03)
{
	self setcursorhint("HINT_NOICON");
	self sethintstring(param_00);
	self _meth_84A7("none");
	self makeusable();
	if(isdefined(param_03))
	{
		self _meth_835F(param_03);
	}

	if(scripts\mp\_utility::istrue(param_02))
	{
		thread watchcratereroll(self.triggerportableradarping);
		thread watchcratererollcommand(self.triggerportableradarping);
		thread fakererollcratesetupforuse(self.triggerportableradarping,param_03);
	}

	var_04 = "icon_minimap_drone_package_friendly";
	if(isdefined(level.objvisall))
	{
		var_05 = "icon_minimap_drone_package_friendly";
	}

	if(!isdefined(self.minimapid))
	{
		self.minimapid = createobjective(var_04,undefined,1,1,0);
	}

	thread crateuseteamupdater();
	thread crateusejuggernautupdater();
	if(issubstr(self.cratetype,"juggernaut"))
	{
		foreach(var_07 in level.players)
		{
			if(var_07 scripts\mp\_utility::isjuggernaut())
			{
				thread crateusepostjuggernautupdater(var_07);
			}
		}
	}

	var_09 = undefined;
	if(level.teambased)
	{
		var_09 = scripts\mp\_entityheadicons::setheadicon(self.team,param_01,(0,0,24),14,14,0,undefined,undefined,undefined,undefined,0);
	}
	else if(isdefined(self.triggerportableradarping))
	{
		var_09 = scripts\mp\_entityheadicons::setheadicon(self.triggerportableradarping,param_01,(0,0,24),14,14,0,undefined,undefined,undefined,undefined,0);
	}

	if(isdefined(var_09))
	{
		var_09.showinkillcam = 0;
	}

	if(isdefined(level.iconvisall))
	{
		[[ level.iconvisall ]](self,param_01);
		return;
	}

	foreach(var_07 in level.players)
	{
		if(var_07.team == "spectator")
		{
			var_09 = scripts\mp\_entityheadicons::setheadicon(var_07,param_01,(0,0,24),14,14,0,undefined,undefined,undefined,undefined,0);
		}
	}
}

//Function Number: 28
fakererollcratesetupforuse(param_00,param_01)
{
	var_02 = &"PLATFORM_GET_KILLSTREAK";
	if(isdefined(game["strings"][self.cratetype + "_hint"]))
	{
		var_02 = game["strings"][self.cratetype + "_hint"];
	}

	var_03 = 128;
	var_04 = 360;
	var_05 = 128;
	var_06 = 360;
	var_07 = -10000;
	if(isdefined(param_01))
	{
		var_07 = param_01;
	}

	var_08 = spawn("script_model",self.origin);
	var_08.curprogress = 0;
	var_08.usetime = 0;
	var_08.userate = 3000;
	var_08.inuse = 0;
	var_08.id = self.id;
	var_08 linkto(self);
	var_08 makeusable();
	var_08 disableplayeruse(param_00);
	var_08 setcursorhint("HINT_NOICON");
	var_08 _meth_84A9("show");
	var_08 sethintstring(var_02);
	var_08 _meth_84A6(var_04);
	var_08 setusefov(var_06);
	var_08 _meth_84A4(var_03);
	var_08 setuserange(var_05);
	var_08 _meth_835F(var_07);
	var_08 thread deleteuseent(self);
	self.fakeuseobj = var_08;
}

//Function Number: 29
watchcratereroll(param_00)
{
	self endon("death");
	param_00 endon("disconnect");
	self waittill("crate_reroll");
	param_00 playlocalsound("mp_killconfirm_tags_drop");
	var_01 = level.cratetypes[self.droptype][self.cratetype].raw_weight;
	changecrateweight(self.droptype,self.cratetype,0);
	var_02 = getcratetypefordroptype(self.droptype);
	changecrateweight(self.droptype,self.cratetype,var_01);
	self.cratetype = var_02;
	var_03 = &"PLATFORM_GET_KILLSTREAK";
	if(isdefined(game["strings"][self.cratetype + "_hint"]))
	{
		var_03 = game["strings"][self.cratetype + "_hint"];
	}

	self sethintstring(var_03);
	if(isdefined(self.fakeuseobj))
	{
		self.fakeuseobj sethintstring(var_03);
	}

	var_04 = scripts\mp\_utility::getkillstreakoverheadicon(self.cratetype);
	var_05 = undefined;
	if(level.teambased)
	{
		var_05 = scripts\mp\_entityheadicons::setheadicon(self.team,var_04,(0,0,24),14,14,0,undefined,undefined,undefined,undefined,0);
	}
	else if(isdefined(self.triggerportableradarping))
	{
		var_05 = scripts\mp\_entityheadicons::setheadicon(self.triggerportableradarping,var_04,(0,0,24),14,14,0,undefined,undefined,undefined,undefined,0);
	}

	if(isdefined(var_05))
	{
		var_05.showinkillcam = 0;
	}

	if(isdefined(level.iconvisall))
	{
		[[ level.iconvisall ]](self,var_04);
		return;
	}

	foreach(var_07 in level.players)
	{
		if(var_07.team == "spectator")
		{
			var_05 = scripts\mp\_entityheadicons::setheadicon(var_07,var_04,(0,0,24),14,14,0,undefined,undefined,undefined,undefined,0);
		}
	}
}

//Function Number: 30
watchcratererollcommand(param_00)
{
	self endon("death");
	param_00 endon("disconnect");
	var_01 = 0;
	var_02 = 16384;
	for(;;)
	{
		if(param_00 usebuttonpressed())
		{
			var_01 = 0;
			while(param_00 usebuttonpressed())
			{
				var_01 = var_01 + 0.05;
				wait(0.05);
			}

			if(var_01 >= 0.5)
			{
				continue;
			}

			var_01 = 0;
			while(!param_00 usebuttonpressed() && var_01 < 0.5)
			{
				var_01 = var_01 + 0.05;
				wait(0.05);
			}

			if(var_01 >= 0.5)
			{
				continue;
			}

			if(!scripts\mp\_utility::isreallyalive(param_00))
			{
				continue;
			}

			if(distance2dsquared(param_00.origin,self.origin) > var_02)
			{
				continue;
			}

			self notify("crate_reroll");
		}

		wait(0.05);
	}
}

//Function Number: 31
createobjective(param_00,param_01,param_02,param_03,param_04)
{
	var_05 = scripts\mp\objidpoolmanager::requestminimapid(10);
	if(var_05 == -1)
	{
		return -1;
	}

	scripts\mp\objidpoolmanager::minimap_objective_add(var_05,"invisible",(0,0,0));
	if(!isdefined(self getlinkedparent()) && !scripts\mp\_utility::istrue(param_03))
	{
		scripts\mp\objidpoolmanager::minimap_objective_position(var_05,self.origin);
	}
	else if(scripts\mp\_utility::istrue(param_03) && scripts\mp\_utility::istrue(param_04))
	{
		scripts\mp\objidpoolmanager::minimap_objective_onentitywithrotation(var_05,self);
	}
	else
	{
		scripts\mp\objidpoolmanager::minimap_objective_onentity(var_05,self);
	}

	scripts\mp\objidpoolmanager::minimap_objective_state(var_05,"active");
	scripts\mp\objidpoolmanager::minimap_objective_icon(var_05,param_00);
	if(isdefined(param_01))
	{
		if(!level.teambased && isdefined(self.triggerportableradarping))
		{
			if(scripts\mp\_utility::istrue(param_02))
			{
				scripts\mp\objidpoolmanager::minimap_objective_playerteam(var_05,self.triggerportableradarping getentitynumber());
			}
			else
			{
				scripts\mp\objidpoolmanager::minimap_objective_playerenemyteam(var_05,self.triggerportableradarping getentitynumber());
			}
		}
		else
		{
			scripts\mp\objidpoolmanager::minimap_objective_team(var_05,param_01);
		}
	}
	else
	{
		scripts\mp\objidpoolmanager::minimap_objective_playermask_showtoall(var_05);
	}

	if(isdefined(level.objvisall))
	{
		[[ level.objvisall ]](var_05);
	}

	return var_05;
}

//Function Number: 32
createobjective_engineer(param_00,param_01,param_02)
{
	var_03 = scripts\mp\objidpoolmanager::requestminimapid(10);
	if(var_03 == -1)
	{
		return -1;
	}

	scripts\mp\objidpoolmanager::minimap_objective_add(var_03,"invisible",(0,0,0));
	if(!isdefined(self getlinkedparent()) && !scripts\mp\_utility::istrue(param_01))
	{
		scripts\mp\objidpoolmanager::minimap_objective_position(var_03,self.origin);
	}
	else if(scripts\mp\_utility::istrue(param_01) && scripts\mp\_utility::istrue(param_02))
	{
		scripts\mp\objidpoolmanager::minimap_objective_onentitywithrotation(var_03,self);
	}
	else
	{
		scripts\mp\objidpoolmanager::minimap_objective_onentity(var_03,self);
	}

	scripts\mp\objidpoolmanager::minimap_objective_state(var_03,"active");
	scripts\mp\objidpoolmanager::minimap_objective_icon(var_03,param_00);
	scripts\mp\objidpoolmanager::minimap_objective_playermask_hidefromall(var_03);
	return var_03;
}

//Function Number: 33
setusablebyteam(param_00)
{
	foreach(var_02 in level.players)
	{
		if(issubstr(self.cratetype,"juggernaut") && var_02 scripts\mp\_utility::isjuggernaut())
		{
			self disableplayeruse(var_02);
			continue;
		}

		if(issubstr(self.cratetype,"lased") && isdefined(var_02.hassoflam) && var_02.hassoflam)
		{
			self disableplayeruse(var_02);
			continue;
		}

		if(issubstr(self.cratetype,"trap") && scripts\mp\_utility::istrue(level.teambased) && var_02.team == self.triggerportableradarping.team)
		{
			self disableplayeruse(var_02);
			continue;
		}

		if(issubstr(self.cratetype,"trap") && !scripts\mp\_utility::istrue(level.teambased) && var_02 == self.triggerportableradarping)
		{
			self disableplayeruse(var_02);
			continue;
		}

		if(issubstr(self.droptype,"reroll") && var_02 != self.triggerportableradarping)
		{
			self disableplayeruse(var_02);
			continue;
		}

		if(!isdefined(param_00) || param_00 == var_02.team)
		{
			self enableplayeruse(var_02);
			continue;
		}

		self disableplayeruse(var_02);
	}
}

//Function Number: 34
setusablebyotherteams(param_00)
{
	foreach(var_02 in level.players)
	{
		if(issubstr(self.cratetype,"juggernaut") && var_02 scripts\mp\_utility::isjuggernaut())
		{
			self disableplayeruse(var_02);
			continue;
		}

		if(!isdefined(param_00) || param_00 != var_02.team)
		{
			self enableplayeruse(var_02);
			continue;
		}

		self disableplayeruse(var_02);
	}
}

//Function Number: 35
dropthecrate(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08)
{
	var_09 = [];
	self.triggerportableradarping endon("disconnect");
	if(!isdefined(param_04))
	{
		if(isdefined(param_07))
		{
			var_0A = undefined;
			var_0B = undefined;
			for(var_0C = 0;var_0C < 100;var_0C++)
			{
				var_0B = getcratetypefordroptype(param_01);
				var_0A = 0;
				for(var_0D = 0;var_0D < param_07.size;var_0D++)
				{
					if(var_0B == param_07[var_0D])
					{
						var_0A = 1;
						break;
					}
				}

				if(var_0A == 0)
				{
					break;
				}
			}

			if(var_0A == 1)
			{
				var_0B = getcratetypefordroptype(param_01);
			}
		}
		else
		{
			var_0B = getcratetypefordroptype(param_02);
		}
	}
	else
	{
		var_0B = param_05;
	}

	param_06 = (0,0,0);
	if(!isdefined(param_06))
	{
		param_06 = (randomint(5),randomint(5),randomint(5));
	}

	var_09 = createairdropcrate(self.triggerportableradarping,param_01,var_0B,param_05,param_00);
	switch(param_01)
	{
		case "nuke_drop":
		case "airdrop_mega":
		case "airdrop_juggernaut_maniac":
		case "airdrop_juggernaut_recon":
		case "airdrop_juggernaut":
			var_09 linkto(self,"tag_ground",(64,32,-128),(0,0,0));
			break;

		case "airdrop_osprey_gunner":
		case "airdrop_escort":
			var_09 linkto(self,param_08,(0,0,0),(0,0,0));
			break;

		default:
			var_09 linkto(self,"tag_ground",(32,0,5),(0,0,0));
			break;
	}

	var_09.angles = (0,0,0);
	var_09 show();
	var_0E = self.var_37A;
	if(issubstr(var_0B,"juggernaut"))
	{
		param_06 = (0,0,0);
	}

	thread waitfordropcratemsg(var_09,param_06,param_01,var_0B);
	var_09.droppingtoground = 1;
	return var_0B;
}

//Function Number: 36
killplayerfromcrate_dodamage(param_00)
{
	if(!scripts\mp\_utility::istrue(level.noairdropkills))
	{
		param_00 dodamage(1000,param_00.origin,self,self,"MOD_CRUSH");
	}

	self endon("death");
	param_00 endon("death");
	param_00 endon("disconnect");
	if(scripts\mp\_utility::isreallyalive(param_00))
	{
		childthread scripts\mp\_movers::unresolved_collision_nearest_node(param_00,undefined,self);
	}
}

//Function Number: 37
killplayerfromcrate_fastvelocitypush()
{
	self endon("death");
	for(;;)
	{
		self waittill("player_pushed",var_00,var_01);
		if(isplayer(var_00) || isagent(var_00))
		{
			if(var_01[2] < -20)
			{
				killplayerfromcrate_dodamage(var_00);
			}
		}

		wait(0.05);
	}
}

//Function Number: 38
airdrop_override_death_moving_platform(param_00)
{
	if(isdefined(param_00.lasttouchedplatform.destroyairdroponcollision) && param_00.lasttouchedplatform.destroyairdroponcollision)
	{
		playfx(scripts\engine\utility::getfx("airdrop_crate_destroy"),self.origin);
		deletecrateold();
	}
}

//Function Number: 39
cleanup_crate_capture()
{
	var_00 = self getlinkedchildren(1);
	if(!isdefined(var_00))
	{
		return;
	}

	foreach(var_02 in var_00)
	{
		if(!isplayer(var_02))
		{
			continue;
		}

		if(isdefined(var_02.iscapturingcrate) && var_02.iscapturingcrate)
		{
			var_03 = var_02 getlinkedparent();
			if(isdefined(var_03))
			{
				var_02 scripts\mp\_gameobjects::updateuiprogress(var_03,0);
				var_02 unlink();
			}

			if(isalive(var_02))
			{
				var_02 scripts\engine\utility::allow_weapon(1);
			}

			var_02.iscapturingcrate = 0;
		}
	}
}

//Function Number: 40
airdrop_override_invalid_moving_platform(param_00)
{
	wait(0.05);
	self notify("restarting_physics");
	cleanup_crate_capture();
	self physicslaunchserver((0,0,0),param_00.dropimpulse,param_00.airdrop_max_linear_velocity);
	thread physicswaiter(param_00.droptype,param_00.cratetype,param_00.dropimpulse,param_00.airdrop_max_linear_velocity);
}

//Function Number: 41
waitfordropcratemsg(param_00,param_01,param_02,param_03,param_04,param_05)
{
	param_00 endon("death");
	if(!isdefined(param_05) || !param_05)
	{
		self waittill("drop_crate");
	}

	var_06 = 1200;
	if(isdefined(param_04))
	{
		var_06 = param_04;
	}

	param_00 unlink();
	param_00 physicslaunchserver((0,0,0),param_01,var_06);
	param_00 thread physicswaiter(param_02,param_03,param_01,var_06);
	param_00 thread killplayerfromcrate_fastvelocitypush();
	param_00.unresolved_collision_func = ::killplayerfromcrate_dodamage;
	if(isdefined(param_00.killcament))
	{
		if(isdefined(param_00.carestrike))
		{
			var_07 = -2100;
		}
		else
		{
			var_07 = 0;
		}

		param_00.killcament unlink();
		var_08 = bullettrace(param_00.origin,param_00.origin + (0,0,-10000),0,param_00);
		var_09 = distance(param_00.origin,var_08["position"]);
		var_0A = var_09 / 800;
		param_00.killcament moveto(var_08["position"] + (0,0,300) + (var_07,0,0),var_0A);
	}
}

//Function Number: 42
waitandanimate()
{
	self endon("death");
	wait(0.035);
	playfx(level._effect["airdrop_dust_kickup"],self.origin + (0,0,5),(0,0,1));
	self.friendlymodel scriptmodelplayanim("juggernaut_carepackage");
	self.enemymodel scriptmodelplayanim("juggernaut_carepackage");
}

//Function Number: 43
physicswaiter(param_00,param_01,param_02,param_03,param_04)
{
	if(scripts\mp\_utility::istrue(param_04))
	{
		self endon("death");
	}

	self endon("restarting_physics");
	func_136A7();
	self.droppingtoground = 0;
	self thread [[ level.cratetypes[param_00][param_01].func ]](param_00);
	level thread droptimeout(self,self.triggerportableradarping,param_01);
	var_05 = spawnstruct();
	var_05.endonstring = "restarting_physics";
	var_05.deathoverridecallback = ::airdrop_override_death_moving_platform;
	var_05.invalidparentoverridecallback = ::airdrop_override_invalid_moving_platform;
	var_05.droptype = param_00;
	var_05.cratetype = param_01;
	var_05.dropimpulse = param_02;
	var_05.airdrop_max_linear_velocity = param_03;
	thread scripts\mp\_movers::handle_moving_platforms(var_05);
	if(self.friendlymodel scripts\mp\_utility::touchingbadtrigger())
	{
		deletecrateold();
		return;
	}

	if(isdefined(self.triggerportableradarping) && abs(self.origin[2] - self.triggerportableradarping.origin[2]) > 3000)
	{
		deletecrateold();
	}
}

//Function Number: 44
func_136A7()
{
	wait(0.5);
	for(;;)
	{
		var_00 = self physics_getbodyid(0);
		var_01 = function_026E(var_00);
		if(lengthsquared(var_01) > 0.5)
		{
			wait(0.1);
			continue;
		}

		break;
	}
}

//Function Number: 45
droptimeout(param_00,param_01,param_02)
{
	if(isdefined(level.nod_gesture) && level.nod_gesture)
	{
		return;
	}

	level endon("game_ended");
	param_00 endon("death");
	if(param_00.droptype == "nuke_drop")
	{
		return;
	}

	var_03 = 90;
	if(param_02 == "supply")
	{
		var_03 = 20;
	}
	else if(param_02 == "bomb_trap")
	{
		var_03 = 60;
	}

	scripts\mp\_hostmigration::waitlongdurationwithhostmigrationpause(var_03);
	while(param_00.curprogress != 0)
	{
		wait(1);
	}

	param_00 deletecrateold();
}

//Function Number: 46
getpathstart(param_00,param_01)
{
	var_02 = 100;
	var_03 = 15000;
	var_04 = (0,param_01,0);
	var_05 = param_00 + anglestoforward(var_04) * -1 * var_03;
	var_05 = var_05 + (randomfloat(2) - 1 * var_02,randomfloat(2) - 1 * var_02,0);
	return var_05;
}

//Function Number: 47
getpathend(param_00,param_01)
{
	var_02 = 150;
	var_03 = 15000;
	var_04 = (0,param_01,0);
	var_05 = param_00 + anglestoforward(var_04 + (0,90,0)) * var_03;
	var_05 = var_05 + (randomfloat(2) - 1 * var_02,randomfloat(2) - 1 * var_02,0);
	return var_05;
}

//Function Number: 48
getflyheightoffset(param_00)
{
	var_01 = 850;
	var_02 = getent("airstrikeheight","targetname");
	if(!isdefined(var_02))
	{
		if(isdefined(level.airstrikeheightscale))
		{
			if(level.airstrikeheightscale > 2)
			{
				var_01 = 1500;
				return var_01 * level.airstrikeheightscale;
			}

			return var_01 * level.airstrikeheightscale + 256 + param_00[2];
		}

		return var_01 + param_00[2];
	}

	return var_02.origin[2];
}

//Function Number: 49
func_581F(param_00,param_01,param_02,param_03,param_04)
{
	if(!isdefined(param_00))
	{
		return;
	}

	if(scripts\mp\_utility::currentactivevehiclecount() >= scripts\mp\_utility::maxvehiclesallowed())
	{
		return;
	}

	if(param_03 == "dronedrop_grnd")
	{
		var_05 = param_01.droporigin;
	}
	else
	{
		var_05 = param_02.location;
	}

	var_06 = getflyheightoffset(var_05);
	var_07 = var_05 * (1,1,0) + (0,0,var_06);
	var_08 = getpathstart(var_07,param_02);
	var_09 = getpathend(var_07,param_02);
	var_07 = var_07 + anglestoforward((0,param_02,0)) * -50;
	var_0A = func_5CC7(param_00,var_08,var_07,param_03,param_01,param_04);
	var_0B = undefined;
	var_0C = 999999;
	var_0D = scripts\common\trace::ray_trace(var_05,var_05 + (0,0,10000),level.characters,scripts\common\trace::create_contents(0,1,0,1,0,1,0));
	var_0E = undefined;
	var_0F = 0;
	if(var_0D["hittype"] == "hittype_none")
	{
		var_0E = var_05 * (1,1,0) + (0,0,var_06);
		var_0F = 1;
	}
	else
	{
		if(isdefined(level.carepackagedropnodes) && level.carepackagedropnodes.size > 0)
		{
			foreach(var_11 in level.carepackagedropnodes)
			{
				var_12 = distance(var_11.origin,var_05);
				if(var_12 < var_0C)
				{
					var_0B = var_11;
					var_0C = var_12;
				}
			}
		}
		else
		{
		}

		var_0E = var_0B.origin * (1,1,0) + (0,0,var_06);
	}

	var_14 = "";
	var_15 = "used_dronedrop";
	if(isdefined(param_04))
	{
		var_14 = scripts\mp\_killstreak_loot::getrarityforlootitem(param_04.variantid);
		var_15 = "used_" + param_04.streakname;
	}

	if(var_14 != "" && var_14 != "rare")
	{
		var_15 = var_15 + "_" + var_14;
	}

	if(level.gametype != "grnd")
	{
		level thread scripts\mp\_utility::teamplayercardsplash(var_15,param_00);
	}

	var_0A setvehgoalpos(var_0E,1);
	var_0A setscriptablepartstate("lights","idle");
	var_0A setscriptablepartstate("thrusters","fly",0);
	var_0A thread func_13A04(var_0E,var_05,var_0F);
}

//Function Number: 50
func_5CC7(param_00,param_01,param_02,param_03,param_04,param_05)
{
	var_06 = vectortoangles(param_02 - param_01);
	var_07 = "veh_mil_air_un_delivery_drone";
	var_08 = "";
	if(isdefined(param_05))
	{
		var_08 = scripts\mp\_killstreak_loot::getrarityforlootitem(param_05.variantid);
	}

	if(var_08 != "")
	{
		var_07 = var_07 + "_" + var_08;
	}

	if(isdefined(param_05))
	{
		if(scripts\mp\killstreaks\_utility::func_A69F(param_05,"passive_bomb_trap"))
		{
			param_03 = "dronedrop_trap";
		}

		if(scripts\mp\killstreaks\_utility::func_A69F(param_05,"passive_reroll"))
		{
			param_03 = "dronedrop_reroll";
		}

		if(scripts\mp\killstreaks\_utility::func_A69F(param_05,"passive_high_roller"))
		{
			param_03 = "dronedrop_highroll";
		}
	}

	var_09 = spawnhelicopter(param_00,param_01,var_06,"delivery_drone_mp",var_07);
	if(!isdefined(var_09))
	{
		return;
	}

	var_09.maxhealth = 100;
	var_09.triggerportableradarping = param_00;
	var_09.team = param_00.team;
	var_09.isairdrop = 1;
	var_09 setmaxpitchroll(35,35);
	var_09 vehicle_setspeed(1600,200,200);
	var_09 givelastonteamwarning(250,100);
	var_09 setneargoalnotifydist(1000);
	var_09 sethoverparams(5,5,2);
	var_09 setcandamage(1);
	var_09 setturningability(1);
	var_09 _meth_84E1(1);
	var_09 _meth_84E0(1);
	var_09.streakinfo = param_05;
	var_09.helitype = "dronedrop";
	var_09 scripts\mp\killstreaks\_utility::func_1843(var_09.helitype,"Killstreak_Air",param_00,1);
	var_0A = getcratetypefordroptype(param_03);
	var_0B = var_09 createairdropcrate(param_00,param_03,var_0A,var_09.origin);
	var_0B linkto(var_09,"tag_origin",(0,0,5),(0,0,0));
	var_0B.streakinfo = param_05;
	var_09.var_5D26 = var_0B;
	var_09 thread watchtimeout(60);
	var_09 thread func_13A01(var_0B,param_03,var_0A,param_04);
	var_09 thread scripts\mp\killstreaks\_helicopter::heli_damage_monitor("dronedrop",undefined,1);
	var_09 thread watchempdamage();
	if(param_03 == "dronedrop_trap")
	{
		var_09 thread watchownerdisconnect(var_0B,param_04);
	}

	var_09 setscriptablepartstate("dust","active",0);
	var_09 thread dronewatchgameover();
	return var_09;
}

//Function Number: 51
func_13A01(param_00,param_01,param_02,param_03)
{
	self waittill("death");
	if(!isdefined(param_00))
	{
		return;
	}

	var_04 = (0,0,0);
	var_05 = 1200;
	var_06 = undefined;
	if(param_01 == "dronedrop_trap")
	{
		var_06 = 1;
	}

	param_00 unlink();
	param_00 physicslaunchserver((0,0,0),var_04,var_05);
	param_00 thread physicswaiter(param_01,param_02,var_04,var_05,var_06);
	param_00 thread killplayerfromcrate_fastvelocitypush();
	param_00.unresolved_collision_func = ::killplayerfromcrate_dodamage;
	if(isdefined(param_00.killcament))
	{
		param_00.killcament unlink();
	}

	if(isdefined(param_03.var_1349C))
	{
		param_03.var_1349C delete();
	}

	param_00 thread handlenavobstacle();
	func_5CAC();
	scripts\mp\_utility::printgameaction("killstreak ended - dronedrop",self.triggerportableradarping);
}

//Function Number: 52
handlenavobstacle()
{
	self endon("death");
	self endon("nav_obstacle_destroyed");
	wait(1);
	self.var_BE6F = function_027A(self.origin,(30,10,64),self.angles);
	var_00 = self.origin;
	while(isdefined(self) && isdefined(self.var_BE6F))
	{
		if(distance2dsquared(var_00,self.origin) > 64)
		{
			destroynavobstacle(self.var_BE6F);
			self.var_BE6F = function_027A(self.origin,(30,10,64),self.angles);
			var_00 = self.origin;
		}

		wait(1);
	}
}

//Function Number: 53
watchempdamage()
{
	self endon("death");
	level endon("game_ended");
	for(;;)
	{
		self waittill("emp_damage",var_00,var_01,var_02,var_03,var_04);
		if(isdefined(var_03) && var_03 == "concussion_grenade_mp")
		{
			if(scripts\mp\_utility::istrue(scripts\mp\_utility::playersareenemies(self.triggerportableradarping,var_00)))
			{
				var_00 scripts\mp\_missions::func_D991("ch_tactical_emp_eqp");
			}
		}

		scripts\mp\killstreaks\_utility::dodamagetokillstreak(100,var_00,var_00,self.team,var_02,var_04,var_03);
	}
}

//Function Number: 54
watchownerdisconnect(param_00,param_01)
{
	self endon("death");
	self.triggerportableradarping waittill("disconnect");
	if(isdefined(param_01.var_1349C))
	{
		param_01.var_1349C delete();
	}

	param_00 deletecrateold();
	func_5CAC();
}

//Function Number: 55
func_5CAC()
{
	playfx(scripts\engine\utility::getfx("drone_explode"),self.origin);
	self playsound("sentry_explode");
	scripts\mp\_utility::decrementfauxvehiclecount();
	self delete();
}

//Function Number: 56
func_13A04(param_00,param_01,param_02)
{
	self endon("death");
	self waittill("goal");
	thread watchmantledisable();
	var_03 = (0,0,-30);
	var_04 = (0,0,12);
	self setscriptablepartstate("thrusters","descend",0);
	thread watchfailsafe(param_00);
	var_05 = undefined;
	if(!scripts\mp\_utility::istrue(param_02))
	{
		if(areanynavvolumesloaded())
		{
			var_06 = param_01 + (0,0,12);
			var_05 = findpath3d(self.origin,var_06);
		}
		else
		{
			var_07 = scripts\common\trace::create_solid_ai_contents();
			var_08 = scripts\common\trace::ray_trace(self.origin,self.origin - (0,0,500),self,var_07);
			var_09 = getclosestpointonnavmesh(var_08["position"],self);
			var_05 = self.triggerportableradarping findpath(var_09,param_01);
			self.triggerportableradarping iprintlnbold("3D Nav Volume is not present, using 2D path instead");
		}
	}
	else
	{
		var_05 = [param_01 + (0,0,12)];
	}

	var_0A = 0;
	var_0B = self.origin;
	foreach(var_10, var_0D in var_05)
	{
		if(var_10 == var_05.size - 1)
		{
			var_0A = 1;
		}

		if(var_0A)
		{
			var_0E = var_04;
		}
		else
		{
			var_0E = var_03;
		}

		var_0F = 50;
		self setneargoalnotifydist(var_0F);
		var_0B = var_0D;
		if(!var_0A)
		{
			thread func_BA1C(var_0D + var_0E,var_05[var_10 + 1] + var_0E);
		}
		else
		{
			thread func_BA1D(var_0D + var_0E);
		}

		self setscriptablepartstate("thrusters","navigate",0);
		self setvehgoalpos(var_0D + var_0E,var_0A);
		if(!var_0A || scripts\mp\_utility::istrue(param_02))
		{
			self waittill("near_goal");
			continue;
		}

		self waittill("goal");
	}

	self notify("death");
}

//Function Number: 57
watchmantledisable()
{
	self endon("death");
	for(;;)
	{
		foreach(var_01 in level.players)
		{
			if(!scripts\mp\_utility::isreallyalive(var_01))
			{
				continue;
			}

			if(distancesquared(self.origin,var_01.origin) <= 10000 && !isdefined(var_01.cratemantle))
			{
				var_01.cratemantle = 0;
				var_01 scripts\engine\utility::allow_mantle(0);
				var_01 thread watchdistancefromcrate(self);
			}
		}

		scripts\engine\utility::waitframe();
	}
}

//Function Number: 58
watchdistancefromcrate(param_00)
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	while(isdefined(param_00))
	{
		if(distancesquared(param_00.origin,self.origin) > 10000)
		{
			break;
		}

		scripts\engine\utility::waitframe();
	}

	self.cratemantle = undefined;
	scripts\engine\utility::allow_mantle(1);
}

//Function Number: 59
watchfailsafe(param_00)
{
	self endon("death");
	self endon("near_goal");
	var_01 = 3;
	scripts\mp\_hostmigration::waitlongdurationwithhostmigrationpause(var_01);
	if(distancesquared(self.origin,param_00) < 2500)
	{
		self notify("death");
	}
}

//Function Number: 60
func_7E84(param_00)
{
	var_01 = abs(param_00[0]);
	var_02 = abs(param_00[1]);
	var_03 = abs(param_00[2]);
	return int(max(var_03,max(var_01,var_02)));
}

//Function Number: 61
func_BA00(param_00,param_01)
{
	self notify("stop_MonitorPath");
	self endon("death");
	self endon("stop_MonitorPath");
	self endon("goal");
	self endon("near_goal");
	var_02[0] = self;
	var_02[1] = self.var_5D26;
	for(;;)
	{
		var_03 = scripts\common\trace::sphere_trace(self.origin,param_01,16,var_02);
		if(var_03["fraction"] == 1)
		{
			self notify("near_goal");
		}

		wait(0.25);
	}
}

//Function Number: 62
setupchallengelocales(param_00,param_01,param_02,param_03,param_04,param_05)
{
	var_06 = spawnstruct();
	var_06.var_B75B = param_01;
	var_06.var_B491 = param_02;
	var_06.var_B7CB = param_03;
	var_06.var_B4C9 = param_04;
	var_06.var_1545 = param_05;
	level.var_109C4[param_00] = var_06;
}

//Function Number: 63
setupcaptureflares()
{
	setupchallengelocales("far",500,750,45,70,100);
	setupchallengelocales("medium",250,500,35,45,100);
	setupchallengelocales("near",50,250,15,30,100);
	setupchallengelocales("medium_sharpturn",250,500,10,30,100);
	setupchallengelocales("near_sharpturn",50,250,10,20,100);
	setupchallengelocales("final",50,1000,10,45,100);
}

//Function Number: 64
func_12F22(param_00,param_01)
{
	var_02 = 9999;
	var_03 = level.var_109C4[param_00];
	if(param_01 < var_03.var_B75B)
	{
		param_01 = var_03.var_B75B;
	}

	if(param_01 > var_03.var_B491)
	{
		param_01 = var_03.var_B491;
	}

	var_04 = param_01 - var_03.var_B75B / var_03.var_B491 - var_03.var_B75B;
	var_05 = var_03.var_B7CB + var_04 * var_03.var_B4C9 - var_03.var_B7CB;
	var_06 = var_03.var_1545;
	if(var_06 > var_05)
	{
		var_06 = var_05;
	}

	self vehicle_setspeed(var_05,var_06,var_02);
}

//Function Number: 65
func_BA1D(param_00)
{
	self notify("stop_MonitorSpeed");
	self endon("death");
	self endon("stop_MonitorSpeed");
	self endon("goal");
	var_01 = "none";
	for(;;)
	{
		var_02 = distance(self.origin,param_00);
		func_12F22("final",var_02);
		scripts\engine\utility::waitframe();
	}
}

//Function Number: 66
func_BA1C(param_00,param_01)
{
	self notify("stop_MonitorSpeed");
	self endon("death");
	self endon("stop_MonitorSpeed");
	var_02 = "none";
	var_03 = vectornormalize(param_01 - param_00);
	var_04 = distance(param_00,param_01);
	for(;;)
	{
		var_05 = distance(self.origin,param_00);
		var_06 = vectornormalize(param_00 - self.origin);
		var_07 = vectordot(var_03,var_06);
		var_08 = 0;
		if(var_07 < 0.707 || var_04 < 300)
		{
			var_08 = 1;
		}

		if(var_08)
		{
			if(var_05 < level.var_109C4["medium_sharpturn"].var_B75B)
			{
				func_12F22("near_sharpturn",var_05);
			}
			else
			{
				func_12F22("medium_sharpturn",var_05);
			}
		}
		else if(var_05 < level.var_109C4["near"].var_B491)
		{
			func_12F22("near",var_05);
		}
		else if(var_05 < level.var_109C4["medium"].var_B491)
		{
			func_12F22("medium",var_05);
		}
		else
		{
			func_12F22("far",var_05);
		}

		scripts\engine\utility::waitframe();
	}
}

//Function Number: 67
doflyby(param_00,param_01,param_02,param_03,param_04,param_05)
{
	if(!isdefined(param_00))
	{
		return;
	}

	if(scripts\mp\_utility::currentactivevehiclecount() >= scripts\mp\_utility::maxvehiclesallowed())
	{
		return;
	}

	var_06 = getflyheightoffset(param_01);
	if(isdefined(param_04))
	{
		var_06 = var_06 + param_04;
	}

	foreach(var_08 in level.littlebirds)
	{
		if(isdefined(var_08.droptype))
		{
			var_06 = var_06 + 128;
		}
	}

	var_0A = param_01 * (1,1,0) + (0,0,var_06);
	var_0B = getpathstart(var_0A,param_02);
	var_0C = getpathend(var_0A,param_02);
	var_0A = var_0A + anglestoforward((0,param_02,0)) * -50;
	var_0D = helisetup(param_00,var_0B,var_0A);
	if(isdefined(level.highlightairdrop) && level.highlightairdrop)
	{
		var_0D hudoutlineenable(3,0,0);
	}

	var_0D endon("death");
	var_0D thread func_4FC2();
	var_0D.droptype = param_03;
	var_0D setvehgoalpos(var_0A,1);
	var_0D thread dropthecrate(param_01,param_03,var_06,0,param_05,var_0B);
	wait(2);
	var_0D vehicle_setspeed(75,40);
	var_0D givelastonteamwarning(180,180,180,0.3);
	var_0D waittill("goal");
	wait(0.1);
	var_0D notify("drop_crate");
	var_0D setvehgoalpos(var_0C,1);
	var_0D vehicle_setspeed(300,75);
	var_0D.var_AB32 = 1;
	var_0D waittill("goal");
	var_0D notify("leaving");
	var_0D notify("delete");
	var_0D delete();
}

//Function Number: 68
func_4FC2()
{
	self waittill("death");
	waittillframeend;
	scripts\mp\_utility::decrementfauxvehiclecount();
}

//Function Number: 69
domegaflyby(param_00,param_01,param_02,param_03)
{
	level thread doflyby(param_00,param_01,param_02,param_03,0);
	wait(randomintrange(1,2));
	level thread doflyby(param_00,param_01 + (128,128,0),param_02,param_03,128);
	wait(randomintrange(1,2));
	level thread doflyby(param_00,param_01 + (172,256,0),param_02,param_03,256);
	wait(randomintrange(1,2));
	level thread doflyby(param_00,param_01 + (64,0,0),param_02,param_03,0);
}

//Function Number: 70
doc130flyby(param_00,param_01,param_02,param_03)
{
	var_04 = 18000;
	var_05 = 3000;
	var_06 = vectortoyaw(param_01 - param_00.origin);
	var_07 = (0,var_06,0);
	var_08 = getflyheightoffset(param_01);
	var_09 = param_01 + anglestoforward(var_07) * -1 * var_04;
	var_09 = var_09 * (1,1,0) + (0,0,var_08);
	var_0A = param_01 + anglestoforward(var_07) * var_04;
	var_0A = var_0A * (1,1,0) + (0,0,var_08);
	var_0B = length(var_09 - var_0A);
	var_0C = var_0B / var_05;
	var_0D = c130setup(param_00,var_09,var_0A);
	var_0D.var_37A = var_05;
	var_0D.droptype = param_03;
	var_0D playloopsound("veh_ac130_dist_loop");
	var_0D.angles = var_07;
	var_0E = anglestoforward(var_07);
	var_0D moveto(var_0A,var_0C,0,0);
	var_0F = distance2d(var_0D.origin,param_01);
	var_10 = 0;
	for(;;)
	{
		var_11 = distance2d(var_0D.origin,param_01);
		if(var_11 < var_0F)
		{
			var_0F = var_11;
		}
		else if(var_11 > var_0F)
		{
			break;
		}

		if(var_11 < 320)
		{
			break;
		}
		else if(var_11 < 768)
		{
			scripts\mp\_shellshock::_earthquake(0.15,1.5,param_01,1500);
			if(!var_10)
			{
				var_0D playsound("veh_ac130_sonic_boom");
				var_10 = 1;
			}
		}

		wait(0.05);
	}

	wait(0.05);
	var_12 = (0,0,0);
	var_13[0] = var_0D thread dropthecrate(param_01,param_03,var_08,0,undefined,var_09,var_12);
	wait(0.05);
	var_0D notify("drop_crate");
	var_14 = param_01 + anglestoforward(var_07) * var_04 * 1.5;
	var_0D moveto(var_14,var_0C / 2,0,0);
	wait(6);
	var_0D delete();
}

//Function Number: 71
domegac130flyby(param_00,param_01,param_02,param_03,param_04)
{
	var_05 = 24000;
	var_06 = 2000;
	var_07 = vectortoyaw(param_01 - param_00.origin);
	var_08 = (0,var_07,0);
	var_09 = anglestoforward(var_08);
	if(isdefined(param_04))
	{
		param_01 = param_01 + var_09 * param_04;
	}

	var_0A = getflyheightoffset(param_01);
	var_0B = param_01 + anglestoforward(var_08) * -1 * var_05;
	var_0B = var_0B * (1,1,0) + (0,0,var_0A);
	var_0C = param_01 + anglestoforward(var_08) * var_05;
	var_0C = var_0C * (1,1,0) + (0,0,var_0A);
	var_0D = length(var_0B - var_0C);
	var_0E = var_0D / var_06;
	var_0F = c130setup(param_00,var_0B,var_0C);
	var_0F.var_37A = var_06;
	var_0F.droptype = param_03;
	var_0F playloopsound("veh_ac130_dist_loop");
	var_0F.angles = var_08;
	var_09 = anglestoforward(var_08);
	var_0F moveto(var_0C,var_0E,0,0);
	var_10 = distance2d(var_0F.origin,param_01);
	var_11 = 0;
	for(;;)
	{
		var_12 = distance2d(var_0F.origin,param_01);
		if(var_12 < var_10)
		{
			var_10 = var_12;
		}
		else if(var_12 > var_10)
		{
			break;
		}

		if(var_12 < 256)
		{
			break;
		}
		else if(var_12 < 768)
		{
			scripts\mp\_shellshock::_earthquake(0.15,1.5,param_01,1500);
			if(!var_11)
			{
				var_0F playsound("veh_ac130_sonic_boom");
				var_11 = 1;
			}
		}

		wait(0.05);
	}

	wait(0.05);
	var_13[0] = var_0F thread dropthecrate(param_01,param_03,var_0A,0,undefined,var_0B);
	wait(0.05);
	var_0F notify("drop_crate");
	wait(0.05);
	var_13[1] = var_0F thread dropthecrate(param_01,param_03,var_0A,0,undefined,var_0B,undefined,var_13);
	wait(0.05);
	var_0F notify("drop_crate");
	wait(0.05);
	var_13[2] = var_0F thread dropthecrate(param_01,param_03,var_0A,0,undefined,var_0B,undefined,var_13);
	wait(0.05);
	var_0F notify("drop_crate");
	wait(0.05);
	var_13[3] = var_0F thread dropthecrate(param_01,param_03,var_0A,0,undefined,var_0B,undefined,var_13);
	wait(0.05);
	var_0F notify("drop_crate");
	wait(4);
	var_0F delete();
}

//Function Number: 72
dropnuke(param_00,param_01,param_02)
{
	var_03 = 24000;
	var_04 = 2000;
	var_05 = randomint(360);
	var_06 = (0,var_05,0);
	var_07 = getflyheightoffset(param_00);
	var_08 = param_00 + anglestoforward(var_06) * -1 * var_03;
	var_08 = var_08 * (1,1,0) + (0,0,var_07);
	var_09 = param_00 + anglestoforward(var_06) * var_03;
	var_09 = var_09 * (1,1,0) + (0,0,var_07);
	var_0A = length(var_08 - var_09);
	var_0B = var_0A / var_04;
	var_0C = c130setup(param_01,var_08,var_09);
	var_0C.var_37A = var_04;
	var_0C.droptype = param_02;
	var_0C playloopsound("veh_ac130_dist_loop");
	var_0C.angles = var_06;
	var_0D = anglestoforward(var_06);
	var_0C moveto(var_09,var_0B,0,0);
	var_0E = 0;
	var_0F = distance2d(var_0C.origin,param_00);
	for(;;)
	{
		var_10 = distance2d(var_0C.origin,param_00);
		if(var_10 < var_0F)
		{
			var_0F = var_10;
		}
		else if(var_10 > var_0F)
		{
			break;
		}

		if(var_10 < 256)
		{
			break;
		}
		else if(var_10 < 768)
		{
			scripts\mp\_shellshock::_earthquake(0.15,1.5,param_00,1500);
			if(!var_0E)
			{
				var_0C playsound("veh_ac130_sonic_boom");
				var_0E = 1;
			}
		}

		wait(0.05);
	}

	var_0C thread dropthecrate(param_00,param_02,var_07,0,"nuke",var_08);
	wait(0.05);
	var_0C notify("drop_crate");
	wait(4);
	var_0C delete();
}

//Function Number: 73
stoploopafter(param_00)
{
	self endon("death");
	wait(param_00);
	self stoploopsound();
}

//Function Number: 74
playlooponent(param_00)
{
	var_01 = spawn("script_origin",(0,0,0));
	var_01 hide();
	var_01 endon("death");
	thread scripts\engine\utility::delete_on_death(var_01);
	var_01.origin = self.origin;
	var_01.angles = self.angles;
	var_01 linkto(self);
	var_01 playloopsound(param_00);
	self waittill("stop sound" + param_00);
	var_01 stoploopsound(param_00);
	var_01 delete();
}

//Function Number: 75
c130setup(param_00,param_01,param_02)
{
	var_03 = vectortoangles(param_02 - param_01);
	var_04 = spawnplane(param_00,"script_model",param_01,"compass_objpoint_c130_friendly","compass_objpoint_c130_enemy");
	var_04 setmodel("vehicle_ac130_low_mp");
	if(!isdefined(var_04))
	{
		return;
	}

	var_04.triggerportableradarping = param_00;
	var_04.team = param_00.team;
	level.c130 = var_04;
	return var_04;
}

//Function Number: 76
helisetup(param_00,param_01,param_02)
{
	var_03 = vectortoangles(param_02 - param_01);
	var_04 = "littlebird_mp";
	if(isdefined(level.vehicleoverride))
	{
		var_04 = level.vehicleoverride;
	}

	var_05 = spawnhelicopter(param_00,param_01,var_03,var_04,"vehicle_aas_72x_killstreak");
	if(!isdefined(var_05))
	{
		return;
	}

	var_05.maxhealth = 500;
	var_05.triggerportableradarping = param_00;
	var_05.team = param_00.team;
	var_05.isairdrop = 1;
	var_05 thread watchtimeout();
	var_05 thread heli_existence();
	var_05 thread helidestroyed();
	var_05 thread scripts\mp\killstreaks\_helicopter::heli_damage_monitor("airdrop");
	var_05 setmaxpitchroll(45,85);
	var_05 vehicle_setspeed(250,175);
	var_05.helitype = "airdrop";
	var_05 scripts\mp\killstreaks\_utility::func_1843(var_05.helitype,"Killstreak_Air",param_00,1);
	var_05 hidepart("tag_wings");
	return var_05;
}

//Function Number: 77
watchtimeout(param_00)
{
	level endon("game_ended");
	self endon("leaving");
	self endon("helicopter_gone");
	self endon("death");
	var_01 = 25;
	if(isdefined(param_00))
	{
		var_01 = param_00;
	}

	scripts\mp\_hostmigration::waitlongdurationwithhostmigrationpause(var_01);
	self notify("death");
}

//Function Number: 78
heli_existence()
{
	scripts\engine\utility::waittill_any_3("crashing","leaving");
	self notify("helicopter_gone");
}

//Function Number: 79
helidestroyed()
{
	self endon("leaving");
	self endon("helicopter_gone");
	self waittill("death");
	if(!isdefined(self))
	{
		return;
	}

	self vehicle_setspeed(25,5);
	thread lbspin(randomintrange(180,220));
	wait(randomfloatrange(0.5,1.5));
	self notify("drop_crate");
	lbexplode();
}

//Function Number: 80
lbexplode()
{
	var_00 = self.origin + (0,0,1) - self.origin;
	playfx(level.chopper_fx["explode"]["death"]["cobra"],self.origin,var_00);
	self playsound("exp_helicopter_fuel");
	self notify("explode");
	scripts\mp\_utility::decrementfauxvehiclecount();
	self delete();
}

//Function Number: 81
lbspin(param_00)
{
	self endon("explode");
	playfxontag(level.chopper_fx["explode"]["medium"],self,"tail_rotor_jnt");
	playfxontag(level.chopper_fx["fire"]["trail"]["medium"],self,"tail_rotor_jnt");
	self givelastonteamwarning(param_00,param_00,param_00);
	while(isdefined(self))
	{
		self settargetyaw(self.angles[1] + param_00 * 0.9);
		wait(1);
	}
}

//Function Number: 82
nukecapturethink()
{
	while(isdefined(self))
	{
		self waittill("trigger",var_00);
		if(!var_00 isonground())
		{
			continue;
		}

		if(!useholdthink(var_00))
		{
			continue;
		}

		self notify("captured",var_00);
	}
}

//Function Number: 83
crateothercapturethink(param_00,param_01)
{
	self endon("restarting_physics");
	var_02 = self;
	var_03 = undefined;
	if(scripts\mp\_utility::istrue(param_01))
	{
		var_02 = self.fakeuseobj;
		var_03 = self.fakeuseobj;
	}

	while(isdefined(self))
	{
		var_02 waittill("trigger",var_04);
		if(isdefined(self.triggerportableradarping) && var_04 == self.triggerportableradarping)
		{
			continue;
		}

		if(!validateopenconditions(var_04))
		{
			continue;
		}

		if(isdefined(level.overridecrateusetime))
		{
			var_05 = level.overridecrateusetime;
		}
		else
		{
			var_05 = undefined;
		}

		var_04.iscapturingcrate = 1;
		if(!scripts\mp\_utility::istrue(param_01))
		{
			var_03 = createuseent();
		}

		var_06 = var_03 useholdthink(var_04,var_05,param_00);
		if(!scripts\mp\_utility::istrue(param_01))
		{
			if(isdefined(var_03))
			{
				var_03 delete();
			}
		}

		if(!isdefined(var_04))
		{
			return;
		}

		if(!var_06)
		{
			var_04.iscapturingcrate = 0;
			continue;
		}

		var_04.iscapturingcrate = 0;
		self notify("captured",var_04);
	}
}

//Function Number: 84
crateownercapturethink(param_00)
{
	self endon("restarting_physics");
	while(isdefined(self))
	{
		self waittill("trigger",var_01);
		if(isdefined(self.triggerportableradarping) && var_01 != self.triggerportableradarping)
		{
			continue;
		}

		if(!validateopenconditions(var_01))
		{
			continue;
		}

		var_01.iscapturingcrate = 1;
		if(!useholdthink(var_01,500,param_00))
		{
			var_01.iscapturingcrate = 0;
			continue;
		}

		var_01.iscapturingcrate = 0;
		self notify("captured",var_01);
	}
}

//Function Number: 85
crateallcapturethink(param_00)
{
	self endon("restarting_physics");
	self.crateuseents = [];
	while(isdefined(self))
	{
		self waittill("trigger",var_01);
		if(!validateopenconditions(var_01))
		{
			continue;
		}

		if(isdefined(level.overridecrateusetime))
		{
			var_02 = level.overridecrateusetime;
			continue;
		}

		var_02 = undefined;
		childthread cratealluselogic(var_01,var_02,param_00);
	}
}

//Function Number: 86
cratealluselogic(param_00,param_01,param_02)
{
	param_00.iscapturingcrate = 1;
	self.crateuseents[param_00.name] = createuseent();
	var_03 = self.crateuseents[param_00.name];
	var_04 = self.crateuseents[param_00.name] useholdthink(param_00,param_01,param_02,self);
	if(isdefined(self.crateuseents) && isdefined(var_03))
	{
		self.crateuseents = scripts\mp\_utility::func_22B1(self.crateuseents,var_03);
		var_03 delete();
	}

	if(!isdefined(param_00))
	{
		return;
	}

	param_00.iscapturingcrate = 0;
	if(var_04)
	{
		self notify("captured",param_00);
	}
}

//Function Number: 87
updatecraftingomnvars()
{
	self.inuse = 0;
	foreach(var_01 in self.crateuseents)
	{
		if(var_01.inuse)
		{
			self.inuse = 1;
			break;
		}
	}
}

//Function Number: 88
validateopenconditions(param_00)
{
	if((self.cratetype == "airdrop_juggernaut_recon" || self.cratetype == "airdrop_juggernaut" || self.cratetype == "airdrop_juggernaut_maniac") && param_00 scripts\mp\_utility::isjuggernaut())
	{
		return 0;
	}

	if(isdefined(param_00.onhelisniper) && param_00.onhelisniper)
	{
		return 0;
	}

	var_01 = param_00 getcurrentweapon();
	if(scripts\mp\_utility::iskillstreakweapon(var_01) && !scripts\mp\_utility::isjuggernautweapon(var_01))
	{
		return 0;
	}

	if(isbot(param_00))
	{
		if(level.gametype != "grnd" && !scripts\mp\bots\_bots_killstreaks::bot_is_killstreak_supported(self.cratetype))
		{
			return 0;
		}

		if(scripts\mp\bots\_bots_killstreaks::iskillstreakblockedforbots(self.cratetype))
		{
			return 0;
		}
	}

	return 1;
}

//Function Number: 89
killstreakcratethink(param_00)
{
	self endon("restarting_physics");
	self endon("death");
	if(isdefined(game["strings"][self.cratetype + "_hint"]))
	{
		var_01 = game["strings"][self.cratetype + "_hint"];
	}
	else
	{
		var_01 = &"PLATFORM_GET_KILLSTREAK";
	}

	var_02 = -10000;
	var_03 = undefined;
	if(!scripts\mp\_utility::istrue(level.gameended))
	{
		if(param_00 == "dronedrop_reroll")
		{
			var_03 = 1;
			if(isdefined(game["strings"][self.cratetype + "_rerollHint"]))
			{
				var_01 = game["strings"][self.cratetype + "_rerollHint"];
			}
		}

		cratesetupforuse(var_01,scripts\mp\_utility::getkillstreakoverheadicon(self.cratetype),var_03,var_02);
	}

	thread crateothercapturethink(undefined,var_03);
	thread crateownercapturethink();
	thread cratewatchgameover();
	for(;;)
	{
		self waittill("captured",var_04);
		if(isplayer(var_04))
		{
			var_04 setclientomnvar("ui_securing",0);
			var_04.ui_securing = undefined;
		}

		if(isdefined(self.triggerportableradarping))
		{
			if(var_04 == self.triggerportableradarping)
			{
				var_04 thread scripts\mp\_missions::func_D991("ch_scorestreak_uses_dronepackage");
			}
			else if(!level.teambased || var_04.team != self.team)
			{
				switch(param_00)
				{
					case "airdrop_osprey_gunner":
					case "airdrop_escort":
					case "airdrop_support":
					case "airdrop_assault":
						var_04 thread scripts\mp\_missions::processchallenge("hijacker_airdrop");
						var_04 thread hijacknotify(self,"airdrop");
						break;

					case "airdrop_sentry_minigun":
						var_04 thread scripts\mp\_missions::processchallenge("hijacker_airdrop");
						var_04 thread hijacknotify(self,"sentry");
						break;

					case "airdrop_remote_tank":
						var_04 thread scripts\mp\_missions::processchallenge("hijacker_airdrop");
						var_04 thread hijacknotify(self,"remote_tank");
						break;

					case "airdrop_mega":
						var_04 thread scripts\mp\_missions::processchallenge("hijacker_airdrop_mega");
						var_04 thread hijacknotify(self,"emergency_airdrop");
						break;

					case "dronedrop_highroll":
					case "jackaldrop":
					case "dronedrop_reroll":
					case "dronedrop":
						var_04 thread hijacknotify(self,"dronedrop");
						var_04 thread scripts\mp\_missions::func_D991("ch_hijack");
						break;
				}
			}
			else if(level.gametype != "grnd")
			{
				self.triggerportableradarping thread scripts\mp\_awards::givemidmatchaward("ss_use_dronedrop");
				self.triggerportableradarping thread scripts\mp\_missions::func_D991("ch_package_share");
			}
		}

		var_04 playlocalsound("ammo_crate_use");
		var_05 = undefined;
		if(scripts\mp\_utility::istrue(level.enablevariantdrops))
		{
			var_05 = scripts\mp\_killstreak_loot::getrandomvariantfrombaseref(self.cratetype);
		}

		if(isdefined(var_05))
		{
			var_06 = scripts\mp\_killstreak_loot::getpassiveperk(var_05);
			var_04 thread scripts\mp\killstreaks\_killstreaks::awardkillstreak(self.cratetype,self.triggerportableradarping,var_06,var_05);
			var_07 = scripts\mp\_killstreak_loot::getrarityforlootitem(var_05);
			var_08 = self.cratetype + "_" + var_07;
			var_04 scripts\mp\_hud_message::showkillstreaksplash(var_08,undefined,1);
		}
		else
		{
			var_04 thread scripts\mp\killstreaks\_killstreaks::givekillstreak(self.cratetype,0,0,self.triggerportableradarping);
			var_04 scripts\mp\_hud_message::showkillstreaksplash(self.cratetype,undefined,1);
		}

		if(scripts\mp\killstreaks\_killstreaks::getstreakcost(self.cratetype) > 1000)
		{
			var_04 thread scripts\mp\_missions::func_D991("ch_dronepackage_jackpot");
		}

		deletecrateold();
	}
}

//Function Number: 90
killstreakbombcratethink(param_00)
{
	self endon("restarting_physics");
	self endon("death");
	if(isdefined(self.triggerportableradarping))
	{
		self.triggerportableradarping endon("disconnect");
	}

	var_01 = [&"KILLSTREAKS_HINTS_SENTRY_SHOCK_PICKUP",&"KILLSTREAKS_HINTS_JACKAL_PICKUP",&"KILLSTREAKS_HINTS_THOR_PICKUP",&"KILLSTREAKS_HINTS_RC8_PICKUP",&"KILLSTREAKS_HINTS_MINI_JACKAL_PICKUP"];
	var_02 = scripts\engine\utility::random(var_01);
	var_03 = undefined;
	if(level.gametype == "grnd")
	{
		var_03 = -10000;
	}

	if(!scripts\mp\_utility::istrue(level.gameended))
	{
		cratesetupforuse(var_02,"hud_icon_trap_package",0,var_03);
	}

	thread crateothercapturethink();
	thread cratewatchgameover();
	thread cratewatchownerdisconnect();
	if(isdefined(self.killcament))
	{
		self.killcament unlink();
		self.killcament moveto(self.origin + (0,0,30),0.05);
	}

	self waittill("captured",var_04);
	if(isplayer(var_04))
	{
		var_04 setclientomnvar("ui_securing",0);
		var_04.ui_securing = undefined;
	}

	var_04 playlocalsound("ammo_crate_use");
	var_05 = self.triggerportableradarping scripts\mp\_utility::_launchgrenade("dummy_spike_mp",self.origin,self.origin,2);
	if(!isdefined(var_05.weapon_name))
	{
		var_05.weapon_name = "dummy_spike_mp";
	}

	var_05 linkto(self);
	var_06 = 0.1;
	var_07 = 0;
	while(var_07 < 0.8)
	{
		playsoundatpos(self.origin + (0,0,10),"mp_dronepackage_trap_warning");
		var_07 = var_07 + var_06;
		wait(var_06);
	}

	playfx(scripts\engine\utility::getfx("crate_explode"),self.origin);
	playsoundatpos(self.origin,"mp_equip_destroyed");
	scripts\mp\_shellshock::func_22FF(1,0.7,800);
	if(isdefined(self.triggerportableradarping))
	{
		self radiusdamage(self.origin,256,200,100,self.triggerportableradarping,"MOD_EXPLOSIVE","jackal_fast_cannon_mp");
	}

	deletecrateold();
}

//Function Number: 91
cratewatchownerdisconnect()
{
	self endon("death");
	self.triggerportableradarping waittill("disconnect");
	deletecrateold();
}

//Function Number: 92
cratewatchgameover()
{
	self endon("death");
	level scripts\engine\utility::waittill_any_3("bro_shot_start","game_ended");
	if(isdefined(self))
	{
		deletecrateold();
	}
}

//Function Number: 93
dronewatchgameover()
{
	self endon("death");
	level scripts\engine\utility::waittill_any_3("bro_shot_start","game_ended");
	if(isdefined(self))
	{
		self notify("death");
	}
}

//Function Number: 94
nukecratethink(param_00)
{
	self endon("restarting_physics");
	self endon("death");
	cratesetupforuse(&"PLATFORM_CALL_NUKE",scripts\mp\_utility::getkillstreakoverheadicon(self.cratetype));
	thread nukecapturethink();
	for(;;)
	{
		self waittill("captured",var_01);
		var_01 thread scripts\mp\killstreaks\_killstreaks::func_729F(self.cratetype);
		level notify("nukeCaptured",var_01);
		if(isdefined(level.gtnw) && level.gtnw)
		{
			var_01.capturednuke = 1;
		}

		var_01 playlocalsound("ammo_crate_use");
		deletecrateold();
	}
}

//Function Number: 95
juggernautcratethink(param_00)
{
	self endon("restarting_physics");
	self endon("death");
	cratesetupforuse(game["strings"][self.cratetype + "_hint"],scripts\mp\_utility::getkillstreakoverheadicon(self.cratetype));
	thread crateothercapturethink();
	thread crateownercapturethink();
	for(;;)
	{
		self waittill("captured",var_01);
		if(isdefined(self.triggerportableradarping) && var_01 != self.triggerportableradarping)
		{
			if(!level.teambased || var_01.team != self.team)
			{
				if(self.cratetype == "airdrop_juggernaut_maniac")
				{
					var_01 thread hijacknotify(self,"maniac");
				}
				else if(scripts\mp\_utility::isstrstart(self.cratetype,"juggernaut_"))
				{
					var_01 thread hijacknotify(self,self.cratetype);
				}
				else
				{
					var_01 thread hijacknotify(self,"juggernaut");
				}
			}
			else if(self.cratetype == "airdrop_juggernaut_maniac")
			{
				self.triggerportableradarping scripts\mp\_hud_message::showsplash("giveaway_juggernaut_maniac",undefined,var_01);
			}
			else if(scripts\mp\_utility::isstrstart(self.cratetype,"juggernaut_"))
			{
				self.triggerportableradarping scripts\mp\_hud_message::showsplash("giveaway_" + self.cratetype,undefined,var_01);
			}
			else
			{
				self.triggerportableradarping scripts\mp\_hud_message::showsplash("giveaway_juggernaut",undefined,var_01);
			}
		}

		var_01 playlocalsound("ammo_crate_use");
		var_02 = "juggernaut";
		switch(self.cratetype)
		{
			case "airdrop_juggernaut":
				var_02 = "juggernaut";
				break;
	
			case "airdrop_juggernaut_recon":
				var_02 = "juggernaut_recon";
				break;
	
			case "airdrop_juggernaut_maniac":
				var_02 = "juggernaut_maniac";
				break;
	
			default:
				if(scripts\mp\_utility::isstrstart(self.cratetype,"juggernaut_"))
				{
					var_02 = self.cratetype;
				}
				break;
		}

		var_01 thread scripts\mp\killstreaks\_juggernaut::givejuggernaut(var_02);
		deletecrateold();
	}
}

//Function Number: 96
sentrycratethink(param_00)
{
	self endon("death");
	cratesetupforuse(game["strings"]["sentry_hint"],scripts\mp\_utility::getkillstreakoverheadicon(self.cratetype));
	thread crateothercapturethink();
	thread crateownercapturethink();
	for(;;)
	{
		self waittill("captured",var_01);
		if(isdefined(self.triggerportableradarping) && var_01 != self.triggerportableradarping)
		{
			if(!level.teambased || var_01.team != self.team)
			{
				if(issubstr(param_00,"airdrop_sentry"))
				{
					var_01 thread hijacknotify(self,"sentry");
				}
				else
				{
					var_01 thread hijacknotify(self,"emergency_airdrop");
				}
			}
			else
			{
				self.triggerportableradarping thread scripts\mp\_utility::giveunifiedpoints("killstreak_giveaway",undefined,int(scripts\mp\killstreaks\_killstreaks::getstreakcost("sentry") / 10) * 50);
				self.triggerportableradarping scripts\mp\_hud_message::showsplash("giveaway_sentry",undefined,var_01);
			}
		}

		var_01 playlocalsound("ammo_crate_use");
		var_01 thread sentryusetracker();
		deletecrateold();
	}
}

//Function Number: 97
deletecrateold()
{
	self notify("crate_deleting");
	if(isdefined(self.usedby))
	{
		foreach(var_01 in self.usedby)
		{
			var_01 setclientomnvar("ui_securing",0);
			var_01.ui_securing = undefined;
		}
	}

	if(isdefined(self.minimapid))
	{
		scripts\mp\objidpoolmanager::returnminimapid(self.minimapid);
	}

	if(isdefined(self.bomb) && isdefined(self.bomb.killcament))
	{
		self.bomb.killcament delete();
	}

	if(isdefined(self.bomb))
	{
		self.bomb delete();
	}

	if(isdefined(self.killcament))
	{
		self.killcament delete();
	}

	if(isdefined(self.droptype))
	{
		playfx(scripts\engine\utility::getfx("airdrop_crate_destroy"),self.origin);
	}

	if(isdefined(self.var_BE6F))
	{
		self notify("nav_obstacle_destroyed");
		destroynavobstacle(self.var_BE6F);
		self.var_BE6F = undefined;
	}

	self delete();
}

//Function Number: 98
sentryusetracker()
{
	if(!scripts\mp\killstreaks\_autosentry::givesentry("sentry_minigun",0,0))
	{
		scripts\mp\killstreaks\_killstreaks::givekillstreak("sentry");
	}
}

//Function Number: 99
hijacknotify(param_00,param_01)
{
	self notify("hijacker",param_01,param_00.triggerportableradarping);
}

//Function Number: 100
refillammo(param_00)
{
	var_01 = self getweaponslistall();
	if(param_00)
	{
	}

	foreach(var_03 in var_01)
	{
		if(issubstr(var_03,"grenade") || getsubstr(var_03,0,2) == "gl")
		{
			if(!param_00 || self getrunningforwardpainanim(var_03) >= 1)
			{
				continue;
			}
		}

		self givemaxammo(var_03);
	}
}

//Function Number: 101
useholdthink(param_00,param_01,param_02,param_03)
{
	scripts\mp\_movers::script_mover_link_to_use_object(param_00);
	param_00 scripts\engine\utility::allow_weapon(0);
	self.curprogress = 0;
	self.inuse = 1;
	self.userate = 0;
	if(isdefined(param_03))
	{
		param_03 updatecraftingomnvars();
	}

	if(isdefined(param_01))
	{
		self.usetime = param_01;
	}
	else
	{
		self.usetime = 3000;
	}

	var_04 = useholdthinkloop(param_00);
	if(isalive(param_00))
	{
		param_00 scripts\engine\utility::allow_weapon(1);
	}

	if(isdefined(param_00))
	{
		scripts\mp\_movers::script_mover_unlink_from_use_object(param_00);
	}

	if(!isdefined(self))
	{
		return 0;
	}

	self.inuse = 0;
	self.curprogress = 0;
	if(isdefined(param_03))
	{
		param_03 updatecraftingomnvars();
	}

	return var_04;
}

//Function Number: 102
useholdthinkloop(param_00)
{
	while(param_00 scripts\mp\killstreaks\_deployablebox::isplayerusingbox(self))
	{
		if(!param_00 scripts\mp\_movers::script_mover_use_can_link(self))
		{
			param_00 scripts\mp\_gameobjects::updateuiprogress(self,0);
			return 0;
		}

		self.curprogress = self.curprogress + 50 * self.userate;
		if(isdefined(self.objectivescaler))
		{
			self.userate = 1 * self.objectivescaler;
		}
		else
		{
			self.userate = 1;
		}

		param_00 scripts\mp\_gameobjects::updateuiprogress(self,1);
		if(self.curprogress >= self.usetime)
		{
			param_00 scripts\mp\_gameobjects::updateuiprogress(self,0);
			return scripts\mp\_utility::isreallyalive(param_00);
		}

		wait(0.05);
	}

	if(isdefined(self))
	{
		param_00 scripts\mp\_gameobjects::updateuiprogress(self,0);
	}

	return 0;
}

//Function Number: 103
createuseent()
{
	var_00 = spawn("script_origin",self.origin);
	var_00.curprogress = 0;
	var_00.usetime = 0;
	var_00.userate = 3000;
	var_00.inuse = 0;
	var_00.id = self.id;
	var_00 linkto(self);
	var_00 thread deleteuseent(self);
	return var_00;
}

//Function Number: 104
deleteuseent(param_00)
{
	self endon("death");
	param_00 waittill("death");
	if(isdefined(self.usedby))
	{
		foreach(var_02 in self.usedby)
		{
			var_02 setclientomnvar("ui_securing",0);
			var_02.ui_securing = undefined;
		}
	}

	self delete();
}

//Function Number: 105
airdropdetonateonstuck()
{
	self endon("death");
	self waittill("missile_stuck");
	self detonate();
}

//Function Number: 106
throw_linked_care_packages(param_00,param_01,param_02,param_03)
{
	if(isdefined(level.carepackages))
	{
		foreach(var_05 in level.carepackages)
		{
			if(isdefined(var_05.inuse) && var_05.inuse)
			{
				continue;
			}

			var_06 = var_05 getlinkedparent();
			if(isdefined(var_06) && var_06 == param_00)
			{
				thread spawn_new_care_package(var_05,param_01,param_02);
				if(isdefined(param_03))
				{
					scripts\engine\utility::delaythread(1,::remove_care_packages_in_volume,param_03);
				}
			}
		}
	}
}

//Function Number: 107
spawn_new_care_package(param_00,param_01,param_02)
{
	var_03 = param_00.triggerportableradarping;
	var_04 = param_00.droptype;
	var_05 = param_00.cratetype;
	var_06 = param_00.origin;
	param_00 deletecrateold();
	var_07 = var_03 createairdropcrate(var_03,var_04,var_05,var_06 + param_01,var_06 + param_01);
	var_07.droppingtoground = 1;
	var_07 thread [[ level.cratetypes[var_07.droptype][var_07.cratetype].func ]](var_07.droptype);
	scripts\engine\utility::waitframe();
	var_07 physicslaunchserver(var_07.origin,param_02);
	if(isbot(var_07.triggerportableradarping))
	{
		wait(0.1);
		var_07.triggerportableradarping notify("new_crate_to_take");
	}
}

//Function Number: 108
remove_care_packages_in_volume(param_00)
{
	if(isdefined(level.carepackages))
	{
		foreach(var_02 in level.carepackages)
		{
			if(isdefined(var_02) && isdefined(var_02.friendlymodel) && var_02.friendlymodel istouching(param_00))
			{
				var_02 deletecrateold();
			}
		}
	}
}

//Function Number: 109
get_dummy_crate_model()
{
	return "care_package_iw7_dummy";
}

//Function Number: 110
get_enemy_crate_model()
{
	return "care_package_iw7_ca_wm";
}

//Function Number: 111
get_friendly_crate_model()
{
	return "care_package_iw7_un_wm";
}

//Function Number: 112
dropzoneaddcratetypes()
{
	addcratetype("dronedrop_grnd","jackal",15,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_JACKAL_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("dronedrop_grnd","thor",10,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_THOR_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("dronedrop_grnd","directional_uav",10,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_DIRECTIONAL_UAV_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("dronedrop_grnd","remote_c8",5,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_RC8_PICKUP",undefined,"care_package_iw7_dummy");
	addcratetype("dronedrop_grnd","minijackal",5,::killstreakcratethink,"care_package_iw7_un_wm","care_package_iw7_ca_wm",&"KILLSTREAKS_HINTS_MINI_JACKAL_PICKUP",undefined,"care_package_iw7_dummy");
	generatemaxweightedcratevalue();
}