/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\cp\powers\coop_armageddon.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 16
 * Decompile Time: 731 ms
 * Timestamp: 10/27/2023 12:26:34 AM
*******************************************************************/

//Function Number: 1
init_armageddon()
{
	scripts\engine\utility::flag_init("armageddon_active");
	reset_armageddon_time();
	init_armageddon_areas();
	level.min_wait_between_metors = 0.2;
	level.max_wait_between_metors = 0.4;
	level.earthquake_time_extension = 10;
	level.armageddon_duration = 20;
	level.armageddon_earthquake_scale = 0.15;
}

//Function Number: 2
armageddon_use()
{
	add_to_armageddon_time(level.armageddon_duration);
	level thread do_armageddon_earthquake(level.armageddon_duration);
	if(scripts\engine\utility::flag("armageddon_active"))
	{
		return;
	}

	scripts\engine\utility::flag_set("armageddon_active");
	level thread armageddon_timer();
	level thread start_armageddon(self);
}

//Function Number: 3
add_to_armageddon_time(param_00)
{
	level.armageddon_time_remaining = level.armageddon_time_remaining + param_00;
}

//Function Number: 4
armageddon_timer()
{
	level endon("game_ended");
	while(level.armageddon_time_remaining > 0)
	{
		wait(1);
		level.var_2177--;
	}

	reset_armageddon_time();
	scripts\engine\utility::flag_clear("armageddon_active");
	level notify("armageddon_timeout");
}

//Function Number: 5
start_armageddon(param_00)
{
	level endon("game_ended");
	level endon("armageddon_timeout");
	for(;;)
	{
		var_01 = randomize_areas();
		foreach(var_03 in var_01)
		{
			drop_meteor_in_area(var_03,param_00);
			wait(randomfloatrange(level.min_wait_between_metors,level.max_wait_between_metors));
		}
	}
}

//Function Number: 6
randomize_areas()
{
	var_00 = scripts\engine\utility::array_randomize(level.armageddon_areas);
	var_01 = [];
	var_02 = [];
	foreach(var_04 in var_00)
	{
		if(area_has_enemies(var_04))
		{
			var_01[var_01.size] = var_04;
			continue;
		}

		var_02[var_02.size] = var_04;
	}

	var_00 = scripts\engine\utility::array_combine(var_01,var_02);
	return var_00;
}

//Function Number: 7
area_has_enemies(param_00)
{
	var_01 = min(param_00[0][0],param_00[1][0]);
	var_02 = max(param_00[0][0],param_00[1][0]);
	var_03 = min(param_00[0][1],param_00[1][1]);
	var_04 = max(param_00[0][1],param_00[1][1]);
	foreach(var_06 in level.spawned_enemies)
	{
		if(var_01 <= var_06.origin[0] && var_06.origin[0] <= var_02 && var_03 <= var_06.origin[1] && var_06.origin[1] <= var_04)
		{
			return 1;
		}
	}

	return 0;
}

//Function Number: 8
drop_meteor_in_area(param_00,param_01)
{
	var_02 = get_drop_pos(param_00);
	if(isdefined(param_01) && isplayer(param_01))
	{
		magicbullet("iw7_armageddonmeteor_mp",var_02.start,var_02.end,param_01);
		return;
	}

	magicbullet("iw7_armageddonmeteor_mp",var_02.start,var_02.end,level.players[0]);
}

//Function Number: 9
get_drop_pos(param_00)
{
	if(area_has_enemies(param_00))
	{
		return get_enemy_pos(param_00);
	}

	return get_random_drop_pos(param_00);
}

//Function Number: 10
get_enemy_pos(param_00)
{
	var_01 = spawnstruct();
	var_02 = min(param_00[0][0],param_00[1][0]);
	var_03 = max(param_00[0][0],param_00[1][0]);
	var_04 = min(param_00[0][1],param_00[1][1]);
	var_05 = max(param_00[0][1],param_00[1][1]);
	foreach(var_07 in level.spawned_enemies)
	{
		if(var_02 <= var_07.origin[0] && var_07.origin[0] <= var_03 && var_04 <= var_07.origin[1] && var_07.origin[1] <= var_05)
		{
			var_01.start = (var_07.origin[0] + randomfloatrange(-2000,2000),var_07.origin[1] + randomfloatrange(-2000,2000),8000 + randomfloatrange(-1000,1000));
			var_01.end = var_07.origin;
			return var_01;
		}
	}
}

//Function Number: 11
get_random_drop_pos(param_00)
{
	var_01 = spawnstruct();
	var_02 = min(param_00[0][0],param_00[1][0]);
	var_03 = max(param_00[0][0],param_00[1][0]);
	var_04 = min(param_00[0][1],param_00[1][1]);
	var_05 = max(param_00[0][1],param_00[1][1]);
	var_06 = randomfloatrange(var_02,var_03);
	var_07 = randomfloatrange(var_04,var_05);
	var_01.start = (var_06,var_07,8000 + randomfloatrange(-1000,1000));
	var_01.end = scripts\engine\utility::drop_to_ground((var_06 + randomfloatrange(-2000,2000),var_07 + randomfloatrange(-2000,2000),-8000),72,-100) + (0,0,16);
	return var_01;
}

//Function Number: 12
reset_armageddon_time()
{
	level.armageddon_time_remaining = 0;
}

//Function Number: 13
isfirstarmageddonmeteorhit(param_00)
{
	if(!isdefined(param_00) && param_00 == "iw7_armageddonmeteor_mp")
	{
		return 0;
	}

	return !scripts\engine\utility::istrue(self.fling_from_meteor);
}

//Function Number: 14
fling_zombie_from_meteor(param_00,param_01,param_02)
{
	if(scripts\engine\utility::istrue(self.fling_from_meteor))
	{
		return;
	}

	self endon("death");
	self.fling_from_meteor = 1;
	self.do_immediate_ragdoll = 1;
	self.customdeath = 1;
	var_03 = self.origin - param_00 * (1,1,0);
	var_03 = vectornormalize(var_03);
	var_03 = vectornormalize(var_03 + (0,0,1)) * 600;
	self setvelocity(var_03);
	wait(0.5);
	self.fling_from_meteor = 0;
	self dodamage(self.maxhealth + 10000,param_01);
}

//Function Number: 15
do_armageddon_earthquake(param_00)
{
	wait(1.5);
	earthquake(level.armageddon_earthquake_scale,param_00 + level.earthquake_time_extension,(742,-853,-85),5000);
}

//Function Number: 16
init_armageddon_areas()
{
	level.armageddon_areas = [];
	var_00 = scripts\engine\utility::getstructarray("armageddon_area_marker","targetname");
	foreach(var_02 in var_00)
	{
		var_03 = [];
		var_04 = scripts\engine\utility::getstruct(var_02.target,"targetname");
		var_03[var_03.size] = var_02.origin;
		var_03[var_03.size] = var_04.origin;
		level.armageddon_areas[level.armageddon_areas.size] = var_03;
	}
}