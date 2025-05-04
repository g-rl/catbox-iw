/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\cp\maps\cp_zmb\cp_zmb_environment_scriptable.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 33
 * Decompile Time: 1739 ms
 * Timestamp: 10/27/2023 12:08:12 AM
*******************************************************************/

//Function Number: 1
front_gate(param_00)
{
	playsoundatpos((632,2357,334),"entrance_sign_power_on_build");
	wait(3);
	turn_on_global_light();
	wait(2);
	zmb_main_entrance_gate();
	wait(3);
	playsoundatpos((579,2387,374),"pa_speaker_power_on");
	playsoundatpos((634,664,255),"pa_speaker_power_on");
	wait(1);
	enablepaspeaker("starting_area");
	enablepaspeaker("cosmic_way");
	scripts\cp\cp_vo::add_to_nag_vo("dj_powerswitch_restore_nag","zmb_dj_vo",60,15,2,1);
	scripts\cp\cp_vo::add_to_nag_vo("dj_quest_ufo_partsrecovery_start","zmb_dj_vo",180,50,1,1);
	level thread scripts\cp\maps\cp_zmb\cp_zmb_dj::dj_quest_dialogue_vo();
	level notify("jukebox_start");
	level thread main_power_turned_on(param_00);
	level thread signs_mainst();
	set_nonstick();
}

//Function Number: 2
set_nonstick()
{
	var_00 = getentarray("coaster_ice_monster","targetname");
	var_01 = getentarray("octonian","targetname");
	var_02 = scripts\engine\utility::array_combine(var_00,var_01);
	foreach(var_04 in var_02)
	{
		var_04 setnonstick(1);
		scripts\engine\utility::waitframe();
	}
}

//Function Number: 3
turn_on_global_light()
{
	var_00 = getentarray("global_light","targetname");
	foreach(var_02 in var_00)
	{
		var_02 setscriptablepartstate("root","on");
	}
}

//Function Number: 4
zmb_main_entrance_gate()
{
	turn_on_main_gate();
}

//Function Number: 5
turn_on_main_gate()
{
	var_00 = getentarray("main_gate","targetname");
	foreach(var_02 in var_00)
	{
		var_02 setscriptablepartstate("main_gate","gate_on");
	}

	for(var_04 = 1;var_04 <= 5;var_04++)
	{
		var_05 = getent("gate_light_0" + var_04,"targetname");
		var_05 setscriptablepartstate("main_gate_light","turning_on");
	}
}

//Function Number: 6
hidden_room()
{
}

//Function Number: 7
moon()
{
}

//Function Number: 8
moon_outside_begin()
{
	turn_on_sign("sign_cosmiccinema");
	turn_on_sign("sign_roverrampage");
	turn_on_sign("sign_starmission");
	turn_on_sign("sign_escapevelocity");
	turn_on_sign("sign_lunarterrace");
	turn_on_scriptable("rocket_diorama");
}

//Function Number: 9
moon_rocket_space()
{
}

//Function Number: 10
moon_second()
{
	playsoundatpos((3548,938,275),"journey_power_on_build");
	wait(5.5);
	playsoundatpos((3850,438,328),"pa_speaker_power_on");
	wait(2);
	enablepaspeaker("journey");
}

//Function Number: 11
moon_bridge()
{
}

//Function Number: 12
arcade()
{
	turn_on_sign("astrocade_signs");
	getent("bfp_cabinet","targetname") setmodel("zmb_game_bowling_for_planets_on");
	wait(1);
	getent("demon_group","targetname") setscriptablepartstate("group","all_on");
	level thread power_on_arcade_machines("arcade_demon");
	wait(1);
	getent("barnstorming_group","targetname") setscriptablepartstate("group","all_on");
	level thread power_on_arcade_machines("arcade_barnstorming");
	wait(1);
	getent("starmaster_group","targetname") setscriptablepartstate("group","all_on");
	level thread power_on_arcade_machines("arcade_starmaster");
	wait(1);
	getent("group_cosmicarc","targetname") setscriptablepartstate("group","all_on");
	level thread power_on_arcade_machines("arcade_cosmic");
	wait(1);
	getent("group_pitfall","targetname") setscriptablepartstate("group","all_on");
	level thread power_on_arcade_machines("arcade_pitfall");
	wait(1);
	getent("group_riverraid","targetname") setscriptablepartstate("group","all_on");
	level thread power_on_arcade_machines("arcade_riverraid");
	wait(1);
	getent("spider_arcade_group","targetname") setscriptablepartstate("group","all_on");
	level thread power_on_arcade_machines("arcade_spider");
	wait(1);
	getent("robottank_group","targetname") setscriptablepartstate("group","all_on");
	level thread power_on_arcade_machines("arcade_robottank");
}

//Function Number: 13
power_on_arcade_machines(param_00)
{
	var_01 = scripts\engine\utility::getstructarray(param_00,"script_noteworthy");
	foreach(var_03 in var_01)
	{
		scripts\engine\utility::waitframe();
		var_03.powered_on = 1;
		if(isdefined(var_03.script_index))
		{
			var_04 = getent(var_03.name,"targetname");
			var_05 = var_03.script_index;
			var_04 setscriptablepartstate("cab" + var_05,"idle");
		}
	}
}

//Function Number: 14
arcade_back()
{
	playsoundatpos((2873,-1083,357),"astrocade_power_on_build");
	wait(5.5);
	playsoundatpos((2794,-1428,318),"pa_speaker_power_on");
	wait(2);
	enablepaspeaker("astrocade");
}

//Function Number: 15
europa_tunnel()
{
	signs_triton();
}

//Function Number: 16
room_europa()
{
}

//Function Number: 17
europa_2()
{
}

//Function Number: 18
roller_coast_back()
{
	playsoundatpos((-830,-3394,604),"triton_power_on_build");
	wait(5.5);
	playsoundatpos((-1103,-3168,601),"pa_speaker_power_on");
	wait(2);
	enablepaspeaker("triton");
}

//Function Number: 19
swamp_stage()
{
}

//Function Number: 20
mars_3()
{
	signs_kepler();
}

//Function Number: 21
mars()
{
	playsoundatpos((-2168,206,668),"kepler_power_on_build");
	wait(5.5);
	playsoundatpos((-2034,-340,534),"pa_speaker_power_on");
	playsoundatpos((-950,1510,428),"pa_speaker_power_on");
	wait(2);
	enablepaspeaker("kepler");
}

//Function Number: 22
init()
{
	level thread power_on_monitor();
}

//Function Number: 23
is_all_power_on()
{
	foreach(var_01 in level.generators)
	{
		if(!scripts\engine\utility::istrue(var_01.powered_on))
		{
			return 0;
		}
	}

	return 1;
}

//Function Number: 24
all_power_vo(param_00)
{
	if(isdefined(param_00))
	{
		if(param_00.vo_prefix == "p1_")
		{
			level thread scripts\cp\cp_vo::try_to_play_vo("poweron_final_valleygirl_1","zmb_dialogue_vo","highest",666,0,0,0,100);
			return;
		}

		if(param_00.vo_prefix == "p2_")
		{
			level thread scripts\cp\cp_vo::try_to_play_vo("poweron_final_nerd_1","zmb_dialogue_vo","highest",666,0,0,0,100);
			return;
		}

		if(param_00.vo_prefix == "p3_")
		{
			level thread scripts\cp\cp_vo::try_to_play_vo("poweron_final_rapper_1","zmb_dialogue_vo","highest",666,0,0,0,100);
			return;
		}

		if(param_00.vo_prefix == "p4_")
		{
			level thread scripts\cp\cp_vo::try_to_play_vo("poweron_final_jock_1","zmb_dialogue_vo","highest",666,0,0,0,100);
			return;
		}

		return;
	}
}

//Function Number: 25
power_on_monitor()
{
	level endon("game_ended");
	var_00 = getent("main_portal_sun","targetname");
	var_00 setmodel("zmb_center_portal_sun_off");
	for(;;)
	{
		level waittill("power_on_scriptable_and_light",var_01,var_02);
		var_03 = is_all_power_on();
		if(var_03)
		{
			level thread all_power_vo(var_02);
		}

		var_04 = strtok(var_01,",");
		foreach(var_06 in var_04)
		{
			switch(var_06)
			{
				case "front_gate":
					level thread front_gate(var_02);
					break;
	
				case "hidden_room":
					level thread hidden_room();
					break;
	
				case "moon":
					level thread moon();
					break;
	
				case "moon_outside_begin":
					level thread moon_outside_begin();
					break;
	
				case "moon_rocket_space":
					level thread moon_rocket_space();
					break;
	
				case "moon_second":
					level thread moon_second();
					break;
	
				case "moon_bridge":
					level thread moon_bridge();
					break;
	
				case "arcade":
					level thread arcade();
					break;
	
				case "arcade_back":
					level thread arcade_back();
					break;
	
				case "europa_tunnel":
					level thread europa_tunnel();
					break;
	
				case "room_europa":
					level thread room_europa();
					break;
	
				case "europa_2":
					level thread europa_2();
					break;
	
				case "roller_coast_back":
					level thread roller_coast_back();
					break;
	
				case "swamp_stage":
					level thread swamp_stage();
					break;
	
				case "mars_3":
					level thread mars_3();
					break;
	
				case "mars":
					level thread mars();
					break;
			}
		}
	}
}

//Function Number: 26
main_power_turned_on(param_00)
{
	if(param_00.vo_prefix == "p1_")
	{
		level thread scripts\cp\cp_vo::try_to_play_vo("poweron_first_valleygirl_1","zmb_dialogue_vo","highest",666,0,0,0,100);
	}
	else if(param_00.vo_prefix == "p2_")
	{
		level thread scripts\cp\cp_vo::try_to_play_vo("poweron_first_nerd_1","zmb_dialogue_vo","highest",666,0,0,0,100);
	}
	else if(param_00.vo_prefix == "p3_")
	{
		level thread scripts\cp\cp_vo::try_to_play_vo("poweron_first_rapper_1","zmb_dialogue_vo","highest",666,0,0,0,100);
	}
	else if(param_00.vo_prefix == "p4_")
	{
		level thread scripts\cp\cp_vo::try_to_play_vo("poweron_first_jock_1","zmb_dialogue_vo","highest",666,0,0,0,100);
	}

	level.power_on = 1;
	level scripts\cp\cp_vo::add_to_nag_vo("dj_fateandfort_replenish_nag","zmb_dj_vo",180,30,20,1);
	level scripts\cp\cp_vo::add_to_nag_vo("dj_ticketbooths_use_nag","zmb_dj_vo",180,60,20,1);
	level scripts\cp\cp_vo::add_to_nag_vo("dj_pap_cosmicway_nag","zmb_dj_vo",180,25,20,1);
	level scripts\cp\cp_vo::add_to_nag_vo("dj_polarpeaks_use_nag","zmb_dj_vo",180,90,20,1);
}

//Function Number: 27
turn_on_light(param_00)
{
	var_01 = getentarray(param_00,"targetname");
	foreach(var_03 in var_01)
	{
		if(isdefined(var_03.script_intensity_01))
		{
			var_04 = var_03.script_intensity_01;
			var_03 setlightintensity(var_04);
		}
	}
}

//Function Number: 28
signs_mainst()
{
	var_00 = getent("main_portal_sun","targetname");
	var_00.angles = (0,0,0);
	var_01 = getent("triton_skull_light","targetname");
	var_02 = getent("triton_sign_light","targetname");
	level thread rotate_center_portal_sun();
	wait(3);
	var_01 setscriptablepartstate("light","on");
	var_02 setscriptablepartstate("light","on");
	turn_on_scriptable("main_street_ball_lights");
	turn_on_scriptable("space_depot_main_sign");
	turn_on_scriptable("spacedepot_neon_upper");
	turn_on_scriptable("spacedepot_neon_lower");
	turn_on_scriptable("pitstop_main_sign");
	turn_on_scriptable("pitstop_neon_upper");
	turn_on_scriptable("pitstop_neon_lower");
	turn_on_scriptable("saturn_sundaes_main_sign");
	turn_on_scriptable("saturn_sundaes_neon_upper");
	turn_on_scriptable("crater_cakes_main_sign");
	turn_on_scriptable("crater_cakes_neon_upper");
	level thread scripts\cp\maps\cp_zmb\cp_zmb_coaster::turn_on_coaster_anims();
	var_03 = getent("main_street_monster","targetname");
	var_03 setscriptablepartstate("main","idle2");
}

//Function Number: 29
rotate_center_portal_sun()
{
	var_00 = getent("main_portal_sun","targetname");
	var_00 setmodel("zmb_center_portal_sun");
	for(;;)
	{
		var_00 rotateyaw(360,10);
		wait(9.95);
	}
}

//Function Number: 30
turn_on_sign(param_00)
{
	var_01 = getentarray(param_00,"targetname");
	foreach(var_03 in var_01)
	{
		wait(randomfloatrange(0.15,0.25));
		var_03 setscriptablepartstate("sign","powered_on");
	}
}

//Function Number: 31
turn_on_scriptable(param_00)
{
	var_01 = getentarray(param_00,"targetname");
	foreach(var_03 in var_01)
	{
		wait(randomfloatrange(0.25,0.5));
		var_03 setscriptablepartstate("neon_tube","on");
	}
}

//Function Number: 32
signs_triton()
{
	turn_on_scriptable("triton_ceiling_neon");
}

//Function Number: 33
signs_kepler()
{
	turn_on_sign("moonlight_cafe_signs");
	turn_on_sign("sign_hyperslopes");
	turn_on_sign("sign_conelord");
	turn_on_sign("chromosphere_sign");
	turn_on_sign("shooting_gallery_sign");
	turn_on_sign("sign_spaceshipsplash");
	getent("chromosphere_mike","targetname") setscriptablepartstate("main","on");
	var_00 = getentarray("octonian","targetname");
	foreach(var_02 in var_00)
	{
		var_02 setscriptablepartstate("body","on");
	}
}