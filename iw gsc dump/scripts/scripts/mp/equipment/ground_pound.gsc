/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 3561.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 17
 * Decompile Time: 10 ms
 * Timestamp: 10/27/2023 12:30:42 AM
*******************************************************************/

//Function Number: 1
init()
{
	groundpound_initimpactstructs();
}

//Function Number: 2
func_8659(param_00)
{
	self allowgroundpound(1);
	thread func_8654();
	thread groundpound_monitoractivation();
}

//Function Number: 3
func_865A()
{
	self allowgroundpound(0);
	if(self.loadoutarchetype == "archetype_heavy")
	{
		self setscriptablepartstate("groundPound","neutral",0);
	}

	self notify("groundPound_unset");
}

//Function Number: 4
func_8654()
{
	self endon("death");
	self endon("disconnect");
	self endon("groundPound_unset");
	for(;;)
	{
		self waittill("groundPoundLand",var_00);
		thread groundpound_impact(self,var_00);
		scripts\mp\_utility::printgameaction("ground pound land",self);
	}
}

//Function Number: 5
groundpound_monitoractivation()
{
	self endon("death");
	self endon("disconnect");
	self endon("groundPound_unset");
	for(;;)
	{
		self waittill("groundPoundBegin");
		thread groundpound_activate(self);
	}
}

//Function Number: 6
groundpound_activate(param_00)
{
	param_00 setscriptablepartstate("groundPound","activated");
}

//Function Number: 7
groundpound_impact(param_00,param_01)
{
	param_00 setclientomnvar("ui_hud_shake",1);
	param_00 setscriptablepartstate("groundPound","impact");
	var_02 = groundpound_getbestimpactstruct(param_01);
	if(!isdefined(var_02))
	{
		return;
	}

	var_03 = param_00.origin + (0,0,2);
	thread groundpound_impactphysics(var_03,var_02.physicsradmin,var_02.physicsradmax,var_02.physicsscale);
	if(isdefined(var_02.stopfxontag))
	{
		var_04 = spawn("script_model",var_03);
		var_04.angles = param_00.angles;
		var_04.triggerportableradarping = param_00;
		var_04.weapon_name = "groundpound_mp";
		var_04.impactstruct = var_02;
		var_04.killcament = param_00;
		var_04 setentityowner(param_00);
		var_04 setotherent(param_00);
		var_04 setmodel(var_02.stopfxontag);
		if(isdefined(var_02.updategamerprofileall) && isdefined(var_02.var_10E2C))
		{
			var_04 setscriptablepartstate(var_02.updategamerprofileall,var_02.var_10E2C);
		}

		if(isdefined(var_02.deletiondelay))
		{
			wait(var_02.deletiondelay);
		}
		else
		{
			scripts\engine\utility::waitframe();
		}

		var_04 delete();
	}
}

//Function Number: 8
groundpound_impactphysics(param_00,param_01,param_02,param_03)
{
	if(!isdefined(param_01) || param_01 == 0)
	{
		return;
	}

	if(!isdefined(param_02) || param_02 == 0)
	{
		return;
	}

	if(!isdefined(param_03) || param_03 == 0)
	{
		return;
	}

	wait(0.1);
	physicsexplosionsphere(param_00,param_02,param_01,param_03);
}

//Function Number: 9
groundpound_victimimpacteffects(param_00,param_01,param_02,param_03)
{
	if(!isdefined(param_00))
	{
		return;
	}

	if(param_00 == param_01)
	{
		return;
	}

	if(param_01 scripts\mp\_utility::isusingremote())
	{
		return;
	}

	if(!isdefined(param_03))
	{
		return;
	}

	var_04 = param_03.impactstruct;
	if(!isdefined(var_04))
	{
		return;
	}

	if(!isdefined(var_04.shock) || var_04.shock == "")
	{
		return;
	}

	if(!isdefined(var_04.shockduration) || var_04.shockduration == 0)
	{
		return;
	}

	param_01 shellshock(var_04.shock,var_04.shockduration);
}

//Function Number: 10
func_8653(param_00,param_01,param_02,param_03,param_04)
{
	if(!isdefined(param_02) || param_02 != "groundpound_mp")
	{
		return param_04;
	}

	if(!isplayer(param_01))
	{
		return param_04;
	}

	if(!isdefined(param_00))
	{
		return param_04;
	}

	if(param_00 == param_01)
	{
		return 0;
	}

	if(!isdefined(param_03))
	{
		return param_04;
	}

	var_05 = param_03.impactstruct;
	if(!isdefined(var_05))
	{
		return param_04;
	}

	var_06 = scripts\engine\utility::ter_op(level.hardcoremode,var_05.innerradsqrhc,var_05.innerradsqr);
	var_07 = scripts\engine\utility::ter_op(level.hardcoremode,var_05.innerdamagehc,var_05.innerdamage);
	var_08 = scripts\engine\utility::ter_op(level.hardcoremode,var_05.outerdamagehc,var_05.outerdamage);
	var_09 = param_01 scripts\mp\_utility::isinarbitraryup();
	var_0A = scripts\engine\utility::ter_op(var_09,self gettagorigin("TAG_EYE",1,1),self gettagorigin("TAG_EYE"));
	var_0B = abs(vectordot(var_0A - param_03.origin,(0,0,1)));
	var_0C = scripts\engine\utility::ter_op(var_09,self gettagorigin("TAG_ORIGIN",1,1),self gettagorigin("TAG_ORIGIN"));
	var_0D = abs(vectordot(var_0C - param_03.origin,(0,0,1)));
	if(var_0B > var_05.maxzdelta && var_0D > var_05.maxzdelta)
	{
		return 0;
	}

	var_0E = var_06 != 0;
	if(var_0E)
	{
		var_0E = var_06 < 0;
		if(!var_0E)
		{
			if(!var_0E)
			{
				var_0F = distancesquared(param_03.origin,param_01.origin);
				if(var_0F <= var_06)
				{
					var_0E = 1;
				}
			}

			if(!var_0E)
			{
				var_0F = distancesquared(param_03.origin,param_01 gettagorigin("j_mainroot"));
				if(var_0F <= var_06)
				{
					var_0E = 1;
				}
			}

			if(!var_0E)
			{
				var_0F = distancesquared(param_03.origin,param_01 geteye());
				if(var_0F <= var_06)
				{
					var_0E = 1;
				}
			}
		}
	}

	if(var_0E)
	{
		param_04 = scripts\engine\utility::ter_op(var_07 > 0,var_07,param_04);
		if(!param_01 isonground())
		{
			param_04 = param_04 * 1;
		}

		return param_04;
	}

	param_04 = scripts\engine\utility::ter_op(var_08 > 0,var_08,param_04);
	if(!param_01 isonground())
	{
		param_04 = param_04 * 1;
	}

	return param_04;
}

//Function Number: 11
groundpound_modifiedblastshieldconst(param_00,param_01)
{
	if(level.hardcoremode)
	{
		if(scripts\mp\_utility::getweaponbasedsmokegrenadecount(param_01) == "groundpound_mp")
		{
			param_00 = 0.65;
		}
	}

	return param_00;
}

//Function Number: 12
func_8651(param_00)
{
	return param_00 _meth_8499();
}

//Function Number: 13
groundpound_initimpactstructs()
{
	var_00 = spawnstruct();
	var_00.impactstructs = [];
	var_01 = groundpound_createimpactstruct();
	var_00.impactstructs[var_00.impactstructs.size] = var_01;
	var_01 = groundpound_createimpactstruct();
	var_01.var_B783 = 150;
	var_01.innerradsqr = 5625;
	var_01.innerradsqr = 5625;
	var_01.var_10E2C = "impact2";
	var_01.physicsradmax = 150;
	var_01.physicsscale = 2.5;
	var_00.impactstructs[var_00.impactstructs.size] = var_01;
	var_01 = groundpound_createimpactstruct();
	var_01.var_B783 = 225;
	var_01.innerradsqr = -1;
	var_01.innerradsqrhc = -1;
	var_01.var_10E2C = "impact3";
	var_01.physicsradmax = 225;
	var_01.physicsscale = 3;
	var_00.impactstructs[var_00.impactstructs.size] = var_01;
	var_01 = groundpound_createimpactstruct();
	var_01.var_B783 = 325;
	var_01.innerradsqr = -1;
	var_01.innerradsqrhc = -1;
	var_01.var_10E2C = "impact4";
	var_01.physicsradmax = 275;
	var_01.physicsscale = 3.5;
	var_00.impactstructs[var_00.impactstructs.size] = var_01;
	var_01 = groundpound_createimpactstruct();
	var_01.var_B783 = 425;
	var_01.innerradsqr = -1;
	var_01.innerradsqrhc = -1;
	var_01.var_10E2C = "impact5";
	var_01.physicsradmax = 325;
	var_01.physicsscale = 4;
	var_00.impactstructs[var_00.impactstructs.size] = var_01;
	var_00.impactstructs = scripts\engine\utility::array_sort_with_func(var_00.impactstructs,::groundpound_compareimpactstruct);
	level.groundpound = var_00;
}

//Function Number: 14
groundpound_createimpactstruct()
{
	var_00 = spawnstruct();
	var_00.var_B783 = 48;
	var_00.maxzdelta = 125;
	var_00.innerradsqr = 0;
	var_00.innerradsqrhc = 0;
	var_00.innerdamage = 105;
	var_00.outerdamage = 55;
	var_00.innerdamagehc = 35;
	var_00.outerdamagehc = 20;
	var_00.stopfxontag = "perk_mp_groundPound_scr";
	var_00.updategamerprofileall = "effects";
	var_00.var_10E2C = "impact1";
	var_00.deletiondelay = 2;
	var_00.physicsradmin = 75;
	var_00.physicsradmax = 100;
	var_00.physicsscale = 2;
	var_00.shock = "concussion_grenade_mp";
	var_00.shockduration = 0.7;
	return var_00;
}

//Function Number: 15
groundpound_compareimpactstruct(param_00,param_01)
{
	return param_00.var_B783 > param_01.var_B783;
}

//Function Number: 16
groundpound_getbestimpactstruct(param_00)
{
	var_01 = undefined;
	foreach(var_03 in level.groundpound.impactstructs)
	{
		if(param_00 < var_03.var_B783)
		{
			continue;
		}

		var_01 = var_03;
		break;
	}

	return var_01;
}

//Function Number: 17
func_8655(param_00,param_01,param_02,param_03)
{
}