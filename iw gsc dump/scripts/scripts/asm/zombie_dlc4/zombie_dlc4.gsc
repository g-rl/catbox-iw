/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\asm\zombie_dlc4\zombie_dlc4.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 21
 * Decompile Time: 1092 ms
 * Timestamp: 10\27\2023 12:03:03 AM
*******************************************************************/

//Function Number: 1
playtraverseanimz_dlc(param_00,param_01,param_02,param_03)
{
	scripts\mp\agents\_scriptedagents::setstatelocked(1,"DoTraverse");
	var_04 = self.do_immediate_ragdoll;
	self.do_immediate_ragdoll = 1;
	dotraverseanim_dlc(param_00,param_01,param_02,param_03);
	self.do_immediate_ragdoll = var_04;
	self scragentsetanimscale(1,1);
	scripts\mp\agents\_scriptedagents::setstatelocked(0,"Traverse end_script");
	self.hastraversed = 1;
	self.traversalvector = undefined;
}

//Function Number: 2
removezfromvec(param_00)
{
	return (param_00[0],param_00[1],0);
}

//Function Number: 3
dotraverseanim_dlc(param_00,param_01,param_02,param_03)
{
	self endon("death");
	self endon("terminate_ai_threads");
	var_04 = self getspectatepoint();
	var_05 = self _meth_8146();
	self.endnode_pos = var_05;
	if(!isdefined(var_04))
	{
		return;
	}

	if(!isdefined(var_05))
	{
		return;
	}

	self.var_6378 = var_05;
	self.traversalvector = vectornormalize(var_05 - var_04.origin);
	var_06 = undefined;
	var_06 = var_04.opcode::OP_ScriptMethodCallPointer;
	if(param_01 == "traverse_external")
	{
		var_06 = param_01;
	}

	if(needscrawlinganimstate_dlc(var_06))
	{
		var_06 = "crawling_" + var_06;
	}

	if(!isdefined(var_06))
	{
		return;
	}

	self.is_traversing = 1;
	var_07 = scripts\asm\asm_mp::asm_getanim(param_00,var_06);
	var_08 = var_05 - var_04.origin;
	var_09 = (var_08[0],var_08[1],0);
	var_0A = vectortoangles(var_09);
	var_0B = issubstr(var_06,"jump_across");
	var_0C = var_06 == "traverse_boost" && self.species == "humanoid" || self.species == "zombie";
	self orientmode("face angle abs",var_0A);
	self ghostlaunched("anim deltas");
	var_0D = self getsafecircleorigin(var_06,var_07);
	var_0E = "flex_height_up_start_fix";
	var_0F = getnotetracktimes(var_0D,var_0E);
	if(var_0F.size == 0)
	{
		var_0E = "flex_height_up_start";
		var_0F = getnotetracktimes(var_0D,var_0E);
		if(var_0F.size == 0)
		{
			var_0E = "flex_height_start";
			var_0F = getnotetracktimes(var_0D,var_0E);
			if(var_0F.size == 0)
			{
				var_0E = "traverse_jump_start";
				var_0F = getnotetracktimes(var_0D,var_0E);
			}
		}
	}

	var_10 = "flex_height_up_end_fix";
	var_11 = getnotetracktimes(var_0D,var_10);
	if(var_11.size == 0)
	{
		var_10 = "flex_height_up_end";
		var_11 = getnotetracktimes(var_0D,var_10);
		if(var_11.size == 0)
		{
			var_10 = "flex_height_end";
			var_11 = getnotetracktimes(var_0D,var_10);
			if(var_11.size == 0)
			{
				var_10 = "traverse_jump_end";
				var_11 = getnotetracktimes(var_0D,var_10);
			}
		}
	}

	var_12 = "highest_point";
	var_13 = getnotetracktimes(var_0D,var_12);
	var_14 = "flex_height_down_start_fix";
	var_15 = getnotetracktimes(var_0D,var_14);
	if(var_15.size == 0)
	{
		var_14 = "flex_height_down_start";
		var_15 = getnotetracktimes(var_0D,var_14);
	}

	var_16 = "flex_height_down_end_fix";
	opcode::OP_SetNewLocalVariableFieldCached0 = getnotetracktimes(var_0D,var_16);
	if(var_17.size == 0)
	{
		var_16 = "flex_height_down_end";
		opcode::OP_SetNewLocalVariableFieldCached0 = getnotetracktimes(var_0D,var_16);
	}

	opcode::OP_EvalSelfFieldVariable = "crawler_early_stop";
	opcode::OP_Return = getnotetracktimes(var_0D,opcode::OP_EvalSelfFieldVariable);
	opcode::OP_CallBuiltin0 = getnotetracktimes(var_0D,"code_move");
	if(var_1A.size > 0)
	{
		opcode::OP_CallBuiltin1 = getmovedelta(var_0D,0,opcode::OP_CallBuiltin0[0]);
	}
	else
	{
		opcode::OP_CallBuiltin1 = getmovedelta(var_0E,0,1);
	}

	opcode::OP_CallBuiltin2 = scripts\mp\agents\_scriptedagents::func_7DC9(var_08,opcode::OP_CallBuiltin1);
	opcode::OP_CallBuiltin3 = animhasnotetrack(var_0D,"ignoreanimscaling");
	if(opcode::OP_CallBuiltin3)
	{
		var_1C.var_13E2B = 1;
	}

	self gib_fx_override("noclip");
	opcode::OP_CallBuiltin4 = self _meth_8145();
	if(isdefined(opcode::OP_CallBuiltin4) && isdefined(var_1E.target))
	{
		self.endnode = opcode::OP_CallBuiltin4;
		opcode::OP_CallBuiltin5 = scripts\common\utility::getstruct(self.var_6366.target,"targetname");
		if(var_13.size > 0)
		{
			scripts\mp\agents\_scriptedagents::func_5AC1(var_06,var_07,var_0D,"traverse",var_0E,var_12,0,::zombietraversenotetrackhandler_dlc);
			opcode::OP_CallBuiltin5 = scripts\common\utility::getstruct(self.var_6366.target,"targetname");
			if(isdefined(var_1F.script_noteworthy) && var_1F.script_noteworthy == "continue_flex_height")
			{
				scripts\mp\agents\_scriptedagents::func_5AC1(var_06,var_07,var_0D,"traverse",var_12,var_10,1,::zombietraversenotetrackhandler_dlc);
			}

			self scragentsetanimscale(1,1);
			scripts\mp\agents\_scriptedagents::func_CED5(var_06,var_07,"traverse","end",::zombietraversenotetrackhandler_dlc);
		}
		else if(var_15.size == 0)
		{
			scripts\mp\agents\_scriptedagents::func_5AC1(var_06,var_07,var_0D,"traverse",var_0E,var_10,0,::zombietraversenotetrackhandler_dlc);
			self scragentsetanimscale(1,1);
			scripts\mp\agents\_scriptedagents::func_CED5(var_06,var_07,"traverse","end",::zombietraversenotetrackhandler_dlc);
		}
		else if(var_0F.size == 0)
		{
			scripts\mp\agents\_scriptedagents::func_CED5(var_06,var_07,"traverse","flex_height_down_start",::zombietraversenotetrackhandler_dlc);
			scripts\mp\agents\_scriptedagents::func_5AC1(var_06,var_07,var_0D,"traverse",var_14,var_16,0,::zombietraversenotetrackhandler_dlc);
			self scragentsetanimscale(1,1);
			scripts\mp\agents\_scriptedagents::func_CED5(var_06,var_07,"traverse","end",::zombietraversenotetrackhandler_dlc);
		}
		else
		{
			opcode::OP_CallBuiltin = scripts\common\utility::getstruct(self.var_6366.target,"targetname");
			opcode::OP_CallBuiltin5 = var_20.origin;
			opcode::OP_BoolNot = var_11[0];
			scripts\mp\agents\_scriptedagents::func_5AC2(var_06,var_07,"traverse",var_0D,var_0E,var_10,opcode::OP_CallBuiltin5,opcode::OP_BoolNot,::zombietraversenotetrackhandler_dlc);
			opcode::OP_ScriptFarMethodThreadCall = getanimlength(var_0D);
			if(var_15[0] - var_11[0] >= 0.05 \ opcode::OP_ScriptFarMethodThreadCall)
			{
				self scragentsetanimscale(1,1);
				scripts\mp\agents\_scriptedagents::func_CED2(var_06,var_07,1,"traverse",var_14,::zombietraversenotetrackhandler_dlc);
			}

			opcode::OP_BoolNot = opcode::OP_SetNewLocalVariableFieldCached0[0];
			opcode::OP_JumpOnTrueExpr = getmovedelta(var_0D,opcode::OP_BoolNot,1);
			opcode::OP_CallBuiltin5 = (self.var_6366.origin[0],self.var_6366.origin[1],self.var_6366.origin[2] - opcode::OP_JumpOnTrueExpr[2]);
			scripts\mp\agents\_scriptedagents::func_5AC2(var_06,var_07,"traverse",var_0D,var_14,var_16,opcode::OP_CallBuiltin5,opcode::OP_BoolNot,::zombietraversenotetrackhandler_dlc);
			self scragentsetanimscale(1,1);
			if(var_19.size == 0 || !scripts\common\utility::istrue(self.dismember_crawl))
			{
				scripts\mp\agents\_scriptedagents::func_CED5(var_06,var_07,"traverse","end",::zombietraversenotetrackhandler_dlc);
			}
		}

		self.endnode = undefined;
	}
	else if(var_15.size > 0 && var_17.size > 0 && self.agent_type != "zombie_brute")
	{
		self scragentsetanimscale(1,1);
		scripts\mp\agents\_scriptedagents::func_CED5(var_06,var_07,"traverse",var_14,::zombietraversenotetrackhandler_dlc);
		opcode::OP_BoolNot = opcode::OP_SetNewLocalVariableFieldCached0[0];
		if(!isdefined(opcode::OP_CallBuiltin4))
		{
			opcode::OP_CallBuiltin5 = var_05;
		}
		else
		{
			opcode::OP_CallBuiltin5 = var_21.origin;
		}

		opcode::OP_JumpOnTrueExpr = getmovedelta(var_0D,opcode::OP_BoolNot,1);
		opcode::OP_CallBuiltin5 = (opcode::OP_CallBuiltin5[0],opcode::OP_CallBuiltin5[1],opcode::OP_CallBuiltin5[2] - opcode::OP_JumpOnTrueExpr[2]);
		scripts\mp\agents\_scriptedagents::func_5AC2(var_06,var_07,"traverse",var_0D,var_14,var_16,opcode::OP_CallBuiltin5,opcode::OP_BoolNot,::zombietraversenotetrackhandler_dlc);
		if(var_19.size == 0 || !scripts\common\utility::istrue(self.dismember_crawl))
		{
			scripts\mp\agents\_scriptedagents::func_CED5(var_06,var_07,"traverse","end",::zombietraversenotetrackhandler_dlc);
		}
	}
	else if(var_0B && abs(var_08[2]) < 64)
	{
		if(var_0F.size != 1)
		{
			var_0F = getnotetracktimes(var_0D,"flex_across_start");
		}

		if(var_11.size != 1)
		{
			var_11 = getnotetracktimes(var_0D,"flex_across_end");
		}

		opcode::OP_ScriptFarMethodThreadCall = getanimlength(var_0D);
		opcode::OP_SetLevelFieldVariableField = var_0F[0] * opcode::OP_ScriptFarMethodThreadCall;
		opcode::OP_CastBool = var_11[0] * opcode::OP_ScriptFarMethodThreadCall;
		self scragentsetanimscale(1,1);
		scripts\mp\agents\_scriptedagents::func_CED3(var_06,var_07,self.traverseratescale,"traverse","flex_across_start");
		opcode::OP_EvalNewLocalArrayRefCached0 = removezfromvec(getmovedelta(var_0D,var_0F[0],var_11[0]));
		opcode::OP_CallBuiltinPointer = distance2d(self.origin,var_05);
		opcode::OP_inequality = getmovedelta(var_0D,var_0F[0],1);
		opcode::OP_GetThisthread = length2d(opcode::OP_inequality);
		opcode::OP_ClearFieldVariable = opcode::OP_CallBuiltinPointer - opcode::OP_GetThisthread;
		opcode::OP_GetFloat = length2d(opcode::OP_EvalNewLocalArrayRefCached0);
		if(opcode::OP_GetFloat < 0.01)
		{
			opcode::OP_GetFloat = 1;
		}

		opcode::OP_SafeCreateVariableFieldCached = opcode::OP_ClearFieldVariable + opcode::OP_GetFloat \ opcode::OP_GetFloat;
		self scragentsetanimscale(opcode::OP_SafeCreateVariableFieldCached,0);
		childthread traverse_lerp_z_over_time_dlc(var_04.origin[2],var_05[2],opcode::OP_CastBool - opcode::OP_SetLevelFieldVariableField \ self.traverseratescale);
		scripts\mp\agents\_scriptedagents::func_CED3(var_06,var_07,self.traverseratescale,"traverse","flex_across_end");
		self scragentsetanimscale(1,1);
		scripts\mp\agents\_scriptedagents::func_CED3(var_06,var_07,self.traverseratescale,"traverse");
	}
	else if(var_08[2] > 16)
	{
		if(opcode::OP_CallBuiltin1[2] > 0)
		{
			if(var_0C)
			{
				self scragentsetanimscale(var_1C.var_13E2B,var_1C.var_3A6);
				opcode::OP_ScriptFarFunctionCall2 = clamp(2 \ var_1C.var_3A6,0.5,1);
				if(var_11.size > 0)
				{
					scripts\mp\agents\_scriptedagents::func_CED3(var_06,var_07,opcode::OP_ScriptFarFunctionCall2 * self.traverseratescale,"traverse",var_10);
					scripts\mp\agents\_scriptedagents::setstatelocked(0,"DoTraverse");
					scripts\mp\agents\_scriptedagents::func_F2B1(var_06,var_07,self.traverseratescale);
					scripts\mp\agents\_scriptedagents::func_1384D("traverse","code_move");
				}
				else
				{
					scripts\mp\agents\_scriptedagents::func_CED3(var_06,var_07,self.traverseratescale,"traverse");
				}

				self scragentsetanimscale(1,1);
			}
			else if(var_0F.size > 0)
			{
				var_1C.var_13E2B = 1;
				var_1C.var_3A6 = 1;
				if(!opcode::OP_CallBuiltin3 && length2dsquared(var_09) < 0.64 * length2dsquared(opcode::OP_CallBuiltin1))
				{
					var_1C.var_13E2B = 0.4;
				}

				self scragentsetanimscale(var_1C.var_13E2B,var_1C.var_3A6);
				scripts\mp\agents\_scriptedagents::func_CED3(var_06,var_07,self.traverseratescale,"traverse",var_0E);
				opcode::OP_ScriptFarFunctionCall = getmovedelta(var_0D,0,var_0F[0]);
				opcode::OP_ScriptFarChildThreadCall = getmovedelta(var_0D,0,var_11[0]);
				var_1C.var_13E2B = 1;
				var_1C.var_3A6 = 1;
				opcode::OP_ClearLocalVariableFieldCached0 = var_05 - self.origin;
				opcode::OP_ClearLocalVariableFieldCached = opcode::OP_CallBuiltin1 - opcode::OP_ScriptFarFunctionCall;
				if(!opcode::OP_CallBuiltin3 && length2dsquared(opcode::OP_ClearLocalVariableFieldCached0) < 0.5625 * length2dsquared(opcode::OP_ClearLocalVariableFieldCached))
				{
					var_1C.var_13E2B = 0.75;
				}

				opcode::OP_checkclearparams = opcode::OP_CallBuiltin1 - opcode::OP_ScriptFarChildThreadCall;
				opcode::OP_CastFieldObject = (opcode::OP_checkclearparams[0] * var_1C.var_13E2B,opcode::OP_checkclearparams[1] * var_1C.var_13E2B,opcode::OP_checkclearparams[2] * var_1C.var_3A6);
				opcode::OP_End = rotatevector(opcode::OP_CastFieldObject,var_0A);
				opcode::OP_size = var_05 - opcode::OP_End;
				opcode::OP_EmptyArray = opcode::OP_ScriptFarChildThreadCall - opcode::OP_ScriptFarFunctionCall;
				opcode::OP_bit_and = rotatevector(opcode::OP_EmptyArray,var_0A);
				opcode::OP_less_equal = opcode::OP_size - self.origin;
				opcode::OP_voidCodepos = opcode::OP_CallBuiltin2;
				opcode::OP_CallBuiltin2 = scripts\mp\agents\_scriptedagents::func_7DC9(opcode::OP_less_equal,opcode::OP_bit_and,1);
				if(opcode::OP_CallBuiltin3)
				{
					var_1C.var_13E2B = 1;
				}

				if(opcode::OP_less_equal[2] <= 0)
				{
					var_1C.var_3A6 = 0;
				}

				self scragentsetanimscale(var_1C.var_13E2B,var_1C.var_3A6);
				scripts\mp\agents\_scriptedagents::func_1384D("traverse",var_10);
				scripts\mp\agents\_scriptedagents::setstatelocked(0,"DoTraverse");
				opcode::OP_CallBuiltin2 = opcode::OP_voidCodepos;
				self scragentsetanimscale(var_1C.var_13E2B,var_1C.var_3A6);
				scripts\mp\agents\_scriptedagents::func_1384D("traverse","code_move");
			}
			else
			{
				self scragentsetanimscale(var_1C.var_13E2B,var_1C.var_3A6);
				scripts\mp\agents\_scriptedagents::func_CED3(var_06,var_07,self.traverseratescale,"traverse");
			}
		}
		else
		{
			scripts\mp\agents\_scriptedagents::func_5AC1(var_06,var_07,var_0D,"traverse","flex_height_start","flex_height_end",1,::zombietraversenotetrackhandler_dlc);
		}
	}
	else if(abs(var_08[2]) < 16 || opcode::OP_CallBuiltin1[2] == 0)
	{
		self scragentsetanimscale(var_1C.var_13E2B,var_1C.var_3A6);
		opcode::OP_ScriptFarFunctionCall2 = clamp(2 \ var_1C.var_3A6,0.5,1);
		if(var_11.size > 0)
		{
			scripts\mp\agents\_scriptedagents::func_CED3(var_06,var_07,opcode::OP_ScriptFarFunctionCall2 * self.traverseratescale,"traverse",var_10);
			scripts\mp\agents\_scriptedagents::setstatelocked(0,"DoTraverse");
			scripts\mp\agents\_scriptedagents::func_F2B1(var_06,var_07,self.traverseratescale);
			scripts\mp\agents\_scriptedagents::func_1384D("traverse","code_move");
		}
		else
		{
			scripts\mp\agents\_scriptedagents::func_CED3(var_06,var_07,self.traverseratescale,"traverse");
		}

		self scragentsetanimscale(1,1);
	}
	else if(opcode::OP_CallBuiltin1[2] < 0)
	{
		self scragentsetanimscale(var_1C.var_13E2B,var_1C.var_3A6);
		opcode::OP_ScriptFarFunctionCall2 = clamp(2 \ var_1C.var_3A6,0.5,1);
		if(var_0F.size > 0)
		{
			scripts\mp\agents\_scriptedagents::func_CED3(var_06,var_07,self.traverseratescale,"traverse",var_0E);
		}

		if(var_11.size > 0)
		{
			scripts\mp\agents\_scriptedagents::func_CED3(var_06,var_07,opcode::OP_ScriptFarFunctionCall2 * 1,"traverse",var_10);
			scripts\mp\agents\_scriptedagents::func_F2B1(var_06,var_07,self.traverseratescale);
			if(animhasnotetrack(var_0D,"removestatelock"))
			{
				scripts\mp\agents\_scriptedagents::func_1384D("traverse","removestatelock");
			}

			scripts\mp\agents\_scriptedagents::setstatelocked(0,"DoTraverse");
			scripts\mp\agents\_scriptedagents::func_1384D("traverse","code_move");
		}
		else
		{
			scripts\mp\agents\_scriptedagents::func_CED3(var_06,var_07,1,"traverse");
		}

		self scragentsetanimscale(1,1);
	}
	else
	{
	}

	lerptoabovegrounddlc();
	self gib_fx_override("gravity");
	self.is_traversing = undefined;
	self notify("traverse_end");
	terminatetraverse_dlc(param_00,param_01);
}

//Function Number: 4
lerptoabovegrounddlc()
{
	var_00 = 0.1;
	var_01 = self.var_6378;
	var_02 = var_01[2];
	var_03 = self.origin[2];
	var_04 = getgroundposition(var_01,8);
	var_05 = var_04[2];
	if(var_03 < var_05)
	{
		self setorigin((self.origin[0],self.origin[1],var_05 + var_00),0);
	}
}

//Function Number: 5
terminatetraverse_dlc(param_00,param_01)
{
	var_02 = level.asm[param_00].states[param_01];
	var_03 = undefined;
	if(isdefined(var_02.var_116FB))
	{
		if(isarray(var_02.var_116FB[0]))
		{
			var_03 = var_02.var_116FB[0];
		}
		else
		{
			var_03 = var_02.var_116FB;
		}
	}

	scripts\asm\asm::func_2388(param_00,param_01,var_02,var_02.var_116FB);
	scripts\asm\asm::func_238A(param_00,var_03,0.2,undefined,undefined,undefined);
	self notify("killanimscript");
}

//Function Number: 6
traverse_lerp_z_over_time_dlc(param_00,param_01,param_02)
{
	self endon("death");
	self endon("terminate_ai_threads");
	var_03 = gettime();
	for(;;)
	{
		var_04 = gettime() - var_03 \ 1000;
		var_05 = var_04 \ param_02;
		if(var_05 > 1)
		{
			break;
		}

		var_06 = scripts\mp\agents\zombie\zombie_util::func_AB6F(var_05,param_00,param_01);
		self setorigin((self.origin[0],self.origin[1],var_06),0);
		wait(0.05);
	}
}

//Function Number: 7
needscrawlinganimstate_dlc(param_00)
{
	if(self.dismember_crawl)
	{
		return 1;
	}

	return 0;
}

//Function Number: 8
zombietraversenotetrackhandler_dlc(param_00,param_01,param_02,param_03)
{
	switch(param_00)
	{
		case "apply_physics":
			self gib_fx_override("gravity");
			break;

		default:
			break;
	}
}

//Function Number: 9
choosestandingdeathanim_dlc(param_00,param_01,param_02,param_03)
{
	if(!scripts\common\utility::istrue(self.kung_fu_punched))
	{
		if(scripts\common\utility::istrue(self.electrocuted))
		{
			return scripts\asm\asm::asm_lookupanimfromalias(param_01,"electrocuted");
		}
	}

	return lib_0C71::func_3F00(param_00,param_01,param_02,param_03);
}

//Function Number: 10
choosemovingdeathanim_dlc(param_00,param_01,param_02)
{
	return lib_0C71::func_3EE2(param_00,param_01,param_02);
}

//Function Number: 11
chooseballoongrabanim(param_00,param_01,param_02)
{
	if(scripts\asm\zombie\zombie::func_BE92())
	{
		return scripts\asm\asm::asm_lookupanimfromalias(param_01,"prone");
	}

	return scripts\asm\asm::asm_lookupanimfromalias(param_01,"stand");
}

//Function Number: 12
handleballoonfloating()
{
	self endon("death");
	wait(randomfloatrange(5,5.9));
	self notify("reached_end");
	self unlink();
	self setvelocity((randomintrange(-10,10),randomintrange(-10,10),-50));
	self.do_immediate_ragdoll = 1;
	self.customdeath = 1;
	playfx(level._effect["balloon_death"],self.balloon_in_hand.origin + (0,0,50));
	playsoundatpos(self.origin,"craftable_balloon_zmb_explo");
	self dodamage(self.health + 100,self.origin,undefined,undefined,"MOD_EXPLOSIVE","zmb_imsprojectile_mp");
}

//Function Number: 13
balloongrabnotehandler(param_00,param_01,param_02,param_03)
{
	if(param_00 == "balloon_attach")
	{
		var_04 = ["decor_balloon_a_blue","decor_balloon_a_blue_light","decor_balloon_a_cyan","decor_balloon_a_green","decor_balloon_a_green_light","decor_balloon_a_orange","decor_balloon_a_pink","decor_balloon_a_purple","decor_balloon_a_purple_deep","decor_balloon_a_red","decor_balloon_a_yellow"];
		var_05 = self gettagorigin("j_shoulder_ri");
		self.balloon_in_hand = spawn("script_model",var_05);
		self.balloon_model = scripts\common\utility::random(var_04);
		if(self.bholdingballooninleft)
		{
			self attach(self.balloon_model,"tag_accessory_left");
		}
		else
		{
			self attach(self.balloon_model,"tag_accessory_right");
		}

		self.balloon_in_hand.origin = var_05;
		self linkto(self.balloon_in_hand);
		self playerlinkedoffsetenable();
		var_06 = randomintrange(-50,50);
		var_07 = randomintrange(-50,50);
		self.balloon_in_hand moveto(self.origin + (var_06,var_07,self.detonate_height),6,3);
		self.balloon_in_hand rotateyaw(randomint(360),6);
		thread handleballoonfloating();
	}
}

//Function Number: 14
chooseballoonfloatanim(param_00,param_01,param_02)
{
	if(scripts\common\utility::istrue(self.bholdingballooninleft))
	{
		return scripts\asm\asm::asm_lookupanimfromalias(param_01,"left");
	}

	return scripts\asm\asm::asm_lookupanimfromalias(param_01,"right");
}

//Function Number: 15
shouldballoongrableft(param_00,param_01,param_02,param_03)
{
	self.bholdingballooninleft = undefined;
	if(lib_0C72::func_9EA5())
	{
		self.bholdingballooninleft = 1;
	}
	else if(randomintrange(0,100) < 50)
	{
		self.bholdingballooninleft = 1;
	}
	else
	{
		self.bholdingballooninleft = 0;
	}

	return self.bholdingballooninleft;
}

//Function Number: 16
isdismembermentdisabled(param_00,param_01,param_02,param_03)
{
	if(scripts\common\utility::istrue(self.var_55CF))
	{
		return 1;
	}

	return 0;
}

//Function Number: 17
shoulddosharpturn_dlc(param_00,param_01,param_02,param_03)
{
	return lib_0F3B::func_FFF8(param_00,param_01,param_02,param_03);
}

//Function Number: 18
isdiscofeverdone(param_00,param_01,param_02,param_03)
{
	return !hasdiscofever(param_00,param_01,param_02,param_03);
}

//Function Number: 19
hasdiscofever(param_00,param_01,param_02,param_03)
{
	return scripts\common\utility::istrue(self.bhasdiscofever);
}

//Function Number: 20
shoot_generic_dlc(param_00,param_01,param_02,param_03)
{
	self endon(param_01 + "_finished");
	lib_0F3E::func_FE89();
	var_04 = lib_0F3E::func_FE64();
	self _meth_83CE();
	var_05 = scripts\asm\asm_mp::asm_getanim(param_00,param_01);
	shootburst_dlc(param_01,0.2,2);
	self.var_2303.var_FECD.var_C21C--;
	lib_0F3E::func_32BE();
	scripts\asm\asm::asm_fireevent(param_01,"shoot_finished");
}

//Function Number: 21
shootburst_dlc(param_00,param_01,param_02)
{
	var_03 = param_00 + "_timeout";
	var_04 = param_00 + "_timeout_end";
	thread lib_0F3E::func_FE84(var_03,var_04,param_02);
	self endon(var_03);
	self endon(param_00 + "_finished");
	var_05 = 0;
	var_06 = self.var_2303.var_FECD.var_FF0B;
	var_07 = var_06 == 1;
	var_08 = 0;
	var_09 = scripts\anim\utility_common::weapon_pump_action_shotgun();
	while(var_05 < var_06 && var_06 > 0)
	{
		if(!isdefined(self.var_1198.shootparams))
		{
			break;
		}

		if(isdefined(self.isnodeoccupied))
		{
			if(!lib_0F3C::isfacingenemy() && !lib_0F3C::func_9FFF())
			{
				break;
			}
		}

		self.var_A9ED = gettime();
		var_0A = lib_0F3C::_meth_811C();
		var_0B = lib_0F3C::_meth_811E(var_0A);
		self shoot(1,var_0B,1,0,1);
		if(self.bulletsinclip > 0)
		{
			if(var_08)
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
		}

		var_05++;
		if(var_09)
		{
			childthread lib_0F3E::func_FE7D(param_00);
		}

		if(self.var_2303.var_FECD.var_6B92 && var_05 == var_06)
		{
			break;
		}

		wait(param_01);
	}

	self notify(var_04);
}