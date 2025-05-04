/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\cp\zombies\cp_rave_spawning.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 57
 * Decompile Time: 2886 ms
 * Timestamp: 10/27/2023 12:08:47 AM
*******************************************************************/

//Function Number: 1
goon_spawn_event_func()
{
	level.agent_funcs["zombie_sasquatch"]["on_damaged"] = ::scripts\cp\maps\cp_rave\cp_rave_damage::cp_rave_onzombiedamaged;
	level.agent_funcs["zombie_sasquatch"]["gametype_on_damage_finished"] = ::scripts/cp/agents/gametype_zombie::onzombiedamagefinished;
	level.agent_funcs["zombie_sasquatch"]["gametype_on_killed"] = ::scripts\cp\maps\cp_rave\cp_rave_damage::cp_rave_onzombiekilled;
	if(!isdefined(level.zombie_sasquatch_vo_prefix))
	{
		level.zombie_sasquatch_vo_prefix = "zmb_vo_sasquatch_";
	}

	level.static_enemy_types = func_79EB();
	level.dynamic_enemy_types = [];
	level.max_static_spawned_enemies = 24;
	level.max_dynamic_spawners = 0;
	level.desired_enemy_deaths_this_wave = _meth_8455();
	level.current_enemy_deaths = 0;
	func_1071B();
}

//Function Number: 2
_meth_8455()
{
	var_00 = level.players.size;
	var_01 = var_00 * 3;
	var_02 = 1;
	switch(level.specialroundcounter)
	{
		case 0:
			var_01 = var_00 * 6;
			break;

		case 1:
			var_01 = var_00 * 9;
			break;

		case 2:
			var_01 = var_00 * 12;
			break;

		case 3:
			var_01 = var_00 * 16;
			break;

		default:
			var_01 = var_00 * 16;
			break;
	}

	var_01 = var_01 * var_02;
	return var_01;
}

//Function Number: 3
func_1071B()
{
	level endon("force_spawn_wave_done");
	level endon("game_ended");
	level.respawning_enemies = 0;
	level.num_goons_spawned = 0;
	level.current_spawn_group_index = 0;
	level.spawn_group = [];
	var_00 = 0;
	while(level.current_enemy_deaths < level.desired_enemy_deaths_this_wave)
	{
		while(scripts\engine\utility::istrue(level.zombies_paused) || scripts\engine\utility::istrue(level.nuke_zombies_paused))
		{
			scripts\engine\utility::waitframe();
		}

		var_01 = num_goons_to_spawn();
		var_02 = get_spawner_and_spawn_goons(var_01);
		var_00 = var_00 + var_02;
		if(var_02 > 0)
		{
			wait(_meth_8454(var_00,level.desired_enemy_deaths_this_wave));
			continue;
		}

		wait(0.1);
	}

	level.max_static_spawned_enemies = 0;
	level.max_dynamic_spawners = 0;
	level.stop_spawning = 1;
}

//Function Number: 4
func_B26D()
{
	if(!is_in_array(level.var_162C,self))
	{
		level.var_162C[level.var_162C.size] = self;
	}

	self.var_19 = 1;
	self.in_use = 0;
}

//Function Number: 5
func_B26E()
{
	self.var_19 = 0;
}

//Function Number: 6
func_5CF7(param_00,param_01,param_02)
{
	if(isdefined(level.force_drop_loot_item))
	{
		level thread scripts\cp\loot::drop_loot(param_01,param_02,level.force_drop_loot_item);
		level.force_drop_loot_item = undefined;
		return 1;
	}

	if(level.spawn_event_running == 1)
	{
		if(level.desired_enemy_deaths_this_wave == level.current_enemy_deaths)
		{
			level thread scripts\cp\loot::drop_loot(param_01,param_02,"ammo_max");
			return 1;
		}

		return 0;
	}

	return 0;
}

//Function Number: 7
func_79EB()
{
	return ["sasquatch"];
}

//Function Number: 8
_meth_8454(param_00,param_01)
{
	var_02 = 1.5;
	switch(level.specialroundcounter)
	{
		case 0:
			var_02 = 3;
			break;

		case 1:
			var_02 = 2;
			break;

		case 2:
			var_02 = 1.5;
			break;

		case 3:
			var_02 = 1;
			break;

		default:
			var_02 = 1;
			break;
	}

	var_02 = var_02 - param_00 / param_01;
	var_02 = max(var_02,0.05);
	return var_02;
}

//Function Number: 9
_meth_826F()
{
	var_00 = 0.5;
	return var_00;
}

//Function Number: 10
rotatevelocity()
{
	var_00 = level.players.size;
	return 8 + 4 * var_00;
}

//Function Number: 11
get_spawner_and_spawn_goons(param_00)
{
	var_01 = 0;
	if(param_00 <= 0)
	{
		if(param_00 < 0)
		{
			scripts\cp\zombies\zombies_spawning::func_A5FA(abs(param_00));
		}

		return 0;
	}

	var_02 = min(param_00,1);
	func_1071C(var_02);
	return var_02;
}

//Function Number: 12
func_1071C(param_00)
{
	var_01 = 0.3;
	var_02 = 0.7;
	if(param_00 > 0)
	{
		scripts\cp\zombies\zombies_spawning::func_93E6(param_00);
		var_03 = [];
		var_04 = scripts\engine\utility::getstruct("brute_hide_org","targetname");
		var_05 = 0;
		while(var_05 < param_00)
		{
			var_06 = func_10719(var_04);
			if(isdefined(var_06))
			{
				var_05++;
				var_06 give_mp_super_weapon(var_06.origin);
				var_06 scripts\mp\agents\_scriptedagents::setstatelocked(1,"spawn_in_box");
				var_06.precacheleaderboards = 1;
				var_06.ignoreme = 1;
				var_06.scripted_mode = 1;
				var_03[var_03.size] = var_06;
			}

			wait(0.1);
		}

		var_07 = scripts\cp\zombies\zombies_spawning::get_scored_goon_spawn_location();
		var_07.in_use = 1;
		var_07.lastspawntime = gettime();
		thread scripts\cp\utility::playsoundinspace("zombie_spawn_lightning",var_07.origin);
		for(var_08 = 0;var_08 < var_03.size;var_08++)
		{
			var_06 = var_03[var_08];
			var_09 = scripts\cp\zombies\zombies_spawning::func_772C(var_07.origin,var_07.angles);
			var_06.spawner = var_09;
			func_1B99(var_06.spawner);
			var_06 scripts\cp\zombies\zombies_spawning::move_to_spot(var_06.spawner);
			var_06.ignoreme = 0;
			var_06.scripted_mode = 0;
			var_06 scripts\mp\agents\_scriptedagents::setstatelocked(0,"spawn_in_box");
			var_09 = undefined;
			scripts\cp\zombies\zombies_spawning::func_4FB6(1);
			var_06 thread scripts\mp\agents\zombie_sasquatch\zombie_sasquatch_agent::setup_eye_glow();
			wait(randomfloatrange(var_01,var_02));
		}

		var_07.in_use = 0;
	}
}

//Function Number: 13
func_1B99(param_00)
{
	var_01 = level._effect["goon_spawn_bolt"];
	playfx(var_01,param_00.origin);
	playfx(level._effect["drone_ground_spawn"],param_00.origin,(0,0,1));
	playrumbleonposition("grenade_rumble",param_00.origin);
	earthquake(0.3,0.2,param_00.origin,500);
}

//Function Number: 14
move_to_spot(param_00)
{
	var_01 = getclosestpointonnavmesh(param_00.origin);
	self dontinterpolate();
	self setorigin(param_00.origin,1);
	self ghostskulls_complete_status(param_00.origin);
	self.precacheleaderboards = 0;
}

//Function Number: 15
func_772C(param_00,param_01)
{
	var_02 = 50;
	var_03 = 50;
	var_04 = spawnstruct();
	var_04.angles = param_01;
	var_05 = var_04.origin;
	var_06 = 0;
	while(!var_06)
	{
		var_07 = randomintrange(var_02 * -1,var_02);
		var_08 = randomintrange(var_03 * -1,var_03);
		var_05 = getclosestpointonnavmesh((param_00[0] + var_07,param_00[1] + var_08,param_00[2]));
		var_06 = 1;
		foreach(var_0A in level.players)
		{
			if(positionwouldtelefrag(var_05))
			{
				var_06 = 0;
			}
		}

		if(!var_06)
		{
			wait(0.1);
		}
	}

	var_04.origin = var_05 + (0,0,5);
	return var_04;
}

//Function Number: 16
func_10719(param_00)
{
	var_01 = "zombie_sasquatch";
	var_02 = param_00.origin;
	var_03 = param_00.angles;
	var_04 = "axis";
	var_05 = scripts\mp\mp_agent::spawnnewagent(var_01,var_04,var_02,var_03);
	if(isdefined(var_05))
	{
		var_05.voprefix = level.zombie_sasquatch_vo_prefix;
		level thread scripts/cp/zombies/zombies_vo::play_zombie_vo(var_05,"spawn",1);
		var_05 setavoidanceradius(4);
		param_00.lastspawntime = gettime();
		var_05 thread sasquatch_audio_monitor();
		var_05 thread scripts\cp\zombies\zombies_spawning::func_64E7(var_01);
		level notify("agent_spawned",var_05);
	}

	return var_05;
}

//Function Number: 17
sasquatch_audio_monitor()
{
	level endon("game_ended");
	self endon("death");
	thread scripts/cp/zombies/zombies_vo::play_zombie_death_vo(self.voprefix,undefined,1);
	self.playing_stumble = 0;
	for(;;)
	{
		var_00 = scripts\engine\utility::waittill_any_timeout_1(6,"attack_hit","attack_miss","attack_charge");
		switch(var_00)
		{
			case "attack_hit":
				level thread scripts/cp/zombies/zombies_vo::play_zombie_vo(self,"attack",0);
				break;
	
			case "attack_miss":
				level thread scripts/cp/zombies/zombies_vo::play_zombie_vo(self,"attack",0);
				break;
	
			case "attack_charge":
				level thread scripts/cp/zombies/zombies_vo::play_zombie_vo(self,"charge_grunt",0);
				break;
	
			case "timeout":
				level thread scripts/cp/zombies/zombies_vo::play_zombie_vo(self,"idle_grunt",0);
				break;
		}
	}
}

//Function Number: 18
num_goons_to_spawn()
{
	var_00 = scripts\cp\zombies\zombies_spawning::num_zombies_available_to_spawn();
	return var_00;
}

//Function Number: 19
get_scored_goon_spawn_location()
{
	var_00 = undefined;
	var_00 = func_79EC();
	return var_00;
}

//Function Number: 20
func_79EC()
{
	var_00 = [];
	foreach(var_02 in level.var_162C)
	{
		if(scripts\engine\utility::istrue(var_02.var_19) && !scripts\engine\utility::istrue(var_02.in_use))
		{
			var_00[var_00.size] = var_02;
		}
	}

	if(var_00.size > 0)
	{
		var_02 = _meth_8456(var_00);
		if(isdefined(var_02))
		{
			return var_02;
		}
	}

	return scripts\engine\utility::random(var_00);
}

//Function Number: 21
_meth_8456(param_00)
{
	var_01 = [];
	var_02 = 2;
	var_03 = 1;
	var_04 = 5000;
	foreach(var_06 in param_00)
	{
		if(scripts/cp/zombies/func_0D60::allowedstances(var_06.volume))
		{
			var_01[var_01.size] = var_06;
			var_06.modifiedspawnpoints = var_02;
			continue;
		}

		if(isdefined(var_06.volume.var_186E))
		{
			foreach(var_08 in var_06.volume.var_186E)
			{
				if(scripts/cp/zombies/func_0D60::allowedstances(var_08))
				{
					var_01[var_01.size] = var_06;
					var_06.modifiedspawnpoints = var_03;
					break;
				}
			}
		}
	}

	var_0B = 562500;
	var_0C = 4000000;
	var_0D = 9000000;
	var_0E = 122500;
	var_0F = -25536;
	var_10 = -99999999;
	var_11 = undefined;
	var_12 = 15000;
	var_13 = -25536;
	var_14 = " ";
	var_15 = undefined;
	var_16 = gettime();
	var_17 = getvalidplayersinarray();
	var_18 = [];
	if(!isdefined(var_17))
	{
		return undefined;
	}

	foreach(var_06 in var_01)
	{
		var_15 = "";
		var_1A = 0;
		var_1B = var_06.modifiedspawnpoints * randomintrange(var_12,var_13);
		var_1C = randomint(100);
		if(isdefined(var_06.var_BF6C) && var_06.var_BF6C >= var_16)
		{
			var_1A = var_1A - 20000;
			var_15 = var_15 + " Short Cooldown";
		}

		var_1D = distancesquared(var_17.origin,var_06.origin);
		if(var_1D < var_0E)
		{
			var_1A = var_1A - -15536;
			var_15 = var_15 + " Too Close";
		}
		else if(var_1D > var_0D)
		{
			var_1A = var_1A - -15536;
			var_15 = var_15 + " Too Far";
		}
		else if(var_1D < var_0B)
		{
			if(var_1C < max(int(level.specialroundcounter + 1) * 10,20))
			{
				var_1A = var_1A + var_1B;
				var_15 = var_15 + " Chance Close";
			}
			else
			{
				var_1A = var_1A - var_1B;
				var_15 = var_15 + " Close";
			}
		}
		else if(var_1D > var_0C)
		{
			var_1A = var_1A - var_1B;
			var_15 = var_15 + " Far";
		}
		else
		{
			var_1A = var_1A + var_1B;
			var_15 = var_15 + " Good Spawn";
		}

		if(var_1A > var_10)
		{
			var_10 = var_1A;
			var_11 = var_06;
			var_14 = var_15;
			var_18[var_18.size] = var_06;
		}
	}

	if(!isdefined(var_11))
	{
		return undefined;
	}

	for(var_1F = var_18.size - 1;var_1F >= 0;var_1F--)
	{
		var_20 = 1;
		foreach(var_17 in level.players)
		{
			if(distancesquared(var_17.origin,var_18[var_1F].origin) < var_0F)
			{
				var_20 = 0;
				break;
			}
		}

		if(var_20)
		{
			var_11 = var_18[var_1F];
			break;
		}
	}

	var_11.var_BF6C = var_16 + var_04;
	return var_11;
}

//Function Number: 22
getvalidplayersinarray()
{
	var_00 = [];
	foreach(var_02 in level.players)
	{
		if(!isalive(var_02))
		{
			continue;
		}

		if(scripts\engine\utility::istrue(var_02.linked_to_coaster))
		{
			continue;
		}

		var_00[var_00.size] = var_02;
	}

	return scripts\engine\utility::random(var_00);
}

//Function Number: 23
func_9608()
{
	level.goon_spawners = [];
	var_00 = scripts\engine\utility::getstructarray("dog_spawner","targetname");
	if(isdefined(level.goon_spawner_patch_func))
	{
		[[ level.goon_spawner_patch_func ]](var_00);
	}

	foreach(var_02 in var_00)
	{
		var_03 = 0;
		foreach(var_05 in level.invalid_spawn_volume_array)
		{
			if(function_010F(var_02.origin,var_05))
			{
				var_03 = 1;
			}
		}

		if(!var_03)
		{
			foreach(var_05 in level.spawn_volume_array)
			{
				if(function_010F(var_02.origin,var_05))
				{
					if(!isdefined(var_02.angles))
					{
						var_02.angles = (0,0,0);
					}

					level.goon_spawners[level.goon_spawners.size] = var_02;
					var_02.volume = var_05;
					if(!isdefined(var_05.goon_spawners))
					{
						var_05.goon_spawners = [];
					}

					var_05.goon_spawners[var_05.goon_spawners.size] = var_02;
					break;
				}
			}
		}
	}
}

//Function Number: 24
move_goon_spawner(param_00,param_01,param_02)
{
	var_03 = scripts\engine\utility::getclosest(param_01,param_00,500);
	var_03.origin = param_02;
}

//Function Number: 25
func_3712()
{
	var_00 = 400;
	switch(level.specialroundcounter)
	{
		case 1:
		case 0:
			var_00 = 400;
			break;

		case 2:
			var_00 = 900;
			break;

		case 3:
			var_00 = 1300;
			break;

		default:
			var_00 = 1600;
			break;
	}

	return var_00;
}

//Function Number: 26
func_7CE3()
{
	if(!isdefined(self.target))
	{
		return undefined;
	}

	var_00 = getentarray(self.target,"targetname");
	if(!isdefined(var_00) || var_00.size == 0)
	{
		var_00 = scripts\engine\utility::getstructarray(self.target,"targetname");
	}

	var_01 = [];
	foreach(var_03 in var_00)
	{
		if(isdefined(var_03.remove_me))
		{
			var_01[var_01.size] = var_03;
		}
	}

	if(var_01.size > 0)
	{
		var_00 = scripts\engine\utility::array_remove_array(var_00,var_01);
	}

	return var_00;
}

//Function Number: 27
update_origin(param_00,param_01)
{
	if(!isdefined(level.spawn_struct_list))
	{
		level.spawn_struct_list = scripts\engine\utility::getstructarray("static","script_noteworthy");
	}

	foreach(var_03 in level.spawn_struct_list)
	{
		if(var_03.origin == param_00)
		{
			var_03.origin = param_01;
			break;
		}
	}
}

//Function Number: 28
remove_origin(param_00)
{
	if(!isdefined(level.spawn_struct_list))
	{
		level.spawn_struct_list = scripts\engine\utility::getstructarray("static","script_noteworthy");
	}

	foreach(var_02 in level.spawn_struct_list)
	{
		if(var_02.origin == param_00)
		{
			var_02.remove_me = 1;
			break;
		}
	}
}

//Function Number: 29
update_kvp(param_00,param_01,param_02)
{
	if(!isdefined(level.spawn_struct_list))
	{
		level.spawn_struct_list = scripts\engine\utility::getstructarray("static","script_noteworthy");
	}

	foreach(var_04 in level.spawn_struct_list)
	{
		if(var_04.origin == param_00)
		{
			var_04 = [[ level.kvp_update_funcs[param_01] ]](var_04,param_02);
			break;
		}
	}
}

//Function Number: 30
kvp_update_init()
{
	level.kvp_update_funcs["script_fxid"] = ::update_kvp_script_fxid;
}

//Function Number: 31
update_kvp_script_fxid(param_00,param_01)
{
	param_00.script_fxid = param_01;
	return param_00;
}

//Function Number: 32
func_77D3()
{
	if(isdefined(level.var_186E[self.basename]))
	{
		var_00 = [];
		foreach(var_02 in level.var_186E[self.basename])
		{
			var_00[var_00.size] = level.var_10817[var_02];
		}

		return var_00;
	}

	return [];
}

//Function Number: 33
func_7999()
{
	var_00 = getentarray(self.destroynavobstacle,"script_noteworthy");
	if(isdefined(var_00) && var_00.size != 0)
	{
		self.var_665B = var_00;
	}
}

//Function Number: 34
func_4F1E()
{
	level endon("game_ended");
	var_00 = getdvarint("scr_spawn_start_delay");
	if(var_00 > 0)
	{
		wait(var_00);
	}
}

//Function Number: 35
func_1294D()
{
	foreach(var_01 in level.active_spawners)
	{
		var_01.var_19 = 0;
		var_01 notify("dont_restart_spawner");
	}

	level.active_spawners = [];
}

//Function Number: 36
should_spawn_clown()
{
	if(isdefined(level.no_clown_spawn))
	{
		return 0;
	}

	if(isdefined(level.respawn_data))
	{
		if(level.respawn_data.type == "zombie_sasquatch")
		{
			return 1;
		}

		return 0;
	}

	var_00 = randomint(100);
	if(var_00 < min(level.wave_num - 19,10) && level.wave_num > 20)
	{
		if(gettime() - level.last_clown_spawn_time > 15000)
		{
			level.last_clown_spawn_time = gettime();
			return 1;
		}
	}

	return 0;
}

//Function Number: 37
func_AD62()
{
	level endon("game_ended");
	for(;;)
	{
		if(getdvarint("scr_reserve_spawning") > 0)
		{
			level.var_E1CC = getdvarint("scr_reserve_spawning");
		}

		wait(1);
	}
}

//Function Number: 38
func_726E()
{
	level notify("force_spawn_wave_done");
	wait(0.1);
	level.max_static_spawned_enemies = 0;
	level.max_dynamic_spawners = 0;
	level.stop_spawning = 1;
}

//Function Number: 39
func_5173(param_00)
{
	scripts\engine\utility::waittill_any_3("death","emerge_done");
	if(isdefined(param_00))
	{
		param_00 delete();
	}
}

//Function Number: 40
calculatezombiehealth(param_00)
{
	var_01 = 0;
	var_02 = level.wave_num;
	if(isdefined(level.var_8CBD) && isdefined(level.var_8CBD[param_00]))
	{
		var_01 = [[ level.var_8CBD[param_00] ]]();
	}
	else
	{
		if(isdefined(level.wave_num_override))
		{
			var_02 = level.wave_num_override;
		}

		if(scripts\engine\utility::istrue(self.is_cop))
		{
			var_02 = var_02 + 3;
		}

		if(scripts\engine\utility::istrue(self.is_skeleton))
		{
			var_02 = var_02 + 10;
		}

		var_03 = 150;
		if(var_02 == 1)
		{
			var_01 = var_03;
		}
		else if(var_02 <= 9)
		{
			var_01 = var_03 + var_02 - 1 * 100;
		}
		else
		{
			var_04 = 950;
			var_05 = var_02 - 9;
			var_01 = var_04 * pow(1.1,var_05);
		}
	}

	if(isdefined(level.var_8CB3[param_00]))
	{
		var_01 = int(var_01 * level.var_8CB3[param_00]);
	}

	if(var_01 > 6100000)
	{
		var_01 = 6100000;
	}

	return int(var_01);
}

//Function Number: 41
func_F604(param_00,param_01)
{
	foreach(var_03 in level.players)
	{
		if(!scripts\engine\utility::istrue(var_03.wearing_dischord_glasses))
		{
			var_03 visionsetnakedforplayer(param_00,param_01);
		}
	}
}

//Function Number: 42
func_7848(param_00)
{
	if(isdefined(level.available_event_func))
	{
		return [[ level.available_event_func ]](param_00);
	}

	return "goon";
}

//Function Number: 43
func_7B1C()
{
	return level.wave_num + 1;
}

//Function Number: 44
func_7D00(param_00,param_01)
{
	if(scripts\cp\utility::is_escape_gametype())
	{
		return 1;
	}

	return 10;
}

//Function Number: 45
func_7CA9(param_00)
{
	var_01 = ["generic_zombie"];
	return var_01;
}

//Function Number: 46
get_max_static_enemies(param_00)
{
	if(scripts\cp\utility::is_escape_gametype() && param_00 < 5)
	{
		var_01 = level.players.size * 6;
		var_02 = [0,0.25,0.3,0.5,0.7,0.9];
		var_03 = 1;
		var_04 = 1;
		var_03 = var_02[param_00];
		var_05 = level.players.size - 1;
		if(var_05 < 1)
		{
			var_05 = 0.5;
		}

		var_06 = 24 + var_05 * 6 * var_04 * var_03;
		return int(min(var_01,var_06));
	}

	return 24;
}

//Function Number: 47
get_total_spawned_enemies(param_00)
{
	if(scripts\cp\utility::is_escape_gametype())
	{
		return 9000;
	}

	var_01 = [0,0.25,0.3,0.5,0.7,0.9];
	var_02 = 1;
	var_03 = 1;
	if(param_00 < 6)
	{
		var_02 = var_01[param_00];
	}
	else if(param_00 < 10)
	{
		var_03 = param_00 / 5;
	}
	else
	{
		var_03 = squared(param_00) * 0.03;
	}

	var_04 = level.players.size - 1;
	if(var_04 < 1)
	{
		var_04 = 0.5;
	}

	var_05 = 24 + var_04 * 6 * var_03 * var_02;
	return int(var_05);
}

//Function Number: 48
func_7CFF(param_00)
{
	return 1;
}

//Function Number: 49
func_13691()
{
	while(level.current_enemy_deaths < level.desired_enemy_deaths_this_wave)
	{
		wait(1);
	}

	level.max_static_spawned_enemies = 0;
	level.max_dynamic_spawners = 0;
	level.stop_spawning = 1;
}

//Function Number: 50
is_in_array(param_00,param_01)
{
	if(!isdefined(param_00) || !isdefined(param_01) || param_00.size == 0)
	{
		return 0;
	}

	for(var_02 = 0;var_02 < param_00.size;var_02++)
	{
		if(param_00[var_02] == param_01)
		{
			return 1;
		}
	}

	return 0;
}

//Function Number: 51
func_13FA2()
{
	foreach(var_01 in level.spawn_volume_array)
	{
		if(self istouching(var_01))
		{
			return 1;
		}
	}

	return 0;
}

//Function Number: 52
cp_rave_cleanup_main()
{
	var_00 = 0;
	level.var_BE23 = 0;
	for(;;)
	{
		scripts\engine\utility::waitframe();
		var_01 = gettime();
		if(var_01 < var_00)
		{
			continue;
		}

		if(isdefined(level.var_BE22))
		{
			var_02 = gettime() / 1000;
			var_03 = var_02 - level.var_BE22;
			if(var_03 < 0)
			{
				continue;
			}

			level.var_BE22 = undefined;
		}

		var_04 = var_01 - level.var_13BDA / 1000;
		if(level.wave_num <= 5 && var_04 < 30)
		{
			continue;
		}
		else if(level.wave_num > 5 && var_04 < 20)
		{
			continue;
		}

		var_05 = undefined;
		if(level.desired_enemy_deaths_this_wave - level.current_enemy_deaths < 3)
		{
			var_05 = 1000000;
		}

		var_00 = var_00 + 3000;
		var_06 = scripts\cp\cp_agent_utils::getaliveagentsofteam("axis");
		foreach(var_08 in var_06)
		{
			if(level.var_BE23 >= 1)
			{
				level.var_BE23 = 0;
				scripts\engine\utility::waitframe();
			}

			if(func_380D(var_08))
			{
				var_08 func_5773(var_05);
			}
		}
	}
}

//Function Number: 53
func_380D(param_00)
{
	if(isdefined(param_00.agent_type) && param_00.agent_type == "zombie_ghost")
	{
		return 0;
	}

	if(isdefined(param_00.var_2BF9))
	{
		return 0;
	}

	if(scripts\engine\utility::istrue(param_00.is_turned))
	{
		return 0;
	}

	if(scripts\engine\utility::istrue(param_00.dont_cleanup))
	{
		return 0;
	}

	if(isdefined(param_00.delay_cleanup_until) && gettime() < param_00.delay_cleanup_until)
	{
		return 0;
	}

	return 1;
}

//Function Number: 54
func_5773(param_00)
{
	if(!isalive(self))
	{
		return;
	}

	if(!func_FF1A(self))
	{
		return;
	}

	var_01 = gettime() - self.spawn_time;
	if(var_01 < 5000)
	{
		return;
	}

	if(self.agent_type == "generic_zombie" || self.agent_type == "lumberjack")
	{
		if(var_01 < -20536 && !self.entered_playspace)
		{
			return;
		}
	}

	var_02 = 1;
	var_03 = 0;
	var_04 = 1;
	if(scripts\engine\utility::istrue(self.dismember_crawl) && level.desired_enemy_deaths_this_wave - level.current_enemy_deaths < 2)
	{
		var_03 = 1;
		param_00 = 250000;
		var_02 = 0;
	}
	else
	{
		if(level.var_B789.size == 0)
		{
			if(isdefined(level.use_adjacent_volumes))
			{
				var_02 = scripts\cp\zombies\zombies_spawning::animmode(1,0);
			}
			else
			{
				var_02 = scripts\cp\zombies\zombies_spawning::animmode(0,0);
			}
		}
		else
		{
			var_02 = scripts\cp\zombies\zombies_spawning::animmode(1,0);
			if(var_02)
			{
				var_04 = scripts\cp\zombies\zombies_spawning::animmode(0,1);
			}
		}

		if(var_02)
		{
			var_05 = undefined;
			foreach(var_07 in level.active_spawn_volumes)
			{
				if(self istouching(var_07))
				{
					var_05 = var_07;
					break;
				}
			}

			if(isdefined(var_05) && var_05.basename == "island")
			{
				var_09 = scripts/cp/zombies/func_0D60::allowedstances(var_05);
				if(var_09 == 0)
				{
					var_02 = 0;
				}
			}
		}
	}

	level.var_BE23++;
	if(!var_02 || !var_04)
	{
		var_0A = 10000000;
		var_0B = level.players[0];
		foreach(var_0D in level.players)
		{
			var_0E = distancesquared(self.origin,var_0D.origin);
			if(var_0E < var_0A)
			{
				var_0A = var_0E;
				var_0B = var_0D;
			}
		}

		if(isdefined(param_00))
		{
			var_10 = param_00;
		}
		else if(isdefined(var_0C) && scripts\cp\zombies\zombies_spawning::func_CF4C(var_0C))
		{
			var_10 = 189225;
		}
		else
		{
			var_10 = 250000;
		}

		if(var_0A >= var_10)
		{
			if(!var_04)
			{
				if(level.last_mini_zone_fail + 1000 > gettime())
				{
					return;
				}
				else
				{
					level.last_mini_zone_fail = gettime();
				}
			}

			thread func_51A5(var_0A,var_03);
		}
	}
}

//Function Number: 55
func_FF1A(param_00)
{
	if(!isdefined(param_00.agent_type))
	{
		return 0;
	}

	switch(param_00.agent_type)
	{
		case "superslasher":
		case "slasher":
			return 0;

		default:
			return 1;
	}
}

//Function Number: 56
func_51A5(param_00,param_01)
{
	if(scripts\engine\utility::istrue(self.var_93A7))
	{
		return;
	}

	if(param_01)
	{
		if(scripts\engine\utility::istrue(self.isactive))
		{
			func_EDF6();
		}
		else
		{
		}

		return;
	}

	foreach(var_03 in level.players)
	{
		if(scripts\engine\utility::istrue(var_03.spectating))
		{
			continue;
		}

		if(scripts\engine\utility::istrue(var_03.is_fast_traveling))
		{
			continue;
		}

		if(scripts\engine\utility::istrue(var_03.in_afterlife_arcade))
		{
			continue;
		}

		if(scripts\cp\zombies\zombies_spawning::func_CFB2(var_03))
		{
			if(param_00 < 4000000)
			{
				return;
			}
		}
	}

	self.died_poorly = 1;
	if(scripts\engine\utility::istrue(self.marked_for_challenge) && isdefined(level.num_zombies_marked))
	{
		level.var_C20A--;
	}

	if(scripts\engine\utility::istrue(self.isactive))
	{
		self.nocorpse = 1;
		func_EDF6();
	}
}

//Function Number: 57
func_EDF6()
{
	self dodamage(self.health + 950,self.origin,self,self,"MOD_SUICIDE");
}