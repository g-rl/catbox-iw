/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\cp\maps\cp_rave\gen\cp_rave_art.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 12
 * Decompile Time: 671 ms
 * Timestamp: 10/27/2023 12:05:50 AM
*******************************************************************/

//Function Number: 1
main()
{
	level.tweakfile = 1;
	thread light_control_flags_init();
	thread strobelight_init();
	thread fire_light_flicker_init();
	thread light_fixture_flicker_init();
}

//Function Number: 2
light_control_flags_init()
{
	scripts\engine\utility::flag_init("light_fixture_on");
	scripts\engine\utility::flag_init("light_fixture_off");
	scripts\engine\utility::flag_init("strobe_red");
	scripts\engine\utility::flag_init("strobe_green");
	scripts\engine\utility::flag_init("strobe_blue");
}

//Function Number: 3
strobelight_init()
{
	var_00 = getentarray("strobelight_r","targetname");
	var_01 = getentarray("strobelight_g","targetname");
	var_02 = getentarray("strobelight_b","targetname");
	thread strobe_light_rand_generator();
	scripts\engine\utility::array_thread(var_00,::strobelight_setup);
	scripts\engine\utility::array_thread(var_01,::strobelight_setup);
	scripts\engine\utility::array_thread(var_02,::strobelight_setup);
}

//Function Number: 4
strobelight_setup()
{
	var_00 = parse_noteworthy_values();
	self.light_targetname = self.var_336;
	self.light_position_show = self.origin;
	self.light_position_hide = self.origin - (0,0,1024);
	for(;;)
	{
		if(self.light_targetname == "strobelight_r" && scripts\engine\utility::flag("strobe_red"))
		{
			self.origin = self.light_position_show;
		}

		if(self.light_targetname == "strobelight_r" && !scripts\engine\utility::flag("strobe_red"))
		{
			self.origin = self.light_position_hide;
		}

		if(self.light_targetname == "strobelight_g" && scripts\engine\utility::flag("strobe_green"))
		{
			self.origin = self.light_position_show;
		}

		if(self.light_targetname == "strobelight_g" && !scripts\engine\utility::flag("strobe_green"))
		{
			self.origin = self.light_position_hide;
		}

		if(self.light_targetname == "strobelight_b" && scripts\engine\utility::flag("strobe_blue"))
		{
			self.origin = self.light_position_show;
		}

		if(self.light_targetname == "strobelight_b" && !scripts\engine\utility::flag("strobe_blue"))
		{
			self.origin = self.light_position_hide;
		}

		scripts\engine\utility::waitframe();
	}
}

//Function Number: 5
strobe_light_rand_generator()
{
	for(;;)
	{
		var_00 = randomintrange(0,150);
		if(var_00 >= 50 && var_00 <= 100)
		{
			scripts\engine\utility::flag_set("strobe_red");
			scripts\engine\utility::flag_clear("strobe_green");
			scripts\engine\utility::flag_clear("strobe_blue");
		}
		else if(var_00 >= 100)
		{
			scripts\engine\utility::flag_clear("strobe_red");
			scripts\engine\utility::flag_set("strobe_green");
			scripts\engine\utility::flag_clear("strobe_blue");
		}
		else
		{
			scripts\engine\utility::flag_clear("strobe_red");
			scripts\engine\utility::flag_clear("strobe_green");
			scripts\engine\utility::flag_set("strobe_blue");
		}

		wait(0.5);
	}
}

//Function Number: 6
fire_light_flicker_init()
{
	var_00 = getentarray("fire_light_flicker","targetname");
	scripts\engine\utility::array_thread(var_00,::fire_light_flicker_setup);
}

//Function Number: 7
fire_light_flicker_setup()
{
	var_00 = parse_noteworthy_values();
	self.frequency = 100;
	self.max_intensity = 750;
	self.min_intensity = 5;
	if(isdefined(var_00["frequency"]))
	{
		self.frequency = float(var_00["frequency"]);
	}

	if(isdefined(var_00["max_intensity"]))
	{
		self.max_intensity = float(var_00["max_intensity"]);
	}

	if(isdefined(var_00["min_intensity"]))
	{
		self.min_intensity = float(var_00["min_intensity"]);
	}

	thread fire_light_flicker();
}

//Function Number: 8
fire_light_flicker()
{
	for(;;)
	{
		var_00 = randomfloatrange(self.min_intensity,self.max_intensity);
		self setlightintensity(var_00);
		wait(1 / self.frequency);
	}
}

//Function Number: 9
light_fixture_flicker_init()
{
	thread light_fixture_flicker_rand_generator();
	thread light_fixture_flicker_setup();
}

//Function Number: 10
light_fixture_flicker_setup()
{
	var_00 = parse_noteworthy_values();
	var_01 = getentarray("light_fixture_flicker","targetname");
	var_02 = getentarray("light_fixture_flicker_off","targetname");
	var_03 = getentarray("light_fixture_flicker_on","targetname");
	var_04 = 150;
	var_05 = 5;
	for(;;)
	{
		if(scripts\engine\utility::flag("light_fixture_on"))
		{
			foreach(var_07 in var_03)
			{
				var_07 show();
			}

			foreach(var_0A in var_02)
			{
				var_0A hide();
			}

			foreach(var_0D in var_01)
			{
				var_0D setlightintensity(var_04);
			}
		}
		else if(scripts\engine\utility::flag("light_fixture_off"))
		{
			foreach(var_07 in var_03)
			{
				var_07 hide();
			}

			foreach(var_0A in var_02)
			{
				var_0A show();
			}

			foreach(var_0D in var_01)
			{
				var_0D setlightintensity(var_05);
			}
		}

		scripts\engine\utility::waitframe();
	}
}

//Function Number: 11
light_fixture_flicker_rand_generator()
{
	for(;;)
	{
		var_00 = randomintrange(0,500);
		if(var_00 >= 250)
		{
			scripts\engine\utility::flag_clear("light_fixture_off");
			scripts\engine\utility::flag_set("light_fixture_on");
		}
		else
		{
			scripts\engine\utility::flag_clear("light_fixture_on");
			scripts\engine\utility::flag_set("light_fixture_off");
		}

		scripts\engine\utility::waitframe();
	}
}

//Function Number: 12
parse_noteworthy_values()
{
	var_00 = [];
	if(isdefined(self.script_noteworthy))
	{
		var_01 = strtok(self.script_noteworthy," ");
		foreach(var_03 in var_01)
		{
			var_04 = strtok(var_03,":");
			var_00[var_04[0]] = var_04[1];
		}
	}

	return var_00;
}