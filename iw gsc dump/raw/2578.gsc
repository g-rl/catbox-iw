/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 2578.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 5
 * Decompile Time: 0 ms
 * Timestamp: 10/27/2023 12:23:23 AM
*******************************************************************/

//Function Number: 1
func_C565(param_00)
{
	if(isdefined(self.var_C9B4))
	{
		return level.success;
	}

	return level.failure;
}

//Function Number: 2
func_F7B2(param_00)
{
	var_01 = self.var_C9B4;
	if(!isdefined(var_01.var_D648) || !isdefined(var_01.var_D642) || !isdefined(var_01.var_1119D))
	{
		return level.failure;
	}

	if(var_01.var_1119D == "loop")
	{
		var_01.var_D642 = var_01.var_D642 + 1;
		if(var_01.var_D642 >= var_01.var_D648.size)
		{
			var_01.var_D642 = 0;
		}
	}
	else if(var_01.var_1119D == "bounce")
	{
		if(!isdefined(var_01.var_54DA))
		{
			var_01.var_54DA = 1;
		}

		var_01.var_D642 = var_01.var_D642 + var_01.var_54DA;
		if(var_01.var_D642 >= var_01.var_D648.size)
		{
			var_01.var_D642 = var_01.var_D648.size - 2;
			var_01.var_54DA = -1;
		}
		else if(var_01.var_D642 < 0)
		{
			var_01.var_D642 = 1;
			var_01.var_54DA = 1;
		}
	}
	else
	{
	}

	self give_more_perk(var_01.var_D648[var_01.var_D642].var_D6A8);
	return level.success;
}

//Function Number: 3
allowreload(param_00,param_01)
{
	var_02 = self.var_C9B4;
	var_03 = var_02.var_D648[var_02.var_D642];
	var_04 = distancesquared(var_03,self.origin);
	var_05 = param_01;
	if(var_05 < 1)
	{
		var_05 = 1;
	}

	if(var_04 <= var_05 * var_05)
	{
		return level.success;
	}

	return level.running;
}

//Function Number: 4
func_9ED9(param_00,param_01)
{
	var_02 = param_01;
	var_03 = self.var_C9B4;
	var_04 = var_03.var_D648[var_03.var_D642];
	if(var_04.var_1119D == var_02)
	{
		return level.success;
	}
}

//Function Number: 5
func_D4A0(param_00)
{
	var_01 = self.var_C9B4;
	var_02 = var_01.var_D648[var_01.var_D642].var_92F3;
	if(!isdefined(var_02))
	{
		return level.failure;
	}

	return level.running;
}