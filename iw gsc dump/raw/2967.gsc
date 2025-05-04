/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 2967.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 8
 * Decompile Time: 2 ms
 * Timestamp: 10/27/2023 12:26:00 AM
*******************************************************************/

//Function Number: 1
lights_on(param_00,param_01)
{
	var_02 = strtok(param_00," ");
	scripts\engine\utility::array_levelthread(var_02,::func_ACCF,param_01);
}

//Function Number: 2
func_8695(param_00,param_01,param_02)
{
	if(!isdefined(level.vehicle.var_116CE.var_13209))
	{
		level.vehicle.var_116CE.var_13209 = [];
	}

	if(!isdefined(level.vehicle.var_116CE.var_13209[param_00]))
	{
		level.vehicle.var_116CE.var_13209[param_00] = [];
	}

	if(!isdefined(level.vehicle.var_116CE.var_13209[param_00][param_02]))
	{
		level.vehicle.var_116CE.var_13209[param_00][param_02] = [];
	}

	foreach(var_04 in level.vehicle.var_116CE.var_13209[param_00][param_02])
	{
		if(param_01 == var_04)
		{
			return;
		}
	}

	level.vehicle.var_116CE.var_13209[param_00][param_02][level.vehicle.var_116CE.var_13209[param_00][param_02].size] = param_01;
}

//Function Number: 3
func_ACCA()
{
	level notify("new_lights_delayfxforframe");
	level endon("new_lights_delayfxforframe");
	if(!isdefined(level.var_7624))
	{
		level.var_7624 = 0;
	}

	level.var_7624 = level.var_7624 + randomfloatrange(0.2,0.4);
	if(level.var_7624 > 2)
	{
		level.var_7624 = 0;
	}

	wait(0.05);
	level.var_7624 = undefined;
}

//Function Number: 4
func_A5F2(param_00)
{
	lights_off_internal("all",param_00);
}

//Function Number: 5
lights_off_internal(param_00,param_01,param_02)
{
	if(isdefined(param_02))
	{
		param_01 = param_02;
	}
	else if(!isdefined(param_01))
	{
		param_01 = self.classname;
	}

	if(!isdefined(param_00))
	{
		param_00 = "all";
	}

	if(!isdefined(self.lights))
	{
		return;
	}

	if(!isdefined(level.vehicle.var_116CE.var_13209[param_01][param_00]))
	{
		return;
	}

	var_03 = level.vehicle.var_116CE.var_13209[param_01][param_00];
	var_04 = 0;
	var_05 = 2;
	if(isdefined(self.var_B4AE))
	{
		var_05 = self.var_B4AE;
	}

	foreach(var_07 in var_03)
	{
		var_08 = level.vehicle.var_116CE.var_13208[param_01][var_07];
		if(scripts\sp\_utility::hastag(self.model,var_08.physics_setgravitydynentscalar))
		{
			stopfxontag(var_08.effect,self,var_08.physics_setgravitydynentscalar);
		}

		var_04++;
		if(var_04 >= var_05)
		{
			var_04 = 0;
			wait(0.05);
		}

		if(!isdefined(self))
		{
			return;
		}

		self.lights[var_07] = undefined;
	}
}

//Function Number: 6
func_ACCF(param_00,param_01)
{
	level.var_A9AE = gettime();
	if(!isdefined(param_00))
	{
		param_00 = "all";
	}

	if(!isdefined(param_01))
	{
		param_01 = self.classname;
	}

	if(!isdefined(level.vehicle.var_116CE.var_13209))
	{
		return;
	}

	if(!isdefined(level.vehicle.var_116CE.var_13209[param_01]) || !isdefined(level.vehicle.var_116CE.var_13209[param_01][param_00]))
	{
		return;
	}

	thread func_ACCA();
	if(!isdefined(self.lights))
	{
		self.lights = [];
	}

	var_02 = level.vehicle.var_116CE.var_13209[param_01][param_00];
	var_03 = 0;
	var_04 = [];
	foreach(var_06 in var_02)
	{
		if(isdefined(self.lights[var_06]))
		{
			continue;
		}

		var_07 = level.vehicle.var_116CE.var_13208[param_01][var_06];
		if(isdefined(var_07.delay))
		{
			var_08 = var_07.delay;
		}
		else
		{
			var_08 = 0;
		}

		var_08 = var_08 + level.var_7624;
		while(isdefined(var_04["" + var_08]))
		{
			var_08 = var_08 + 0.05;
		}

		var_04["" + var_08] = 1;
		self endon("death");
		childthread scripts\engine\utility::noself_delaycall_proc(::playfxontag,var_08,var_07.effect,self,var_07.physics_setgravitydynentscalar);
		self.lights[var_06] = 1;
		if(!isdefined(self))
		{
			break;
		}
	}

	level.var_7624 = 0;
}

//Function Number: 7
lights_off(param_00,param_01,param_02)
{
	var_03 = strtok(param_00," ",param_01);
	scripts\engine\utility::array_levelthread(var_03,::lights_off_internal,param_01,param_02);
}

//Function Number: 8
func_12BE2()
{
	if(!isdefined(self.var_8BB8))
	{
		return;
	}

	while(isdefined(self.lights) && self.lights.size)
	{
		wait(0.05);
	}
}