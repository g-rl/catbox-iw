/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\agents\zombie_dlc4\zombie_dlc4_agent.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 9
 * Decompile Time: 541 ms
 * Timestamp: 10/27/2023 12:11:29 AM
*******************************************************************/

//Function Number: 1
registerscriptedagent()
{
	scripts/aitypes/bt_util::init();
	behaviortree\zombie_dlc4::func_DEE8();
	scripts\asm\zombie_dlc4\mp\states::func_2371();
	if(!isdefined(level.species_funcs))
	{
		level.species_funcs = [];
	}

	level.agent_definition["generic_zombie"]["asm"] = "zombie_dlc4";
	level.agent_definition["generic_zombie"]["behaviorTree"] = "zombie_dlc4";
	level.agent_definition["generic_zombie"]["animclass"] = "zombie_dlc4_animclass";
	level.var_13BDC = 1;
	level.var_4878 = 0;
	level.var_BF7C = 0;
	level.movemodefunc = [];
	level.var_BCE5 = [];
	level.var_C082 = [];
	level.var_126E9 = [];
	level.var_8EE6 = [];
	level.var_5662 = [];
	level.playerteam = "allies";
	scripts\mp\agents\zombie\zmb_zombie_agent::func_9890();
	scripts\mp\agents\zombie\zmb_zombie_agent::func_98A5();
	scripts\mp\agents\zombie\zmb_zombie_agent::func_97FB();
	scripts\mp\agents\zombie\zmb_zombie_agent::func_AEB0();
	thread func_FAB0();
	thread scripts\mp\agents\zombie\zmb_zombie_agent::func_BC5C();
}

//Function Number: 2
zombieinit_dlc()
{
	scripts/asm/zombie/zombie::func_13F9A();
}

//Function Number: 3
func_FAB0()
{
	level endon("game_ended");
	if(!isdefined(level.agent_definition))
	{
		level waittill("scripted_agents_initialized");
	}

	level.agent_definition["generic_zombie"]["setup_func"] = ::setupagent;
	level.agent_definition["generic_zombie"]["setup_model_func"] = ::func_FACE;
	level.agent_funcs["generic_zombie"]["gametype_on_damage_finished"] = ::scripts/cp/agents/gametype_zombie::onzombiedamagefinished;
	level.agent_funcs["generic_zombie"]["gametype_on_killed"] = ::scripts\cp\maps\cp_final\cp_final_damage::cp_final_onzombiekilled;
	level.agent_funcs["generic_zombie"]["on_damaged"] = ::scripts\cp\maps\cp_final\cp_final_damage::cp_final_onzombiedamaged;
	level.agent_funcs["generic_zombie"]["on_damaged_finished"] = ::onzombiedamagefinished;
	level.agent_funcs["generic_zombie"]["on_killed"] = ::onzombiekilled;
}

//Function Number: 4
setupagent()
{
	scripts\mp\agents\zombie\zmb_zombie_agent::setupagent();
	self.kung_fu_punched = 0;
	self.pinched = undefined;
	self.fridge_trap_marked = undefined;
	if(scripts\engine\utility::istrue(self.activated_venomx_sphere))
	{
		self.activated_venomx_sphere = undefined;
	}

	if(scripts\engine\utility::istrue(self.dot_triggered))
	{
		self.dot_triggered = undefined;
	}
}

//Function Number: 5
func_FACE(param_00)
{
	scripts\mp\agents\zombie\zmb_zombie_agent::func_FACE();
}

//Function Number: 6
dopiranhatrapdeath()
{
	scripts/asm/asm::asm_setstate("piranha_trap");
}

//Function Number: 7
onzombiedamagefinished(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B,param_0C)
{
	scripts\mp\agents\zombie\zmb_zombie_agent::onzombiedamagefinished(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B,param_0C);
}

//Function Number: 8
onzombiekilled(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08)
{
	scripts\mp\agents\zombie\zmb_zombie_agent::onzombiekilled(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08);
}

//Function Number: 9
func_C4BD(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09)
{
	scripts\mp\agents\zombie\zmb_zombie_agent::func_C4BD(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09);
}