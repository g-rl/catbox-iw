/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\bots\gametype_assault.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 43
 * Decompile Time: 2237 ms
 * Timestamp: 10/27/2023 12:11:49 AM
*******************************************************************/

//Function Number: 1
main()
{
	setup_callbacks();
	bot_sd_start();
}

//Function Number: 2
setup_callbacks()
{
	level.bot_funcs["crate_can_use"] = ::crate_can_use;
	level.bot_funcs["gametype_think"] = ::bot_sd_think;
	level.bot_funcs["should_start_cautious_approach"] = ::should_start_cautious_approach_sd;
	level.bot_funcs["know_enemies_on_start"] = undefined;
	level.bot_funcs["notify_enemy_bots_bomb_used"] = ::notify_enemy_team_bomb_used;
}

//Function Number: 3
bot_sd_start()
{
	setup_bot_sd();
}

//Function Number: 4
crate_can_use(param_00)
{
	if(isagent(self) && !isdefined(param_00.boxtype))
	{
		return 0;
	}

	if(isdefined(param_00.cratetype) && !scripts\mp\bots\_bots_killstreaks::bot_is_killstreak_supported(param_00.cratetype))
	{
		return 0;
	}

	if(!scripts\mp\_utility::isteamparticipant(self))
	{
		return 1;
	}

	if(!isdefined(self.role))
	{
		return 0;
	}

	switch(self.role)
	{
		case "investigate_someone_using_bomb":
		case "bomb_defuser":
		case "atk_bomber":
			return 0;
	}

	return 1;
}

//Function Number: 5
setup_bot_sd()
{
	level.bots_disable_team_switching = 1;
	level.initial_pickup_wait_time = 3000;
	scripts\mp\bots\_bots_strategy::bot_setup_bombzone_bottargets();
	scripts\mp\bots\_bots_util::bot_waittill_bots_enabled(1);
	level.bot_sd_override_zone_targets = [];
	level.bot_sd_override_zone_targets["axis"] = [];
	level.bot_sd_override_zone_targets["allies"] = [];
	level.bot_default_sd_role_behavior["atk_bomber"] = ::atk_bomber_update;
	level.bot_default_sd_role_behavior["clear_target_zone"] = ::clear_target_zone_update;
	level.bot_default_sd_role_behavior["defend_planted_bomb"] = ::defend_planted_bomb_update;
	level.bot_default_sd_role_behavior["bomb_defuser"] = ::bomb_defuser_update;
	level.bot_default_sd_role_behavior["investigate_someone_using_bomb"] = ::investigate_someone_using_bomb_update;
	level.bot_default_sd_role_behavior["camp_bomb"] = ::camp_bomb_update;
	level.bot_default_sd_role_behavior["defender"] = ::defender_update;
	level.bot_default_sd_role_behavior["backstabber"] = ::backstabber_update;
	level.bot_default_sd_role_behavior["random_killer"] = ::random_killer_update;
	var_00 = 0;
	function_002B(level.curbombzone,game["defenders"]);
}

//Function Number: 6
bot_sd_think()
{
	self notify("bot_sd_think");
	self endon("bot_sd_think");
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	while(!isdefined(level.bot_gametype_precaching_done))
	{
		wait(0.05);
	}

	self botsetflag("separation",0);
	self botsetflag("grenade_objectives",1);
	self botsetflag("use_obj_path_style",1);
	var_00 = game["attackers"];
	var_01 = 1;
	if(isdefined(level.sdbomb) && isdefined(level.sdbomb.carrier) && level.sdbomb.carrier == self && isdefined(self.role) && self.role == "atk_bomber")
	{
		var_01 = 0;
	}

	if(var_01)
	{
		self.role = undefined;
	}

	self.suspend_sd_role = undefined;
	self.has_started_thinking = 0;
	self.atk_bomber_no_path_to_bomb_count = 0;
	self.scripted_path_style = undefined;
	self.defender_set_script_pathstyle = undefined;
	self.defuser_bad_path_counter = 0;
	if(!isdefined(level.initial_bomb_location) && !level.multibomb)
	{
		level.initial_bomb_location = level.sdbomb.curorigin;
		level.initial_bomb_location_nearest_node = getclosestnodeinsight(level.sdbomb.curorigin);
	}

	if(self.team == var_00 && !isdefined(level.can_pickup_bomb_time))
	{
		var_02 = 0;
		if(!level.multibomb)
		{
			var_03 = get_living_players_on_team(var_00);
			foreach(var_05 in var_03)
			{
				if(!isai(var_05))
				{
					var_02 = 1;
				}
			}
		}

		if(var_02)
		{
			var_07 = 6000;
			level.can_pickup_bomb_time = gettime() + var_07;
			badplace_cylinder("bomb",var_07 / 1000,level.sdbomb.curorigin,75,300,var_00);
		}
	}

	for(;;)
	{
		wait(randomintrange(1,3) * 0.05);
		if(self.health <= 0)
		{
			continue;
		}

		self.has_started_thinking = 1;
		if(!isdefined(self.role))
		{
			initialize_sd_role();
		}

		if(isdefined(self.suspend_sd_role))
		{
			continue;
		}

		if(self.team == var_00)
		{
			if(!level.multibomb && isdefined(level.can_pickup_bomb_time) && gettime() < level.can_pickup_bomb_time && !isdefined(level.sdbomb.carrier))
			{
				if(!scripts\mp\bots\_bots_util::bot_is_defending_point(level.sdbomb.curorigin))
				{
					var_08 = getclosestnodeinsight(level.sdbomb.curorigin);
					if(isdefined(var_08))
					{
						var_09["nearest_node_to_center"] = var_08;
						scripts\mp\bots\_bots_strategy::bot_protect_point(level.sdbomb.curorigin,900,var_09);
					}
					else
					{
						level.can_pickup_bomb_time = gettime();
					}
				}
			}
			else
			{
				self [[ level.bot_default_sd_role_behavior[self.role] ]]();
			}

			continue;
		}

		if(level.bombplanted)
		{
			if(distancesquared(self.origin,level.sdbombmodel.origin) > squared(level.protect_radius * 2))
			{
				if(!isdefined(self.defender_set_script_pathstyle))
				{
					self.defender_set_script_pathstyle = 1;
					self getpathactionvalue("scripted");
				}
			}
			else if(isdefined(self.defender_set_script_pathstyle) && !isdefined(self.scripted_path_style))
			{
				self.defender_set_script_pathstyle = undefined;
				self getpathactionvalue(undefined);
			}
		}

		if(level.bombplanted && isdefined(level.bomb_defuser) && self.role != "bomb_defuser")
		{
			if(!scripts\mp\bots\_bots_util::bot_is_defending_point(level.sdbombmodel.origin))
			{
				self botclearscriptgoal();
				scripts\mp\bots\_bots_strategy::bot_protect_point(level.sdbombmodel.origin,level.protect_radius);
			}

			continue;
		}

		self [[ level.bot_default_sd_role_behavior[self.role] ]]();
	}
}

//Function Number: 7
atk_bomber_update()
{
	self endon("new_role");
	if(scripts\mp\bots\_bots_util::bot_is_defending())
	{
		scripts\mp\bots\_bots_strategy::bot_defend_stop();
	}

	if(isdefined(level.sdbomb) && isdefined(level.sdbomb.carrier) && isalive(level.sdbomb.carrier) && level.sdbomb.carrier != self)
	{
		wait(0.7);
	}

	if(!self.isbombcarrier && !level.multibomb)
	{
		if(isdefined(level.sdbomb))
		{
			if(!isdefined(self.last_bomb_location))
			{
				self.last_bomb_location = level.sdbomb.curorigin;
			}

			if(distancesquared(self.last_bomb_location,level.sdbomb.curorigin) > 4)
			{
				self botclearscriptgoal();
				self.last_bomb_location = level.sdbomb.curorigin;
			}
		}

		if(self.atk_bomber_no_path_to_bomb_count >= 2)
		{
			var_01 = getnodesinradiussorted(level.sdbomb.curorigin,512,0);
			var_02 = undefined;
			foreach(var_04 in var_01)
			{
				if(!var_04 getweaponbarsize())
				{
					var_02 = var_04;
					break;
				}
			}

			if(isdefined(var_02))
			{
				self botsetscriptgoal(var_02.origin,20,"critical");
				scripts\mp\bots\_bots_util::bot_waittill_goal_or_fail();
				if(isdefined(level.sdbomb) && !isdefined(level.sdbomb.carrier))
				{
					level.sdbomb scripts\mp\_gameobjects::setpickedup(self);
				}
			}
			else
			{
			}

			return;
		}

		if(!self bothasscriptgoal())
		{
			var_06 = 15;
			var_07 = 32;
			var_08 = scripts\mp\bots\_bots_util::bot_queued_process("BotGetClosestNavigablePoint",::scripts\mp\bots\_bots_util::func_bot_get_closest_navigable_point,level.sdbomb.curorigin,var_06 + var_07,self);
			if(isdefined(var_08))
			{
				var_09 = self botsetscriptgoal(level.sdbomb.curorigin,0,"critical");
				if(var_09)
				{
					childthread bomber_monitor_no_path();
					return;
				}

				return;
			}

			var_01 = getnodesinradiussorted(level.sdbomb.curorigin,512,0);
			if(var_08.size > 0)
			{
				self botsetscriptgoal(var_08[0].origin,0,"critical");
				scripts\mp\bots\_bots_util::bot_waittill_goal_or_fail();
			}

			if(isdefined(level.sdbomb) && !isdefined(level.sdbomb.carrier))
			{
				var_07 = scripts\mp\bots\_bots_util::bot_queued_process("BotGetClosestNavigablePoint",::scripts\mp\bots\_bots_util::func_bot_get_closest_navigable_point,level.sdbomb.curorigin,var_05 + var_06,self);
				if(!isdefined(var_07))
				{
					level.sdbomb scripts\mp\_gameobjects::setpickedup(self);
					return;
				}

				return;
			}

			return;
		}

		return;
	}

	if(isdefined(self.dont_plant_until_time) && gettime() < self.dont_plant_until_time)
	{
		return;
	}

	if(!isdefined(level.bomb_zone_assaulting))
	{
		level.bomb_zone_assaulting = level.curbombzone;
	}

	var_0A = level.bomb_zone_assaulting;
	self.bombzonegoal = var_0A;
	if(!isdefined(level.initial_bomb_pickup_time) || gettime() - level.initial_bomb_pickup_time < level.initial_pickup_wait_time)
	{
		level.initial_bomb_pickup_time = gettime() + level.initial_pickup_wait_time;
		self botclearscriptgoal();
		self botsetscriptgoal(self.origin,0,"tactical");
		wait(level.initial_pickup_wait_time / 1000);
	}

	self botclearscriptgoal();
	if(level.attack_behavior == "rush")
	{
		self getpathactionvalue("scripted");
		var_0B = self getparent(var_0A.bottargets,"node_exposed");
		var_0C = self botgetdifficultysetting("strategyLevel") * 0.45;
		var_0D = self botgetdifficultysetting("strategyLevel") + 1 * 0.15;
		foreach(var_0E in var_0A.bottargets)
		{
			if(!scripts\engine\utility::array_contains(var_0A,var_0E))
			{
				var_0A[var_0A.size] = var_0E;
			}
		}

		if(randomfloat(1) < var_0B)
		{
			var_10 = var_0A[0];
		}
		else if(randomfloat(1) < var_0D)
		{
			var_10 = var_0B[1];
		}
		else
		{
			var_10 = scripts\engine\utility::random(var_0B);
		}

		self botsetscriptgoal(var_10.origin,0,"critical");
	}

	var_11 = scripts\mp\bots\_bots_util::bot_waittill_goal_or_fail();
	if(var_11 == "goal")
	{
		var_12 = get_round_end_time() - gettime();
		var_13 = var_12 - level.planttime * 2 * 1000;
		var_14 = gettime() + var_13;
		if(var_13 > 0)
		{
			scripts\mp\bots\_bots_util::bot_waittill_out_of_combat_or_time(var_13);
		}

		var_15 = gettime() >= var_14;
		var_16 = sd_press_use(level.planttime + 2,"bomb_planted",var_15);
		self botclearscriptgoal();
		if(var_16)
		{
			scripts\mp\bots\_bots_strategy::bot_enable_tactical_goals();
			bot_set_role("defend_planted_bomb");
			return;
		}

		if(var_13 > 5000)
		{
			self.dont_plant_until_time = gettime() + 5000;
			return;
		}

		return;
	}
}

//Function Number: 8
get_round_end_time()
{
	if(level.bombplanted)
	{
		return level.defuseendtime;
	}

	return gettime() + scripts\mp\_gamelogic::gettimeremaining();
}

//Function Number: 9
bomber_monitor_no_path()
{
	self notify("bomber_monitor_no_path");
	self endon("death");
	self endon("disconnect");
	self endon("goal");
	self endon("bomber_monitor_no_path");
	level.sdbomb endon("pickup_object");
	for(;;)
	{
		self waittill("no_path");
		self.var_2414++;
	}
}

//Function Number: 10
clear_target_zone_update()
{
	self endon("new_role");
	if(isdefined(level.atk_bomber))
	{
		if(level.attack_behavior == "rush")
		{
			if(!isdefined(self.set_initial_rush_goal))
			{
				if(!level.multibomb)
				{
					var_00["nearest_node_to_center"] = level.initial_bomb_location_nearest_node;
					scripts\mp\bots\_bots_strategy::bot_protect_point(level.initial_bomb_location,900,var_00);
					wait(randomfloatrange(0,4));
					scripts\mp\bots\_bots_strategy::bot_defend_stop();
				}

				self.set_initial_rush_goal = 1;
			}

			if(self botgetdifficultysetting("strategyLevel") > 0)
			{
				set_force_sprint();
			}

			if(isai(level.atk_bomber) && isdefined(level.atk_bomber.bombzonegoal))
			{
				var_01 = level.atk_bomber.bombzonegoal;
			}
			else if(isdefined(level.bomb_zone_assaulting))
			{
				var_01 = level.bomb_zone_assaulting;
			}
			else
			{
				var_01 = find_closest_bombzone_to_player(level.atk_bomber);
			}

			if(!scripts\mp\bots\_bots_util::bot_is_defending_point(var_01.curorigin))
			{
				var_01["min_goal_time"] = 2;
				var_01["max_goal_time"] = 4;
				var_01["override_origin_node"] = scripts\engine\utility::random(var_01.bottargets);
				scripts\mp\bots\_bots_strategy::bot_protect_point(var_01.curorigin,level.protect_radius,var_01);
				return;
			}
		}
	}
}

//Function Number: 11
defend_planted_bomb_update()
{
	self endon("new_role");
	if(level.bombplanted)
	{
		if(level.attack_behavior == "rush")
		{
			disable_force_sprint();
		}

		if(!scripts\mp\bots\_bots_util::bot_is_defending_point(level.sdbombmodel.origin))
		{
			scripts\mp\bots\_bots_strategy::bot_protect_point(level.sdbombmodel.origin,level.protect_radius);
		}
	}
}

//Function Number: 12
bomb_defuser_update()
{
	self endon("new_role");
	if(level.bombdefused)
	{
		return;
	}

	var_00 = find_ticking_bomb();
	if(!isdefined(var_00))
	{
		return;
	}

	var_01 = scripts\engine\utility::get_array_of_closest(level.sdbombmodel.origin,var_00.bottargets);
	var_02 = (level.sdbombmodel.origin[0],level.sdbombmodel.origin[1],var_01[0].origin[2]);
	var_03 = cautious_approach_till_close(var_02,undefined);
	if(!var_03)
	{
		return;
	}

	var_04 = scripts\mp\bots\_bots_util::bot_waittill_goal_or_fail();
	if(var_04 == "bad_path")
	{
		self.var_50A8++;
		if(self.defuser_bad_path_counter >= 4)
		{
			for(;;)
			{
				var_05 = getnodesinradiussorted(var_02,50,0);
				var_06 = self.defuser_bad_path_counter - 4;
				if(var_05.size <= var_06)
				{
					break;
				}

				self botsetscriptgoal(var_05[var_06].origin,20,"critical");
				var_04 = scripts\mp\bots\_bots_util::bot_waittill_goal_or_fail();
				if(var_04 == "bad_path")
				{
					self.var_50A8++;
					continue;
				}

				break;
			}
		}
	}

	if(var_04 == "goal")
	{
		var_07 = get_round_end_time() - gettime();
		var_08 = var_07 - level.defusetime * 2 * 1000;
		var_09 = gettime() + var_08;
		if(var_08 > 0)
		{
			scripts\mp\bots\_bots_util::bot_waittill_out_of_combat_or_time(var_08);
		}

		var_0A = gettime() >= var_09;
		sd_press_use(level.defusetime + 2,"bomb_defused",var_0A);
		self botclearscriptgoal();
		scripts\mp\bots\_bots_strategy::bot_enable_tactical_goals();
	}
}

//Function Number: 13
investigate_someone_using_bomb_update()
{
	self endon("new_role");
	if(scripts\mp\bots\_bots_util::bot_is_defending())
	{
		scripts\mp\bots\_bots_strategy::bot_defend_stop();
	}

	var_00 = find_closest_bombzone_to_player(self);
	self botsetscriptgoalnode(scripts\engine\utility::random(var_00.bottargets),"guard");
	var_01 = scripts\mp\bots\_bots_util::bot_waittill_goal_or_fail();
	if(var_01 == "goal")
	{
		wait(4);
		bot_set_role(self.prev_role);
	}
}

//Function Number: 14
camp_bomb_update()
{
	self endon("new_role");
	if(isdefined(level.sdbomb.carrier))
	{
		if(self.prev_role == "defender")
		{
			self.defend_zone = find_closest_bombzone_to_player(self);
		}

		bot_set_role(self.prev_role);
		return;
	}

	if(!scripts\mp\bots\_bots_util::bot_is_defending_point(level.sdbomb.curorigin))
	{
		var_00["nearest_node_to_center"] = level.sdbomb.nearest_node_for_camping;
		scripts\mp\bots\_bots_strategy::bot_protect_point(level.sdbomb.curorigin,level.protect_radius,var_00);
	}
}

//Function Number: 15
defender_update()
{
	self endon("new_role");
	if(!scripts\mp\bots\_bots_util::bot_is_defending_point(self.defend_zone.curorigin))
	{
		var_00["score_flags"] = "strict_los";
		var_00["override_origin_node"] = scripts\engine\utility::random(self.defend_zone.bottargets);
		scripts\mp\bots\_bots_strategy::bot_protect_point(self.defend_zone.curorigin,level.protect_radius,var_00);
	}
}

//Function Number: 16
backstabber_update()
{
	self endon("new_role");
	if(scripts\mp\bots\_bots_util::bot_is_defending())
	{
		scripts\mp\bots\_bots_strategy::bot_defend_stop();
	}

	if(!isdefined(self.backstabber_stage))
	{
		self.backstabber_stage = "1_move_to_midpoint";
	}

	if(self.backstabber_stage == "1_move_to_midpoint")
	{
		var_00 = level.bombzones[0].curorigin;
		var_01 = level.bombzones[1].curorigin;
		var_02 = (var_00[0] + var_01[0] * 0.5,var_00[1] + var_01[1] * 0.5,var_00[2] + var_01[2] * 0.5);
		var_03 = getnodesinradiussorted(var_02,512,0);
		if(var_03.size == 0)
		{
			bot_set_role("random_killer");
			return;
		}

		var_04 = undefined;
		var_05 = int(var_03.size * var_03.size + 1 * 0.5);
		var_06 = randomint(var_05);
		for(var_07 = 0;var_07 < var_03.size;var_07++)
		{
			var_08 = var_03.size - var_07;
			if(var_06 < var_08)
			{
				var_04 = var_03[var_07];
				break;
			}

			var_06 = var_06 - var_08;
		}

		self getpathactionvalue("scripted");
		var_09 = self botsetscriptgoalnode(var_04,"guard");
		if(var_09)
		{
			var_0A = scripts\mp\bots\_bots_util::bot_waittill_goal_or_fail();
			if(var_0A == "goal")
			{
				wait(randomfloatrange(1,4));
				self.backstabber_stage = "2_move_to_enemy_spawn";
			}
		}
	}

	if(self.backstabber_stage == "2_move_to_enemy_spawn")
	{
		var_0B = scripts\mp\_spawnlogic::getspawnpointarray("mp_sd_spawn_attacker");
		var_0C = scripts\engine\utility::random(var_0B);
		self getpathactionvalue("scripted");
		var_09 = self botsetscriptgoal(var_0C.origin,250,"guard");
		if(var_09)
		{
			var_0A = scripts\mp\bots\_bots_util::bot_waittill_goal_or_fail();
			if(var_0A == "goal")
			{
				self.backstabber_stage = "3_move_to_bombzone";
			}
		}
	}

	if(self.backstabber_stage == "3_move_to_bombzone")
	{
		if(!isdefined(self.bombzone_num_picked))
		{
			self.bombzone_num_picked = randomint(level.bombzones.size);
		}

		self getpathactionvalue(undefined);
		var_09 = self botsetscriptgoal(scripts\engine\utility::random(level.bombzones[self.bombzone_num_picked].bottargets).origin,160,"objective");
		if(var_09)
		{
			var_0A = scripts\mp\bots\_bots_util::bot_waittill_goal_or_fail();
			if(var_0A == "goal")
			{
				self botclearscriptgoal();
				self.backstabber_stage = "2_move_to_enemy_spawn";
				self.bombzone_num_picked = 1 - self.bombzone_num_picked;
				return;
			}
		}
	}
}

//Function Number: 17
random_killer_update()
{
	self endon("new_role");
	if(scripts\mp\bots\_bots_util::bot_is_defending())
	{
		scripts\mp\bots\_bots_strategy::bot_defend_stop();
	}

	self [[ self.personality_update_function ]]();
}

//Function Number: 18
set_force_sprint()
{
	if(!isdefined(self.always_sprint))
	{
		self botsetflag("force_sprint",1);
		self.always_sprint = 1;
	}
}

//Function Number: 19
disable_force_sprint()
{
	if(isdefined(self.always_sprint))
	{
		self botsetflag("force_sprint",0);
		self.always_sprint = undefined;
	}
}

//Function Number: 20
set_scripted_pathing_style()
{
	if(!isdefined(self.scripted_path_style))
	{
		self getpathactionvalue("scripted");
		self.scripted_path_style = 1;
	}
}

//Function Number: 21
cautious_approach_till_close(param_00,param_01)
{
	var_02 = level.capture_radius;
	var_03["entrance_points_index"] = param_01;
	scripts\mp\bots\_bots_strategy::bot_capture_point(param_00,var_02,var_03);
	wait(0.05);
	while(distancesquared(self.origin,param_00) > var_02 * var_02 && scripts\mp\bots\_bots_util::bot_is_defending())
	{
		if(get_round_end_time() - gettime() < 20000)
		{
			set_scripted_pathing_style();
			set_force_sprint();
			break;
		}

		wait(0.05);
	}

	if(scripts\mp\bots\_bots_util::bot_is_defending())
	{
		scripts\mp\bots\_bots_strategy::bot_defend_stop();
	}

	return self botsetscriptgoal(param_00,20,"critical");
}

//Function Number: 22
sd_press_use(param_00,param_01,param_02)
{
	var_03 = 0;
	if(self botgetdifficultysetting("strategyLevel") == 1)
	{
		var_03 = 40;
	}
	else if(self botgetdifficultysetting("strategyLevel") >= 2)
	{
		var_03 = 80;
	}

	if(randomint(100) < var_03)
	{
		self botsetstance("prone");
		wait(0.2);
	}

	if(self botgetdifficultysetting("strategyLevel") > 0 && !param_02)
	{
		thread notify_on_whizby();
		thread notify_on_damage();
	}

	self botpressbutton("use",param_00);
	var_04 = scripts\mp\bots\_bots_util::bot_usebutton_wait(param_00,param_01,"use_interrupted");
	self botsetstance("none");
	self getothermode("use");
	var_05 = var_04 == param_01;
	return var_05;
}

//Function Number: 23
notify_enemy_team_bomb_used(param_00)
{
	var_01 = get_living_players_on_team(scripts\engine\utility::get_enemy_team(self.team),1);
	foreach(var_03 in var_01)
	{
		var_04 = 0;
		if(param_00 == "plant")
		{
			var_04 = 300 + var_03 botgetdifficultysetting("strategyLevel") * 100;
		}
		else if(param_00 == "defuse")
		{
			var_04 = 500 + var_03 botgetdifficultysetting("strategyLevel") * 500;
		}

		if(distancesquared(var_03.origin,self.origin) < squared(var_04))
		{
			var_03 bot_set_role("investigate_someone_using_bomb");
		}
	}
}

//Function Number: 24
notify_on_whizby()
{
	var_00 = find_closest_bombzone_to_player(self);
	self waittill("bulletwhizby",var_01);
	if(!isdefined(var_01.team) || var_01.team != self.team)
	{
		var_02 = var_00.usetime - var_00.curprogress;
		if(var_02 > 1000)
		{
			self notify("use_interrupted");
		}
	}
}

//Function Number: 25
notify_on_damage()
{
	self waittill("damage",var_00,var_01);
	if(!isdefined(var_01.team) || var_01.team != self.team)
	{
		self notify("use_interrupted");
	}
}

//Function Number: 26
should_start_cautious_approach_sd(param_00)
{
	var_01 = 2000;
	var_02 = var_01 * var_01;
	if(param_00)
	{
		if(get_round_end_time() - gettime() < 15000)
		{
			return 0;
		}

		var_03 = 0;
		var_04 = scripts\engine\utility::get_enemy_team(self.team);
		foreach(var_06 in level.players)
		{
			if(!isdefined(var_06.team))
			{
				continue;
			}

			if(isalive(var_06) && var_06.team == var_04)
			{
				var_03 = 1;
			}
		}

		return var_03;
	}

	return distancesquared(self.origin,self.bot_defending_center) <= var_07 && self botpursuingscriptgoal();
}

//Function Number: 27
find_closest_bombzone_to_player(param_00)
{
	var_01 = undefined;
	var_02 = 999999999;
	foreach(var_04 in level.bombzones)
	{
		var_05 = distancesquared(var_04.curorigin,param_00.origin);
		if(var_05 < var_02)
		{
			var_01 = var_04;
			var_02 = var_05;
		}
	}

	return var_01;
}

//Function Number: 28
get_players_defending_zone(param_00)
{
	var_01 = [];
	var_02 = get_living_players_on_team(game["defenders"]);
	foreach(var_04 in var_02)
	{
		if(isai(var_04) && isdefined(var_04.role) && var_04.role == "defender")
		{
			if(isdefined(var_04.defend_zone) && var_04.defend_zone == param_00)
			{
				var_01 = scripts\engine\utility::array_add(var_01,var_04);
			}

			continue;
		}

		if(distancesquared(var_04.origin,param_00.curorigin) < level.protect_radius * level.protect_radius)
		{
			var_01 = scripts\engine\utility::array_add(var_01,var_04);
		}
	}

	return var_01;
}

//Function Number: 29
find_ticking_bomb()
{
	if(isdefined(level.tickingobject))
	{
		foreach(var_01 in level.bombzones)
		{
			if(distancesquared(level.tickingobject.origin,var_01.curorigin) < 90000)
			{
				return var_01;
			}
		}
	}

	return undefined;
}

//Function Number: 30
get_specific_zone(param_00)
{
	param_00 = "_" + tolower(param_00);
	for(var_01 = 0;var_01 < level.bombzones.size;var_01++)
	{
		if(level.bombzones[var_01].label == param_00)
		{
			return level.bombzones[var_01];
		}
	}
}

//Function Number: 31
bomber_wait_for_death()
{
	self endon("stopped_being_bomb_carrier");
	self endon("new_role");
	scripts\engine\utility::waittill_any_3("death","disconnect");
	level.atk_bomber = undefined;
	level.last_atk_bomber_death_time = gettime();
	if(isdefined(self))
	{
		self.role = undefined;
	}

	var_00 = get_living_players_on_team(game["attackers"],1);
	force_all_players_to_role(var_00,undefined);
}

//Function Number: 32
bomber_wait_for_bomb_reset()
{
	self endon("death");
	self endon("disconnect");
	self endon("stopped_being_bomb_carrier");
	level.sdbomb endon("pickup_object");
	level.sdbomb waittill("reset");
	if(scripts\mp\_utility::isaiteamparticipant(self))
	{
		self botclearscriptgoal();
	}

	bot_set_role("atk_bomber");
}

//Function Number: 33
set_new_bomber()
{
	level.atk_bomber = self;
	bot_set_role("atk_bomber");
	thread bomber_wait_for_death();
	if(!level.multibomb)
	{
		thread bomber_wait_for_bomb_reset();
	}

	if(isai(self))
	{
		scripts\mp\bots\_bots_strategy::bot_disable_tactical_goals();
		if(level.attack_behavior == "rush" && self botgetdifficultysetting("strategyLevel") > 0)
		{
			set_force_sprint();
		}
	}
}

//Function Number: 34
initialize_sd_role()
{
	if(self.team == game["attackers"])
	{
		if(level.bombplanted)
		{
			bot_set_role("defend_planted_bomb");
			return;
		}

		if(!isdefined(level.atk_bomber))
		{
			set_new_bomber();
			return;
		}

		if(level.attack_behavior == "rush")
		{
			bot_set_role("clear_target_zone");
			return;
		}

		return;
	}

	var_00 = get_players_by_role("backstabber");
	var_01 = get_players_by_role("defender");
	var_02 = level.bot_personality_type[self.personality];
	var_03 = self botgetdifficultysetting("strategyLevel");
	if(var_02 == "active")
	{
		if(!isdefined(self.role) && level.allow_backstabbers && var_03 > 0)
		{
			if(var_00.size == 0)
			{
				bot_set_role("backstabber");
			}
			else
			{
				var_04 = 1;
				foreach(var_06 in var_00)
				{
					var_07 = level.bot_personality_type[var_06.personality];
					if(var_07 == "active")
					{
						var_04 = 0;
						break;
					}
				}

				if(var_04)
				{
					bot_set_role("backstabber");
					var_00[0] bot_set_role(undefined);
				}
			}
		}

		if(!isdefined(self.role))
		{
			if(var_01.size < 4)
			{
				bot_set_role("defender");
			}
		}

		if(!isdefined(self.role))
		{
			var_09 = randomint(4);
			if(var_09 == 3 && level.allow_random_killers && var_03 > 0)
			{
				bot_set_role("random_killer");
			}
			else if(var_09 == 2 && level.allow_backstabbers && var_03 > 0)
			{
				bot_set_role("backstabber");
			}
			else
			{
				bot_set_role("defender");
			}
		}
	}
	else if(var_02 == "stationary")
	{
		if(!isdefined(self.role))
		{
			if(var_01.size < 4)
			{
				bot_set_role("defender");
			}
			else
			{
				foreach(var_0B in var_01)
				{
					var_0C = level.bot_personality_type[var_0B.personality];
					if(var_0C == "active")
					{
						bot_set_role("defender");
						var_0B bot_set_role(undefined);
						break;
					}
				}
			}
		}

		if(!isdefined(self.role) && level.allow_backstabbers && var_03 > 0)
		{
			if(var_00.size == 0)
			{
				bot_set_role("backstabber");
			}
		}

		if(!isdefined(self.role))
		{
			bot_set_role("defender");
		}
	}

	if(self.role == "defender")
	{
		var_0E = level.bombzones;
		if(has_override_zone_targets(self.team))
		{
			var_0E = get_override_zone_targets(self.team);
		}

		if(var_0E.size == 1)
		{
			self.defend_zone = var_0E[0];
			return;
		}

		var_0F = get_players_defending_zone(var_0E[0]);
		var_10 = get_players_defending_zone(var_0E[1]);
		if(var_0F.size < var_10.size)
		{
			self.defend_zone = var_0E[0];
			return;
		}

		if(var_10.size < var_0F.size)
		{
			self.defend_zone = var_0E[1];
			return;
		}

		self.defend_zone = scripts\engine\utility::random(var_0E);
		return;
	}
}

//Function Number: 35
bot_set_role(param_00)
{
	if(isai(self))
	{
		scripts\mp\bots\_bots_strategy::bot_defend_stop();
		self getpathactionvalue(undefined);
	}

	self.prev_role = self.role;
	self.role = param_00;
	self notify("new_role");
}

//Function Number: 36
bot_set_role_delayed(param_00,param_01)
{
	self endon("death");
	self endon("disconnect");
	self endon("new_role");
	wait(param_01);
	bot_set_role(param_00);
}

//Function Number: 37
force_all_players_to_role(param_00,param_01,param_02)
{
	foreach(var_04 in param_00)
	{
		if(isdefined(param_02))
		{
			var_04 thread bot_set_role_delayed(param_01,randomfloatrange(0,param_02));
			continue;
		}

		var_04 thread bot_set_role(param_01);
	}
}

//Function Number: 38
get_override_zone_targets(param_00)
{
	return level.bot_sd_override_zone_targets[param_00];
}

//Function Number: 39
has_override_zone_targets(param_00)
{
	var_01 = get_override_zone_targets(param_00);
	return var_01.size > 0;
}

//Function Number: 40
get_players_by_role(param_00)
{
	var_01 = [];
	foreach(var_03 in level.participants)
	{
		if(isalive(var_03) && scripts\mp\_utility::isteamparticipant(var_03) && isdefined(var_03.role) && var_03.role == param_00)
		{
			var_01[var_01.size] = var_03;
		}
	}

	return var_01;
}

//Function Number: 41
get_living_players_on_team(param_00,param_01)
{
	var_02 = [];
	foreach(var_04 in level.participants)
	{
		if(!isdefined(var_04.team))
		{
			continue;
		}

		if(scripts\mp\_utility::isreallyalive(var_04) && scripts\mp\_utility::isteamparticipant(var_04) && var_04.team == param_00)
		{
			if(!isdefined(param_01) || param_01 && isai(var_04) && isdefined(var_04.role))
			{
				var_02[var_02.size] = var_04;
			}
		}
	}

	return var_02;
}

//Function Number: 42
bot_sd_ai_director_update()
{
	level notify("bot_sd_ai_director_update");
	level endon("bot_sd_ai_director_update");
	level endon("game_ended");
	level.allow_backstabbers = randomint(3) <= 1;
	level.allow_random_killers = randomint(3) <= 1;
	level.attack_behavior = "rush";
	level.protect_radius = 725;
	level.capture_radius = 140;
	for(;;)
	{
		if(isdefined(level.sdbomb) && isdefined(level.sdbomb.carrier) && !isai(level.sdbomb.carrier))
		{
			level.bomb_zone_assaulting = find_closest_bombzone_to_player(level.sdbomb.carrier);
		}

		var_00 = 0;
		if(!level.bombplanted)
		{
			var_01 = get_living_players_on_team(game["attackers"]);
			foreach(var_03 in var_01)
			{
				if(var_03.isbombcarrier)
				{
					level.can_pickup_bomb_time = gettime();
					if(!isdefined(level.atk_bomber) || var_03 != level.atk_bomber)
					{
						if(isdefined(level.atk_bomber) && isalive(level.atk_bomber))
						{
							level.atk_bomber bot_set_role(undefined);
							level.atk_bomber notify("stopped_being_bomb_carrier");
						}

						var_00 = 1;
						var_03 set_new_bomber();
					}
				}
			}

			if(!level.multibomb && !isdefined(level.sdbomb.carrier))
			{
				var_05 = getclosestnodeinsight(level.sdbomb.curorigin);
				if(isdefined(var_05))
				{
					level.sdbomb.nearest_node_for_camping = var_05;
					var_06 = 0;
					var_07 = get_living_players_on_team(game["defenders"],1);
					foreach(var_09 in var_07)
					{
						var_0A = var_09 getnearestnode();
						var_0B = var_09 botgetdifficultysetting("strategyLevel");
						if(var_0B > 0 && var_09.role != "camp_bomb" && isdefined(var_0A) && nodesvisible(var_05,var_0A,1))
						{
							var_0C = var_09 botgetfovdot();
							if(scripts\engine\utility::within_fov(var_09.origin,var_09.angles,level.sdbomb.curorigin,var_0C))
							{
								if(var_0B >= 2 || distancesquared(var_09.origin,level.sdbomb.curorigin) < squared(700))
								{
									var_06 = 1;
									break;
								}
							}
						}
					}

					if(var_06)
					{
						foreach(var_09 in var_07)
						{
							if(var_09.role != "camp_bomb" && var_09 botgetdifficultysetting("strategyLevel") > 0)
							{
								var_09 bot_set_role("camp_bomb");
							}
						}
					}
				}
			}

			var_10 = level.bombzones;
			if(has_override_zone_targets(game["defenders"]))
			{
				var_10 = get_override_zone_targets(game["defenders"]);
			}

			for(var_11 = 0;var_11 < var_10.size;var_11++)
			{
				for(var_12 = 0;var_12 < var_10.size;var_12++)
				{
					var_13 = get_players_defending_zone(var_10[var_11]);
					var_14 = get_players_defending_zone(var_10[var_12]);
					if(var_13.size > var_14.size + 1)
					{
						var_15 = [];
						foreach(var_03 in var_13)
						{
							if(isai(var_03))
							{
								var_15 = scripts\engine\utility::array_add(var_15,var_03);
							}
						}

						if(var_15.size > 0)
						{
							var_18 = scripts\engine\utility::random(var_15);
							var_18 scripts\mp\bots\_bots_strategy::bot_defend_stop();
							var_18.defend_zone = var_10[var_12];
						}
					}
				}
			}
		}
		else
		{
			if(isdefined(level.atk_bomber))
			{
				level.atk_bomber = undefined;
			}

			if(!isdefined(level.bomb_defuser) || !isalive(level.bomb_defuser))
			{
				var_19 = [];
				var_1A = get_players_by_role("defender");
				var_1B = get_players_by_role("backstabber");
				var_1C = get_players_by_role("random_killer");
				if(var_1A.size > 0)
				{
					var_19 = var_1A;
				}
				else if(var_1B.size > 0)
				{
					var_19 = var_1B;
				}
				else if(var_1C.size > 0)
				{
					var_19 = var_1C;
				}

				if(var_19.size > 0)
				{
					var_1D = scripts\engine\utility::get_array_of_closest(level.sdbombmodel.origin,var_19);
					level.bomb_defuser = var_1D[0];
					level.bomb_defuser bot_set_role("bomb_defuser");
					level.bomb_defuser scripts\mp\bots\_bots_strategy::bot_disable_tactical_goals();
					level.bomb_defuser thread defuser_wait_for_death();
				}
			}

			if(!isdefined(level.sd_bomb_just_planted))
			{
				level.sd_bomb_just_planted = 1;
				var_1E = get_living_players_on_team(game["attackers"]);
				foreach(var_03 in var_1E)
				{
					if(isdefined(var_03.role))
					{
						if(var_03.role == "atk_bomber")
						{
							var_03 thread bot_set_role(undefined);
							continue;
						}

						if(var_03.role != "defend_planted_bomb")
						{
							var_03 thread bot_set_role_delayed("defend_planted_bomb",randomfloatrange(0,3));
						}
					}
				}
			}
		}

		wait(0.5);
	}
}

//Function Number: 43
defuser_wait_for_death()
{
	scripts\engine\utility::waittill_any_3("death","disconnect");
	level.bomb_defuser = undefined;
}