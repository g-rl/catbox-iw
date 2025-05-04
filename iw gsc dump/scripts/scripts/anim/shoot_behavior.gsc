/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\anim\shoot_behavior.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 26
 * Decompile Time: 1266 ms
 * Timestamp: 10\27\2023 12:01:01 AM
*******************************************************************/

//Function Number: 1
func_4F69(param_00)
{
	self endon("killanimscript");
	self notify("stop_deciding_how_to_shoot");
	self endon("stop_deciding_how_to_shoot");
	self endon("death");
	scripts\sp\_gameskill::resetmisstime_code();
	self.var_FECA = param_00;
	self.var_FE9E = undefined;
	self.var_FECF = undefined;
	self.var_FED7 = "none";
	self.var_6B92 = 0;
	self.var_1006D = undefined;
	if(!isdefined(self.var_3C60))
	{
		self.var_3C60 = 0;
	}

	var_01 = isdefined(self.covernode) && self.var_473C.type != "Cover Prone" && self.var_473C.type != "Conceal Prone";
	if(var_01)
	{
		wait(0.05);
	}

	var_02 = self.var_FE9E;
	var_03 = self.var_FECF;
	var_04 = self.var_FED7;
	if(!isdefined(self.var_8B95))
	{
		self.var_1491.laseron = 1;
		scripts\anim\shared::updatelaserstatus();
	}

	if(scripts\anim\utility_common::isasniper())
	{
		func_E26D();
	}

	if(var_01 && !self.var_1491.var_2411 || !scripts\anim\utility_common::canseeenemy())
	{
		thread func_13A46();
	}

	thread func_E883();
	self.var_1E2B = undefined;
	for(;;)
	{
		if(isdefined(self.var_FED1))
		{
			if(!isdefined(self.isnodeoccupied))
			{
				self.var_FECF = self.var_FED1;
				self.var_FED1 = undefined;
				func_13696();
			}
			else
			{
				self.var_FED1 = undefined;
			}
		}

		var_05 = undefined;
		if(self.var_394 == "none")
		{
			func_C064();
		}
		else if(scripts\anim\utility_common::usingrocketlauncher())
		{
			var_05 = func_E778();
		}
		else if(scripts\anim\utility_common::isusingsidearm())
		{
			var_05 = func_CBE2();
		}
		else
		{
			var_05 = func_E501();
		}

		if(isdefined(self.var_1491.var_1096D))
		{
			[[ self.var_1491.var_1096D ]]();
		}

		if(func_3DFB(var_02,self.var_FE9E) || !isdefined(self.var_FE9E) && func_3DFB(var_03,self.var_FECF) || func_3DFB(var_04,self.var_FED7))
		{
			self notify("shoot_behavior_change");
		}

		var_02 = self.var_FE9E;
		var_03 = self.var_FECF;
		var_04 = self.var_FED7;
		if(!isdefined(var_05))
		{
			func_13696();
		}
	}
}

//Function Number: 2
func_13696()
{
	self endon("enemy");
	self endon("done_changing_cover_pos");
	self endon("weapon_position_change");
	self endon("enemy_visible");
	if(isdefined(self.var_FE9E))
	{
		self.var_FE9E endon("death");
		self endon("do_slow_things");
		wait(0.05);
		while(isdefined(self.var_FE9E))
		{
			self.var_FECF = self.var_FE9E getshootatpos();
			wait(0.05);
		}

		return;
	}

	self waittill("do_slow_things");
}

//Function Number: 3
func_C064()
{
	self.var_FE9E = undefined;
	self.var_FECF = undefined;
	self.var_FED7 = "none";
	self.var_FECA = "normal";
}

//Function Number: 4
func_100A4()
{
	return !scripts\anim\utility_common::isasniper() && !scripts\anim\utility_common::isshotgun(self.var_394);
}

//Function Number: 5
func_E503()
{
	if(!scripts\anim\utility_common::shouldshootenemyent())
	{
		if(scripts\anim\utility_common::isasniper())
		{
			func_E26D();
		}

		if(self.var_FC)
		{
			self.var_FECA = "ambush";
			return "retry";
		}

		if(!isdefined(self.isnodeoccupied))
		{
			func_8C4D();
			return;
		}

		func_B376();
		if((self.assertmsg || randomint(5) > 0) && func_100A4())
		{
			self.var_FECA = "suppress";
		}
		else
		{
			self.var_FECA = "ambush";
		}

		return "retry";
	}

	func_F83F();
	func_F842();
}

//Function Number: 6
func_E504(param_00)
{
	if(!param_00)
	{
		func_8C4D();
		return;
	}

	self.var_FE9E = undefined;
	self.var_FECF = scripts\anim\utility::func_7E90();
	func_F841();
}

//Function Number: 7
func_E502(param_00)
{
	self.var_FED7 = "none";
	self.var_FE9E = undefined;
	if(!param_00)
	{
		func_7DB9();
		if(func_1009A())
		{
			self.var_1E2B = undefined;
			self notify("return_to_cover");
			self.var_1006D = 1;
			return;
		}

		return;
	}

	self.var_FECF = scripts\anim\utility::func_7E90();
	if(func_1009A())
	{
		self.var_1E2B = undefined;
		if(func_100A4())
		{
			self.var_FECA = "suppress";
		}

		if(randomint(3) == 0)
		{
			self notify("return_to_cover");
			self.var_1006D = 1;
		}

		return "retry";
	}
}

//Function Number: 8
func_7DB9()
{
	if(isdefined(self.isnodeoccupied) && self getpersstat(self.isnodeoccupied))
	{
		func_F83F();
		return;
	}

	var_00 = self getsafeanimmovedeltapercentage();
	if(!isdefined(var_00))
	{
		if(isdefined(self.covernode))
		{
			var_00 = self.var_473C.angles;
		}
		else if(isdefined(self.var_1E2C))
		{
			var_00 = self.var_1E2C.angles;
		}
		else if(isdefined(self.isnodeoccupied))
		{
			var_00 = vectortoangles(self lastknownpos(self.isnodeoccupied) - self.origin);
		}
		else
		{
			var_00 = self.angles;
		}
	}

	var_01 = 1024;
	if(isdefined(self.isnodeoccupied))
	{
		var_01 = distance(self.origin,self.var_10C.origin);
	}

	var_02 = self geteye() + anglestoforward(var_00) * var_01;
	if(!isdefined(self.var_FECF) || distancesquared(var_02,self.var_FECF) > 25)
	{
		self.var_FECF = var_02;
	}
}

//Function Number: 9
func_E501()
{
	if(self.var_FECA == "normal")
	{
		func_E503();
	}
	else
	{
		if(scripts\anim\utility_common::shouldshootenemyent())
		{
			self.var_FECA = "normal";
			self.var_1E2B = undefined;
			return "retry";
		}

		func_B376();
		if(scripts\anim\utility_common::isasniper())
		{
			func_E26D();
		}

		var_00 = scripts\anim\utility_common::cansuppressenemy();
		if(self.var_FECA == "suppress" || self.team == "allies" && !isdefined(self.isnodeoccupied) && !var_00)
		{
			func_E504(var_00);
		}
		else
		{
			func_E502(var_00);
		}
	}
}

//Function Number: 10
func_1009A()
{
	if(!isdefined(self.var_1E2B))
	{
		if(self gettargetchargepos())
		{
			self.var_1E2B = gettime() + randomintrange(10000,-5536);
		}
		else
		{
			self.var_1E2B = gettime() + randomintrange(4000,10000);
		}
	}

	return self.var_1E2B < gettime();
}

//Function Number: 11
func_E778()
{
	if(!scripts\anim\utility_common::shouldshootenemyent())
	{
		func_B376();
		func_8C4D();
		return;
	}

	func_F83F();
	func_F840("single",0);
	var_00 = lengthsquared(self.origin - self.var_FECF);
	if(var_00 < squared(512))
	{
		self notify("return_to_cover");
		self.var_1006D = 1;
	}
}

//Function Number: 12
func_CBE2()
{
	if(self.var_FECA == "normal")
	{
		if(!scripts\anim\utility_common::shouldshootenemyent())
		{
			if(!isdefined(self.isnodeoccupied))
			{
				func_8C4D();
				return;
			}

			func_B376();
			self.var_FECA = "ambush";
			return "retry";
		}

		func_F83F();
		func_F840("single",0);
		return;
	}

	if(scripts\anim\utility_common::shouldshootenemyent())
	{
		self.var_FECA = "normal";
		self.var_1E2B = undefined;
		return "retry";
	}

	func_B376();
	self.var_FE9E = undefined;
	self.var_FED7 = "none";
	self.var_FECF = scripts\anim\utility::func_7E90();
	if(!isdefined(self.var_1E2B))
	{
		self.var_1E2B = gettime() + randomintrange(4000,8000);
	}

	if(self.var_1E2B < gettime())
	{
		self.var_FECA = "normal";
		self.var_1E2B = undefined;
		return "retry";
	}
}

//Function Number: 13
func_B376()
{
	if(isdefined(self.isnodeoccupied) && !self.var_3C60 && self.script != "combat")
	{
		if(isai(self.isnodeoccupied) && isdefined(self.var_10C.script) && self.var_10C.script == "cover_stand" || self.var_10C.script == "cover_crouch")
		{
			if(isdefined(self.var_10C.var_1491.var_4727) && self.var_10C.var_1491.var_4727 == "hide")
			{
				return;
			}
		}

		self.var_46A6 = self.var_10C.origin;
	}
}

//Function Number: 14
func_13A46()
{
	self endon("killanimscript");
	self endon("stop_deciding_how_to_shoot");
	for(;;)
	{
		self waittill("suppression");
		if(self.testbrushedgesforgrapple > self.suppressionthreshold)
		{
			if(func_DD7D())
			{
				self notify("return_to_cover");
				self.var_1006D = 1;
			}
		}
	}
}

//Function Number: 15
func_DD7D()
{
	if(self.var_3C60)
	{
		return 0;
	}

	if(!isdefined(self.isnodeoccupied) || !self getpersstat(self.isnodeoccupied))
	{
		return 1;
	}

	if(gettime() < self.var_4740 + 800)
	{
		return 0;
	}

	if(isplayer(self.isnodeoccupied) && self.var_10C.health < self.var_10C.maxhealth * 0.5)
	{
		if(gettime() < self.var_4740 + 3000)
		{
			return 0;
		}
	}

	return 1;
}

//Function Number: 16
func_E883()
{
	self endon("death");
	scripts\common\utility::waittill_any_3("killanimscript","stop_deciding_how_to_shoot");
	self.var_1491.laseron = 0;
	scripts\anim\shared::updatelaserstatus();
}

//Function Number: 17
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

//Function Number: 18
func_F83F()
{
	self.var_FE9E = self.isnodeoccupied;
	self.var_FECF = self.var_FE9E getshootatpos();
}

//Function Number: 19
func_8C4D()
{
	self.var_FE9E = undefined;
	self.var_FECF = undefined;
	self.var_FED7 = "none";
	if(self.var_FC)
	{
		self.var_FECA = "ambush";
	}

	if(!self.var_3C60)
	{
		self notify("return_to_cover");
		self.var_1006D = 1;
	}
}

//Function Number: 20
func_FFC6()
{
	return level.var_7683 == 3 && isplayer(self.isnodeoccupied);
}

//Function Number: 21
func_F842()
{
	if(isdefined(self.var_FE9E.isnodeoccupied) && isdefined(self.var_FE9E.var_10C.physics_setgravityragdollscalar))
	{
		return func_F840("single",0);
	}

	if(scripts\anim\utility_common::isasniper())
	{
		return func_F840("single",0);
	}

	if(scripts\anim\utility_common::isshotgun(self.var_394))
	{
		if(scripts\anim\utility_common::weapon_pump_action_shotgun())
		{
			return func_F840("single",0);
		}
		else
		{
			return func_F840("semi",0);
		}
	}

	if(weaponclass(self.var_394) == "grenade")
	{
		return func_F840("single",0);
	}

	if(function_023C(self.var_394) > 0)
	{
		return func_F840("burst",0);
	}

	if(isdefined(self.var_A4A3) && self.var_A4A3)
	{
		return func_F840("full",1);
	}

	var_00 = distancesquared(self getshootatpos(),self.var_FECF);
	var_01 = weaponclass(self.var_394) == "mg";
	if(self.assertmsg && var_01)
	{
		return func_F840("full",0);
	}

	if(var_00 < -3036)
	{
		if(isdefined(self.var_FE9E) && isdefined(self.var_FE9E.var_B14F))
		{
			return func_F840("single",0);
		}
		else
		{
			return func_F840("full",0);
		}
	}
	else if(var_00 < 810000 || func_FFC6())
	{
		if(function_0248(self.var_394) || func_FFF6())
		{
			return func_F840("semi",1);
		}
		else
		{
			return func_F840("burst",1);
		}
	}
	else if(self.assertmsg || var_01 || var_00 < 2560000)
	{
		if(func_FFF6())
		{
			return func_F840("semi",0);
		}
		else
		{
			return func_F840("burst",0);
		}
	}

	return func_F840("single",0);
}

//Function Number: 22
func_F841()
{
	var_00 = distancesquared(self getshootatpos(),self.var_FECF);
	if(function_0248(self.var_394))
	{
		if(var_00 < 2560000)
		{
			return func_F840("semi",0);
		}

		return func_F840("single",0);
	}

	if(weaponclass(self.var_394) == "mg")
	{
		return func_F840("full",0);
	}

	if(self.assertmsg || var_00 < 2560000)
	{
		if(func_FFF6())
		{
			return func_F840("semi",0);
		}
		else
		{
			return func_F840("burst",0);
		}
	}

	return func_F840("single",0);
}

//Function Number: 23
func_F840(param_00,param_01)
{
	self.var_FED7 = param_00;
	self.var_6B92 = param_01;
}

//Function Number: 24
func_FFF6()
{
	if(weaponclass(self.var_394) != "rifle")
	{
		return 0;
	}

	if(self.team != "allies")
	{
		return 0;
	}

	var_00 = scripts\anim\utility_common::safemod(int(self.origin[1]),10000) + 2000;
	var_01 = int(self.origin[0]) + gettime();
	return var_01 % 2 * var_00 > var_00;
}

//Function Number: 25
func_E26D()
{
	self.var_103BF = 0;
	self.var_103BA = 0;
	thread func_103A7();
}

//Function Number: 26
func_103A7()
{
	self endon("killanimscript");
	self endon("enemy");
	self endon("return_to_cover");
	self notify("new_glint_thread");
	self endon("new_glint_thread");
	if(isdefined(self.var_5583) && self.var_5583)
	{
		return;
	}

	if(!isdefined(level._effect["sniper_glint"]))
	{
		return;
	}

	if(!isalive(self.isnodeoccupied))
	{
		return;
	}

	var_00 = scripts\common\utility::getfx("sniper_glint");
	wait(0.2);
	for(;;)
	{
		if(self.var_394 == self.primaryweapon && scripts\anim\combat_utility::func_D285())
		{
			if(distancesquared(self.origin,self.var_10C.origin) > 65536)
			{
				playfxontag(var_00,self,"tag_flash");
			}

			var_01 = randomfloatrange(3,5);
			wait(var_01);
		}

		wait(0.2);
	}
}