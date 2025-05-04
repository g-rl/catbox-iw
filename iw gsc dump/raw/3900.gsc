/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 3900.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 25
 * Decompile Time: 3 ms
 * Timestamp: 10/27/2023 12:31:10 AM
*******************************************************************/

//Function Number: 1
func_5AC0()
{
	self endon("killanimscript");
	var_00 = self getspectatepoint();
	var_01 = var_00.var_48;
	self notify("traverse_begin",var_01,var_00);
	self waittill("traverse_end");
}

//Function Number: 2
func_3E96(param_00,param_01,param_02)
{
	if(!isdefined(param_02))
	{
		return func_3EF4(param_00,param_01,param_02);
	}

	return scripts/asm/asm::asm_lookupanimfromalias(param_01,param_02);
}

//Function Number: 3
func_3EB8(param_00,param_01,param_02)
{
	return 0;
}

//Function Number: 4
func_3EF4(param_00,param_01,param_02)
{
	var_03 = self getanimentrycount(param_01);
	if(var_03 == 1)
	{
		return 0;
	}

	return randomint(var_03);
}

//Function Number: 5
func_3EB6(param_00,param_01,param_02)
{
	return func_3E96(param_00,param_01,param_02);
}

//Function Number: 6
func_CEA8(param_00,param_01,param_02,param_03)
{
	scripts/asm/asm_mp::func_2364(param_00,param_01,param_02,param_03);
}

//Function Number: 7
func_B050(param_00,param_01,param_02,param_03)
{
	scripts/asm/asm_mp::func_235F(param_00,param_01,param_02,1);
}

//Function Number: 8
func_136B4(param_00,param_01,param_02)
{
	self endon(param_01 + "_finished");
	self _meth_84BD();
	self waittill("stop_soon");
	self.var_20EE = self _meth_813A();
	scripts/asm/asm::asm_fireevent(param_01,"cover_approach",self.var_20EE);
}

//Function Number: 9
func_136CC(param_00,param_01,param_02)
{
	self endon(param_01 + "_finished");
	self waittill("path_set");
	var_03 = self _meth_813A();
	var_04 = [var_03,1];
	scripts/asm/asm::asm_fireevent(param_01,"sharp_turn",var_04);
	thread func_136CC(param_00,param_01,param_02);
}

//Function Number: 10
func_136E7(param_00,param_01,param_02)
{
	self endon(param_01 + "_finished");
	self waittill("path_dir_change",var_03);
	var_04 = [var_03,1];
	scripts/asm/asm::asm_fireevent(param_01,"sharp_turn",var_04);
	thread func_136E7(param_00,param_01,param_02);
}

//Function Number: 11
func_D4DD(param_00,param_01,param_02,param_03)
{
	thread func_136B4(param_00,param_01,param_03);
	thread func_136E7(param_00,param_01,param_03);
	thread func_136CC(param_00,param_01,param_03);
	var_04 = 1;
	if(isdefined(self.asm.moveplaybackrate))
	{
		var_04 = self.asm.moveplaybackrate;
	}
	else if(isdefined(self.moveplaybackrate))
	{
		var_04 = self.moveplaybackrate;
	}

	scripts/asm/asm_mp::func_235F(param_00,param_01,param_02,var_04);
}

//Function Number: 12
func_FFB6(param_00,param_01,param_02,param_03)
{
	if(!func_100A3(param_00,param_01,param_02,param_03))
	{
		return 1;
	}

	if(!scripts/asm/asm_bb::bb_movetyperequested("combat"))
	{
		return 1;
	}

	if(scripts/asm/asm_bb::bb_meleechargerequested(param_00,param_01,param_02,param_03))
	{
		return 1;
	}

	return 0;
}

//Function Number: 13
func_100A3(param_00,param_01,param_02,param_03)
{
	if(isdefined(param_03))
	{
		if(!scripts/asm/asm_bb::func_2949(param_00,param_01,param_02,param_03))
		{
			return 0;
		}
	}

	if(self._blackboard.alwaysrunforward)
	{
		return 0;
	}

	if(!scripts/asm/asm_bb::bb_movetyperequested("combat"))
	{
		return 0;
	}

	if(!scripts/asm/asm_bb::bb_wantstostrafe())
	{
		return 0;
	}

	if(!isdefined(self.isnodeoccupied))
	{
		if(!isdefined(self.var_6571))
		{
			return 0;
		}
	}

	return 1;
}

//Function Number: 14
isfacingenemy(param_00)
{
	if(!isdefined(param_00))
	{
		param_00 = 0.5;
	}

	var_01 = anglestoforward(self.angles);
	var_02 = vectornormalize(self.isnodeoccupied.origin - self.origin);
	var_03 = vectordot(var_01,var_02);
	if(var_03 < param_00)
	{
		return 0;
	}

	return 1;
}

//Function Number: 15
func_9FFF()
{
	if(isaimedataimtarget())
	{
		return 1;
	}

	return 0;
}

//Function Number: 16
shouldshoot(param_00,param_01,param_02,param_03)
{
	if(!scripts/asm/asm_bb::func_291C())
	{
		return 0;
	}

	if(isdefined(self.isnodeoccupied))
	{
		if(!isfacingenemy() && !func_9FFF())
		{
			return 0;
		}

		if(!self getpersstat(self.isnodeoccupied))
		{
			return 0;
		}
	}

	return 1;
}

//Function Number: 17
func_3EB3(param_00,param_01,param_02)
{
	var_03 = scripts/asm/asm::asm_getdemeanor();
	if(scripts/asm/asm::asm_hasdemeanoranimoverride(var_03,"idle"))
	{
		var_04 = scripts/asm/asm::asm_getdemeanoranimoverride(var_03,"idle");
		if(isarray(var_04))
		{
			return var_04[randomint(var_04.size)];
		}

		return var_04;
	}

	return func_3EAB(param_01,param_02,var_03);
}

//Function Number: 18
func_3EAB(param_00,param_01,param_02)
{
	if(isdefined(self.var_394))
	{
		var_03 = weaponclass(self.var_394);
	}
	else
	{
		var_03 = "none";
	}

	if(!scripts/asm/asm::asm_hasalias(param_01,var_03 + param_02))
	{
		var_03 = "rifle";
	}

	return scripts/asm/asm::asm_lookupanimfromalias(param_01,var_03 + param_02);
}

//Function Number: 19
func_138E2()
{
	if(scripts/asm/asm_bb::func_292C() == "crouch")
	{
		return 1;
	}

	return 0;
}

//Function Number: 20
_meth_811E(param_00)
{
	if(!isdefined(self._blackboard.shootparams))
	{
		return undefined;
	}
	else if(isdefined(self._blackboard.shootparams.ent))
	{
		return self._blackboard.shootparams.ent getshootatpos();
	}
	else if(isdefined(self._blackboard.shootparams.pos))
	{
		return self._blackboard.shootparams.pos;
	}
	else if(isdefined(self.isnodeoccupied))
	{
		return self.isnodeoccupied getshootatpos();
	}

	return undefined;
}

//Function Number: 21
_meth_811C()
{
	if(isdefined(self.var_130A9))
	{
		var_00 = self getspawnteam();
		return (var_00[0],var_00[1],self geteye()[2]);
	}

	return (self.origin[0],self.origin[1],self geteye()[2]);
}

//Function Number: 22
isaimedataimtarget()
{
	if(!isdefined(self._blackboard.shootparams.pos) && !isdefined(self._blackboard.shootparams.ent))
	{
		return 1;
	}

	var_00 = self getspawnpointdist();
	var_01 = _meth_811C();
	var_02 = _meth_811E(var_01);
	if(!isdefined(var_02))
	{
		return 0;
	}

	var_03 = vectortoangles(var_02 - var_01);
	var_04 = scripts\engine\utility::absangleclamp180(var_00[1] - var_03[1]);
	if(var_04 > level.var_1A52)
	{
		if(distancesquared(self geteye(),var_02) > level.var_1A50 || var_04 > level.var_1A51)
		{
		}
	}

	var_05 = func_7DA3();
	return scripts\engine\utility::absangleclamp180(var_00[0] - var_03[0]) <= var_05;
}

//Function Number: 23
func_7DA3()
{
	if(isdefined(self.var_1A44))
	{
		return self.var_1A44;
	}

	return level.var_1A44;
}

//Function Number: 24
func_CEC0(param_00,param_01,param_02)
{
}

//Function Number: 25
func_CEC1(param_00,param_01,param_02)
{
}