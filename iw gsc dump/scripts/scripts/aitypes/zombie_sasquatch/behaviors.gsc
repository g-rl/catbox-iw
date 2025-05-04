/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\aitypes\zombie_sasquatch\behaviors.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 35
 * Decompile Time: 1342 ms
 * Timestamp: 10\26\2023 11:59:08 PM
*******************************************************************/

//Function Number: 1
sasquatch_init(param_00)
{
	var_01 = gettime();
	self.var_3135.allowthrowtime = var_01 + 8000;
	self.var_3135.allowrushtime = var_01 + 5000;
	return level.success;
}

//Function Number: 2
isintrees(param_00)
{
	return level.failure;
}

//Function Number: 3
updateeveryframe(param_00)
{
	if(!isalive(self))
	{
		return level.failure;
	}

	if(isdefined(self.scripted) && self.scripted)
	{
		return level.failure;
	}

	var_01 = getclosestplayer();
	self.var_3135.isnodeoccupied = var_01;
	return level.success;
}

//Function Number: 4
shouldswingaround(param_00)
{
	return level.failure;
}

//Function Number: 5
shouldthrowrock(param_00)
{
	if(!isdefined(self.var_3135.isnodeoccupied))
	{
		return level.failure;
	}

	if(gettime() < self.var_3135.allowthrowtime)
	{
		return level.failure;
	}

	var_01 = distance2dsquared(self.var_3135.var_10C.origin,self.origin);
	if(var_01 > 360000)
	{
		return level.failure;
	}

	if(var_01 < 16384)
	{
		return level.failure;
	}

	if(!self getpersstat(self.var_3135.isnodeoccupied))
	{
		return level.failure;
	}

	return level.success;
}

//Function Number: 6
throwattack_check(param_00)
{
	var_01 = scripts\asm\asm_bb::bb_getthrowgrenadetarget();
	if(!isdefined(var_01))
	{
		return level.failure;
	}

	if(!isalive(var_01))
	{
		return level.failure;
	}

	if(distancesquared(self.origin,var_01.origin) > 518400)
	{
		return level.failure;
	}

	return level.success;
}

//Function Number: 7
throwattack_init(param_00)
{
	self.var_3135.instancedata[param_00] = spawnstruct();
	self.var_3135.instancedata[param_00].starttime = gettime();
	self.var_3135.instancedata[param_00].target = self.var_3135.isnodeoccupied;
	self ghostskulls_complete_status(self.origin);
	self ghostskulls_total_waves(64);
	scripts\asm\asm_bb::bb_requestthrowgrenade(1,self.var_3135.isnodeoccupied);
}

//Function Number: 8
throwattack(param_00)
{
	var_01 = 5000;
	if(gettime() - self.var_3135.instancedata[param_00].starttime > var_01)
	{
		return level.failure;
	}

	if(scripts\asm\asm::asm_ephemeraleventfired("throwevent","end"))
	{
		return level.success;
	}

	return level.running;
}

//Function Number: 9
throwattack_cleanup(param_00)
{
	self.var_3135.instancedata[param_00] = undefined;
	scripts\asm\asm_bb::bb_requestthrowgrenade(0);
	self.var_3135.allowthrowtime = gettime() + 8000;
}

//Function Number: 10
shouldmelee(param_00)
{
	if(!isdefined(self.var_3135.isnodeoccupied))
	{
		return level.failure;
	}

	var_01 = self.var_3135.isnodeoccupied;
	if(isdefined(self.var_3135.lastmeleefailtarget) && self.var_3135.lastmeleefailtarget == var_01 && gettime() - self.var_3135.lastmeleefailtime < 3000)
	{
		return level.failure;
	}

	var_02 = var_01.origin - self.origin;
	var_03 = length2dsquared(var_02);
	if(var_03 > 65536)
	{
		return level.failure;
	}

	if(abs(var_02[2]) > 72 && var_03 < 10000)
	{
		return level.failure;
	}

	return level.success;
}

//Function Number: 11
melee_setup(param_00)
{
	self.var_3135.meleetarget = self.var_3135.isnodeoccupied;
	return level.success;
}

//Function Number: 12
melee_shouldabort()
{
	var_00 = self.var_3135.meleetarget;
	if(!isdefined(var_00))
	{
		return 1;
	}

	if(!isalive(var_00))
	{
		return 1;
	}

	return 0;
}

//Function Number: 13
melee_cleanup()
{
	self.var_3135.meleetarget = undefined;
}

//Function Number: 14
melee_failed(param_00,param_01)
{
	self.var_3135.lastmeleefailtime = gettime();
	self.var_3135.lastmeleefailtarget = param_01;
	self.var_3135.lastmeleefailreason = param_00;
}

//Function Number: 15
melee_charge_init(param_00)
{
	self.var_3135.instancedata[param_00] = spawnstruct();
	self.var_3135.instancedata[param_00].starttime = gettime();
	self.var_3135.instancedata[param_00].prevgoalpos = self.origin;
}

//Function Number: 16
melee_charge(param_00)
{
	if(melee_shouldabort())
	{
		return level.failure;
	}

	var_01 = self.var_3135.meleetarget;
	var_02 = gettime() - self.var_3135.instancedata[param_00].starttime;
	var_03 = isdefined(self _meth_8150());
	if(var_02 > 200 && !var_03)
	{
		melee_failed(1,var_01);
		return level.failure;
	}

	if(var_02 > 5000)
	{
		melee_failed(3,var_01);
		return level.failure;
	}

	var_04 = var_01.origin - self.origin;
	var_05 = length2dsquared(var_04);
	var_06 = var_05;
	if(var_03)
	{
		var_07 = self pathdisttogoal();
		var_06 = var_07 * var_07;
	}

	if(var_06 > 200704)
	{
		melee_failed(2,var_01);
		return level.failure;
	}

	if(var_05 < 5184)
	{
		var_08 = self _meth_84AC();
		var_09 = getclosestpointonnavmesh(var_01.origin,self);
		if(navisstraightlinereachable(var_08,var_09,self))
		{
			self.var_3135.instancedata[param_00].bsuccess = 1;
			return level.success;
		}
	}

	var_0A = var_01.origin;
	var_0B = 144;
	if(distance2dsquared(var_0A,self.var_3135.instancedata[param_00].prevgoalpos) > var_0B)
	{
		self ghostskulls_complete_status(var_0A);
		self ghostskulls_total_waves(24);
		self.var_3135.instancedata[param_00].prevgoalpos = var_0A;
	}

	return level.running;
}

//Function Number: 17
melee_charge_cleanup(param_00)
{
	if(!isdefined(self.var_3135.instancedata[param_00].bsuccess))
	{
		melee_cleanup();
	}

	self.var_3135.instancedata[param_00] = undefined;
}

//Function Number: 18
melee_attack_init(param_00)
{
	self.var_3135.instancedata[param_00] = spawnstruct();
	self.var_3135.instancedata[param_00].starttime = gettime();
	scripts\asm\asm_bb::bb_requestmelee(self.var_3135.meleetarget);
	self ghostskulls_complete_status(self.origin);
	self ghostskulls_total_waves(64);
}

//Function Number: 19
melee_attack(param_00)
{
	if(melee_shouldabort())
	{
		return level.failure;
	}

	var_01 = 10000;
	if(gettime() - self.var_3135.instancedata[param_00].starttime > var_01)
	{
		return level.failure;
	}

	if(scripts\asm\asm::asm_ephemeraleventfired("meleeattack","end"))
	{
		return level.success;
	}

	return level.running;
}

//Function Number: 20
melee_attack_cleanup(param_00)
{
	self.var_3135.instancedata[param_00] = undefined;
	melee_cleanup();
	scripts\asm\asm_bb::bb_clearmeleerequest();
}

//Function Number: 21
shouldrush(param_00)
{
	var_01 = self.var_3135.isnodeoccupied;
	if(!isdefined(var_01) || !isalive(var_01))
	{
		return level.failure;
	}

	if(gettime() < self.var_3135.allowrushtime)
	{
		return level.failure;
	}

	var_02 = var_01.origin - self.origin;
	var_03 = length2dsquared(var_02);
	if(var_03 > 589824)
	{
		return level.failure;
	}

	if(var_03 < 32400)
	{
		return level.failure;
	}

	if(isdefined(self.vehicle_getspawnerarray))
	{
		var_04 = self _meth_84F9(84);
		if(isdefined(var_04))
		{
			return level.failure;
		}

		if(self pathdisttogoal() > 1179648)
		{
			return level.failure;
		}
	}

	if(!self getpersstat(var_01))
	{
		return level.failure;
	}

	return level.success;
}

//Function Number: 22
rush_charge_init(param_00)
{
	self.var_3135.instancedata[param_00] = spawnstruct();
	self.var_3135.instancedata[param_00].starttime = gettime();
	self.var_3135.instancedata[param_00].areanynavvolumesloaded = self.origin;
	self.var_3135.instancedata[param_00].btracking = 1;
	self.var_1198.movetype = "sprint";
	self.var_1198.brushorienttoenemy = 1;
	self.var_1198.brushrequested = 1;
	self.var_3135.meleetarget = self.var_3135.isnodeoccupied;
}

//Function Number: 23
rush_charge(param_00)
{
	var_01 = 0;
	var_02 = 1;
	var_03 = 2;
	if(melee_shouldabort())
	{
		return level.success;
	}

	var_04 = gettime();
	var_05 = self.var_3135.instancedata[param_00].starttime;
	var_06 = 8000;
	if(var_04 > var_05 + var_06)
	{
		self.var_3135.instancedata[param_00].bfailure = 1;
		return level.failure;
	}

	if(distance2dsquared(self.origin,self.var_3135.instancedata[param_00].areanynavvolumesloaded) > 262144)
	{
		return level.success;
	}

	var_07 = self.var_3135.var_B64D.origin - self.origin;
	if(length2dsquared(var_07) < 20736)
	{
		self.var_3135.instancedata[param_00].bsuccess = 1;
		return level.success;
	}

	if(var_04 > var_05 + 200 && !isdefined(self.vehicle_getspawnerarray))
	{
		self.var_3135.instancedata[param_00].bfailure = 1;
		return level.failure;
	}

	var_08 = self _meth_84F9(84);
	if(isdefined(var_08))
	{
		self.var_3135.instancedata[param_00].bfailure = 1;
		return level.failure;
	}

	if(self.var_3135.instancedata[param_00].btracking)
	{
		var_09 = 1000;
		if(var_04 > self.var_3135.instancedata[param_00].starttime + var_09)
		{
			var_0A = vectornormalize((var_07[0],var_07[1],0));
			var_0B = self _meth_813A();
			var_0B = vectornormalize((var_0B[0],var_0B[1],0));
			if(vectordot(var_07,var_0B) < 0.966)
			{
				var_0C = self.origin + var_0B * 208;
				var_0D = self _meth_84AC();
				var_0E = navtrace(var_0D,var_0C,self,1);
				if(var_0E["fraction"] < 1)
				{
					var_0C = var_0E["position"];
				}

				self ghostskulls_complete_status(var_0C);
				self ghostskulls_total_waves(24);
				self.var_3135.instancedata[param_00].btracking = 0;
			}
			else
			{
				self ghostskulls_complete_status(self.var_3135.var_B64D.origin);
				self ghostskulls_total_waves(24);
			}
		}
		else
		{
			self ghostskulls_complete_status(self.var_3135.var_B64D.origin);
			self ghostskulls_total_waves(24);
		}
	}
	else if(self pathdisttogoal() < 144)
	{
		return level.success;
	}

	return level.running;
}

//Function Number: 24
rush_charge_cleanup(param_00)
{
	if(!isdefined(self.var_3135.instancedata[param_00].bsuccess))
	{
		melee_cleanup();
		self.var_3135.allowrushtime = gettime() + 1000;
	}

	self.var_1198.movetype = "run";
	self.var_1198.brushrequested = undefined;
	self.var_3135.instancedata[param_00] = undefined;
}

//Function Number: 25
rush_attack_init(param_00)
{
	self.var_3135.instancedata[param_00] = gettime();
	scripts\asm\asm_bb::bb_requestmelee(self.var_3135.meleetarget);
}

//Function Number: 26
rush_attack(param_00)
{
	var_01 = gettime();
	var_02 = 5000;
	if(var_01 > self.var_3135.instancedata[param_00] + var_02)
	{
		return level.failure;
	}

	if(scripts\asm\asm::asm_ephemeraleventfired("rushattack","end"))
	{
		self.var_3135.allowrushtime = var_01 + 5000;
		return level.success;
	}

	self ghostskulls_complete_status(self.origin);
	self ghostskulls_total_waves(36);
	return level.running;
}

//Function Number: 27
rush_attack_cleanup(param_00)
{
	self.var_3135.instancedata[param_00] = undefined;
	scripts\asm\asm_bb::bb_clearmeleerequest();
	melee_cleanup();
}

//Function Number: 28
shouldtaunt(param_00)
{
	if(isdefined(self.killed_player))
	{
		self.killed_player = undefined;
		return level.success;
	}

	return level.failure;
}

//Function Number: 29
taunt_init(param_00)
{
	self.var_3135.instancedata[param_00] = gettime();
	self.var_1198.btauntrequested = 1;
	self ghostskulls_complete_status(self.origin);
	self ghostskulls_total_waves(64);
}

//Function Number: 30
dotaunt(param_00)
{
	var_01 = 6000;
	if(gettime() - self.var_3135.instancedata[param_00] > var_01)
	{
		return level.failure;
	}

	if(scripts\asm\asm::asm_ephemeraleventfired("tauntevent","end"))
	{
		return level.success;
	}

	return level.running;
}

//Function Number: 31
taunt_cleanup(param_00)
{
	self.var_3135.instancedata[param_00] = undefined;
	self.var_1198.btauntrequested = undefined;
}

//Function Number: 32
wander_init(param_00)
{
	var_01 = spawnstruct();
	var_01.curtargetpos = self.origin;
	var_01.nextchecktime = gettime();
	self.var_3135.instancedata[param_00] = var_01;
}

//Function Number: 33
getclosestplayer()
{
	var_00 = undefined;
	var_01 = 0;
	foreach(var_03 in level.players)
	{
		if(!isalive(var_03))
		{
			continue;
		}

		if(var_03.ignoreme || isdefined(var_03.triggerportableradarping) && var_03.var_222.ignoreme)
		{
			continue;
		}

		if(scripts\mp\agents\zombie\zombie_util::shouldignoreent(var_03))
		{
			continue;
		}

		var_04 = distance2dsquared(self.origin,var_03.origin);
		if(!isdefined(var_00) || var_04 < var_01)
		{
			var_00 = var_03;
			var_01 = var_04;
		}
	}

	return var_00;
}

//Function Number: 34
wander(param_00)
{
	if(isdefined(self.var_3135.isnodeoccupied) && !scripts\common\utility::istrue(self.var_3135.var_10C.ignoreme))
	{
		var_01 = self.var_3135.var_10C.origin;
		if(!isdefined(self.vehicle_getspawnerarray) || distance2dsquared(var_01,self.var_3135.instancedata[param_00].curtargetpos) > 1296)
		{
			self.var_3135.instancedata[param_00].curtargetpos = var_01;
			var_02 = getclosestpointonnavmesh(var_01,self);
			self ghostskulls_complete_status(var_02);
		}
	}
	else if(gettime() >= self.var_3135.instancedata[param_00].nextchecktime || isdefined(self.var_3135.isnodeoccupied) && scripts\common\utility::istrue(self.var_3135.var_10C.ignoreme))
	{
		var_03 = getclosestplayer();
		if(isdefined(var_03))
		{
			self.var_3135.instancedata[param_00].curtargetpos = var_03.origin;
			var_02 = getclosestpointonnavmesh(var_03.origin,self);
			self ghostskulls_complete_status(var_02);
			self.var_3135.instancedata[param_00].nextchecktime = self.var_3135.instancedata[param_00].nextchecktime + 2000;
		}
	}

	return level.running;
}

//Function Number: 35
wander_cleanup(param_00)
{
	self.var_3135.instancedata[param_00] = undefined;
}