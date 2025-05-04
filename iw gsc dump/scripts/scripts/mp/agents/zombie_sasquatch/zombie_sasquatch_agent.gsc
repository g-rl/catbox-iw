/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\agents\zombie_sasquatch\zombie_sasquatch_agent.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 10
 * Decompile Time: 634 ms
 * Timestamp: 10/27/2023 12:11:29 AM
*******************************************************************/

//Function Number: 1
zombiesasquatchagentinit()
{
	registerscriptedagent();
}

//Function Number: 2
registerscriptedagent()
{
	scripts/aitypes/bt_util::init();
	behaviortree\zombie_sasquatch::func_DEE8();
	scripts\asm\zombie_sasquatch\mp\states::func_2371();
	thread func_FAB0();
	func_AE11();
}

//Function Number: 3
func_FAB0()
{
	level endon("game_ended");
	if(!isdefined(level.agent_definition))
	{
		level waittill("scripted_agents_initialized");
	}

	if(!isdefined(level.species_funcs))
	{
		level.species_funcs = [];
	}

	level.species_funcs["zombie_sasquatch"] = [];
	level.agent_definition["zombie_sasquatch"]["setup_func"] = ::setupagent;
	level.agent_definition["zombie_sasquatch"]["setup_model_func"] = ::func_FACE;
	level.agent_funcs["zombie_sasquatch"] = [];
	level.agent_funcs["zombie_sasquatch"]["on_killed"] = ::onsasquatchkilled;
	level.agent_funcs["zombie_sasquatch"]["on_damaged_finished"] = ::onsasquatchdamagefinished;
}

//Function Number: 4
func_AE11()
{
	level._effect["sasquatch_rock_hit"] = loadfx("vfx/iw7/levels/cp_rave/sasquatch/vfx_rave_sas_projectile_impact.vfx");
}

//Function Number: 5
setupagent()
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
	self.marked_for_death = undefined;
	self.trap_killed_by = undefined;
	self.hastraversed = 0;
	self.immune_against_nuke = 1;
	self.aistate = "idle";
	self.synctransients = "run";
	self.sharpturnnotifydist = 150;
	self.fgetarg = 20;
	self.height = 53;
	self.var_252B = 26 + self.fgetarg;
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
	self.defaultgoalradius = self.fgetarg + 1;
	self.dismember_crawl = 0;
	self.died_poorly = 0;
	self.isfrozen = undefined;
	self.flung = undefined;
	self.dismember_crawl = 0;
	self.var_B0FC = 1;
	self.full_gib = 0;
	self.croc_chomp = 0;
	self.spawn_round_num = level.wave_num;
	self.footstepdetectdist = 600;
	self.footstepdetectdistwalk = 600;
	self.footstepdetectdistsprint = 600;
	self.last_damage_time_on_player = [];
	self.allowpain = 1;
	self setavoidanceradius(45);
	if(getdvarint("scr_zombie_left_foot_sharp_turn_only",0) == 1)
	{
		self.var_AB3F = 1;
	}

	self.entered_playspace = 1;
	thread func_899C();
}

//Function Number: 6
func_FACE(param_00)
{
	self setmodel("zmb_sasquatch_fullbody");
}

//Function Number: 7
setup_eye_glow()
{
	self endon("death");
	self getrandomhovernodesaroundtargetpos(1,0.1);
	wait(1);
	self setscriptablepartstate("right_eye","active");
	self setscriptablepartstate("left_eye","active");
}

//Function Number: 8
func_899C()
{
	self endon("death");
	level waittill("game_ended");
	self clearpath();
	var_00 = self.var_164D[self.asmname];
	var_01 = var_00.var_4BC0;
	var_02 = level.asm[self.asmname].states[var_01];
	scripts/asm/asm::func_2388(self.asmname,var_01,var_02,var_02.var_116FB);
	scripts/asm/asm::func_238A(self.asmname,"idle",0.2,undefined,undefined,undefined);
}

//Function Number: 9
onsasquatchkilled(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08)
{
	self getrandomhovernodesaroundtargetpos(1,0);
	self setscriptablepartstate("right_eye","inactive");
	self setscriptablepartstate("left_eye","inactive");
	scripts\mp\mp_agent::default_on_killed(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08);
}

//Function Number: 10
onsasquatchdamagefinished(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B,param_0C)
{
	scripts\mp\mp_agent::default_on_damage_finished(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B,param_0C);
}