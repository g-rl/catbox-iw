/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 3158.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 32
 * Decompile Time: 10 ms
 * Timestamp: 10/27/2023 12:26:20 AM
*******************************************************************/

//Function Number: 1
func_98CC(param_00,param_01,param_02,param_03)
{
	self._blackboard.shootstate = scripts/asm/asm::asm_getcurrentstate(self.asmname);
}

//Function Number: 2
func_FFC9(param_00,param_01,param_02,param_03)
{
	if(!scripts/asm/asm_bb::func_291C())
	{
		return 0;
	}

	return scripts/asm/asm::func_232B(param_01,"burst_delay_finished");
}

//Function Number: 3
func_8981(param_00)
{
	self endon(param_00 + "_finished");
	func_32BE();
	scripts/asm/asm::asm_fireevent(param_00,"burst_delay_finished");
}

//Function Number: 4
func_FE76(param_00,param_01,param_02,param_03)
{
	thread func_8981(param_01);
	if(scripts/asm/asm_bb::bb_moverequested())
	{
		return;
	}

	lib_0A1E::func_2361(param_00,param_01,param_02,param_03);
}

//Function Number: 5
func_10002(param_00,param_01,param_02,param_03)
{
	if(!func_10081(param_00,param_01,param_02,param_03))
	{
		return 1;
	}

	return 0;
}

//Function Number: 6
func_10081(param_00,param_01,param_02,param_03)
{
	if(!scripts\anim\utility_common::isasniper())
	{
		return 0;
	}

	if(lib_0A2B::func_9F60())
	{
		return 0;
	}

	return 1;
}

//Function Number: 7
func_10080(param_00,param_01,param_02,param_03)
{
	if(!scripts\anim\utility_common::isasniper())
	{
		return func_FFC9(param_00,param_01,param_02,param_03);
	}

	if(lib_0A2B::func_9F60())
	{
		return 0;
	}

	if(!func_FFC9(param_00,param_01,param_02,param_03))
	{
		return 0;
	}

	return 1;
}

//Function Number: 8
func_FE75(param_00,param_01,param_02,param_03)
{
	thread func_8981(param_01);
	if(scripts\anim\utility_common::isasniper())
	{
		return;
	}

	if(scripts/asm/asm_bb::bb_moverequested())
	{
		return;
	}

	lib_0A1E::func_2361(param_00,param_01,param_02,param_03);
}

//Function Number: 9
func_FE58(param_00,param_01,param_02,param_03)
{
	thread func_8981(param_01);
}

//Function Number: 10
func_FECE(param_00,param_01,param_02,param_03)
{
	var_04 = self.asm.shootparams;
	var_05 = self._blackboard.shootparams;
	if(!isdefined(var_05))
	{
		return 1;
	}

	if(scripts\anim\utility_common::isasniper())
	{
		return 0;
	}

	if(func_3DFB(var_04.ent,var_05.ent) || !isdefined(var_04.ent) && func_3DFB(var_04.pos,var_05.pos) || func_3DFB(var_04.var_1119D,var_05.var_1119D))
	{
		return 1;
	}

	return 0;
}

//Function Number: 11
func_FEDC(param_00,param_01,param_02,param_03)
{
	if(isdefined(self.asm.shootparams))
	{
		return self.asm.shootparams.var_FF0B == 1;
	}

	return self._blackboard.shootparams.var_FF0B == 1;
}

//Function Number: 12
func_FED9(param_00,param_01,param_02,param_03)
{
	if(self._blackboard.shootparams.var_1119D == "full" || self._blackboard.shootparams.var_1119D == "burst")
	{
		return 1;
	}

	return 0;
}

//Function Number: 13
func_C185(param_00,param_01,param_02,param_03)
{
	return !func_10078(param_00,param_01,param_02,param_03);
}

//Function Number: 14
func_10078(param_00,param_01,param_02,param_03)
{
	return scripts\anim\utility_common::usingmg() || isdefined(self _meth_8164());
}

//Function Number: 15
func_FEDA(param_00,param_01,param_02,param_03)
{
	return self._blackboard.shootparams.var_1119D == "mg";
}

//Function Number: 16
func_3DFB(param_00,param_01)
{
	if(isdefined(param_00) != isdefined(param_01))
	{
		return 1;
	}

	if(!isdefined(param_01))
	{
		return 0;
	}

	return param_00 != param_01;
}

//Function Number: 17
func_5AAC(param_00)
{
	var_01 = self _meth_8164();
	var_01 _meth_8398();
	var_01 endon("death");
	var_01 endon("turretstatechange");
	var_02 = self.asm.shootparams.var_FF0B;
	while(var_02 > 0)
	{
		var_01 shootturret();
		var_02--;
		self.a.var_A9ED = gettime();
		wait(param_00);
	}

	var_01 givesentry();
}

//Function Number: 18
func_5AAB(param_00,param_01,param_02,param_03)
{
	var_04 = self.asm.shootparams.var_FF0B;
	var_05 = lib_0A1E::asm_getallanimsforstate(param_00,param_01);
	var_06 = getanimlength(var_05);
	var_06 = var_06 / param_03;
	self _meth_83CE();
	while(var_04 > 0)
	{
		var_04--;
		scripts\anim\utility_common::shootenemywrapper(0);
		self _meth_82E7(param_01,var_05,1,param_02,var_06);
		scripts\anim\combat_utility::decrementbulletsinclip();
		wait(param_03);
	}

	self _meth_837D();
}

//Function Number: 19
func_FE70(param_00,param_01,param_02,param_03)
{
	self endon(param_01 + "_finished");
	func_FE89();
	var_04 = func_FE64();
	if(isdefined(self _meth_8164()))
	{
		func_5AAC(var_04);
	}
	else
	{
		func_5AAB(param_00,param_01,param_02,var_04);
	}

	self.asm.shootparams.var_C21C--;
	scripts/asm/asm::asm_fireevent("shoot","shoot_finished");
	scripts/asm/asm::asm_fireevent(param_01,"shoot_finished");
}

//Function Number: 20
func_FE71(param_00,param_01,param_02)
{
	self _meth_837D();
}

//Function Number: 21
func_FE61(param_00,param_01,param_02,param_03)
{
	self endon(param_01 + "_finished");
	if(!isdefined(self.asm.shootparams))
	{
		func_FE89();
	}

	if(scripts\anim\utility_common::isasniper(1))
	{
		lib_0A2B::func_C599();
	}

	var_04 = func_FE64();
	self _meth_83CE();
	var_05 = lib_0A1E::asm_getallanimsforstate(param_00,param_01);
	self _meth_82E7(param_01,var_05,1,param_02,var_04);
	func_FE5C(param_00,param_01,var_05,2);
	self.asm.shootparams.var_C21C--;
	if(!func_FEDC())
	{
		func_FE82(0.05);
	}

	scripts/asm/asm::asm_fireevent("shoot","shoot_finished");
	scripts/asm/asm::asm_fireevent(param_01,"shoot_finished");
	if(scripts\anim\utility_common::isasniper(1))
	{
		lib_0A2B::func_C59A();
	}
}

//Function Number: 22
func_FE7D(param_00)
{
	var_01 = param_00 + "_shotgun_sound";
	var_02 = param_00 + "kill_shotgun_sound";
	thread func_FE84(var_01,var_02,2);
	self endon(var_01);
	self waittillmatch("rechamber",param_00);
	self playsound("ai_shotgun_pump");
	self notify(var_02);
}

//Function Number: 23
func_FE82(param_00)
{
	self endon("terminate_ai_threads");
	wait(param_00);
	self _meth_837D();
}

//Function Number: 24
func_FE5C(param_00,param_01,param_02,param_03)
{
	var_04 = param_01 + "_timeout";
	var_05 = param_01 + "_timeout_end";
	childthread func_FE84(var_04,var_05,param_03);
	self endon(var_04);
	var_06 = animhasnotetrack(param_02,"fire");
	var_07 = weaponclass(self.var_394) == "rocketlauncher";
	if(var_06)
	{
		var_08 = getnotetracktimes(param_02,"fire");
		if(var_08.size == 1 && var_08[0] == 0)
		{
			var_06 = 0;
		}
	}

	var_09 = 0;
	var_0A = self.asm.shootparams.var_FF0B;
	var_0B = var_0A == 1 || self.asm.shootparams.var_1119D == "semi";
	var_0C = isplayer(self.isnodeoccupied) && self.isnodeoccupied scripts\sp\_utility::func_65DB("player_is_invulnerable");
	var_0D = scripts\anim\utility_common::weapon_pump_action_shotgun();
	while(var_09 < var_0A && var_0A > 0)
	{
		if(var_06)
		{
			self waittillmatch("fire",param_01);
		}

		if(!self.bulletsinclip)
		{
			break;
		}

		shootatshootentorpos(var_0B);
		if(var_0C)
		{
			if(randomint(3) == 0)
			{
				self.var_3250--;
			}
		}
		else
		{
			self.var_3250--;
		}

		if(var_07)
		{
			self.a.var_E5DE--;
		}

		var_09++;
		if(var_0D)
		{
			childthread func_FE7D(param_01);
		}

		if(self.asm.shootparams.var_6B92 && var_09 == var_0A)
		{
			break;
		}

		if(!var_06 || var_0A == 1 && self.asm.shootparams.var_1119D == "single")
		{
			self waittillmatch("end",param_01);
		}
	}

	self notify(var_05);
}

//Function Number: 25
shootatshootentorpos(param_00)
{
	if(isdefined(self.asm.shootparams.ent))
	{
		if(isdefined(self.isnodeoccupied) && self.asm.shootparams.ent == self.isnodeoccupied)
		{
			self [[ level.shootenemywrapper_func ]](param_00);
			return;
		}

		return;
	}

	self [[ level.var_FED3 ]](self.asm.shootparams.pos,param_00);
}

//Function Number: 26
func_FE84(param_00,param_01,param_02)
{
	self endon(param_01);
	wait(param_02);
	self notify(param_00);
}

//Function Number: 27
func_FE64()
{
	var_00 = self.asm.shootparams.var_1119D;
	var_01 = 1;
	if(isdefined(self.var_FED4))
	{
		var_01 = self.var_FED4;
	}
	else if(var_00 == "mg")
	{
		var_01 = 0.1;
	}
	else if(var_00 == "full")
	{
		var_01 = scripts\anim\weaponlist::autoshootanimrate() * randomfloatrange(0.5,1);
	}
	else if(var_00 == "burst")
	{
		var_01 = scripts\anim\weaponlist::burstshootanimrate();
	}
	else if(scripts\anim\utility_common::isusingsidearm())
	{
		var_01 = 3;
	}
	else if(scripts\anim\utility_common::isusingshotgun())
	{
		var_01 = scripts\anim\combat_utility::func_FEFE();
	}

	return var_01;
}

//Function Number: 28
func_FE89(param_00,param_01,param_02,param_03)
{
	var_04 = self._blackboard.shootparams;
	if(!isdefined(self.asm.shootparams))
	{
		self.asm.shootparams = spawnstruct();
		self.asm.shootparams.var_C21C = var_04.var_32BD;
	}

	self.asm.shootparams.var_1119D = var_04.var_1119D;
	self.asm.shootparams.var_6B92 = var_04.var_6B92;
	self.asm.shootparams.var_FF0B = var_04.var_FF0B;
	self.asm.shootparams.pos = var_04.pos;
	self.asm.shootparams.ent = var_04.ent;
	switch(var_04.var_1119D)
	{
		case "semi":
		case "burst":
			self.asm.shootparams.var_FF0B = scripts/aitypes/combat::func_4F65(var_04);
			break;

		case "full":
			self.asm.shootparams.var_FF0B = scripts/aitypes/combat::func_4F66();
			break;

		case "mg":
			self.asm.shootparams.var_FF0B = scripts/aitypes/combat::func_4F68();
			break;
	}

	return 1;
}

//Function Number: 29
func_32BE()
{
	if(isdefined(self.asm.shootparams) && self.asm.shootparams.var_1119D == "full" && !self.asm.shootparams.var_6B92)
	{
		if(self.a.var_A9ED == gettime())
		{
			wait(0.05);
		}

		return;
	}

	var_00 = _meth_80E7();
	if(var_00)
	{
		wait(var_00);
	}
}

//Function Number: 30
_meth_80E7()
{
	var_00 = gettime() - self.a.var_A9ED / 1000;
	var_01 = func_7E12();
	if(var_01 > var_00)
	{
		return var_01 - var_00;
	}

	return 0;
}

//Function Number: 31
func_7E13()
{
	var_00 = isdefined(self.turret);
	if(var_00 && isdefined(self.turret.script_delay_min))
	{
		var_01 = self.turret.script_delay_min;
	}
	else
	{
		var_01 = 0.2;
	}

	if(var_00 && isdefined(self.turret.script_delay_max))
	{
		var_02 = self.turret.script_delay_max - var_01;
	}
	else
	{
		var_02 = 0.5;
	}

	return var_01 + randomfloat(var_02);
}

//Function Number: 32
func_7E12()
{
	if(scripts\sp\_mgturret::func_130FD() || weaponclass(self.var_394) == "mg")
	{
		return func_7E13();
	}

	if(scripts\anim\utility_common::isusingsidearm())
	{
		return randomfloatrange(0.15,0.55);
	}

	if(scripts\anim\utility_common::weapon_pump_action_shotgun())
	{
		return randomfloatrange(1,1.7);
	}

	if(scripts\anim\utility_common::isasniper())
	{
		return scripts\anim\combat_utility::getjointype();
	}

	if(isdefined(self.asm.shootparams))
	{
		if(self.asm.shootparams.var_6B92)
		{
			if(isdefined(self.asm.shootparams.ent))
			{
				return randomfloatrange(0.2,0.4);
			}
			else
			{
				return randomfloatrange(0.6,1);
			}
		}

		if(isdefined(self.asm.shootparams.ent))
		{
			return randomfloatrange(0.4,0.9);
		}
		else
		{
			return randomfloatrange(0.8,1.2);
		}
	}

	return randomfloatrange(0.8,1.2);
}