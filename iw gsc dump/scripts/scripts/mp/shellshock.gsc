/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\shellshock.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 19
 * Decompile Time: 859 ms
 * Timestamp: 10/27/2023 12:21:30 AM
*******************************************************************/

//Function Number: 1
init()
{
	level._effect["slide_dust"] = loadfx("vfx/core/screen/vfx_scrnfx_tocam_slidedust_m");
	level._effect["hit_left"] = loadfx("vfx/core/screen/vfx_blood_hit_left");
	level._effect["hit_right"] = loadfx("vfx/core/screen/vfx_blood_hit_right");
	level._effect["melee_spray"] = loadfx("vfx/core/screen/vfx_melee_blood_spray");
}

//Function Number: 2
shellshockondamage(param_00,param_01)
{
	if(isdefined(self.flashendtime) && gettime() < self.flashendtime)
	{
		return;
	}

	if(param_00 == "MOD_EXPLOSIVE" || param_00 == "MOD_GRENADE" || param_00 == "MOD_GRENADE_SPLASH" || param_00 == "MOD_PROJECTILE" || param_00 == "MOD_PROJECTILE_SPLASH")
	{
		if(param_01 > 10)
		{
			if(isplayer(self) && self _meth_84CA())
			{
				return;
			}

			if(isdefined(self.shellshockreduction) && self.shellshockreduction)
			{
				self shellshock("frag_grenade_mp",self.shellshockreduction);
				return;
			}

			self shellshock("frag_grenade_mp",0.5);
			return;
		}
	}
}

//Function Number: 3
endondeath()
{
	self waittill("death");
	waittillframeend;
	self notify("end_explode");
}

//Function Number: 4
grenade_earthquake(param_00,param_01)
{
	self notify("grenade_earthQuake");
	self endon("grenade_earthQuake");
	thread endondeath();
	self endon("end_explode");
	var_02 = undefined;
	if(!isdefined(param_01) || param_01)
	{
		self waittill("explode",var_02);
	}
	else
	{
		var_02 = self.origin;
	}

	grenade_earthquakeatposition_internal(var_02,param_00);
}

//Function Number: 5
grenade_earthquakeatposition(param_00,param_01,param_02)
{
	grenade_earthquakeatposition_internal(param_00,param_01,param_02);
}

//Function Number: 6
grenade_earthquakeatposition_internal(param_00,param_01,param_02)
{
	if(!isdefined(param_01))
	{
		param_01 = 1;
	}

	func_13B9("grenade_rumble",param_00,param_02);
	var_03 = 0.45 * param_01;
	var_04 = 0.7;
	var_05 = 800;
	_earthquake(var_03,var_04,param_00,var_05,param_02);
	_screenshakeonposition(param_00,600,param_02);
}

//Function Number: 7
bloodeffect(param_00)
{
	self endon("disconnect");
	if(!scripts\mp\utility::isreallyalive(self))
	{
		return;
	}

	var_01 = vectornormalize(anglestoforward(self.angles));
	var_02 = vectornormalize(anglestoright(self.angles));
	var_03 = vectornormalize(param_00 - self.origin);
	var_04 = vectordot(var_03,var_01);
	var_05 = vectordot(var_03,var_02);
	if(var_04 > 0 && var_04 > 0.5)
	{
		return;
	}

	if(abs(var_04) < 0.866)
	{
		var_06 = level._effect["hit_left"];
		if(var_05 > 0)
		{
			var_06 = level._effect["hit_right"];
		}

		var_07 = ["death","damage"];
		thread play_fx_with_entity(var_06,var_07,7);
	}
}

//Function Number: 8
func_2BC3(param_00)
{
	self endon("disconnect");
	if(isdefined(param_00) && scripts\mp\utility::getweaponrootname(param_00) == "iw7_axe" && self getweaponammoclip(param_00) > 0)
	{
		if(!isdefined(self.axeswingnum))
		{
			self.axeswingnum = 1;
		}

		var_01 = "axe_blood_" + self.axeswingnum;
		thread activateaxeblood(var_01);
		self.axeswingnum++;
		if(self.axeswingnum > 5)
		{
			self.axeswingnum = 1;
			return;
		}

		return;
	}

	wait(0.5);
	var_02 = ["death"];
	thread play_fx_with_entity(level._effect["melee_spray"],var_02,1.5);
}

//Function Number: 9
activateaxeblood(param_00)
{
	self endon("disconnect");
	self setscriptablepartstate(param_00,"blood");
	wait(5);
	self setscriptablepartstate(param_00,"neutral");
}

//Function Number: 10
play_fx_with_entity(param_00,param_01,param_02)
{
	self endon("disconnect");
	var_03 = function_01E1(param_00,self geteye(),self);
	triggerfx(var_03);
	var_03 setfxkilldefondelete();
	scripts\engine\utility::waittill_any_in_array_or_timeout(param_01,param_02);
	var_03 delete();
}

//Function Number: 11
c4_earthquake()
{
	thread endondeath();
	self endon("end_explode");
	self waittill("explode",var_00);
	playrumbleonposition("grenade_rumble",var_00);
	earthquake(0.4,0.75,var_00,512);
	foreach(var_02 in level.players)
	{
		if(var_02 scripts\mp\utility::isusingremote())
		{
			continue;
		}

		if(distance(var_00,var_02.origin) > 512)
		{
			continue;
		}

		var_02 setclientomnvar("ui_hud_shake",1);
	}
}

//Function Number: 12
func_22FF(param_00,param_01,param_02)
{
	var_03 = self.origin;
	func_13B9("artillery_rumble",var_03);
	if(!isdefined(param_00))
	{
		param_00 = 0.7;
	}

	if(!isdefined(param_01))
	{
		param_01 = 0.5;
	}

	if(!isdefined(param_02))
	{
		param_02 = 800;
	}

	_earthquake(param_00,param_01,var_03,param_02);
	_screenshakeonposition(var_03,param_02);
}

//Function Number: 13
func_10F44(param_00)
{
	playrumbleonposition("grenade_rumble",param_00);
	earthquake(1,0.6,param_00,2000);
	foreach(var_02 in level.players)
	{
		if(var_02 scripts\mp\utility::isusingremote())
		{
			continue;
		}

		if(distance(param_00,var_02.origin) > 1000)
		{
			continue;
		}

		var_02 setclientomnvar("ui_hud_shake",1);
	}
}

//Function Number: 14
airstrike_earthquake(param_00)
{
	func_13B9("artillery_rumble",param_00);
	_earthquake(0.5,0.65,param_00,1000);
	_screenshakeonposition(param_00,900);
}

//Function Number: 15
func_DAF3(param_00)
{
	self notify("pulseGrenade_earthQuake");
	self endon("pulseGrenade_earthQuake");
	thread endondeath();
	self endon("end_explode");
	var_01 = undefined;
	if(!isdefined(param_00) || param_00)
	{
		self waittill("explode",var_01);
	}
	else
	{
		var_01 = self.origin;
	}

	playrumbleonposition("grenade_rumble",var_01);
	earthquake(0.3,0.35,var_01,800);
	foreach(var_03 in level.players)
	{
		if(var_03 scripts\mp\utility::isusingremote())
		{
			continue;
		}

		if(distancesquared(var_01,var_03.origin) > 90000)
		{
			continue;
		}

		var_03 setclientomnvar("ui_hud_shake",1);
	}
}

//Function Number: 16
func_65C4(param_00)
{
	self notify("pulseGrenade_earthQuake");
	self endon("pulseGrenade_earthQuake");
	thread endondeath();
	self endon("end_explode");
	var_01 = undefined;
	if(!isdefined(param_00) || param_00)
	{
		self waittill("explode",var_01);
	}
	else
	{
		var_01 = self.origin;
	}

	playrumbleonposition("grenade_rumble",var_01);
	earthquake(0.3,0.35,var_01,800);
	foreach(var_03 in level.players)
	{
		if(var_03 scripts\mp\utility::isusingremote())
		{
			continue;
		}

		if(distancesquared(var_01,var_03.origin) > 90000)
		{
			continue;
		}

		var_03 setclientomnvar("ui_hud_shake",1);
	}
}

//Function Number: 17
_earthquake(param_00,param_01,param_02,param_03,param_04)
{
	if(!isdefined(param_04))
	{
		param_04 = 0;
	}

	foreach(var_06 in level.players)
	{
		if(!isdefined(var_06))
		{
			continue;
		}

		var_07 = scripts/mp/equipment/phase_shift::isentityphaseshifted(var_06);
		if((var_07 && param_04) || !var_07 && !param_04)
		{
			var_06 earthquakeforplayer(param_00,param_01,param_02,param_03);
		}
	}
}

//Function Number: 18
func_13B9(param_00,param_01,param_02)
{
	if(!isdefined(param_02))
	{
		param_02 = 0;
	}

	foreach(var_04 in level.players)
	{
		if(!isdefined(var_04))
		{
			continue;
		}

		var_05 = scripts/mp/equipment/phase_shift::isentityphaseshifted(var_04);
		if((var_05 && param_02) || !var_05 && !param_02)
		{
			var_04 getyaw(param_00,param_01);
		}
	}
}

//Function Number: 19
_screenshakeonposition(param_00,param_01,param_02)
{
	if(!isdefined(param_02))
	{
		param_02 = 0;
	}

	var_03 = param_01 * param_01;
	foreach(var_05 in level.players)
	{
		if(!isdefined(var_05))
		{
			continue;
		}

		if(var_05 scripts\mp\utility::isusingremote())
		{
			continue;
		}

		var_06 = scripts/mp/equipment/phase_shift::isentityphaseshifted(var_05);
		if((var_06 && param_02) || !var_06 && !param_02)
		{
			if(distancesquared(param_00,var_05.origin) <= var_03)
			{
				var_05 setclientomnvar("ui_hud_shake",1);
			}
		}
	}
}