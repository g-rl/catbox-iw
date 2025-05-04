/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 2644.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 33
 * Decompile Time: 3 ms
 * Timestamp: 10/27/2023 12:23:33 AM
*******************************************************************/

//Function Number: 1
init_gamescore()
{
	register_scoring_mode();
}

//Function Number: 2
register_scoring_mode()
{
	if(scripts\cp\utility::isplayingsolo())
	{
		setomnvar("zm_ui_is_solo",1);
		return;
	}

	setomnvar("zm_ui_is_solo",0);
}

//Function Number: 3
register_eog_score_component(param_00,param_01)
{
	if(!isdefined(level.eog_score_components))
	{
		level.eog_score_components = [];
	}

	var_02 = spawnstruct();
	var_02.lua_string_index = param_01;
	level.eog_score_components[param_00] = var_02;
}

//Function Number: 4
register_encounter_score_component(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07)
{
	var_08 = spawnstruct();
	var_08 = [[ param_01 ]](var_08);
	var_08.reset_team_performance_func = param_02;
	var_08.reset_player_performance_func = param_03;
	var_08.calculate_func = param_04;
	var_08.lua_string_index = param_05;
	var_08.end_game_score_component_ref = param_06;
	if(isdefined(param_07))
	{
		var_08.player_init_func = param_07;
	}

	level.encounter_score_components[param_00] = var_08;
}

//Function Number: 5
has_eog_score_component(param_00)
{
	return has_score_component_internal(level.eog_score_components,param_00);
}

//Function Number: 6
has_score_component_internal(param_00,param_01)
{
	if(is_scoring_disabled())
	{
		return 0;
	}

	if(!isdefined(param_00))
	{
		return 0;
	}

	return isdefined(param_00[param_01]);
}

//Function Number: 7
is_scoring_disabled()
{
	if(isdefined(level.isscoringdisabled))
	{
		return [[ level.isscoringdisabled ]]();
	}

	return 0;
}

//Function Number: 8
init_player_score()
{
	if(is_scoring_disabled())
	{
		return;
	}

	self.encounter_performance = [];
	self.end_game_score = [];
	component_specific_init(self);
	reset_player_encounter_performance(self);
	reset_end_game_score();
}

//Function Number: 9
component_specific_init(param_00)
{
	foreach(var_02 in level.encounter_score_components)
	{
		if(isdefined(var_02.player_init_func))
		{
			[[ var_02.player_init_func ]](param_00);
		}
	}
}

//Function Number: 10
reset_player_encounter_performance(param_00)
{
	foreach(var_02 in level.encounter_score_components)
	{
		if(isdefined(var_02.reset_player_performance_func))
		{
			[[ var_02.reset_player_performance_func ]](param_00);
		}
	}
}

//Function Number: 11
reset_end_game_score()
{
	foreach(var_02, var_01 in level.eog_score_components)
	{
		self.end_game_score[var_02] = 0;
	}
}

//Function Number: 12
reset_encounter_performance()
{
	foreach(var_01 in level.encounter_score_components)
	{
		if(isdefined(var_01.reset_team_performance_func))
		{
			[[ var_01.reset_team_performance_func ]](var_01);
		}
	}

	reset_players_encounter_performance_and_lua();
}

//Function Number: 13
reset_players_encounter_performance_and_lua()
{
	foreach(var_01 in level.players)
	{
		reset_player_encounter_performance(var_01);
		reset_player_encounter_lua_omnvars(var_01);
	}
}

//Function Number: 14
calculate_players_total_end_game_score(param_00)
{
	if(is_scoring_disabled())
	{
		return;
	}

	if(isdefined(level.endgameencounterscorefunc))
	{
		[[ level.endgameencounterscorefunc ]](param_00);
	}

	foreach(var_02 in level.players)
	{
		calculate_total_end_game_score(var_02);
	}
}

//Function Number: 15
calculate_total_end_game_score(param_00)
{
	var_01 = 1;
	var_02 = 0;
	foreach(var_06, var_04 in level.eog_score_components)
	{
		var_05 = param_00.end_game_score[var_06];
		var_01++;
		var_02 = var_02 + var_05;
	}
}

//Function Number: 16
calculate_and_show_encounter_scores(param_00,param_01)
{
	calculate_encounter_scores(param_00,param_01);
	show_encounter_scores();
}

//Function Number: 17
calculate_encounter_scores(param_00,param_01,param_02)
{
	foreach(var_04 in param_00)
	{
		calculate_player_encounter_scores(var_04,param_01,param_02);
	}
}

//Function Number: 18
calculate_player_encounter_scores(param_00,param_01,param_02)
{
	var_03 = 1;
	var_04 = 0;
	foreach(var_06 in param_01)
	{
		var_07 = level.encounter_score_components[var_06];
		var_08 = [[ var_07.calculate_func ]](param_00,var_07);
		var_08 = var_08 * level.cycle_score_scalar;
		var_08 = int(var_08);
		param_00.end_game_score[var_07.end_game_score_component_ref] = param_00.end_game_score[var_07.end_game_score_component_ref] + var_08;
		set_lua_encounter_score_row(param_00,var_03,var_07.lua_string_index,var_08);
		var_04 = var_04 + var_08;
		var_03++;
	}

	if(isdefined(level.bonusscorefunc))
	{
		var_0A = [[ level.bonusscorefunc ]](param_00,var_04);
		var_04 = var_04 + var_0A.var_3C;
		set_lua_encounter_score_row(param_00,var_03,var_0A.var_12B27,var_0A.var_3C);
		var_03++;
	}

	param_00 scripts\cp\cp_persistence::eog_player_update_stat("score",var_04,param_02);
	set_lua_encounter_score_row(param_00,var_03,6,var_04);
	var_03++;
	if(isdefined(level.postencounterscorefunc))
	{
		[[ level.postencounterscorefunc ]](param_00,var_04,var_03);
	}
}

//Function Number: 19
round_up_to_nearest(param_00,param_01)
{
	var_02 = param_00 / param_01;
	var_02 = ceil(var_02);
	return int(var_02 * param_01);
}

//Function Number: 20
update_players_encounter_performance(param_00,param_01,param_02)
{
	foreach(var_04 in level.players)
	{
		var_04 update_personal_encounter_performance(param_00,param_01,param_02);
	}
}

//Function Number: 21
update_personal_encounter_performance(param_00,param_01,param_02)
{
	if(!has_encounter_score_component(param_00))
	{
		return;
	}

	if(!isplayer(self))
	{
		return;
	}

	self.encounter_performance = update_encounter_performance_internal(self.encounter_performance,param_01,param_02);
}

//Function Number: 22
update_encounter_performance_internal(param_00,param_01,param_02)
{
	if(!isdefined(param_02))
	{
		param_02 = 1;
	}

	param_00[param_01] = param_00[param_01] + param_02;
	return param_00;
}

//Function Number: 23
get_team_encounter_performance(param_00,param_01)
{
	return param_00.team_encounter_performance[param_01];
}

//Function Number: 24
has_encounter_score_component(param_00)
{
	return has_score_component_internal(level.encounter_score_components,param_00);
}

//Function Number: 25
get_player_encounter_performance(param_00,param_01)
{
	return param_00.encounter_performance[param_01];
}

//Function Number: 26
calculate_under_max_score(param_00,param_01,param_02)
{
	var_03 = clamp(param_01 - param_00,0,param_01);
	return int(var_03 / param_01 * param_02);
}

//Function Number: 27
update_team_encounter_performance(param_00,param_01,param_02)
{
	if(!has_encounter_score_component(param_00))
	{
		return;
	}

	if(!isdefined(param_02))
	{
		param_02 = 1;
	}

	level.encounter_score_components[param_00].team_encounter_performance[param_01] = level.encounter_score_components[param_00].team_encounter_performance[param_01] + param_02;
}

//Function Number: 28
blank_score_component_init(param_00)
{
	return param_00;
}

//Function Number: 29
get_team_score_component_name()
{
	return scripts\engine\utility::ter_op(isdefined(level.team_score_component_name),level.team_score_component_name,"team");
}

//Function Number: 30
reset_player_encounter_lua_omnvars(param_00)
{
	var_01 = 8;
	for(var_02 = 1;var_02 <= var_01;var_02++)
	{
		var_03 = "ui_alien_encounter_title_row_" + var_02;
		var_04 = "ui_alien_encounter_score_row_" + var_02;
		param_00 setclientomnvar(var_03,0);
		param_00 setclientomnvar(var_04,0);
	}
}

//Function Number: 31
set_lua_eog_score_row(param_00,param_01,param_02,param_03)
{
	var_04 = "zm_ui_eog_title_row_" + param_01;
	var_05 = "zm_ui_eog_title_row_" + param_01;
	param_00 setclientomnvar(var_04,param_02);
	param_00 setclientomnvar(var_05,param_03);
}

//Function Number: 32
show_encounter_scores()
{
	level endon("game_ended ");
	setomnvar("zm_ui_show_encounter_score",1);
	wait(1);
	setomnvar("zm_ui_show_encounter_score",0);
}

//Function Number: 33
set_lua_encounter_score_row(param_00,param_01,param_02,param_03)
{
	var_04 = "ui_alien_encounter_title_row_" + param_01;
	var_05 = "ui_alien_encounter_score_row_" + param_01;
}