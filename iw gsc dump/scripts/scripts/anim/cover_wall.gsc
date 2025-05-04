/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\anim\cover_wall.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 38
 * Decompile Time: 1983 ms
 * Timestamp: 10\27\2023 12:00:29 AM
*******************************************************************/

//Function Number: 1
func_950B()
{
}

//Function Number: 2
func_470E(param_00)
{
	self endon("killanimscript");
	self.covernode = self.target_getindexoftarget;
	self.var_4757 = param_00;
	if(!isdefined(self.var_205.turret))
	{
		scripts\anim\cover_behavior::func_129B4(0);
	}

	if(param_00 == "crouch")
	{
		func_F923("unknown");
		self.covernode func_97F0();
	}
	else
	{
		func_F925("unknown");
	}

	self.var_1491.var_1A3E = undefined;
	self orientmode("face angle",self.var_473C.angles[1]);
	if(isdefined(self.target_getindexoftarget) && isdefined(self.var_205.turret))
	{
		func_130DF();
	}

	self animmode("normal");
	if(param_00 == "crouch" && self.var_1491.pose == "stand")
	{
		var_01 = scripts\anim\utility::func_1F64("stand_2_hide");
		var_02 = getanimlength(var_01);
		self give_boombox(var_01,%body,1,0.2,scripts\anim\combat_utility::func_6B9A());
		thread scripts\anim\shared::func_BD1D(self.covernode,var_02);
		wait(var_02);
		self.var_1491.var_4727 = "hide";
	}
	else
	{
		func_B05A(0.4);
		if(distancesquared(self.origin,self.var_473C.origin) > 1)
		{
			thread scripts\anim\shared::func_BD1D(self.covernode,0.4);
			wait(0.2);
			if(param_00 == "crouch")
			{
				self.var_1491.pose = "crouch";
			}

			wait(0.2);
		}
		else
		{
			wait(0.1);
		}
	}

	func_F6C0();
	if(param_00 == "crouch")
	{
		if(self.var_1491.pose == "prone")
		{
			scripts\anim\utility::exitpronewrapper(1);
		}

		self.var_1491.pose = "crouch";
	}

	if(self.var_4757 == "stand")
	{
		self.var_1491.var_10930 = "cover_stand";
	}
	else
	{
		self.var_1491.var_10930 = "cover_crouch";
	}

	var_03 = spawnstruct();
	if(!self.logstring)
	{
		var_03.var_BD1C = ::scripts\anim\cover_behavior::func_BD1C;
	}

	var_03.openfile = ::func_4742;
	var_03.var_AB2D = ::func_D66A;
	var_03.setnojipscore = ::look;
	var_03.var_6B9B = ::func_6B9B;
	var_03.var_92CC = ::func_92CC;
	var_03.var_6F27 = ::func_6F27;
	var_03.objective_position = ::func_128AF;
	var_03._meth_85BF = ::func_128B0;
	var_03.var_2B99 = ::func_2B99;
	scripts\anim\cover_behavior::main(var_03);
}

//Function Number: 3
func_9F33(param_00)
{
	return getsubstr(param_00,0,3) == "rpd" && param_00.size == 3 || param_00[3] == "_";
}

//Function Number: 4
func_97F0()
{
	if(isdefined(self.var_4A9D))
	{
		return;
	}

	var_00 = (0,0,42);
	var_01 = anglestoforward(self.angles);
	self.var_4A9D = sighttracepassed(self.origin + var_00,self.origin + var_00 + var_01 * 64,0,undefined);
}

//Function Number: 5
func_F923(param_00)
{
	scripts\anim\combat::func_F337(self.covernode);
	func_F92B(param_00);
}

//Function Number: 6
func_F925(param_00)
{
	scripts\anim\combat::func_F337(self.covernode);
	func_FA52(param_00);
}

//Function Number: 7
func_4742()
{
	var_00 = scripts\anim\combat_utility::openfile(2,scripts\anim\utility::func_1F64("reload"));
	if(isdefined(var_00) && var_00)
	{
		return 1;
	}

	return 0;
}

//Function Number: 8
func_D66A()
{
	self.sendmatchdata = 1;
	if(isdefined(self.var_DC5C) && randomfloat(1) < self.var_DC5C)
	{
		if(func_DC57())
		{
			return 1;
		}
	}

	if(!func_D65B())
	{
		return 0;
	}

	shootastold();
	scripts\anim\combat_utility::func_631A();
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
		}
	}

	_meth_8405();
	self.var_4716 = undefined;
	self.sendmatchdata = 0;
	return 1;
}

//Function Number: 9
shootastold()
{
	self endon("return_to_cover");
	scripts\sp\_gameskill::func_54C4();
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

		if(self.var_4757 == "crouch" && func_BE9D())
		{
			break;
		}

		func_FEE1();
		self aiclearanim(%add_fire,0.2);
	}
}

//Function Number: 10
func_FEE1()
{
	if(self.var_4757 == "crouch")
	{
		thread func_1E82();
	}

	thread scripts\anim\combat_utility::func_1A3E();
	scripts\anim\combat_utility::func_FEDF();
}

//Function Number: 11
func_DC57()
{
	if(!scripts\anim\utility::func_8BED())
	{
		return 0;
	}

	var_00 = "rambo";
	if(randomint(10) < 2)
	{
		var_00 = "rambo_fail";
	}

	if(!scripts\anim\utility::func_1F65(var_00))
	{
		return 0;
	}

	if(self.var_4757 == "crouch" && !self.var_473C.var_4A9D)
	{
		return 0;
	}

	var_01 = _meth_811F(self.var_473C.origin + scripts\anim\utility_common::getnodeoffset(self.covernode));
	if(var_01 > 15)
	{
		return 0;
	}

	var_02 = anglestoforward(self.angles);
	var_03 = self.origin + var_02 * -16;
	if(!self maymovetopoint(var_03))
	{
		return 0;
	}

	self.var_4740 = gettime();
	func_F6C0();
	self.sendmatchdata = 1;
	self.var_9F15 = 1;
	self.var_1491.var_D892 = "rambo";
	self.var_3C60 = 1;
	thread scripts\anim\shared::func_DC59(0);
	var_04 = scripts\anim\utility::func_1F67(var_00);
	self _meth_82E4("rambo",var_04,%body,1,0.2,1);
	func_470A(var_04);
	scripts\anim\shared::donotetracks("rambo");
	self notify("rambo_aim_end");
	self.var_3C60 = 0;
	self.sendmatchdata = 0;
	self.var_A9D8 = gettime();
	self.var_3C60 = 0;
	self.var_9F15 = undefined;
	return 1;
}

//Function Number: 12
func_92CC()
{
	self endon("end_idle");
	for(;;)
	{
		var_00 = randomint(2) == 0 && scripts\anim\utility::func_1F65("hide_idle_twitch");
		if(var_00)
		{
			var_01 = scripts\anim\utility::func_1F67("hide_idle_twitch");
		}
		else
		{
			var_01 = scripts\anim\utility::func_1F64("hide_idle");
		}

		func_D49E(var_01,var_00);
	}
}

//Function Number: 13
func_6F27()
{
	if(!scripts\anim\utility::func_1F65("hide_idle_flinch"))
	{
		return 0;
	}

	var_00 = anglestoforward(self.angles);
	var_01 = self.origin + var_00 * -16;
	if(!self maymovetopoint(var_01,!scripts\common\utility::actor_is3d()))
	{
		return 0;
	}

	func_F6C0();
	self.sendmatchdata = 1;
	var_02 = scripts\anim\utility::func_1F67("hide_idle_flinch");
	func_D49E(var_02,1);
	self.sendmatchdata = 0;
	return 1;
}

//Function Number: 14
func_D49E(param_00,param_01)
{
	if(param_01)
	{
		self _meth_82E4("idle",param_00,%body,1,0.25,1);
	}
	else
	{
		self _meth_82E3("idle",param_00,%body,1,0.25,1);
	}

	func_470A(param_00);
	self.var_1491.var_4727 = "hide";
	scripts\anim\shared::donotetracks("idle");
}

//Function Number: 15
look(param_00)
{
	if(!isdefined(self.var_1491.var_2274["hide_to_look"]))
	{
		return 0;
	}

	if(!func_C9FC())
	{
		return 0;
	}

	scripts\anim\shared::func_D4C2(scripts\anim\utility::func_1F64("look_idle"),param_00);
	var_01 = undefined;
	if(scripts\anim\utility_common::issuppressedwrapper())
	{
		var_01 = scripts\anim\utility::func_1F64("look_to_hide_fast");
	}
	else
	{
		var_01 = scripts\anim\utility::func_1F64("look_to_hide");
	}

	self _meth_82E4("looking_end",var_01,%body,1,0.1);
	func_470A(var_01);
	scripts\anim\shared::donotetracks("looking_end");
	return 1;
}

//Function Number: 16
func_C9FC()
{
	if(isdefined(self.var_473C.var_ED6A))
	{
		return 0;
	}

	var_00 = scripts\anim\utility::func_1F64("hide_to_look");
	self _meth_82E3("looking_start",var_00,%body,1,0.2);
	func_470A(var_00);
	scripts\anim\shared::donotetracks("looking_start");
	return 1;
}

//Function Number: 17
func_6B9B()
{
	var_00 = scripts\anim\utility::func_1F67("look");
	self _meth_82E4("look",var_00,%body,1,0.1);
	func_470A(var_00);
	scripts\anim\shared::donotetracks("look");
	return 1;
}

//Function Number: 18
func_D65C()
{
	if(self.var_1491.var_4727 == "left" || self.var_1491.var_4727 == "right" || self.var_1491.var_4727 == "over")
	{
		return 1;
	}

	return scripts\anim\combat_utility::func_DCAD();
}

//Function Number: 19
func_D65B()
{
	var_00 = func_7DFA();
	var_01 = 0.1;
	var_02 = scripts\anim\utility::func_1F64("hide_2_" + var_00);
	var_03 = !scripts\common\utility::actor_is3d();
	if(!self maymovetopoint(scripts\anim\utility::func_7DC6(var_02),var_03))
	{
		return 0;
	}

	if(self.script == "cover_crouch" && var_00 == "lean")
	{
		self.var_4716 = 1;
	}

	if(self.var_4757 == "crouch")
	{
		func_F923(var_00);
	}
	else
	{
		func_F925(var_00);
	}

	self.var_1491.var_10930 = "none";
	self.var_10957 = undefined;
	if(self.var_4757 == "stand")
	{
		self.var_1491.var_10930 = "cover_stand_aim";
	}
	else
	{
		self.var_1491.var_10930 = "cover_crouch_aim";
	}

	self.var_3C60 = 1;
	self notify("done_changing_cover_pos");
	func_F6C0();
	var_04 = func_D65C();
	self _meth_82E4("pop_up",var_02,%body,1,0.1,var_04);
	thread donotetracksforpopup("pop_up");
	if(animhasnotetrack(var_02,"start_aim"))
	{
		self waittillmatch("start_aim","pop_up");
		var_01 = getanimlength(var_02) \ var_04 * 1 - self getscoreinfocategory(var_02);
	}
	else
	{
		self waittillmatch("end","pop_up");
		var_01 = 0.1;
	}

	self aiclearanim(var_02,var_01 + 0.05);
	self.var_1491.var_4727 = var_00;
	self.var_1491.var_D892 = var_00;
	func_F8A6(var_01);
	thread scripts\anim\track::func_11B07();
	wait(var_01);
	if(scripts\anim\utility_common::isasniper())
	{
		thread scripts\anim\shoot_behavior::func_103A7();
	}

	self.var_3C60 = 0;
	self.var_4740 = gettime();
	self notify("stop_popup_donotetracks");
	return 1;
}

//Function Number: 20
donotetracksforpopup(param_00)
{
	self endon("killanimscript");
	self endon("stop_popup_donotetracks");
	scripts\anim\shared::donotetracks(param_00);
}

//Function Number: 21
func_F8A6(param_00)
{
	if(self.var_1491.var_4727 == "left" || self.var_1491.var_4727 == "right")
	{
		var_01 = "crouch";
	}
	else
	{
		var_01 = self.var_1491.var_4727;
	}

	self _meth_82A5(scripts\anim\utility::func_1F64(var_01 + "_aim"),%body,1,param_00);
	if(var_01 == "crouch")
	{
		self _meth_82AC(scripts\anim\utility::func_B027("cover_crouch","add_aim_down"),1,0);
		self _meth_82AC(scripts\anim\utility::func_B027("cover_crouch","add_aim_left"),1,0);
		self _meth_82AC(scripts\anim\utility::func_B027("cover_crouch","add_aim_up"),1,0);
		self _meth_82AC(scripts\anim\utility::func_B027("cover_crouch","add_aim_right"),1,0);
		return;
	}

	if(var_01 == "stand")
	{
		self _meth_82AC(scripts\anim\utility::func_B027("default_stand","add_aim_down"),1,0);
		self _meth_82AC(scripts\anim\utility::func_B027("default_stand","add_aim_left"),1,0);
		self _meth_82AC(scripts\anim\utility::func_B027("default_stand","add_aim_up"),1,0);
		self _meth_82AC(scripts\anim\utility::func_B027("default_stand","add_aim_right"),1,0);
		return;
	}

	if(var_01 == "lean")
	{
		self _meth_82AC(scripts\anim\utility::func_B027("default_stand","add_aim_down"),1,0);
		self _meth_82AC(scripts\anim\utility::func_B027("default_stand","add_aim_left"),1,0);
		self _meth_82AC(scripts\anim\utility::func_B027("default_stand","add_aim_up"),1,0);
		self _meth_82AC(scripts\anim\utility::func_B027("default_stand","add_aim_right"),1,0);
		return;
	}

	if(var_01 == "over")
	{
		self _meth_82AC(scripts\anim\utility::func_B027("cover_stand","add_aim_down"),1,0);
		self _meth_82AC(scripts\anim\utility::func_B027("cover_stand","add_aim_left"),1,0);
		self _meth_82AC(scripts\anim\utility::func_B027("cover_stand","add_aim_up"),1,0);
		self _meth_82AC(scripts\anim\utility::func_B027("cover_stand","add_aim_right"),1,0);
		return;
	}
}

//Function Number: 22
_meth_8405()
{
	self notify("return_to_cover");
	self.var_3C60 = 1;
	self notify("done_changing_cover_pos");
	scripts\anim\combat_utility::func_6309();
	var_00 = func_D65C();
	self _meth_82E3("go_to_hide",scripts\anim\utility::func_1F64(self.var_1491.var_4727 + "_2_hide"),%body,1,0.2,var_00);
	self aiclearanim(%exposed_modern,0.2);
	scripts\anim\shared::donotetracks("go_to_hide");
	self.var_1491.var_4727 = "hide";
	if(self.var_4757 == "stand")
	{
		self.var_1491.var_10930 = "cover_stand";
	}
	else
	{
		self.var_1491.var_10930 = "cover_crouch";
	}

	self.var_3C60 = 0;
}

//Function Number: 23
func_128B0(param_00)
{
	return func_128AF(param_00,1);
}

//Function Number: 24
func_128AF(param_00,param_01)
{
	if(isdefined(self.dontevershoot) || isdefined(param_00.var_5951))
	{
		return 0;
	}

	var_02 = undefined;
	if(isdefined(self.var_DC5C) && randomfloat(1) < self.var_DC5C)
	{
		var_02 = scripts\anim\utility::func_1F67("grenade_rambo");
	}
	else if(isdefined(param_01) && param_01)
	{
		var_02 = scripts\anim\utility::func_1F67("grenade_safe");
	}
	else
	{
		var_02 = scripts\anim\utility::func_1F67("grenade_exposed");
	}

	func_F6C0();
	self.sendmatchdata = 1;
	var_03 = scripts\anim\combat_utility::func_128A0(param_00,var_02);
	self.sendmatchdata = 0;
	return var_03;
}

//Function Number: 25
func_2B99()
{
	if(!scripts\anim\utility::func_1F65("blind_fire"))
	{
		return 0;
	}

	func_F6C0();
	self.sendmatchdata = 1;
	self _meth_82E4("blindfire",scripts\anim\utility::func_1F67("blind_fire"),%body,1,0.2,1);
	scripts\anim\shared::donotetracks("blindfire");
	self.sendmatchdata = 0;
	return 1;
}

//Function Number: 26
func_4A2B(param_00,param_01,param_02)
{
	var_03 = spawnturret("misc_turret",param_00.origin,param_01);
	var_03.angles = param_00.angles;
	var_03.var_1A56 = self;
	var_03 setmodel(param_02);
	var_03 makeusable();
	var_03 setdefaultdroppitch(0);
	if(isdefined(param_00.setmatchdataid))
	{
		var_03.setmatchdataid = param_00.setmatchdataid;
	}

	if(isdefined(param_00.setdevdvarifuninitialized))
	{
		var_03.setdevdvarifuninitialized = param_00.setdevdvarifuninitialized;
	}

	if(isdefined(param_00.var_349))
	{
		var_03.var_349 = param_00.var_349;
	}

	if(isdefined(param_00.opcode::OP_ScriptLocalMethodThreadCall))
	{
		var_03.opcode::OP_ScriptLocalMethodThreadCall = param_00.opcode::OP_ScriptLocalMethodThreadCall;
	}

	return var_03;
}

//Function Number: 27
func_51B9(param_00)
{
	self endon("death");
	self endon("being_used");
	wait(0.1);
	if(isdefined(param_00))
	{
		param_00 notify("turret_use_failed");
	}

	self delete();
}

//Function Number: 28
func_130DF()
{
	var_00 = self.var_205.turret;
	if(!var_00.var_9F46)
	{
		return;
	}

	thread scripts\sp\_mg_penetration::func_8715(var_00);
	self waittill("continue_cover_script");
}

//Function Number: 29
func_F92B(param_00)
{
	self.var_1491.var_2274 = scripts\anim\utility::func_B028("cover_crouch");
	if(scripts\anim\utility_common::weapon_pump_action_shotgun())
	{
		if(param_00 == "lean" || param_00 == "stand")
		{
			self.var_1491.var_2274["single"] = scripts\anim\utility::func_B027("shotgun_stand","single");
		}
		else
		{
			self.var_1491.var_2274["single"] = scripts\anim\utility::func_B027("shotgun_crouch","single");
		}
	}

	if(isdefined(level.var_DC5B))
	{
		self.var_1491.var_2274["rambo"] = level.var_DC5B.var_4713;
		self.var_1491.var_2274["rambo_fail"] = level.var_DC5B.var_4714;
		self.var_1491.var_2274["grenade_rambo"] = level.var_DC5B.var_4715;
	}
}

//Function Number: 30
func_FA52(param_00)
{
	self.var_1491.var_2274 = scripts\anim\utility::func_B028("cover_stand");
	if(param_00 != "over")
	{
		var_01 = scripts\anim\utility::func_B028("default_stand");
		self.var_1491.var_2274["stand_aim"] = var_01["straight_level"];
		self.var_1491.var_2274["fire"] = var_01["fire_corner"];
		self.var_1491.var_2274["semi2"] = var_01["semi2"];
		self.var_1491.var_2274["semi3"] = var_01["semi3"];
		self.var_1491.var_2274["semi4"] = var_01["semi4"];
		self.var_1491.var_2274["semi5"] = var_01["semi5"];
		if(scripts\anim\utility_common::weapon_pump_action_shotgun())
		{
			self.var_1491.var_2274["single"] = scripts\anim\utility::func_B027("shotgun_stand","single");
		}
		else
		{
			self.var_1491.var_2274["single"] = var_01["single"];
		}

		self.var_1491.var_2274["burst2"] = var_01["burst2"];
		self.var_1491.var_2274["burst3"] = var_01["burst3"];
		self.var_1491.var_2274["burst4"] = var_01["burst4"];
		self.var_1491.var_2274["burst5"] = var_01["burst5"];
		self.var_1491.var_2274["burst6"] = var_01["burst6"];
	}

	if(isdefined(level.var_DC5B))
	{
		self.var_1491.var_2274["rambo"] = level.var_DC5B.var_474A;
		self.var_1491.var_2274["rambo_fail"] = level.var_DC5B.var_474B;
		self.var_1491.var_2274["grenade_rambo"] = level.var_DC5B.var_474C;
	}
}

//Function Number: 31
func_B05A(param_00)
{
	if(!isdefined(param_00))
	{
		param_00 = 0.1;
	}

	self give_boombox(scripts\anim\utility::func_1F64("hide_idle"),%body,1,param_00);
	self.var_1491.var_4727 = "hide";
}

//Function Number: 32
func_1E82()
{
	self endon("killanimscript");
	self notify("newAngleRangeCheck");
	self endon("newAngleRangeCheck");
	self endon("return_to_cover");
	for(;;)
	{
		if(func_BE9D())
		{
			break;
		}

		wait(0.1);
	}

	self notify("stopShooting");
}

//Function Number: 33
func_BE9D()
{
	if(self.var_4757 != "crouch")
	{
		return 0;
	}

	var_00 = _meth_811F(self geteye());
	if(self.var_1491.var_4727 == "lean")
	{
		return var_00 < 10;
	}

	return var_00 > 45;
}

//Function Number: 34
func_7DFA()
{
	var_00 = [];
	if(self.var_4757 == "stand")
	{
		var_00 = self.covernode _meth_8169();
		var_00[var_00.size] = "stand";
	}
	else
	{
		var_01 = _meth_811F(self.var_473C.origin + scripts\anim\utility_common::getnodeoffset(self.covernode));
		if(var_01 > 30)
		{
			return "lean";
		}

		if(var_01 > 15 || !self.var_473C.var_4A9D)
		{
			return "stand";
		}

		var_00 = self.covernode _meth_8169();
		var_00[var_00.size] = "crouch";
	}

	for(var_02 = 0;var_02 < var_00.size;var_02++)
	{
		if(!isdefined(self.var_1491.var_2274["hide_2_" + var_00[var_02]]))
		{
			var_00[var_02] = var_00[var_00.size - 1];
			var_00[var_00.size - 1] = undefined;
			continue;
		}
	}

	return scripts\anim\combat_utility::_meth_80B5(var_00);
}

//Function Number: 35
_meth_811F(param_00)
{
	var_01 = scripts\anim\utility_common::getenemyeyepos();
	return angleclamp180(vectortoangles(var_01 - param_00)[0]);
}

//Function Number: 36
func_F6C0()
{
	if(scripts\common\utility::actor_is3d())
	{
		self animmode("nogravity");
		return;
	}

	self animmode("zonly_physics");
}

//Function Number: 37
func_470A(param_00,param_01)
{
	if(!isdefined(param_01))
	{
		param_01 = "run";
	}

	self.facialidx = scripts\anim\face::playfacialanim(param_00,param_01,self.facialidx);
}

//Function Number: 38
func_4701()
{
	self.facialidx = undefined;
	self aiclearanim(%head,0.2);
}