/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 3423.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 11
 * Decompile Time: 1 ms
 * Timestamp: 10/27/2023 12:27:12 AM
*******************************************************************/

//Function Number: 1
func_9758()
{
	if(!isdefined(level.var_10680))
	{
		level.var_10680 = 250000;
	}
}

//Function Number: 2
func_EC19(param_00,param_01,param_02,param_03)
{
	if(isdefined(param_03))
	{
		var_04 = [[ param_01 ]](param_02,param_03);
	}
	else
	{
		var_04 = [[ param_02 ]](param_03);
	}

	var_04 = clamp(var_04,0,100);
	var_04 = var_04 * param_00;
	param_02.var_11A3A = param_02.var_11A3A + 100 * param_00;
	param_02.var_A9E9[self.team] = param_02.var_A9E9[self.team] + var_04;
	return var_04;
}

//Function Number: 3
critical_factor(param_00,param_01)
{
	var_02 = [[ param_00 ]](param_01);
	var_02 = clamp(var_02,0,100);
	return var_02;
}

//Function Number: 4
avoidcarepackages(param_00)
{
	foreach(var_02 in level.carepackages)
	{
		if(!isdefined(var_02))
		{
			continue;
		}

		if(distancesquared(param_00.origin,var_02.origin) < 22500)
		{
			return 0;
		}
	}

	return 100;
}

//Function Number: 5
func_26B8(param_00)
{
	foreach(var_02 in level.grenades)
	{
		if(!isdefined(var_02) || !var_02 isexplosivedangeroustoplayer(self))
		{
			continue;
		}

		if(distancesquared(param_00.origin,var_02.origin) < 122500)
		{
			return 0;
		}
	}

	return 100;
}

//Function Number: 6
func_26BC(param_00)
{
	var_01 = level.mines;
	if(isdefined(level.placed_crafted_traps))
	{
		var_01 = scripts\engine\utility::array_combine(level.mines,level.placed_crafted_traps);
	}

	foreach(var_03 in var_01)
	{
		if(!isdefined(var_03) || !var_03 isexplosivedangeroustoplayer(self))
		{
			continue;
		}

		if(distancesquared(param_00.origin,var_03.origin) < 122500)
		{
			return 0;
		}
	}

	return 100;
}

//Function Number: 7
isexplosivedangeroustoplayer(param_00)
{
	if(!level.teambased || level.friendlyfire || !isdefined(param_00.team))
	{
		return 1;
	}

	var_01 = undefined;
	if(isdefined(self.triggerportableradarping))
	{
		if(param_00 == self.triggerportableradarping)
		{
			return 1;
		}

		var_01 = self.triggerportableradarping.team;
	}

	if(isdefined(var_01))
	{
		return var_01 != param_00.team;
	}

	return 1;
}

//Function Number: 8
func_26C4(param_00)
{
	if(isdefined(self.var_1CAE))
	{
		return 100;
	}

	if(isdefined(param_00.var_1CAE))
	{
		return 100;
	}

	if(positionwouldtelefrag(param_00.origin))
	{
		return 0;
	}

	return 100;
}

//Function Number: 9
avoidsamespawn(param_00)
{
	if(isdefined(self.lastspawnpoint) && self.lastspawnpoint == param_00)
	{
		return 0;
	}

	return 100;
}

//Function Number: 10
randomspawnscore(param_00)
{
	return randomintrange(0,99);
}

//Function Number: 11
maxplayerspawninfluencedistsquared(param_00)
{
	return 3240000;
}