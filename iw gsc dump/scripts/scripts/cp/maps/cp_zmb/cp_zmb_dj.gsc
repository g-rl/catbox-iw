/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\cp\maps\cp_zmb\cp_zmb_dj.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 144
 * Decompile Time: 7309 ms
 * Timestamp: 10/27/2023 12:08:10 AM
*******************************************************************/

//Function Number: 1
init_dj_quests()
{
	level.played_dj_vos = [];
	level.played_dj_vos[""] = 0;
	scripts/cp/zombies/zombie_quest::register_quest_step("ufo",0,::init_fetch_quest,::do_fetch_quest,::complete_fetch_quest,::debug_beat_fetch_quest);
	scripts/cp/zombies/zombie_quest::register_quest_step("ufo",1,::blank,::wait_use_pap_portal,::blank,::debug_use_pap_portal);
	scripts/cp/zombies/zombie_quest::register_quest_step("ufo",2,::init_first_speaker_defense,::do_first_speaker_defend,::blank,::debug_beat_speaker_defense);
	scripts/cp/zombies/zombie_quest::register_quest_step("ufo",3,::init_second_speaker_defense,::do_second_speaker_defend,::blank,::debug_beat_speaker_defense);
	scripts/cp/zombies/zombie_quest::register_quest_step("ufo",4,::init_third_speaker_defense,::do_third_speaker_defend,::complete_all_speaker_defense,::debug_beat_speaker_defense);
	scripts/cp/zombies/zombie_quest::register_quest_step("ufo",5,::blank,::wait_one_wave,::blank,::debug_beat_wait_one_wave);
	scripts/cp/zombies/zombie_quest::register_quest_step("ufo",6,::init_get_tone_generator,::get_tone_generator,::complete_get_tone_generator,::debug_get_tone_generator);
	scripts/cp/zombies/zombie_quest::register_quest_step("ufo",7,::init_place_tone_generator,::place_tone_generator,::complete_place_tone_generator,::debug_place_tone_generator);
	scripts/cp/zombies/zombie_quest::register_quest_step("ufo",8,::init_match_ufo_tone,::match_ufo_tone,::complete_match_ufo_tone,::debug_match_ufo_tone);
	scripts/cp/zombies/zombie_quest::register_quest_step("ufo",9,::blank,::ufo_suicide_bomber,::blank,::debug_beat_ufo_suicide_bomber);
	scripts/cp/zombies/zombie_quest::register_quest_step("ufo",10,::init_alien_grey_fight,::alien_grey_fight,::complete_grey_fight,::debug_beat_alien_grey_fight);
	scripts/cp/zombies/zombie_quest::register_quest_step("ufo",11,::init_ufo_projectile_attack,::ufo_projectile_attack,::complete_ufo_projectile_attack,::debug_beat_ufo_projectile_attack);
}

//Function Number: 2
dj_quest_dialogue_vo()
{
	for(;;)
	{
		if(isdefined(level.played_dj_vos["dj_quest_ufo_partsrecovery_start"]))
		{
			level thread scripts\cp\cp_vo::try_to_play_vo("quest_dj_intro_1","zmb_dialogue_vo");
			return;
		}

		wait(1);
	}
}

//Function Number: 3
init_fetch_quest()
{
	level.selected_dj_parts = [];
	level.use_dj_door_func = ::fetch_quest_use_dj_door;
	scripts\engine\utility::flag_init("dj_fetch_quest_completed");
	scripts\engine\utility::flag_init("ufo_destroyed");
}

//Function Number: 4
debug_dj_location()
{
	for(;;)
	{
		if(getdvar("scr_dj_location") != "")
		{
			level thread setup_dj_doors();
			setdvar("scr_dj_location","");
		}

		wait(1);
	}
}

//Function Number: 5
complete_fetch_quest()
{
	if(!scripts\engine\utility::istrue(level.dj_part_1_found))
	{
		pick_up_part_1(level.selected_dj_parts[1],level.players[0]);
	}

	if(!scripts\engine\utility::istrue(level.dj_part_2_found))
	{
		pick_up_part_2(level.selected_dj_parts[2],level.players[0]);
	}

	if(!scripts\engine\utility::istrue(level.dj_part_3_found))
	{
		pick_up_part_3(level.selected_dj_parts[3],level.players[0]);
	}
}

//Function Number: 6
do_fetch_quest()
{
	scripts\engine\utility::flag_wait("dj_fetch_quest_completed");
}

//Function Number: 7
debug_beat_fetch_quest()
{
}

//Function Number: 8
fetch_quest_use_dj_door(param_00,param_01)
{
	if(!isdefined(level.first_time_use_door_allparts))
	{
		level.first_time_use_door_allparts = 0;
	}

	level thread play_dj_parts_quest_vo(param_01,param_00);
}

//Function Number: 9
play_dj_willard_exchange(param_00)
{
	level.pause_nag_vo = 1;
	level.disable_broadcast = 1;
	scripts\cp\maps\cp_zmb\cp_zmb_vo::clear_up_all_vo(param_00);
	scripts\cp\cp_vo::func_C9CB([param_00]);
	level.dj set_dj_state("approach_mic");
	if(randomint(100) >= 50)
	{
		playsoundatpos(level.dj.origin,"dj_dj_noparts_1");
		wait(scripts\cp\cp_vo::get_sound_length("dj_dj_noparts_1"));
		if(param_00.vo_prefix == "p6_")
		{
			param_00 playlocalsound("p6_plr_dj_noparts_2");
		}
		else
		{
			param_00 playlocalsound("p6_dj_noparts_2");
		}

		wait(scripts\cp\cp_vo::get_sound_length("p6_dj_noparts_2"));
		playsoundatpos(level.dj.origin,"dj_dj_noparts_3");
		wait(scripts\cp\cp_vo::get_sound_length("dj_dj_noparts_3"));
	}
	else
	{
		playsoundatpos(level.dj.origin,"dj_dj_quest_success_1");
		wait(scripts\cp\cp_vo::get_sound_length("dj_dj_quest_success_1"));
		if(param_00.vo_prefix == "p6_")
		{
			param_00 playlocalsound("p6_plr_dj_quest_success_2");
		}
		else
		{
			param_00 playlocalsound("p6_dj_quest_success_2");
		}

		wait(scripts\cp\cp_vo::get_sound_length("p6_dj_quest_success_2"));
		playsoundatpos(level.dj.origin,"dj_dj_quest_success_3");
		wait(scripts\cp\cp_vo::get_sound_length("dj_dj_quest_success_3"));
	}

	level.dj set_dj_state("open_window");
	scripts\cp\cp_vo::func_12BE3([param_00]);
	level.pause_nag_vo = 0;
	level.disable_broadcast = undefined;
}

//Function Number: 10
play_dj_parts_quest_vo(param_00,param_01)
{
	level.disable_broadcast = 1;
	scripts\cp\cp_interaction::remove_from_current_interaction_list(param_01);
	if(isdefined(param_00.vo_prefix))
	{
		if(param_00.vo_prefix == "p5_" || param_00.vo_prefix == "p6_")
		{
			param_00 thread scripts\cp\cp_vo::try_to_play_vo("quest_intro","zmb_comment_vo");
			wait(scripts\cp\cp_vo::get_sound_length(param_00.vo_prefix + "quest_intro") + 3);
		}
	}

	if(get_num_of_dj_quest_parts_collected() == 0)
	{
		if(randomint(100) > 50)
		{
			if(param_00.vo_prefix == "p6_")
			{
				play_dj_willard_exchange(param_00);
			}
			else if(param_00.vo_prefix == "p5_")
			{
				playsoundatpos(level.dj.origin,"dj_quest_ufo_partsrecovery_fail");
				wait(scripts\cp\cp_vo::get_sound_length("dj_quest_ufo_partsrecovery_fail"));
				param_00 thread scripts\cp\cp_vo::try_to_play_vo("quest_return_noparts","zmb_comment_vo");
			}
		}
		else
		{
			playsoundatpos(level.dj.origin,"dj_quest_ufo_partsrecovery_fail");
			wait(scripts\cp\cp_vo::get_sound_length(param_00.vo_prefix + "quest_return_noparts"));
			param_00 thread scripts\cp\cp_vo::try_to_play_vo("quest_return_noparts","zmb_comment_vo");
		}

		level.first_time_use_door_allparts = 1;
	}
	else if(get_num_of_dj_quest_parts_collected() == 1)
	{
		if(param_00.vo_prefix == "p6_" || param_00.vo_prefix == "p5_")
		{
			param_00 thread scripts\cp\cp_vo::try_to_play_vo("quest_return_generic","zmb_comment_vo");
			wait(scripts\cp\cp_vo::get_sound_length(param_00.vo_prefix + "quest_return_generic"));
			playsoundatpos(level.dj.origin,"dj_quest_parts_1");
		}

		level.first_time_use_door_allparts = 1;
	}
	else if(get_num_of_dj_quest_parts_collected() == 2)
	{
		if(param_00.vo_prefix == "p6_" || param_00.vo_prefix == "p5_")
		{
			param_00 thread scripts\cp\cp_vo::try_to_play_vo("quest_return_generic","zmb_comment_vo");
			wait(scripts\cp\cp_vo::get_sound_length(param_00.vo_prefix + "quest_return_generic"));
			playsoundatpos(level.dj.origin,"dj_quest_parts_2");
		}

		level.first_time_use_door_allparts = 1;
	}
	else if(get_num_of_dj_quest_parts_collected() == 3)
	{
		scripts\cp\cp_vo::remove_from_nag_vo("nag_return_djpart");
		if(level.first_time_use_door_allparts == 0)
		{
			playsoundatpos(level.dj.origin,"dj_quest_ufo_parts_before_quest");
		}
		else
		{
			playsoundatpos(level.dj.origin,"dj_quest_parts_all");
		}

		scripts\cp\zombies\zombie_analytics::log_frequency_device_crafted_dj(level.wave_num,param_01.name);
		level.use_dj_door_func = undefined;
	}

	level.disable_broadcast = undefined;
	scripts\cp\cp_vo::remove_from_nag_vo("dj_quest_ufo_partsrecovery_start");
	level scripts\cp\cp_vo::add_to_nag_vo("dj_craft_nag","zmb_dj_vo",60,60,2,1);
	scripts\cp\cp_interaction::add_to_current_interaction_list(param_01);
}

//Function Number: 11
init_part_1()
{
	init_dj_quest_part("dj_quest_part_1","zmb_frequency_device_radio");
}

//Function Number: 12
pick_up_part_1(param_00,param_01)
{
	level.dj_part_1_found = 1;
	if(randomint(100) > 50)
	{
		param_01 thread scripts\cp\cp_vo::try_to_play_vo("collect_dj","zmb_comment_vo","low",10,0,0,1,50);
	}
	else
	{
		param_01 thread scripts\cp\cp_vo::try_to_play_vo("quest_dj_boombox","zmb_comment_vo","highest",10,1,0,0,100);
	}

	level thread scripts\cp\cp_vo::remove_from_nag_vo("dj_craft_nag",1);
	pick_up_dj_quest_part(param_00,param_01,22);
}

//Function Number: 13
init_part_2()
{
	init_dj_quest_part("dj_quest_part_2","zmb_frequency_device_calculator");
}

//Function Number: 14
pick_up_part_2(param_00,param_01)
{
	level.dj_part_2_found = 1;
	if(randomint(100) > 50)
	{
		param_01 thread scripts\cp\cp_vo::try_to_play_vo("collect_dj","zmb_comment_vo","low",10,0,0,1,50);
	}
	else
	{
		param_01 thread scripts\cp\cp_vo::try_to_play_vo("quest_dj_calculator","zmb_comment_vo","highest",10,1,0,0,100);
	}

	pick_up_dj_quest_part(param_00,param_01,23);
}

//Function Number: 15
init_part_3()
{
	init_dj_quest_part("dj_quest_part_3","zmb_frequency_device_umbrella_ground");
}

//Function Number: 16
pick_up_part_3(param_00,param_01)
{
	level.dj_part_3_found = 1;
	if(randomint(100) > 50)
	{
		param_01 thread scripts\cp\cp_vo::try_to_play_vo("collect_dj","zmb_comment_vo","low",10,0,0,1,50);
	}
	else
	{
		param_01 thread scripts\cp\cp_vo::try_to_play_vo("quest_dj_umbrella","zmb_comment_vo","highest",10,1,0,0,100);
	}

	pick_up_dj_quest_part(param_00,param_01,24);
	level thread scripts\cp\cp_vo::remove_from_nag_vo("dj_quest_ufo_partsrecovery_hint");
}

//Function Number: 17
init_dj_quest_part(param_00,param_01)
{
	if(scripts\cp\utility::is_codxp())
	{
		return;
	}

	if(!isdefined(level.djpartsareas))
	{
		level.djpartsareas = ["area_1","area_2","area_3"];
	}

	var_02 = scripts\engine\utility::getstructarray(param_00,"script_noteworthy");
	var_03 = scripts\engine\utility::random(level.djpartsareas);
	var_04 = scripts\engine\utility::array_randomize(var_02);
	var_05 = undefined;
	foreach(var_07 in var_04)
	{
		if(!isdefined(var_05) && var_03 == var_07.groupname)
		{
			var_05 = var_07;
			level.djpartsareas = scripts\engine\utility::array_remove(level.djpartsareas,var_07.groupname);
		}

		scripts\cp\cp_interaction::remove_from_current_interaction_list(var_07);
	}

	var_09 = scripts\engine\utility::getstruct(var_05.target,"targetname");
	var_0A = spawn("script_model",var_09.origin);
	var_0A setmodel(param_01);
	if(isdefined(var_09.angles))
	{
		var_0A.angles = var_09.angles;
	}

	var_05.part_model = var_0A;
	var_05.custom_search_dist = 96;
	scripts\cp\cp_interaction::add_to_current_interaction_list(var_05);
	add_to_dj_quest_part_list(var_05);
}

//Function Number: 18
pick_up_dj_quest_part(param_00,param_01,param_02)
{
	if(get_num_of_dj_quest_parts_collected() == 3)
	{
		scripts\engine\utility::flag_set("dj_fetch_quest_completed");
		param_01 thread scripts\cp\cp_vo::add_to_nag_vo("nag_return_djpart","zmb_comment_vo",60,100,3,1);
	}

	playfx(level._effect["souvenir_pickup"],param_00.part_model.origin);
	param_01 playlocalsound("part_pickup");
	scripts\cp\zombies\zombie_analytics::log_frequency_device_collected(level.wave_num,param_00.groupname,param_00.part_model.model);
	scripts\cp\cp_interaction::remove_from_current_interaction_list(param_00);
	param_00.part_model delete();
	level scripts\cp\utility::set_quest_icon(param_02);
}

//Function Number: 19
get_num_of_dj_quest_parts_collected()
{
	var_00 = 0;
	if(scripts\engine\utility::istrue(level.dj_part_1_found))
	{
		var_00++;
	}

	if(scripts\engine\utility::istrue(level.dj_part_2_found))
	{
		var_00++;
	}

	if(scripts\engine\utility::istrue(level.dj_part_3_found))
	{
		var_00++;
	}

	return var_00;
}

//Function Number: 20
add_to_dj_quest_part_list(param_00)
{
	level.selected_dj_parts[level.selected_dj_parts.size + 1] = param_00;
}

//Function Number: 21
setup_dj_doors()
{
	var_00 = scripts\engine\utility::getstructarray("dj_quest_door","script_noteworthy");
	foreach(var_02 in var_00)
	{
		var_02.selected = 0;
	}

	if(isdefined(level.the_hoff))
	{
		return;
	}

	level.selected_dj_door = scripts\engine\utility::random(var_00);
	level.selected_dj_door.selected = 1;
	level thread setup_dj_booth(level.selected_dj_door);
}

//Function Number: 22
choose_new_dj_door()
{
	level notify("choose_new_dj_door");
	level endon("choose_new_dj_door");
	if(isdefined(level.the_hoff))
	{
		return;
	}

	level.disable_broadcast = 1;
	while(!isdefined(level.dj) || !isdefined(level.dj.current_state) || level.dj.current_state != "idle")
	{
		wait(1);
	}

	for(;;)
	{
		if(level.dj.current_state != "close_window")
		{
			set_dj_state("close_window");
		}

		wait(1);
		if(level.dj.current_state == "close_window")
		{
			break;
		}
	}

	var_00 = scripts\engine\utility::getstructarray("dj_quest_door","script_noteworthy");
	foreach(var_02 in var_00)
	{
		var_02.selected = 0;
	}

	level.dj waittill("window_closed");
	if(isdefined(level.the_hoff))
	{
		return;
	}

	level.selected_dj_door = scripts\engine\utility::random(var_00);
	level.selected_dj_door.selected = 1;
	level thread setup_dj_booth(level.selected_dj_door);
}

//Function Number: 23
wait_use_pap_portal()
{
	for(;;)
	{
		level waittill("wave_start_sound_done");
		if(scripts\engine\utility::flag("pap_portal_used"))
		{
			break;
		}
	}
}

//Function Number: 24
debug_use_pap_portal()
{
}

//Function Number: 25
wait_some_wave()
{
	level endon("stop_wait_some_wave");
	var_00 = 3;
	var_01 = 0;
	for(;;)
	{
		level waittill("wave_start_sound_done");
		var_01++;
		if(var_01 >= var_00)
		{
			break;
		}
	}
}

//Function Number: 26
debug_beat_wait_some_wave()
{
}

//Function Number: 27
wait_one_wave()
{
	level endon("stop_wait_one_wave");
	level waittill("regular_wave_starting");
}

//Function Number: 28
debug_beat_wait_one_wave()
{
}

//Function Number: 29
init_first_speaker_defense()
{
	scripts\engine\utility::flag_init("defend_sequence");
	scripts\engine\utility::flag_init("dj_request_defense_done");
	level.selected_speaker_defense_locations = [];
	level.speaker_defense_length = 60;
	level.use_dj_door_func = ::use_dj_door_to_request_defense;
	level.frequency_device_clip = getent("frequency_device_clip","targetname");
	level.frequency_device_clip.originalloc = level.frequency_device_clip.origin;
}

//Function Number: 30
use_dj_door_to_request_defense(param_00,param_01)
{
	scripts\engine\utility::flag_set("dj_request_defense_done");
	level thread scripts\cp\cp_vo::try_to_play_vo("dj_quest_ufo_speakerdefense_start","zmb_dj_vo");
	foreach(param_01 in level.players)
	{
		param_01 setclientomnvar("zm_special_item",3);
	}
}

//Function Number: 31
use_dj_door_during_speaker_defense(param_00,param_01)
{
	playsoundatpos(level.dj.origin,"dj_quest_freq_notready");
}

//Function Number: 32
use_dj_door_after_fail_speaker_defense(param_00,param_01)
{
	scripts\engine\utility::flag_set("dj_request_defense_done");
	level.use_dj_door_func = ::use_dj_door_during_speaker_defense;
	foreach(param_01 in level.players)
	{
		param_01 setclientomnvar("zm_special_item",3);
	}
}

//Function Number: 33
use_dj_door_to_pick_up_analyzer(param_00,param_01)
{
}

//Function Number: 34
init_second_speaker_defense()
{
	level.use_dj_door_func = ::use_dj_door_to_request_defense;
	level.speaker_defense_length = 90;
}

//Function Number: 35
init_third_speaker_defense()
{
	level.use_dj_door_func = ::use_dj_door_to_request_defense;
	level.speaker_defense_length = 120;
}

//Function Number: 36
do_first_speaker_defend()
{
	level thread ufo_light_sequence_pre_defense();
	do_speaker_defense(20);
}

//Function Number: 37
do_second_speaker_defend()
{
	do_speaker_defense(22);
}

//Function Number: 38
do_third_speaker_defend()
{
	do_speaker_defense(25);
}

//Function Number: 39
do_speaker_defense(param_00)
{
	scripts\engine\utility::flag_wait("dj_request_defense_done");
	scripts\engine\utility::flag_set("defend_sequence");
	var_01 = get_speaker_loc(param_00);
	for(;;)
	{
		var_02 = level scripts\engine\utility::waittill_any_return("speaker_defense_failed","speaker_defense_completed");
		if(var_02 == "speaker_defense_failed")
		{
			level thread scripts\cp\cp_vo::try_to_play_vo("dj_quest_ufo_partsrecovery_fail","zmb_dj_vo","high",20,0,0,1);
			scripts\engine\utility::flag_wait("dj_request_defense_done");
			var_01 thread playstaticsoundinarea(var_01);
			var_01 thread managespeakerlocactivation(var_01);
			continue;
		}
		else
		{
			level scripts\engine\utility::waittill_multiple("speaker_picked_up","regular_wave_starting");
			level.use_dj_door_func = undefined;
			break;
		}
	}
}

//Function Number: 40
complete_all_speaker_defense()
{
	level.use_dj_door_func = undefined;
	scripts\engine\utility::flag_clear("defend_sequence");
	level thread choose_new_dj_door();
}

//Function Number: 41
ufo_light_sequence_pre_defense()
{
	scripts\cp\maps\cp_zmb\cp_zmb_ufo::flashufolights(0);
	scripts\cp\maps\cp_zmb\cp_zmb_ufo::playsequence(["01","02","03","04","05","06"],0);
}

//Function Number: 42
debug_beat_speaker_defense()
{
}

//Function Number: 43
select_speaker_defense_locations()
{
	var_00 = scripts\engine\utility::getstructarray("dj_quest_speaker","script_noteworthy");
	var_03 = [];
	var_04 = [];
	foreach(var_06 in var_00)
	{
		if(isdefined(var_06.area_name) && var_06.area_name == "underground_route")
		{
			var_03[var_03.size] = var_06;
			continue;
		}

		var_04[var_04.size] = var_06;
	}

	for(var_01 = 0;var_01 < 3;var_01++)
	{
		if(var_01 < 1)
		{
			var_08 = scripts\engine\utility::random(var_03);
			var_03 = scripts\engine\utility::array_remove(var_03,var_08);
			level.selected_speaker_defense_locations[level.selected_speaker_defense_locations.size] = var_08;
			continue;
		}

		var_09 = scripts\engine\utility::random(var_04);
		var_04 = scripts\engine\utility::array_remove(var_04,var_09);
		level.selected_speaker_defense_locations[level.selected_speaker_defense_locations.size] = var_09;
	}
}

//Function Number: 44
init_get_tone_generator()
{
	level.use_dj_door_func = ::use_dj_door_to_get_tone_generator;
	scripts\engine\utility::flag_init("tone_generators_given");
}

//Function Number: 45
get_tone_generator()
{
	scripts\engine\utility::flag_wait("tone_generators_given");
	foreach(var_01 in level.players)
	{
		var_01 setclientomnvar("zm_special_item",5);
	}
}

//Function Number: 46
complete_get_tone_generator()
{
	level.use_dj_door_func = undefined;
	level thread scripts\cp\cp_vo::add_to_nag_vo("dj_quest_ufo_tonegen_hint","zmb_dj_vo",60,15,2,1);
}

//Function Number: 47
debug_get_tone_generator()
{
}

//Function Number: 48
use_dj_door_to_get_tone_generator(param_00,param_01)
{
	scripts\engine\utility::flag_set("tone_generators_given");
	level scripts\cp\cp_vo::add_to_nag_vo("dj_quest_ufo_tonegen_nag","zmb_dj_vo",60,60,2,1);
	scripts\cp\zombies\zombie_analytics::log_frequency_device_crafted_dj(level.wave_num,param_00.name);
	level thread scripts\cp\cp_vo::add_to_nag_vo("dj_quest_ufo_tonegen_nag","zmb_dj_vo",60,15,2,1);
	level.use_dj_door_func = ::use_dj_door_after_getting_tone_generator;
}

//Function Number: 49
use_dj_door_after_getting_tone_generator(param_00,param_01)
{
}

//Function Number: 50
init_place_tone_generator()
{
	scripts\engine\utility::flag_init("all_structs_placed");
	scripts\engine\utility::flag_init("all_center_positions_used");
	level.centerstructstriggered = [];
	activateallmiddleplacementstructs();
}

//Function Number: 51
place_tone_generator()
{
	scripts\engine\utility::flag_wait("all_center_positions_used");
	level thread scripts\cp\cp_vo::remove_from_nag_vo("dj_quest_ufo_tonegen_nag",1);
}

//Function Number: 52
complete_place_tone_generator()
{
	scripts\engine\utility::flag_set("jukebox_paused");
	level notify("skip_song");
	disableparkpas();
}

//Function Number: 53
debug_place_tone_generator()
{
}

//Function Number: 54
init_match_ufo_tone()
{
	scripts\engine\utility::flag_init("ufo_listening");
	scripts\engine\utility::flag_init("tones_played_successfully");
	scripts\engine\utility::flag_init("ufo_intro_reach_center_portal");
	scripts\cp\maps\cp_zmb\cp_zmb_ufo::start_grey_fight_blocker_vfx();
	scripts\cp\maps\cp_zmb\cp_zmb_ufo::disableportals();
	scripts\cp\maps\cp_zmb\cp_zmb_ufo::setalltonestructstoneutralstate();
	level thread scripts\cp\maps\cp_zmb\cp_zmb_ufo::ufo_intro_fly_to_center_portal();
	level thread scripts\cp\maps\cp_zmb\cp_zmb_ufo::move_grey_fight_clip_down();
	level thread scripts\cp\maps\cp_zmb\cp_zmb_ufo::ufostopwavefromprogressing();
}

//Function Number: 55
match_ufo_tone()
{
	var_00 = level.ufo;
	level thread ufo_player_vo();
	scripts\cp\zombies\zombie_analytics::log_tone_sequence_activated(level.wave_num);
	var_00 thread scripts\cp\maps\cp_zmb\cp_zmb_ufo::start_match_tone_sequence();
	scripts\engine\utility::flag_wait("tones_played_successfully");
}

//Function Number: 56
ufo_player_vo()
{
	level endon("game_ended");
	scripts\cp\cp_vo::try_to_play_vo_on_all_players("ufo_first");
	wait(4);
	level thread scripts\cp\cp_vo::try_to_play_vo("ww_ufo_spawn_action","zmb_announcer_vo","highest",60,0,0,1);
}

//Function Number: 57
complete_match_ufo_tone()
{
	level thread scripts\cp\maps\cp_zmb\cp_zmb_ufo::destroyalltonestructs();
	scripts\engine\utility::flag_set("tones_played_successfully");
}

//Function Number: 58
debug_match_ufo_tone()
{
}

//Function Number: 59
ufo_suicide_bomber()
{
	scripts\cp\maps\cp_zmb\cp_zmb_ufo::ufo_suicide_bomber_sequence();
}

//Function Number: 60
debug_beat_ufo_suicide_bomber()
{
}

//Function Number: 61
init_alien_grey_fight()
{
}

//Function Number: 62
alien_grey_fight()
{
	level thread scripts\cp\maps\cp_zmb\cp_zmb_ufo::start_grey_sequence();
	level waittill("complete_alien_grey_fight");
}

//Function Number: 63
complete_grey_fight()
{
	scripts\cp\maps\cp_zmb\cp_zmb_ufo::clear_grey_fight_clips();
	scripts\cp\maps\cp_zmb\cp_zmb_ufo::stop_grey_fight_blocker_vfx();
	scripts\cp\maps\cp_zmb\cp_zmb_ufo::stop_grey_fight_blocker_sfx();
	scripts\cp\maps\cp_zmb\cp_zmb_ufo::drop_alien_fuses();
	scripts\cp\maps\cp_zmb\cp_zmb_ufo::enableportals();
	var_00 = spawn("script_model",level.players[0].origin);
	var_00 setmodel("tag_origin");
	var_00.team = "allies";
	level.forced_nuke = 1;
	scripts\cp\loot::process_loot_content(level.players[0],"kill_50",var_00,0);
	level.wave_num_override = undefined;
	level.spawndelayoverride = undefined;
	wait(5);
	scripts\engine\utility::flag_clear("pause_wave_progression");
	scripts\engine\utility::flag_clear("all_center_positions_used");
	if(level.wave_num == level.ufo_starting_wave)
	{
		level.current_enemy_deaths = level.savedcurrentdeaths;
		level.max_static_spawned_enemies = level.savemaxspawns;
		level.desired_enemy_deaths_this_wave = level.savedesireddeaths;
		return;
	}

	level.current_enemy_deaths = 0;
	level.max_static_spawned_enemies = scripts\cp\zombies\zombies_spawning::get_max_static_enemies(level.wave_num);
	level.desired_enemy_deaths_this_wave = scripts\cp\zombies\zombies_spawning::get_total_spawned_enemies(level.wave_num);
}

//Function Number: 64
debug_beat_alien_grey_fight()
{
}

//Function Number: 65
init_ufo_projectile_attack()
{
	scripts\cp\maps\cp_zmb\cp_zmb_ufo::activate_spaceland_powernode();
}

//Function Number: 66
ufo_projectile_attack()
{
	level thread scripts\cp\cp_vo::try_to_play_vo("dj_quest_ufo_destroy_nag","zmb_dj_vo","high",10,0,3,0);
	scripts\cp\maps\cp_zmb\cp_zmb_ufo::start_slow_projectile_sequence(level.ufo);
	level waittill("ufo_destroyed");
}

//Function Number: 67
complete_ufo_projectile_attack()
{
	scripts\engine\utility::flag_set("ufo_quest_finished");
	level thread wait_drop_soul_key();
	scripts\engine\utility::flag_clear("jukebox_paused");
	enableparkpas();
}

//Function Number: 68
wait_drop_soul_key()
{
	level endon("game_ended");
	if(scripts\cp\maps\cp_zmb\cp_zmb_ufo::any_player_is_willard())
	{
		if(scripts\engine\utility::flag_exist("pause_spawn_after_UFO_destroyed"))
		{
			scripts\engine\utility::flag_waitopen("pause_spawn_after_UFO_destroyed");
		}
	}

	scripts\cp\maps\cp_zmb\cp_zmb_ufo::drop_soul_key();
}

//Function Number: 69
debug_beat_ufo_projectile_attack()
{
}

//Function Number: 70
use_dj_door(param_00,param_01)
{
	if(param_00.selected == 1)
	{
		if(level.dj.current_state == "mic_loop")
		{
			param_01 playlocalsound("dj_deny");
			return;
		}

		if(isdefined(level.use_dj_door_func))
		{
			[[ level.use_dj_door_func ]](param_00,param_01);
			param_01 playlocalsound("dj_turn_in");
			return;
		}

		default_dj_interactions(param_00,param_01);
		return;
	}

	param_01 playlocalsound("dj_deny");
}

//Function Number: 71
default_dj_interactions(param_00,param_01)
{
	if(isdefined(level.song_skip_time) && gettime() >= level.song_skip_time || level.song_skip_time == 0)
	{
		level notify("skip_song");
		level.song_skip_time = gettime() + 30000;
		param_01 playlocalsound("dj_turn_in");
		var_02 = scripts\engine\utility::random(["dj_newtrack_request"]);
		playsoundatpos(level.dj.origin,var_02);
		return;
	}

	var_02 playlocalsound("dj_turn_in");
	var_02 = scripts\engine\utility::random(["dj_newtrack_cooldown"]);
	playsoundatpos(level.dj.origin,var_02);
}

//Function Number: 72
disable_dj_broadcast_for_time(param_00)
{
	level.disable_broadcast = 1;
	wait(param_00);
	level.disable_broadcast = undefined;
}

//Function Number: 73
get_speaker_loc(param_00)
{
	if(level.selected_speaker_defense_locations.size == 0)
	{
		select_speaker_defense_locations();
	}

	var_01 = scripts\engine\utility::random(level.selected_speaker_defense_locations);
	level.selected_speaker_defense_locations = scripts\engine\utility::array_remove(level.selected_speaker_defense_locations,var_01);
	var_01 thread playstaticsoundinarea(var_01);
	var_01 thread managespeakerlocactivation(var_01);
	var_01.wave_num_override = param_00;
	return var_01;
}

//Function Number: 74
dj_arcade_purchase_hint_func(param_00,param_01)
{
	return &"CP_QUEST_WOR_PART";
}

//Function Number: 75
dj_speaker_mid_hint_func(param_00,param_01)
{
	if(scripts\engine\utility::istrue(param_00.placed))
	{
		return &"CP_QUEST_WOR_USE_TONE_EQUIP";
	}

	return &"CP_QUEST_WOR_PLACE_PART";
}

//Function Number: 76
dj_door_hintstring(param_00,param_01)
{
	if(param_00.selected)
	{
		return &"CP_ZMB_INTERACTIONS_TALK_TO_DJ";
	}

	return &"CP_ZMB_INTERACTIONS_DJ_NOT_HERE";
}

//Function Number: 77
init_dj_speaker()
{
	var_00 = scripts\engine\utility::getstructarray("dj_quest_speaker","script_noteworthy");
	foreach(var_02 in var_00)
	{
		var_03 = scripts\cp\cp_interaction::get_area_for_power(var_02);
		if(isdefined(var_03))
		{
			var_02.area_name = var_03;
		}

		scripts\cp\cp_interaction::remove_from_current_interaction_list(var_02);
		var_02.custom_search_dist = 128;
	}
}

//Function Number: 78
playstaticsoundinarea(param_00)
{
	level endon("speaker_defense_completed");
	level endon("speaker_defense_started");
	level endon("speaker_defense_failed");
	param_00 endon("death");
	for(;;)
	{
		if(!scripts\engine\utility::flag("dj_request_defense_done"))
		{
			scripts\engine\utility::flag_wait("dj_request_defense_done");
		}

		if(scripts\engine\utility::istrue(level.spawn_event_running))
		{
			level waittill("regular_wave_starting");
		}

		var_01 = scripts\engine\utility::get_array_of_closest(param_00.origin,level.players,undefined,4,96);
		foreach(var_03 in var_01)
		{
			var_03 setclientomnvar("ui_hud_shake",1);
			var_03 playrumbleonentity("artillery_rumble");
		}

		playsoundatpos(param_00.origin,"tone_placement_close");
		wait(randomfloatrange(0.5,2));
	}
}

//Function Number: 79
managespeakerlocactivation(param_00)
{
	param_00 notify("speaker_loc_manager");
	param_00 endon("speaker_loc_manager");
	level endon("speaker_defense_started");
	if(scripts\engine\utility::istrue(level.spawn_event_running))
	{
		scripts\cp\cp_interaction::remove_from_current_interaction_list(param_00);
	}
	else
	{
		scripts\cp\cp_interaction::add_to_current_interaction_list(param_00);
	}

	for(;;)
	{
		var_01 = level scripts\engine\utility::waittill_any_return("event_wave_starting","regular_wave_starting");
		if(var_01 == "event_wave_starting")
		{
			scripts\cp\cp_interaction::remove_from_current_interaction_list(param_00);
			continue;
		}

		scripts\cp\cp_interaction::add_to_current_interaction_list(param_00);
	}
}

//Function Number: 80
waitforallplayerstriggered(param_00)
{
	param_00 notify("waiting_for_all_structs_used");
	param_00 endon("waiting_for_all_structs_used");
	if(!scripts\engine\utility::array_contains(level.centerstructstriggered,param_00))
	{
		level.centerstructstriggered[level.centerstructstriggered.size] = param_00;
	}

	if(level.centerstructstriggered.size == level.players.size)
	{
		scripts\engine\utility::flag_set("all_center_positions_used");
	}

	wait(1);
	if(scripts\engine\utility::array_contains(level.centerstructstriggered,param_00))
	{
		level.centerstructstriggered = scripts\engine\utility::array_remove(level.centerstructstriggered,param_00);
	}
}

//Function Number: 81
disableparkpas()
{
	disablepaspeaker("starting_area");
	disablepaspeaker("cosmic_way");
	disablepaspeaker("kepler");
	disablepaspeaker("triton");
	disablepaspeaker("astrocade");
	disablepaspeaker("journey");
}

//Function Number: 82
enableparkpas()
{
	enablepaspeaker("starting_area");
	enablepaspeaker("cosmic_way");
	enablepaspeaker("kepler");
	enablepaspeaker("triton");
	enablepaspeaker("astrocade");
	enablepaspeaker("journey");
}

//Function Number: 83
speaker_defend_hint_func(param_00,param_01)
{
	return level.interaction_hintstrings[param_00.script_noteworthy];
}

//Function Number: 84
start_defense_sequence(param_00,param_01)
{
	var_02 = param_01 can_place_speaker(param_00);
	if(!isdefined(var_02))
	{
		return 0;
	}

	set_up_defense_sequence_zombie_model();
	notify_objective();
	disable_speaker_loc_interaction(param_00);
	set_defense_sequence_active_flag();
	level thread keep_park_workers_from_despawning();
	level thread scripts\cp\cp_vo::try_to_play_vo("dj_sign_off","zmb_dj_vo","medium",3,0,0,1);
	set_up_and_start_speaker(param_00,var_02);
	foreach(param_01 in level.players)
	{
		param_01 setclientomnvar("zm_special_item",0);
	}

	level.use_dj_door_func = ::use_dj_door_during_speaker_defense;
	level thread stopwavefromprogressing(param_00);
	thread startspeakereventspawning(param_00);
}

//Function Number: 85
can_place_speaker(param_00)
{
	var_01 = self canplayerplacesentry(1,24);
	if(self isonground() && var_01["result"] && abs(param_00.origin[2] - self.origin[2]) < 24)
	{
		return var_01;
	}

	return undefined;
}

//Function Number: 86
keep_park_workers_from_despawning()
{
	level endon("speaker_defense_failed");
	level endon("speaker_defense_completed");
	while(scripts\engine\utility::flag("defense_sequence_active"))
	{
		level waittill("agent_spawned",var_00);
		var_00.dont_cleanup = 1;
	}
}

//Function Number: 87
turn_despawn_back_on()
{
	foreach(var_01 in level.spawned_enemies)
	{
		var_01.dont_cleanup = undefined;
	}
}

//Function Number: 88
speaker_hint_func(param_00,param_01)
{
	return level.interaction_hintstrings[param_00.script_noteworthy];
}

//Function Number: 89
stopwavefromprogressing(param_00)
{
	var_01 = level.cop_spawn_percent;
	var_02 = level.current_enemy_deaths;
	var_03 = level.max_static_spawned_enemies;
	var_04 = level.desired_enemy_deaths_this_wave;
	var_05 = level.wave_num;
	while(level.current_enemy_deaths == level.desired_enemy_deaths_this_wave)
	{
		wait(0.05);
	}

	level.current_enemy_deaths = 0;
	if(scripts\cp\utility::isplayingsolo() || scripts\engine\utility::istrue(level.only_one_player))
	{
		level.max_static_spawned_enemies = 16;
	}
	else
	{
		level.max_static_spawned_enemies = 24;
	}

	level.desired_enemy_deaths_this_wave = 24;
	level.special_event = 1;
	scripts\engine\utility::flag_set("pause_wave_progression");
	var_06 = level scripts\engine\utility::waittill_any_return("speaker_defense_failed","speaker_defense_completed");
	if(var_06 == "speaker_defense_completed")
	{
		level.force_drop_loot_item = "ammo_max";
	}

	var_07 = spawn("script_model",level.players[0].origin);
	var_07 setmodel("tag_origin");
	var_07.team = "allies";
	level.forced_nuke = 1;
	scripts\cp\loot::process_loot_content(level.players[0],"kill_50",var_07,0);
	level.spawndelayoverride = undefined;
	level.wave_num_override = undefined;
	level.special_event = undefined;
	turn_despawn_back_on();
	wait(2);
	if(var_06 == "speaker_defense_failed")
	{
		scripts\engine\utility::flag_set("force_spawn_boss");
	}

	wait(3);
	scripts\engine\utility::flag_clear("pause_wave_progression");
	if(level.wave_num == var_05)
	{
		level.current_enemy_deaths = var_02;
		level.max_static_spawned_enemies = var_03;
		level.desired_enemy_deaths_this_wave = var_04;
		return;
	}

	level.current_enemy_deaths = 0;
	level.max_static_spawned_enemies = scripts\cp\zombies\zombies_spawning::get_max_static_enemies(level.wave_num);
	level.desired_enemy_deaths_this_wave = scripts\cp\zombies\zombies_spawning::get_total_spawned_enemies(level.wave_num);
}

//Function Number: 90
startspeakereventspawning(param_00)
{
	var_01 = level.active_spawn_volumes;
	var_02 = undefined;
	var_03 = scripts\cp\cp_agent_utils::getaliveagentsofteam("axis");
	var_04 = scripts\engine\utility::get_array_of_closest(param_00.origin,level.players,undefined,4,1000);
	foreach(var_06 in scripts\cp\cp_agent_utils::getaliveagentsofteam("axis"))
	{
		var_06 thread adjustmovespeed(var_06);
	}

	foreach(var_09 in var_01)
	{
		if(function_010F(param_00.origin,var_09))
		{
			var_02 = var_09;
			foreach(var_0B in var_03)
			{
				var_0B thread sendzombietospeaker(var_0B,var_02);
			}

			break;
		}
	}

	if(isdefined(var_02.spawners))
	{
		var_0E = scripts\engine\utility::get_array_of_closest(param_00.origin,var_02.spawners,undefined,100,400);
		foreach(var_10 in var_0E)
		{
			var_10 scripts\cp\zombies\zombies_spawning::make_spawner_inactive();
		}
	}

	foreach(var_13 in var_01)
	{
		if(var_13 == var_02)
		{
			continue;
		}

		var_13 scripts\cp\zombies\zombies_spawning::make_volume_inactive();
	}

	level scripts\engine\utility::waittill_any_return("speaker_defense_failed","speaker_defense_completed");
	foreach(var_16 in var_01)
	{
		var_16 scripts\cp\zombies\zombies_spawning::make_volume_active();
	}
}

//Function Number: 91
sendzombietospeaker(param_00,param_01)
{
	var_02 = 250000;
	param_00 endon("death");
	level endon("speaker_defense_failed");
	level endon("speaker_defense_completed");
	while(!isdefined(level.current_speaker))
	{
		wait(0.05);
	}

	param_00.scripted_mode = 1;
	param_00.precacheleaderboards = 1;
	param_00 give_mp_super_weapon(level.frequency_device_clip.origin);
	for(;;)
	{
		if(distance(param_00.origin,level.current_speaker.origin) < 750)
		{
			break;
		}

		wait(0.5);
	}

	param_00.scripted_mode = 0;
	param_00.precacheleaderboards = 0;
}

//Function Number: 92
notify_objective()
{
	level notify("speaker_defense_started");
}

//Function Number: 93
disable_speaker_loc_interaction(param_00)
{
	scripts\cp\cp_interaction::remove_from_current_interaction_list(param_00);
}

//Function Number: 94
set_defense_sequence_active_flag()
{
	if(!scripts\engine\utility::flag_exist("defense_sequence_active"))
	{
		scripts\engine\utility::flag_init("defense_sequence_active");
	}

	scripts\engine\utility::flag_set("defense_sequence_active");
	level.defense_sequence_duration = gettime();
}

//Function Number: 95
set_up_and_start_speaker(param_00,param_01)
{
	var_02 = param_01["origin"];
	if(isdefined(param_00.wave_num_override))
	{
		level.wave_num_override = param_00.wave_num_override;
	}

	if(scripts\cp\utility::isplayingsolo() || scripts\engine\utility::istrue(level.only_one_player))
	{
		level.spawndelayoverride = 0.7;
	}
	else
	{
		level.spawndelayoverride = 0.35;
	}

	var_02 = var_02 + (0,0,0.5);
	var_03 = spawn("script_model",var_02);
	var_03 setmodel("zmb_frequency_device");
	var_03 notsolid();
	if(isdefined(param_00.angles))
	{
		var_03.angles = param_00.angles;
		level.frequency_device_clip.angles = param_00.angles;
	}
	else
	{
		var_03.angles = (0,0,0);
		level.frequency_device_clip.angles = (0,0,0);
	}

	level.frequency_device_clip dontinterpolate();
	level.frequency_device_clip.origin = var_03.origin + (0,0,48);
	level.frequency_device_clip.special_case_ignore = 1;
	level.frequency_device_clip makeentitysentient("allies",0);
	level.frequency_device_clip.navrepulsor = function_0277("speaker_nav_repulsor",0,var_03.origin,72,1);
	var_03 thread damage_monitor(var_03,level.frequency_device_clip);
	level thread destroyspeakerifonlyoneplayer(var_03);
	var_03 thread assign_zombie_attacker_logic(var_03,level.frequency_device_clip);
	var_03 thread quest_timer(var_03,param_00);
	level.current_speaker = var_03;
	var_03.hit_point_left = 10;
	level.fake_players = scripts\engine\utility::array_add_safe(level.fake_players,level.frequency_device_clip);
}

//Function Number: 96
destroyspeakerifonlyoneplayer(param_00)
{
	level endon("speaker_defense_completed");
	level endon("speaker_defense_failed");
	level waittill("destroy_speaker");
	level thread defense_sequence_fail(param_00);
}

//Function Number: 97
adjustmovespeed(param_00,param_01)
{
	param_00 endon("death");
	if(isdefined(param_00.agent_type) && param_00.agent_type == "zombie_brute" || param_00.agent_type == "zombie_grey" || param_00.agent_type == "zombie_ghost")
	{
		return;
	}

	if(scripts\engine\utility::istrue(param_00.is_suicide_bomber))
	{
		return;
	}

	if(scripts\engine\utility::istrue(param_01))
	{
		wait(0.5);
	}

	param_00.synctransients = "sprint";
	param_00 scripts/asm/asm_bb::bb_requestmovetype("sprint");
}

//Function Number: 98
get_speaker_icon_shader(param_00)
{
	var_01 = 0;
	var_01 = param_00.hit_point_left / 10;
	setomnvar("zm_speaker_defense_health",var_01);
}

//Function Number: 99
damage_monitor(param_00,param_01)
{
	level endon("speaker_defense_completed");
	level endon("destroy_speaker");
	param_00 endon("death");
	param_01 setcandamage(1);
	param_01.health = 9999999;
	param_00.nextdamagetime = 0;
	for(;;)
	{
		param_01 waittill("damage",var_02,var_03);
		if(isdefined(var_03) && isdefined(var_03.team) && var_03.team == "allies")
		{
			continue;
		}

		if(!var_03 scripts\cp\utility::is_zombie_agent())
		{
			continue;
		}

		if(!isdefined(var_03.agent_type) || isdefined(var_03.agent_type) && var_03.agent_type != "zombie_brute")
		{
			if(!isdefined(var_03.attackent))
			{
				var_03.attackent = param_01;
				var_03 thread removelockedonflagonspeakerdeath(var_03,param_00);
			}
		}

		playfx(level._effect["vfx_zb_thu_sparks"],param_00.origin + (0,0,32));
		var_03 notify("speaker_attacked");
		foreach(var_05 in level.players)
		{
			var_05 thread scripts\cp\cp_vo::try_to_play_vo("quest_ufo_defend_speakers","zmb_comment_vo");
		}

		var_07 = gettime();
		if(var_07 >= param_00.nextdamagetime)
		{
			param_00.nextdamagetime = var_07 + 1000;
			param_00.var_902E--;
		}

		if(param_00.hit_point_left == 0)
		{
			break;
		}

		param_00.icon_shader = get_speaker_icon_shader(param_00);
	}

	defense_sequence_fail(param_00);
}

//Function Number: 100
removelockedonflagonspeakerdeath(param_00,param_01)
{
	level endon("game_ended");
	param_00 endon("death");
	param_01 scripts\engine\utility::waittill_any_3("death","speaker_defense_completed");
	param_00.attackent = undefined;
}

//Function Number: 101
quest_timer(param_00,param_01)
{
	level endon("game_ended");
	param_00 endon("death");
	var_02 = spawn("script_model",param_00.origin + (0,0,32));
	setomnvar("zm_speaker_defense_target",var_02);
	setomnvar("zm_speaker_defense_timer",level.speaker_defense_length);
	setomnvar("zm_speaker_defense_health",1);
	speaker_icon_timer(var_02,param_01);
	defense_sequence_success(param_00);
	exit_defense_sequence(param_00);
}

//Function Number: 102
speaker_icon_timer(param_00,param_01)
{
	level endon("complete_defense");
	param_00 playloopsound("speaker_defense_tone_scrubbing");
	var_02 = level.speaker_defense_length;
	thread turn_off_timer(var_02,param_00);
	var_03 = var_02;
	while(var_03 > 0)
	{
		var_04 = level scripts\engine\utility::waittill_notify_or_timeout_return("debug_beat_speaker_defense",1);
		if(isdefined(var_04) && var_04 == "timeout")
		{
			var_03 = var_03 - 1;
			setomnvar("zm_speaker_defense_timer",var_03);
			continue;
		}

		setomnvar("zm_speaker_defense_timer",0);
		return;
	}
}

//Function Number: 103
turn_off_timer(param_00,param_01)
{
	level endon("game_ended");
	level scripts\engine\utility::waittill_any_timeout_1(param_00,"complete_defense","speaker_defense_failed");
	playsoundatpos(param_01.origin,"speaker_defense_tone_scrubbing_end");
	param_01 stoploopsound();
	setomnvar("zm_speaker_defense_timer",0);
	setomnvar("zm_speaker_defense_health",0);
	setomnvar("zm_speaker_defense_target",undefined);
	param_01 delete();
}

//Function Number: 104
exit_defense_sequence(param_00)
{
	scripts\engine\utility::flag_clear("defense_sequence_active");
	level.defense_sequence_duration = gettime() - level.defense_sequence_duration;
	scripts\cp\zombies\zombie_analytics::log_speaker_defence_sequence_ends(level.wave_num,param_00.origin,level.defense_sequence_duration,param_00.health);
	setomnvar("zm_ui_timer",0);
	param_00 waittill("trigger",var_01);
	var_01 playlocalsound("part_pickup");
	level.use_dj_door_func = undefined;
	level.has_speaker = 1;
	level notify("speaker_picked_up");
	foreach(var_01 in level.players)
	{
		var_01 setclientomnvar("zm_special_item",3);
	}

	param_00 makeunusable();
	if(isdefined(level.frequency_device_clip.navrepulsor))
	{
		function_0278(level.frequency_device_clip.navrepulsor);
	}

	param_00 delete();
}

//Function Number: 105
createstructinmiddle()
{
	level.ufotones = scripts\engine\utility::array_randomize(["speaker_tone_playback_01","speaker_tone_playback_02","speaker_tone_playback_03","speaker_tone_playback_04"]);
	level.djcenterstructs = [];
	level.alldjcenterstructs = [];
	var_00 = [(300,663,60),(660,335,60),(985,665,60),(647,792,116)];
	foreach(var_02 in var_00)
	{
		var_03 = scripts\engine\utility::drop_to_ground(var_02,32,-300) + (0,0,48);
		var_04 = spawnstruct("script_origin",var_03);
		var_04.origin = var_03;
		var_04.script_noteworthy = "dj_quest_speaker_mid";
		var_04.disabled = 1;
		var_04.requires_power = 0;
		var_04.powered_on = 0;
		var_04.script_parameters = "default";
		var_04.var_336 = "interaction";
		var_04.name = "center_speaker_locs";
		var_04.custom_search_dist = 96;
		level.alldjcenterstructs[level.alldjcenterstructs.size] = var_04;
		level.djcenterstructs[level.djcenterstructs.size] = var_04;
	}
}

//Function Number: 106
assign_zombie_attacker_logic(param_00,param_01)
{
	param_00 endon("death");
	level.num_of_active_zombie_attacker = 0;
	direct_existing_zombies_to_attack_speaker(param_01);
	for(;;)
	{
		level waittill("agent_spawned",var_02);
		if(isdefined(var_02.agent_type) && var_02.agent_type == "zombie_brute")
		{
			continue;
		}

		var_02 thread adjustmovespeed(var_02,1);
		if(level.num_of_active_zombie_attacker < 3)
		{
			if(isdefined(var_02.species) && var_02.species == "zombie" && !scripts\engine\utility::istrue(var_02.active_speaker_attacker))
			{
				attack_speaker(var_02,param_01);
			}
		}
	}
}

//Function Number: 107
attack_speaker(param_00,param_01)
{
	param_00.loadstartpointtransients = param_01;
	param_00.active_speaker_attacker = 1;
	level.var_C1F3++;
	param_00 thread death_monitor(param_00,param_01);
}

//Function Number: 108
attack_monitor(param_00,param_01)
{
	param_01 endon("death");
	param_00 endon("death");
	param_00 waittill("speaker_attacked");
	param_00.loadstartpointtransients = scripts\engine\utility::getclosest(param_00.origin,level.players);
	param_00.active_speaker_attacker = undefined;
	level.var_C1F3--;
	wait(3);
	get_new_zombie_to_attack_speaker(param_01,param_00);
}

//Function Number: 109
death_monitor(param_00,param_01)
{
	param_01 endon("death");
	param_00 waittill("death");
	wait(3);
	level.var_C1F3--;
	get_new_zombie_to_attack_speaker(param_01);
}

//Function Number: 110
direct_existing_zombies_to_attack_speaker(param_00,param_01)
{
	foreach(var_03 in level.characters)
	{
		if(isdefined(param_01) && var_03 == param_01)
		{
			continue;
		}

		if(isdefined(var_03.agent_type) && var_03.agent_type == "zombie_brute")
		{
			continue;
		}

		if(isdefined(var_03.species) && var_03.species == "zombie" && !scripts\engine\utility::istrue(var_03.active_speaker_attacker))
		{
			attack_speaker(var_03,param_00);
			if(level.num_of_active_zombie_attacker >= 3)
			{
				break;
			}
		}
	}
}

//Function Number: 111
get_new_zombie_to_attack_speaker(param_00,param_01)
{
	foreach(var_03 in level.characters)
	{
		if(isdefined(param_01) && var_03 == param_01)
		{
			continue;
		}

		if(isdefined(var_03.agent_type) && var_03.agent_type == "zombie_brute")
		{
			continue;
		}

		if(isdefined(var_03.species) && var_03.species == "zombie" && !scripts\engine\utility::istrue(var_03.active_speaker_attacker))
		{
			attack_speaker(var_03,param_00);
			if(level.num_of_active_zombie_attacker >= 3)
			{
				break;
			}
		}
	}
}

//Function Number: 112
clear_goal_icon_on(param_00)
{
	param_00.icon_entity delete();
	foreach(var_02 in param_00.goal_head_icon)
	{
		if(isdefined(var_02))
		{
			var_02 destroy();
			var_02 scripts\cp\zombies\zombie_afterlife_arcade::remove_from_icons_to_hide_in_afterlife(var_02.triggerportableradarping,var_02);
		}
	}
}

//Function Number: 113
playspeakerdefencefailsound()
{
	self endon("death");
	self endon("disconnect");
	self endon("game_ended");
	self endon("play_vo_speaker_defence");
	var_00 = scripts\engine\utility::getstructarray("dj_quest_door","script_noteworthy");
	for(;;)
	{
		level.dj waittill("state_changed",var_01);
		if(var_01 == "close_window")
		{
			wait(5);
			self playlocalsound("dj_quest_ufo_speakerdefense_fail");
			self notify("play_vo_speaker_defence");
		}

		scripts\engine\utility::waitframe();
	}
}

//Function Number: 114
defense_sequence_fail(param_00)
{
	scripts\engine\utility::flag_clear("dj_request_defense_done");
	level.frequency_device_clip freeentitysentient();
	level.frequency_device_clip dontinterpolate();
	level.frequency_device_clip.origin = level.frequency_device_clip.originalloc;
	foreach(var_02 in level.players)
	{
		var_02 thread playspeakerdefencefailsound();
		var_02 setclientomnvar("zm_special_item",2);
	}

	level notify("speaker_defense_failed");
	level thread scripts\cp\maps\cp_zmb\cp_zmb_ufo::play_fail_sound();
	scripts\engine\utility::flag_clear("defense_sequence_active");
	clear_defense_sequence_zombie_model();
	setomnvar("zm_ui_timer",0);
	if(isdefined(level.current_speaker))
	{
		level.current_speaker = undefined;
	}

	param_00 makeunusable();
	if(isdefined(level.frequency_device_clip.navrepulsor))
	{
		function_0278(level.frequency_device_clip.navrepulsor);
	}

	level.use_dj_door_func = ::use_dj_door_after_fail_speaker_defense;
	level thread choose_new_dj_door();
	level.fake_players = scripts\engine\utility::array_remove(level.fake_players,level.frequency_device_clip);
	param_00 delete();
}

//Function Number: 115
defense_sequence_success(param_00)
{
	level.frequency_device_clip dontinterpolate();
	level.frequency_device_clip.origin = level.frequency_device_clip.originalloc;
	var_01 = scripts\engine\utility::getstructarray("dj_quest_door","script_noteworthy");
	level.use_dj_door_func = ::use_dj_door_to_pick_up_analyzer;
	clear_defense_sequence_zombie_model();
	level.frequency_device_clip freeentitysentient();
	var_02 = &"CP_QUEST_WOR_PART";
	param_00 sethintstring(var_02);
	param_00 makeusable();
	if(isdefined(level.current_speaker))
	{
		level.current_speaker = undefined;
	}

	foreach(var_04 in level.players)
	{
		var_04 scripts\cp\cp_persistence::give_player_xp(250,1);
		param_00 notify("speaker_defense_completed");
		level notify("speaker_defense_completed");
	}

	level.fake_players = scripts\engine\utility::array_remove(level.fake_players,level.frequency_device_clip);
}

//Function Number: 116
activateallmiddleplacementstructs()
{
	foreach(var_01 in level.alldjcenterstructs)
	{
		var_01.disabled = undefined;
		if(!scripts\engine\utility::array_contains(level.current_interaction_structs,var_01))
		{
			scripts\cp\cp_interaction::add_to_current_interaction_list(var_01);
		}
	}
}

//Function Number: 117
deactivateallmiddleplacementstructs()
{
	foreach(var_01 in level.alldjcenterstructs)
	{
		var_01.disabled = 1;
		scripts\cp\cp_interaction::remove_from_current_interaction_list(var_01);
	}
}

//Function Number: 118
activatemiddleplacementstructs()
{
	foreach(var_01 in level.djcenterstructs)
	{
		var_01.disabled = undefined;
		scripts\cp\cp_interaction::add_to_current_interaction_list(var_01);
	}
}

//Function Number: 119
deactivatemiddleplacementstructs()
{
	foreach(var_01 in level.djcenterstructs)
	{
		var_01.disabled = 1;
		scripts\cp\cp_interaction::remove_from_current_interaction_list(var_01);
	}
}

//Function Number: 120
waitforplayertrigger(param_00,param_01)
{
	if(scripts\engine\utility::istrue(param_00.placed))
	{
		if(isdefined(level.spawn_event_running) && level.spawn_event_running)
		{
			play_tone(param_00,param_01,0);
			return;
		}

		if(scripts\engine\utility::flag("all_structs_placed"))
		{
			play_tone(param_00,param_01,1);
			return;
		}

		play_tone(param_00,param_01,0);
		return;
	}

	place_tone_generator_on(param_00);
}

//Function Number: 121
place_tone_generator_on(param_00)
{
	param_00.placed = 1;
	var_01 = spawn("script_model",param_00.origin);
	var_01.origin = scripts\engine\utility::drop_to_ground(param_00.origin,32,-400);
	var_01.angles = (270,0,-90);
	var_01 setmodel("zmb_tone_speaker");
	param_00.model = var_01;
	param_00.model setscriptablepartstate("tone","neutral");
	param_00.tone = level.ufotones[level.djcenterstructs.size - 1];
	level.djcenterstructs = scripts\engine\utility::array_remove(level.djcenterstructs,param_00);
	playsoundatpos(var_01.origin,"sentry_gun_plant");
	if(level.djcenterstructs.size == 0)
	{
		scripts\engine\utility::flag_set("all_structs_placed");
		foreach(var_03 in level.players)
		{
			var_03 setclientomnvar("zm_special_item",4);
		}
	}
}

//Function Number: 122
play_tone(param_00,param_01,param_02)
{
	playsoundatpos(param_00.origin,param_00.tone);
	var_03 = strtok(param_00.tone,"_");
	param_01 thread scripts/cp/zombies/zombies_pillage::gesture_activate("ges_devil_horns_zm",undefined,0,0.5);
	level notify("tone_played",var_03[3],param_00);
	if(scripts\engine\utility::istrue(param_02))
	{
		level thread waitforallplayerstriggered(param_00);
	}
}

//Function Number: 123
set_up_defense_sequence_zombie_model()
{
	level.generic_zombie_model_override_list = ["zombie_male_park_worker","zombie_male_park_worker_a","zombie_male_park_worker_b","zombie_male_park_worker_c"];
}

//Function Number: 124
clear_defense_sequence_zombie_model()
{
	level.generic_zombie_model_override_list = undefined;
}

//Function Number: 125
blank()
{
}

//Function Number: 126
setup_dj_booth(param_00)
{
	if(!isdefined(level.dj))
	{
		level scripts\engine\utility::waittill_any_3("power_on","moon power_on");
		level.active_dj_spot = scripts\engine\utility::getstruct(param_00.target,"targetname");
		level.active_dj_door = scripts\engine\utility::getclosest(level.active_dj_spot.origin,getentarray("dj_doors","targetname"));
		level.vo_functions["zmb_dj_vo"] = ::dj_broadcast_vo_handler;
		spawn_dj();
		level thread dj_state_manager(level.dj);
		set_dj_state("open_window");
		return;
	}

	if(!isdefined(level.disable_broadcast))
	{
		set_dj_state("close_window");
		level.dj waittill("window_closed");
		return;
	}

	level.active_dj_spot = scripts\engine\utility::getstruct(param_00.target,"targetname");
	level.active_dj_door = scripts\engine\utility::getclosest(level.active_dj_spot.origin,getentarray("dj_doors","targetname"));
	set_dj_state("open_window");
}

//Function Number: 127
dj_broadcast_vo_handler(param_00,param_01,param_02,param_03,param_04,param_05,param_06)
{
	if(isdefined(level.disable_broadcast))
	{
		return;
	}

	if(!isdefined(level.dj.current_state))
	{
		return;
	}

	while(scripts\cp\cp_vo::is_vo_system_busy() && !isdefined(level.dj_trying_to_broadcast))
	{
		wait(0.1);
	}

	if(scripts\engine\utility::istrue(param_04))
	{
		level.dj notify("end_dj_broadcast_handler");
		level.dj_trying_to_broadcast = undefined;
		foreach(var_08 in level.players)
		{
			var_08 scripts\cp\cp_vo::set_vo_system_playing(0);
			var_08.vo_system_playing_vo = 0;
		}

		level get_dj_into_idle();
	}

	if(isdefined(level.dj_trying_to_broadcast))
	{
		return;
	}

	level.dj endon("end_dj_broadcast_handler");
	level.dj_trying_to_broadcast = 1;
	scripts\cp\cp_vo::set_vo_system_busy(1);
	while(scripts\cp\cp_music_and_dialog::vo_is_playing())
	{
		wait(0.1);
	}

	level.dj thread endon_different_state_changed("approach_mic");
	level.dj thread dj_endon_timeout(30);
	level.dj set_dj_state("approach_mic");
	play_dj_broadcast_vo(param_00,param_01,param_02,param_03,param_04,param_05,param_06);
	level.dj_trying_to_broadcast = undefined;
	scripts\cp\cp_vo::set_vo_system_busy(0);
	foreach(var_08 in level.players)
	{
		var_08 scripts\cp\cp_vo::set_vo_system_playing(0);
	}

	set_dj_state("exit_mic");
	level.dj notify("finished_dj_broadcast");
	level.dj_broadcasting = undefined;
}

//Function Number: 128
play_dj_broadcast_vo(param_00,param_01,param_02,param_03,param_04,param_05,param_06)
{
	level.dj endon("end_dj_broadcast_early");
	if(level.dj.current_state != "at_mic")
	{
		level.dj waittill("at_mic");
	}

	level.dj_broadcasting = 1;
	var_07 = scripts\cp\cp_vo::create_vo_data(param_00,param_03,param_05,param_06);
	foreach(var_09 in level.players)
	{
		if(!isdefined(var_09))
		{
			continue;
		}

		if(var_09 issplitscreenplayer() && !var_09 issplitscreenplayerprimary())
		{
			continue;
		}

		var_09 thread scripts\cp\cp_vo::play_vo_system(var_07);
	}

	level.played_dj_vos[param_00] = 1;
	wait(scripts\cp\cp_vo::get_sound_length(param_00));
}

//Function Number: 129
get_dj_into_idle()
{
	level.dj endon("end_dj_broadcast_handler");
	switch(level.dj.current_state)
	{
		case "open_window":
			set_dj_state("idle");
			break;

		case "approach_mic":
			while(level.dj.current_state != "mic_loop")
			{
				wait(0.1);
			}
	
			break;

		case "mic_loop":
			set_dj_state("exit_mic");
			break;

		case "exit_mic":
			break;
	}

	while(level.dj.current_state != "idle")
	{
		wait(0.1);
	}
}

//Function Number: 130
endon_different_state_changed(param_00)
{
	level.dj endon("finished_dj_broadcast");
	level.dj waittill("state_changed",var_01);
	if(param_00 != var_01)
	{
		level.dj notify("end_dj_broadcast_early");
	}
}

//Function Number: 131
dj_endon_timeout(param_00)
{
	level.dj endon("finished_dj_broadcast");
	level.dj endon("at_mic");
	wait(param_00);
	level.dj notify("end_dj_broadcast_early");
}

//Function Number: 132
spawn_dj()
{
	level.dj = spawn("script_model",level.active_dj_spot.origin);
	level.dj.angles = level.active_dj_spot.angles;
	level.dj setmodel("fullbody_zmb_hero_dj");
	level.dj_states = [];
	level.dj_states["open_window"] = ::dj_open_window;
	level.dj_states["close_window"] = ::dj_close_window;
	level.dj_states["idle"] = ::dj_idle;
	level.dj_states["vo"] = ::dj_say_vo;
	level.dj_states["approach_mic"] = ::dj_approach_mic;
	level.dj_states["exit_mic"] = ::dj_exit_mic;
	level.dj_states["mic_loop"] = ::dj_mic_loop;
}

//Function Number: 133
dj_state_manager(param_00)
{
	level endon("stop_dj_manager");
	for(;;)
	{
		if(!isdefined(level.dj.desired_state))
		{
			wait(0.05);
		}

		level.dj notify("state_changed",level.dj.desired_state);
		switch(level.dj.desired_state)
		{
			case "open_window":
				[[ level.dj_states["open_window"] ]]();
				set_dj_state("idle");
				break;
	
			case "dance":
			case "exit_mic":
			case "mic_loop":
			case "close_window":
			case "approach_mic":
			case "idle":
				[[ level.dj_states[level.dj.desired_state] ]]();
				break;
		}

		wait(0.05);
	}
}

//Function Number: 134
set_dj_state(param_00)
{
	level.dj.desired_state = param_00;
}

//Function Number: 135
dj_interrupt_test()
{
	var_00 = 1;
	for(;;)
	{
		level thread scripts\cp\cp_vo::try_to_play_vo("dj_fateandfort_replenish_nag","zmb_dj_vo","high",20,1,0,1);
		wait(2);
	}
}

//Function Number: 136
dj_open_window()
{
	level.dj.current_state = "open_window";
	turn_on_sign();
	var_00 = getanimlength(%iw7_cp_zom_hoff_dj_window_open);
	level.dj scriptmodelplayanimdeltamotionfrompos("IW7_cp_zom_hoff_dj_window_open",level.active_dj_spot.origin,level.active_dj_spot.angles);
	level.active_dj_door movez(29,0.75);
	wait(var_00 - 0.15);
}

//Function Number: 137
dj_close_window()
{
	level.dj.current_state = "close_window";
	turn_off_sign();
	var_00 = getanimlength(%iw7_cp_zom_hoff_dj_window_close);
	level.dj scriptmodelplayanimdeltamotionfrompos("IW7_cp_zom_hoff_dj_window_close",level.active_dj_spot.origin,level.active_dj_spot.angles);
	wait(2.25);
	level.active_dj_door movez(-29,0.75);
	wait(var_00);
	level.dj notify("window_closed");
}

//Function Number: 138
dj_idle()
{
	level.dj.current_state = "idle";
	var_00 = scripts\engine\utility::random([%iw7_cp_zom_hoff_dj_desk_01,%iw7_cp_zom_hoff_dj_desk_02,%iw7_cp_zom_hoff_dj_desk_03,%iw7_cp_zom_hoff_dj_desk_04,%iw7_cp_zom_hoff_dj_desk_05,%iw7_cp_zom_hoff_dj_desk_06]);
	var_01 = %iw7_cp_zom_hoff_dj_idle_01;
	var_02 = var_01;
	if(randomint(100) > 80)
	{
		var_02 = var_00;
	}

	var_03 = getanimlength(var_02);
	level.dj scriptmodelplayanimdeltamotionfrompos(var_02,level.active_dj_spot.origin,level.active_dj_spot.angles);
	wait(var_03 - 0.1);
}

//Function Number: 139
dj_approach_mic()
{
	level.dj.current_state = "approach_mic";
	var_00 = getanimlength(%iw7_cp_zom_hoff_dj_vo_06_enter);
	level.dj scriptmodelplayanimdeltamotionfrompos("IW7_cp_zom_hoff_dj_vo_06_enter",level.active_dj_spot.origin,level.active_dj_spot.angles);
	wait(var_00);
	level.dj notify("at_mic");
	set_dj_state("mic_loop");
}

//Function Number: 140
dj_exit_mic()
{
	level.dj.current_state = "exit_mic";
	var_00 = getanimlength(%iw7_cp_zom_hoff_dj_vo_06_exit);
	level.dj scriptmodelplayanimdeltamotionfrompos("IW7_cp_zom_hoff_dj_vo_06_exit",level.active_dj_spot.origin,level.active_dj_spot.angles);
	wait(var_00);
	set_dj_state("idle");
}

//Function Number: 141
dj_mic_loop()
{
	level.dj.current_state = "mic_loop";
	var_00 = [%iw7_cp_zom_hoff_dj_vo_06,%iw7_cp_zom_hoff_dj_vo_05,%iw7_cp_zom_hoff_dj_vo_04,%iw7_cp_zom_hoff_dj_vo_03,%iw7_cp_zom_hoff_dj_vo_02,%iw7_cp_zom_hoff_dj_vo_01];
	var_01 = ["IW7_cp_zom_hoff_dj_vo_05","IW7_cp_zom_hoff_dj_vo_04","IW7_cp_zom_hoff_dj_vo_03","IW7_cp_zom_hoff_dj_vo_02","IW7_cp_zom_hoff_dj_vo_01","IW7_cp_zom_hoff_dj_vo_06"];
	var_02 = scripts\engine\utility::random(var_01);
	var_03 = undefined;
	switch(var_02)
	{
		case "IW7_cp_zom_hoff_dj_vo_06":
			var_03 = %iw7_cp_zom_hoff_dj_vo_06;
			break;

		case "IW7_cp_zom_hoff_dj_vo_05":
			var_03 = %iw7_cp_zom_hoff_dj_vo_05;
			break;

		case "IW7_cp_zom_hoff_dj_vo_04":
			var_03 = %iw7_cp_zom_hoff_dj_vo_04;
			break;

		case "IW7_cp_zom_hoff_dj_vo_03":
			var_03 = %iw7_cp_zom_hoff_dj_vo_03;
			break;

		case "IW7_cp_zom_hoff_dj_vo_02":
			var_03 = %iw7_cp_zom_hoff_dj_vo_02;
			break;

		case "IW7_cp_zom_hoff_dj_vo_01":
			var_03 = %iw7_cp_zom_hoff_dj_vo_01;
			break;
	}

	var_04 = getanimlength(var_03);
	level.dj scriptmodelplayanimdeltamotionfrompos(var_02,level.active_dj_spot.origin,level.active_dj_spot.angles);
	wait(var_04);
}

//Function Number: 142
dj_say_vo()
{
}

//Function Number: 143
turn_on_sign(param_00)
{
	var_01 = scripts\engine\utility::getclosest(level.active_dj_door.origin,getentarray("cosmic_tunes","targetname"));
	var_01 setscriptablepartstate("sign","on");
}

//Function Number: 144
turn_off_sign(param_00)
{
	var_01 = scripts\engine\utility::getclosest(level.active_dj_door.origin,getentarray("cosmic_tunes","targetname"));
	var_01 setscriptablepartstate("sign","off");
}