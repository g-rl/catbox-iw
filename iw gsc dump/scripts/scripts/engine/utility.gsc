/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\engine\_utility.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 259
 * Decompile Time: 12584 ms
 * Timestamp: 10/27/2023 12:11:04 AM
*******************************************************************/

//Function Number: 1
noself_func(param_00,param_01,param_02,param_03,param_04)
{
	if(!isdefined(level.func))
	{
		return;
	}

	if(!isdefined(level.func[param_00]))
	{
		return;
	}

	if(!isdefined(param_01))
	{
		[[ level.func[param_00] ]]();
		return;
	}

	if(!isdefined(param_02))
	{
		[[ level.func[param_00] ]](param_01);
		return;
	}

	if(!isdefined(param_03))
	{
		[[ level.func[param_00] ]](param_01,param_02);
		return;
	}

	if(!isdefined(param_04))
	{
		[[ level.func[param_00] ]](param_01,param_02,param_03);
		return;
	}

	[[ level.func[param_00] ]](param_01,param_02,param_03,param_04);
}

//Function Number: 2
self_func(param_00,param_01,param_02,param_03,param_04)
{
	if(!isdefined(level.func[param_00]))
	{
		return;
	}

	if(!isdefined(param_01))
	{
		self [[ level.func[param_00] ]]();
		return;
	}

	if(!isdefined(param_02))
	{
		self [[ level.func[param_00] ]](param_01);
		return;
	}

	if(!isdefined(param_03))
	{
		self [[ level.func[param_00] ]](param_01,param_02);
		return;
	}

	if(!isdefined(param_04))
	{
		self [[ level.func[param_00] ]](param_01,param_02,param_03);
		return;
	}

	self [[ level.func[param_00] ]](param_01,param_02,param_03,param_04);
}

//Function Number: 3
anglebetweenvectors(param_00,param_01)
{
	return acos(vectordot(param_00,param_01) / length(param_00) * length(param_01));
}

//Function Number: 4
anglebetweenvectorsunit(param_00,param_01)
{
	return acos(vectordot(param_00,param_01));
}

//Function Number: 5
anglebetweenvectorssigned(param_00,param_01,param_02)
{
	var_03 = vectornormalize(param_00);
	var_04 = vectornormalize(param_01);
	var_05 = acos(clamp(vectordot(var_03,var_04),-1,1));
	var_06 = vectorcross(var_03,var_04);
	if(vectordot(var_06,param_02) < 0)
	{
		var_05 = var_05 * -1;
	}

	return var_05;
}

//Function Number: 6
segmentvssphere(param_00,param_01,param_02,param_03)
{
	if(param_00 == param_01)
	{
		return 0;
	}

	var_04 = param_02 - param_00;
	var_05 = param_01 - param_00;
	var_06 = clamp(vectordot(var_04,var_05) / vectordot(var_05,var_05),0,1);
	var_07 = param_00 + var_05 * var_06;
	return lengthsquared(param_02 - var_07) <= param_03 * param_03;
}

//Function Number: 7
randomvector(param_00)
{
	return (randomfloat(param_00) - param_00 * 0.5,randomfloat(param_00) - param_00 * 0.5,randomfloat(param_00) - param_00 * 0.5);
}

//Function Number: 8
randomvectorrange(param_00,param_01)
{
	var_02 = randomfloatrange(param_00,param_01);
	if(randomint(2) == 0)
	{
		var_02 = var_02 * -1;
	}

	var_03 = randomfloatrange(param_00,param_01);
	if(randomint(2) == 0)
	{
		var_03 = var_03 * -1;
	}

	var_04 = randomfloatrange(param_00,param_01);
	if(randomint(2) == 0)
	{
		var_04 = var_04 * -1;
	}

	return (var_02,var_03,var_04);
}

//Function Number: 9
sign(param_00)
{
	if(param_00 >= 0)
	{
		return 1;
	}

	return -1;
}

//Function Number: 10
mod(param_00,param_01)
{
	var_02 = int(param_00 / param_01);
	if(param_00 * param_01 < 0)
	{
		var_02 = var_02 - 1;
	}

	return param_00 - var_02 * param_01;
}

//Function Number: 11
get_enemy_team(param_00)
{
	var_01 = [];
	var_01["axis"] = "allies";
	var_01["allies"] = "axis";
	return var_01[param_00];
}

//Function Number: 12
clear_exception(param_00)
{
	self.exception[param_00] = level.defaultexception;
}

//Function Number: 13
cointoss()
{
	return randomint(100) >= 50;
}

//Function Number: 14
choose_from_weighted_array(param_00,param_01)
{
	var_02 = randomint(param_01[param_01.size - 1] + 1);
	for(var_03 = 0;var_03 < param_01.size;var_03++)
	{
		if(var_02 <= param_01[var_03])
		{
			return param_00[var_03];
		}
	}
}

//Function Number: 15
waittill_string(param_00,param_01)
{
	if(param_00 != "death")
	{
		self endon("death");
	}

	param_01 endon("die");
	self waittill(param_00);
	param_01 notify("returned",param_00);
}

//Function Number: 16
waittillmatch_string(param_00,param_01,param_02)
{
	if(param_01 != "death")
	{
		self endon("death");
	}

	param_02 endon("die");
	self waittillmatch(param_01,param_00);
	param_02 notify("returned",param_01);
}

//Function Number: 17
waittill_string_no_endon_death(param_00,param_01)
{
	param_01 endon("die");
	self waittill(param_00);
	param_01 notify("returned",param_00);
}

//Function Number: 18
waittill_multiple(param_00,param_01,param_02,param_03,param_04)
{
	self endon("death");
	var_05 = spawnstruct();
	var_05.threads = 0;
	if(isdefined(param_00))
	{
		childthread waittill_string(param_00,var_05);
		var_05.var_117B8++;
	}

	if(isdefined(param_01))
	{
		childthread waittill_string(param_01,var_05);
		var_05.var_117B8++;
	}

	if(isdefined(param_02))
	{
		childthread waittill_string(param_02,var_05);
		var_05.var_117B8++;
	}

	if(isdefined(param_03))
	{
		childthread waittill_string(param_03,var_05);
		var_05.var_117B8++;
	}

	if(isdefined(param_04))
	{
		childthread waittill_string(param_04,var_05);
		var_05.var_117B8++;
	}

	while(var_05.threads)
	{
		var_05 waittill("returned");
		var_05.var_117B8--;
	}

	var_05 notify("die");
}

//Function Number: 19
waittillmatch_notify(param_00,param_01,param_02)
{
	self endon("death");
	self waittillmatch(param_01,param_00);
	self notify(param_02);
}

//Function Number: 20
waittill_any_return(param_00,param_01,param_02,param_03,param_04,param_05)
{
	if((!isdefined(param_00) || param_00 != "death") && !isdefined(param_01) || param_01 != "death" && !isdefined(param_02) || param_02 != "death" && !isdefined(param_03) || param_03 != "death" && !isdefined(param_04) || param_04 != "death" && !isdefined(param_05) || param_05 != "death")
	{
		self endon("death");
	}

	var_06 = spawnstruct();
	if(isdefined(param_00))
	{
		childthread waittill_string(param_00,var_06);
	}

	if(isdefined(param_01))
	{
		childthread waittill_string(param_01,var_06);
	}

	if(isdefined(param_02))
	{
		childthread waittill_string(param_02,var_06);
	}

	if(isdefined(param_03))
	{
		childthread waittill_string(param_03,var_06);
	}

	if(isdefined(param_04))
	{
		childthread waittill_string(param_04,var_06);
	}

	if(isdefined(param_05))
	{
		childthread waittill_string(param_05,var_06);
	}

	var_06 waittill("returned",var_07);
	var_06 notify("die");
	return var_07;
}

//Function Number: 21
waittillmatch_any_return(param_00,param_01,param_02,param_03,param_04,param_05,param_06)
{
	if((!isdefined(param_01) || param_01 != "death") && !isdefined(param_02) || param_02 != "death" && !isdefined(param_03) || param_03 != "death" && !isdefined(param_04) || param_04 != "death" && !isdefined(param_05) || param_05 != "death" && !isdefined(param_06) || param_06 != "death")
	{
		self endon("death");
	}

	var_07 = spawnstruct();
	if(isdefined(param_01))
	{
		childthread waittillmatch_string(param_00,param_01,var_07);
	}

	if(isdefined(param_02))
	{
		childthread waittillmatch_string(param_00,param_02,var_07);
	}

	if(isdefined(param_03))
	{
		childthread waittillmatch_string(param_00,param_03,var_07);
	}

	if(isdefined(param_04))
	{
		childthread waittillmatch_string(param_00,param_04,var_07);
	}

	if(isdefined(param_05))
	{
		childthread waittillmatch_string(param_00,param_05,var_07);
	}

	if(isdefined(param_06))
	{
		childthread waittillmatch_string(param_00,param_06,var_07);
	}

	var_07 waittill("returned",var_08);
	var_07 notify("die");
	return var_08;
}

//Function Number: 22
waittill_any_return_no_endon_death_3(param_00,param_01,param_02,param_03,param_04,param_05)
{
	var_06 = spawnstruct();
	if(isdefined(param_00))
	{
		childthread waittill_string_no_endon_death(param_00,var_06);
	}

	if(isdefined(param_01))
	{
		childthread waittill_string_no_endon_death(param_01,var_06);
	}

	if(isdefined(param_02))
	{
		childthread waittill_string_no_endon_death(param_02,var_06);
	}

	if(isdefined(param_03))
	{
		childthread waittill_string_no_endon_death(param_03,var_06);
	}

	if(isdefined(param_04))
	{
		childthread waittill_string_no_endon_death(param_04,var_06);
	}

	if(isdefined(param_05))
	{
		childthread waittill_string_no_endon_death(param_05,var_06);
	}

	var_06 waittill("returned",var_07);
	var_06 notify("die");
	return var_07;
}

//Function Number: 23
waittill_any_in_array_return(param_00)
{
	var_01 = spawnstruct();
	var_02 = 0;
	foreach(var_04 in param_00)
	{
		childthread waittill_string(var_04,var_01);
		if(var_04 == "death")
		{
			var_02 = 1;
		}
	}

	if(!var_02)
	{
		self endon("death");
	}

	var_01 waittill("returned",var_06);
	var_01 notify("die");
	return var_06;
}

//Function Number: 24
waittill_any_in_array_return_no_endon_death(param_00)
{
	var_01 = spawnstruct();
	foreach(var_03 in param_00)
	{
		childthread waittill_string_no_endon_death(var_03,var_01);
	}

	var_01 waittill("returned",var_05);
	var_01 notify("die");
	return var_05;
}

//Function Number: 25
waittill_any_in_array_or_timeout(param_00,param_01)
{
	var_02 = spawnstruct();
	var_03 = 0;
	foreach(var_05 in param_00)
	{
		childthread waittill_string(var_05,var_02);
		if(var_05 == "death")
		{
			var_03 = 1;
		}
	}

	if(!var_03)
	{
		self endon("death");
	}

	var_02 childthread _timeout(param_01);
	var_02 waittill("returned",var_07);
	var_02 notify("die");
	return var_07;
}

//Function Number: 26
waittill_any_in_array_or_timeout_no_endon_death(param_00,param_01)
{
	var_02 = spawnstruct();
	foreach(var_04 in param_00)
	{
		childthread waittill_string_no_endon_death(var_04,var_02);
	}

	var_02 thread _timeout(param_01);
	var_02 waittill("returned",var_06);
	var_02 notify("die");
	return var_06;
}

//Function Number: 27
waittill_any_timeout_1(param_00,param_01,param_02,param_03,param_04,param_05,param_06)
{
	if((!isdefined(param_01) || param_01 != "death") && !isdefined(param_02) || param_02 != "death" && !isdefined(param_03) || param_03 != "death" && !isdefined(param_04) || param_04 != "death" && !isdefined(param_05) || param_05 != "death" && !isdefined(param_06) || param_06 != "death")
	{
		self endon("death");
	}

	var_07 = spawnstruct();
	if(isdefined(param_01))
	{
		childthread waittill_string(param_01,var_07);
	}

	if(isdefined(param_02))
	{
		childthread waittill_string(param_02,var_07);
	}

	if(isdefined(param_03))
	{
		childthread waittill_string(param_03,var_07);
	}

	if(isdefined(param_04))
	{
		childthread waittill_string(param_04,var_07);
	}

	if(isdefined(param_05))
	{
		childthread waittill_string(param_05,var_07);
	}

	if(isdefined(param_06))
	{
		childthread waittill_string(param_06,var_07);
	}

	var_07 childthread _timeout(param_00);
	var_07 waittill("returned",var_08);
	var_07 notify("die");
	return var_08;
}

//Function Number: 28
_timeout(param_00)
{
	self endon("die");
	wait(param_00);
	self notify("returned","timeout");
}

//Function Number: 29
waittill_any_timeout_no_endon_death_2(param_00,param_01,param_02,param_03,param_04,param_05)
{
	var_06 = spawnstruct();
	if(isdefined(param_01))
	{
		childthread waittill_string_no_endon_death(param_01,var_06);
	}

	if(isdefined(param_02))
	{
		childthread waittill_string_no_endon_death(param_02,var_06);
	}

	if(isdefined(param_03))
	{
		childthread waittill_string_no_endon_death(param_03,var_06);
	}

	if(isdefined(param_04))
	{
		childthread waittill_string_no_endon_death(param_04,var_06);
	}

	if(isdefined(param_05))
	{
		childthread waittill_string_no_endon_death(param_05,var_06);
	}

	var_06 childthread _timeout(param_00);
	var_06 waittill("returned",var_07);
	var_06 notify("die");
	return var_07;
}

//Function Number: 30
waittill_any_3(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07)
{
	if(isdefined(param_01))
	{
		self endon(param_01);
	}

	if(isdefined(param_02))
	{
		self endon(param_02);
	}

	if(isdefined(param_03))
	{
		self endon(param_03);
	}

	if(isdefined(param_04))
	{
		self endon(param_04);
	}

	if(isdefined(param_05))
	{
		self endon(param_05);
	}

	if(isdefined(param_06))
	{
		self endon(param_06);
	}

	if(isdefined(param_07))
	{
		self endon(param_07);
	}

	self waittill(param_00);
}

//Function Number: 31
waittill_any_ents(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B,param_0C,param_0D)
{
	if(isdefined(param_02) && isdefined(param_03))
	{
		param_02 endon(param_03);
	}

	if(isdefined(param_04) && isdefined(param_05))
	{
		param_04 endon(param_05);
	}

	if(isdefined(param_06) && isdefined(param_07))
	{
		param_06 endon(param_07);
	}

	if(isdefined(param_08) && isdefined(param_09))
	{
		param_08 endon(param_09);
	}

	if(isdefined(param_0A) && isdefined(param_0B))
	{
		param_0A endon(param_0B);
	}

	if(isdefined(param_0C) && isdefined(param_0D))
	{
		param_0C endon(param_0D);
	}

	param_00 waittill(param_01);
}

//Function Number: 32
isflashed()
{
	if(!isdefined(self.flashendtime))
	{
		return 0;
	}

	return gettime() < self.flashendtime;
}

//Function Number: 33
flag_exist(param_00)
{
	if(!isdefined(level.flag))
	{
		return 0;
	}

	return isdefined(level.flag[param_00]);
}

//Function Number: 34
flag(param_00)
{
	return level.flag[param_00];
}

//Function Number: 35
flag_init(param_00)
{
	if(!isdefined(level.flag))
	{
		scripts\common\flags::init_flags();
	}

	level.flag[param_00] = 0;
	init_trigger_flags();
	if(!isdefined(level.trigger_flags[param_00]))
	{
		level.trigger_flags[param_00] = [];
	}

	if(getsubstr(param_00,0,3) == "aa_")
	{
		thread [[ level.func["sp_stat_tracking_func"] ]](param_00);
	}
}

//Function Number: 36
empty_init_func(param_00)
{
}

//Function Number: 37
flag_set(param_00,param_01)
{
	level.flag[param_00] = 1;
	set_trigger_flag_permissions(param_00);
	if(isdefined(param_01))
	{
		level notify(param_00,param_01);
		return;
	}

	level notify(param_00);
}

//Function Number: 38
flag_wait(param_00)
{
	var_01 = undefined;
	while(!flag(param_00))
	{
		var_01 = undefined;
		level waittill(param_00,var_01);
	}

	if(isdefined(var_01))
	{
		return var_01;
	}
}

//Function Number: 39
flag_clear(param_00)
{
	if(!flag(param_00))
	{
		return;
	}

	level.flag[param_00] = 0;
	set_trigger_flag_permissions(param_00);
	level notify(param_00);
}

//Function Number: 40
flag_waitopen(param_00)
{
	while(flag(param_00))
	{
		level waittill(param_00);
	}
}

//Function Number: 41
waittill_either(param_00,param_01)
{
	self endon(param_00);
	self waittill(param_01);
	return param_01;
}

//Function Number: 42
array_thread_safe(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B)
{
	if(!isdefined(param_03))
	{
		foreach(var_0D in param_00)
		{
			var_0D thread [[ param_01 ]]();
			wait(param_02);
		}

		return;
	}

	if(!isdefined(param_07))
	{
		foreach(var_0F in param_03)
		{
			var_0F thread [[ param_03 ]](param_05);
			wait(param_04);
		}

		return;
	}

	if(!isdefined(param_0A))
	{
		foreach(var_11 in param_05)
		{
			var_11 thread [[ param_05 ]](param_07,param_08);
			wait(param_06);
		}

		return;
	}

	if(!isdefined(var_0D))
	{
		foreach(var_13 in param_07)
		{
			var_13 thread [[ param_07 ]](param_09,param_0A,param_0B);
			wait(param_08);
		}

		return;
	}

	if(!isdefined(var_10))
	{
		foreach(var_15 in param_09)
		{
			var_15 thread [[ param_09 ]](param_0B,var_0C,var_0D,var_0E);
			wait(param_0A);
		}

		return;
	}

	if(!isdefined(var_13))
	{
		foreach(var_17 in param_0B)
		{
			var_17 thread [[ param_0B ]](var_0D,var_0E,var_0F,var_10,var_11);
			wait(var_0C);
		}

		return;
	}

	if(!isdefined(var_16))
	{
		foreach(var_19 in var_0D)
		{
			var_19 thread [[ var_0D ]](var_0F,var_10,var_11,var_12,var_13,var_14);
			wait(var_0E);
		}

		return;
	}

	if(!isdefined(var_19))
	{
		foreach(var_1B in var_0F)
		{
			var_1B thread [[ var_0F ]](var_11,var_12,var_13,var_14,var_15,var_16,var_17);
			wait(var_10);
		}

		return;
	}

	if(!isdefined(var_1C))
	{
		foreach(var_1D in var_11)
		{
			var_1D thread [[ var_11 ]](var_13,var_14,var_15,var_16,var_17,var_18,var_19,var_1A);
			wait(var_12);
		}

		return;
	}

	foreach(var_1F in var_13)
	{
		var_1F thread [[ var_13 ]](var_15,var_16,var_17,var_18,var_19,var_1A,var_1B,var_1C,var_1D);
		wait(var_14);
	}
}

//Function Number: 43
array_thread(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A)
{
	if(isdefined(param_0A))
	{
		foreach(var_0C in param_00)
		{
			var_0C thread [[ param_01 ]](param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A);
		}

		return;
	}

	if(isdefined(var_0C))
	{
		foreach(var_0E in param_03)
		{
			var_0E thread [[ param_03 ]](param_04,param_05,param_06,param_07,param_08,param_09,param_0A,var_0B);
		}

		return;
	}

	if(isdefined(var_0D))
	{
		foreach(var_10 in param_05)
		{
			var_10 thread [[ param_05 ]](param_06,param_07,param_08,param_09,param_0A,var_0B,var_0C);
		}

		return;
	}

	if(isdefined(var_0E))
	{
		foreach(var_12 in param_07)
		{
			var_12 thread [[ param_07 ]](param_08,param_09,param_0A,var_0B,var_0C,var_0D);
		}

		return;
	}

	if(isdefined(var_0F))
	{
		foreach(var_14 in param_09)
		{
			var_14 thread [[ param_09 ]](param_0A,var_0B,var_0C,var_0D,var_0E);
		}

		return;
	}

	if(isdefined(var_10))
	{
		foreach(var_16 in var_0B)
		{
			var_16 thread [[ var_0B ]](var_0C,var_0D,var_0E,var_0F);
		}

		return;
	}

	if(isdefined(var_11))
	{
		foreach(var_18 in var_0D)
		{
			var_18 thread [[ var_0D ]](var_0E,var_0F,var_10);
		}

		return;
	}

	if(isdefined(var_12))
	{
		foreach(var_1A in var_0F)
		{
			var_1A thread [[ var_0F ]](var_10,var_11);
		}

		return;
	}

	if(isdefined(var_13))
	{
		foreach(var_1C in var_11)
		{
			var_1C thread [[ var_11 ]](var_12);
		}

		return;
	}

	foreach(var_1E in var_13)
	{
		var_1E thread [[ var_13 ]]();
	}
}

//Function Number: 44
array_call(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09)
{
	if(isdefined(param_09))
	{
		foreach(var_0B in param_00)
		{
			var_0B [[ param_01 ]](param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09);
		}

		return;
	}

	if(isdefined(var_0B))
	{
		foreach(var_0D in param_03)
		{
			var_0D [[ param_03 ]](param_04,param_05,param_06,param_07,param_08,param_09,var_0A);
		}

		return;
	}

	if(isdefined(var_0C))
	{
		foreach(var_0F in param_05)
		{
			var_0F [[ param_05 ]](param_06,param_07,param_08,param_09,var_0A,var_0B);
		}

		return;
	}

	if(isdefined(var_0D))
	{
		foreach(var_11 in param_07)
		{
			var_11 [[ param_07 ]](param_08,param_09,var_0A,var_0B,var_0C);
		}

		return;
	}

	if(isdefined(var_0E))
	{
		foreach(var_13 in param_09)
		{
			var_13 [[ param_09 ]](var_0A,var_0B,var_0C,var_0D);
		}

		return;
	}

	if(isdefined(var_0F))
	{
		foreach(var_15 in var_0B)
		{
			var_15 [[ var_0B ]](var_0C,var_0D,var_0E);
		}

		return;
	}

	if(isdefined(var_10))
	{
		foreach(var_17 in var_0D)
		{
			var_17 [[ var_0D ]](var_0E,var_0F);
		}

		return;
	}

	if(isdefined(var_11))
	{
		foreach(var_19 in var_0F)
		{
			var_19 [[ var_0F ]](var_10);
		}

		return;
	}

	foreach(var_1B in var_11)
	{
		var_1B [[ var_11 ]]();
	}
}

//Function Number: 45
trigger_on(param_00,param_01)
{
	if(isdefined(param_00) && isdefined(param_01))
	{
		var_02 = getentarray(param_00,param_01);
		array_thread(var_02,::trigger_on_proc);
		return;
	}

	trigger_on_proc();
}

//Function Number: 46
trigger_on_proc()
{
	if(isdefined(self.realorigin))
	{
		self.origin = self.realorigin;
	}

	self.trigger_off = undefined;
}

//Function Number: 47
trigger_off(param_00,param_01)
{
	if(isdefined(param_00) && isdefined(param_01))
	{
		var_02 = getentarray(param_00,param_01);
		array_thread(var_02,::trigger_off_proc);
		return;
	}

	trigger_off_proc();
}

//Function Number: 48
trigger_off_proc()
{
	if(!isdefined(self.realorigin))
	{
		self.realorigin = self.origin;
	}

	if(self.origin == self.realorigin)
	{
		self.origin = self.origin + (0,0,-10000);
	}

	self.trigger_off = 1;
	self notify("trigger_off");
}

//Function Number: 49
set_trigger_flag_permissions(param_00)
{
	if(!isdefined(level.trigger_flags))
	{
		return;
	}

	level.trigger_flags[param_00] = array_removeundefined(level.trigger_flags[param_00]);
	array_thread(level.trigger_flags[param_00],::update_trigger_based_on_flags);
}

//Function Number: 50
update_trigger_based_on_flags()
{
	var_00 = 1;
	if(isdefined(self.script_flag_true))
	{
		var_00 = 0;
		var_01 = create_flags_and_return_tokens(self.script_flag_true);
		foreach(var_03 in var_01)
		{
			if(flag(var_03))
			{
				var_00 = 1;
				break;
			}
		}
	}

	var_05 = 1;
	if(isdefined(self.script_flag_false))
	{
		var_01 = create_flags_and_return_tokens(self.script_flag_false);
		foreach(var_03 in var_01)
		{
			if(flag(var_03))
			{
				var_05 = 0;
				break;
			}
		}
	}

	[[ level.trigger_func[var_00 && var_05] ]]();
}

//Function Number: 51
create_flags_and_return_tokens(param_00)
{
	var_01 = strtok(param_00," ");
	for(var_02 = 0;var_02 < var_01.size;var_02++)
	{
		if(!isdefined(level.flag[var_01[var_02]]))
		{
			flag_init(var_01[var_02]);
		}
	}

	return var_01;
}

//Function Number: 52
init_trigger_flags()
{
	if(!add_init_script("trigger_flags",::init_trigger_flags))
	{
		return;
	}

	level.trigger_flags = [];
	level.trigger_func[1] = ::trigger_on;
	level.trigger_func[0] = ::trigger_off;
}

//Function Number: 53
getstruct(param_00,param_01)
{
	var_02 = level.struct_class_names[param_01][param_00];
	if(!isdefined(var_02))
	{
		return undefined;
	}

	if(var_02.size > 1)
	{
		return undefined;
	}

	return var_02[0];
}

//Function Number: 54
getstructarray(param_00,param_01)
{
	var_02 = level.struct_class_names[param_01][param_00];
	if(!isdefined(var_02))
	{
		return [];
	}

	return var_02;
}

//Function Number: 55
struct_class_init()
{
	if(!add_init_script("struct_classes",::struct_class_init))
	{
		return;
	}

	level.struct_class_names = [];
	level.struct_class_names["target"] = [];
	level.struct_class_names["targetname"] = [];
	level.struct_class_names["script_noteworthy"] = [];
	level.struct_class_names["script_linkname"] = [];
	foreach(var_03, var_01 in level.struct)
	{
		if(isdefined(var_01.var_336))
		{
			if(var_01.var_336 == "delete_on_load")
			{
				level.struct[var_03] = undefined;
				continue;
			}

			if(!isdefined(level.struct_class_names["targetname"][var_01.var_336]))
			{
				level.struct_class_names["targetname"][var_01.var_336] = [];
			}

			var_02 = level.struct_class_names["targetname"][var_01.var_336].size;
			level.struct_class_names["targetname"][var_01.var_336][var_02] = var_01;
		}

		if(isdefined(var_01.target))
		{
			if(!isdefined(level.struct_class_names["target"][var_01.target]))
			{
				level.struct_class_names["target"][var_01.target] = [];
			}

			var_02 = level.struct_class_names["target"][var_01.target].size;
			level.struct_class_names["target"][var_01.target][var_02] = var_01;
		}

		if(isdefined(var_01.script_noteworthy))
		{
			if(!isdefined(level.struct_class_names["script_noteworthy"][var_01.script_noteworthy]))
			{
				level.struct_class_names["script_noteworthy"][var_01.script_noteworthy] = [];
			}

			var_02 = level.struct_class_names["script_noteworthy"][var_01.script_noteworthy].size;
			level.struct_class_names["script_noteworthy"][var_01.script_noteworthy][var_02] = var_01;
		}

		if(isdefined(var_01.destroynavobstacle))
		{
			if(!isdefined(level.struct_class_names["script_linkname"][var_01.destroynavobstacle]))
			{
				level.struct_class_names["script_linkname"][var_01.destroynavobstacle] = [];
			}

			var_02 = level.struct_class_names["script_linkname"][var_01.destroynavobstacle].size;
			level.struct_class_names["script_linkname"][var_01.destroynavobstacle][var_02] = var_01;
		}
	}
}

//Function Number: 56
fileprint_start(param_00)
{
}

//Function Number: 57
fileprint_map_start()
{
}

//Function Number: 58
fileprint_map_header(param_00)
{
	if(!isdefined(param_00))
	{
		param_00 = 0;
	}
}

//Function Number: 59
fileprint_map_keypairprint(param_00,param_01)
{
}

//Function Number: 60
fileprint_map_entity_start()
{
}

//Function Number: 61
fileprint_map_entity_end()
{
}

//Function Number: 62
fileprint_radiant_vec(param_00)
{
}

//Function Number: 63
array_remove(param_00,param_01)
{
	var_02 = [];
	foreach(var_04 in param_00)
	{
		if(var_04 != param_01)
		{
			var_02[var_02.size] = var_04;
		}
	}

	return var_02;
}

//Function Number: 64
array_remove_array(param_00,param_01)
{
	foreach(var_03 in param_01)
	{
		param_00 = array_remove(param_00,var_03);
	}

	return param_00;
}

//Function Number: 65
array_removeundefined(param_00)
{
	var_01 = [];
	foreach(var_03 in param_00)
	{
		if(!isdefined(var_03))
		{
			continue;
		}

		var_01[var_01.size] = var_03;
	}

	return var_01;
}

//Function Number: 66
array_remove_duplicates(param_00)
{
	var_01 = [];
	foreach(var_03 in param_00)
	{
		if(!isdefined(var_03))
		{
			continue;
		}

		var_04 = 1;
		foreach(var_06 in var_01)
		{
			if(var_03 == var_06)
			{
				var_04 = 0;
				break;
			}
		}

		if(var_04)
		{
			var_01[var_01.size] = var_03;
		}
	}

	return var_01;
}

//Function Number: 67
array_levelthread(param_00,param_01,param_02,param_03,param_04)
{
	if(isdefined(param_04))
	{
		foreach(var_06 in param_00)
		{
			thread [[ param_01 ]](var_06,param_02,param_03,param_04);
		}

		return;
	}

	if(isdefined(var_06))
	{
		foreach(var_08 in param_03)
		{
			thread [[ param_03 ]](var_08,param_04,var_05);
		}

		return;
	}

	if(isdefined(var_07))
	{
		foreach(var_0A in var_05)
		{
			thread [[ var_05 ]](var_0A,var_06);
		}

		return;
	}

	foreach(var_0C in var_07)
	{
		thread [[ var_07 ]](var_0C);
	}
}

//Function Number: 68
array_levelcall(param_00,param_01,param_02,param_03,param_04)
{
	if(isdefined(param_04))
	{
		foreach(var_06 in param_00)
		{
			[[ param_01 ]](var_06,param_02,param_03,param_04);
		}

		return;
	}

	if(isdefined(var_06))
	{
		foreach(var_08 in param_03)
		{
			[[ param_03 ]](var_08,param_04,var_05);
		}

		return;
	}

	if(isdefined(var_07))
	{
		foreach(var_0A in var_05)
		{
			[[ var_05 ]](var_0A,var_06);
		}

		return;
	}

	foreach(var_0C in var_07)
	{
		[[ var_07 ]](var_0C);
	}
}

//Function Number: 69
array_add_safe(param_00,param_01)
{
	if(!isdefined(param_01))
	{
		return param_00;
	}

	if(!isdefined(param_00))
	{
		param_00[0] = param_01;
	}
	else
	{
		param_00[param_00.size] = param_01;
	}

	return param_00;
}

//Function Number: 70
exist_in_array_MAYBE(param_00,param_01)
{
	var_02 = 0;
	if(param_00.size > 0)
	{
		foreach(var_04 in param_00)
		{
			if(var_04 == param_01)
			{
				var_02 = 1;
				break;
			}
		}
	}

	return var_02;
}

//Function Number: 71
delaycall(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B,param_0C,param_0D)
{
	thread delaycall_proc(param_01,param_00,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B,param_0C,param_0D);
}

//Function Number: 72
delaycall_proc(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B,param_0C,param_0D)
{
	if(issp())
	{
		self endon("death");
		self endon("stop_delay_call");
	}

	wait(param_01);
	if(isdefined(param_0D))
	{
		self [[ param_00 ]](param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B,param_0C,param_0D);
		return;
	}

	if(isdefined(param_0C))
	{
		self [[ param_00 ]](param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B,param_0C);
		return;
	}

	if(isdefined(param_0B))
	{
		self [[ param_00 ]](param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B);
		return;
	}

	if(isdefined(param_0A))
	{
		self [[ param_00 ]](param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A);
		return;
	}

	if(isdefined(param_09))
	{
		self [[ param_00 ]](param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09);
		return;
	}

	if(isdefined(param_08))
	{
		self [[ param_00 ]](param_02,param_03,param_04,param_05,param_06,param_07,param_08);
		return;
	}

	if(isdefined(param_07))
	{
		self [[ param_00 ]](param_02,param_03,param_04,param_05,param_06,param_07);
		return;
	}

	if(isdefined(param_06))
	{
		self [[ param_00 ]](param_02,param_03,param_04,param_05,param_06);
		return;
	}

	if(isdefined(param_05))
	{
		self [[ param_00 ]](param_02,param_03,param_04,param_05);
		return;
	}

	if(isdefined(param_04))
	{
		self [[ param_00 ]](param_02,param_03,param_04);
		return;
	}

	if(isdefined(param_03))
	{
		self [[ param_00 ]](param_02,param_03);
		return;
	}

	if(isdefined(param_02))
	{
		self [[ param_00 ]](param_02);
		return;
	}

	self [[ param_00 ]]();
}

//Function Number: 73
issp()
{
	if(!isdefined(level.issp))
	{
		var_00 = getdvar("mapname");
		var_01 = "";
		for(var_02 = 0;var_02 < min(var_00.size,3);var_02++)
		{
			var_01 = var_01 + var_00[var_02];
		}

		level.issp = var_01 != "mp_" && var_01 != "cp_";
	}

	return level.issp;
}

//Function Number: 74
iscp()
{
	return string_starts_with(getdvar("mapname"),"cp_");
}

//Function Number: 75
issp_towerdefense()
{
	if(!isdefined(level.issp_towerdefense))
	{
		level.issp_towerdefense = string_starts_with(getdvar("mapname"),"so_td_");
	}

	return level.issp_towerdefense;
}

//Function Number: 76
string_starts_with(param_00,param_01)
{
	if(param_00.size < param_01.size)
	{
		return 0;
	}

	var_02 = getsubstr(param_00,0,param_01.size);
	if(var_02 == param_01)
	{
		return 1;
	}

	return 0;
}

//Function Number: 77
plot_points(param_00,param_01,param_02,param_03,param_04)
{
	var_05 = param_00[0];
	if(!isdefined(param_01))
	{
		param_01 = 1;
	}

	if(!isdefined(param_02))
	{
		param_02 = 1;
	}

	if(!isdefined(param_03))
	{
		param_03 = 1;
	}

	if(!isdefined(param_04))
	{
		param_04 = 0.05;
	}

	for(var_06 = 1;var_06 < param_00.size;var_06++)
	{
		thread draw_line_for_time(var_05,param_00[var_06],param_01,param_02,param_03,param_04);
		var_05 = param_00[var_06];
	}
}

//Function Number: 78
draw_line_for_time(param_00,param_01,param_02,param_03,param_04,param_05)
{
	param_05 = gettime() + param_05 * 1000;
	while(gettime() < param_05)
	{
		wait(0.05);
	}
}

//Function Number: 79
array_combine(param_00,param_01,param_02,param_03)
{
	var_04 = [];
	if(isdefined(param_00))
	{
		foreach(var_06 in param_00)
		{
			var_04[var_04.size] = var_06;
		}
	}

	if(isdefined(param_01))
	{
		foreach(var_06 in param_01)
		{
			var_04[var_04.size] = var_06;
		}
	}

	if(isdefined(param_02))
	{
		foreach(var_06 in param_02)
		{
			var_04[var_04.size] = var_06;
		}
	}

	if(isdefined(param_03))
	{
		foreach(var_06 in param_03)
		{
			var_04[var_04.size] = var_06;
		}
	}

	return var_04;
}

//Function Number: 80
array_combine_multiple(param_00)
{
	var_01 = [];
	foreach(var_03 in param_00)
	{
		foreach(var_05 in var_03)
		{
			var_01[var_01.size] = var_05;
		}
	}

	return var_01;
}

//Function Number: 81
array_combine_unique(param_00,param_01)
{
	var_02 = [];
	foreach(var_04 in param_00)
	{
		var_02[var_02.size] = var_04;
	}

	foreach(var_04 in param_01)
	{
		if(array_contains(var_02,var_04))
		{
			continue;
		}

		var_02[var_02.size] = var_04;
	}

	return var_02;
}

//Function Number: 82
array_combine_non_integer_indices(param_00,param_01)
{
	var_02 = [];
	foreach(var_05, var_04 in param_00)
	{
		var_02[var_05] = var_04;
	}

	foreach(var_05, var_04 in param_01)
	{
		var_02[var_05] = var_04;
	}

	return var_02;
}

//Function Number: 83
array_randomize(param_00)
{
	for(var_01 = 0;var_01 <= param_00.size - 2;var_01++)
	{
		var_02 = randomintrange(var_01,param_00.size - 1);
		var_03 = param_00[var_01];
		param_00[var_01] = param_00[var_02];
		param_00[var_02] = var_03;
	}

	return param_00;
}

//Function Number: 84
array_randomize_objects(param_00)
{
	var_01 = [];
	for(var_02 = param_00;var_02.size > 0;var_02 = var_04)
	{
		var_03 = randomintrange(0,var_02.size);
		var_04 = [];
		var_05 = 0;
		foreach(var_08, var_07 in var_02)
		{
			if(var_05 == var_03)
			{
				var_01[ter_op(isstring(var_08),var_08,var_01.size)] = var_07;
			}
			else
			{
				var_04[ter_op(isstring(var_08),var_08,var_04.size)] = var_07;
			}

			var_05++;
		}
	}

	return var_01;
}

//Function Number: 85
array_add(param_00,param_01)
{
	param_00[param_00.size] = param_01;
	return param_00;
}

//Function Number: 86
array_insert(param_00,param_01,param_02)
{
	if(param_02 == param_00.size)
	{
		var_03 = param_00;
		var_03[var_03.size] = param_01;
		return var_03;
	}

	var_03 = [];
	var_04 = 0;
	for(var_05 = 0;var_05 < param_00.size;var_05++)
	{
		if(var_05 == param_02)
		{
			var_03[var_05] = param_01;
			var_04 = 1;
		}

		var_03[var_05 + var_04] = param_00[var_05];
	}

	return var_03;
}

//Function Number: 87
array_contains(param_00,param_01)
{
	if(param_00.size <= 0)
	{
		return 0;
	}

	foreach(var_03 in param_00)
	{
		if(var_03 == param_01)
		{
			return 1;
		}
	}

	return 0;
}

//Function Number: 88
array_find(param_00,param_01)
{
	foreach(var_04, var_03 in param_00)
	{
		if(var_03 == param_01)
		{
			return var_04;
		}
	}

	return undefined;
}

//Function Number: 89
flat_angle(param_00)
{
	var_01 = (0,param_00[1],0);
	return var_01;
}

//Function Number: 90
flat_origin(param_00)
{
	var_01 = (param_00[0],param_00[1],0);
	return var_01;
}

//Function Number: 91
flatten_vector(param_00,param_01)
{
	if(!isdefined(param_01))
	{
		param_01 = (0,0,1);
	}

	var_02 = vectornormalize(param_00 - vectordot(param_01,param_00) * param_01);
	return var_02;
}

//Function Number: 92
draw_arrow_time(param_00,param_01,param_02,param_03)
{
	level endon("newpath");
	var_04 = [];
	var_05 = vectortoangles(param_00 - param_01);
	var_06 = anglestoright(var_05);
	var_07 = anglestoforward(var_05);
	var_08 = anglestoup(var_05);
	var_09 = distance(param_00,param_01);
	var_0A = [];
	var_0B = 0.1;
	var_0A[0] = param_00;
	var_0A[1] = param_00 + var_06 * var_09 * var_0B + var_07 * var_09 * -0.1;
	var_0A[2] = param_01;
	var_0A[3] = param_00 + var_06 * var_09 * -1 * var_0B + var_07 * var_09 * -0.1;
	var_0A[4] = param_00;
	var_0A[5] = param_00 + var_08 * var_09 * var_0B + var_07 * var_09 * -0.1;
	var_0A[6] = param_01;
	var_0A[7] = param_00 + var_08 * var_09 * -1 * var_0B + var_07 * var_09 * -0.1;
	var_0A[8] = param_00;
	var_0C = param_02[0];
	var_0D = param_02[1];
	var_0E = param_02[2];
	plot_points(var_0A,var_0C,var_0D,var_0E,param_03);
}

//Function Number: 93
get_links()
{
	return strtok(self.script_linkto," ");
}

//Function Number: 94
draw_arrow(param_00,param_01,param_02)
{
	level endon("newpath");
	var_03 = [];
	var_04 = vectortoangles(param_00 - param_01);
	var_05 = anglestoright(var_04);
	var_06 = anglestoforward(var_04);
	var_07 = distance(param_00,param_01);
	var_08 = [];
	var_09 = 0.05;
	var_08[0] = param_00;
	var_08[1] = param_00 + var_05 * var_07 * var_09 + var_06 * var_07 * -0.2;
	var_08[2] = param_01;
	var_08[3] = param_00 + var_05 * var_07 * -1 * var_09 + var_06 * var_07 * -0.2;
	for(var_0A = 0;var_0A < 4;var_0A++)
	{
		var_0B = var_0A + 1;
		if(var_0B >= 4)
		{
			var_0B = 0;
		}
	}
}

//Function Number: 95
draw_capsule(param_00,param_01,param_02,param_03,param_04,param_05,param_06)
{
	if(!isdefined(param_03))
	{
		param_03 = (0,0,0);
	}

	if(!isdefined(param_05))
	{
		param_05 = 0;
	}

	if(!isdefined(param_06))
	{
		param_06 = 1;
	}

	var_07 = anglestoforward(param_03);
	var_08 = anglestoright(param_03);
	var_09 = anglestoup(param_03);
	var_0A = param_00 + var_09 * param_01;
	var_0B = param_00 + var_09 * param_02;
	var_0B = var_0B - var_09 * param_01;
	var_0C = var_0A + var_07 * param_01;
	var_0D = var_0B + var_07 * param_01;
	var_0E = var_0A - var_07 * param_01;
	var_0F = var_0B - var_07 * param_01;
	var_10 = var_0A + var_08 * param_01;
	var_11 = var_0B + var_08 * param_01;
	var_12 = var_0A - var_08 * param_01;
	var_13 = var_0B - var_08 * param_01;
}

//Function Number: 96
draw_character_capsule(param_00,param_01,param_02)
{
	var_03 = self physics_getcharactercollisioncapsule();
	draw_capsule(self getorigin(),var_03["radius"],var_03["half_height"] * 2,self.angles,param_00,param_01,param_02);
}

//Function Number: 97
draw_player_capsule(param_00,param_01,param_02)
{
	var_03 = self physics_getcharactercollisioncapsule();
	draw_capsule(self getorigin(),var_03["radius"],var_03["half_height"] * 2,self getplayerangles(),param_00,param_01,param_02);
}

//Function Number: 98
draw_ent_bone_forever(param_00,param_01)
{
	self endon("stop_drawing_axis");
	self endon("death");
	for(;;)
	{
		var_02 = self gettagorigin(param_00);
		var_03 = self gettagangles(param_00);
		draw_angles(var_03,var_02,param_01);
		waitframe();
	}
}

//Function Number: 99
draw_ent_axis_forever(param_00,param_01)
{
	self endon("stop_drawing_axis");
	self endon("death");
	for(;;)
	{
		draw_ent_axis(param_00,undefined,param_01);
		waitframe();
	}
}

//Function Number: 100
draw_ent_axis(param_00,param_01,param_02)
{
	waittillframeend;
	if(isdefined(self.angles))
	{
		var_03 = self.angles;
	}
	else
	{
		var_03 = (0,0,0);
	}

	draw_angles(var_03,self.origin,param_00,param_01,param_02);
}

//Function Number: 101
draw_angles(param_00,param_01,param_02,param_03,param_04)
{
	waittillframeend;
	var_05 = anglestoforward(param_00);
	var_06 = anglestoright(param_00);
	var_07 = anglestoup(param_00);
	if(!isdefined(param_02))
	{
		param_02 = (1,0,1);
	}

	if(!isdefined(param_03))
	{
		param_03 = 1;
	}

	if(!isdefined(param_04))
	{
		param_04 = 10;
	}
}

//Function Number: 102
draw_entity_bounds(param_00,param_01,param_02,param_03,param_04)
{
	if(!isdefined(param_02))
	{
		param_02 = (0,1,0);
	}

	if(!isdefined(param_03))
	{
		param_03 = 0;
	}

	if(!isdefined(param_04))
	{
		param_04 = 0.05;
	}

	if(param_03)
	{
		var_05 = int(param_04 / 0.05);
	}
	else
	{
		var_05 = int(param_02 / 0.05);
	}

	var_06 = [];
	var_07 = [];
	var_08 = gettime();
	var_09 = var_08 + param_01 * 1000;
	while(var_08 < var_09 && isdefined(param_00))
	{
		var_06[0] = param_00 getpointinbounds(1,1,1);
		var_06[1] = param_00 getpointinbounds(1,1,-1);
		var_06[2] = param_00 getpointinbounds(-1,1,-1);
		var_06[3] = param_00 getpointinbounds(-1,1,1);
		var_07[0] = param_00 getpointinbounds(1,-1,1);
		var_07[1] = param_00 getpointinbounds(1,-1,-1);
		var_07[2] = param_00 getpointinbounds(-1,-1,-1);
		var_07[3] = param_00 getpointinbounds(-1,-1,1);
		for(var_0A = 0;var_0A < 4;var_0A++)
		{
			var_0B = var_0A + 1;
			if(var_0B == 4)
			{
				var_0B = 0;
			}
		}

		if(!param_03)
		{
			return;
		}

		wait(param_04);
		var_08 = gettime();
	}
}

//Function Number: 103
getfx(param_00)
{
	return level._effect[param_00];
}

//Function Number: 104
fxexists(param_00)
{
	return isdefined(level._effect[param_00]);
}

//Function Number: 105
getlastweapon()
{
	return self.saved_lastweapon;
}

//Function Number: 106
playerunlimitedammothread()
{
}

//Function Number: 107
isusabilityallowed()
{
	return !isdefined(self.disabledusability) || !self.disabledusability;
}

//Function Number: 108
allow_usability(param_00)
{
	if(param_00)
	{
		if(!isdefined(self.disabledusability))
		{
			self.disabledusability = 0;
		}

		self.var_55E4--;
		if(!self.disabledusability)
		{
			self enableusability();
			return;
		}

		return;
	}

	if(!isdefined(self.disabledusability))
	{
		self.disabledusability = 0;
	}

	self.var_55E4++;
	self disableusability();
}

//Function Number: 109
allow_weapon(param_00)
{
	if(param_00)
	{
		if(!isdefined(self.disabledweapon))
		{
			self.disabledweapon = 0;
		}

		self.var_55E6--;
		if(!self.disabledweapon)
		{
			self enableweapons();
			if(isdefined(level.allow_weapon_func))
			{
				self [[ level.allow_weapon_func ]](1);
				return;
			}

			return;
		}

		return;
	}

	if(!isdefined(self.disabledweapon))
	{
		self.disabledweapon = 0;
	}

	if(!self.disabledweapon)
	{
		if(isdefined(level.allow_weapon_func))
		{
			self [[ level.allow_weapon_func ]](0);
		}

		self getradiuspathsighttestnodes();
	}

	self.var_55E6++;
}

//Function Number: 110
isweaponallowed()
{
	return !isdefined(self.disabledweapon) || !self.disabledweapon;
}

//Function Number: 111
allow_weapon_switch(param_00)
{
	if(param_00)
	{
		if(!isdefined(self.disabledweaponswitch))
		{
			self.disabledweaponswitch = 0;
		}

		self.disabledweaponswitch--;
		if(!self.disabledweaponswitch)
		{
			self enableweaponswitch();
			return;
		}

		return;
	}

	if(!isdefined(self.disabledweaponswitch))
	{
		self.disabledweaponswitch = 0;
	}

	self.disabledweaponswitch++;
	self getraidspawnpoint();
}

//Function Number: 112
allow_offhand_weapons(param_00)
{
	if(param_00)
	{
		if(!isdefined(self.disabledoffhandweapons))
		{
			self.disabledoffhandweapons = 0;
		}

		self.var_55D9--;
		if(!self.disabledoffhandweapons)
		{
			self enableoffhandweapons();
		}

		if(!isdefined(level.ismp) || level.ismp == 0)
		{
			allow_offhand_shield_weapons(1);
			return;
		}

		return;
	}

	if(!isdefined(self.disabledoffhandweapons))
	{
		self.disabledoffhandweapons = 0;
	}

	self.var_55D9++;
	self getquadrant();
	if(!isdefined(level.ismp) || level.ismp == 0)
	{
		allow_offhand_shield_weapons(0);
	}
}

//Function Number: 113
allow_offhand_primary_weapons(param_00)
{
	if(param_00)
	{
		if(!isdefined(self.disabledoffhandprimaryweapons))
		{
			self.disabledoffhandprimaryweapons = 0;
		}
		else
		{
			self.var_55D6--;
		}

		if(!self.disabledoffhandprimaryweapons)
		{
			self grenade_earthquakeatposition_internal();
			return;
		}

		return;
	}

	if(!isdefined(self.disabledoffhandprimaryweapons))
	{
		self.disabledoffhandprimaryweapons = 0;
	}

	self.var_55D6++;
	self grenade_earthquakeatposition();
}

//Function Number: 114
allow_offhand_secondary_weapons(param_00)
{
	if(param_00)
	{
		if(!isdefined(self.disabledoffhandsecondaryweapons))
		{
			self.disabledoffhandsecondaryweapons = 0;
		}
		else
		{
			self.var_55D7--;
		}

		if(!self.disabledoffhandsecondaryweapons)
		{
			self enableoffhandsecondaryweapons();
		}

		allow_offhand_shield_weapons(1);
		return;
	}

	if(!isdefined(self.disabledoffhandsecondaryweapons))
	{
		self.disabledoffhandsecondaryweapons = 0;
	}

	self.var_55D7++;
	self disableoffhandsecondaryweapons();
	allow_offhand_shield_weapons(0);
}

//Function Number: 115
allow_offhand_shield_weapons(param_00)
{
	if(param_00)
	{
		if(!isdefined(self.disabledoffhandshieldweapons))
		{
			self.disabledoffhandshieldweapons = 0;
		}

		self.var_55D8--;
		if(!self.disabledoffhandshieldweapons)
		{
			self allowoffhandshieldweapons(1);
			return;
		}

		return;
	}

	if(!isdefined(self.disabledoffhandshieldweapons))
	{
		self.disabledoffhandshieldweapons = 0;
	}

	self.var_55D8++;
	self allowoffhandshieldweapons(0);
}

//Function Number: 116
isweaponswitchallowed()
{
	return !isdefined(self.disabledweaponswitch) || !self.disabledweaponswitch;
}

//Function Number: 117
isoffhandweaponsallowed()
{
	return !isdefined(self.disabledoffhandweapons) || !self.disabledoffhandweapons;
}

//Function Number: 118
isoffhandprimaryweaponsallowed()
{
	return !isdefined(self.disabledoffhandprimaryweapons) || !self.disabledoffhandprimaryweapons;
}

//Function Number: 119
isoffhandsecondaryweaponsallowed()
{
	return !isdefined(self.disabledoffhandsecondaryweapons) || !self.disabledoffhandsecondaryweapons;
}

//Function Number: 120
allow_prone(param_00)
{
	if(param_00)
	{
		if(!isdefined(self.disabledprone))
		{
			self.disabledprone = 0;
		}
		else
		{
			self.var_55DC--;
		}

		if(!self.disabledprone)
		{
			self allowprone(1);
			return;
		}

		return;
	}

	if(!isdefined(self.disabledprone))
	{
		self.disabledprone = 0;
	}

	self.var_55DC++;
	self allowprone(0);
}

//Function Number: 121
allow_crouch(param_00)
{
	if(param_00)
	{
		if(!isdefined(self.disabledcrouch))
		{
			self.disabledcrouch = 0;
		}
		else
		{
			self.var_55C3--;
		}

		if(!self.disabledcrouch)
		{
			self allowcrouch(1);
			return;
		}

		return;
	}

	if(!isdefined(self.disabledcrouch))
	{
		self.disabledcrouch = 0;
	}

	self.var_55C3++;
	self allowcrouch(0);
}

//Function Number: 122
allow_stances(param_00)
{
	if(param_00)
	{
		if(!isdefined(self.disabledstances))
		{
			self.disabledstances = 0;
		}
		else
		{
			self.var_55E2--;
		}

		if(!self.disabledstances)
		{
			self allowstand(1);
			return;
		}

		return;
	}

	if(!isdefined(self.disabledstances))
	{
		self.disabledstances = 0;
	}

	self.var_55E2++;
	self allowstand(0);
}

//Function Number: 123
allow_sprint(param_00)
{
	if(param_00)
	{
		if(!isdefined(self.disabledsprint))
		{
			self.disabledsprint = 0;
		}
		else
		{
			self.var_55E1--;
		}

		if(!self.disabledsprint)
		{
			self getnumownedagentsonteambytype(1);
			return;
		}

		return;
	}

	if(!isdefined(self.disabledsprint))
	{
		self.disabledsprint = 0;
	}

	self.var_55E1++;
	self getnumownedagentsonteambytype(0);
}

//Function Number: 124
allow_mantle(param_00)
{
	if(param_00)
	{
		if(!isdefined(self.disabledmantle))
		{
			self.disabledmantle = 0;
		}
		else
		{
			self.var_55D4--;
		}

		if(!self.disabledmantle)
		{
			self allowmantle(1);
			return;
		}

		return;
	}

	if(!isdefined(self.disabledmantle))
	{
		self.disabledmantle = 0;
	}

	self.var_55D4++;
	self allowmantle(0);
}

//Function Number: 125
allow_fire(param_00)
{
	if(param_00)
	{
		if(!isdefined(self.disabledfire))
		{
			self.disabledfire = 0;
		}
		else
		{
			self.var_55C8--;
		}

		if(!self.disabledfire)
		{
			self allowfire(1);
			return;
		}

		return;
	}

	if(!isdefined(self.disabledfire))
	{
		self.disabledfire = 0;
	}

	self.var_55C8++;
	self allowfire(0);
}

//Function Number: 126
allow_ads(param_00)
{
	if(param_00)
	{
		if(!isdefined(self.disabledads))
		{
			self.disabledads = 0;
		}
		else
		{
			self.var_55BE--;
		}

		if(!self.disabledads)
		{
			self allowads(1);
			return;
		}

		return;
	}

	if(!isdefined(self.disabledads))
	{
		self.disabledads = 0;
	}

	self.var_55BE++;
	self allowads(0);
}

//Function Number: 127
allow_jump(param_00)
{
	if(param_00)
	{
		if(!isdefined(self.disabledjump))
		{
			self.disabledjump = 0;
		}
		else
		{
			self.var_55D0--;
		}

		if(!self.disabledjump)
		{
			self allowjump(1);
			return;
		}

		return;
	}

	if(!isdefined(self.disabledjump))
	{
		self.disabledjump = 0;
	}

	self.var_55D0++;
	self allowjump(0);
}

//Function Number: 128
allow_wallrun(param_00)
{
	if(param_00)
	{
		if(!isdefined(self.disabledwallrun))
		{
			self.disabledwallrun = 0;
		}
		else
		{
			self.var_55E5--;
		}

		if(!self.disabledwallrun)
		{
			self allowwallrun(1);
			return;
		}

		return;
	}

	if(!isdefined(self.disabledwallrun))
	{
		self.disabledwallrun = 0;
	}

	self.var_55E5++;
	self allowwallrun(0);
}

//Function Number: 129
allow_doublejump(param_00)
{
	if(param_00)
	{
		if(!isdefined(self.disableddoublejump))
		{
			self.disableddoublejump = 0;
		}
		else
		{
			self.var_55C6--;
		}

		if(!self.disableddoublejump)
		{
			self goal_radius(0,self.doublejumpenergy);
			self goalflag(0,self.doublejumpenergyrestorerate);
			self.doublejumpenergy = undefined;
			self.doublejumpenergyrestorerate = undefined;
			self allowdoublejump(1);
			return;
		}

		return;
	}

	if(!isdefined(self.disableddoublejump))
	{
		self.disableddoublejump = 0;
	}

	if(self.disableddoublejump == 0)
	{
		self.doublejumpenergy = self goal_position(0);
		self.doublejumpenergyrestorerate = self energy_getrestorerate(0);
		self goal_radius(0,0);
		self goalflag(0,0);
	}

	self.var_55C6++;
	self allowdoublejump(0);
}

//Function Number: 130
allow_melee(param_00)
{
	if(param_00)
	{
		if(!isdefined(self.disabledmelee))
		{
			self.disabledmelee = 0;
		}
		else
		{
			self.var_55D5--;
		}

		if(!self.disabledmelee)
		{
			self allowmelee(1);
			return;
		}

		return;
	}

	if(!isdefined(self.disabledmelee))
	{
		self.disabledmelee = 0;
	}

	self.var_55D5++;
	self allowmelee(0);
}

//Function Number: 131
allow_slide(param_00)
{
	if(param_00)
	{
		if(!isdefined(self.disabledslide))
		{
			self.disabledslide = 0;
		}
		else
		{
			self.var_55E0--;
		}

		if(!self.disabledslide)
		{
			self allowslide(1);
			return;
		}

		return;
	}

	if(!isdefined(self.disabledslide))
	{
		self.disabledslide = 0;
	}

	self.var_55E0++;
	self allowslide(0);
}

//Function Number: 132
get_doublejumpenergy()
{
	if(!isdefined(self.doublejumpenergy))
	{
		return self goal_position(0);
	}

	return self.doublejumpenergy;
}

//Function Number: 133
set_doublejumpenergy(param_00)
{
	if(!isdefined(self.doublejumpenergy))
	{
		self goal_radius(0,param_00);
		return;
	}

	self.doublejumpenergy = param_00;
}

//Function Number: 134
get_doublejumpenergyrestorerate()
{
	if(!isdefined(self.doublejumpenergyrestorerate))
	{
		return self energy_getrestorerate(0);
	}

	return self.doublejumpenergyrestorerate;
}

//Function Number: 135
set_doublejumpenergyrestorerate(param_00)
{
	if(!isdefined(self.doublejumpenergyrestorerate))
	{
		self goalflag(0,param_00);
		return;
	}

	self.doublejumpenergyrestorerate = param_00;
}

//Function Number: 136
random(param_00)
{
	var_01 = [];
	foreach(var_03 in param_00)
	{
		var_01[var_01.size] = var_03;
	}

	if(!var_01.size)
	{
		return undefined;
	}

	return var_01[randomint(var_01.size)];
}

//Function Number: 137
random_weight_sorted(param_00)
{
	var_01 = [];
	foreach(var_03 in param_00)
	{
		var_01[var_01.size] = var_03;
	}

	if(!var_01.size)
	{
		return undefined;
	}

	var_05 = randomint(var_01.size * var_01.size);
	return var_01[var_01.size - 1 - int(sqrt(var_05))];
}

//Function Number: 138
spawn_tag_origin(param_00,param_01)
{
	if(!isdefined(param_01) && isdefined(self.angles))
	{
		param_01 = self.angles;
	}

	if(!isdefined(param_00) && isdefined(self.origin))
	{
		param_00 = self.origin;
	}
	else if(!isdefined(param_00))
	{
		param_00 = (0,0,0);
	}

	var_02 = spawn("script_model",param_00);
	var_02 setmodel("tag_origin");
	var_02 hide();
	if(isdefined(param_01))
	{
		var_02.angles = param_01;
	}

	return var_02;
}

//Function Number: 139
waittill_notify_or_timeout(param_00,param_01)
{
	self endon(param_00);
	wait(param_01);
}

//Function Number: 140
waittill_notify_or_timeout_return(param_00,param_01)
{
	self endon(param_00);
	wait(param_01);
	return "timeout";
}

//Function Number: 141
waittill_notify_and_time(param_00,param_01)
{
	var_02 = gettime();
	self waittill(param_00);
	var_03 = var_02 + param_01 * 1000;
	var_04 = var_03 - var_02;
	if(var_04 > 0)
	{
		var_05 = var_04 / 1000;
		wait(var_05);
	}
}

//Function Number: 142
fileprint_launcher_start_file()
{
	level.fileprintlauncher_linecount = 0;
	level.fileprint_launcher = 1;
	fileprint_launcher("GAMEPRINTSTARTFILE:");
}

//Function Number: 143
fileprint_launcher(param_00)
{
	level.fileprintlauncher_linecount++;
	if(level.fileprintlauncher_linecount > 200)
	{
		wait(0.05);
		level.fileprintlauncher_linecount = 0;
	}
}

//Function Number: 144
fileprint_launcher_end_file(param_00,param_01)
{
	if(!isdefined(param_01))
	{
		param_01 = 0;
	}

	if(param_01)
	{
		fileprint_launcher("GAMEPRINTENDFILE:GAMEPRINTP4ENABLED:" + param_00);
	}
	else
	{
		fileprint_launcher("GAMEPRINTENDFILE:" + param_00);
	}

	var_02 = gettime() + 4000;
	while(getdvarint("LAUNCHER_PRINT_SUCCESS") == 0 && getdvar("LAUNCHER_PRINT_FAIL") == "0" && gettime() < var_02)
	{
		wait(0.05);
	}

	if(!gettime() < var_02)
	{
		iprintlnbold("LAUNCHER_PRINT_FAIL:( TIMEOUT ): launcherconflict? restart launcher and try again? ");
		level.fileprint_launcher = undefined;
		return 0;
	}

	var_03 = getdvar("LAUNCHER_PRINT_FAIL");
	if(var_03 != "0")
	{
		iprintlnbold("LAUNCHER_PRINT_FAIL:( " + var_03 + " ): launcherconflict? restart launcher and try again? ");
		level.fileprint_launcher = undefined;
		return 0;
	}

	iprintlnbold("Launcher write to file successful!");
	level.fileprint_launcher = undefined;
	return 1;
}

//Function Number: 145
launcher_write_clipboard(param_00)
{
	level.fileprintlauncher_linecount = 0;
	fileprint_launcher("LAUNCHER_CLIP:" + param_00);
}

//Function Number: 146
activate_individual_exploder()
{
	scripts\common\exploder::activate_individual_exploder_proc();
}

//Function Number: 147
waitframe()
{
	wait(0.05);
}

//Function Number: 148
get_target_ent(param_00)
{
	if(!isdefined(param_00))
	{
		param_00 = self.target;
	}

	var_01 = getent(param_00,"targetname");
	if(isdefined(var_01))
	{
		return var_01;
	}

	if(issp())
	{
		var_01 = [[ level.getnodefunction ]](param_00,"targetname");
		if(isdefined(var_01))
		{
			return var_01;
		}

		var_01 = [[ level.func["getspawner"] ]](param_00,"targetname");
		if(isdefined(var_01))
		{
			return var_01;
		}
	}

	var_01 = getstruct(param_00,"targetname");
	if(isdefined(var_01))
	{
		return var_01;
	}

	var_01 = getvehiclenode(param_00,"targetname");
	if(isdefined(var_01))
	{
		return var_01;
	}
}

//Function Number: 149
do_earthquake(param_00,param_01)
{
	var_02 = level.earthquake[param_00];
	earthquake(var_02["magnitude"],var_02["duration"],param_01,var_02["radius"]);
}

//Function Number: 150
play_loopsound_in_space(param_00,param_01)
{
	var_02 = spawn("script_origin",(0,0,0));
	if(!isdefined(param_01))
	{
		param_01 = self.origin;
	}

	var_02.origin = param_01;
	var_02 playloopsound(param_00);
	return var_02;
}

//Function Number: 151
play_sound_in_space_with_angles(param_00,param_01,param_02,param_03,param_04)
{
	var_05 = spawn("script_origin",(0,0,1));
	if(!isdefined(param_01))
	{
		param_01 = self.origin;
	}

	var_05.origin = param_01;
	var_05.angles = param_02;
	if(isdefined(param_04))
	{
		var_05 linkto(param_04);
	}

	if(issp())
	{
		if(isdefined(param_03) && param_03)
		{
			var_05 playsoundasmaster(param_00,"sounddone");
		}
		else
		{
			var_05 playsound(param_00,"sounddone");
		}

		var_05 waittill("sounddone");
	}
	else if(isdefined(param_03) && param_03)
	{
		var_05 playsoundasmaster(param_00);
	}
	else
	{
		var_05 playsound(param_00);
	}

	var_05 delete();
}

//Function Number: 152
play_sound_in_space(param_00,param_01,param_02,param_03)
{
	play_sound_in_space_with_angles(param_00,param_01,(0,0,0),param_02,param_03);
}

//Function Number: 153
loop_fx_sound(param_00,param_01,param_02,param_03,param_04)
{
	loop_fx_sound_with_angles(param_00,param_01,(0,0,0),param_02,param_03,param_04);
}

//Function Number: 154
loop_fx_sound_with_angles(param_00,param_01,param_02,param_03,param_04,param_05,param_06)
{
	if(isdefined(param_03) && param_03)
	{
		if(!isdefined(level.first_frame) || level.first_frame == 1)
		{
			function_01E3(param_00,param_01,param_02);
			return;
		}

		return;
	}

	if(level.createfx_enabled && isdefined(param_05.loopsound_ent))
	{
		var_07 = param_05.loopsound_ent;
	}
	else
	{
		var_07 = spawn("script_origin",(0,0,0));
	}

	if(isdefined(param_04))
	{
		thread loop_sound_delete(param_04,var_07);
		self endon(param_04);
	}

	var_07.origin = param_01;
	var_07.angles = param_02;
	var_07 playloopsound(param_00);
	if(level.createfx_enabled)
	{
		param_05.loopsound_ent = var_07;
		return;
	}

	var_07 willneverchange();
}

//Function Number: 155
loop_fx_sound_interval(param_00,param_01,param_02,param_03,param_04,param_05)
{
	loop_fx_sound_interval_with_angles(param_00,param_01,(0,0,0),param_02,param_03,param_04,param_05);
}

//Function Number: 156
loop_fx_sound_interval_with_angles(param_00,param_01,param_02,param_03,param_04,param_05,param_06)
{
	self.origin = param_01;
	self.angles = param_02;
	if(isdefined(param_03))
	{
		self endon(param_03);
	}

	if(param_05 >= param_06)
	{
		wait(0.05);
	}

	if(!soundexists(param_00))
	{
		wait(0.05);
	}

	for(;;)
	{
		wait(randomfloatrange(param_05,param_06));
		lock("createfx_looper");
		thread play_sound_in_space_with_angles(param_00,self.origin,self.angles,undefined);
		unlock("createfx_looper");
	}
}

//Function Number: 157
loop_sound_delete(param_00,param_01)
{
	param_01 endon("death");
	self waittill(param_00);
	param_01 delete();
}

//Function Number: 158
createloopeffect(param_00)
{
	var_01 = scripts\common\createfx::createeffect("loopfx",param_00);
	var_01.v["delay"] = scripts\common\createfx::getloopeffectdelaydefault();
	return var_01;
}

//Function Number: 159
createoneshoteffect(param_00)
{
	var_01 = scripts\common\createfx::createeffect("oneshotfx",param_00);
	var_01.v["delay"] = scripts\common\createfx::getoneshoteffectdelaydefault();
	return var_01;
}

//Function Number: 160
createexploder(param_00)
{
	var_01 = scripts\common\createfx::createeffect("exploder",param_00);
	var_01.v["delay"] = scripts\common\createfx::getexploderdelaydefault();
	var_01.v["exploder_type"] = "normal";
	return var_01;
}

//Function Number: 161
alphabetize(param_00)
{
	if(param_00.size <= 1)
	{
		return param_00;
	}

	var_01 = 0;
	for(var_02 = param_00.size - 1;var_02 >= 1;var_02--)
	{
		var_03 = param_00[var_02];
		var_04 = var_02;
		for(var_05 = 0;var_05 < var_02;var_05++)
		{
			var_06 = param_00[var_05];
			if(stricmp(var_06,var_03) > 0)
			{
				var_03 = var_06;
				var_04 = var_05;
			}
		}

		if(var_04 != var_02)
		{
			param_00[var_04] = param_00[var_02];
			param_00[var_02] = var_03;
		}
	}

	return param_00;
}

//Function Number: 162
play_loop_sound_on_entity(param_00,param_01)
{
	var_02 = spawn("script_origin",(0,0,0));
	var_02 endon("death");
	thread delete_on_death(var_02);
	if(isdefined(param_01))
	{
		var_02.origin = self.origin + param_01;
		var_02.angles = self.angles;
		var_02 linkto(self);
	}
	else
	{
		var_02.origin = self.origin;
		var_02.angles = self.angles;
		var_02 linkto(self);
	}

	var_02 playloopsound(param_00);
	self waittill("stop sound" + param_00);
	var_02 stoploopsound(param_00);
	var_02 delete();
}

//Function Number: 163
stop_loop_sound_on_entity(param_00)
{
	self notify("stop sound" + param_00);
}

//Function Number: 164
delete_on_death(param_00)
{
	param_00 endon("death");
	self waittill("death");
	if(isdefined(param_00))
	{
		param_00 delete();
	}
}

//Function Number: 165
error(param_00)
{
	waitframe();
}

//Function Number: 166
exploder(param_00,param_01,param_02)
{
	[[ level._fx.exploderfunction ]](param_00,param_01,param_02);
}

//Function Number: 167
ter_op(param_00,param_01,param_02)
{
	if(param_00)
	{
		return param_01;
	}

	return param_02;
}

//Function Number: 168
create_lock(param_00,param_01)
{
	if(!isdefined(param_01))
	{
		param_01 = 1;
	}

	if(!isdefined(level.lock))
	{
		level.lock = [];
	}

	var_02 = spawnstruct();
	var_02.max_count = param_01;
	var_02.var_C1 = 0;
	level.lock[param_00] = var_02;
}

//Function Number: 169
lock(param_00)
{
	for(var_01 = level.lock[param_00];var_01.var_C1 >= var_01.max_count;var_01 waittill("unlocked"))
	{
	}

	var_01.var_C1++;
}

//Function Number: 170
unlock(param_00)
{
	thread unlock_thread(param_00);
}

//Function Number: 171
unlock_thread(param_00)
{
	wait(0.05);
	var_01 = level.lock[param_00];
	var_01.var_C1--;
	var_01 notify("unlocked");
}

//Function Number: 172
get_template_script_MAYBE()
{
	var_00 = level.script;
	if(isdefined(level.template_script))
	{
		var_00 = level.template_script;
	}

	return var_00;
}

//Function Number: 173
is_player_gamepad_enabled()
{
	if(!level.console)
	{
		var_00 = self usinggamepad();
		if(isdefined(var_00))
		{
			return var_00;
		}
		else
		{
			return 0;
		}
	}

	return 1;
}

//Function Number: 174
array_reverse(param_00)
{
	var_01 = [];
	for(var_02 = param_00.size - 1;var_02 >= 0;var_02--)
	{
		var_01[var_01.size] = param_00[var_02];
	}

	return var_01;
}

//Function Number: 175
distance_2d_squared(param_00,param_01)
{
	return length2dsquared(param_00 - param_01);
}

//Function Number: 176
get_array_of_farthest(param_00,param_01,param_02,param_03,param_04,param_05)
{
	var_06 = get_array_of_closest(param_00,param_01,param_02,param_03,param_04,param_05);
	var_06 = array_reverse(var_06);
	return var_06;
}

//Function Number: 177
get_array_of_closest(param_00,param_01,param_02,param_03,param_04,param_05)
{
	if(!isdefined(param_03))
	{
		param_03 = param_01.size;
	}

	if(!isdefined(param_02))
	{
		param_02 = [];
	}

	var_06 = undefined;
	if(isdefined(param_04))
	{
		var_06 = param_04 * param_04;
	}

	var_07 = 0;
	if(isdefined(param_05))
	{
		var_07 = param_05 * param_05;
	}

	if(param_02.size == 0 && param_03 >= param_01.size && var_07 == 0 && !isdefined(var_06))
	{
		return sortbydistance(param_01,param_00);
	}

	var_08 = [];
	foreach(var_0A in param_01)
	{
		var_0B = 0;
		foreach(var_0D in param_02)
		{
			if(var_0A == var_0D)
			{
				var_0B = 1;
				break;
			}
		}

		if(var_0B)
		{
			continue;
		}

		var_0F = distancesquared(param_00,var_0A.origin);
		if(isdefined(var_06) && var_0F > var_06)
		{
			continue;
		}

		if(var_0F < var_07)
		{
			continue;
		}

		var_08[var_08.size] = var_0A;
	}

	var_08 = sortbydistance(var_08,param_00);
	if(param_03 >= var_08.size)
	{
		return var_08;
	}

	var_11 = [];
	for(var_12 = 0;var_12 < param_03;var_12++)
	{
		var_11[var_12] = var_08[var_12];
	}

	return var_11;
}

//Function Number: 178
drop_to_ground(param_00,param_01,param_02)
{
	if(!isdefined(param_01))
	{
		param_01 = 1500;
	}

	if(!isdefined(param_02))
	{
		param_02 = -12000;
	}

	return physicstrace(param_00 + (0,0,param_01),param_00 + (0,0,param_02));
}

//Function Number: 179
within_fov(param_00,param_01,param_02,param_03)
{
	var_04 = vectornormalize(param_02 - param_00);
	var_05 = anglestoforward(param_01);
	var_06 = vectordot(var_05,var_04);
	return var_06 >= param_03;
}

//Function Number: 180
make_entity_sentient_mp(param_00,param_01)
{
	if(isdefined(level.bot_funcs) && isdefined(level.bot_funcs["bots_make_entity_sentient"]))
	{
		return self [[ level.bot_funcs["bots_make_entity_sentient"] ]](param_00,param_01);
	}
}

//Function Number: 181
ai_3d_sighting_model(param_00)
{
	if(isdefined(level.bot_funcs) && isdefined(level.bot_funcs["ai_3d_sighting_model"]))
	{
		return self [[ level.bot_funcs["ai_3d_sighting_model"] ]](param_00);
	}
}

//Function Number: 182
getclosest(param_00,param_01,param_02)
{
	if(!isdefined(param_02))
	{
		param_02 = 500000;
	}

	var_03 = undefined;
	foreach(var_05 in param_01)
	{
		var_06 = distance(var_05.origin,param_00);
		if(var_06 >= param_02)
		{
			continue;
		}

		param_02 = var_06;
		var_03 = var_05;
	}

	return var_03;
}

//Function Number: 183
missile_settargetandflightmode(param_00,param_01,param_02)
{
	param_02 = ter_op(isdefined(param_02),param_02,(0,0,0));
	self missile_settargetent(param_00,param_02);
	switch(param_01)
	{
		case "direct":
			self missile_setflightmodedirect();
			break;

		case "top":
			self missile_setflightmodetop();
			break;
	}
}

//Function Number: 184
add_fx(param_00,param_01)
{
	if(!isdefined(level._effect))
	{
		level._effect = [];
	}

	level._effect[param_00] = loadfx(param_01);
}

//Function Number: 185
array_sort_with_func(param_00,param_01)
{
	for(var_02 = 1;var_02 < param_00.size;var_02++)
	{
		var_03 = param_00[var_02];
		for(var_04 = var_02 - 1;var_04 >= 0 && ![[ param_01 ]](param_00[var_04],var_03);var_04--)
		{
			param_00[var_04 + 1] = param_00[var_04];
		}

		param_00[var_04 + 1] = var_03;
	}

	return param_00;
}

//Function Number: 186
add_func_ref_MAYBE(param_00,param_01)
{
	if(!isdefined(level.func))
	{
		level.func = [];
	}

	level.func[param_00] = param_01;
}

//Function Number: 187
init_empty_func_ref_MAYBE(param_00)
{
	if(!isdefined(level.func))
	{
		level.func = [];
	}

	if(!isdefined(level.func[param_00]))
	{
		add_func_ref_MAYBE(param_00,::empty_init_func);
	}
}

//Function Number: 188
add_init_script(param_00,param_01)
{
	if(!isdefined(level.init_script))
	{
		level.init_script = [];
	}

	if(isdefined(level.init_script[param_00]))
	{
		return 0;
	}

	level.init_script[param_00] = param_01;
	return 1;
}

//Function Number: 189
func_D959()
{
}

//Function Number: 190
func_C953()
{
	if(getdvar("g_connectpaths") == "2")
	{
		level waittill("eternity");
	}
}

//Function Number: 191
getdamagetype(param_00)
{
	if(!isdefined(param_00))
	{
		return "unknown";
	}

	param_00 = tolower(param_00);
	switch(param_00)
	{
		case "melee":
		case "mod_crush":
		case "mod_melee":
			return "melee";

		case "bullet":
		case "mod_rifle_bullet":
		case "mod_pistol_bullet":
			return "bullet";

		case "splash":
		case "mod_explosive":
		case "mod_projectile_splash":
		case "mod_projectile":
		case "mod_grenade_splash":
		case "mod_grenade":
			return "splash";

		case "mod_impact":
			return "impact";

		case "unknown":
			return "unknown";

		default:
			return "unknown";
	}
}

//Function Number: 192
add_frame_event(param_00)
{
	if(!isdefined(self.frame_events))
	{
		self.frame_events = [param_00];
		thread process_frame_events();
		return;
	}

	self.frame_events[self.frame_events.size] = param_00;
}

//Function Number: 193
process_frame_events()
{
	for(;;)
	{
		if(isdefined(self))
		{
			foreach(var_01 in self.frame_events)
			{
				self thread [[ var_01 ]]();
			}
		}
		else
		{
			break;
		}

		wait(0.05);
	}
}

//Function Number: 194
delaythread(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07)
{
	thread delaythread_proc(param_01,param_00,param_02,param_03,param_04,param_05,param_06,param_07);
}

//Function Number: 195
delaythread_proc(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07)
{
	self endon("death");
	self endon("stop_delay_thread");
	wait(param_01);
	if(isdefined(param_07))
	{
		thread [[ param_00 ]](param_02,param_03,param_04,param_05,param_06,param_07);
		return;
	}

	if(isdefined(param_06))
	{
		thread [[ param_00 ]](param_02,param_03,param_04,param_05,param_06);
		return;
	}

	if(isdefined(param_05))
	{
		thread [[ param_00 ]](param_02,param_03,param_04,param_05);
		return;
	}

	if(isdefined(param_04))
	{
		thread [[ param_00 ]](param_02,param_03,param_04);
		return;
	}

	if(isdefined(param_03))
	{
		thread [[ param_00 ]](param_02,param_03);
		return;
	}

	if(isdefined(param_02))
	{
		thread [[ param_00 ]](param_02);
		return;
	}

	thread [[ param_00 ]]();
}

//Function Number: 196
isprotectedbyriotshield(param_00)
{
	if(isdefined(param_00.hasriotshield) && param_00.hasriotshield)
	{
		var_01 = self.origin - param_00.origin;
		var_02 = vectornormalize((var_01[0],var_01[1],0));
		var_03 = anglestoforward(param_00.angles);
		var_04 = vectordot(var_03,var_01);
		if(param_00.hasriotshieldequipped)
		{
			if(var_04 > 0.766)
			{
				return 1;
			}
		}
		else if(var_04 < -0.766)
		{
			return 1;
		}
	}

	return 0;
}

//Function Number: 197
isprotectedbyaxeblock(param_00)
{
	var_01 = 0;
	var_02 = self getcurrentweapon();
	var_03 = self adsbuttonpressed();
	var_04 = 0;
	var_05 = 0;
	var_06 = 0;
	var_07 = anglestoforward(self.angles);
	var_08 = vectornormalize(param_00.origin - self.origin);
	var_09 = vectordot(var_08,var_07);
	if(var_09 > 0.5)
	{
		var_04 = 1;
	}

	if(var_02 == "iw6_axe_mp" || var_02 == "iw7_axe_zm")
	{
		var_06 = self getcurrentweaponclipammo();
		var_05 = 1;
	}

	if(var_05 && var_03 && var_04 && var_06 > 0)
	{
		self setweaponammoclip(var_02,var_06 - 1);
		self playsound("crate_impact");
		earthquake(0.75,0.5,self.origin,100);
		var_01 = 1;
	}

	return var_01;
}

//Function Number: 198
isairdropmarker(param_00)
{
	switch(param_00)
	{
		case "airdrop_escort_marker_mp":
		case "airdrop_tank_marker_mp":
		case "airdrop_juggernaut_maniac_mp":
		case "airdrop_juggernaut_def_mp":
		case "airdrop_juggernaut_mp":
		case "airdrop_sentry_marker_mp":
		case "airdrop_mega_marker_mp":
		case "airdrop_marker_support_mp":
		case "airdrop_marker_assault_mp":
		case "airdrop_marker_mp":
			return 1;

		default:
			return 0;
	}
}

//Function Number: 199
isdestructibleweapon(param_00)
{
	if(!isdefined(param_00))
	{
		return 0;
	}

	switch(param_00)
	{
		case "barrel_mp":
		case "destructible_toy":
		case "destructible_car":
		case "destructible":
			return 1;
	}

	return 0;
}

//Function Number: 200
weaponclass(param_00)
{
	if(isdefined(param_00) && param_00 != "" && param_00 != "none")
	{
		var_01 = getweaponbasename(param_00);
		if(var_01 == "iw7_emc")
		{
			return "pistol";
		}

		if(var_01 == "iw7_devastator")
		{
			return "spread";
		}

		if(var_01 == "iw7_steeldragon")
		{
			return "beam";
		}
	}

	return weaponclass(param_00);
}

//Function Number: 201
damagelocationisany(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B)
{
	if(isdefined(self.var_DD))
	{
		if(!isdefined(param_00))
		{
			return 0;
		}

		if(self.var_DD == param_00)
		{
			return 1;
		}

		if(!isdefined(param_01))
		{
			return 0;
		}

		if(self.var_DD == param_01)
		{
			return 1;
		}

		if(!isdefined(param_02))
		{
			return 0;
		}

		if(self.var_DD == param_02)
		{
			return 1;
		}

		if(!isdefined(param_03))
		{
			return 0;
		}

		if(self.var_DD == param_03)
		{
			return 1;
		}

		if(!isdefined(param_04))
		{
			return 0;
		}

		if(self.var_DD == param_04)
		{
			return 1;
		}

		if(!isdefined(param_05))
		{
			return 0;
		}

		if(self.var_DD == param_05)
		{
			return 1;
		}

		if(!isdefined(param_06))
		{
			return 0;
		}

		if(self.var_DD == param_06)
		{
			return 1;
		}

		if(!isdefined(param_07))
		{
			return 0;
		}

		if(self.var_DD == param_07)
		{
			return 1;
		}

		if(!isdefined(param_08))
		{
			return 0;
		}

		if(self.var_DD == param_08)
		{
			return 1;
		}

		if(!isdefined(param_09))
		{
			return 0;
		}

		if(self.var_DD == param_09)
		{
			return 1;
		}

		if(!isdefined(param_0A))
		{
			return 0;
		}

		if(self.var_DD == param_0A)
		{
			return 1;
		}
	}

	return damagesubpartlocationisany(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B);
}

//Function Number: 202
damagesubpartlocationisany(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B)
{
	if(!isdefined(self.damagedsubpart))
	{
		return 0;
	}

	if(!isdefined(param_00))
	{
		return 0;
	}

	if(self.damagedsubpart == param_00)
	{
		return 1;
	}

	if(!isdefined(param_01))
	{
		return 0;
	}

	if(self.damagedsubpart == param_01)
	{
		return 1;
	}

	if(!isdefined(param_02))
	{
		return 0;
	}

	if(self.damagedsubpart == param_02)
	{
		return 1;
	}

	if(!isdefined(param_03))
	{
		return 0;
	}

	if(self.damagedsubpart == param_03)
	{
		return 1;
	}

	if(!isdefined(param_04))
	{
		return 0;
	}

	if(self.damagedsubpart == param_04)
	{
		return 1;
	}

	if(!isdefined(param_05))
	{
		return 0;
	}

	if(self.damagedsubpart == param_05)
	{
		return 1;
	}

	if(!isdefined(param_06))
	{
		return 0;
	}

	if(self.damagedsubpart == param_06)
	{
		return 1;
	}

	if(!isdefined(param_07))
	{
		return 0;
	}

	if(self.damagedsubpart == param_07)
	{
		return 1;
	}

	if(!isdefined(param_08))
	{
		return 0;
	}

	if(self.damagedsubpart == param_08)
	{
		return 1;
	}

	if(!isdefined(param_09))
	{
		return 0;
	}

	if(self.damagedsubpart == param_09)
	{
		return 1;
	}

	if(!isdefined(param_0A))
	{
		return 0;
	}

	if(self.damagedsubpart == param_0A)
	{
		return 1;
	}

	return 0;
}

//Function Number: 203
isbulletdamage(param_00)
{
	var_01 = "MOD_RIFLE_BULLET MOD_PISTOL_BULLET MOD_HEAD_SHOT";
	if(issubstr(var_01,param_00))
	{
		return 1;
	}

	return 0;
}

//Function Number: 204
isnodecoverleft(param_00)
{
	return param_00.type == "Cover Left";
}

//Function Number: 205
isnodecoverright(param_00)
{
	return param_00.type == "Cover Right";
}

//Function Number: 206
isnode3d(param_00)
{
	return isnodecover3d(param_00) || isnodeexposed3d(param_00);
}

//Function Number: 207
isnodecover3d(param_00)
{
	return param_00.type == "Cover Stand 3D" || param_00.type == "Cover 3D";
}

//Function Number: 208
isnodeexposed3d(param_00)
{
	return param_00.type == "Exposed 3D" || param_00.type == "Path 3D";
}

//Function Number: 209
isnodecovercrouch(param_00)
{
	return param_00.type == "Cover Crouch" || param_00.type == "Cover Crouch Window" || param_00.type == "Conceal Crouch";
}

//Function Number: 210
absangleclamp180(param_00)
{
	return abs(angleclamp180(param_00));
}

//Function Number: 211
getaimyawtopoint(param_00)
{
	var_01 = getyawtospot(param_00);
	var_02 = distance(self.origin,param_00);
	if(var_02 > 3)
	{
		var_03 = asin(-3 / var_02);
		var_01 = var_01 - var_03;
	}

	var_01 = angleclamp180(var_01);
	return var_01;
}

//Function Number: 212
getyawtospot(param_00)
{
	if(actor_is3d())
	{
		var_01 = anglestoforward(self.angles);
		var_02 = rotatepointaroundvector(var_01,param_00 - self.origin,self.angles[2] * -1);
		param_00 = var_02 + self.origin;
	}

	var_03 = getyaw(param_00) - self.angles[1];
	var_03 = angleclamp180(var_03);
	return var_03;
}

//Function Number: 213
getyaw(param_00)
{
	return vectortoyaw(param_00 - self.origin);
}

//Function Number: 214
getaimyawtopoint3d(param_00)
{
	var_01 = getyawtospot3d(param_00);
	var_02 = distance(self.origin,param_00);
	if(var_02 > 3)
	{
		var_03 = asin(-3 / var_02);
		var_01 = var_01 - var_03;
	}

	var_01 = angleclamp180(var_01);
	return var_01;
}

//Function Number: 215
getyawtospot3d(param_00)
{
	var_01 = param_00 - self.origin;
	var_02 = rotatevectorinverted(var_01,self.angles);
	var_03 = vectortoyaw(var_02);
	var_04 = angleclamp180(var_03);
	return var_04;
}

//Function Number: 216
getaimpitchtopoint3d(param_00)
{
	var_01 = getpitchtospot3d(param_00);
	var_02 = distance(self.origin,param_00);
	if(var_02 > 3)
	{
		var_03 = asin(-3 / var_02);
		var_01 = var_01 - var_03;
	}

	var_01 = angleclamp180(var_01);
	return var_01;
}

//Function Number: 217
getpitchtospot3d(param_00)
{
	var_01 = param_00 - self.origin;
	var_02 = rotatevectorinverted(var_01,self.angles);
	var_03 = function_02D1(var_02);
	var_04 = angleclamp180(var_03);
	return var_04;
}

//Function Number: 218
actor_isspace()
{
	return istrue(self.isent);
}

//Function Number: 219
actor_is3d()
{
	return actor_isspace();
}

//Function Number: 220
getpredictedaimyawtoshootentorpos(param_00,param_01,param_02)
{
	if(!isdefined(param_01))
	{
		if(!isdefined(param_02))
		{
			return 0;
		}

		return getaimyawtopoint(param_02);
	}

	var_03 = (0,0,0);
	if(isplayer(param_01))
	{
		var_03 = param_01 getvelocity();
	}
	else if(isai(param_01))
	{
		var_03 = param_01.var_381;
	}

	var_04 = param_01.origin + var_03 * param_00;
	return getaimyawtopoint(var_04);
}

//Function Number: 221
getpredictedaimyawtoshootentorpos3d(param_00,param_01,param_02)
{
	if(!isdefined(param_01))
	{
		if(!isdefined(param_02))
		{
			return 0;
		}

		return getaimyawtopoint3d(param_02);
	}

	var_03 = (0,0,0);
	if(isplayer(param_01))
	{
		var_03 = param_01 getvelocity();
	}
	else if(isai(param_01))
	{
		var_03 = param_01.var_381;
	}

	var_04 = param_01.origin + var_03 * param_00;
	return getaimyawtopoint3d(var_04);
}

//Function Number: 222
getpredictedaimpitchtoshootentorpos3d(param_00,param_01,param_02)
{
	if(!isdefined(param_01))
	{
		if(!isdefined(param_02))
		{
			return 0;
		}

		return getaimpitchtopoint3d(param_02);
	}

	var_03 = (0,0,0);
	if(isplayer(param_01))
	{
		var_03 = param_01 getvelocity();
	}
	else if(isai(param_01))
	{
		var_03 = param_01.var_381;
	}

	var_04 = param_01.origin + var_03 * param_00;
	return getaimpitchtopoint3d(var_04);
}

//Function Number: 223
meleegrab_ksweapon_used()
{
	var_00 = ["mars_killstreak","iw7_jackal_support_designator"];
	if(array_contains(var_00,level.player getcurrentweapon()))
	{
		return 1;
	}

	if(level.player isdroppingweapon())
	{
		return 1;
	}

	if(level.player israisingweapon())
	{
		if(array_contains(var_00,level.player getcurrentweapon()))
		{
			return 1;
		}
	}

	return 0;
}

//Function Number: 224
wasdamagedbyoffhandshield()
{
	if(!isdefined(self.var_DE) || self.var_DE != "MOD_MELEE")
	{
		return 0;
	}

	if(!isdefined(self.var_E2) || function_024C(self.var_E2) != "shield")
	{
		return 0;
	}

	return 1;
}

//Function Number: 225
istrue(param_00)
{
	if(isdefined(param_00) && param_00)
	{
		return 1;
	}

	return 0;
}

//Function Number: 226
player_is_in_jackal()
{
	if(isdefined(level.player _meth_8473()))
	{
		return 1;
	}

	return 0;
}

//Function Number: 227
set_createfx_enabled()
{
	if(!isdefined(level.createfx_enabled))
	{
		level.createfx_enabled = getdvar("createfx") != "";
	}
}

//Function Number: 228
flag_set_delayed(param_00,param_01,param_02)
{
	wait(param_01);
	flag_set(param_00,param_02);
}

//Function Number: 229
noself_array_call(param_00,param_01,param_02,param_03,param_04)
{
	if(isdefined(param_04))
	{
		foreach(var_06 in param_00)
		{
			[[ param_01 ]](var_06,param_02,param_03,param_04);
		}

		return;
	}

	if(isdefined(var_06))
	{
		foreach(var_08 in param_03)
		{
			[[ param_03 ]](var_08,param_04,var_05);
		}

		return;
	}

	if(isdefined(var_07))
	{
		foreach(var_0A in var_05)
		{
			[[ var_05 ]](var_0A,var_06);
		}

		return;
	}

	foreach(var_0C in var_07)
	{
		[[ var_07 ]](var_0C);
	}
}

//Function Number: 230
flag_assert(param_00)
{
}

//Function Number: 231
flag_wait_either(param_00,param_01)
{
	for(;;)
	{
		if(flag(param_00))
		{
			return;
		}

		if(flag(param_01))
		{
			return;
		}

		level waittill_either(param_00,param_01);
	}
}

//Function Number: 232
flag_wait_either_return(param_00,param_01)
{
	for(;;)
	{
		if(flag(param_00))
		{
			return param_00;
		}

		if(flag(param_01))
		{
			return param_01;
		}

		var_02 = level waittill_any_return(param_00,param_01);
		return var_02;
	}
}

//Function Number: 233
flag_wait_any(param_00,param_01,param_02,param_03,param_04,param_05)
{
	var_06 = [];
	if(isdefined(param_05))
	{
		var_06[var_06.size] = param_00;
		var_06[var_06.size] = param_01;
		var_06[var_06.size] = param_02;
		var_06[var_06.size] = param_03;
		var_06[var_06.size] = param_04;
		var_06[var_06.size] = param_05;
	}
	else if(isdefined(param_04))
	{
		var_06[var_06.size] = param_00;
		var_06[var_06.size] = param_01;
		var_06[var_06.size] = param_02;
		var_06[var_06.size] = param_03;
		var_06[var_06.size] = param_04;
	}
	else if(isdefined(param_03))
	{
		var_06[var_06.size] = param_00;
		var_06[var_06.size] = param_01;
		var_06[var_06.size] = param_02;
		var_06[var_06.size] = param_03;
	}
	else if(isdefined(param_02))
	{
		var_06[var_06.size] = param_00;
		var_06[var_06.size] = param_01;
		var_06[var_06.size] = param_02;
	}
	else if(isdefined(param_01))
	{
		flag_wait_either(param_00,param_01);
		return;
	}
	else
	{
		return;
	}

	for(;;)
	{
		for(var_07 = 0;var_07 < var_06.size;var_07++)
		{
			if(flag(var_06[var_07]))
			{
				return;
			}
		}

		level waittill_any_3(param_00,param_01,param_02,param_03,param_04,param_05);
	}
}

//Function Number: 234
flag_wait_any_return(param_00,param_01,param_02,param_03,param_04)
{
	var_05 = [];
	if(isdefined(param_04))
	{
		var_05[var_05.size] = param_00;
		var_05[var_05.size] = param_01;
		var_05[var_05.size] = param_02;
		var_05[var_05.size] = param_03;
		var_05[var_05.size] = param_04;
	}
	else if(isdefined(param_03))
	{
		var_05[var_05.size] = param_00;
		var_05[var_05.size] = param_01;
		var_05[var_05.size] = param_02;
		var_05[var_05.size] = param_03;
	}
	else if(isdefined(param_02))
	{
		var_05[var_05.size] = param_00;
		var_05[var_05.size] = param_01;
		var_05[var_05.size] = param_02;
	}
	else if(isdefined(param_01))
	{
		var_06 = flag_wait_either_return(param_00,param_01);
		return var_06;
	}
	else
	{
		return;
	}

	for(;;)
	{
		for(var_07 = 0;var_07 < var_06.size;var_07++)
		{
			if(flag(var_06[var_07]))
			{
				return var_06[var_07];
			}
		}

		var_06 = level waittill_any_return(param_01,param_02,param_03,param_04,var_05);
		return var_07;
	}
}

//Function Number: 235
flag_wait_all(param_00,param_01,param_02,param_03)
{
	if(isdefined(param_00))
	{
		flag_wait(param_00);
	}

	if(isdefined(param_01))
	{
		flag_wait(param_01);
	}

	if(isdefined(param_02))
	{
		flag_wait(param_02);
	}

	if(isdefined(param_03))
	{
		flag_wait(param_03);
	}
}

//Function Number: 236
flag_wait_or_timeout(param_00,param_01)
{
	var_02 = param_01 * 1000;
	var_03 = gettime();
	for(;;)
	{
		if(flag(param_00))
		{
			break;
		}

		if(gettime() >= var_03 + var_02)
		{
			break;
		}

		var_04 = var_02 - gettime() - var_03;
		var_05 = var_04 / 1000;
		wait_for_flag_or_time_elapses(param_00,var_05);
	}
}

//Function Number: 237
flag_waitopen_or_timeout(param_00,param_01)
{
	var_02 = gettime();
	for(;;)
	{
		if(!flag(param_00))
		{
			break;
		}

		if(gettime() >= var_02 + param_01 * 1000)
		{
			break;
		}

		wait_for_flag_or_time_elapses(param_00,param_01);
	}
}

//Function Number: 238
wait_for_flag_or_time_elapses(param_00,param_01)
{
	level endon(param_00);
	wait(param_01);
}

//Function Number: 239
noself_delaycall(param_00,param_01,param_02,param_03,param_04,param_05)
{
	thread noself_delaycall_proc(param_01,param_00,param_02,param_03,param_04,param_05);
}

//Function Number: 240
noself_delaycall_proc(param_00,param_01,param_02,param_03,param_04,param_05)
{
	wait(param_01);
	if(isdefined(param_05))
	{
		[[ param_00 ]](param_02,param_03,param_04,param_05);
		return;
	}

	if(isdefined(param_04))
	{
		[[ param_00 ]](param_02,param_03,param_04);
		return;
	}

	if(isdefined(param_03))
	{
		[[ param_00 ]](param_02,param_03);
		return;
	}

	if(isdefined(param_02))
	{
		[[ param_00 ]](param_02);
		return;
	}

	[[ param_00 ]]();
}

//Function Number: 241
get_target_array(param_00)
{
	if(!isdefined(param_00))
	{
		param_00 = self.target;
	}

	var_01 = getentarray(param_00,"targetname");
	if(var_01.size > 0)
	{
		return var_01;
	}

	if(issp())
	{
		var_01 = [[ level.getnodearrayfunction ]](param_00,"targetname");
		if(var_01.size > 0)
		{
			return var_01;
		}
	}

	var_01 = getstructarray(param_00,"targetname");
	if(var_01.size > 0)
	{
		return var_01;
	}

	var_01 = getvehiclenodearray(param_00,"targetname");
	if(var_01.size > 0)
	{
		return var_01;
	}
}

//Function Number: 242
pauseeffect()
{
	scripts\common\createfx::stop_fx_looper();
}

//Function Number: 243
spawn_script_origin(param_00,param_01)
{
	if(!isdefined(param_01) && isdefined(self.angles))
	{
		param_01 = self.angles;
	}

	if(!isdefined(param_00) && isdefined(self.origin))
	{
		param_00 = self.origin;
	}
	else if(!isdefined(param_00))
	{
		param_00 = (0,0,0);
	}

	var_02 = spawn("script_origin",param_00);
	if(isdefined(param_01))
	{
		var_02.angles = param_01;
	}

	return var_02;
}

//Function Number: 244
allow_lean(param_00)
{
	if(param_00)
	{
		if(!isdefined(self.disabledlean))
		{
			self.disabledlean = 0;
		}
		else
		{
			self.var_55D1--;
		}

		if(!self.disabledlean)
		{
			self _meth_800E(1);
			return;
		}

		return;
	}

	if(!isdefined(self.disabledlean))
	{
		self.disabledlean = 0;
	}

	self.var_55D1++;
	self _meth_800E(0);
}

//Function Number: 245
allow_reload(param_00,param_01)
{
	if(param_00)
	{
		if(!isdefined(self.disabledreload))
		{
			self.disabledreload = 0;
		}
		else
		{
			self.var_55DE--;
		}

		if(!self.disabledreload)
		{
			self allowreload(1);
			return;
		}

		return;
	}

	if(!isdefined(self.disabledreload))
	{
		self.disabledreload = 0;
	}

	self.var_55DE++;
	self allowreload(0);
	if(!isdefined(param_01) || !param_01)
	{
		self _meth_8545();
	}
}

//Function Number: 246
allow_autoreload(param_00)
{
	if(param_00)
	{
		if(!isdefined(self.disableautoreload))
		{
			self.disableautoreload = 0;
		}
		else
		{
			self.var_55C1--;
		}

		if(!self.disableautoreload)
		{
			self enableautoreload();
			return;
		}

		return;
	}

	if(!isdefined(self.disableautoreload))
	{
		self.disableautoreload = 0;
	}

	self.var_55C1++;
	self disableautoreload();
}

//Function Number: 247
forceenable_weapon_MAYBE()
{
	self.disabledweapon = 0;
	self enableweapons();
}

//Function Number: 248
forceenable_fire_MAYBE()
{
	self.disabledfire = 0;
	self allowfire(1);
}

//Function Number: 249
forceenable_melee_MAYBE()
{
	self.disabledmelee = 0;
	self allowmelee(1);
}

//Function Number: 250
get_noteworthy_array(param_00)
{
	var_01 = getentarray(param_00,"script_noteworthy");
	if(var_01.size > 0)
	{
		return var_01;
	}

	if(issp())
	{
		var_01 = [[ level.getnodearrayfunction ]](param_00,"script_noteworthy");
		if(var_01.size > 0)
		{
			return var_01;
		}
	}

	var_01 = getstructarray(param_00,"script_noteworthy");
	if(var_01.size > 0)
	{
		return var_01;
	}

	var_01 = getvehiclenodearray(param_00,"script_noteworthy");
	if(var_01.size > 0)
	{
		return var_01;
	}
}

//Function Number: 251
get_cumulative_weights(param_00)
{
	var_01 = [];
	var_02 = 0;
	for(var_03 = 0;var_03 < param_00.size;var_03++)
	{
		var_02 = var_02 + param_00[var_03];
		var_01[var_03] = var_02;
	}

	return var_01;
}

//Function Number: 252
void()
{
}

//Function Number: 253
func_9DA3()
{
	if(!isdefined(self.isnodeoccupied))
	{
		return 0;
	}

	if(!issentient(self.isnodeoccupied))
	{
		return 1;
	}

	if(self getpersstat(self.isnodeoccupied))
	{
		return 1;
	}

	var_00 = self lastknowntime(self.isnodeoccupied);
	if(var_00 == 0)
	{
		return 0;
	}

	var_01 = gettime() - var_00;
	if(var_01 > 10000)
	{
		return 0;
	}

	if(distancesquared(self.isnodeoccupied.origin,self.origin) > 4194304)
	{
		return 0;
	}

	return 1;
}

//Function Number: 254
get_notetrack_time(param_00,param_01)
{
	var_02 = getnotetracktimes(param_00,param_01);
	var_03 = getanimlength(param_00);
	return var_02[0] * var_03;
}

//Function Number: 255
mph_to_ips(param_00)
{
	return param_00 * 17.6;
}

//Function Number: 256
ips_to_mph(param_00)
{
	return param_00 * 0.056818;
}

//Function Number: 257
closestdistancebetweenlines(param_00,param_01,param_02,param_03)
{
	var_04 = param_00 - param_02;
	var_05 = param_03 - param_02;
	if(abs(var_05[0]) < 1E-06 && abs(var_05[1]) < 1E-06 && abs(var_05[2]) < 1E-06)
	{
		return undefined;
	}

	var_06 = param_01 - param_00;
	if(abs(var_06[0]) < 1E-06 && abs(var_06[1]) < 1E-06 && abs(var_06[2]) < 1E-06)
	{
		return undefined;
	}

	var_07 = var_04[0] * var_05[0] + var_04[1] * var_05[1] + var_04[2] * var_05[2];
	var_08 = var_05[0] * var_06[0] + var_05[1] * var_06[1] + var_05[2] * var_06[2];
	var_09 = var_04[0] * var_06[0] + var_04[1] * var_06[1] + var_04[2] * var_06[2];
	var_0A = var_05[0] * var_05[0] + var_05[1] * var_05[1] + var_05[2] * var_05[2];
	var_0B = var_06[0] * var_06[0] + var_06[1] * var_06[1] + var_06[2] * var_06[2];
	var_0C = var_0B * var_0A - var_08 * var_08;
	if(abs(var_0C) < 1E-06)
	{
		return undefined;
	}

	var_0D = var_07 * var_08 - var_09 * var_0A;
	var_0E = var_0D / var_0C;
	var_0F = var_07 + var_08 * var_0E / var_0A;
	var_10 = param_00 + var_0E * var_06;
	var_11 = param_02 + var_0F * var_05;
	var_12 = [var_10,var_11,distance(var_10,var_11)];
	return var_12;
}

//Function Number: 258
closestdistancebetweensegments(param_00,param_01,param_02,param_03)
{
	var_04 = param_01 - param_00;
	var_05 = param_03 - param_02;
	var_06 = param_00 - param_02;
	var_07 = vectordot(var_04,var_04);
	var_08 = vectordot(var_04,var_05);
	var_09 = vectordot(var_05,var_05);
	var_0A = vectordot(var_04,var_06);
	var_0B = vectordot(var_05,var_06);
	var_0C = var_07 * var_09 - var_08 * var_08;
	var_0D = var_0C;
	var_0E = var_0C;
	var_0F = 0;
	var_10 = 0;
	var_11 = 0;
	var_12 = 0;
	if(var_0C < 1E-08)
	{
		var_10 = 0;
		var_0D = 1;
		var_12 = var_0B;
		var_0E = var_09;
	}
	else
	{
		var_10 = var_08 * var_0B - var_09 * var_0A;
		var_12 = var_07 * var_0B - var_08 * var_0A;
		if(var_10 < 0)
		{
			var_10 = 0;
			var_12 = var_0B;
			var_0E = var_09;
		}
		else if(var_10 > var_0D)
		{
			var_10 = var_0D;
			var_12 = var_0B + var_08;
			var_0E = var_09;
		}
	}

	if(var_12 < 0)
	{
		var_12 = 0;
		if(var_0A * -1 < 0)
		{
			var_10 = 0;
		}
		else if(var_0A * -1 > var_07)
		{
			var_10 = var_0D;
		}
		else
		{
			var_10 = var_0A * -1;
			var_0D = var_07;
		}
	}
	else if(var_12 > var_0E)
	{
		var_12 = var_0E;
		if(var_08 - var_0A < 0)
		{
			var_10 = 0;
		}
		else if(var_08 - var_0A > var_07)
		{
			var_10 = var_0D;
		}
		else
		{
			var_10 = var_08 - var_0A;
			var_0D = var_07;
		}
	}

	if(abs(var_10) > 1E-08)
	{
		var_0F = var_10 / var_0D;
	}

	if(abs(var_12) > 1E-08)
	{
		var_11 = var_12 / var_0E;
	}

	var_13 = param_00 + var_0F * var_04;
	var_14 = param_02 + var_11 * var_05;
	var_15 = [var_13,var_14,distance(var_13,var_14)];
	return var_15;
}

//Function Number: 259
getcamotablecolumnindex(param_00)
{
	switch(param_00)
	{
		case "index":
			return 0;

		case "ref":
			return 1;

		case "type":
			return 2;

		case "target_material":
			return 3;

		case "tint":
			return 4;

		case "atlas_dims":
			return 5;

		case "name":
			return 6;

		case "image":
			return 7;

		case "weapon_index":
			return 8;

		case "bot_valid":
			return 9;

		case "description":
			return 10;

		case "category":
			return 11;

		default:
			return undefined;
	}
}