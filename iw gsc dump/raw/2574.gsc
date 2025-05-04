/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 2574.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 27
 * Decompile Time: 10 ms
 * Timestamp: 10/27/2023 12:23:22 AM
*******************************************************************/

//Function Number: 1
meleedeathhandler(param_00)
{
	self endon("melee_finished");
	self waittill("terminate_ai_threads");
	scripts/asm/asm_bb::bb_clearmeleetarget();
}

//Function Number: 2
melee_init(param_00,param_01)
{
	if(!isdefined(param_01))
	{
		param_01 = self.isnodeoccupied;
	}

	if(isdefined(self.melee))
	{
		melee_destroy();
	}

	scripts/asm/asm_bb::bb_setmeleetarget(param_01);
	self.melee.taskid = param_00;
	param_01.melee.taskid = param_00;
	return level.success;
}

//Function Number: 3
melee_destroy()
{
	self _meth_8484();
	if(isdefined(self.melee))
	{
		if(isdefined(self.melee.target))
		{
			self.melee.target.melee = undefined;
		}

		self.melee = undefined;
	}
}

//Function Number: 4
func_3914(param_00)
{
	if(isdefined(self.melee))
	{
		return 0;
	}

	if(!isdefined(self.var_B5E4) || !self.var_B5E4)
	{
		return 0;
	}

	if(!isdefined(param_00.melee))
	{
		return 0;
	}

	var_01 = param_00.melee.partner;
	if(!isdefined(var_01) || !isdefined(var_01.melee))
	{
		return 0;
	}

	if(isdefined(var_01.melee.var_29A8))
	{
		return 0;
	}

	var_02 = distance(param_00.origin,self.origin);
	var_03 = distance(param_00.origin,var_01.origin);
	if(var_02 + 48 > var_03)
	{
		return 0;
	}

	return 1;
}

//Function Number: 5
func_9E96(param_00)
{
	var_01 = self.isnodeoccupied;
	if(isdefined(param_00))
	{
		var_01 = param_00;
	}

	if(isdefined(self.dontmelee))
	{
		return 0;
	}

	if(isdefined(self.bt.cannotmelee))
	{
		return 0;
	}

	if(!isdefined(var_01))
	{
		return 0;
	}

	if(isdefined(var_01.dontmelee))
	{
		return 0;
	}

	if(isdefined(self._stealth) && !canmeleeduringstealth())
	{
		return 0;
	}

	if(func_9DD1(var_01))
	{
		if(!func_3914(var_01))
		{
			return 0;
		}
	}

	return 1;
}

//Function Number: 6
shouldmelee(param_00,param_01)
{
	if(!isdefined(param_01))
	{
		param_01 = self.isnodeoccupied;
	}

	if(!func_9E96(param_01))
	{
		return level.failure;
	}

	if(![[ self.fnismeleevalid ]](param_01,1))
	{
		return level.failure;
	}

	if(!func_9E98(param_01))
	{
		return level.failure;
	}

	return level.success;
}

//Function Number: 7
func_9896(param_00)
{
	self.bt.instancedata[param_00] = spawnstruct();
	self.bt.instancedata[param_00].timeout = gettime();
	self.bt.instancedata[param_00].var_312F = 0;
	if(isplayer(self.melee.target))
	{
		self.bt.instancedata[param_00].objective_state_nomessage = self.objective_state_nomessage;
		self.objective_state_nomessage = 0;
	}

	scripts/asm/asm_bb::bb_requestmelee(self.melee.target);
	if(isdefined(self.var_71BF))
	{
		self [[ self.var_71BF ]]();
	}

	if(!isdefined(self.var_B5DA) && isplayer(self.melee.target) && !self.melee.target isonground())
	{
		self.melee.var_2720 = 1;
	}

	self clearpath();
	if(isai(self.melee.target))
	{
		self.melee.target clearpath();
	}
}

//Function Number: 8
func_5903(param_00)
{
	if(!isdefined(self.melee))
	{
		return level.failure;
	}

	if(isdefined(self.melee.var_2720))
	{
		return level.failure;
	}

	if(scripts/asm/asm::asm_ephemeraleventfired("melee_attack","end"))
	{
		return level.success;
	}

	if(scripts/asm/asm::asm_ephemeraleventfired("melee_attack","begin",0))
	{
		self.bt.instancedata[param_00].var_312F = 1;
		self.bt.instancedata[param_00].timeout = gettime() + 10000;
	}

	if(!self.bt.instancedata[param_00].var_312F)
	{
		if(!isdefined(self.melee.target) || !isalive(self.melee.target))
		{
			return level.failure;
		}
	}

	if(gettime() > self.bt.instancedata[param_00].timeout + 2000)
	{
		self.melee.var_2720 = 1;
		return level.failure;
	}

	if(isdefined(self.melee.target) && !isplayer(self.melee.target) && self.melee.target scripts/asm/asm_bb::bb_isanimscripted())
	{
		return level.failure;
	}

	return level.running;
}

//Function Number: 9
func_41C6(param_00)
{
	scripts/asm/asm_bb::bb_clearmeleerequest();
	if(isdefined(self.melee) && !isdefined(self.melee.var_312F))
	{
		if(isdefined(self.melee.target))
		{
			self.melee.target.melee = undefined;
		}

		self.melee = undefined;
	}

	if(isdefined(self.bt.instancedata[param_00].objective_state_nomessage))
	{
		self.objective_state_nomessage = self.bt.instancedata[param_00].objective_state_nomessage;
	}

	self.bt.instancedata[param_00] = undefined;
}

//Function Number: 10
func_B5C3(param_00)
{
	if(isdefined(self.isnodeoccupied) && isdefined(self.isnodeoccupied.melee))
	{
		if(isdefined(self.isnodeoccupied.melee.partner))
		{
			self.isnodeoccupied.melee.partner melee_destroy();
		}
		else
		{
			self.isnodeoccupied melee_destroy();
		}
	}

	return level.success;
}

//Function Number: 11
func_B653(param_00)
{
	melee_init(param_00);
	if(isdefined(self.fnmeleevsplayer_init))
	{
		self [[ self.fnmeleevsplayer_init ]](param_00);
	}

	thread meleedeathhandler(self.isnodeoccupied);
}

//Function Number: 12
meleevsplayer_terminate(param_00)
{
	scripts/asm/asm_bb::bb_clearmeleerequest();
	melee_destroy();
	if(isdefined(self.fnmeleevsplayer_terminate))
	{
		self [[ self.fnmeleevsplayer_terminate ]](param_00);
	}
}

//Function Number: 13
meleevsplayer_update(param_00)
{
	if(!isdefined(self.melee.target) || !isalive(self.melee.target))
	{
		return level.failure;
	}

	if(scripts/asm/asm::asm_ephemeraleventfired("melee_attack","end"))
	{
		return level.success;
	}

	scripts/asm/asm_bb::bb_requestmelee(self.melee.target);
	return level.running;
}

//Function Number: 14
func_B5B4(param_00,param_01)
{
	if(!isdefined(anim))
	{
		return;
	}

	if(!isdefined(level.var_B5F5))
	{
		return;
	}

	if(!isdefined(param_00))
	{
		return;
	}

	if(!isdefined(param_01))
	{
		param_01 = 1;
	}

	if(isplayer(self.melee.target) && isdefined(level.var_B5F6[self.unittype]))
	{
		level.var_B5F7[self.unittype] = gettime() + level.var_B5F6[self.unittype] * param_01;
		return;
	}

	if(isdefined(level.var_B5F5[self.unittype]))
	{
		level.var_B5F8[self.unittype] = gettime() + level.var_B5F5[self.unittype] * param_01;
	}
}

//Function Number: 15
func_B5E8(param_00)
{
	self.melee.var_3D2C = 1;
	if(isdefined(self.fnmeleecharge_init))
	{
		self [[ self.fnmeleecharge_init ]](param_00);
	}

	func_B5B4(self.unittype,3);
	self.bt.instancedata[param_00] = spawnstruct();
	self.bt.instancedata[param_00].var_3E30 = gettime() + 100;
	self.bt.instancedata[param_00].timeout = gettime() + 4000;
	self.bt.instancedata[param_00].var_6572 = self.isnodeoccupied.origin;
	if(isplayer(self.melee.target))
	{
		self.bt.instancedata[param_00].objective_state_nomessage = self.objective_state_nomessage;
		self.objective_state_nomessage = 0;
	}

	self.setumbraportalstate = 64;
}

//Function Number: 16
func_B5EE(param_00)
{
	if(isdefined(self.melee))
	{
		func_B5B4(self.unittype,0);
	}

	if(isdefined(self.melee) && isdefined(self.melee.var_2720) || !isdefined(self.melee.var_29A8))
	{
		melee_destroy();
	}

	self _meth_8484();
	self.setumbraportalstate = 0;
	if(isdefined(self.bt.instancedata[param_00].objective_state_nomessage))
	{
		self.objective_state_nomessage = self.bt.instancedata[param_00].objective_state_nomessage;
	}

	scripts/asm/asm_bb::bb_clearmeleechargerequest();
	if(isdefined(self.fnmeleecharge_terminate))
	{
		self [[ self.fnmeleecharge_terminate ]](param_00);
	}

	self.bt.instancedata[param_00] = undefined;
}

//Function Number: 17
func_7FAB(param_00)
{
	if(isplayer(param_00))
	{
		var_01 = self.meleechargedistvsplayer;
	}
	else
	{
		var_01 = self.meleechargedist;
	}

	if(!scripts/aitypes/combat::hasammoinclip())
	{
		var_01 = var_01 * self.meleechargedistreloadmultiplier;
	}

	return var_01;
}

//Function Number: 18
melee_shouldabort()
{
	if(!isdefined(self.melee))
	{
		return 1;
	}

	var_00 = self.melee.target;
	if(!isdefined(var_00))
	{
		return 1;
	}

	if(!isalive(var_00))
	{
		return 1;
	}

	if(!isplayer(var_00) && var_00 scripts/asm/asm_bb::bb_isanimscripted())
	{
		return 1;
	}

	return 0;
}

//Function Number: 19
func_B5EB()
{
	if(melee_shouldabort())
	{
		return 1;
	}

	if(isdefined(self.bt.cannotmelee))
	{
		return 1;
	}

	if(isdefined(self.melee.var_2720))
	{
		return 1;
	}

	var_00 = self.melee.target;
	if(isdefined(var_00.var_C337) && var_00.var_C337.var_19)
	{
		if(isai(var_00) || !isdefined(self.var_B5DC) || !self.var_B5DC)
		{
			return 1;
		}
	}

	if(isdefined(self.isnodeoccupied) && var_00 != self.isnodeoccupied)
	{
		return 1;
	}

	if(scripts/asm/asm::asm_ephemeraleventfired("melee_charge_state","end"))
	{
		return 1;
	}

	return 0;
}

//Function Number: 20
func_B5E7(param_00)
{
	self.var_BF90 = gettime() + 1500;
	self.var_A985 = param_00;
}

//Function Number: 21
func_B5EA(param_00,param_01)
{
	var_02 = self.bt.instancedata[param_00].targetpos;
	if(!isdefined(var_02))
	{
		return 0;
	}

	if(isdefined(self.vehicle_getspawnerarray) && distance2dsquared(self.vehicle_getspawnerarray,self.origin) > 16)
	{
		return 0;
	}

	return distancesquared(var_02,param_01) < 4;
}

//Function Number: 22
func_B5F0(param_00)
{
	if(func_B5EB())
	{
		if(isdefined(self.melee))
		{
			self.melee.var_2720 = 1;
		}

		return level.failure;
	}

	var_01 = self.meleerangesq;
	if(!isdefined(var_01))
	{
		var_01 = 4096;
	}

	var_02 = self.melee.target;
	if(isdefined(self.var_B5DA) || isdefined(self.var_B621))
	{
		var_03 = distance2dsquared(var_02.origin,self.origin);
	}
	else
	{
		var_03 = distancesquared(var_03.origin,self.origin);
	}

	var_04 = func_7FAB(var_02) + 24;
	var_05 = var_04 * var_04;
	if(var_03 > var_05)
	{
		self.melee.var_2720 = 1;
		return level.failure;
	}

	if(isplayer(var_02))
	{
		var_06 = getclosestpointonnavmesh(var_02.origin,self);
	}
	else
	{
		var_06 = var_03 _meth_84AC();
	}

	var_07 = var_01;
	var_08 = length(self.var_381);
	if(var_08 > 1)
	{
		var_07 = squared(sqrt(var_01) + var_08 * 0.1);
	}

	if(var_03 <= var_07)
	{
		if(isplayer(var_02))
		{
			if(scripts\engine\utility::meleegrab_ksweapon_used())
			{
				return level.running;
			}
		}

		var_09 = 18;
		if(isdefined(self.getcsplinepointtargetname) && self.getcsplinepointtargetname != "none" && isplayer(var_02))
		{
			var_09 = 32;
		}

		if(isdefined(self.var_B621) || abs(self.origin[2] - var_02.origin[2]) < var_09)
		{
			var_0A = self _meth_84AC();
			if(self [[ self.fncanmovefrompointtopoint ]](var_0A,var_06))
			{
				self.melee.var_29A8 = 1;
				return level.success;
			}
		}
	}

	if(self.badpath || gettime() > self.bt.instancedata[param_00].var_3E30 && !isdefined(self.vehicle_getspawnerarray))
	{
		func_B5E7(var_02);
		self.melee.var_2720 = 1;
		return level.failure;
	}

	if(!isdefined(self.melee.var_2AC7) || !self.melee.var_2AC7)
	{
		if(gettime() >= self.bt.instancedata[param_00].timeout)
		{
			func_B5E7(var_02);
			self.melee.var_2720 = 1;
			return level.failure;
		}
	}

	if(!isdefined(self.melee.var_2AC6) || !self.melee.var_2AC6)
	{
		if(isdefined(self.var_B5DA))
		{
			var_0B = distance2dsquared(var_02.origin,self.bt.instancedata[param_00].var_6572);
		}
		else
		{
			var_0B = distancesquared(var_03.origin,self.bt.instancedata[var_01].var_6572);
		}

		if(var_0B > 16384)
		{
			func_B5E7(var_02);
			self.melee.var_2720 = 1;
			return level.failure;
		}
	}

	var_0C = max(sqrt(var_01) - 24,0);
	var_0D = vectornormalize(self.origin - var_02.origin);
	var_0E = var_02.origin + var_0D * var_0C;
	var_0F = 36;
	if(isdefined(self.var_B64F))
	{
		var_0F = self.var_B64F;
	}

	var_10 = 1;
	if(!func_B5EA(param_00,var_0E))
	{
		var_11 = getclosestpointonnavmesh(var_0E,self);
		var_10 = distance2dsquared(var_0E,var_11) > var_0F;
		if(!var_10)
		{
			var_10 = !self [[ self.fncanmovefrompointtopoint ]](var_11,var_06);
		}
	}

	if(var_10 && isdefined(self.var_B651) && self.var_B651)
	{
		if(isdefined(var_02.target_getindexoftarget))
		{
			if(scripts\engine\utility::isnodecoverleft(var_02.target_getindexoftarget))
			{
				var_12 = function_02D3(var_02.target_getindexoftarget.angles);
				var_0E = var_02.target_getindexoftarget.origin + var_12 * var_0C;
			}
			else if(scripts\engine\utility::isnodecoverright(var_02.target_getindexoftarget))
			{
				var_13 = anglestoright(var_02.target_getindexoftarget.angles);
				var_0E = var_02.target_getindexoftarget.origin + var_13 * var_0C;
			}
			else
			{
				var_14 = anglestoforward(var_02.target_getindexoftarget.angles);
				var_0E = var_02.target_getindexoftarget.origin - var_14 * var_0C;
			}

			if(!func_B5EA(param_00,var_0E))
			{
				var_11 = getclosestpointonnavmesh(var_0E,self);
				var_10 = distance2dsquared(var_0E,var_11) > var_0F;
			}
		}

		if(var_10)
		{
			var_0E = var_02.origin - var_0D * var_0C;
			if(!func_B5EA(param_00,var_0E))
			{
				var_11 = getclosestpointonnavmesh(var_0E,self);
				var_10 = distance2dsquared(var_0E,var_11) > var_0F;
			}
		}

		if(var_10)
		{
			var_0E = var_06;
			var_10 = 0;
		}
	}

	if(var_10)
	{
		func_B5E7(var_02);
		self.melee.var_2720 = 1;
		return level.failure;
	}

	self _meth_8481(var_0E);
	self.var_6D = 6;
	self.bt.instancedata[param_00].targetpos = var_0E;
	scripts/asm/asm_bb::bb_requestmeleecharge(var_02,var_0E);
	return level.running;
}

//Function Number: 23
gettargetchargepos(param_00)
{
	var_01 = param_00.origin;
	var_02 = param_00.origin - self.origin;
	var_02 = vectornormalize(var_02);
	var_01 = var_01 - var_02 * self.meleeactorboundsradius;
	var_03 = getclosestpointonnavmesh(var_01,self);
	if(abs(var_01[2] - var_03[2]) > self.maxzdiff)
	{
		return undefined;
	}

	var_04 = navtrace(self.origin,var_03,self,1);
	var_05 = var_04["fraction"];
	if(var_05 < self.acceptablemeleefraction)
	{
		return undefined;
	}

	return var_03;
}

//Function Number: 24
canmeleeduringstealth()
{
	if(isdefined(self.var_65DB) && isdefined(self.var_65DB["_stealth_enabled"]) && self.var_65DB["_stealth_enabled"])
	{
		if(isdefined(self.var_65DB["_stealth_attack"]) && !self.var_65DB["_stealth_attack"])
		{
			return 0;
		}
	}

	return level.success;
}

//Function Number: 25
func_9DD1(param_00)
{
	var_01 = self.isnodeoccupied;
	if(isdefined(param_00))
	{
		var_01 = param_00;
	}

	if(isdefined(self.melee))
	{
		return 1;
	}

	if(isdefined(var_01.melee))
	{
		return 1;
	}

	return 0;
}

//Function Number: 26
func_9E98(param_00)
{
	if(abs(param_00.origin[2] - self.origin[2]) > self.var_B627)
	{
		return 0;
	}

	var_01 = func_7FAB(param_00);
	var_02 = var_01 * var_01;
	var_03 = distancesquared(self.origin,param_00.origin);
	return var_03 <= var_02;
}

//Function Number: 27
ismeleevalid_common(param_00,param_01)
{
	if(isdefined(self.dontmelee))
	{
		return 0;
	}

	if(!isdefined(param_00))
	{
		return 0;
	}

	if(isdefined(param_00.dontmelee))
	{
		return 0;
	}

	if(!isalive(self))
	{
		return 0;
	}

	if(!isalive(param_00))
	{
		return 0;
	}

	return 1;
}