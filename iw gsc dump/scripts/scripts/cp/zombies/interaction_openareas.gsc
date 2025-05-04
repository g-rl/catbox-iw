/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\cp\zombies\interaction_openareas.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 13
 * Decompile Time: 584 ms
 * Timestamp: 10/27/2023 12:26:53 AM
*******************************************************************/

//Function Number: 1
init_all_debris_and_door_positions()
{
	func_F945("debris_350");
	func_F945("debris_1000");
	func_F945("debris_1500");
	func_F945("debris_2000");
	func_F945("debris_1250");
	func_F945("debris_750");
	func_F945("team_door_switch");
	func_F945("chi_0");
	func_F945("chi_1");
	func_F945("chi_2");
}

//Function Number: 2
func_F945(param_00)
{
	var_01 = scripts\engine\utility::getstructarray(param_00,"script_noteworthy");
	foreach(var_03 in var_01)
	{
		set_nonstick(var_03);
	}
}

//Function Number: 3
set_nonstick(param_00)
{
	var_01 = getentarray(param_00.target,"targetname");
	foreach(var_03 in var_01)
	{
		var_03 setnonstick(1);
		wait(0.1);
	}
}

//Function Number: 4
func_102F3(param_00,param_01)
{
	scripts\cp\zombies\zombies_spawning::set_adjacent_volume_from_door_struct(param_00);
	scripts\cp\zombies\zombies_spawning::activate_volume_by_name(param_00.script_area);
	playsoundatpos(param_00.origin,"zmb_sliding_door_open");
	var_02 = getentarray(param_00.target,"targetname");
	foreach(var_04 in var_02)
	{
		var_04 connectpaths();
		var_05 = scripts\engine\utility::getstruct(var_04.target,"targetname");
		var_04 moveto(var_05.origin,1);
	}

	scripts\cp\cp_interaction::disable_linked_interactions(param_00);
	if(level.players.size > 1)
	{
		param_01 thread scripts\cp\cp_vo::try_to_play_vo("purchase_area","zmb_comment_vo","low",10,0,0,1,40);
		return;
	}

	level.players[0] thread scripts\cp\cp_vo::try_to_play_vo("purchase_area","zmb_comment_vo","low",10,0,1,1,40);
}

//Function Number: 5
use_team_door_switch(param_00,param_01)
{
	var_02 = undefined;
	var_03 = undefined;
	if(!isdefined(level.var_115C8))
	{
		level.var_115C8 = 0;
	}

	switch(param_00.script_side)
	{
		case "moon":
			if(!isdefined(level.moon_donations))
			{
				level.moon_donations = -1;
			}
	
			level.moon_donations++;
			var_03 = level.moon_donations;
			scripts\cp\zombies\zombie_analytics::log_purchasingforateamdoor(1,param_01,param_00.script_side,1000,level.wave_num);
			break;

		case "kepler":
			if(!isdefined(level.kepler_donations))
			{
				level.kepler_donations = -1;
			}
	
			level.kepler_donations++;
			var_03 = level.kepler_donations;
			scripts\cp\zombies\zombie_analytics::log_purchasingforateamdoor(1,param_01,param_00.script_side,1000,level.wave_num);
			break;

		case "triton":
			if(!isdefined(level.triton_donations))
			{
				level.triton_donations = -1;
			}
	
			level.triton_donations++;
			var_03 = level.triton_donations;
			scripts\cp\zombies\zombie_analytics::log_purchasingforateamdoor(1,param_01,param_00.script_side,1000,level.wave_num);
			break;
	}

	var_04 = getentarray(param_00.target,"targetname");
	foreach(var_06 in var_04)
	{
		if(!isdefined(var_06.script_noteworthy))
		{
			continue;
		}
		else if(var_06.script_noteworthy == "progress")
		{
			var_06 movez(4,0.1);
			var_06 waittill("movedone");
		}
	}

	if(var_03 >= 3)
	{
		level thread func_C61B(param_00,var_02,var_03,param_01);
		param_01 scripts\cp\cp_merits::processmerit("mt_purchase_doors");
		param_01 notify("door_opened_notify");
		level.var_115C8++;
		if(level.var_115C8 == 2)
		{
			scripts\engine\utility::flag_set("canFiresale");
		}
	}

	if(scripts\cp\utility::isplayingsolo() || scripts\engine\utility::istrue(level.only_one_player))
	{
		if(!scripts\cp\zombies\direct_boss_fight::should_directly_go_to_boss_fight())
		{
			param_01 scripts\cp\cp_persistence::give_player_xp(250,1);
		}
	}
	else if(!scripts\cp\zombies\direct_boss_fight::should_directly_go_to_boss_fight())
	{
		param_01 scripts\cp\cp_persistence::give_player_xp(75,1);
	}

	param_01 scripts\cp\cp_interaction::refresh_interaction();
}

//Function Number: 6
func_C61B(param_00,param_01,param_02,param_03)
{
	scripts\cp\zombies\zombie_analytics::func_AF7E(1,param_03,param_00.script_side,1000,level.wave_num);
	thread func_115B2(param_00);
	scripts\cp\cp_interaction::disable_linked_interactions(param_00);
	var_04 = scripts\cp\cp_interaction::get_linked_interactions(param_00);
	foreach(var_06 in var_04)
	{
		if(!level.spawn_volume_array[var_06.script_area].var_19)
		{
			level thread [[ level.team_buy_vos ]](var_06,param_03);
		}
	}

	foreach(var_09 in var_04)
	{
		scripts\cp\zombies\zombies_spawning::set_adjacent_volume_from_door_struct(var_09);
		scripts\cp\zombies\zombies_spawning::activate_volume_by_name(var_09.script_area);
	}

	if(isdefined(param_00.var_ED83))
	{
		scripts\engine\utility::exploder(param_00.var_ED83);
	}

	var_0B = getentarray(var_04[0].target,"targetname");
	foreach(var_0D in var_0B)
	{
		if(var_0D.spawnimpulsefield == 1)
		{
			var_0D connectpaths();
			var_0D notsolid();
			continue;
		}

		if(var_0D.classname == "script_brushmodel")
		{
			var_0D hide();
			var_0D notsolid();
			continue;
		}

		var_0D setscriptablepartstate("default","hide");
		if(should_play_door_purchase_sound())
		{
			var_0D playsound("purchase_generic");
		}
	}
}

//Function Number: 7
func_115B2(param_00)
{
	wait(0.5);
	playsoundatpos(param_00.origin,"zmb_clear_barricade");
	wait(0.5);
}

//Function Number: 8
init_sliding_power_doors()
{
	var_00 = scripts\engine\utility::getstructarray("power_door_sliding","script_noteworthy");
	foreach(var_02 in var_00)
	{
		var_02 thread sliding_power_door();
	}
}

//Function Number: 9
sliding_power_door()
{
	if(scripts\engine\utility::istrue(self.requires_power))
	{
		level scripts\engine\utility::waittill_any_3("power_on",self.power_area + " power_on");
	}

	self.powered_on = 1;
	playsoundatpos(self.origin,"zmb_sliding_door_open");
	var_00 = getentarray(self.target,"targetname");
	foreach(var_02 in var_00)
	{
		var_02 connectpaths();
		var_03 = scripts\engine\utility::getstruct(var_02.target,"targetname");
		var_02 moveto(var_03.origin,1);
	}

	scripts\cp\cp_interaction::disable_linked_interactions(self);
	scripts\cp\zombies\zombies_spawning::set_adjacent_volume_from_door_struct(self);
	scripts\cp\zombies\zombies_spawning::activate_volume_by_name(self.script_area);
}

//Function Number: 10
func_8FDE(param_00,param_01)
{
	playsoundatpos(param_00.origin,"zmb_gate_open");
	var_02 = getent(param_00.target,"targetname");
	var_02 rotateyaw(160,1);
	scripts\cp\cp_interaction::disable_linked_interactions(param_00);
}

//Function Number: 11
clear_debris(param_00,param_01)
{
	scripts\cp\cp_interaction::disable_linked_interactions(param_00);
	if(isdefined(level.script) && level.script == "cp_disco")
	{
		if(isdefined(param_00) && issubstr(param_00.name,"chi_"))
		{
			playsoundatpos(param_00.origin,"cp_disco_doorbuy_chi_gongs");
		}
		else
		{
			playsoundatpos(param_00.origin,"cp_disco_doorbuy_caution_tape");
		}
	}
	else
	{
		playsoundatpos(param_00.origin,"zmb_clear_barricade");
	}

	scripts\cp\zombies\zombies_spawning::set_adjacent_volume_from_door_struct(param_00);
	scripts\cp\zombies\zombies_spawning::activate_volume_by_name(param_00.script_area);
	var_02 = getentarray(param_00.target,"targetname");
	foreach(var_04 in var_02)
	{
		if(var_04.classname == "script_brushmodel")
		{
			var_04 connectpaths();
			var_04 notsolid();
			continue;
		}

		var_04 setscriptablepartstate("default","hide");
		if(should_play_door_purchase_sound())
		{
			var_04 playsound("purchase_generic");
		}
	}
}

//Function Number: 12
should_play_door_purchase_sound()
{
	if(scripts\cp\zombies\direct_boss_fight::should_directly_go_to_boss_fight())
	{
		return 0;
	}

	return 1;
}

//Function Number: 13
move_up_and_delete(param_00)
{
	self endon("death");
	wait(param_00 * 0.2);
	self movez(10,0.5);
	self rotateto(self.angles + (randomintrange(-10,10),randomintrange(-10,10),randomintrange(-10,10)),0.5);
	wait(0.5);
	self movez(1000,3,2,1);
	wait(2);
	if(isdefined(self))
	{
		self delete();
	}
}