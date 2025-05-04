/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\aitypes\zombie_dlc1\behaviors.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 3
 * Decompile Time: 144 ms
 * Timestamp: 10\26\2023 11:59:05 PM
*******************************************************************/

//Function Number: 1
checkscripteddlc1(param_00)
{
	return lib_0C2B::func_3E48(param_00);
}

//Function Number: 2
chaseenemydlc1(param_00)
{
	scripts\asm\asm_bb::bb_setisincombat(1);
	if(self.precacheleaderboards)
	{
		self.curmeleetarget = undefined;
		return level.failure;
	}

	if(isdefined(self.hastraversed) && self.hastraversed)
	{
		self.noturnanims = 0;
	}

	if(!isdefined(self.isnodeoccupied))
	{
		return level.failure;
	}

	if(isdefined(self.var_10C.is_fast_traveling) || isdefined(self.var_10C.is_off_grid))
	{
		self.curmeleetarget = undefined;
		return level.failure;
	}

	if(isdefined(self.var_10C.killing_time))
	{
		self.curmeleetarget = undefined;
		return level.failure;
	}

	var_01 = undefined;
	if(isdefined(self.var_571B) && scripts\mp\agents\zombie\zombie_util::func_100AB())
	{
		var_01 = self.var_571B;
	}
	else if(isdefined(self.attackent))
	{
		var_01 = self.attackent;
	}
	else if(isdefined(self.isnodeoccupied) && !scripts\mp\agents\zombie\zombie_util::shouldignoreent(self.isnodeoccupied))
	{
		var_01 = self.isnodeoccupied;
	}

	if(!isdefined(var_01))
	{
		if(isdefined(self.curmeleetarget))
		{
			self.var_2AB8 = 1;
		}

		self.curmeleetarget = undefined;
		return level.failure;
	}

	var_03 = self.var_252B + self.fgetarg * 2;
	var_04 = var_03 * var_03;
	var_05 = self.var_252B;
	var_06 = var_05 * var_05;
	self.curmeleetarget = var_01;
	var_07 = scripts\mp\agents\zombie\zombie_util::func_7FAA(var_01);
	var_08 = var_07.var_656D;
	var_09 = distancesquared(var_07.origin,self.origin);
	var_0A = distancesquared(var_08,self.origin);
	var_0B = self.var_2AB8;
	if(var_0A < squared(self.fgetarg) && distancesquared(var_08,var_07.origin) > squared(self.fgetarg))
	{
		var_0B = 1;
		self notify("attack_anim","end");
	}

	if(!var_0B && var_0A > var_04 && var_09 > var_06)
	{
		var_0B = 1;
	}

	if(var_07.var_1312B)
	{
		if(!var_0B && var_0A <= var_04 && var_09 > squared(self.defaultgoalradius))
		{
			var_0B = 1;
		}

		self ghostskulls_total_waves(self.defaultgoalradius);
	}
	else if(!scripts\mp\agents\zombie\zombie_util::func_8C39(var_01,self.var_B640))
	{
		self ghostskulls_total_waves(self.defaultgoalradius);
		var_0B = 1;
	}
	else
	{
		self ghostskulls_total_waves(var_03);
		if(var_0A <= var_04)
		{
			var_07.origin = self.origin;
			var_0B = 1;
		}
	}

	if(var_0B)
	{
		var_02 = getclosestpointonnavmesh(var_07.origin);
		if(distancesquared(var_02,var_07.origin) > 10000)
		{
			return level.failure;
		}

		self ghostskulls_complete_status(var_02);
	}

	return level.success;
}

//Function Number: 3
seekenemydlc1(param_00)
{
	if(isdefined(self.dontseekenemies))
	{
		return level.failure;
	}

	var_01 = [];
	foreach(var_03 in level.players)
	{
		if(var_03.ignoreme || isdefined(var_03.triggerportableradarping) && var_03.var_222.ignoreme)
		{
			continue;
		}

		if(scripts\mp\agents\zombie\zombie_util::shouldignoreent(var_03))
		{
			continue;
		}

		if(!isalive(var_03))
		{
			continue;
		}

		var_01[var_01.size] = var_03;
	}

	var_05 = undefined;
	if(var_01.size > 0)
	{
		var_05 = sortbydistance(var_01,self.origin);
	}

	if(isdefined(var_05) && var_05.size > 0)
	{
		var_06 = 300;
		var_07 = distancesquared(var_05[0].origin,self.origin);
		if(var_07 < var_06 * var_06)
		{
			var_06 = 16;
		}

		var_08 = var_06 * var_06;
		if(self.var_2AB8 || distancesquared(self ghosthide(),var_05[0].origin) > var_08)
		{
			var_09 = isdefined(var_05[0].zipline);
			var_0A = var_05[0].origin;
			if(var_09)
			{
				var_0A = var_05[0].zipline.traversal_end;
			}

			var_0B = getclosestpointonnavmesh(var_0A,self);
			if(!var_09 && distancesquared(var_0B,var_05[0].origin) > var_08)
			{
				return level.failure;
			}

			self ghostskulls_complete_status(var_0B);
			self.var_2AB8 = 0;
		}

		scripts\asm\asm_bb::bb_setisincombat(1);
		return level.success;
	}

	return level.failure;
}