/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 3169.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 7
 * Decompile Time: 1 ms
 * Timestamp: 10/27/2023 12:26:23 AM
*******************************************************************/

//Function Number: 1
func_D490(param_00,param_01,param_02,param_03)
{
	self endon(param_01 + "_finished");
	var_04 = lib_0A1E::asm_getallanimsforstate(param_00,param_01);
	self aiclearanim(lib_0A1E::asm_getbodyknob(),param_02);
	self animmode("zonly_physics");
	if(isdefined(self.objective_position) && distancesquared(self.objective_position.origin,self.origin) > 36)
	{
		self orientmode("face angle",vectortoyaw(self.objective_position.origin - self.origin));
	}

	self _meth_82EA(param_01,var_04,1,param_02,1);
	var_05 = animhasnotetrack(var_04,"grenade_left");
	var_06 = animhasnotetrack(var_04,"grenade_right");
	var_07 = var_05 || var_06;
	if(var_07)
	{
		scripts\anim\shared::placeweaponon(self.var_394,"left");
		thread lib_0A1E::func_231F(param_00,param_01);
		if(var_05)
		{
			self waittillmatch("grenade_left",param_01);
		}
		else
		{
			self waittillmatch("grenade_right",param_01);
		}

		self _meth_8228();
		scripts\anim\battlechatter_ai::func_67CF("frag");
		var_08 = self _meth_84F3();
		if(isdefined(var_08))
		{
			var_09 = vectortoyaw(var_08);
			self orientmode("face angle",var_09);
		}

		self waittillmatch("grenade_throw",param_01);
	}
	else
	{
		thread lib_0A1E::func_231F(param_00,param_01);
		self waittillmatch("grenade_throw",param_01);
		self _meth_8228();
		scripts\anim\battlechatter_ai::func_67CF("frag");
	}

	if(isdefined(self.objective_position))
	{
		self _meth_83C2();
	}

	wait(1);
	self notify("killanimscript");
}

//Function Number: 2
func_116F6(param_00,param_01,param_02)
{
	scripts/asm/asm::asm_fireephemeralevent("grenade response","return throw complete");
	scripts\anim\shared::placeweaponon(self.var_394,"right");
	if(isdefined(self.var_C3F2))
	{
		self.objective_team = self.var_C3F2;
		self.var_C3F2 = undefined;
	}
}

//Function Number: 3
func_9E8C()
{
	var_00 = (self.origin[0],self.origin[1],self.origin[2] + 20);
	var_01 = var_00 + anglestoforward(self.angles) * 50;
	return sighttracepassed(var_00,var_01,0,undefined);
}

//Function Number: 4
func_3EDB(param_00,param_01,param_02)
{
	var_03 = undefined;
	var_04 = 1000;
	if(isdefined(self.isnodeoccupied))
	{
		var_04 = distance(self.origin,self.isnodeoccupied.origin);
	}

	var_05 = [];
	if(var_04 < 600 && func_9E8C())
	{
		if(var_04 < 300)
		{
			return scripts/asm/asm::asm_lookupanimfromalias(param_01,"throw_short");
		}
		else
		{
			return scripts/asm/asm::asm_lookupanimfromalias(param_01,"throw_long");
		}
	}

	return scripts/asm/asm::asm_lookupanimfromalias(param_01,"throw_default");
}

//Function Number: 5
func_D48F(param_00,param_01,param_02,param_03)
{
	self.asm.var_312B = randomint(100) > 50;
}

//Function Number: 6
func_1001F(param_00,param_01,param_02,param_03)
{
	if(!self.asm.var_312B)
	{
		return 0;
	}

	if(self.a.pose != "stand")
	{
		return 0;
	}

	if(!isdefined(self.objective_position))
	{
		return 0;
	}

	var_04 = 0;
	var_04 = angleclamp180(vectortoangles(self.objective_position.origin - self.origin)[1] - self.angles[1]);
	if(abs(var_04) < 90 && param_03 == "backward")
	{
		return 0;
	}

	var_05 = lib_0A1E::asm_getallanimsforstate(param_00,param_02);
	var_06 = getmovedelta(var_05,0,0.5);
	var_07 = self gettweakablevalue(var_06);
	if(!self maymovetopoint(var_07))
	{
		return 0;
	}

	return 1;
}

//Function Number: 7
_meth_85B1(param_00,param_01,param_02)
{
	self.asm.var_312B = undefined;
}