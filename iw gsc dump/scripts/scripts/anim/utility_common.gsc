/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\anim\utility_common.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 66
 * Decompile Time: 3355 ms
 * Timestamp: 10\27\2023 12:01:14 AM
*******************************************************************/

//Function Number: 1
print3dtime(param_00,param_01,param_02,param_03,param_04,param_05)
{
	var_06 = param_00 \ 0.05;
	for(var_07 = 0;var_07 < var_06;var_07++)
	{
		wait(0.05);
	}
}

//Function Number: 2
print3drise(param_00,param_01,param_02,param_03,param_04)
{
	var_05 = 100;
	var_06 = 0;
	param_00 = param_00 + scripts\common\utility::randomvector(30);
	for(var_07 = 0;var_07 < var_05;var_07++)
	{
		var_06 = var_06 + 0.5;
		wait(0.05);
	}
}

//Function Number: 3
crossproduct(param_00,param_01)
{
	return param_00[0] * param_01[1] - param_00[1] * param_01[0] > 0;
}

//Function Number: 4
safemod(param_00,param_01)
{
	var_02 = int(param_00) % param_01;
	var_02 = var_02 + param_01;
	return var_02 % param_01;
}

//Function Number: 5
quadrantanimweights(param_00)
{
	var_01 = cos(param_00);
	var_02 = sin(param_00);
	var_03["front"] = 0;
	var_03["right"] = 0;
	var_03["back"] = 0;
	var_03["left"] = 0;
	if(isdefined(self.alwaysrunforward))
	{
		var_03["front"] = 1;
		return var_03;
	}

	if(var_01 > 0)
	{
		if(var_02 > var_01)
		{
			var_03["left"] = 1;
		}
		else if(var_02 < -1 * var_01)
		{
			var_03["right"] = 1;
		}
		else
		{
			var_03["front"] = 1;
		}
	}
	else
	{
		var_04 = -1 * var_01;
		if(var_02 > var_04)
		{
			var_03["left"] = 1;
		}
		else if(var_02 < var_01)
		{
			var_03["right"] = 1;
		}
		else
		{
			var_03["back"] = 1;
		}
	}

	return var_03;
}

//Function Number: 6
getquadrant(param_00)
{
	param_00 = angleclamp(param_00);
	if(param_00 < 45 || param_00 > 315)
	{
		var_01 = "front";
	}
	else if(var_01 < 135)
	{
		var_01 = "left";
	}
	else if(var_01 < 225)
	{
		var_01 = "back";
	}
	else
	{
		var_01 = "right";
	}

	return var_01;
}

//Function Number: 7
isinset(param_00,param_01)
{
	for(var_02 = param_01.size - 1;var_02 >= 0;var_02--)
	{
		if(param_00 == param_01[var_02])
		{
			return 1;
		}
	}

	return 0;
}

//Function Number: 8
weapon_pump_action_shotgun()
{
	return self.var_394 != "none" && function_0246(self.var_394) && weaponclass(self.var_394) == "spread";
}

//Function Number: 9
isshotgun(param_00)
{
	return weaponclass(param_00) == "spread";
}

//Function Number: 10
issniperrifle(param_00)
{
	return weaponclass(param_00) == "sniper";
}

//Function Number: 11
isshotgunai()
{
	return isshotgun(self.primaryweapon);
}

//Function Number: 12
isasniper(param_00)
{
	if(!isdefined(param_00))
	{
		param_00 = 1;
	}

	if(!issniperrifle(self.primaryweapon))
	{
		return 0;
	}

	if(param_00)
	{
		if(self.primaryweapon != self.var_394)
		{
			return issniperrifle(self.var_394);
		}
	}

	return 1;
}

//Function Number: 13
islongrangeai()
{
	return isasniper() || usingrocketlauncher();
}

//Function Number: 14
usingpistol()
{
	return weaponclass(self.var_394) == "pistol";
}

//Function Number: 15
usingrocketlauncher()
{
	return weaponclass(self.var_394) == "rocketlauncher";
}

//Function Number: 16
usingmg()
{
	return weaponclass(self.var_394) == "mg";
}

//Function Number: 17
isusingshotgun()
{
	return weaponclass(self.var_394) == "spread";
}

//Function Number: 18
usingriflelikeweapon()
{
	var_00 = weaponclass(self.var_394);
	switch(var_00)
	{
		case "sniper":
		case "mg":
		case "smg":
		case "rifle":
		case "spread":
			return 1;
	}

	return 0;
}

//Function Number: 19
repeater_headshot_ammo_passive(param_00,param_01,param_02)
{
	if(!isdefined(param_00) || !isdefined(param_01) || !isdefined(param_02))
	{
		return;
	}

	if(!isplayer(param_01))
	{
		return;
	}

	var_03 = getweaponbasename(param_00);
	if(!isdefined(var_03) || var_03 != "iw7_repeater")
	{
		return;
	}

	if(!isdefined(param_02.var_DD))
	{
		return;
	}

	if(param_02.var_DD != "head" && param_02.var_DD != "helmet")
	{
		return;
	}

	var_04 = weaponclipsize(param_00);
	var_05 = var_04 * 1;
	var_06 = param_01 getweaponammoclip(param_00);
	var_07 = min(var_06 + var_05,var_04);
	param_01 setweaponammoclip(param_00,int(var_07));
}

//Function Number: 20
needtoreload(param_00)
{
	if(self.var_394 == "none")
	{
		return 0;
	}

	if(isdefined(self.var_C08B))
	{
		if(self.bulletsinclip < weaponclipsize(self.var_394) * 0.5)
		{
			self.bulletsinclip = int(weaponclipsize(self.var_394) * 0.5);
		}

		if(self.bulletsinclip <= 0)
		{
			self.bulletsinclip = 0;
		}

		return 0;
	}

	if(self.bulletsinclip <= weaponclipsize(self.var_394) * param_00)
	{
		if(param_00 == 0)
		{
			if(cheatammoifnecessary())
			{
				return 0;
			}
		}

		return 1;
	}

	return 0;
}

//Function Number: 21
cheatammoifnecessary()
{
	if(!isdefined(self.isnodeoccupied))
	{
		return 0;
	}

	if(self.team != "allies")
	{
		if(!isplayer(self.isnodeoccupied))
		{
			return 0;
		}
	}

	if(isusingsidearm() || usingrocketlauncher())
	{
		return 0;
	}

	if(gettime() - self.ammocheattime < self.ammocheatinterval)
	{
		return 0;
	}

	if(!self getpersstat(self.isnodeoccupied) && distancesquared(self.origin,self.var_10C.origin) > 65536)
	{
		return 0;
	}

	self.bulletsinclip = int(weaponclipsize(self.var_394) \ 2);
	if(self.bulletsinclip > weaponclipsize(self.var_394))
	{
		self.bulletsinclip = weaponclipsize(self.var_394);
	}

	self.ammocheattime = gettime();
	return 1;
}

//Function Number: 22
isusingprimary()
{
	return self.var_394 == self.primaryweapon && self.var_394 != "none";
}

//Function Number: 23
isusingsecondary()
{
	return self.var_394 == self.secondaryweapon && self.var_394 != "none";
}

//Function Number: 24
isusingsidearm()
{
	if(!isdefined(self.var_101B4))
	{
		return 0;
	}

	return self.var_394 == self.var_101B4 && self.var_394 != "none";
}

//Function Number: 25
func_7E28()
{
	var_00 = self.target_getindexoftarget;
	if(isdefined(var_00) && self getweaponassetfromrootweapon(var_00) || isdefined(self.covernode) && var_00 == self.covernode)
	{
		return var_00;
	}

	return undefined;
}

//Function Number: 26
func_7FFE()
{
	var_00 = func_7E28();
	if(isdefined(var_00))
	{
		return var_00.type;
	}

	return "none";
}

//Function Number: 27
getnodedirection()
{
	var_00 = func_7E28();
	if(isdefined(var_00))
	{
		return var_00.angles[1];
	}

	return self.var_EC;
}

//Function Number: 28
getnodeforward()
{
	var_00 = func_7E28();
	if(isdefined(var_00))
	{
		return anglestoforward(var_00.angles);
	}

	return anglestoforward(self.angles);
}

//Function Number: 29
func_7FFD()
{
	var_00 = func_7E28();
	if(isdefined(var_00))
	{
		return var_00.origin;
	}

	return self.origin;
}

//Function Number: 30
shootenemywrapper(param_00)
{
	if(!isdefined(param_00))
	{
		param_00 = 1;
	}

	[[ level.shootenemywrapper_func ]](param_00);
}

//Function Number: 31
getnodeyawtoorigin(param_00)
{
	if(isdefined(self.target_getindexoftarget))
	{
		var_01 = self.var_205.angles[1] - scripts\common\utility::getyaw(param_00);
	}
	else
	{
		var_01 = self.angles[1] - scripts\common\utility::getyaw(var_01);
	}

	var_01 = angleclamp180(var_01);
	return var_01;
}

//Function Number: 32
getnodeyawtoenemy()
{
	var_00 = undefined;
	if(isdefined(self.isnodeoccupied))
	{
		var_00 = self.var_10C.origin;
	}
	else
	{
		if(isdefined(self.target_getindexoftarget))
		{
			var_01 = anglestoforward(self.var_205.angles);
		}
		else
		{
			var_01 = anglestoforward(self.angles);
		}

		var_01 = var_01 * 150;
		var_00 = self.origin + var_01;
	}

	if(isdefined(self.target_getindexoftarget))
	{
		var_02 = self.var_205.angles[1] - scripts\common\utility::getyaw(var_00);
	}
	else
	{
		var_02 = self.angles[1] - scripts\common\utility::getyaw(var_02);
	}

	var_02 = angleclamp180(var_02);
	return var_02;
}

//Function Number: 33
getyawtoenemy()
{
	var_00 = undefined;
	if(isdefined(self.isnodeoccupied))
	{
		var_00 = self.var_10C.origin;
	}
	else
	{
		var_01 = anglestoforward(self.angles);
		var_01 = var_01 * 150;
		var_00 = self.origin + var_01;
	}

	var_02 = self.angles[1] - scripts\common\utility::getyaw(var_00);
	var_02 = angleclamp180(var_02);
	return var_02;
}

//Function Number: 34
getyaw2d(param_00)
{
	var_01 = vectortoangles((param_00[0],param_00[1],0) - (self.origin[0],self.origin[1],0));
	return var_01[1];
}

//Function Number: 35
absyawtoenemy()
{
	var_00 = self.angles[1] - scripts\common\utility::getyaw(self.var_10C.origin);
	var_00 = angleclamp180(var_00);
	if(var_00 < 0)
	{
		var_00 = -1 * var_00;
	}

	return var_00;
}

//Function Number: 36
absyawtoenemy2d()
{
	var_00 = self.angles[1] - getyaw2d(self.var_10C.origin);
	var_00 = angleclamp180(var_00);
	if(var_00 < 0)
	{
		var_00 = -1 * var_00;
	}

	return var_00;
}

//Function Number: 37
absyawtoorigin(param_00)
{
	var_01 = self.angles[1] - scripts\common\utility::getyaw(param_00);
	var_01 = angleclamp180(var_01);
	if(var_01 < 0)
	{
		var_01 = -1 * var_01;
	}

	return var_01;
}

//Function Number: 38
absyawtoangles(param_00)
{
	var_01 = self.angles[1] - param_00;
	var_01 = angleclamp180(var_01);
	if(var_01 < 0)
	{
		var_01 = -1 * var_01;
	}

	return var_01;
}

//Function Number: 39
getyawfromorigin(param_00,param_01)
{
	var_02 = vectortoangles(param_00 - param_01);
	return var_02[1];
}

//Function Number: 40
getgrenademodel()
{
	return function_00EA(self.objective_team);
}

//Function Number: 41
getenemyeyepos()
{
	if(isdefined(self.isnodeoccupied))
	{
		self.var_1491.lastenemypos = self.isnodeoccupied getshootatpos();
		self.var_1491.lastenemytime = gettime();
		return self.var_1491.lastenemypos;
	}

	if(isdefined(self.var_1491.lastenemytime) && isdefined(self.var_1491.lastenemypos) && self.var_1491.lastenemytime + 3000 < gettime())
	{
		return self.var_1491.lastenemypos;
	}

	var_00 = self getshootatpos();
	var_00 = var_00 + (196 * self.setomnvarbit[0],196 * self.setomnvarbit[1],196 * self.setomnvarbit[2]);
	return var_00;
}

//Function Number: 42
gettruenodeangles(param_00)
{
	if(!isdefined(param_00))
	{
		return (0,0,0);
	}

	if(!isdefined(param_00.script_angles))
	{
		return param_00.angles;
	}

	var_01 = param_00.angles;
	var_02 = angleclamp180(var_01[0] + param_00.script_angles[0]);
	var_03 = var_01[1];
	var_04 = angleclamp180(var_01[2] + param_00.script_angles[2]);
	return (var_02,var_03,var_04);
}

//Function Number: 43
getyawtoorigin(param_00)
{
	if(isdefined(self.type) && scripts\common\utility::isnode3d(self))
	{
		var_01 = gettruenodeangles(self);
		var_02 = anglestoforward(var_01);
		var_03 = rotatepointaroundvector(var_02,param_00 - self.origin,var_01[2] * -1);
		var_03 = var_03 + self.origin;
		var_04 = scripts\common\utility::getyaw(var_03) - var_01[1];
		var_04 = angleclamp180(var_04);
		return var_04;
	}

	var_04 = scripts\common\utility::getyaw(var_04) - self.angles[1];
	var_04 = angleclamp180(var_04);
	return var_04;
}

//Function Number: 44
canseepointfromexposedatcorner(param_00,param_01)
{
	var_02 = param_01 getyawtoorigin(param_00);
	if(var_02 > 60 || var_02 < -60)
	{
		return 0;
	}

	if(scripts\common\utility::isnodecoverleft(param_01) && var_02 < -14)
	{
		return 0;
	}

	if(scripts\common\utility::isnodecoverright(param_01) && var_02 > 12)
	{
		return 0;
	}

	return 1;
}

//Function Number: 45
getnodeoffset(param_00)
{
	if(isdefined(param_00.offset))
	{
		return param_00.offset;
	}

	var_01 = (-26,0.4,36);
	var_02 = (-32,7,63);
	var_03 = (43.5,11,36);
	var_04 = (36,8.3,63);
	var_05 = (3.5,-12.5,45);
	var_06 = (-3.7,-22,63);
	var_07 = 0;
	var_08 = (0,0,0);
	var_09 = anglestoright(param_00.angles);
	var_0A = anglestoforward(param_00.angles);
	var_0B = anglestoup(param_00.angles);
	var_0C = param_00.type;
	switch(var_0C)
	{
		case "Cover Left":
			if(param_00 gethighestnodestance() == "crouch")
			{
				var_08 = calculatenodeoffset(var_09,var_0A,var_0B,var_01);
			}
			else
			{
				var_08 = calculatenodeoffset(var_09,var_0A,var_0B,var_02);
			}
			break;

		case "Cover Right":
			if(param_00 gethighestnodestance() == "crouch")
			{
				var_08 = calculatenodeoffset(var_09,var_0A,var_0B,var_03);
			}
			else
			{
				var_08 = calculatenodeoffset(var_09,var_0A,var_0B,var_04);
			}
			break;

		case "Cover Stand":
		case "Conceal Stand":
		case "Turret":
		case "Cover Stand 3D":
			var_08 = calculatenodeoffset(var_09,var_0A,var_0B,var_06);
			break;

		case "Conceal Crouch":
		case "Cover Crouch Window":
		case "Cover Crouch":
			var_08 = calculatenodeoffset(var_09,var_0A,var_0B,var_05);
			break;

		case "Cover 3D":
			var_08 = getcover3dnodeoffset(param_00);
			break;
	}

	param_00.offset = var_08;
	return param_00.offset;
}

//Function Number: 46
getcover3dnodeoffset(param_00,param_01)
{
	var_02 = (2,-10,35);
	var_03 = (-19,-10,32);
	var_04 = (16,-10,32);
	var_05 = anglestoright(param_00.angles);
	var_06 = anglestoforward(param_00.angles);
	var_07 = anglestoup(param_00.angles);
	var_08 = var_02;
	if(isdefined(param_01))
	{
		if(param_01 == "left")
		{
			var_08 = var_03;
		}
		else if(param_01 == "right")
		{
			var_08 = var_04;
		}
		else
		{
		}
	}

	return calculatenodeoffset(var_05,var_06,var_07,var_08);
}

//Function Number: 47
calculatenodeoffset(param_00,param_01,param_02,param_03)
{
	return param_00 * param_03[0] + param_01 * param_03[1] + param_02 * param_03[2];
}

//Function Number: 48
canseepointfromexposedatnode(param_00,param_01)
{
	if(scripts\common\utility::isnodecoverleft(param_01) || scripts\common\utility::isnodecoverright(param_01))
	{
		if(!canseepointfromexposedatcorner(param_00,param_01))
		{
			return 0;
		}
	}

	var_02 = getnodeoffset(param_01);
	var_03 = param_01.origin + var_02;
	if(!checkpitchvisibility(var_03,param_00,param_01))
	{
		return 0;
	}

	if(!sighttracepassed(var_03,param_00,0,undefined))
	{
		if(scripts\common\utility::isnodecovercrouch(param_01))
		{
			var_03 = (0,0,64) + param_01.origin;
			return sighttracepassed(var_03,param_00,0,undefined);
		}

		return 0;
	}

	return 1;
}

//Function Number: 49
persistentdebugline(param_00,param_01)
{
	self endon("death");
	level notify("newdebugline");
	level endon("newdebugline");
	wait(0.05);
}

//Function Number: 50
canseeenemyfromexposed()
{
	if(!isdefined(self.isnodeoccupied))
	{
		self.goodshootpos = undefined;
		return 0;
	}

	var_00 = getenemyeyepos();
	if(!isdefined(self.target_getindexoftarget))
	{
		var_01 = self getpersstat(self.isnodeoccupied);
	}
	else if(scripts\common\utility::actor_is3d() && scripts\common\utility::isnode3d(self.target_getindexoftarget))
	{
		var_01 = canseepointfromexposedatnode(var_01,self.target_getindexoftarget);
		if(!var_01)
		{
			var_00 = self.var_10C.origin + var_00 \ 2;
			var_01 = canseepointfromexposedatnode(var_00,self.target_getindexoftarget);
		}
	}
	else
	{
		var_01 = canseepointfromexposedatnode(var_01,self.target_getindexoftarget);
	}

	if(var_01)
	{
		self.goodshootpos = var_00;
		dontgiveuponsuppressionyet();
	}
	else
	{
	}

	return var_01;
}

//Function Number: 51
checkpitchvisibility(param_00,param_01,param_02)
{
	var_03 = self.var_368 - level.var_1A44;
	var_04 = self.isbot + level.var_1A44;
	var_05 = param_01 - param_00;
	if(scripts\common\utility::actor_is3d())
	{
		if(isdefined(param_02) && scripts\common\utility::isnode3d(param_02))
		{
			var_06 = param_02.angles;
		}
		else
		{
			var_06 = self.angles;
		}

		var_05 = rotatevectorinverted(var_05,var_06);
	}

	var_07 = angleclamp180(vectortoangles(var_05)[0]);
	if(var_07 < var_03)
	{
		return 0;
	}

	if(var_07 > var_04)
	{
		if(isdefined(param_02) && !scripts\common\utility::isnodecovercrouch(param_02))
		{
			return 0;
		}

		if(var_07 > level.covercrouchleanpitch + var_04)
		{
			return 0;
		}
	}

	return 1;
}

//Function Number: 52
dontgiveuponsuppressionyet()
{
	self.var_1491.shouldresetgiveuponsuppressiontimer = 1;
}

//Function Number: 53
cansuppressenemy()
{
	if(!hassuppressableenemy())
	{
		self.goodshootpos = undefined;
		return 0;
	}

	if(!isplayer(self.isnodeoccupied))
	{
		return aisuppressai();
	}

	var_00 = self getmuzzlepos();
	if(!checkpitchvisibility(var_00,self.setignoremegroup))
	{
		return 0;
	}

	return findgoodsuppressspot(var_00);
}

//Function Number: 54
updategiveuponsuppressiontimer()
{
	if(!isdefined(self.var_1491.shouldresetgiveuponsuppressiontimer))
	{
		self.var_1491.shouldresetgiveuponsuppressiontimer = 1;
	}

	if(self.var_1491.shouldresetgiveuponsuppressiontimer)
	{
		self.var_1491.giveuponsuppressiontime = gettime() + randomintrange(15000,30000);
		self.var_1491.shouldresetgiveuponsuppressiontimer = 0;
	}
}

//Function Number: 55
hassuppressableenemy()
{
	if(!isdefined(self.isnodeoccupied))
	{
		return 0;
	}

	if(!isdefined(self.setignoremegroup))
	{
		return 0;
	}

	updategiveuponsuppressiontimer();
	if(gettime() > self.var_1491.giveuponsuppressiontime)
	{
		return 0;
	}

	if(!isdefined(self.goodshootpos) && !needrecalculatesuppressspot())
	{
		return 0;
	}

	return 1;
}

//Function Number: 56
aisuppressai()
{
	if(!self getequipmenttableinfo())
	{
		return 0;
	}

	var_00 = undefined;
	if(isdefined(self.var_10C.target_getindexoftarget))
	{
		var_01 = getnodeoffset(self.var_10C.target_getindexoftarget);
		var_00 = self.var_10C.var_205.origin + var_01;
	}
	else
	{
		var_00 = self.isnodeoccupied getshootatpos();
	}

	if(!self canshoot(var_00))
	{
		return 0;
	}

	if(self.script == "combat")
	{
		if(!sighttracepassed(self geteye(),self getmuzzlepos(),0,undefined))
		{
			return 0;
		}
	}

	self.goodshootpos = var_00;
	return 1;
}

//Function Number: 57
canseeandshootpoint(param_00)
{
	if(!sighttracepassed(self getshootatpos(),param_00,0,undefined))
	{
		return 0;
	}

	if(self.var_1491.weaponpos["right"] == "none")
	{
		return 0;
	}

	var_01 = self getmuzzlepos();
	return sighttracepassed(var_01,param_00,0,undefined);
}

//Function Number: 58
needrecalculatesuppressspot()
{
	if(isdefined(self.goodshootpos) && !canseeandshootpoint(self.goodshootpos))
	{
		return 1;
	}

	return !isdefined(self.lastenemysightposold) || self.lastenemysightposold != self.setignoremegroup || distancesquared(self.lastenemysightposselforigin,self.origin) > 1024;
}

//Function Number: 59
findgoodsuppressspot(param_00)
{
	if(isdefined(self.isnodeoccupied) && distancesquared(self.origin,self.var_10C.origin) > squared(self.var_10C.setturretnode))
	{
		self.goodshootpos = undefined;
		return 0;
	}

	if(!sighttracepassed(self getshootatpos(),param_00,0,undefined))
	{
		self.goodshootpos = undefined;
		return 0;
	}

	if(needrecalculatesuppressspot())
	{
		self.lastenemysightposselforigin = self.origin;
		self.lastenemysightposold = self.setignoremegroup;
		var_01 = getenemyeyepos();
		var_02 = bullettrace(self.setignoremegroup,var_01,0,undefined);
		var_03 = var_02["position"];
		var_04 = self.setignoremegroup - var_03;
		var_05 = vectornormalize(self.setignoremegroup - param_00);
		var_04 = var_04 - var_05 * vectordot(var_04,var_05);
		var_06 = 20;
		var_07 = int(length(var_04) \ var_06 + 0.5);
		if(var_07 < 1)
		{
			var_07 = 1;
		}

		if(var_07 > 4)
		{
			var_07 = 4;
		}

		var_08 = self.setignoremegroup - var_03;
		var_08 = (var_08[0] \ var_07,var_08[1] \ var_07,var_08[2] \ var_07);
		var_07++;
		var_09 = var_03;
		self.goodshootpos = undefined;
		var_0A = 0;
		var_0B = 2;
		for(var_0C = 0;var_0C < var_07 + var_0B;var_0C++)
		{
			var_0D = sighttracepassed(param_00,var_09,0,undefined);
			var_0E = var_09;
			if(var_0C == var_07 - 1)
			{
				var_08 = var_08 - var_05 * vectordot(var_08,var_05);
			}

			var_09 = var_09 + var_08;
			if(var_0D)
			{
				var_0A++;
				self.goodshootpos = var_0E;
				if(var_0C > 0 && var_0A < var_0B && var_0C < var_07 + var_0B - 1)
				{
					continue;
				}

				return 1;
			}
			else
			{
				var_0A = 0;
			}
		}
	}

	return isdefined(self.goodshootpos);
}

//Function Number: 60
cansuppressenemyfromexposed()
{
	if(!hassuppressableenemy())
	{
		self.goodshootpos = undefined;
		return 0;
	}

	if(!isplayer(self.isnodeoccupied))
	{
		return aisuppressai();
	}

	if(isdefined(self.target_getindexoftarget))
	{
		if(scripts\common\utility::isnodecoverleft(self.target_getindexoftarget) || scripts\common\utility::isnodecoverright(self.target_getindexoftarget))
		{
			if(!canseepointfromexposedatcorner(getenemyeyepos(),self.target_getindexoftarget))
			{
				return 0;
			}
		}

		var_00 = getnodeoffset(self.target_getindexoftarget);
		var_01 = self.var_205.origin + var_00;
	}
	else
	{
		var_01 = self getmuzzlepos();
	}

	if(!checkpitchvisibility(var_01,self.setignoremegroup))
	{
		return 0;
	}

	return findgoodsuppressspot(var_01);
}

//Function Number: 61
canseeenemy(param_00)
{
	if(!isdefined(self.isnodeoccupied))
	{
		return 0;
	}

	if((isdefined(param_00) && self getpersstat(self.isnodeoccupied,param_00)) || self getpersstat(self.isnodeoccupied))
	{
		if(!checkpitchvisibility(self geteye(),self.isnodeoccupied getshootatpos()))
		{
			return 0;
		}

		self.goodshootpos = getenemyeyepos();
		dontgiveuponsuppressionyet();
		return 1;
	}

	return 0;
}

//Function Number: 62
recentlysawenemy()
{
	return isdefined(self.isnodeoccupied) && self seerecently(self.isnodeoccupied,5);
}

//Function Number: 63
issuppressedwrapper()
{
	if(isdefined(self.forcesuppression))
	{
		return self.forcesuppression;
	}

	if(self.testbrushedgesforgrapple <= self.suppressionthreshold)
	{
		return 0;
	}

	return self issuppressed();
}

//Function Number: 64
enemyishiding()
{
	if(!isdefined(self.isnodeoccupied))
	{
		return 0;
	}

	if(self.isnodeoccupied scripts\common\utility::isflashed())
	{
		return 1;
	}

	if(isplayer(self.isnodeoccupied))
	{
		if(isdefined(self.var_10C.health) && self.var_10C.health < self.var_10C.maxhealth)
		{
			return 1;
		}
	}
	else if(isai(self.isnodeoccupied) && self.isnodeoccupied issuppressedwrapper())
	{
		return 1;
	}

	if(isdefined(self.var_10C.isreloading) && self.var_10C.isreloading)
	{
		return 1;
	}

	return 0;
}

//Function Number: 65
shouldshootenemyent()
{
	if(!canseeenemy())
	{
		return 0;
	}

	if(!isdefined(self.covernode) && !self canshootenemy())
	{
		return 0;
	}

	return 1;
}

//Function Number: 66
sortandcullanimstructarray(param_00)
{
	var_01 = [];
	foreach(var_03 in param_00)
	{
		if(var_03.weight <= 0)
		{
			continue;
		}

		for(var_04 = 0;var_04 < var_01.size;var_04++)
		{
			if(var_03.weight < var_01[var_04].weight)
			{
				for(var_05 = var_01.size;var_05 > var_04;var_05--)
				{
					var_01[var_05] = var_01[var_05 - 1];
				}

				break;
			}
		}

		var_01[var_04] = var_03;
	}

	return var_01;
}