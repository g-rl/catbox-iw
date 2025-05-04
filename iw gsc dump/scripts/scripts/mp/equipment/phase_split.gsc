/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 3577.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 14
 * Decompile Time: 3 ms
 * Timestamp: 10/27/2023 12:30:46 AM
*******************************************************************/

//Function Number: 1
init()
{
	level.var_CAA3 = [];
	level.var_CAA3["spawn"] = loadfx("vfx/iw7/_requests/mp/vfx_phasesplit_holo_spawn");
	level.var_CAA3["death"] = loadfx("vfx/iw7/_requests/mp/vfx_phasesplit_holo_death");
	level.var_CAA3["shimmer"] = loadfx("vfx/iw7/_requests/mp/vfx_phasesplit_holo_shimmer");
}

//Function Number: 2
func_CAC1()
{
	func_CABB();
}

//Function Number: 3
func_CAC2()
{
	if(!func_CAB5())
	{
		return 0;
	}

	thread func_CAC4();
	return 1;
}

//Function Number: 4
func_CAC4(param_00)
{
	self endon("death");
	self endon("disconnect");
	self endon("phaseSplit_end");
	self.var_CAB1 = 1;
	var_01 = anglestoright(self.angles) * cos(90) + anglestoforward(self.angles) * sin(90);
	var_02 = var_01 * 64;
	var_03 = self.origin + var_02;
	var_03 = getclosestpointonnavmesh(var_03);
	var_04 = getnodesinradius(var_03,64,0,128);
	var_05 = var_04[0];
	var_06 = 9999999;
	foreach(var_08 in var_04)
	{
		var_09 = lengthsquared(var_08.origin - var_03);
		if(var_09 < var_06)
		{
			var_05 = var_08;
			var_06 = var_09;
		}
	}

	thread func_CAC8();
	var_0B = func_CAC0(var_05);
	var_0B thread func_CAB4();
	var_0B thread func_CAB3();
	var_0B thread func_CAB6();
	scripts\mp\_powers::func_4575(10,"power_phaseSplit_update","phaseSplit_end");
	thread func_CABB(1);
}

//Function Number: 5
func_CAC8()
{
	self endon("death");
	self endon("disconnect");
	self endon("phaseSplit_end");
	while(!scripts\mp\killstreaks\_emp_common::isemped())
	{
		scripts\engine\utility::waitframe();
	}

	thread func_CABB();
}

//Function Number: 6
func_CABB(param_00)
{
	if(!isdefined(self.var_CAB1))
	{
		return;
	}

	self.var_CAB1 = undefined;
	self notify("phaseSplit_end");
	if(!isdefined(param_00) || !param_00)
	{
		self notify("powers_phaseSplit_update",0);
	}
}

//Function Number: 7
func_CAC0(param_00)
{
	if(!isdefined(param_00))
	{
		param_00 = scripts/mp/agents/agent_utility::getvalidspawnpathnodenearplayer(1,1);
	}

	var_01 = scripts\mp\agents\_agents::add_humanoid_agent("phaseSplitAgent",self.team,"callback",param_00.origin,self.angles,self,0,0,"veteran",::func_CAB2);
	if(!isdefined(var_01))
	{
		thread func_CABB();
		return;
	}

	if(isdefined(var_01.headmodel))
	{
		var_01 detach(self.headmodel,"");
		var_01.headmodel = undefined;
	}

	var_01 setmodel(var_01.triggerportableradarping.model);
	var_01.health = 25;
	var_01 botsetflag("disable_attack",1);
	var_02 = var_01.origin + anglestoforward(var_01.angles) * 500;
	var_03 = scripts\common\trace::ray_trace(var_01.origin,var_02,level.players);
	if(!isdefined(var_03))
	{
		var_03["position"] = var_02;
	}
	else
	{
		var_03 = var_03["position"];
	}

	var_04 = getclosestpointonnavmesh(var_03);
	var_04 = getclosestnodeinsight(var_04);
	var_01 botsetscriptgoalnode(var_04,"objective");
	self playlocalsound("ghost_prism_activate");
	playfx(level.var_CAA3["spawn"],var_01.origin,anglestoforward(var_01.angles),anglestoup(var_01.angles));
	return var_01;
}

//Function Number: 8
func_CAB6()
{
	self endon("death");
	for(;;)
	{
		wait(0.75);
		playfxontag(level.var_CAA3["shimmer"],self,"j_spineupper");
	}
}

//Function Number: 9
func_CAB4()
{
	self waittill("death");
	var_00 = self _meth_8113();
	var_00 hide();
	playfx(level.var_CAA3["death"],var_00.origin,anglestoforward(var_00.angles),anglestoup(var_00.angles));
	if(isdefined(self.triggerportableradarping))
	{
		self.triggerportableradarping func_CABB();
		if(scripts\mp\_utility::isreallyalive(self.triggerportableradarping))
		{
			self.triggerportableradarping iprintlnbold("Clone Destroyed");
		}
	}
}

//Function Number: 10
func_CAB3()
{
	self endon("death");
	self.triggerportableradarping scripts\engine\utility::waittill_any_3("death","disconnect","phaseSplit_end");
	self suicide();
}

//Function Number: 11
func_CAB5()
{
	var_00 = scripts/mp/agents/agent_utility::getnumownedactiveagents(self);
	if(var_00 >= 2)
	{
		return 0;
	}

	return 1;
}

//Function Number: 12
func_CAC9()
{
	level.agent_funcs["phaseSplitAgent"] = level.agent_funcs["player"];
	level.agent_funcs["phaseSplitAgent"]["think"] = ::scripts\mp\killstreaks\_agent_killstreak::squadmate_agent_think;
	level.agent_funcs["phaseSplitAgent"]["on_killed"] = ::func_CACA;
	level.agent_funcs["phaseSplitAgent"]["on_damaged"] = ::scripts\mp\agents\_agents::on_agent_player_damaged;
	level.agent_funcs["phaseSplitAgent"]["gametype_update"] = ::scripts\mp\killstreaks\_agent_killstreak::no_gametype_update;
}

//Function Number: 13
func_CACA(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08)
{
	scripts\mp\agents\_agents::on_humanoid_agent_killed_common(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,0);
	if(isplayer(param_01) && isdefined(self.triggerportableradarping) && param_01 != self.triggerportableradarping)
	{
		self.triggerportableradarping scripts\mp\_utility::leaderdialogonplayer("squad_killed");
	}

	scripts/mp/agents/agent_utility::deactivateagent();
}

//Function Number: 14
func_CAB2()
{
	var_00 = self.triggerportableradarping;
	var_01 = [];
	var_02 = var_00 getweaponslistprimaries();
	var_03 = [];
	if(var_02.size > 0 && var_02[0] != "none")
	{
		for(var_04 = 0;var_04 < var_02.size;var_04++)
		{
			if(!scripts\mp\_weapons::isaltmodeweapon(var_02[var_04]))
			{
				var_03[var_03.size] = var_02[var_04];
			}
		}
	}

	var_02 = var_03;
	if(var_02.size > 0 && var_02[0] != "none")
	{
		var_05 = var_02[0];
		var_01["loadoutPrimary"] = scripts\mp\_utility::getweaponrootname(var_05);
		var_06 = function_00E3(var_05);
		for(var_04 = 0;var_04 < var_06.size;var_04++)
		{
			var_07 = scripts\engine\utility::ter_op(var_04 > 0,"loadoutPrimaryAttachment" + var_04 + 1,"loadoutPrimaryAttachment");
			var_01[var_07] = var_06[var_04];
		}

		var_01["loadoutPrimaryCamo"] = function_00E5(var_05);
	}

	if(var_02.size > 0 && var_02[1] != "none")
	{
		var_05 = var_02[1];
		var_01["loadoutSecondary"] = scripts\mp\_utility::getweaponrootname(var_05);
		var_06 = function_00E3(var_05);
		for(var_04 = 0;var_04 < var_06.size;var_04++)
		{
			var_07 = scripts\engine\utility::ter_op(var_04 > 0,"loadoutSecondaryAttachment1" + var_04,"loadoutSecondaryAttachment");
			var_01[var_07] = var_06[var_04];
		}

		var_01["loadoutSecondaryCamo"] = function_00E5(var_05);
	}

	return var_01;
}