/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\killstreaks\_harrier.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 47
 * Decompile Time: 2219 ms
 * Timestamp: 10/27/2023 12:28:36 AM
*******************************************************************/

//Function Number: 1
func_2A6A(param_00,param_01,param_02)
{
	var_03 = getent("airstrikeheight","targetname");
	if(isdefined(var_03))
	{
		var_04 = var_03.origin[2];
	}
	else if(isdefined(level.airstrikeheightscale))
	{
		var_04 = 850 * level.airstrikeheightscale;
	}
	else
	{
		var_04 = 850;
	}

	param_02 = param_02 * (1,1,0);
	var_05 = param_02 + (0,0,var_04);
	var_06 = func_10845(param_00,self,param_01,var_05);
	var_06.var_C96C = var_05;
	return var_06;
}

//Function Number: 2
getcorrectheight(param_00,param_01,param_02)
{
	var_03 = 1200;
	var_04 = tracegroundpoint(param_00,param_01);
	var_05 = var_04 + var_03;
	if(isdefined(level.airstrikeheightscale) && var_05 < 850 * level.airstrikeheightscale)
	{
		var_05 = 950 * level.airstrikeheightscale;
	}

	var_05 = var_05 + randomint(param_02);
	return var_05;
}

//Function Number: 3
func_10845(param_00,param_01,param_02,param_03)
{
	var_04 = vectortoangles(param_03 - param_02);
	var_05 = spawnhelicopter(param_01,param_02,var_04,"harrier_mp","vehicle_av8b_harrier_jet_mp");
	if(!isdefined(var_05))
	{
		return;
	}

	var_05 func_184E();
	var_05 thread func_E10A();
	var_05 thread func_8992();
	var_05.getclosestpointonnavmesh3d = 250;
	var_05.var_1545 = 175;
	var_05.health = 2500;
	var_05.maxhealth = var_05.health;
	var_05.team = param_01.team;
	var_05.triggerportableradarping = param_01;
	var_05 setcandamage(1);
	var_05.triggerportableradarping = param_01;
	var_05 thread func_8B5B();
	var_05 setmaxpitchroll(0,90);
	var_05 vehicle_setspeed(var_05.getclosestpointonnavmesh3d,var_05.var_1545);
	var_05 thread func_D494();
	var_05 give_fwoosh_perk(3);
	var_05.missiles = 6;
	var_05.pers["team"] = var_05.team;
	var_05 sethoverparams(50,100,50);
	var_05 setturningability(0.05);
	var_05 givelastonteamwarning(45,25,25,0.5);
	var_05.defendloc = param_03;
	var_05.lifeid = param_00;
	var_05.allowmonitoreddamage = 1;
	var_05.var_9E20 = 1;
	var_05.damagecallback = ::func_3758;
	level.var_8B5F = scripts\engine\utility::array_removeundefined(level.var_8B5F);
	level.var_8B5F[level.var_8B5F.size] = var_05;
	level.harrier_incoming = undefined;
	return var_05;
}

//Function Number: 4
func_5088(param_00)
{
	param_00 endon("death");
	param_00 thread func_8B61();
	param_00 setvehgoalpos(param_00.var_C96C,1);
	param_00 thread closetogoalcheck(param_00.var_C96C);
	param_00 waittill("goal");
	param_00 func_11075();
	param_00 func_658C();
	param_00 thread monitorowner();
}

//Function Number: 5
closetogoalcheck(param_00)
{
	self endon("goal");
	self endon("death");
	for(;;)
	{
		if(distance2d(self.origin,param_00) < 768)
		{
			self setmaxpitchroll(45,25);
			break;
		}

		wait(0.05);
	}
}

//Function Number: 6
func_658C()
{
	self notify("engageGround");
	self endon("engageGround");
	self endon("death");
	thread func_8B5D();
	thread func_DCB0();
	var_00 = self.defendloc;
	self vehicle_setspeed(15,5);
	self setvehgoalpos(var_00,1);
	self waittill("goal");
}

//Function Number: 7
func_8B5E()
{
	self endon("death");
	self setmaxpitchroll(0,0);
	self notify("leaving");
	func_2FC0(1);
	self notify("stopRand");
	for(;;)
	{
		self vehicle_setspeed(35,25);
		var_00 = self.origin + anglestoforward((0,randomint(360),0)) * 500;
		var_00 = var_00 + (0,0,900);
		var_01 = bullettrace(self.origin,self.origin + (0,0,900),0,self);
		if(var_01["surfacetype"] == "none")
		{
			break;
		}

		wait(0.1);
	}

	self setvehgoalpos(var_00,1);
	thread func_10DA1();
	self waittill("goal");
	self playsoundonmovingent("harrier_fly_away");
	var_02 = getpathend();
	self vehicle_setspeed(250,75);
	self setvehgoalpos(var_02,1);
	self waittill("goal");
	level.var_8B5F[level.var_8B5F.size - 1] = undefined;
	self notify("harrier_gone");
	thread func_8B5A();
}

//Function Number: 8
func_8B5A()
{
	self delete();
}

//Function Number: 9
func_8B61()
{
	self endon("death");
	scripts\mp\_hostmigration::waitlongdurationwithhostmigrationpause(90);
	func_8B5E();
}

//Function Number: 10
func_DCB0()
{
	self notify("randomHarrierMovement");
	self endon("randomHarrierMovement");
	self endon("stopRand");
	self endon("death");
	self endon("acquiringTarget");
	self endon("leaving");
	var_00 = self.defendloc;
	for(;;)
	{
		var_01 = getnewpoint(self.origin);
		self setvehgoalpos(var_01,1);
		self waittill("goal");
		wait(randomintrange(1,2));
		self notify("randMove");
	}
}

//Function Number: 11
getnewpoint(param_00,param_01)
{
	self endon("stopRand");
	self endon("death");
	self endon("acquiringTarget");
	self endon("leaving");
	if(!isdefined(param_01))
	{
		var_02 = [];
		foreach(var_04 in level.players)
		{
			if(var_04 == self)
			{
				continue;
			}

			if(!level.teambased || var_04.team != self.team)
			{
				var_02[var_02.size] = var_04.origin;
			}
		}

		if(var_02.size > 0)
		{
			var_06 = averagepoint(var_02);
			var_07 = var_06[0];
			var_08 = var_06[1];
		}
		else
		{
			var_09 = level.mapcenter;
			var_0A = level.mapsize / 4;
			var_07 = randomfloatrange(var_09[0] - var_0A,var_09[0] + var_0A);
			var_08 = randomfloatrange(var_09[1] - var_0A,var_09[1] + var_0A);
		}

		var_0B = getcorrectheight(var_07,var_08,20);
	}
	else if(scripts\engine\utility::cointoss())
	{
		var_0C = self.origin - self.besttarget.origin;
		var_07 = var_0C[0];
		var_08 = var_0C[1] * -1;
		var_0B = getcorrectheight(var_07,var_08,20);
		var_0D = (var_08,var_07,var_0B);
		if(distance2d(self.origin,var_0D) > 1200)
		{
			var_08 = var_08 * 0.5;
			var_07 = var_07 * 0.5;
			var_0D = (var_08,var_07,var_0B);
		}
	}
	else
	{
		if(distance2d(self.origin,self.besttarget.origin) < 200)
		{
			return;
		}

		var_0E = self.angles[1];
		var_0F = (0,var_0E,0);
		var_10 = self.origin + anglestoforward(var_0F) * randomintrange(200,400);
		var_0B = getcorrectheight(var_10[0],var_10[1],20);
		var_07 = var_10[0];
		var_08 = var_10[1];
	}

	for(;;)
	{
		var_11 = tracenewpoint(var_07,var_08,var_0B);
		if(var_11 != 0)
		{
			return var_11;
		}

		var_07 = randomfloatrange(param_00[0] - 1200,param_00[0] + 1200);
		var_08 = randomfloatrange(param_00[1] - 1200,param_00[1] + 1200);
		var_0B = getcorrectheight(var_07,var_08,20);
	}
}

//Function Number: 12
tracenewpoint(param_00,param_01,param_02)
{
	self endon("stopRand");
	self endon("death");
	self endon("acquiringTarget");
	self endon("leaving");
	self endon("randMove");
	for(var_03 = 1;var_03 <= 10;var_03++)
	{
		switch(var_03)
		{
			case 1:
				var_04 = bullettrace(self.origin,(param_00,param_01,param_02),0,self);
				break;

			case 2:
				var_04 = bullettrace(self gettagorigin("tag_left_wingtip"),(param_00,param_01,param_02),0,self);
				break;

			case 3:
				var_04 = bullettrace(self gettagorigin("tag_right_wingtip"),(param_00,param_01,param_02),0,self);
				break;

			case 4:
				var_04 = bullettrace(self gettagorigin("tag_engine_left2"),(param_00,param_01,param_02),0,self);
				break;

			case 5:
				var_04 = bullettrace(self gettagorigin("tag_engine_right2"),(param_00,param_01,param_02),0,self);
				break;

			case 6:
				var_04 = bullettrace(self gettagorigin("tag_right_alamo_missile"),(param_00,param_01,param_02),0,self);
				break;

			case 7:
				var_04 = bullettrace(self gettagorigin("tag_left_alamo_missile"),(param_00,param_01,param_02),0,self);
				break;

			case 8:
				var_04 = bullettrace(self gettagorigin("tag_right_archer_missile"),(param_00,param_01,param_02),0,self);
				break;

			case 9:
				var_04 = bullettrace(self gettagorigin("tag_left_archer_missile"),(param_00,param_01,param_02),0,self);
				break;

			case 10:
				var_04 = bullettrace(self gettagorigin("tag_light_tail"),(param_00,param_01,param_02),0,self);
				break;

			default:
				var_04 = bullettrace(self.origin,(param_00,param_01,param_02),0,self);
				break;
		}

		if(var_04["surfacetype"] != "none")
		{
			return 0;
		}

		wait(0.05);
	}

	var_05 = (param_00,param_01,param_02);
	return var_05;
}

//Function Number: 13
tracegroundpoint(param_00,param_01)
{
	self endon("death");
	self endon("acquiringTarget");
	self endon("leaving");
	var_02 = -9999999;
	var_03 = 9999999;
	var_04 = -9999999;
	var_05 = self.origin[2];
	var_06 = undefined;
	var_07 = undefined;
	for(var_08 = 1;var_08 <= 5;var_08++)
	{
		switch(var_08)
		{
			case 1:
				var_09 = bullettrace((param_00,param_01,var_05),(param_00,param_01,var_04),0,self);
				break;

			case 2:
				var_09 = bullettrace((param_00 + 20,param_01 + 20,var_05),(param_00 + 20,param_01 + 20,var_04),0,self);
				break;

			case 3:
				var_09 = bullettrace((param_00 - 20,param_01 - 20,var_05),(param_00 - 20,param_01 - 20,var_04),0,self);
				break;

			case 4:
				var_09 = bullettrace((param_00 + 20,param_01 - 20,var_05),(param_00 + 20,param_01 - 20,var_04),0,self);
				break;

			case 5:
				var_09 = bullettrace((param_00 - 20,param_01 + 20,var_05),(param_00 - 20,param_01 + 20,var_04),0,self);
				break;

			default:
				var_09 = bullettrace(self.origin,(param_00,param_01,var_04),0,self);
				break;
		}

		if(var_09["position"][2] > var_02)
		{
			var_02 = var_09["position"][2];
			var_06 = var_09;
		}
		else if(var_09["position"][2] < var_03)
		{
			var_03 = var_09["position"][2];
			var_07 = var_09;
		}

		wait(0.05);
	}

	return var_02;
}

//Function Number: 14
func_D494()
{
	self endon("death");
	wait(0.2);
	playfxontag(level.fx_airstrike_contrail,self,"tag_right_wingtip");
	playfxontag(level.fx_airstrike_contrail,self,"tag_left_wingtip");
	wait(0.2);
	playfxontag(level.harrier_afterburnerfx,self,"tag_engine_right");
	playfxontag(level.harrier_afterburnerfx,self,"tag_engine_left");
	wait(0.2);
	playfxontag(level.harrier_afterburnerfx,self,"tag_engine_right2");
	playfxontag(level.harrier_afterburnerfx,self,"tag_engine_left2");
	wait(0.2);
	playfxontag(level.chopper_fx["light"]["left"],self,"tag_light_L_wing");
	wait(0.2);
	playfxontag(level.chopper_fx["light"]["right"],self,"tag_light_R_wing");
	wait(0.2);
	playfxontag(level.chopper_fx["light"]["belly"],self,"tag_light_belly");
	wait(0.2);
	playfxontag(level.chopper_fx["light"]["tail"],self,"tag_light_tail");
}

//Function Number: 15
func_11075()
{
	stopfxontag(level.fx_airstrike_contrail,self,"tag_right_wingtip");
	stopfxontag(level.fx_airstrike_contrail,self,"tag_left_wingtip");
}

//Function Number: 16
func_10DA1()
{
	wait(3);
	if(!isdefined(self))
	{
		return;
	}

	playfxontag(level.fx_airstrike_contrail,self,"tag_right_wingtip");
	playfxontag(level.fx_airstrike_contrail,self,"tag_left_wingtip");
}

//Function Number: 17
getpathstart(param_00)
{
	var_01 = 100;
	var_02 = 15000;
	var_03 = 850;
	var_04 = randomfloat(360);
	var_05 = (0,var_04,0);
	var_06 = param_00 + anglestoforward(var_05) * -1 * var_02;
	var_06 = var_06 + (randomfloat(2) - 1 * var_01,randomfloat(2) - 1 * var_01,0);
	return var_06;
}

//Function Number: 18
getpathend()
{
	var_00 = 150;
	var_01 = 15000;
	var_02 = 850;
	var_03 = self.angles[1];
	var_04 = (0,var_03,0);
	var_05 = self.origin + anglestoforward(var_04) * var_01;
	return var_05;
}

//Function Number: 19
fireontarget(param_00,param_01)
{
	self endon("leaving");
	self endon("stopfiring");
	self endon("explode");
	self endon("death");
	self.besttarget endon("death");
	self.besttarget endon("disconnect");
	var_02 = gettime();
	var_03 = gettime();
	var_04 = 0;
	self giveflagassistedcapturepoints("harrier_20mm_mp");
	if(!isdefined(param_01))
	{
		param_01 = 50;
	}

	for(;;)
	{
		if(isreadytofire(param_00))
		{
			break;
		}
		else
		{
			wait(0.25);
		}
	}

	self setturrettargetent(self.besttarget,(0,0,50));
	var_05 = 25;
	for(;;)
	{
		if(var_05 == 25)
		{
			self playloopsound("weap_hind_20mm_fire_npc");
		}

		var_05--;
		self fireweapon("tag_flash",self.besttarget,(0,0,0),0.05);
		wait(0.1);
		if(var_05 <= 0)
		{
			self stoploopsound();
			wait(1);
			var_05 = 25;
		}
	}
}

//Function Number: 20
isreadytofire(param_00)
{
	self endon("death");
	self endon("leaving");
	if(!isdefined(param_00))
	{
		param_00 = 10;
	}

	var_01 = anglestoforward(self.angles);
	var_02 = self.besttarget.origin - self.origin;
	var_01 = var_01 * (1,1,0);
	var_02 = var_02 * (1,1,0);
	var_02 = vectornormalize(var_02);
	var_01 = vectornormalize(var_01);
	var_03 = vectordot(var_02,var_01);
	var_04 = cos(param_00);
	if(var_03 >= var_04)
	{
		return 1;
	}

	return 0;
}

//Function Number: 21
func_1570(param_00)
{
	self endon("death");
	self endon("leaving");
	if(param_00.size == 1)
	{
		self.besttarget = param_00[0];
	}
	else
	{
		self.besttarget = getbesttarget(param_00);
	}

	func_2737(0);
	self notify("acquiringTarget");
	self setturrettargetent(self.besttarget);
	self setlookatent(self.besttarget);
	var_01 = getnewpoint(self.origin,1);
	if(!isdefined(var_01))
	{
		var_01 = self.origin;
	}

	self setvehgoalpos(var_01,1);
	thread func_13B74();
	thread func_13B77();
	self giveflagassistedcapturepoints("harrier_20mm_mp");
	thread fireontarget();
}

//Function Number: 22
func_2737(param_00)
{
	self setvehgoalpos(self.defendloc,1);
	if(isdefined(param_00) && param_00)
	{
		self waittill("goal");
	}
}

//Function Number: 23
func_13DCF(param_00)
{
	var_01 = bullettrace(self.origin,param_00,1,self);
	if(var_01["position"] == param_00)
	{
		return 0;
	}

	return 1;
}

//Function Number: 24
func_13B74()
{
	self notify("watchTargetDeath");
	self endon("watchTargetDeath");
	self endon("newTarget");
	self endon("death");
	self endon("leaving");
	self.besttarget waittill("death");
	thread func_2FC0();
}

//Function Number: 25
func_13B77(param_00)
{
	self endon("death");
	self.besttarget endon("death");
	self.besttarget endon("disconnect");
	self endon("leaving");
	self endon("newTarget");
	var_01 = undefined;
	if(!isdefined(param_00))
	{
		param_00 = 1000;
	}

	for(;;)
	{
		if(!istarget(self.besttarget))
		{
			thread func_2FC0();
			return;
		}

		if(!isdefined(self.besttarget))
		{
			thread func_2FC0();
			return;
		}

		if(self.besttarget giveperks(self.origin,self) < 1)
		{
			if(!isdefined(var_01))
			{
				var_01 = gettime();
			}

			if(gettime() - var_01 > param_00)
			{
				thread func_2FC0();
				return;
			}
		}
		else
		{
			var_01 = undefined;
		}

		wait(0.25);
	}
}

//Function Number: 26
func_2FC0(param_00)
{
	self endon("death");
	self getplayerkillstreakcombatmode();
	self stoploopsound();
	self notify("stopfiring");
	if(isdefined(param_00) && param_00)
	{
		return;
	}

	thread func_DCB0();
	self notify("newTarget");
	thread func_8B5D();
}

//Function Number: 27
func_8B5D()
{
	self notify("harrierGetTargets");
	self endon("harrierGetTargets");
	self endon("death");
	self endon("leaving");
	var_00 = [];
	for(;;)
	{
		var_00 = [];
		var_01 = level.players;
		if(isdefined(level.chopper) && level.chopper.team != self.team && isalive(level.chopper))
		{
			if(!isdefined(level.chopper.var_C084) || isdefined(level.chopper.var_C084) && !level.chopper.var_C084)
			{
				thread func_6591(level.chopper);
				return;
			}
			else
			{
				func_2737(1);
			}
		}

		if(isdefined(level.littlebirds))
		{
			foreach(var_03 in level.littlebirds)
			{
				if(isdefined(var_03) && var_03.team != self.team && isdefined(var_03.helipilottype) && var_03.helipilottype == "heli_pilot")
				{
					thread func_6591(var_03);
					return;
				}
			}
		}

		for(var_05 = 0;var_05 < var_01.size;var_05++)
		{
			var_06 = var_01[var_05];
			if(istarget(var_06))
			{
				if(isdefined(var_01[var_05]))
				{
					var_00[var_00.size] = var_01[var_05];
				}
			}
			else
			{
				continue;
			}

			wait(0.05);
		}

		if(var_00.size > 0)
		{
			func_1570(var_00);
			return;
		}

		wait(1);
	}
}

//Function Number: 28
istarget(param_00)
{
	self endon("death");
	if(!isalive(param_00) || param_00.sessionstate != "playing")
	{
		return 0;
	}

	if(isdefined(self.triggerportableradarping) && param_00 == self.triggerportableradarping)
	{
		return 0;
	}

	if(distance(param_00.origin,self.origin) > 8192)
	{
		return 0;
	}

	if(distance2d(param_00.origin,self.origin) < 150)
	{
		return 0;
	}

	if(!isdefined(param_00.pers["team"]))
	{
		return 0;
	}

	if(level.teambased && param_00.pers["team"] == self.team)
	{
		return 0;
	}

	if(param_00.pers["team"] == "spectator")
	{
		return 0;
	}

	if(isdefined(param_00.spawntime) && gettime() - param_00.spawntime / 1000 <= 5)
	{
		return 0;
	}

	if(param_00 scripts\mp\_utility::_hasperk("specialty_blindeye"))
	{
		return 0;
	}

	var_01 = self.origin + (0,0,-160);
	var_02 = anglestoforward(self.angles);
	var_03 = var_01 + 144 * var_02;
	var_04 = param_00 giveperks(self.origin,self);
	if(var_04 < 1)
	{
		return 0;
	}

	return 1;
}

//Function Number: 29
getbesttarget(param_00)
{
	self endon("death");
	var_01 = self gettagorigin("tag_flash");
	var_02 = self.origin;
	var_03 = anglestoforward(self.angles);
	var_04 = undefined;
	var_05 = undefined;
	var_06 = 0;
	foreach(var_08 in param_00)
	{
		var_09 = abs(vectortoangles(var_08.origin - self.origin)[1]);
		var_0A = abs(self gettagangles("tag_flash")[1]);
		var_09 = abs(var_09 - var_0A);
		var_0B = var_08 getweaponslistitems();
		foreach(var_0D in var_0B)
		{
			if(issubstr(var_0D,"at4") || issubstr(var_0D,"stinger") || issubstr(var_0D,"jav"))
			{
				var_09 = var_09 - 40;
			}
		}

		if(distance(self.origin,var_08.origin) > 2000)
		{
			var_09 = var_09 + 40;
		}

		if(!isdefined(var_04))
		{
			var_04 = var_09;
			var_05 = var_08;
			continue;
		}

		if(var_04 > var_09)
		{
			var_04 = var_09;
			var_05 = var_08;
		}
	}

	return var_05;
}

//Function Number: 30
firemissile(param_00)
{
	self endon("death");
	self endon("leaving");
	if(self.missiles <= 0)
	{
		return;
	}

	var_01 = func_3E13(param_00,256);
	if(!isdefined(param_00))
	{
		return;
	}

	if(distance2d(self.origin,param_00.origin) < 512)
	{
		return;
	}

	if(isdefined(var_01) && var_01)
	{
		return;
	}

	self.var_B898--;
	self giveflagassistedcapturepoints("aamissile_projectile_mp");
	if(isdefined(param_00.var_1155F))
	{
		var_02 = self fireweapon("tag_flash",param_00.var_1155F,(0,0,-250));
	}
	else
	{
		var_02 = self fireweapon("tag_flash",var_01,(0,0,-250));
	}

	var_02 missile_setflightmodedirect();
	var_02 missile_settargetent(param_00);
}

//Function Number: 31
func_3E13(param_00,param_01)
{
	self endon("death");
	self endon("leaving");
	var_02 = [];
	var_03 = level.players;
	var_04 = param_00.origin;
	for(var_05 = 0;var_05 < var_03.size;var_05++)
	{
		var_06 = var_03[var_05];
		if(var_06.team != self.team)
		{
			continue;
		}

		var_07 = var_06.origin;
		if(distance2d(var_07,var_04) < 512)
		{
			return 1;
		}
	}

	return 0;
}

//Function Number: 32
func_8992()
{
	self waittill("damage",var_00,var_01,var_02,var_03,var_04,var_05,var_06,var_07,var_08,var_09);
	if(var_09 == "aamissile_projectile_mp" && var_04 == "MOD_EXPLOSIVE" && var_00 >= self.health)
	{
		func_3758(var_01,var_01,9001,0,var_04,var_09,var_03,var_02,var_03,0,0,var_07);
	}
}

//Function Number: 33
func_3758(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B)
{
	if((param_01 == self || isdefined(param_01.pers) && param_01.pers["team"] == self.team && !level.friendlyfire && level.teambased) && param_01 != self.triggerportableradarping)
	{
		return;
	}

	if(self.health <= 0)
	{
		return;
	}

	param_02 = scripts\mp\_damage::handleapdamage(param_05,param_04,param_02);
	switch(param_05)
	{
		case "iw6_rocketmutli_mp":
		case "iw6_rocketplyr_mp":
		case "remotemissile_projectile_mp":
		case "odin_projectile_large_rod_mp":
		case "javelin_mp":
		case "stinger_mp":
		case "ac130_40mm_mp":
		case "ac130_105mm_mp":
			self.largeprojectiledamage = 1;
			param_02 = self.maxhealth + 1;
			break;

		case "at4_mp":
		case "rpg_mp":
			self.largeprojectiledamage = 1;
			param_02 = self.maxhealth - 900;
			break;

		case "odin_projectile_small_rod_mp":
		case "remote_tank_projectile_mp":
			param_02 = int(self.maxhealth * 0.34);
			self.largeprojectiledamage = 1;
			break;

		case "iw6_panzerfaust3_mp":
		case "switch_blade_child_mp":
		case "drone_hive_projectile_mp":
			param_02 = int(self.maxhealth * 0.25);
			self.largeprojectiledamage = 1;
			break;

		default:
			if(param_05 != "none")
			{
				param_02 = int(param_02 / 2);
			}
	
			self.largeprojectiledamage = 0;
			break;
	}

	scripts\mp\killstreaks\_killstreaks::killstreakhit(param_01,param_05,self);
	param_01 scripts\mp\_damagefeedback::updatedamagefeedback("");
	if(isplayer(param_01) && param_01 scripts\mp\_utility::_hasperk("specialty_armorpiercing"))
	{
		var_0C = int(param_02 * level.armorpiercingmod);
		param_02 = param_02 + var_0C;
	}

	if(self.health <= param_02)
	{
		if(isplayer(param_01) && !isdefined(self.triggerportableradarping) || param_01 != self.triggerportableradarping)
		{
			thread scripts\mp\_utility::teamplayercardsplash("callout_destroyed_harrier",param_01);
			param_01 thread scripts\mp\_utility::giveunifiedpoints("kill",param_05);
			param_01 notify("destroyed_killstreak");
		}

		if(param_05 == "heli_pilot_turret_mp")
		{
			param_01 scripts\mp\_missions::processchallenge("ch_enemy_down");
		}

		scripts\mp\_missions::func_3DE3(param_01,self,param_05);
		self notify("death");
	}

	if(self.health - param_02 <= 900 && !isdefined(self.var_1037E) || !self.var_1037E)
	{
		thread playdamageefx();
		self.var_1037E = 1;
	}

	self vehicle_finishdamage(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B);
}

//Function Number: 34
playdamageefx()
{
	self endon("death");
	stopfxontag(level.harrier_afterburnerfx,self,"tag_engine_left");
	playfxontag(level.harrier_smoke,self,"tag_engine_left");
	stopfxontag(level.harrier_afterburnerfx,self,"tag_engine_right");
	playfxontag(level.harrier_smoke,self,"tag_engine_right");
	wait(0.15);
	stopfxontag(level.harrier_afterburnerfx,self,"tag_engine_left2");
	playfxontag(level.harrier_smoke,self,"tag_engine_left2");
	stopfxontag(level.harrier_afterburnerfx,self,"tag_engine_right2");
	playfxontag(level.harrier_smoke,self,"tag_engine_right2");
	playfxontag(level.chopper_fx["damage"]["heavy_smoke"],self,"tag_engine_left");
}

//Function Number: 35
func_8B5B()
{
	self endon("harrier_gone");
	self waittill("death");
	if(!isdefined(self))
	{
		return;
	}

	if(!isdefined(self.largeprojectiledamage))
	{
		self vehicle_setspeed(25,5);
		thread func_8B60(randomintrange(180,220));
		wait(randomfloatrange(0.5,1.5));
	}

	func_8B5C();
}

//Function Number: 36
func_8B5C()
{
	self playsound("harrier_jet_crash");
	level.var_8B5F[level.var_8B5F.size - 1] = undefined;
	var_00 = self gettagangles("tag_deathfx");
	playfx(level.harrier_deathfx,self gettagorigin("tag_deathfx"),anglestoforward(var_00),anglestoup(var_00));
	self notify("explode");
	wait(0.05);
	thread func_8B5A();
}

//Function Number: 37
func_8B60(param_00)
{
	self endon("explode");
	playfxontag(level.chopper_fx["explode"]["medium"],self,"tag_origin");
	self givelastonteamwarning(param_00,param_00,param_00);
	while(isdefined(self))
	{
		self settargetyaw(self.angles[1] + param_00 * 0.9);
		wait(1);
	}
}

//Function Number: 38
func_6591(param_00)
{
	param_00 endon("death");
	param_00 endon("leaving");
	param_00 endon("crashing");
	self endon("death");
	func_1574(param_00);
	thread func_6D7C();
}

//Function Number: 39
func_6D7C()
{
	self endon("leaving");
	self endon("stopfiring");
	self endon("explode");
	self.besttarget endon("crashing");
	self.besttarget endon("leaving");
	self.besttarget endon("death");
	var_00 = gettime();
	if(isdefined(self.besttarget) && self.besttarget.classname == "script_vehicle")
	{
		self setturrettargetent(self.besttarget);
		for(;;)
		{
			var_01 = distance2d(self.origin,self.besttarget.origin);
			if(gettime() - var_00 > 2500 && var_01 > 1000)
			{
				firemissile(self.besttarget);
				var_00 = gettime();
			}

			wait(0.1);
		}
	}
}

//Function Number: 40
func_1574(param_00)
{
	self endon("death");
	self endon("leaving");
	self notify("newTarget");
	self.besttarget = param_00;
	self notify("acquiringVehTarget");
	self setlookatent(self.besttarget);
	thread func_13B9E();
	thread func_13B9D();
	self setturrettargetent(self.besttarget);
}

//Function Number: 41
func_13B9D()
{
	self endon("death");
	self endon("leaving");
	self.besttarget endon("death");
	self.besttarget endon("drop_crate");
	self.besttarget waittill("crashing");
	func_2FC1();
}

//Function Number: 42
func_13B9E()
{
	self endon("death");
	self endon("leaving");
	self.besttarget endon("crashing");
	self.besttarget endon("drop_crate");
	self.besttarget waittill("death");
	func_2FC1();
}

//Function Number: 43
func_2FC1()
{
	self getplayerkillstreakcombatmode();
	if(isdefined(self.besttarget) && !isdefined(self.besttarget.var_C084))
	{
		self.besttarget.var_C084 = 1;
	}

	self notify("stopfiring");
	self notify("newTarget");
	thread func_11075();
	thread func_658C();
}

//Function Number: 44
func_67E4()
{
	self setmaxpitchroll(15,80);
	self vehicle_setspeed(50,100);
	self givelastonteamwarning(90,30,30,0.5);
	var_00 = self.origin;
	var_01 = self.angles[1];
	if(scripts\engine\utility::cointoss())
	{
		var_02 = (0,var_01 + 90,0);
	}
	else
	{
		var_02 = (0,var_02 - 90,0);
	}

	var_03 = self.origin + anglestoforward(var_02) * 500;
	self setvehgoalpos(var_03,1);
	self waittill("goal");
}

//Function Number: 45
func_184E()
{
	level.helis[self getentitynumber()] = self;
}

//Function Number: 46
func_E10A()
{
	var_00 = self getentitynumber();
	self waittill("death");
	level.helis[var_00] = undefined;
}

//Function Number: 47
monitorowner()
{
	self endon("death");
	self endon("leaving");
	if(!isdefined(self.triggerportableradarping) || self.triggerportableradarping.team != self.team)
	{
		thread func_8B5E();
		return;
	}

	self.triggerportableradarping scripts\engine\utility::waittill_any_3("joined_team","disconnect");
	thread func_8B5E();
}