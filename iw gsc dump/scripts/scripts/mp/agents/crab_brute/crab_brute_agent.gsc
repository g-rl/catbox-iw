/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\agents\crab_brute\crab_brute_agent.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 15
 * Decompile Time: 916 ms
 * Timestamp: 10/27/2023 12:11:10 AM
*******************************************************************/

//Function Number: 1
registerscriptedagent()
{
	scripts/aitypes/bt_util::init();
	behaviortree\crab_brute::func_DEE8();
	scripts\asm\crab_brute\mp\states::func_2371();
	scripts\mp\agents\crab_brute\crab_brute_tunedata::setuptunedata();
	thread func_FAB0();
}

//Function Number: 2
func_FAB0()
{
	level endon("game_ended");
	if(!isdefined(level.agent_definition))
	{
		level waittill("scripted_agents_initialized");
	}

	level.agent_definition["crab_brute"]["setup_func"] = ::setupagent;
	level.agent_definition["crab_brute"]["setup_model_func"] = ::func_FACE;
	level.agent_funcs["crab_brute"]["on_damaged"] = ::scripts\cp\maps\cp_town\cp_town_damage::cp_town_onzombiedamaged;
	if(!isdefined(level.var_8CBD))
	{
		level.var_8CBD = [];
	}

	level.var_8CBD["crab_brute"] = ::calculatecrabbruteihealth;
	level.agent_funcs["crab_brute"]["gametype_on_killed"] = ::func_C4D1;
	level.brute_loot_check = [];
	if(!isdefined(level.damage_feedback_overrride))
	{
		level.damage_feedback_overrride = [];
	}

	level.damage_feedback_overrride["crab_brute"] = ::scripts\cp\maps\cp_town\cp_town_damage::crog_processdamagefeedback;
	if(!isdefined(level.special_zombie_damage_func))
	{
		level.special_zombie_damage_func = [];
	}

	level.special_zombie_damage_func["crab_brute"] = ::crab_brute_special_damage_func;
}

//Function Number: 3
func_FACE(param_00)
{
	self setmodel("zmb_brutecrab");
}

//Function Number: 4
setupzombiegametypevars()
{
	self.class = undefined;
	self.movespeedscaler = undefined;
	self.avoidkillstreakonspawntimer = undefined;
	self.guid = undefined;
	self.name = undefined;
	self.saved_actionslotdata = undefined;
	self.perks = undefined;
	self.weaponlist = undefined;
	self.objectivescaler = undefined;
	self.sessionteam = undefined;
	self.sessionstate = undefined;
	self.disabledweapon = undefined;
	self.disabledweaponswitch = undefined;
	self.disabledoffhandweapons = undefined;
	self.disabledusability = 1;
	self.nocorpse = undefined;
	self.ignoreme = 0;
	self.precacheleaderboards = 0;
	self.ten_percent_of_max_health = undefined;
	self.command_given = undefined;
	self.current_icon = undefined;
	self.do_immediate_ragdoll = undefined;
	self.can_be_killed = 0;
	self.attack_spot = undefined;
	self.entered_playspace = 0;
	self.marked_for_death = undefined;
	self.trap_killed_by = undefined;
	self.hastraversed = 0;
	self.attackent = undefined;
	self.var_9342 = 1;
	self.aistate = "idle";
	self.synctransients = "walk";
	self.sharpturnnotifydist = 100;
	self.fgetarg = 15;
	self.height = 40;
	self.var_252B = 26 + self.fgetarg;
	self.var_B640 = "normal";
	self.var_B641 = 50;
	self.var_2539 = 54;
	self.var_253A = -64;
	self.var_4D45 = 2250000;
	self.precacheminimapicon = 1;
	self.guid = self getentitynumber();
	self.moveratescale = 1;
	self.var_C081 = 1;
	self.traverseratescale = 1;
	self.generalspeedratescale = 1;
	self.var_2AB2 = 0;
	self.var_2AB8 = 1;
	self.timelineevents = 0;
	self.var_2F = 1;
	self.var_B5F9 = 40;
	self.var_B62E = 70;
	self.meleeradiuswhentargetnotonnavmesh = 80;
	self.meleeradiusbasesq = squared(self.var_B62E);
	self.defaultgoalradius = self.fgetarg + 1;
	self.meleedot = 0.5;
	self.dismember_crawl = 0;
	self.is_crawler = 0;
	self.died_poorly = 0;
	self.damaged_by_player = 0;
	self.isfrozen = undefined;
	self.flung = undefined;
	self.var_B0FC = 1;
	self.full_gib = 0;
	self.loadstartpointtransients = undefined;
	self.var_E821 = undefined;
	self.last_damage_time_on_player = [];
	self.var_8C12 = 0;
	self.hasplayedvignetteanim = undefined;
	self.is_cop = undefined;
	self.pointonsegmentnearesttopoint = 200;
	self.deathmethod = undefined;
	self.var_10A57 = undefined;
	self.gib_fx_override = undefined;
	self.var_CE65 = undefined;
	self.var_29D2 = 1;
	self.vignette_nocorpse = undefined;
	self.death_anim_no_ragdoll = undefined;
	self.dont_cleanup = 1;
	self.dont_scriptkill = 1;
	self.spawn_round_num = level.wave_num;
	if(getdvarint("scr_zombie_left_foot_sharp_turn_only",0) == 1)
	{
		self.var_AB3F = 1;
	}
}

//Function Number: 5
setupagent()
{
	setupzombiegametypevars();
	self.height = self.var_18F4;
	self.fgetarg = self.var_18F9;
	self.immune_against_nuke = 1;
	self.var_B62D = 70;
	self.var_B62E = 70;
	self.meleeradiuswhentargetnotonnavmesh = 80;
	self.meleeradiusbasesq = squared(self.var_B62E);
	self.defaultgoalradius = self.fgetarg + 1;
	self.meleedot = 0.5;
	self.var_B601 = 45;
	self.var_504E = 55;
	self.var_129AF = 55;
	self.var_368 = -60;
	self.isbot = 60;
	self setavoidanceradius(45);
	self.ground_pound_damage = 50;
	self.footstepdetectdist = 2500;
	self.footstepdetectdistwalk = 2500;
	self.footstepdetectdistsprint = 2500;
	self.precacheleaderboards = 1;
	self _meth_85C9(16);
	thread dopostspawnupdates();
	thread listen_for_death_sfx();
}

//Function Number: 6
dopostspawnupdates()
{
	wait(0.5);
	self.dont_cleanup = 1;
}

//Function Number: 7
listen_for_death_sfx()
{
	self waittill("death");
	self playsound("brute_crog_death");
	wait(1);
	self playsound("brute_crog_explo");
}

//Function Number: 8
getenemy()
{
	if(isdefined(self.myenemy))
	{
		return self.myenemy;
	}

	return undefined;
}

//Function Number: 9
lookatenemy()
{
	var_00 = getenemy();
	if(isdefined(var_00))
	{
		var_01 = var_00.origin - self.origin;
		var_02 = vectortoangles(var_01);
		self orientmode("face angle abs",var_02);
		return;
	}

	self orientmode("face angle abs",self.angles);
}

//Function Number: 10
crab_brute_special_damage_func(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B)
{
	if(scripts/asm/asm::asm_isinstate("burrow_loop"))
	{
		return 0;
	}

	if(param_05 == "gas_grenade_mp")
	{
		return 0;
	}

	self.lastdamagetime = gettime();
	if(isdefined(param_07))
	{
		var_0C = scripts\mp\agents\crab_brute\crab_brute_tunedata::gettunedata();
		var_0D = anglestoforward(self.angles) * -1;
		var_0E = vectordot(var_0D,param_07);
		if(var_0E > var_0C.reduce_damage_dot)
		{
			param_02 = param_02 * var_0C.reduce_damage_pct;
			self.armor_hit = 1;
		}
	}

	return param_02;
}

//Function Number: 11
func_C4D1(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B)
{
	if(isdefined(self.agent_type) && self.agent_type == "crab_brute")
	{
		param_01 scripts\cp\cp_merits::processmerit("mt_dlc3_crab_brute");
	}

	var_0C = scripts\engine\utility::random(["ammo_max","instakill_30","cash_2","instakill_30","cash_2","instakill_30","cash_2"]);
	if(isdefined(var_0C) && !isdefined(self.var_72AC))
	{
		if(!isdefined(level.brute_loot_check[self.spawn_round_num]))
		{
			level.brute_loot_check[self.spawn_round_num] = 1;
			level thread scripts\cp\loot::drop_loot(self.origin,param_01,var_0C);
		}
	}

	var_0D = 400;
	level thread boss_death_vo();
	foreach(var_0F in level.players)
	{
		var_0F scripts\cp\cp_persistence::give_player_currency(var_0D);
	}
}

//Function Number: 12
boss_death_vo()
{
	wait(10);
	if(isdefined(level.elvira_ai))
	{
		level thread scripts\cp\cp_vo::try_to_play_vo("ww_crog_defeat_elvira","rave_announcer_vo","highest",70,0,0,1);
		return;
	}

	level thread scripts\cp\cp_vo::try_to_play_vo("ww_crog_defeat_generic","rave_announcer_vo","highest",70,0,0,1);
}

//Function Number: 13
calculatecrabbruteihealth()
{
	return 5000 * level.players.size;
}

//Function Number: 14
shouldignoreenemy(param_00)
{
	if(!isalive(param_00))
	{
		return 1;
	}

	if(param_00.ignoreme || isdefined(param_00.triggerportableradarping) && param_00.triggerportableradarping.ignoreme)
	{
		return 1;
	}

	if(scripts/mp/agents/zombie/zombie_util::shouldignoreent(param_00))
	{
		return 1;
	}

	return 0;
}

//Function Number: 15
create_brute_death_fx(param_00)
{
	self.var_CE65 = 1;
}