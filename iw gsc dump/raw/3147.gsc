/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 3147.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 20
 * Decompile Time: 8 ms
 * Timestamp: 10/27/2023 12:26:17 AM
*******************************************************************/

//Function Number: 1
func_2371()
{
	if(scripts/asm/asm::func_232E("corner_cover_lean_shoot"))
	{
		return;
	}

	scripts/asm/asm::func_230B("corner_cover_lean_shoot","shoot_start");
	scripts/asm/asm::func_2374("cover_left_shoot_single",::lib_0C56::func_FE61,undefined,undefined,::lib_0F3D::func_CEC0,undefined,::lib_0F3D::func_3E96,"single",undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,undefined,undefined,undefined,undefined);
	scripts/asm/asm::func_2375("cover_left_lean_idle",undefined,::scripts/asm/asm::func_68B0,"shoot_finished");
	scripts/asm/asm::func_2374("cover_left_lean_fire",::scripts\asm\shared_utility::func_2B58,undefined,undefined,undefined,undefined,::lib_0F3D::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,undefined,undefined,undefined,1);
	scripts/asm/asm::func_2375("cover_left_lean_shoot_updateparams",undefined,::lib_0C56::func_FE89,undefined);
	scripts/asm/asm::func_2374("cover_left_lean_idle",::lib_0C56::func_FE75,undefined,undefined,::lib_0F3D::func_CEC1,undefined,::lib_0F3D::func_3E96,"shoot_idle",undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,undefined,undefined,undefined,undefined);
	scripts/asm/asm::func_2375("cover_left_lean_fire",undefined,::func_11D85,undefined);
	scripts/asm/asm::func_2374("cover_left_shoot_full",::lib_0C56::func_FE61,undefined,undefined,::lib_0F3D::func_CEC0,undefined,::scripts\asm\shared_utility::func_3E9A,"burst",undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,undefined,undefined,undefined,undefined);
	scripts/asm/asm::func_2375("cover_left_lean_idle",undefined,::scripts/asm/asm::func_68B0,"shoot_finished");
	scripts/asm/asm::func_2374("cover_left_shoot_semi",::lib_0C56::func_FE61,undefined,undefined,::lib_0F3D::func_CEC0,undefined,::scripts\asm\shared_utility::func_3E9A,"semi",undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,undefined,undefined,undefined,undefined);
	scripts/asm/asm::func_2375("cover_left_lean_idle",undefined,::scripts/asm/asm::func_68B0,"shoot_finished");
	scripts/asm/asm::func_2374("cover_right_lean_idle",::lib_0C56::func_FE75,undefined,undefined,::lib_0F3D::func_CEC1,undefined,::lib_0F3D::func_3E96,"shoot_idle",undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,undefined,undefined,undefined,undefined);
	scripts/asm/asm::func_2375("cover_right_lean_fire",undefined,::func_11ED3,undefined);
	scripts/asm/asm::func_2374("cover_right_shoot_full",::lib_0C56::func_FE61,undefined,undefined,::lib_0F3D::func_CEC0,undefined,::scripts\asm\shared_utility::func_3E9A,"burst",undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,undefined,undefined,undefined,undefined);
	scripts/asm/asm::func_2375("cover_right_lean_idle",undefined,::scripts/asm/asm::func_68B0,"shoot_finished");
	scripts/asm/asm::func_2374("cover_right_shoot_semi",::lib_0C56::func_FE61,undefined,undefined,::lib_0F3D::func_CEC0,undefined,::scripts\asm\shared_utility::func_3E9A,"semi",undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,undefined,undefined,undefined,undefined);
	scripts/asm/asm::func_2375("cover_right_lean_idle",undefined,::scripts/asm/asm::func_68B0,"shoot_finished");
	scripts/asm/asm::func_2374("cover_right_lean_fire",::scripts\asm\shared_utility::func_2B58,undefined,undefined,undefined,undefined,::lib_0F3D::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,undefined,undefined,undefined,1);
	scripts/asm/asm::func_2375("cover_right_lean_shoot_updateparams",undefined,::lib_0C56::func_FE89,undefined);
	scripts/asm/asm::func_2374("cover_right_shoot_single",::lib_0C56::func_FE61,undefined,undefined,::lib_0F3D::func_CEC0,undefined,::lib_0F3D::func_3E96,"single",undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,undefined,undefined,undefined,undefined);
	scripts/asm/asm::func_2375("cover_right_lean_idle",undefined,::scripts/asm/asm::func_68B0,"shoot_finished");
	scripts/asm/asm::func_2374("shoot_start",::scripts\asm\shared_utility::func_2B58,undefined,undefined,undefined,undefined,::lib_0F3D::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,undefined,undefined,undefined,1);
	scripts/asm/asm::func_2375("cover_left_lean_shoot",undefined,::func_124B8,undefined);
	scripts/asm/asm::func_2375("cover_right_lean_shoot",undefined,::scripts\asm\shared_utility::func_12668,undefined);
	scripts/asm/asm::func_2374("cover_left_lean_shoot",::scripts\asm\shared_utility::func_2B58,undefined,undefined,undefined,undefined,::lib_0F3D::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,undefined,undefined,undefined,1);
	scripts/asm/asm::func_2375("cover_left_crouch_lean_idle",undefined,::func_11D87,undefined);
	scripts/asm/asm::func_2375("cover_left_lean_idle",undefined,::scripts\asm\shared_utility::func_12668,undefined);
	scripts/asm/asm::func_2374("cover_left_crouch_lean_fire",::scripts\asm\shared_utility::func_2B58,undefined,undefined,undefined,undefined,::lib_0F3D::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,undefined,undefined,undefined,1);
	scripts/asm/asm::func_2375("cover_left_crouch_shoot_updateparams",undefined,::lib_0C56::func_FE89,undefined);
	scripts/asm/asm::func_2374("cover_left_crouch_lean_idle",::lib_0C56::func_FE75,undefined,undefined,::lib_0F3D::func_CEC1,undefined,::lib_0F3D::func_3E96,"shoot_idle",undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,undefined,undefined,undefined,undefined);
	scripts/asm/asm::func_2375("cover_left_crouch_lean_fire",undefined,::func_11CFC,undefined);
	scripts/asm/asm::func_2374("cover_left_crouch_shoot_full",::lib_0C56::func_FE61,undefined,undefined,::lib_0F3D::func_CEC0,undefined,::scripts\asm\shared_utility::func_3E9A,"burst",undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,undefined,undefined,undefined,undefined);
	scripts/asm/asm::func_2375("cover_left_crouch_lean_idle",undefined,::scripts/asm/asm::func_68B0,"shoot_finished");
	scripts/asm/asm::func_2374("cover_left_crouch_shoot_semi",::lib_0C56::func_FE61,undefined,undefined,::lib_0F3D::func_CEC0,undefined,::scripts\asm\shared_utility::func_3E9A,"semi",undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,undefined,undefined,undefined,undefined);
	scripts/asm/asm::func_2375("cover_left_crouch_lean_idle",undefined,::scripts/asm/asm::func_68B0,"shoot_finished");
	scripts/asm/asm::func_2374("cover_left_crouch_shoot_single",::lib_0C56::func_FE61,undefined,undefined,::lib_0F3D::func_CEC0,undefined,::lib_0F3D::func_3E96,"single",undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,undefined,undefined,undefined,undefined);
	scripts/asm/asm::func_2375("cover_left_crouch_lean_idle",undefined,::scripts/asm/asm::func_68B0,"shoot_finished");
	scripts/asm/asm::func_2374("cover_right_lean_shoot",::scripts\asm\shared_utility::func_2B58,undefined,undefined,undefined,undefined,::lib_0F3D::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,undefined,undefined,undefined,1);
	scripts/asm/asm::func_2375("cover_right_crouch_lean_idle",undefined,::func_11ED5,undefined);
	scripts/asm/asm::func_2375("cover_right_lean_idle",undefined,::scripts\asm\shared_utility::func_12668,undefined);
	scripts/asm/asm::func_2374("cover_right_crouch_lean_idle",::lib_0C56::func_FE75,undefined,undefined,::lib_0F3D::func_CEC1,undefined,::lib_0F3D::func_3E96,"shoot_idle",undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,undefined,undefined,undefined,undefined);
	scripts/asm/asm::func_2375("cover_right_crouch_lean_fire",undefined,::func_11E2D,undefined);
	scripts/asm/asm::func_2374("cover_right_crouch_shoot_full",::lib_0C56::func_FE61,undefined,undefined,::lib_0F3D::func_CEC0,undefined,::scripts\asm\shared_utility::func_3E9A,"burst",undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,undefined,undefined,undefined,undefined);
	scripts/asm/asm::func_2375("cover_right_crouch_lean_idle",undefined,::scripts/asm/asm::func_68B0,"shoot_finished");
	scripts/asm/asm::func_2374("cover_right_crouch_shoot_semi",::lib_0C56::func_FE61,undefined,undefined,::lib_0F3D::func_CEC0,undefined,::scripts\asm\shared_utility::func_3E9A,"semi",undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,undefined,undefined,undefined,undefined);
	scripts/asm/asm::func_2375("cover_right_crouch_lean_idle",undefined,::scripts/asm/asm::func_68B0,"shoot_finished");
	scripts/asm/asm::func_2374("cover_right_crouch_shoot_single",::lib_0C56::func_FE61,undefined,undefined,::lib_0F3D::func_CEC0,undefined,::lib_0F3D::func_3E96,"single",undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,undefined,undefined,undefined,undefined);
	scripts/asm/asm::func_2375("cover_right_crouch_lean_idle",undefined,::scripts/asm/asm::func_68B0,"shoot_finished");
	scripts/asm/asm::func_2374("cover_right_crouch_lean_fire",::scripts\asm\shared_utility::func_2B58,undefined,undefined,undefined,undefined,::lib_0F3D::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"death_generic",undefined,undefined,undefined,undefined,undefined,undefined,1);
	scripts/asm/asm::func_2375("cover_right_crouch_shoot_updateparams",undefined,::lib_0C56::func_FE89,undefined);
	scripts/asm/asm::func_2374("cover_left_lean_shoot_updateparams",::scripts\asm\shared_utility::func_2B58,undefined,undefined,undefined,undefined,::lib_0F3D::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,1);
	scripts/asm/asm::func_2375("cover_left_shoot_single",undefined,::func_11D8B,undefined);
	scripts/asm/asm::func_2375("cover_left_shoot_full",undefined,::func_11D89,undefined);
	scripts/asm/asm::func_2375("cover_left_shoot_semi",undefined,::func_11D8A,undefined);
	scripts/asm/asm::func_2374("cover_right_lean_shoot_updateparams",::scripts\asm\shared_utility::func_2B58,undefined,undefined,undefined,undefined,::lib_0F3D::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,1);
	scripts/asm/asm::func_2375("cover_right_shoot_single",undefined,::func_11ED9,undefined);
	scripts/asm/asm::func_2375("cover_right_shoot_full",undefined,::func_11ED7,undefined);
	scripts/asm/asm::func_2375("cover_right_shoot_semi",undefined,::func_11ED8,undefined);
	scripts/asm/asm::func_2374("cover_right_crouch_shoot_updateparams",::scripts\asm\shared_utility::func_2B58,undefined,undefined,undefined,undefined,::lib_0F3D::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,1);
	scripts/asm/asm::func_2375("cover_right_crouch_shoot_single",undefined,::func_11E3E,undefined);
	scripts/asm/asm::func_2375("cover_right_crouch_shoot_full",undefined,::func_11E3C,undefined);
	scripts/asm/asm::func_2375("cover_right_crouch_shoot_semi",undefined,::func_11E3D,undefined);
	scripts/asm/asm::func_2374("cover_left_crouch_shoot_updateparams",::scripts\asm\shared_utility::func_2B58,undefined,undefined,undefined,undefined,::lib_0F3D::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,1);
	scripts/asm/asm::func_2375("cover_left_crouch_shoot_single",undefined,::func_11D0C,undefined);
	scripts/asm/asm::func_2375("cover_left_crouch_shoot_full",undefined,::func_11D0A,undefined);
	scripts/asm/asm::func_2375("cover_left_crouch_shoot_semi",undefined,::func_11D0B,undefined);
	scripts/asm/asm::func_2327();
}

//Function Number: 2
func_11D85(param_00,param_01,param_02,param_03)
{
	return scripts/asm/asm_bb::func_291C();
}

//Function Number: 3
func_11ED3(param_00,param_01,param_02,param_03)
{
	return scripts/asm/asm_bb::func_291C();
}

//Function Number: 4
func_124B8(param_00,param_01,param_02,param_03)
{
	return isdefined(self.target_getindexoftarget) && self.target_getindexoftarget.type == "Cover Left";
}

//Function Number: 5
func_11D87(param_00,param_01,param_02,param_03)
{
	return self.a.pose == "crouch";
}

//Function Number: 6
func_11CFC(param_00,param_01,param_02,param_03)
{
	return scripts/asm/asm_bb::func_291C();
}

//Function Number: 7
func_11ED5(param_00,param_01,param_02,param_03)
{
	return self.a.pose == "crouch";
}

//Function Number: 8
func_11E2D(param_00,param_01,param_02,param_03)
{
	return scripts/asm/asm_bb::func_291C();
}

//Function Number: 9
func_11D8B(param_00,param_01,param_02,param_03)
{
	return self._blackboard.shootparams.var_FF0B == 1;
}

//Function Number: 10
func_11D89(param_00,param_01,param_02,param_03)
{
	return self._blackboard.shootparams.var_1119D == "full" || self._blackboard.shootparams.var_1119D == "burst";
}

//Function Number: 11
func_11D8A(param_00,param_01,param_02,param_03)
{
	return 1;
}

//Function Number: 12
func_11ED9(param_00,param_01,param_02,param_03)
{
	return self._blackboard.shootparams.var_FF0B == 1;
}

//Function Number: 13
func_11ED7(param_00,param_01,param_02,param_03)
{
	return self._blackboard.shootparams.var_1119D == "fire" || self._blackboard.shootparams.var_1119D == "burst";
}

//Function Number: 14
func_11ED8(param_00,param_01,param_02,param_03)
{
	return 1;
}

//Function Number: 15
func_11E3E(param_00,param_01,param_02,param_03)
{
	return self._blackboard.shootparams.var_FF0B == 1;
}

//Function Number: 16
func_11E3C(param_00,param_01,param_02,param_03)
{
	return self._blackboard.shootparams.var_1119D == "full" || self._blackboard.shootparams.var_1119D == "burst";
}

//Function Number: 17
func_11E3D(param_00,param_01,param_02,param_03)
{
	return 1;
}

//Function Number: 18
func_11D0C(param_00,param_01,param_02,param_03)
{
	return self._blackboard.shootparams.var_FF0B == 1;
}

//Function Number: 19
func_11D0A(param_00,param_01,param_02,param_03)
{
	return self._blackboard.shootparams.var_1119D == "full" || self._blackboard.shootparams.var_1119D == "burst";
}

//Function Number: 20
func_11D0B(param_00,param_01,param_02,param_03)
{
	return 1;
}