/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\heavyarmor.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 9
 * Decompile Time: 374 ms
 * Timestamp: 10/27/2023 12:20:31 AM
*******************************************************************/

//Function Number: 1
addheavyarmor(param_00)
{
	var_01 = self.heavyarmor;
	if(!isdefined(self.struct))
	{
		var_01 = spawnstruct(self.heavyarmor);
		var_01.player = self;
		var_01.hp = 0;
		self.heavyarmor = var_01;
		var_01.hp = var_01.hp + param_00;
		self notify("heavyArmor_added");
		return;
	}

	var_01.hp = var_01.hp + param_00;
}

//Function Number: 2
subtractheavyarmor(param_00)
{
	var_01 = self.heavyarmor;
	if(scripts\mp\utility::istrue(var_01.var_9344))
	{
		return;
	}

	if(var_01.hp > 0)
	{
		var_01.hp = max(0,var_01.hp - param_00);
		scripts\mp\missions::func_D991("ch_heavy_armor_absorb",param_00);
		if(var_01.hp <= 0)
		{
			thread heavyarmor_break();
		}
	}
}

//Function Number: 3
removeheavyarmor()
{
	self notify("heavyArmor_removed");
	self.heavyarmor = undefined;
}

//Function Number: 4
heavyarmormodifydamage(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A)
{
	if(param_02 <= 0 && param_03 <= 0)
	{
		return [0,param_02,param_03];
	}

	if(param_04 == "MOD_SUICIDE")
	{
		return [0,param_02,param_03];
	}

	if(isdefined(param_01) && param_01.classname == "trigger_hurt" || param_01.classname == "worldspawn")
	{
		return [0,param_02,param_03];
	}

	if(!param_00 hasheavyarmor())
	{
		return [0,param_02,param_03];
	}

	if(scripts\mp\utility::isbombsiteweapon(param_05))
	{
		return [0,param_02,param_03];
	}

	if(param_00 hasheavyarmorinvulnerability())
	{
		return [1,1,0];
	}

	var_0B = param_00 getheavyarmor();
	var_0C = heavyarmor_getdamagemodifier(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A);
	var_0D = param_02 * var_0C;
	var_0E = param_03 * var_0C;
	var_0F = var_0D + var_0E;
	if(!param_0A)
	{
		param_00 subtractheavyarmor(var_0F);
	}

	if(param_00 hasheavyarmorinvulnerability())
	{
		return [var_0B,1,0];
	}

	return [param_02 + param_03,1,0];
}

//Function Number: 5
getheavyarmor()
{
	if(!hasheavyarmor())
	{
		return 0;
	}

	return self.heavyarmor.hp;
}

//Function Number: 6
hasheavyarmor()
{
	return isdefined(self.heavyarmor) && self.heavyarmor.hp > 0 || scripts\mp\utility::istrue(self.heavyarmor.invulnerabilityframe);
}

//Function Number: 7
hasheavyarmorinvulnerability()
{
	return isdefined(self.heavyarmor) && scripts\mp\utility::istrue(self.heavyarmor.invulnerabilityframe);
}

//Function Number: 8
heavyarmor_break()
{
	self endon("disconnect");
	self endon("heavyArmor_removed");
	if(!scripts\mp\utility::isanymlgmatch())
	{
		self.heavyarmor.invulnerabilityframe = 1;
	}

	self notify("heavyArmor_broken");
	waittillframeend;
	thread removeheavyarmor();
}

//Function Number: 9
heavyarmor_getdamagemodifier(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A)
{
	var_0B = [];
	if(scripts\mp\utility::issuperweapon(param_04))
	{
		var_0B[var_0B.size] = 1.33;
	}

	if(function_0107(param_04))
	{
		var_0B[var_0B.size] = 1.5;
	}

	if(param_04 == "MOD_MELEE")
	{
		var_0B[var_0B.size] = 1.5;
	}

	if(scripts\mp\utility::isheadshot(param_05,param_08,param_04,param_01))
	{
		var_0B[var_0B.size] = 1.5;
	}

	var_0C = 1;
	foreach(var_0E in var_0B)
	{
		if(var_0E > var_0C)
		{
			var_0E = var_0C;
		}
	}

	return var_0C;
}