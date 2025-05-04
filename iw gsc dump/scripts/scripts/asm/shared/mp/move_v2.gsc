/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\asm\shared\mp\move_v2.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 3
 * Decompile Time: 215 ms
 * Timestamp: 10\27\2023 12:02:07 AM
*******************************************************************/

//Function Number: 1
waitforsharpturnv2(param_00,param_01,param_02)
{
	self endon(param_01 + "_finished");
	self waittill("path_dir_change",var_03);
	var_04 = [var_03,0];
	scripts\asm\asm::asm_fireevent(param_01,"sharp_turn",var_04);
	thread lib_0F3C::func_136E7(param_00,param_01,param_02);
}

//Function Number: 2
playmoveloopv2(param_00,param_01,param_02,param_03)
{
	thread lib_0F3C::func_136B4(param_00,param_01,param_03);
	thread waitforsharpturnv2(param_00,param_01,param_03);
	thread lib_0F3C::func_136CC(param_00,param_01,param_03);
	var_04 = 1;
	if(isdefined(self.var_2303.moveplaybackrate))
	{
		var_04 = self.var_2303.moveplaybackrate;
	}
	else if(isdefined(self.moveplaybackrate))
	{
		var_04 = self.moveplaybackrate;
	}

	scripts\asm\asm_mp::func_235F(param_00,param_01,param_02,var_04);
}

//Function Number: 3
playsharpturnanimv2(param_00,param_01,param_02,param_03)
{
	self endon(param_01 + "_finished");
	var_04 = scripts\asm\asm_mp::asm_getanim(param_00,param_01);
	self.var_FC61 = undefined;
	self ghostlaunched("anim deltas");
	self orientmode("face angle abs",self.angles);
	var_05 = scripts\asm\asm::func_2341(param_00,param_01);
	if(isdefined(self.moveplaybackrate))
	{
		scripts\mp\agents\_scriptedagents::func_CED2(param_01,var_04,self.moveplaybackrate,param_01,"code_move",var_05);
	}
	else
	{
		scripts\mp\agents\_scriptedagents::func_CED5(param_01,var_04,param_01,"code_move",var_05);
	}

	self orientmode("face motion");
	self ghostlaunched("code_move");
}