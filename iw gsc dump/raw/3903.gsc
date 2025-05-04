/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 3903.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 11
 * Decompile Time: 3 ms
 * Timestamp: 10/27/2023 12:31:11 AM
*******************************************************************/

//Function Number: 1
func_2371()
{
	if(scripts/asm/asm::func_232E("shoot_grey"))
	{
		return;
	}

	scripts/asm/asm::func_230B("shoot_grey","shoot_start");
	scripts/asm/asm::func_2374("shoot_idle",::lib_0F3E::func_FE75,undefined,undefined,::lib_0F3C::func_CEC1,undefined,::lib_0F3C::func_3E96,"shoot_idle",undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,undefined,undefined,undefined,undefined);
	scripts/asm/asm::func_2375("shoot_fire",undefined,::func_124B0,undefined);
	scripts/asm/asm::func_2374("shoot_single",::scripts/asm/zombie_grey/zombie_grey_asm::func_FE6A,undefined,undefined,::lib_0F3C::func_CEC0,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,"shoot",undefined,undefined,undefined);
	scripts/asm/asm::func_2375("shoot_idle",undefined,::scripts/asm/asm::func_68B0,"shoot_finished");
	scripts/asm/asm::func_2374("shoot_full",::scripts/asm/zombie_grey/zombie_grey_asm::func_FE6A,undefined,undefined,::lib_0F3C::func_CEC0,undefined,::scripts\asm\shared_utility::func_3E9A,"burst",undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,"shoot",undefined,undefined,undefined);
	scripts/asm/asm::func_2375("shoot_idle",undefined,::scripts/asm/asm::func_68B0,"shoot_finished");
	scripts/asm/asm::func_2374("shoot_semi",::scripts/asm/zombie_grey/zombie_grey_asm::func_FE6A,undefined,undefined,::lib_0F3C::func_CEC0,undefined,::scripts\asm\shared_utility::func_3E9A,"semi",undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,"shoot",undefined,undefined,undefined);
	scripts/asm/asm::func_2375("shoot_idle",undefined,::scripts/asm/asm::func_68B0,"shoot_finished");
	scripts/asm/asm::func_2374("shoot_start",::lib_0F3E::func_98CC,undefined,undefined,undefined,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,undefined,undefined,undefined,1);
	scripts/asm/asm::func_2375("crouch_shoot_idle",undefined,::func_124BA,undefined);
	scripts/asm/asm::func_2375("shoot_idle",undefined,::scripts\asm\shared_utility::func_12668,undefined);
	scripts/asm/asm::func_2374("shoot_fire",::scripts\asm\shared_utility::func_2B58,undefined,undefined,undefined,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,undefined,undefined,undefined,1);
	scripts/asm/asm::func_2375("shoot_single",undefined,::func_124A9,undefined);
	scripts/asm/asm::func_2375("shoot_full",undefined,::func_124A1,undefined);
	scripts/asm/asm::func_2375("shoot_semi",undefined,::func_124A5,undefined);
	scripts/asm/asm::func_2374("crouch_shoot_idle",::lib_0F3E::func_FE75,undefined,undefined,::lib_0F3C::func_CEC1,undefined,::scripts\asm\shared_utility::chooseanimshoot,"shoot_idle",undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,undefined,undefined,undefined,undefined);
	scripts/asm/asm::func_2375("crouch_shoot_fire",undefined,::func_12047,undefined);
	scripts/asm/asm::func_2375("shoot_start",undefined,::func_1204C,undefined);
	scripts/asm/asm::func_2374("crouch_shoot_full",::lib_0F3E::func_FE61,undefined,undefined,::lib_0F3C::func_CEC0,undefined,::scripts\asm\shared_utility::func_3E9A,"burst",undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,"shoot",undefined,undefined,undefined);
	scripts/asm/asm::func_2375("crouch_shoot_idle",undefined,::scripts/asm/asm::func_68B0,"shoot_finished");
	scripts/asm/asm::func_2374("crouch_shoot_semi",::lib_0F3E::func_FE61,undefined,undefined,::lib_0F3C::func_CEC0,undefined,::scripts\asm\shared_utility::func_3E9A,"semi",undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,"shoot",undefined,undefined,undefined);
	scripts/asm/asm::func_2375("crouch_shoot_idle",undefined,::scripts/asm/asm::func_68B0,"shoot_finished");
	scripts/asm/asm::func_2374("crouch_shoot_fire",::scripts\asm\shared_utility::func_2B58,undefined,undefined,undefined,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,undefined,undefined,undefined,1);
	scripts/asm/asm::func_2375("crouch_shoot_single",undefined,::func_1203F,undefined);
	scripts/asm/asm::func_2375("crouch_shoot_full",undefined,::func_12037,undefined);
	scripts/asm/asm::func_2375("crouch_shoot_semi",undefined,::func_1203B,undefined);
	scripts/asm/asm::func_2374("crouch_shoot_single",::lib_0F3E::func_FE61,undefined,undefined,::lib_0F3C::func_CEC0,undefined,::lib_0F3C::func_3E96,"single",undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,"shoot",undefined,undefined,undefined);
	scripts/asm/asm::func_2375("crouch_shoot_idle",undefined,::scripts/asm/asm::func_68B0,"shoot_finished");
	scripts/asm/asm::func_2327();
}

//Function Number: 2
func_124B0(param_00,param_01,param_02,param_03)
{
	return scripts/asm/asm_bb::func_291C();
}

//Function Number: 3
func_124BA(param_00,param_01,param_02,param_03)
{
	return self.a.pose == "crouch";
}

//Function Number: 4
func_124A9(param_00,param_01,param_02,param_03)
{
	return self._blackboard.shootparams.var_FF0B == 1;
}

//Function Number: 5
func_124A1(param_00,param_01,param_02,param_03)
{
	return self._blackboard.shootparams.var_1119D == "full";
}

//Function Number: 6
func_124A5(param_00,param_01,param_02,param_03)
{
	return 1;
}

//Function Number: 7
func_12047(param_00,param_01,param_02,param_03)
{
	return scripts/asm/asm_bb::func_291C();
}

//Function Number: 8
func_1204C(param_00,param_01,param_02,param_03)
{
	return self.a.pose != "crouch";
}

//Function Number: 9
func_1203F(param_00,param_01,param_02,param_03)
{
	return self._blackboard.shootparams.var_FF0B == 1;
}

//Function Number: 10
func_12037(param_00,param_01,param_02,param_03)
{
	return self._blackboard.shootparams.var_1119D == "full";
}

//Function Number: 11
func_1203B(param_00,param_01,param_02,param_03)
{
	return 1;
}