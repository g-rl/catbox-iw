/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\anim\corner.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 58
 * Decompile Time: 2911 ms
 * Timestamp: 10\27\2023 12:00:19 AM
*******************************************************************/

//Function Number: 1
func_4661(param_00,param_01)
{
	self endon("killanimscript");
	self.var_1F66["exposed"]["stand"] = ::func_F5AD;
	self.var_1F66["exposed"]["crouch"] = ::func_F317;
	self.covernode = self.target_getindexoftarget;
	self.var_4664 = param_00;
	self.var_1491.var_4667 = "unknown";
	self.var_1491.var_1A3E = undefined;
	scripts\anim\cover_behavior::func_129B4(param_01);
	func_F30C();
	self.var_9F4D = 0;
	self.var_11AE0 = 0;
	self.var_4662 = 0;
	scripts\anim\track::func_F641(0);
	self.var_8C4B = 0;
	var_02 = spawnstruct();
	if(!self.logstring)
	{
		var_02.var_BD1C = ::scripts\anim\cover_behavior::func_BD1C;
	}

	var_02.var_B24A = ::func_B24A;
	var_02.openfile = ::func_4668;
	var_02.var_AB2D = ::func_10F8B;
	var_02.setnojipscore = ::func_B01C;
	var_02.var_6B9B = ::func_6B9B;
	var_02.var_92CC = ::func_92CC;
	var_02.objective_position = ::func_128AF;
	var_02._meth_85BF = ::func_128B0;
	var_02.var_2B99 = ::func_2B99;
	scripts\anim\cover_behavior::main(var_02);
}

//Function Number: 2
func_62F3()
{
	self.var_10F8C = undefined;
	self.var_1491.var_AAF2 = undefined;
}

//Function Number: 3
func_F30C()
{
	if(self.var_1491.pose == "crouch")
	{
		func_F2AE("crouch");
		return;
	}

	if(self.var_1491.pose == "stand")
	{
		func_F2AE("stand");
		return;
	}

	scripts\anim\utility::exitpronewrapper(1);
	self.var_1491.pose = "crouch";
	func_F2AE("crouch");
}

//Function Number: 4
func_FFD1()
{
	if(!isdefined(self.isnodeoccupied))
	{
		return 0;
	}

	if(!isdefined(self.var_3C5B))
	{
		self.var_3C5B = gettime() + randomintrange(5000,20000);
	}

	if(gettime() > self.var_3C5B)
	{
		self.var_3C5B = gettime() + randomintrange(5000,20000);
		if(isdefined(self.var_DC5C) && self.var_1491.pose == "stand")
		{
			return 0;
		}

		self.var_1491.var_D892 = undefined;
		return 1;
	}

	return 0;
}

//Function Number: 5
func_B24A()
{
	var_00 = "stand";
	if(self.var_1491.pose == "crouch")
	{
		var_00 = "crouch";
		if(self.covernode getrandomattachments("stand"))
		{
			if(!self.covernode getrandomattachments("crouch") || func_FFD1())
			{
				var_00 = "stand";
			}
		}
	}
	else if(self.covernode getrandomattachments("crouch"))
	{
		if(!self.covernode getrandomattachments("stand") || func_FFD1())
		{
			var_00 = "crouch";
		}
	}

	if(self.var_8C4B)
	{
		transitiontostance(var_00);
		return;
	}

	if(self.var_1491.pose == var_00)
	{
		if(isdefined(self.var_C2) && isdefined(self.var_C2.var_8ED9) && self.var_C2.var_8ED9 == "back")
		{
			var_01 = scripts\anim\utility::func_1F64("alert_idle_back");
		}
		else
		{
			var_01 = scripts\anim\utility::func_1F64("alert_idle");
		}

		_meth_846D(var_01,0.3,0.4);
	}
	else
	{
		var_02 = scripts\anim\utility::func_1F64("stance_change");
		_meth_846D(var_02,0.3,getanimlength(var_02));
		func_F2AE(var_00);
	}

	self.var_8C4B = 1;
}

//Function Number: 6
func_D921()
{
	wait(2);
	for(;;)
	{
		func_D922();
		wait(0.05);
	}
}

//Function Number: 7
shootposwrapper_func()
{
	if(!isdefined(self.var_FECF))
	{
		return 0;
	}

	var_00 = self.covernode scripts\anim\utility_common::getyawtoorigin(self.var_FECF);
	if(self.var_1491.var_4667 == "over")
	{
		return var_00 > self.setmatchdatadef || self.setdevdvar > var_00;
	}

	if(self.var_4664 == "up")
	{
		return var_00 < -50 || var_00 > 50;
	}

	if(self.var_4664 == "left")
	{
		if(self.var_1491.var_4667 == "B")
		{
			return var_00 > self.var_1513 || var_00 < -14;
		}

		if(self.var_1491.var_4667 == "A")
		{
			return var_00 < self.var_1513;
		}

		return var_00 > 50 || var_00 < -8;
	}

	if(self.var_1491.var_4667 == "B")
	{
		return var_00 < -1 * self.var_1513 || var_00 > 12;
	}

	if(self.var_1491.var_4667 == "A")
	{
		return var_00 > -1 * self.var_1513;
	}

	return var_00 < -50 || var_00 > 8;
}

//Function Number: 8
func_7E3C(param_00,param_01)
{
	var_02 = 0;
	var_03 = 0;
	if(isdefined(param_01))
	{
		var_03 = param_00 scripts\anim\utility_common::getyawtoorigin(param_01);
	}

	var_04 = [];
	if(isdefined(param_00) && self.var_1491.pose == "crouch" && var_03 < self.setmatchdatadef && self.setdevdvar < var_03)
	{
		var_04 = param_00 _meth_8169();
	}

	if(self.var_4664 == "up")
	{
		if(scripts\common\utility::actor_is3d())
		{
			var_05 = 0;
			if(isdefined(param_01))
			{
				var_06 = anglestoup(self.angles);
				var_05 = scripts\anim\combat_utility::_meth_8063(param_01,self geteye() + (var_06[0] * 12,var_06[1] * 12,var_06[2] * 12));
			}

			if(func_38C5(var_05,-80,5))
			{
				var_02 = func_10032();
				var_04[var_04.size] = "lean";
				var_04[var_04.size] = "lean";
			}

			if(!var_02)
			{
				var_04[var_04.size] = "A";
			}
		}
		else
		{
			var_04[var_04.size] = "A";
		}
	}
	else if(self.var_4664 == "left")
	{
		if(func_38C5(var_03,0,40))
		{
			var_02 = func_10032();
			var_04[var_04.size] = "lean";
		}

		if(!var_02 && var_03 > -14)
		{
			if(var_03 > self.var_1513)
			{
				var_04[var_04.size] = "A";
			}
			else
			{
				var_04[var_04.size] = "B";
			}
		}
	}
	else
	{
		if(func_38C5(var_03,-40,0))
		{
			var_02 = func_10032();
			var_04[var_04.size] = "lean";
		}

		if(!var_02 && var_03 < 12)
		{
			if(var_03 > -1 * self.var_1513)
			{
				var_04[var_04.size] = "A";
			}
			else
			{
				var_04[var_04.size] = "B";
			}
		}
	}

	return scripts\anim\combat_utility::_meth_80B5(var_04);
}

//Function Number: 9
func_7E03()
{
	var_00 = 0;
	if(scripts\anim\utility_common::cansuppressenemy())
	{
		var_00 = self.covernode scripts\anim\utility_common::getyawtoorigin(scripts\anim\utility::func_7E90());
	}
	else if(self.var_FC && isdefined(self.var_FECF))
	{
		var_00 = self.covernode scripts\anim\utility_common::getyawtoorigin(self.var_FECF);
	}

	if(self.var_1491.var_4667 == "lean")
	{
		return "lean";
	}

	if(self.var_1491.var_4667 == "over")
	{
		return "over";
	}

	if(self.var_1491.var_4667 == "B")
	{
		if(self.var_4664 == "left")
		{
			if(var_00 > self.var_1513)
			{
				return "A";
			}
		}
		else if(self.var_4664 == "right")
		{
			if(var_00 < -1 * self.var_1513)
			{
				return "A";
			}
		}

		return "B";
	}

	if(self.var_1491.var_4667 == "A")
	{
		if(self.var_4664 == "up")
		{
			return "A";
		}
		else if(self.var_4664 == "left")
		{
			if(var_00 < self.var_1513)
			{
				return "B";
			}
		}
		else if(self.var_4664 == "right")
		{
			if(var_00 > -1 * self.var_1513)
			{
				return "B";
			}
		}

		return "A";
	}
}

//Function Number: 10
func_3C5D()
{
	self endon("killanimscript");
	var_00 = func_7E03();
	if(var_00 == self.var_1491.var_4667)
	{
		return 0;
	}

	self.var_3C60 = 1;
	self notify("done_changing_cover_pos");
	var_01 = self.var_1491.var_4667 + "_to_" + var_00;
	var_02 = scripts\anim\utility::func_1F67(var_01);
	if(scripts\common\utility::actor_is3d() && var_01 == "A_to_B" || var_01 == "B_to_A")
	{
		return 0;
	}

	var_03 = !scripts\common\utility::actor_is3d();
	var_04 = destroy();
	if(!self maymovetopoint(var_04,var_03))
	{
		return 0;
	}

	if(!self maymovefrompointtopoint(var_04,scripts\anim\utility::func_7DC6(var_02),var_03))
	{
		return 0;
	}

	scripts\anim\combat_utility::func_6309();
	func_1105C(0.3);
	var_05 = self.var_1491.pose;
	self _meth_82AC(scripts\anim\utility::func_1F64("straight_level"),0,0.2);
	self give_left_powers("changeStepOutPos",var_02,1,0.2,1.2);
	func_465E(var_02);
	thread donotetrackswithendon("changeStepOutPos");
	var_06 = animhasnotetrack(var_02,"start_aim");
	if(var_06)
	{
		self waittillmatch("start_aim","changeStepOutPos");
	}
	else
	{
		self waittillmatch("end","changeStepOutPos");
	}

	thread func_10D6A(undefined,0,0.3);
	if(var_06)
	{
		self waittillmatch("end","changeStepOutPos");
	}

	self aiclearanim(var_02,0.1);
	self.var_1491.var_4667 = var_00;
	self.var_3C60 = 0;
	self.var_4740 = gettime();
	if(self.var_1491.pose != var_05)
	{
		func_F2AE(self.var_1491.pose);
	}

	thread func_3C50(undefined,1,0.3);
	return 1;
}

//Function Number: 11
func_38C5(param_00,param_01,param_02)
{
	if(self.var_1491.var_BEF9)
	{
		return 0;
	}

	return param_01 <= param_00 && param_00 <= param_02;
}

//Function Number: 12
func_10032()
{
	if(self.team == "allies")
	{
		return 1;
	}

	if(scripts\anim\utility::func_9ED4())
	{
		return 1;
	}

	return 0;
}

//Function Number: 13
donotetrackswithendon(param_00)
{
	self endon("killanimscript");
	scripts\anim\shared::donotetracks(param_00);
}

//Function Number: 14
func_10D6A(param_00,param_01,param_02)
{
	self.var_4662 = 1;
	if(self.var_1491.var_4667 == "lean")
	{
		self.var_1491.var_AAF2 = 1;
	}
	else
	{
		self.var_1491.var_AAF2 = undefined;
	}

	func_F637(param_00,param_01,param_02);
}

//Function Number: 15
func_3C50(param_00,param_01,param_02)
{
	if(self.var_1491.var_4667 == "lean")
	{
		self.var_1491.var_AAF2 = 1;
	}
	else
	{
		self.var_1491.var_AAF2 = undefined;
	}

	func_F637(param_00,param_01,param_02);
}

//Function Number: 16
func_1105C(param_00)
{
	self.var_4662 = 0;
	self aiclearanim(%add_fire,param_00);
	scripts\anim\track::func_F641(0,param_00);
	self.facialidx = undefined;
	self aiclearanim(%head,0.2);
}

//Function Number: 17
func_F637(param_00,param_01,param_02)
{
	self.var_10A5A = param_00;
	self _meth_82AC(%exposed_modern,1,param_02);
	self _meth_82AC(%exposed_aiming,1,param_02);
	self _meth_82AC(%add_idle,1,param_02);
	scripts\anim\track::func_F641(1,param_02);
	func_465D(undefined);
	var_03 = undefined;
	if(isdefined(self.var_1491.var_2274["lean_aim_straight"]))
	{
		var_03 = self.var_1491.var_2274["lean_aim_straight"];
	}

	thread scripts\anim\combat_utility::func_1A3E();
	if(isdefined(self.var_1491.var_AAF2))
	{
		self _meth_82AC(var_03,1,param_02);
		self _meth_82AC(scripts\anim\utility::func_1F64("straight_level"),0,0);
		self _meth_82A9(scripts\anim\utility::func_1F64("lean_aim_left"),1,param_02);
		self _meth_82A9(scripts\anim\utility::func_1F64("lean_aim_right"),1,param_02);
		self _meth_82A9(scripts\anim\utility::func_1F64("lean_aim_up"),1,param_02);
		self _meth_82A9(scripts\anim\utility::func_1F64("lean_aim_down"),1,param_02);
		return;
	}

	if(param_01)
	{
		self _meth_82AC(scripts\anim\utility::func_1F64("straight_level"),1,param_02);
		if(isdefined(var_03))
		{
			self _meth_82AC(var_03,0,0);
		}

		self _meth_82A9(scripts\anim\utility::func_1F64("add_aim_up"),1,param_02);
		self _meth_82A9(scripts\anim\utility::func_1F64("add_aim_down"),1,param_02);
		self _meth_82A9(scripts\anim\utility::func_1F64("add_aim_left"),1,param_02);
		self _meth_82A9(scripts\anim\utility::func_1F64("add_aim_right"),1,param_02);
		return;
	}

	self _meth_82AC(scripts\anim\utility::func_1F64("straight_level"),0,param_02);
	if(isdefined(var_03))
	{
		self _meth_82AC(var_03,0,0);
	}

	self _meth_82A9(scripts\anim\utility::func_1F64("add_turn_aim_up"),1,param_02);
	self _meth_82A9(scripts\anim\utility::func_1F64("add_turn_aim_down"),1,param_02);
	self _meth_82A9(scripts\anim\utility::func_1F64("add_turn_aim_left"),1,param_02);
	self _meth_82A9(scripts\anim\utility::func_1F64("add_turn_aim_right"),1,param_02);
}

//Function Number: 18
func_10F8A()
{
	if(self.var_1491.var_4667 == "over")
	{
		return 1;
	}

	return scripts\anim\combat_utility::func_DCAD();
}

//Function Number: 19
func_10F89()
{
	self.var_1491.var_4667 = "alert";
	if(self.objective_playermask_showto < 64)
	{
		self.objective_playermask_showto = 64;
	}

	func_F6B9();
	if(self.var_1491.pose == "stand")
	{
		self.var_1513 = 38;
	}
	else
	{
		self.var_1513 = 31;
	}

	var_00 = self.var_1491.pose;
	func_F2AE(var_00);
	scripts\anim\combat::func_F337();
	var_01 = "none";
	if(scripts\anim\utility::func_8BED())
	{
		var_01 = func_7E3C(self.covernode,scripts\anim\utility::func_7E90());
	}
	else
	{
		var_01 = func_7E3C(self.covernode);
	}

	if(!isdefined(var_01))
	{
		return 0;
	}

	var_02 = "alert_to_" + var_01;
	if(!scripts\anim\utility::func_1F65(var_02))
	{
		return 0;
	}

	var_03 = scripts\anim\utility::func_1F67(var_02);
	if(var_01 == "lean" && !func_9EDA())
	{
		return 0;
	}

	if(var_01 != "over" && !func_9ED6(var_03,var_01 != "lean"))
	{
		return 0;
	}

	self.var_1491.var_4667 = var_01;
	self.var_1491.var_D892 = var_01;
	if(self.var_1491.var_4667 == "lean")
	{
		scripts\anim\combat::func_F337(self.covernode);
	}

	if(var_01 == "A" || var_01 == "B")
	{
		self.var_1491.var_10930 = "cover_" + self.var_4664 + "_" + self.var_1491.pose + "_" + var_01;
	}
	else if(var_01 == "over")
	{
		self.var_1491.var_10930 = "cover_crouch_aim";
	}
	else
	{
		self.var_1491.var_10930 = "none";
	}

	self.sendmatchdata = 1;
	var_04 = 0;
	self.var_3C60 = 1;
	self notify("done_changing_cover_pos");
	var_05 = func_10F8A();
	self.closefile = 0;
	self _meth_82E4("stepout",var_03,%root,1,0.2,var_05);
	func_465E(var_03);
	thread donotetrackswithendon("stepout");
	var_04 = animhasnotetrack(var_03,"start_aim");
	if(var_04)
	{
		self.var_10F8C = self.angles[1] + getangledelta(var_03,0,1);
		self waittillmatch("start_aim","stepout");
	}
	else
	{
		self waittillmatch("end","stepout");
	}

	if(var_01 == "B" && scripts\common\utility::cointoss() && self.var_4664 == "right")
	{
		self.var_1491.var_10930 = "corner_right_martyrdom";
	}

	func_F2AF(var_00);
	var_06 = var_01 == "over" || scripts\common\utility::actor_is3d();
	func_10D6A(undefined,var_06,0.3);
	thread scripts\anim\track::func_11B07();
	if(var_04)
	{
		self waittillmatch("end","stepout");
		self.var_10F8C = undefined;
	}

	func_3C50(undefined,1,0.2);
	self aiclearanim(%cover,0.1);
	self aiclearanim(%corner,0.1);
	self.var_3C60 = 0;
	self.var_4740 = gettime();
	self.closefile = 1;
	return 1;
}

//Function Number: 20
func_10F8B()
{
	self.sendmatchdata = 1;
	if(isdefined(self.var_DC5C) && randomfloat(1) < self.var_DC5C)
	{
		if(func_DC57())
		{
			return 1;
		}
	}

	if(!func_10F89())
	{
		return 0;
	}

	shootastold();
	if(isdefined(self.var_FECF))
	{
		var_00 = lengthsquared(self.origin - self.var_FECF);
		if(scripts\anim\utility_common::usingrocketlauncher() && scripts\anim\utility::func_10000(var_00))
		{
			if(self.var_1491.pose == "stand")
			{
				scripts\anim\shared::func_1180E(scripts\anim\utility::func_B027("combat","drop_rpg_stand"));
			}
			else
			{
				scripts\anim\shared::func_1180E(scripts\anim\utility::func_B027("combat","drop_rpg_crouch"));
			}

			thread func_E841();
			return;
		}
	}

	func_E47A();
	self.sendmatchdata = 0;
	return 1;
}

//Function Number: 21
func_8C4E(param_00)
{
	if(!isdefined(self.var_A9D8))
	{
		return 1;
	}

	return gettime() - self.var_A9D8 > param_00 * 1000;
}

//Function Number: 22
func_DC57()
{
	if(!scripts\anim\utility::func_8BED())
	{
		return 0;
	}

	var_00 = 0;
	var_01 = 90;
	var_02 = self.covernode scripts\anim\utility_common::getyawtoorigin(scripts\anim\utility::func_7E90());
	if(self.var_4664 == "right")
	{
		var_02 = 0 - var_02;
	}

	if(var_02 < -30)
	{
		var_01 = 45;
		if(self.var_4664 == "left")
		{
			var_00 = -45;
		}
		else
		{
			var_00 = 45;
		}
	}

	var_03 = "rambo" + var_01;
	if(!scripts\anim\utility::func_1F65(var_03))
	{
		return 0;
	}

	var_04 = scripts\anim\utility::func_1F67(var_03);
	var_05 = destroy(48);
	if(!self maymovetopoint(var_05,!scripts\common\utility::actor_is3d()))
	{
		return 0;
	}

	self.var_4740 = gettime();
	func_F6B9();
	self.sendmatchdata = 1;
	self.var_9F15 = 1;
	self.var_1491.var_D892 = "rambo";
	self.var_3C60 = 1;
	thread scripts\anim\shared::func_DC59(var_00);
	self _meth_82E4("rambo",var_04,%body,1,0,1);
	func_465E(var_04);
	scripts\anim\shared::donotetracks("rambo");
	self notify("rambo_aim_end");
	self.var_3C60 = 0;
	self.sendmatchdata = 0;
	self.var_A9D8 = gettime();
	self.var_3C60 = 0;
	self.var_9F15 = undefined;
	return 1;
}

//Function Number: 23
shootastold()
{
	scripts\sp\_gameskill::func_54C4();
	for(;;)
	{
		for(;;)
		{
			if(isdefined(self.var_1006D))
			{
				break;
			}

			if(!isdefined(self.var_FECF))
			{
				self waittill("do_slow_things");
				waittillframeend;
				if(isdefined(self.var_FECF))
				{
					continue;
				}

				break;
			}

			if(!self.bulletsinclip)
			{
				break;
			}

			if(shootposwrapper_func())
			{
				if(!func_3C5D())
				{
					if(func_7E03() == self.var_1491.var_4667)
					{
						break;
					}

					func_FEE2(0.2);
					continue;
				}

				if(shootposwrapper_func())
				{
					break;
				}

				continue;
			}

			func_FEE0(1);
			self aiclearanim(%add_fire,0.2);
		}

		if(canreturntocover(self.var_1491.var_4667 != "lean"))
		{
			break;
		}

		if(shootposwrapper_func() && func_3C5D())
		{
			continue;
		}

		func_FEE2(0.2);
	}
}

//Function Number: 24
func_FEE2(param_00)
{
	thread func_C173(param_00);
	var_01 = gettime();
	func_FEE0(0);
	self notify("stopNotifyStopShootingAfterTime");
	var_02 = gettime() - var_01 \ 1000;
	if(var_02 < param_00)
	{
		wait(param_00 - var_02);
	}
}

//Function Number: 25
func_C173(param_00)
{
	self endon("killanimscript");
	self endon("stopNotifyStopShootingAfterTime");
	wait(param_00);
	self notify("stopShooting");
}

//Function Number: 26
func_FEE0(param_00)
{
	self endon("return_to_cover");
	if(param_00)
	{
		thread func_1E82();
	}

	thread scripts\anim\combat_utility::func_1A3E();
	scripts\anim\combat_utility::func_FEDF();
}

//Function Number: 27
func_1E82()
{
	self endon("killanimscript");
	self notify("newAngleRangeCheck");
	self endon("newAngleRangeCheck");
	self endon("take_cover_at_corner");
	for(;;)
	{
		if(shootposwrapper_func())
		{
			break;
		}

		wait(0.1);
	}

	self notify("stopShooting");
}

//Function Number: 28
func_10154()
{
	self.isnodeoccupied endon("death");
	self endon("enemy");
	self endon("stopshowstate");
	wait(0.05);
}

//Function Number: 29
canreturntocover(param_00)
{
	var_01 = !scripts\common\utility::actor_is3d();
	if(param_00)
	{
		var_02 = destroy();
		if(!self maymovetopoint(var_02,var_01))
		{
			return 0;
		}

		return self maymovefrompointtopoint(var_02,self.var_473C.origin,var_01);
	}

	return self maymovetopoint(self.var_473C.origin,var_02);
}

//Function Number: 30
func_E47A()
{
	scripts\anim\combat_utility::func_631A();
	var_00 = scripts\anim\utility_common::issuppressedwrapper();
	self notify("take_cover_at_corner");
	self.var_3C60 = 1;
	self notify("done_changing_cover_pos");
	var_01 = self.var_1491.var_4667 + "_to_alert";
	var_02 = scripts\anim\utility::func_1F67(var_01);
	func_1105C(0.3);
	var_03 = 0;
	if(self.var_1491.var_4667 != "lean" && var_00 && scripts\anim\utility::func_1F65(var_01 + "_reload") && randomfloat(100) < 75)
	{
		var_02 = scripts\anim\utility::func_1F67(var_01 + "_reload");
		var_03 = 1;
	}

	var_04 = func_10F8A();
	if(scripts\common\utility::actor_is3d())
	{
		self aiclearanim(%exposed_modern,0.2);
	}
	else
	{
		self aiclearanim(%body,0.1);
	}

	self _meth_82EA("hide",var_02,1,0.1,var_04);
	func_465E(var_02);
	scripts\anim\shared::donotetracks("hide");
	if(var_03)
	{
		scripts\anim\weaponlist::refillclip();
	}

	self.var_3C60 = 0;
	if(self.var_4664 == "up")
	{
		self.var_1491.var_10930 = "cover_up";
	}
	else if(self.var_4664 == "left")
	{
		self.var_1491.var_10930 = "cover_left";
	}
	else
	{
		self.var_1491.var_10930 = "cover_right";
	}

	self.sendmatchdata = 0;
	self aiclearanim(var_02,0.2);
}

//Function Number: 31
func_2B99()
{
	if(!scripts\anim\utility::func_1F65("blind_fire"))
	{
		return 0;
	}

	func_F6B9();
	self.sendmatchdata = 1;
	var_00 = scripts\anim\utility::func_1F67("blind_fire");
	self _meth_82E4("blindfire",var_00,%body,1,0,1);
	func_465E(var_00);
	scripts\anim\shared::donotetracks("blindfire");
	self.sendmatchdata = 0;
	return 1;
}

//Function Number: 32
func_ACF4(param_00,param_01,param_02)
{
	if(!isdefined(param_02))
	{
		param_02 = (1,1,1);
	}

	for(var_03 = 0;var_03 < 100;var_03++)
	{
		wait(0.05);
	}
}

//Function Number: 33
func_128B0(param_00)
{
	return func_128AF(param_00,1);
}

//Function Number: 34
func_128AF(param_00,param_01)
{
	if(!self maymovetopoint(destroy()))
	{
		return 0;
	}

	if(isdefined(self.dontevershoot) || isdefined(param_00.var_5951))
	{
		return 0;
	}

	var_02 = undefined;
	if(isdefined(self.var_DC5C) && randomfloat(1) < self.var_DC5C)
	{
		if(isdefined(self.var_1491.var_2274["grenade_rambo"]))
		{
			var_02 = scripts\anim\utility::func_1F64("grenade_rambo");
		}
	}

	if(!isdefined(var_02))
	{
		if(isdefined(param_01) && param_01)
		{
			if(!isdefined(self.var_1491.var_2274["grenade_safe"]))
			{
				return 0;
			}

			var_02 = scripts\anim\utility::func_1F64("grenade_safe");
		}
		else
		{
			if(!isdefined(self.var_1491.var_2274["grenade_exposed"]))
			{
				return 0;
			}

			var_02 = scripts\anim\utility::func_1F64("grenade_exposed");
		}
	}

	func_F6B9();
	self.sendmatchdata = 1;
	var_03 = scripts\anim\combat_utility::func_128A0(param_00,var_02);
	self.sendmatchdata = 0;
	return var_03;
}

//Function Number: 35
func_D922()
{
}

//Function Number: 36
func_B01C(param_00)
{
	if(!isdefined(self.var_1491.var_2274["alert_to_look"]))
	{
		return 0;
	}

	func_F6B9();
	self.sendmatchdata = 1;
	if(!func_C9FC())
	{
		return 0;
	}

	scripts\anim\shared::func_D4C2(scripts\anim\utility::func_1F64("look_idle"),param_00,::func_3915);
	var_01 = undefined;
	if(scripts\anim\utility_common::issuppressedwrapper())
	{
		var_01 = scripts\anim\utility::func_1F64("look_to_alert_fast");
	}
	else
	{
		var_01 = scripts\anim\utility::func_1F64("look_to_alert");
	}

	self _meth_82E4("looking_end",var_01,%body,1,0.1,1);
	func_465E(var_01);
	scripts\anim\shared::donotetracks("looking_end");
	func_F6B9();
	self.sendmatchdata = 0;
	return 1;
}

//Function Number: 37
func_9EDA()
{
	var_00 = self.var_473C.angles;
	if(scripts\common\utility::actor_is3d())
	{
		var_00 = scripts\anim\utility_common::gettruenodeangles(self.covernode);
	}

	var_01 = self geteye();
	var_02 = anglestoright(var_00);
	var_03 = anglestoup(var_00);
	if(self.var_4664 == "right")
	{
		var_01 = var_01 + var_02 * 30;
	}
	else if(self.var_4664 == "left")
	{
		var_01 = var_01 - var_02 * 30;
	}
	else
	{
		var_01 = var_01 + var_03 * 30;
	}

	var_04 = var_01 + anglestoforward(var_00) * 30;
	return sighttracepassed(var_01,var_04,1,self);
}

//Function Number: 38
func_C9FC()
{
	if(isdefined(self.var_473C.var_ED6A))
	{
		return 0;
	}

	if(isdefined(self.var_BFA3) && gettime() < self.var_BFA3)
	{
		return 0;
	}

	if(!func_9EDA())
	{
		self.var_BFA3 = gettime() + 3000;
		return 0;
	}

	var_00 = scripts\anim\utility::func_1F64("alert_to_look");
	self _meth_82E3("looking_start",var_00,%body,1,0.2,1);
	func_465E(var_00);
	scripts\anim\shared::donotetracks("looking_start");
	return 1;
}

//Function Number: 39
func_3915()
{
	return self maymovetopoint(self.var_473C.origin,!scripts\common\utility::actor_is3d());
}

//Function Number: 40
func_6B9B()
{
	return 0;
}

//Function Number: 41
func_4668()
{
	var_00 = scripts\anim\utility::func_1F67("reload");
	self _meth_82E7("cornerReload",var_00,1,0.2);
	func_465E(var_00);
	scripts\anim\shared::donotetracks("cornerReload");
	self notify("abort_reload");
	scripts\anim\weaponlist::refillclip();
	self give_capture_credit(scripts\anim\utility::func_1F64("alert_idle"),1,0.2);
	self aiclearanim(var_00,0.2);
	return 1;
}

//Function Number: 42
func_9ED6(param_00,param_01)
{
	var_02 = !scripts\common\utility::actor_is3d();
	if(param_01)
	{
		var_03 = destroy();
		if(!self maymovetopoint(var_03,var_02))
		{
			return 0;
		}

		if(scripts\common\utility::actor_is3d())
		{
			return 1;
		}

		return self maymovefrompointtopoint(var_03,scripts\anim\utility::func_7DC6(param_00),var_02);
	}

	if(scripts\common\utility::actor_is3d())
	{
		return 1;
	}

	return self maymovetopoint(scripts\anim\utility::func_7DC6(param_01),var_03);
}

//Function Number: 43
destroy(param_00)
{
	var_01 = self.var_473C.angles;
	var_02 = anglestoright(var_01);
	if(!isdefined(param_00))
	{
		param_00 = 36;
	}

	var_03 = self.script;
	switch(var_03)
	{
		case "cover_left":
			var_02 = var_02 * 0 - param_00;
			break;

		case "cover_right":
			var_02 = var_02 * param_00;
			break;

		default:
			break;
	}

	return self.var_473C.origin + (var_02[0],var_02[1],0);
}

//Function Number: 44
func_92CC()
{
	self endon("end_idle");
	for(;;)
	{
		var_00 = randomint(2) == 0 && isdefined(self.var_1491.var_2274["alert_idle_twitch"]) && scripts\anim\utility::func_1F65("alert_idle_twitch");
		if(var_00)
		{
			var_01 = scripts\anim\utility::func_1F67("alert_idle_twitch");
		}
		else
		{
			var_01 = scripts\anim\utility::func_1F64("alert_idle");
		}

		func_D49E(var_01,var_00);
	}
}

//Function Number: 45
func_6F27()
{
	if(!scripts\anim\utility::func_1F65("alert_idle_flinch"))
	{
		return 0;
	}

	func_D49E(scripts\anim\utility::func_1F67("alert_idle_flinch"),1);
	return 1;
}

//Function Number: 46
func_D49E(param_00,param_01)
{
	if(param_01)
	{
		self _meth_82E4("idle",param_00,%body,1,0.1,1);
	}
	else
	{
		self _meth_82E3("idle",param_00,%body,1,0.1,1);
	}

	func_465E(param_00);
	scripts\anim\shared::donotetracks("idle");
}

//Function Number: 47
func_F2AE(param_00)
{
	[[ self.var_1F66["hiding"][param_00] ]]();
	[[ self.var_1F66["exposed"][param_00] ]]();
}

//Function Number: 48
func_F2AF(param_00)
{
	[[ self.var_1F66["exposed"][param_00] ]]();
}

//Function Number: 49
transitiontostance(param_00)
{
	if(self.var_1491.pose == param_00)
	{
		func_F2AE(param_00);
		return;
	}

	var_01 = scripts\anim\utility::func_1F64("stance_change");
	self _meth_82E4("changeStance",var_01,%body);
	func_465E(var_01);
	func_F2AE(param_00);
	scripts\anim\shared::donotetracks("changeStance");
	wait(0.2);
}

//Function Number: 50
_meth_846D(param_00,param_01,param_02)
{
	var_03 = scripts\anim\utility_common::getnodedirection();
	var_04 = scripts\anim\utility_common::func_7E28();
	var_05 = var_03 + self.var_8EDF;
	if(scripts\common\utility::actor_is3d())
	{
		self notify("force_space_rotation_update",0,0);
	}
	else
	{
		self orientmode("face angle",var_05);
	}

	self animmode("normal");
	if(isdefined(var_04))
	{
		thread scripts\anim\shared::func_BD1D(var_04,param_01);
	}

	self _meth_82E4("coveranim",param_00,%body,1,param_01);
	func_465E(param_00);
	scripts\anim\notetracks::donotetracksfortime(param_02,"coveranim");
	while(scripts\common\utility::absangleclamp180(self.angles[1] - var_05) > 1)
	{
		scripts\anim\notetracks::donotetracksfortime(0.1,"coveranim");
		var_03 = scripts\anim\utility_common::getnodedirection();
		var_05 = var_03 + self.var_8EDF;
	}

	func_F6B9();
	if(self.var_4664 == "left")
	{
		self.var_1491.var_10930 = "cover_left";
		return;
	}

	if(self.var_4664 == "right")
	{
		self.var_1491.var_10930 = "cover_right";
		return;
	}

	self.var_1491.var_10930 = "cover_up";
}

//Function Number: 51
drawoffset()
{
	self endon("killanimscript");
	wait(0.05);
}

//Function Number: 52
func_F5AD()
{
	if(!isdefined(self.var_1491.var_2274))
	{
	}

	var_00 = scripts\anim\utility::func_B028("default_stand");
	self.var_1491.var_2274["add_aim_up"] = var_00["add_aim_up"];
	self.var_1491.var_2274["add_aim_down"] = var_00["add_aim_down"];
	self.var_1491.var_2274["add_aim_left"] = var_00["add_aim_left"];
	self.var_1491.var_2274["add_aim_right"] = var_00["add_aim_right"];
	self.var_1491.var_2274["add_turn_aim_up"] = var_00["add_turn_aim_up"];
	self.var_1491.var_2274["add_turn_aim_down"] = var_00["add_turn_aim_down"];
	self.var_1491.var_2274["add_turn_aim_left"] = var_00["add_turn_aim_left"];
	self.var_1491.var_2274["add_turn_aim_right"] = var_00["add_turn_aim_right"];
	self.var_1491.var_2274["straight_level"] = var_00["straight_level"];
	if(self.var_1491.var_4667 == "lean")
	{
		var_01 = self.var_1491.var_2274["lean_fire"];
		var_02 = self.var_1491.var_2274["lean_single"];
		self.var_1491.var_2274["fire"] = var_01;
		self.var_1491.var_2274["single"] = scripts\anim\utility::func_2274(var_02);
		self.var_1491.var_2274["semi2"] = var_02;
		self.var_1491.var_2274["semi3"] = var_02;
		self.var_1491.var_2274["semi4"] = var_02;
		self.var_1491.var_2274["semi5"] = var_02;
		self.var_1491.var_2274["burst2"] = var_01;
		self.var_1491.var_2274["burst3"] = var_01;
		self.var_1491.var_2274["burst4"] = var_01;
		self.var_1491.var_2274["burst5"] = var_01;
		self.var_1491.var_2274["burst6"] = var_01;
	}
	else
	{
		self.var_1491.var_2274["fire"] = var_00["fire_corner"];
		self.var_1491.var_2274["semi2"] = var_00["semi2"];
		self.var_1491.var_2274["semi3"] = var_00["semi3"];
		self.var_1491.var_2274["semi4"] = var_00["semi4"];
		self.var_1491.var_2274["semi5"] = var_00["semi5"];
		if(scripts\anim\utility_common::weapon_pump_action_shotgun())
		{
			self.var_1491.var_2274["single"] = scripts\anim\utility::func_B027("shotgun_stand","single");
		}
		else
		{
			self.var_1491.var_2274["single"] = var_00["single"];
		}

		self.var_1491.var_2274["burst2"] = var_00["burst2"];
		self.var_1491.var_2274["burst3"] = var_00["burst3"];
		self.var_1491.var_2274["burst4"] = var_00["burst4"];
		self.var_1491.var_2274["burst5"] = var_00["burst5"];
		self.var_1491.var_2274["burst6"] = var_00["burst6"];
	}

	self.var_1491.var_2274["exposed_idle"] = var_00["exposed_idle"];
}

//Function Number: 53
func_F317()
{
	if(!isdefined(self.var_1491.var_2274))
	{
	}

	var_00 = scripts\anim\utility::func_B028("default_crouch");
	var_01["add_aim_up"] = scripts\anim\utility::func_B027("cover_crouch","add_aim_up");
	var_02["add_aim_up"] = scripts\anim\utility::func_B027("cover_crouch","add_aim_up");
	var_03[0] = scripts\anim\utility::func_B027("cover_crouch","add_aim_up");
	if(self.var_1491.var_4667 == "over")
	{
		self.var_1491.var_2274["add_aim_up"] = scripts\anim\utility::func_B027("cover_crouch","add_aim_up");
		self.var_1491.var_2274["add_aim_down"] = scripts\anim\utility::func_B027("cover_crouch","add_aim_down");
		self.var_1491.var_2274["add_aim_left"] = scripts\anim\utility::func_B027("cover_crouch","add_aim_left");
		self.var_1491.var_2274["add_aim_right"] = scripts\anim\utility::func_B027("cover_crouch","add_aim_right");
		self.var_1491.var_2274["straight_level"] = scripts\anim\utility::func_B027("cover_crouch","straight_level");
		self.var_1491.var_2274["exposed_idle"] = scripts\anim\utility::func_B027("default_stand","exposed_idle");
		return;
	}

	if(self.var_1491.var_4667 == "lean")
	{
		var_04 = self.var_1491.var_2274["lean_fire"];
		var_05 = self.var_1491.var_2274["lean_single"];
		self.var_1491.var_2274["fire"] = var_04;
		self.var_1491.var_2274["single"] = scripts\anim\utility::func_2274(var_05);
		self.var_1491.var_2274["semi2"] = var_05;
		self.var_1491.var_2274["semi3"] = var_05;
		self.var_1491.var_2274["semi4"] = var_05;
		self.var_1491.var_2274["semi5"] = var_05;
		self.var_1491.var_2274["burst2"] = var_04;
		self.var_1491.var_2274["burst3"] = var_04;
		self.var_1491.var_2274["burst4"] = var_04;
		self.var_1491.var_2274["burst5"] = var_04;
		self.var_1491.var_2274["burst6"] = var_04;
	}
	else
	{
		self.var_1491.var_2274["fire"] = var_00["fire"];
		self.var_1491.var_2274["semi2"] = var_00["semi2"];
		self.var_1491.var_2274["semi3"] = var_00["semi3"];
		self.var_1491.var_2274["semi4"] = var_00["semi4"];
		self.var_1491.var_2274["semi5"] = var_00["semi5"];
		if(scripts\anim\utility_common::weapon_pump_action_shotgun())
		{
			self.var_1491.var_2274["single"] = scripts\anim\utility::func_B027("shotgun_crouch","single");
		}
		else
		{
			self.var_1491.var_2274["single"] = var_00["single"];
		}

		self.var_1491.var_2274["burst2"] = var_00["burst2"];
		self.var_1491.var_2274["burst3"] = var_00["burst3"];
		self.var_1491.var_2274["burst4"] = var_00["burst4"];
		self.var_1491.var_2274["burst5"] = var_00["burst5"];
		self.var_1491.var_2274["burst6"] = var_00["burst6"];
	}

	self.var_1491.var_2274["add_aim_up"] = var_00["add_aim_up"];
	self.var_1491.var_2274["add_aim_down"] = var_00["add_aim_down"];
	self.var_1491.var_2274["add_aim_left"] = var_00["add_aim_left"];
	self.var_1491.var_2274["add_aim_right"] = var_00["add_aim_right"];
	self.var_1491.var_2274["add_turn_aim_up"] = var_00["add_turn_aim_up"];
	self.var_1491.var_2274["add_turn_aim_down"] = var_00["add_turn_aim_down"];
	self.var_1491.var_2274["add_turn_aim_left"] = var_00["add_turn_aim_left"];
	self.var_1491.var_2274["add_turn_aim_right"] = var_00["add_turn_aim_right"];
	self.var_1491.var_2274["straight_level"] = var_00["straight_level"];
	self.var_1491.var_2274["exposed_idle"] = var_00["exposed_idle"];
}

//Function Number: 54
func_E841()
{
	self notify("killanimscript");
	thread scripts\anim\combat::main();
}

//Function Number: 55
func_F6B9()
{
	if(scripts\common\utility::actor_is3d())
	{
		self animmode("nogravity");
		return;
	}

	self animmode("zonly_physics");
}

//Function Number: 56
func_465E(param_00)
{
	if(self.var_4664 == "left")
	{
		var_01 = "corner_stand_L";
	}
	else
	{
		var_01 = "corner_stand_R";
	}

	self.facialidx = scripts\anim\face::playfacialanim(param_00,var_01,self.facialidx);
}

//Function Number: 57
func_465D(param_00)
{
	self.facialidx = scripts\anim\face::playfacialanim(param_00,"aim",self.facialidx);
}

//Function Number: 58
func_465B()
{
	self.facialidx = undefined;
	self aiclearanim(%head,0.2);
}