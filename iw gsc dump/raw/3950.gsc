/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 3950.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 9
 * Decompile Time: 4 ms
 * Timestamp: 10/27/2023 12:31:18 AM
*******************************************************************/

//Function Number: 1
registerscriptedagent()
{
	scripts/aitypes/bt_util::init();
	lib_03B1::func_DEE8();
	lib_0F39::func_2371();
	if(!isdefined(level.species_funcs))
	{
		level.species_funcs = [];
	}

	level.species_funcs["seeker"] = [];
	level.agent_definition["seeker"]["setup_func"] = ::setupagent;
	level._effect["seeker_warning_beacon"] = loadfx("vfx/iw7/_requests/mp/vfx_light_blink_red.vfx");
	level._effect["seeker_sparks"] = loadfx("vfx/misc/sparks/vfx_transformer_sparks_b_nolight");
	level._effect["seeker_explosion"] = loadfx("vfx/iw7/_requests/mp/power/vfx_spider_gren_exp.vfx");
}

//Function Number: 2
setupcallbacks()
{
	level.agent_funcs["seeker"]["on_killed"] = ::func_C58D;
	level.agent_funcs["seeker"]["on_damaged"] = ::func_C58B;
}

//Function Number: 3
setupagent()
{
	self.accuracy = 0.5;
	self.noattackeraccuracymod = 0;
	self.sharpturnnotifydist = 48;
	self.last_enemy_sight_time = 0;
	self.desiredenemydistmax = 360;
	self.desiredenemydistmin = 340;
	self.maxtimetostrafewithoutlos = 3000;
	self.strafeifwithindist = self.desiredenemydistmax + 100;
	self.fastcrawlanimscale = 12;
	self.forcefastcrawldist = 340;
	self.fastcrawlmaxhealth = 40;
	self.dismemberchargeexplodedistsq = 2500;
	self.explosionradius = 75;
	self.explosiondamagemin = 30;
	self.explosiondamagemax = 50;
	self.meleerangesq = 9216;
	self.meleechargedist = 160;
	self.meleechargedistvsplayer = 250;
	self.meleechargedistreloadmultiplier = 1.2;
	self.maxzdiff = 50;
	self.meleeactorboundsradius = 32;
	self.meleemindamage = 30;
	self.meleemaxdamage = 45;
	self.nocorpse = 1;
	thread func_FAEF();
}

//Function Number: 4
func_FAEF()
{
	self endon("death");
	wait(0.1);
	self _meth_8504(1,"bot_move_forward","bot_jump","bot_double_jump");
}

//Function Number: 5
func_1090C(param_00,param_01,param_02)
{
	scripts\mp\_utility::printgameaction("spider grenade spawn",param_02);
	var_03 = scripts\mp\mp_agent::spawnnewagent("seeker",param_02.team,param_00,param_01);
	if(!isdefined(var_03))
	{
		return undefined;
	}

	scripts/mp/equipment/spider_grenade::spidergrenade_addtoactiveagentarray(var_03);
	var_03.triggerportableradarping = param_02;
	var_03.var_9F72 = 1;
	var_03.var_9F46 = 1;
	if(var_03.triggerportableradarping scripts\mp\_utility::_hasperk("specialty_rugged_eqp"))
	{
		var_03.hasruggedeqp = 1;
		var_03 scripts\mp\mp_agent::set_agent_health(30);
	}

	var_03 setotherent(param_02);
	var_03 setsolid(0);
	return var_03;
}

//Function Number: 6
func_C58B(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B)
{
	var_0C = self.triggerportableradarping;
	var_0D = param_01;
	if(isdefined(param_01) && isdefined(param_01.triggerportableradarping))
	{
		var_0D = param_01.triggerportableradarping;
	}

	if(isdefined(level.weaponmapfunc))
	{
		param_05 = [[ level.weaponmapfunc ]](param_05,param_00);
	}

	if(param_04 == "MOD_FALLING")
	{
		param_02 = 0;
	}
	else if(param_04 == "MOD_MELEE")
	{
		param_02 = 0;
	}
	else if(scripts\mp\_weapons::func_66AA(param_05,param_04))
	{
		param_02 = 0;
	}
	else if(isdefined(param_00) && !scripts/mp/equipment/phase_shift::areentitiesinphase(self,param_00))
	{
		param_02 = 0;
	}
	else if(isdefined(param_01))
	{
		if(!isdefined(param_00) && !scripts/mp/equipment/phase_shift::areentitiesinphase(self,var_0D))
		{
			param_02 = 0;
		}
		else if(!level.friendlyfire && var_0C != var_0D && !scripts\mp\_utility::istrue(scripts\mp\_utility::playersareenemies(var_0C,var_0D)))
		{
			param_02 = 0;
		}
	}

	if(param_02)
	{
		var_0E = getseekermaxhealth();
		var_0F = 1;
		if(scripts\mp\_utility::isfmjdamage(param_05,param_04))
		{
			var_0F = 2;
		}
		else if(param_02 >= scripts\mp\_weapons::minegettwohitthreshold())
		{
			var_0F = 2;
		}

		param_02 = var_0F * var_0E;
		if(isplayer(var_0D))
		{
			var_10 = scripts\engine\utility::ter_op(scripts\mp\_utility::istrue(self.hasruggedeqp),"hitequip","");
			var_0D scripts\mp\_damagefeedback::updatedamagefeedback(var_10,param_02 >= self.maxhealth);
		}

		scripts\mp\_powers::equipmenthit(var_0C,var_0D,param_05,param_04);
		if(param_02 >= self.health)
		{
			if(isdefined(var_0D) && isdefined(var_0C) && scripts\mp\_utility::istrue(scripts\mp\_utility::playersareenemies(var_0D,var_0C)))
			{
				var_0D thread scripts\mp\_utility::giveunifiedpoints("destroyed_equipment");
			}

			if(isdefined(self.triggerportableradarping))
			{
				thread scripts/mp/equipment/spider_grenade::spidergrenade_explode();
				return;
			}
		}
	}

	self getrespawndelay(param_00,param_01,int(param_02),param_03,param_04,param_05,param_06,param_07,param_08,param_09,0,param_0A,param_0B);
}

//Function Number: 7
func_C58D(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08)
{
	scripts/mp/equipment/spider_grenade::spidergrenade_removefromactiveagentarray(self);
	scripts\mp\mp_agent::deactivateagent();
}

//Function Number: 8
getseekermaxhealth()
{
	return 15;
}

//Function Number: 9
getseekermaxhealthrugged()
{
	return 30;
}