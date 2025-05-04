/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\agents\crab_boss\crab_boss_agent.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 8
 * Decompile Time: 466 ms
 * Timestamp: 10/27/2023 12:11:09 AM
*******************************************************************/

//Function Number: 1
registerscriptedagent()
{
	scripts/aitypes/bt_util::init();
	behaviortree\crab_boss::func_DEE8();
	scripts\asm\crab_boss\mp\states::func_2371();
	scripts\mp\agents\crab_boss\crab_boss_tunedata::setuptunedata();
	func_AEB0();
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

	level.agent_definition["crab_boss"]["setup_func"] = ::setupagent;
	level.agent_definition["crab_boss"]["setup_model_func"] = ::func_FACE;
	level.agent_funcs["crab_boss"]["on_damaged_finished"] = ::ondamagefinished;
}

//Function Number: 3
func_FACE(param_00)
{
	self setmodel("zmb_boss_crab");
}

//Function Number: 4
func_AEB0()
{
	level._effect["boss_crab_beam_start_fx"] = loadfx("vfx/iw7/levels/cp_town/crog/vfx_lure_glow_charge.vfx");
}

//Function Number: 5
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
	if(getdvarint("scr_zombie_left_foot_sharp_turn_only",0) == 1)
	{
		self.var_AB3F = 1;
	}
}

//Function Number: 6
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
	self.ground_pound_damage = 50;
	self.footstepdetectdist = 2500;
	self.footstepdetectdistwalk = 2500;
	self.footstepdetectdistsprint = 2500;
	self.precacheleaderboards = 1;
	self.ignoreme = 1;
}

//Function Number: 7
getenemy()
{
	if(isdefined(self.myenemy))
	{
		return self.myenemy;
	}

	return undefined;
}

//Function Number: 8
ondamagefinished(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B,param_0C)
{
	param_02 = 0;
}