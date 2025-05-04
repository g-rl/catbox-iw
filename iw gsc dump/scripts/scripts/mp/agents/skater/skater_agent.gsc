/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\agents\skater\skater_agent.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 7
 * Decompile Time: 412 ms
 * Timestamp: 10/27/2023 12:11:22 AM
*******************************************************************/

//Function Number: 1
registerscriptedagent()
{
	scripts/aitypes/bt_util::init();
	behaviortree\zombie_dlc2::func_DEE8();
	scripts\asm\zombie_dlc2\mp\states::func_2371();
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

	level.agent_funcs["skater"]["on_damaged"] = ::scripts\cp\maps\cp_disco\cp_disco_damage::cp_disco_onzombiedamaged;
	level.agent_funcs["skater"]["gametype_on_damage_finished"] = ::scripts/cp/agents/gametype_zombie::onzombiedamagefinished;
	level.agent_funcs["skater"]["gametype_on_killed"] = ::scripts/cp/agents/gametype_zombie::onzombiekilled;
	level.movemodefunc["skater"] = ::scripts/cp/agents/gametype_zombie::run_if_last_zombie;
	level.agent_definition["skater"]["setup_func"] = ::setupagent;
	level.agent_definition["skater"]["setup_model_func"] = ::func_FACE;
	level.agent_funcs["skater"]["on_damaged_finished"] = ::scripts\mp\agents\zombie\zmb_zombie_agent::onzombiedamagefinished;
	level.agent_funcs["skater"]["on_killed"] = ::scripts\mp\agents\zombie\zmb_zombie_agent::onzombiekilled;
	if(!isdefined(level.var_8CBD))
	{
		level.var_8CBD = [];
	}

	level.var_8CBD["skater"] = ::func_3725;
}

//Function Number: 3
setupagent()
{
	scripts\mp\agents\zombie\zmb_zombie_agent::setupagent();
	self.entered_playspace = 1;
	self.is_suicide_bomber = 1;
	self.nocorpse = 1;
	self.allowpain = 0;
	if(isdefined(level.suicider_avoidance_radius))
	{
		self setavoidanceradius(level.suicider_avoidance_radius);
	}

	thread func_899C();
}

//Function Number: 4
func_899C()
{
	self endon("death");
	level waittill("game_ended");
	self clearpath();
	foreach(var_04, var_01 in self.var_164D)
	{
		var_02 = var_01.var_4BC0;
		var_03 = level.asm[var_04].states[var_02];
		scripts/asm/asm::func_2388(var_04,var_02,var_03,var_03.var_116FB);
		scripts/asm/asm::func_238A(var_04,"idle",0.2,undefined,undefined,undefined);
	}
}

//Function Number: 5
func_FACE(param_00)
{
	self setmodel("roller_skater_female_white");
	thread scripts\mp\agents\zombie\zmb_zombie_agent::func_50EF();
}

//Function Number: 6
func_AEB0()
{
	level._effect["suicide_zmb_death"] = loadfx("vfx/iw7/_requests/coop/vfx_zmb_blackhole_death");
	level._effect["suicide_zmb_explode"] = loadfx("vfx/iw7/levels/cp_disco/vfx_disco_rollerskate_exp.vfx");
}

//Function Number: 7
func_3725()
{
	var_00 = 200;
	switch(level.specialroundcounter)
	{
		case 0:
			var_00 = 145;
			break;

		case 1:
			var_00 = 400;
			break;

		case 2:
			var_00 = 900;
			break;

		case 3:
			var_00 = 900;
			break;

		default:
			var_00 = 900;
			break;
	}

	return var_00;
}