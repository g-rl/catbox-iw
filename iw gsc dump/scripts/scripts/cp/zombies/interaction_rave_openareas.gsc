/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\cp\zombies\interaction_rave_openareas.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 5
 * Decompile Time: 316 ms
 * Timestamp: 10/27/2023 12:09:04 AM
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
init_sliding_power_doors()
{
	var_00 = scripts\engine\utility::getstructarray("power_door_sliding","script_noteworthy");
	foreach(var_02 in var_00)
	{
		var_02 thread sliding_power_door();
	}
}

//Function Number: 5
sliding_power_door()
{
	if(scripts\engine\utility::istrue(self.requires_power))
	{
		level scripts\engine\utility::waittill_any_3("power_on",self.power_area + " power_on");
	}

	self.powered_on = 1;
	if(isdefined(self.script_sound))
	{
		playsoundatpos(self.origin,self.script_sound);
	}

	var_00 = getentarray(self.target,"targetname");
	foreach(var_02 in var_00)
	{
		if(isdefined(var_02.moved))
		{
			continue;
		}

		if(var_02.classname == "script_brushmodel")
		{
			var_02.moved = 1;
			var_02 connectpaths();
			var_02 notsolid();
		}

		if(var_02.classname == "script_model")
		{
			var_02.moved = 1;
			var_02 moveto(var_02.origin + var_02.script_angles,0.5);
		}
	}

	scripts\cp\cp_interaction::disable_linked_interactions(self);
	scripts\cp\zombies\zombies_spawning::set_adjacent_volume_from_door_struct(self);
	scripts\cp\zombies\zombies_spawning::activate_volume_by_name(self.script_area);
}