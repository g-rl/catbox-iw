/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\cp\maps\cp_zmb\cp_zmb_crafting.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 21
 * Decompile Time: 1143 ms
 * Timestamp: 10/27/2023 12:08:03 AM
*******************************************************************/

//Function Number: 1
init_crafting()
{
	level.max_crafting_drops = 1;
	level.num_crafting_drops = 0;
	level.last_crafting_item_drop_time = gettime();
	level.crafting_item_min_drop_time = 25000;
	level.crafting_item_max_drop_time = -5536;
	level.next_crafting_item_drop_time = gettime() + 180000;
	level.crafting_item_drop_func = ::zmb_crafting_item_drop_func;
	level.crafting_item_debug_drop = ::zmb_crafting_item_debug_drop;
	level.crafting_item_models = get_crafting_models_from_table(level.crafting_table);
	level.craftable_items_list = get_craftable_items_from_table(level.crafting_table);
	level.crafting_item_ordered_list = level.crafting_item_models;
	level.placed_crafted_traps = [];
	level.crafting_icon_create_func = ::create_player_crafting_item_icon;
}

//Function Number: 2
init_crafting_station()
{
	var_00 = scripts\engine\utility::getstructarray("crafting_station","script_noteworthy");
	foreach(var_03, var_02 in var_00)
	{
		var_02 thread crafting_station_power(var_03);
	}
}

//Function Number: 3
crafting_station_power(param_00)
{
	if(param_00 > 0)
	{
		wait(0.1 * param_00);
	}

	var_01 = scripts\engine\utility::getstructarray(self.target,"targetname");
	foreach(var_03 in var_01)
	{
		if(var_03.script_noteworthy == "fx_spot")
		{
			self.crafting_fx_spot = var_03;
			continue;
		}

		if(var_03.script_noteworthy == "egg_land_spot")
		{
			self.egg_land_spot = var_03;
		}
	}

	var_01 = getentarray(self.target,"targetname");
	foreach(var_03 in var_01)
	{
		if(var_03.script_noteworthy == "souvenir_light")
		{
			self.setminimap = var_03;
			continue;
		}

		if(var_03.script_noteworthy == "souvenir_toy")
		{
			self.souvenir_toy = var_03;
			continue;
		}

		if(var_03.script_noteworthy == "station")
		{
			self.souvenir_station = var_03;
		}
	}

	if(isdefined(self.setminimap))
	{
		self.setminimap setlightintensity(0);
	}

	if(scripts\engine\utility::istrue(self.requires_power) && isdefined(self.power_area))
	{
		level scripts\engine\utility::waittill_any_3("power_on",self.power_area + " power_on");
	}

	if(isdefined(self.setminimap))
	{
		self.setminimap setlightintensity(0.65);
	}

	self.powered_on = 1;
	self.enabled = 0;
	self.available_ingredient_slots = 3;
	self.ingredient_list = [];
	self.souvenir = undefined;
	self.souvenir_station setscriptablepartstate("body","default_on");
	self.souvenir_station setscriptablepartstate("monitor_1","logo");
	self.souvenir_station setscriptablepartstate("monitor_2","logo");
	self.souvenir_station setscriptablepartstate("monitor_3","logo");
	self.egg_land_spot.origin = self.egg_land_spot.origin + (0,0,2);
}

//Function Number: 4
use_crafting_station(param_00,param_01)
{
	if(!scripts\engine\utility::array_contains(level.current_interaction_structs,param_00))
	{
		return;
	}

	if(param_00.available_ingredient_slots > 0)
	{
		if(!isdefined(param_01.current_crafting_struct))
		{
			return;
		}

		param_01 playlocalsound("zmb_coin_sounvenir_place");
		param_01 thread scripts\cp\cp_vo::try_to_play_vo("souvenir_coin_station","zmb_comment_vo","medium",10,0,0,1,50);
		if(getweaponbasename(param_01 getcurrentweapon()) != "iw7_penetrationrail_mp")
		{
			thread scripts\cp\utility::firegesturegrenade(param_01,"iw7_souvenircoin_zm");
		}

		var_02 = "logo";
		level.souvenircointype = param_01.current_crafting_struct.crafting_model;
		switch(param_01.current_crafting_struct.crafting_model)
		{
			case "zmb_coin_alien":
				var_02 = "alien";
				break;

			case "zmb_coin_space":
				var_02 = "space";
				break;

			case "zmb_coin_ice":
				var_02 = "ice";
				break;
		}

		switch(param_00.available_ingredient_slots)
		{
			case 3:
				param_00.souvenir_station setscriptablepartstate("monitor_1",var_02);
				break;

			case 2:
				param_00.souvenir_station setscriptablepartstate("monitor_2",var_02);
				break;

			case 1:
				param_00.souvenir_station setscriptablepartstate("monitor_3",var_02);
				break;
		}

		playsoundatpos(param_00.crafting_fx_spot.origin + (0,0,-5),"zmb_souvenir_machine_arm_mvmt");
		param_01 setclientomnvar("zombie_souvenir_piece_index",0);
		param_00.ingredient_list = scripts\engine\utility::array_add_safe(param_00.ingredient_list,param_01.current_crafting_struct.crafting_model);
		param_01.last_interaction_point = undefined;
		param_01.current_crafting_struct = undefined;
		param_00.var_269F--;
		param_01 scripts\cp\cp_merits::processmerit("mt_used_crafting");
		if(param_00.available_ingredient_slots > 0)
		{
			return;
		}

		level notify("quest_crafting_check",param_00);
		scripts\cp\cp_interaction::remove_from_current_interaction_list(param_00);
		level thread souvenir_vo(param_00);
		wait(0.25);
		playfx(level._effect["crafting_souvenir"],param_00.crafting_fx_spot.origin + (0,0,-5));
		playsoundatpos(param_00.crafting_fx_spot.origin + (0,0,-5),"zmb_souvenir_machine_craft");
		wait(2);
		if(!isdefined(param_00.souvenir_origin))
		{
			param_00.souvenir_origin = param_00.souvenir_toy.origin;
			param_00.souvenir_model = param_00.souvenir_toy.model;
		}

		param_00.souvenir_toy movez(-35,0.2);
		param_00.souvenir_toy waittill("movedone");
		param_00.souvenir_toy moveto(param_00.egg_land_spot.origin,0.2);
		level thread scripts\cp\cp_vo::remove_from_nag_vo("nag_use_souvenircoin");
		scripts\cp\zombies\zombie_analytics::log_souvenircoindeposited(level.wave_num,level.souvenircointype);
		craft_souvenir(param_00,param_01);
		if(param_01 scripts\cp\utility::is_valid_player())
		{
			param_01 thread scripts\cp\cp_vo::try_to_play_vo("souvenir_craft_success","zmb_comment_vo","low",10,0,0,0,50);
		}

		scripts\cp\cp_vo::remove_from_nag_vo("dj_souvenircoin_collect_nag");
		param_00.souvenir_station setscriptablepartstate("monitor_3","logo");
		wait(0.1);
		param_00.souvenir_station setscriptablepartstate("monitor_2","logo");
		wait(0.1);
		param_00.souvenir_station setscriptablepartstate("monitor_1","logo");
		wait(0.1);
		scripts\cp\cp_interaction::add_to_current_interaction_list(param_00);
		while(isdefined(param_00.souvenir))
		{
			wait(0.1);
		}

		playfx(level._effect["souvenir_pickup"],param_00.souvenir_toy.origin + (0,0,-45));
		param_00.available_ingredient_slots = 3;
		param_00.ingredient_list = [];
		if(param_01 scripts\cp\utility::is_valid_player())
		{
			param_01.last_interaction_point = undefined;
			return;
		}
	}
}

//Function Number: 5
souvenir_vo(param_00)
{
	var_01 = get_crafted_souvenir(param_00);
	var_02 = lookupsoundlength("announcer_crafting_inform");
	playsoundatpos(param_00.souvenir_station.origin + (0,0,60),"announcer_crafting_inform");
	wait(var_02 / 1000 + 0.25);
	switch(var_01)
	{
		case "crafted_autosentry":
			playsoundatpos(param_00.souvenir_station.origin + (0,0,60),"announcer_crafting_sentry");
			break;

		case "crafted_ims":
			playsoundatpos(param_00.souvenir_station.origin + (0,0,60),"announcer_crafting_fireworks");
			break;

		case "crafted_medusa":
			playsoundatpos(param_00.souvenir_station.origin + (0,0,60),"announcer_crafting_medusa");
			break;

		case "crafted_electric_trap":
			playsoundatpos(param_00.souvenir_station.origin + (0,0,60),"announcer_crafting_electric");
			break;

		case "crafted_boombox":
			playsoundatpos(param_00.souvenir_station.origin + (0,0,60),"announcer_crafting_boombox");
			break;

		case "crafted_revocator":
			playsoundatpos(param_00.souvenir_station.origin + (0,0,60),"announcer_crafting_revocator");
			break;

		case "crafted_gascan":
			playsoundatpos(param_00.souvenir_station.origin + (0,0,60),"announcer_crafting_kindle");
			break;

		case "crafted_windowtrap":
			playsoundatpos(param_00.souvenir_station.origin + (0,0,60),"announcer_crafting_laser");
			break;
	}
}

//Function Number: 6
zmb_crafting_item_drop_func(param_00,param_01,param_02)
{
	if(!should_drop_crafting_item(param_01))
	{
		return 0;
	}

	level thread spawn_crafting_item(param_01);
	return 1;
}

//Function Number: 7
zmb_crafting_item_debug_drop(param_00,param_01)
{
	level thread spawn_crafting_item(param_00,param_01);
}

//Function Number: 8
spawn_crafting_item(param_00,param_01)
{
	level.var_C1E2++;
	level.last_crafting_item_drop_time = gettime();
	level.next_crafting_item_drop_time = level.last_crafting_item_drop_time + 30000 + randomintrange(level.crafting_item_min_drop_time,level.crafting_item_max_drop_time);
	var_02 = spawn("script_model",param_00 + (0,0,45));
	var_02.angles = (90,0,0);
	var_02.og_angles = (90,0,0);
	var_03 = scripts\engine\utility::random(level.crafting_item_ordered_list);
	if(isdefined(param_01))
	{
		var_03 = param_01;
	}

	var_02 setmodel(var_03);
	var_02.script_noteworthy = "crafting_item";
	var_04 = "red";
	if(var_02.model == "zmb_coin_space")
	{
		var_04 = "blue";
	}
	else if(var_02.model == "zmb_coin_ice")
	{
		var_04 = "green";
	}

	var_02 setscriptablepartstate("fx",var_04);
	var_05 = create_crafting_pickup_interaction(var_02,25);
	var_02 thread crafting_item_timeout(var_05);
}

//Function Number: 9
create_crafting_pickup_interaction(param_00,param_01)
{
	var_02 = spawnstruct();
	var_02.script_noteworthy = "crafting_pickup";
	var_02.origin = param_00.origin - (0,0,45);
	var_02.randomintrange = param_00;
	var_02.requires_power = 0;
	var_02.powered_on = 1;
	var_02.script_parameters = "crafting_pickup";
	var_02.name = "crafting_pickup";
	var_02.time_remaining = param_01;
	var_02.crafting_model = param_00.model;
	var_02.crafting_icon = "";
	var_02.spend_type = "souvenir_coin";
	scripts\cp\cp_interaction::add_to_current_interaction_list(var_02);
	return var_02;
}

//Function Number: 10
crafting_item_pickup(param_00,param_01)
{
	if(!isdefined(param_00.randomintrange))
	{
		return;
	}

	if(isdefined(param_00.randomintrange.beingpickedup))
	{
		return;
	}

	scripts\cp\cp_interaction::remove_from_current_interaction_list(param_00);
	if(!isdefined(level.collect_tokens_vo))
	{
		level.collect_tokens_vo = 1;
		level thread scripts\cp\cp_vo::add_to_nag_vo("dj_souvenircoin_collect_nag","zmb_dj_vo",60,60,2);
	}

	var_02 = param_00.origin + (0,0,45);
	playfx(level._effect["souvenir_pickup"],param_00.randomintrange.origin);
	param_00.randomintrange delete();
	scripts\engine\utility::waitframe();
	if(isdefined(param_01.current_crafting_struct))
	{
		param_01 playlocalsound("zmb_coin_swap");
		var_03 = spawnstruct();
		var_03.script_noteworthy = "crafting_pickup";
		var_03.origin = param_00.origin;
		var_03.randomintrange = spawn("script_model",var_02);
		var_03.randomintrange.angles = (90,0,0);
		var_03.randomintrange.og_angles = (90,0,0);
		var_03.requires_power = 0;
		var_03.powered_on = 1;
		var_03.script_parameters = param_01.current_crafting_struct.script_parameters;
		var_03.name = param_01.current_crafting_struct.name;
		var_03.time_remaining = param_00.time_remaining;
		var_03.crafting_model = param_01.current_crafting_struct.crafting_model;
		var_03.crafting_icon = "";
		var_03.randomintrange setmodel(var_03.crafting_model);
		param_01.current_crafting_struct = param_00;
		param_01 create_player_crafting_item_icon(param_00);
		var_03.randomintrange thread crafting_item_timeout(var_03);
		param_00 = undefined;
		scripts\cp\cp_interaction::add_to_current_interaction_list(var_03);
		wait(0.3);
		var_04 = "red";
		if(var_03.randomintrange.model == "zmb_coin_space")
		{
			var_04 = "blue";
		}
		else if(var_03.randomintrange.model == "zmb_coin_ice")
		{
			var_04 = "green";
		}

		var_03.randomintrange setscriptablepartstate("fx",var_04);
		return;
	}

	param_01 playlocalsound("zmb_coin_pickup");
	level.var_C1E2--;
	param_01.current_crafting_struct = param_00;
	param_01 thread scripts\cp\cp_vo::try_to_play_vo("pillage_craft","zmb_comment_vo","low",10,0,1,0,40);
	param_01 create_player_crafting_item_icon(param_00);
	if(isdefined(param_00.randomintrange))
	{
		param_00.randomintrange delete();
	}
}

//Function Number: 11
create_player_crafting_item_icon(param_00)
{
	var_01 = get_icon_index_based_on_model(param_00.crafting_model);
	self setclientomnvar("zombie_souvenir_piece_index",int(var_01));
}

//Function Number: 12
crafting_item_timeout(param_00)
{
	self endon("death");
	self endon("vacuum");
	self notify("timeout");
	self endon("timeout");
	var_01 = 25;
	if(isdefined(param_00.time_remaining))
	{
		var_01 = int(param_00.time_remaining);
	}

	var_02 = gettime() + var_01 * 1000;
	var_03 = 0;
	var_04 = 0;
	while(gettime() < var_02)
	{
		if(var_04 == 0)
		{
			self rotateyaw(360,2);
			self movez(5,2);
		}

		if(var_04 == 2)
		{
			self rotateyaw(360,2);
			self movez(-5,2);
		}

		if(var_04 == 4)
		{
			var_04 = 0;
			continue;
		}

		wait(1);
		var_04++;
		param_00.time_remaining = param_00.time_remaining - 1;
	}

	playsoundatpos(self.origin,"zmb_coin_disappear");
	playfx(level._effect["souvenir_pickup"],self.origin);
	level.var_C1E2--;
	if(level.num_crafting_drops < 0)
	{
		level.num_crafting_drops = 0;
	}

	scripts\cp\cp_interaction::remove_from_current_interaction_list(param_00);
	self delete();
}

//Function Number: 13
should_drop_crafting_item(param_00)
{
	if(level.num_crafting_drops >= level.max_crafting_drops)
	{
		return 0;
	}

	if(!self.entered_playspace)
	{
		return 0;
	}

	if(isdefined(level.active_volume_check))
	{
		if(![[ level.active_volume_check ]](param_00))
		{
			return 0;
		}
	}

	if(isdefined(level.invalid_spawn_volume_array))
	{
		if(!scripts\cp\cp_weapon::isinvalidzone(param_00,level.invalid_spawn_volume_array,undefined,undefined,1))
		{
			return 0;
		}
	}
	else if(!scripts\cp\cp_weapon::isinvalidzone(param_00,undefined,undefined,undefined,1))
	{
		return 0;
	}

	if(randomint(100) < 30)
	{
		return 0;
	}

	if(level.next_crafting_item_drop_time > gettime())
	{
		return 0;
	}

	return 1;
}

//Function Number: 14
craft_souvenir(param_00,param_01)
{
	var_02 = get_crafted_souvenir(param_00);
	if(!isdefined(var_02))
	{
		var_02 = "money";
	}

	switch(var_02)
	{
		case "crafted_gascan":
		case "crafted_revocator":
		case "crafted_boombox":
		case "crafted_electric_trap":
		case "crafted_medusa":
		case "crafted_ims":
		case "crafted_autosentry":
		case "crafted_windowtrap":
			param_00.script_noteworthy = var_02;
			param_00.spend_type = "craftable";
			param_00.requires_power = 0;
			param_00.powered_on = 1;
			param_00.script_parameters = var_02;
			param_00.name = var_02;
			param_00.souvenir = 1;
			param_00.post_activate_update = 1;
			param_00.crafted_souvenir = 1;
			break;

		default:
			foreach(var_04 in level.players)
			{
				var_04 scripts\cp\cp_persistence::give_player_currency(500);
				break;
			}
	
			break;
	}

	scripts\cp\zombies\zombie_analytics::log_itemcrafted(level.wave_num,var_02);
	if(isdefined(param_01) && isalive(param_01))
	{
		param_01.itemtype = var_02;
	}
}

//Function Number: 15
get_crafted_souvenir(param_00)
{
	foreach(var_02 in level.craftable_items_list)
	{
		var_03 = 0;
		var_04 = var_02;
		foreach(var_06 in param_00.ingredient_list)
		{
			if(scripts\engine\utility::array_contains(var_04,var_06))
			{
				var_03++;
				var_04 = remove_ingredient(var_04,var_06);
			}
		}

		if(var_03 == 3)
		{
			return var_02[0];
		}
	}

	return undefined;
}

//Function Number: 16
remove_ingredient(param_00,param_01)
{
	var_02 = 0;
	var_03 = [];
	for(var_04 = 0;var_04 < param_00.size;var_04++)
	{
		if(!var_02 && param_00[var_04] == param_01)
		{
			var_02 = 1;
			continue;
		}

		var_03[var_03.size] = param_00[var_04];
	}

	return var_03;
}

//Function Number: 17
get_crafting_models_from_table(param_00)
{
	var_01 = [];
	for(var_02 = 1;var_02 < 99;var_02++)
	{
		var_03 = table_look_up(param_00,var_02,1);
		if(var_03 == "")
		{
			break;
		}

		var_01[var_01.size] = var_03;
	}

	return var_01;
}

//Function Number: 18
get_craftable_items_from_table(param_00)
{
	var_01 = 1;
	var_02 = 2;
	var_03 = [];
	for(var_04 = 100;var_04 <= 199;var_04++)
	{
		var_05 = undefined;
		var_05 = table_look_up(param_00,var_04,var_01);
		if(var_05 == "")
		{
			break;
		}

		var_06 = strtok(table_look_up(param_00,var_04,var_02)," ");
		var_06 = scripts\engine\utility::array_insert(var_06,var_05,0);
		var_03[var_03.size] = var_06;
	}

	return var_03;
}

//Function Number: 19
table_look_up(param_00,param_01,param_02)
{
	return tablelookup(param_00,0,param_01,param_02);
}

//Function Number: 20
get_icon_index_based_on_model(param_00)
{
	return tablelookup("scripts/cp/maps/cp_zmb/cp_zmb_crafting.csv",1,param_00,0);
}

//Function Number: 21
souvenir_impact_sounds(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08)
{
	if(isdefined(param_00.playing_sound))
	{
		return;
	}

	param_00 endon("death");
	param_00.playing_sound = 1;
	var_09 = "arcade_tooth_hit";
	param_00 playsound(var_09);
	wait(lookupsoundlength(var_09) / 1000);
	param_00.playing_sound = undefined;
}