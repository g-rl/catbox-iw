/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\common\createfxmenu.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 40
 * Decompile Time: 1978 ms
 * Timestamp: 10/27/2023 12:03:17 AM
*******************************************************************/

//Function Number: 1
init_menu()
{
	level._createfx.options = [];
	addoption("string","fxid","FX id","nil","fx");
	addoption("float","delay","Repeat rate/start delay",0.5,"fx");
	addoption("string","flag","Flag","nil","exploder");
	if(!level.mp_createfx)
	{
		addoption("string","firefx","2nd FX id","nil","exploder");
		addoption("float","firefxdelay","2nd FX id repeat rate",0.5,"exploder");
		addoption("float","firefxtimeout","2nd FX timeout",5,"exploder");
		addoption("string","firefxsound","2nd FX soundalias","nil","exploder");
		addoption("float","damage","Radius damage",150,"exploder");
		addoption("float","damage_radius","Radius of radius damage",250,"exploder");
		addoption("string","earthquake","Earthquake","nil","exploder");
		addoption("string","ender","Level notify for ending 2nd FX","nil","exploder");
	}

	addoption("float","delay_min","Minimimum time between repeats",1,"soundfx_interval");
	addoption("float","delay_max","Maximum time between repeats",2,"soundfx_interval");
	addoption("int","repeat","Number of times to repeat",5,"exploder");
	addoption("string","exploder","Exploder","1","exploder");
	addoption("string","soundalias","Soundalias","nil","all");
	addoption("string","loopsound","Loopsound","nil","exploder");
	addoption("int","reactive_radius","Reactive Radius",100,"reactive_fx",::input_reactive_radius);
	if(!level.mp_createfx)
	{
		addoption("string","rumble","Rumble","nil","exploder");
		addoption("int","stopable","Can be stopped from script","1","all");
	}

	level.effect_list_offset = 0;
	level.effect_list_offset_max = 10;
	if(level.mp_createfx)
	{
		level.effect_list_offset_max = 6;
	}

	level.createfxmasks = [];
	level.createfxmasks["all"] = [];
	level.createfxmasks["all"]["exploder"] = 1;
	level.createfxmasks["all"]["oneshotfx"] = 1;
	level.createfxmasks["all"]["loopfx"] = 1;
	level.createfxmasks["all"]["soundfx"] = 1;
	level.createfxmasks["all"]["soundfx_interval"] = 1;
	level.createfxmasks["all"]["reactive_fx"] = 1;
	level.createfxmasks["fx"] = [];
	level.createfxmasks["fx"]["exploder"] = 1;
	level.createfxmasks["fx"]["oneshotfx"] = 1;
	level.createfxmasks["fx"]["loopfx"] = 1;
	if(!level.mp_createfx)
	{
		level.createfxmasks["fx"]["reactive_fx"] = 1;
	}

	level.createfxmasks["exploder"] = [];
	level.createfxmasks["exploder"]["exploder"] = 1;
	level.createfxmasks["loopfx"] = [];
	level.createfxmasks["loopfx"]["loopfx"] = 1;
	level.createfxmasks["oneshotfx"] = [];
	level.createfxmasks["oneshotfx"]["oneshotfx"] = 1;
	level.createfxmasks["soundfx"] = [];
	level.createfxmasks["soundfx"]["soundalias"] = 1;
	level.createfxmasks["soundfx_interval"] = [];
	level.createfxmasks["soundfx_interval"]["soundfx_interval"] = 1;
	level.createfxmasks["reactive_fx"] = [];
	level.createfxmasks["reactive_fx"]["reactive_fx"] = 1;
	var_00 = [];
	var_00["creation"] = ::menu_create_select;
	var_00["create_oneshot"] = ::menu_create;
	var_00["create_loopfx"] = ::menu_create;
	var_00["change_fxid"] = ::menu_create;
	var_00["none"] = ::menu_none;
	var_00["add_options"] = ::menu_add_options;
	var_00["select_by_name"] = ::menu_select_by_name;
	level._createfx.menus = var_00;
}

//Function Number: 2
menu(param_00)
{
	return level.create_fx_menu == param_00;
}

//Function Number: 3
setmenu(param_00)
{
	level.create_fx_menu = param_00;
}

//Function Number: 4
create_fx_menu()
{
	if(scripts\common\createfx::button_is_clicked("escape","x"))
	{
		exit_menu();
		return;
	}

	if(isdefined(level._createfx.menus[level.create_fx_menu]))
	{
		[[ level._createfx.menus[level.create_fx_menu] ]]();
	}
}

//Function Number: 5
menu_create_select()
{
	if(!isdefined(level._createfx.menu_create_select))
	{
		level._createfx.menu_create_select = [];
		var_00 = [];
		var_00["1"] = ::buttonpress_create_oneshot;
		if(!level.mp_createfx)
		{
			var_00["2"] = ::buttonpress_create_loopfx;
			var_00["3"] = ::buttonpress_create_loopsound;
			var_00["4"] = ::buttonpress_create_exploder;
			var_00["5"] = ::buttonpress_create_interval_sound;
			var_00["6"] = ::buttonpress_create_reactiveent;
		}
		else
		{
			var_00["2"] = ::buttonpress_create_loopsound;
			var_00["3"] = ::buttonpress_create_exploder;
			var_00["4"] = ::buttonpress_create_interval_sound;
			var_00["5"] = ::buttonpress_create_reactiveent;
		}

		level._createfx.menu_create_select = var_00;
	}

	foreach(var_03, var_02 in level._createfx.menu_create_select)
	{
		if(scripts\common\createfx::button_is_clicked(var_03))
		{
			[[ var_02 ]]();
			return;
		}
	}
}

//Function Number: 6
buttonpress_create_oneshot()
{
	setmenu("create_oneshot");
	draw_effects_list();
}

//Function Number: 7
buttonpress_create_loopfx()
{
	setmenu("create_loopfx");
	draw_effects_list();
}

//Function Number: 8
buttonpress_create_loopsound()
{
	setmenu("create_loopsound");
	var_00 = scripts\common\createfx::createloopsound();
	finish_creating_entity(var_00);
}

//Function Number: 9
buttonpress_create_exploder()
{
	setmenu("create_exploder");
	var_00 = scripts\common\createfx::createnewexploder();
	finish_creating_entity(var_00);
}

//Function Number: 10
buttonpress_create_interval_sound()
{
	setmenu("create_interval_sound");
	var_00 = scripts\common\createfx::createintervalsound();
	finish_creating_entity(var_00);
}

//Function Number: 11
buttonpress_create_reactiveent()
{
	var_00 = scripts\common\createfx::createreactiveent();
	finish_creating_entity(var_00);
}

//Function Number: 12
menu_create()
{
	if(next_button())
	{
		increment_list_offset();
		draw_effects_list();
	}
	else if(previous_button())
	{
		decrement_list_offset();
		draw_effects_list();
	}

	menu_fx_creation();
}

//Function Number: 13
menu_none()
{
	if(scripts\common\createfx::button_is_clicked("m"))
	{
		increment_list_offset();
	}

	menu_change_selected_fx();
	if(entities_are_selected())
	{
		var_00 = get_last_selected_ent();
		if(!isdefined(level.last_displayed_ent) || var_00 != level.last_displayed_ent)
		{
			display_fx_info(var_00);
			level.last_displayed_ent = var_00;
		}

		if(scripts\common\createfx::button_is_clicked("a"))
		{
			scripts\common\createfx::clear_settable_fx();
			setmenu("add_options");
			return;
		}

		return;
	}

	level.last_displayed_ent = undefined;
}

//Function Number: 14
menu_add_options()
{
	if(!entities_are_selected())
	{
		scripts\common\createfx::clear_fx_hudelements();
		setmenu("none");
		return;
	}

	display_fx_add_options(get_last_selected_ent());
	if(next_button())
	{
		increment_list_offset();
	}
}

//Function Number: 15
menu_select_by_name()
{
	if(next_button())
	{
		increment_list_offset();
		draw_effects_list("Select by name");
	}
	else if(previous_button())
	{
		decrement_list_offset();
		draw_effects_list("Select by name");
	}

	select_by_name();
}

//Function Number: 16
next_button()
{
	return scripts\common\createfx::button_is_clicked("rightarrow");
}

//Function Number: 17
previous_button()
{
	return scripts\common\createfx::button_is_clicked("leftarrow");
}

//Function Number: 18
exit_menu()
{
	scripts\common\createfx::clear_fx_hudelements();
	scripts\common\createfx::clear_entity_selection();
	scripts\common\createfx::update_selected_entities();
	setmenu("none");
}

//Function Number: 19
menu_fx_creation()
{
	var_00 = 0;
	var_01 = undefined;
	var_02 = scripts\common\createfx::func_get_level_fx();
	for(var_03 = level.effect_list_offset;var_03 < var_02.size;var_03++)
	{
		var_00 = var_00 + 1;
		var_04 = var_00;
		if(var_04 == 10)
		{
			var_04 = 0;
		}

		if(scripts\common\createfx::button_is_clicked(var_04 + ""))
		{
			var_01 = var_02[var_03];
			break;
		}

		if(var_00 > level.effect_list_offset_max)
		{
			break;
		}
	}

	if(!isdefined(var_01))
	{
		return;
	}

	if(menu("change_fxid"))
	{
		apply_option_to_selected_fx(get_option("fxid"),var_01);
		level.effect_list_offset = 0;
		scripts\common\createfx::clear_fx_hudelements();
		setmenu("none");
		return;
	}

	var_05 = undefined;
	if(menu("create_loopfx"))
	{
		var_05 = scripts\engine\utility::createloopeffect(var_01);
	}

	if(menu("create_oneshot"))
	{
		var_05 = scripts\engine\utility::createoneshoteffect(var_01);
	}

	finish_creating_entity(var_05);
}

//Function Number: 20
finish_creating_entity(param_00)
{
	param_00.v["angles"] = vectortoangles(param_00.v["origin"] + (0,0,100) - param_00.v["origin"]);
	if(isdefined(level._effect) && isdefined(level._effect[param_00.v["fxid"]]) && function_02A2(level._effect[param_00.v["fxid"]]))
	{
		param_00.v["angles"] = (0,0,0);
	}

	param_00 scripts\common\createfx::post_entity_creation_function();
	scripts\common\createfx::clear_entity_selection();
	scripts\common\createfx::select_last_entity();
	scripts\common\createfx::move_selection_to_cursor();
	scripts\common\createfx::update_selected_entities();
	setmenu("none");
}

//Function Number: 21
entities_are_selected()
{
	return level._createfx.selected_fx_ents.size > 0;
}

//Function Number: 22
menu_change_selected_fx()
{
	if(!level._createfx.selected_fx_ents.size)
	{
		return;
	}

	var_00 = 0;
	var_01 = 0;
	var_02 = get_last_selected_ent();
	for(var_03 = 0;var_03 < level._createfx.options.size;var_03++)
	{
		var_04 = level._createfx.options[var_03];
		if(!isdefined(var_02.v[var_04["name"]]))
		{
			continue;
		}

		var_00++;
		if(var_00 < level.effect_list_offset)
		{
			continue;
		}

		var_01++;
		var_05 = var_01;
		if(var_05 == 10)
		{
			var_05 = 0;
		}

		if(scripts\common\createfx::button_is_clicked(var_05 + ""))
		{
			prepare_option_for_change(var_04,var_01);
			break;
		}

		if(var_01 > level.effect_list_offset_max)
		{
			var_06 = 1;
			break;
		}
	}
}

//Function Number: 23
prepare_option_for_change(param_00,param_01)
{
	if(param_00["name"] == "fxid")
	{
		setmenu("change_fxid");
		draw_effects_list();
		return;
	}

	level.createfx_inputlocked = 1;
	level._createfx.hudelems[param_01 + 3][0].color = (1,1,0);
	if(isdefined(param_00["input_func"]))
	{
		thread [[ param_00["input_func"] ]](param_01 + 3);
	}
	else
	{
		scripts\common\createfx::createfx_centerprint("To change " + param_00["description"] + " on selected entities, type /fx newvalue");
	}

	set_option_index(param_00["name"]);
	setdvar("fx","nil");
}

//Function Number: 24
menu_fx_option_set()
{
	if(getdvar("fx") == "nil")
	{
		return;
	}

	var_00 = get_selected_option();
	var_01 = undefined;
	if(var_00["type"] == "string")
	{
		var_01 = getdvar("fx");
	}

	if(var_00["type"] == "int")
	{
		var_01 = getdvarint("fx");
	}

	if(var_00["type"] == "float")
	{
		var_01 = getdvarfloat("fx");
	}

	apply_option_to_selected_fx(var_00,var_01);
}

//Function Number: 25
apply_option_to_selected_fx(param_00,param_01)
{
	for(var_02 = 0;var_02 < level._createfx.selected_fx_ents.size;var_02++)
	{
		var_03 = level._createfx.selected_fx_ents[var_02];
		if(mask(param_00["mask"],var_03.v["type"]))
		{
			var_03.v[param_00["name"]] = param_01;
		}
	}

	level.last_displayed_ent = undefined;
	scripts\common\createfx::update_selected_entities();
	scripts\common\createfx::clear_settable_fx();
}

//Function Number: 26
set_option_index(param_00)
{
	for(var_01 = 0;var_01 < level._createfx.options.size;var_01++)
	{
		if(level._createfx.options[var_01]["name"] != param_00)
		{
			continue;
		}

		level._createfx.selected_fx_option_index = var_01;
		return;
	}
}

//Function Number: 27
get_selected_option()
{
	return level._createfx.options[level._createfx.selected_fx_option_index];
}

//Function Number: 28
mask(param_00,param_01)
{
	return isdefined(level.createfxmasks[param_00][param_01]);
}

//Function Number: 29
addoption(param_00,param_01,param_02,param_03,param_04,param_05)
{
	var_06 = [];
	var_06["type"] = param_00;
	var_06["name"] = param_01;
	var_06["description"] = param_02;
	var_06["default"] = param_03;
	var_06["mask"] = param_04;
	if(isdefined(param_05))
	{
		var_06["input_func"] = param_05;
	}

	level._createfx.options[level._createfx.options.size] = var_06;
}

//Function Number: 30
get_option(param_00)
{
	for(var_01 = 0;var_01 < level._createfx.options.size;var_01++)
	{
		if(level._createfx.options[var_01]["name"] == param_00)
		{
			return level._createfx.options[var_01];
		}
	}
}

//Function Number: 31
input_reactive_radius(param_00)
{
	for(;;)
	{
		wait(0.05);
		if(level.player buttonpressed("escape") || level.player buttonpressed("x"))
		{
			break;
		}

		var_01 = 0;
		if(level.player buttonpressed("-"))
		{
			var_01 = -10;
		}
		else if(level.player buttonpressed("="))
		{
			var_01 = 10;
		}

		if(var_01 != 0)
		{
			foreach(var_03 in level._createfx.selected_fx_ents)
			{
				if(isdefined(var_03.v["reactive_radius"]))
				{
					var_03.v["reactive_radius"] = var_03.v["reactive_radius"] + var_01;
					var_03.v["reactive_radius"] = clamp(var_03.v["reactive_radius"],10,1000);
				}
			}
		}
	}

	level.last_displayed_ent = undefined;
	scripts\common\createfx::update_selected_entities();
	scripts\common\createfx::clear_settable_fx();
}

//Function Number: 32
display_fx_add_options(param_00)
{
	scripts\common\createfx::clear_fx_hudelements();
	scripts\common\createfx::set_fx_hudelement("Name: " + param_00.v["fxid"]);
	scripts\common\createfx::set_fx_hudelement("Type: " + param_00.v["type"]);
	scripts\common\createfx::set_fx_hudelement("Origin: " + param_00.v["origin"]);
	scripts\common\createfx::set_fx_hudelement("Angles: " + param_00.v["angles"]);
	var_01 = 0;
	var_02 = 0;
	var_03 = 0;
	if(level.effect_list_offset >= level._createfx.options.size)
	{
		level.effect_list_offset = 0;
	}

	for(var_04 = 0;var_04 < level._createfx.options.size;var_04++)
	{
		var_05 = level._createfx.options[var_04];
		if(isdefined(param_00.v[var_05["name"]]))
		{
			continue;
		}

		if(!mask(var_05["mask"],param_00.v["type"]))
		{
			continue;
		}

		var_01++;
		if(var_01 < level.effect_list_offset)
		{
			continue;
		}

		if(var_02 >= level.effect_list_offset_max)
		{
			continue;
		}

		var_02++;
		var_06 = var_02;
		if(var_06 == 10)
		{
			var_06 = 0;
		}

		if(scripts\common\createfx::button_is_clicked(var_06 + ""))
		{
			add_option_to_selected_entities(var_05);
			menunone();
			level.last_displayed_ent = undefined;
			return;
		}

		scripts\common\createfx::set_fx_hudelement(var_06 + ". " + var_05["description"]);
	}

	if(var_01 > level.effect_list_offset_max)
	{
		scripts\common\createfx::set_fx_hudelement("(->) More >");
	}

	scripts\common\createfx::set_fx_hudelement("(x) Exit >");
}

//Function Number: 33
add_option_to_selected_entities(param_00)
{
	var_01 = undefined;
	for(var_02 = 0;var_02 < level._createfx.selected_fx_ents.size;var_02++)
	{
		var_03 = level._createfx.selected_fx_ents[var_02];
		if(mask(param_00["mask"],var_03.v["type"]))
		{
			var_03.v[param_00["name"]] = param_00["default"];
		}
	}
}

//Function Number: 34
menunone()
{
	level.effect_list_offset = 0;
	scripts\common\createfx::clear_fx_hudelements();
	setmenu("none");
}

//Function Number: 35
display_fx_info(param_00)
{
	if(!menu("none"))
	{
		return;
	}

	scripts\common\createfx::clear_fx_hudelements();
	scripts\common\createfx::set_fx_hudelement("Name: " + param_00.v["fxid"]);
	scripts\common\createfx::set_fx_hudelement("Type: " + param_00.v["type"]);
	scripts\common\createfx::set_fx_hudelement("Origin: " + param_00.v["origin"]);
	scripts\common\createfx::set_fx_hudelement("Angles: " + param_00.v["angles"]);
	if(entities_are_selected())
	{
		var_01 = 0;
		var_02 = 0;
		var_03 = 0;
		for(var_04 = 0;var_04 < level._createfx.options.size;var_04++)
		{
			var_05 = level._createfx.options[var_04];
			if(!isdefined(param_00.v[var_05["name"]]))
			{
				continue;
			}

			var_01++;
			if(var_01 < level.effect_list_offset)
			{
				continue;
			}

			var_02++;
			scripts\common\createfx::set_fx_hudelement(var_02 + ". " + var_05["description"] + ": " + param_00.v[var_05["name"]]);
			if(var_02 > level.effect_list_offset_max)
			{
				var_03 = 1;
				break;
			}
		}

		if(var_01 > level.effect_list_offset_max)
		{
			scripts\common\createfx::set_fx_hudelement("(->) More >");
		}

		scripts\common\createfx::set_fx_hudelement("(a) Add >");
		scripts\common\createfx::set_fx_hudelement("(x) Exit >");
		return;
	}

	var_01 = 0;
	var_03 = 0;
	for(var_04 = 0;var_04 < level._createfx.options.size;var_04++)
	{
		var_05 = level._createfx.options[var_04];
		if(!isdefined(param_00.v[var_05["name"]]))
		{
			continue;
		}

		var_01++;
		scripts\common\createfx::set_fx_hudelement(var_05["description"] + ": " + param_00.v[var_05["name"]]);
		if(var_01 > level._createfx.hudelem_count)
		{
			break;
		}
	}
}

//Function Number: 36
draw_effects_list(param_00)
{
	scripts\common\createfx::clear_fx_hudelements();
	var_01 = 0;
	var_02 = 0;
	var_03 = scripts\common\createfx::func_get_level_fx();
	if(!isdefined(param_00))
	{
		param_00 = "Pick an effect";
	}

	scripts\common\createfx::set_fx_hudelement(param_00 + " [" + level.effect_list_offset + " - " + var_03.size + "]:");
	for(var_04 = level.effect_list_offset;var_04 < var_03.size;var_04++)
	{
		var_01 = var_01 + 1;
		scripts\common\createfx::set_fx_hudelement(var_01 + ". " + var_03[var_04]);
		if(var_01 >= level.effect_list_offset_max)
		{
			var_02 = 1;
			break;
		}
	}

	if(var_03.size > level.effect_list_offset_max)
	{
		scripts\common\createfx::set_fx_hudelement("(->) More >");
		scripts\common\createfx::set_fx_hudelement("(<-) Previous >");
	}
}

//Function Number: 37
increment_list_offset()
{
	var_00 = scripts\common\createfx::func_get_level_fx();
	if(level.effect_list_offset >= var_00.size - level.effect_list_offset_max)
	{
		level.effect_list_offset = 0;
		return;
	}

	level.effect_list_offset = level.effect_list_offset + level.effect_list_offset_max;
}

//Function Number: 38
decrement_list_offset()
{
	level.effect_list_offset = level.effect_list_offset - level.effect_list_offset_max;
	if(level.effect_list_offset < 0)
	{
		var_00 = scripts\common\createfx::func_get_level_fx();
		level.effect_list_offset = var_00.size - level.effect_list_offset_max;
	}
}

//Function Number: 39
select_by_name()
{
	var_00 = 0;
	var_01 = undefined;
	var_02 = scripts\common\createfx::func_get_level_fx();
	for(var_03 = level.effect_list_offset;var_03 < var_02.size;var_03++)
	{
		var_00 = var_00 + 1;
		var_04 = var_00;
		if(var_04 == 10)
		{
			var_04 = 0;
		}

		if(scripts\common\createfx::button_is_clicked(var_04 + ""))
		{
			var_01 = var_02[var_03];
			break;
		}

		if(var_00 > level.effect_list_offset_max)
		{
			break;
		}
	}

	if(!isdefined(var_01))
	{
		return;
	}

	var_05 = [];
	foreach(var_03, var_07 in level.createfxent)
	{
		if(issubstr(var_07.v["fxid"],var_01))
		{
			var_05[var_05.size] = var_03;
		}
	}

	scripts\common\createfx::deselect_all_ents();
	scripts\common\createfx::select_index_array(var_05);
	level._createfx.select_by_name = 1;
}

//Function Number: 40
get_last_selected_ent()
{
	return level._createfx.selected_fx_ents[level._createfx.selected_fx_ents.size - 1];
}