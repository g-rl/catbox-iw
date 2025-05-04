/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\cp\cp_movers.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 48
 * Decompile Time: 2479 ms
 * Timestamp: 10/27/2023 12:09:39 AM
*******************************************************************/

//Function Number: 1
main()
{
	if(getdvar("r_reflectionProbeGenerate") == "1")
	{
		return;
	}

	level.script_mover_defaults = [];
	level.script_mover_defaults["move_time"] = 5;
	level.script_mover_defaults["accel_time"] = 0;
	level.script_mover_defaults["decel_time"] = 0;
	level.script_mover_defaults["wait_time"] = 0;
	level.script_mover_defaults["delay_time"] = 0;
	level.script_mover_defaults["usable"] = 0;
	level.script_mover_defaults["hintstring"] = "activate";
	script_mover_add_hintstring("activate",&"MP_ACTIVATE_MOVER");
	script_mover_add_parameters("none","");
	level.script_mover_named_goals = [];
	scripts\engine\utility::waitframe();
	var_00 = [];
	var_01 = script_mover_classnames();
	foreach(var_03 in var_01)
	{
		var_00 = scripts\engine\utility::array_combine(var_00,getentarray(var_03,"classname"));
	}

	scripts\engine\utility::array_thread(var_00,::script_mover_int);
}

//Function Number: 2
script_mover_classnames()
{
	return ["script_model_mover","script_brushmodel_mover"];
}

//Function Number: 3
script_mover_is_script_mover()
{
	if(isdefined(self.script_mover))
	{
		return self.script_mover;
	}

	var_00 = script_mover_classnames();
	foreach(var_02 in var_00)
	{
		if(self.classname == var_02)
		{
			self.script_mover = 1;
			return 1;
		}
	}

	return 0;
}

//Function Number: 4
script_mover_add_hintstring(param_00,param_01)
{
	if(!isdefined(level.script_mover_hintstrings))
	{
		level.script_mover_hintstrings = [];
	}

	level.script_mover_hintstrings[param_00] = param_01;
}

//Function Number: 5
script_mover_add_parameters(param_00,param_01)
{
	if(!isdefined(level.script_mover_parameters))
	{
		level.script_mover_parameters = [];
	}

	level.script_mover_parameters[param_00] = param_01;
}

//Function Number: 6
script_mover_int()
{
	if(!isdefined(self.target))
	{
		return;
	}

	self.script_mover = 1;
	self.moving = 0;
	self.origin_ent = self;
	self.use_triggers = [];
	self.linked_ents = [];
	var_00 = scripts\engine\utility::getstructarray(self.target,"targetname");
	foreach(var_02 in var_00)
	{
		if(!isdefined(var_02.script_noteworthy))
		{
			continue;
		}

		switch(var_02.script_noteworthy)
		{
			case "origin":
				if(!isdefined(var_02.angles))
				{
					var_02.angles = (0,0,0);
				}
	
				self.origin_ent = spawn("script_model",var_02.origin);
				self.origin_ent.angles = var_02.angles;
				self.origin_ent setmodel("tag_origin");
				self.origin_ent linkto(self);
				break;

			default:
				break;
		}
	}

	var_04 = getentarray(self.target,"targetname");
	foreach(var_02 in var_04)
	{
		if(!isdefined(var_02.script_noteworthy))
		{
			continue;
		}

		switch(var_02.script_noteworthy)
		{
			case "use_trigger_link":
				var_02 enablelinkto();
				var_02 linkto(self);
				break;

			case "use_trigger":
				var_02 script_mover_parse_targets();
				thread script_mover_use_trigger(var_02);
				self.use_triggers[self.use_triggers.size] = var_02;
				break;

			case "link":
				var_02 linkto(self);
				self.linked_ents[self.linked_ents.size] = var_02;
				break;

			default:
				break;
		}
	}

	thread script_mover_parse_targets();
	thread script_mover_init_move_parameters();
	thread script_mover_save_default_move_parameters();
	thread script_mover_apply_move_parameters(self);
	thread script_mover_move_to_target();
	foreach(var_08 in self.use_triggers)
	{
		script_mover_set_usable(var_08,1);
	}
}

//Function Number: 7
script_mover_use_trigger(param_00)
{
	self endon("death");
	for(;;)
	{
		param_00 waittill("trigger");
		if(param_00.goals.size > 0)
		{
			self notify("new_path");
			thread script_mover_move_to_target(param_00);
			continue;
		}

		self notify("trigger");
	}
}

//Function Number: 8
script_mover_move_to_named_goal(param_00)
{
	if(isdefined(level.script_mover_named_goals[param_00]))
	{
		self notify("new_path");
		self.goals = [level.script_mover_named_goals[param_00]];
		thread script_mover_move_to_target();
	}
}

//Function Number: 9
anglesclamp180(param_00)
{
	return (angleclamp180(param_00[0]),angleclamp180(param_00[1]),angleclamp180(param_00[2]));
}

//Function Number: 10
script_mover_parse_targets()
{
	if(isdefined(self.parsed) && self.parsed)
	{
		return;
	}

	self.parsed = 1;
	self.goals = [];
	self.movers = [];
	self.level_notify = [];
	var_00 = [];
	var_01 = [];
	if(isdefined(self.target))
	{
		var_00 = scripts\engine\utility::getstructarray(self.target,"targetname");
		var_01 = getentarray(self.target,"targetname");
	}

	for(var_02 = 0;var_02 < var_00.size;var_02++)
	{
		var_03 = var_00[var_02];
		if(!isdefined(var_03.script_noteworthy))
		{
			var_03.script_noteworthy = "goal";
		}

		switch(var_03.script_noteworthy)
		{
			case "ignore":
				if(isdefined(var_03.target))
				{
					var_04 = scripts\engine\utility::getstructarray(var_03.target,"targetname");
					foreach(var_06 in var_04)
					{
						var_00[var_00.size] = var_06;
					}
				}
				break;

			case "goal":
				var_03 script_mover_init_move_parameters();
				var_03 script_mover_parse_targets();
				self.goals[self.goals.size] = var_03;
				if(isdefined(var_03.params["name"]))
				{
					level.script_mover_named_goals[var_03.params["name"]] = var_03;
				}
				break;

			case "level_notify":
				if(isdefined(var_03.script_parameters))
				{
					self.level_notify[self.level_notify.size] = var_03;
				}
				break;

			default:
				break;
		}
	}

	foreach(var_09 in var_01)
	{
		if(var_09 script_mover_is_script_mover())
		{
			self.movers[self.movers.size] = var_09;
			continue;
		}

		if(!isdefined(var_09.script_noteworthy))
		{
			continue;
		}

		var_0A = strtok(var_09.script_noteworthy,"_");
		if(var_0A.size != 3 || var_0A[1] != "on")
		{
			continue;
		}

		switch(var_0A[0])
		{
			case "delete":
				thread script_mover_call_func_on_notify(var_09,::delete,var_0A[2]);
				break;

			case "hide":
				thread script_mover_call_func_on_notify(var_09,::hide,var_0A[2]);
				break;

			case "show":
				var_09 hide();
				thread script_mover_call_func_on_notify(var_09,::show,var_0A[2]);
				break;

			case "triggerHide":
			case "triggerhide":
				thread script_mover_func_on_notify(var_09,::scripts\engine\utility::trigger_off,var_0A[2]);
				break;

			case "triggerShow":
			case "triggershow":
				var_09 scripts\engine\utility::trigger_off();
				thread script_mover_func_on_notify(var_09,::scripts\engine\utility::trigger_on,var_0A[2]);
				break;

			default:
				break;
		}
	}
}

//Function Number: 11
script_mover_func_on_notify(param_00,param_01,param_02)
{
	self endon("death");
	param_00 endon("death");
	for(;;)
	{
		self waittill(param_02);
		param_00 [[ param_01 ]]();
	}
}

//Function Number: 12
script_mover_call_func_on_notify(param_00,param_01,param_02)
{
	self endon("death");
	param_00 endon("death");
	for(;;)
	{
		self waittill(param_02);
		param_00 [[ param_01 ]]();
	}
}

//Function Number: 13
script_mover_trigger_on()
{
	scripts\engine\utility::trigger_on();
}

//Function Number: 14
script_mover_move_to_target(param_00)
{
	self endon("death");
	self endon("new_path");
	if(!isdefined(param_00))
	{
		param_00 = self;
	}

	while(param_00.goals.size != 0)
	{
		var_01 = scripts\engine\utility::random(param_00.goals);
		var_02 = self;
		var_02 script_mover_apply_move_parameters(var_01);
		if(isdefined(var_02.params["delay_till"]))
		{
			level waittill(var_02.params["delay_till"]);
		}

		if(isdefined(var_02.params["delay_till_trigger"]) && var_02.params["delay_till_trigger"])
		{
			self waittill("trigger");
		}

		if(var_02.params["delay_time"] > 0)
		{
			wait(var_02.params["delay_time"]);
		}

		var_03 = var_02.params["move_time"];
		var_04 = var_02.params["accel_time"];
		var_05 = var_02.params["decel_time"];
		var_06 = 0;
		var_07 = 0;
		var_08 = transformmove(var_01.origin,var_01.angles,self.origin_ent.origin,self.origin_ent.angles,self.origin,self.angles);
		if(var_02.origin != var_01.origin)
		{
			if(isdefined(var_02.params["move_speed"]))
			{
				var_09 = distance(var_02.origin,var_01.origin);
				var_03 = var_09 / var_02.params["move_speed"];
			}

			if(isdefined(var_02.params["accel_frac"]))
			{
				var_04 = var_02.params["accel_frac"] * var_03;
			}

			if(isdefined(var_02.params["decel_frac"]))
			{
				var_05 = var_02.params["decel_frac"] * var_03;
			}

			var_02 moveto(var_08["origin"],var_03,var_04,var_05);
			foreach(var_0B in var_01.level_notify)
			{
				thread script_mover_run_notify(var_0B.origin,var_0B.script_parameters,self.origin,var_01.origin);
			}

			var_06 = 1;
		}

		if(anglesclamp180(var_08["angles"]) != anglesclamp180(var_02.angles))
		{
			var_02 rotateto(var_08["angles"],var_03,var_04,var_05);
			var_07 = 1;
		}

		foreach(var_0E in var_02.movers)
		{
			var_0E notify("trigger");
		}

		param_00 notify("depart");
		var_02 script_mover_allow_usable(0);
		self.moving = 1;
		if(isdefined(var_02.params["move_time_offset"]) && var_02.params["move_time_offset"] + var_03 > 0)
		{
			wait(var_02.params["move_time_offset"] + var_03);
		}
		else if(var_06)
		{
			self waittill("movedone");
		}
		else if(var_07)
		{
			self waittill("rotatedone");
		}
		else
		{
			wait(var_03);
		}

		self.moving = 0;
		self notify("move_end");
		var_01 notify("arrive");
		if(isdefined(var_02.params["solid"]))
		{
			if(var_02.params["solid"])
			{
				var_02 solid();
			}
			else
			{
				var_02 notsolid();
			}
		}

		foreach(var_0E in var_01.movers)
		{
			var_0E notify("trigger");
		}

		if(isdefined(var_02.params["wait_till"]))
		{
			level waittill(var_02.params["wait_till"]);
		}

		if(var_02.params["wait_time"] > 0)
		{
			wait(var_02.params["wait_time"]);
		}

		var_02 script_mover_allow_usable(1);
		param_00 = var_01;
	}
}

//Function Number: 15
script_mover_run_notify(param_00,param_01,param_02,param_03)
{
	self endon("move_end");
	var_04 = self;
	var_05 = vectornormalize(param_03 - param_02);
	for(;;)
	{
		var_06 = vectornormalize(param_00 - var_04.origin);
		if(vectordot(var_05,var_06) <= 0)
		{
			break;
		}

		wait(0.05);
	}

	level notify(param_01);
}

//Function Number: 16
script_mover_init_move_parameters()
{
	self.params = [];
	if(!isdefined(self.angles))
	{
		self.angles = (0,0,0);
	}

	self.angles = anglesclamp180(self.angles);
	script_mover_parse_move_parameters(self.script_parameters);
}

//Function Number: 17
script_mover_parse_move_parameters(param_00)
{
	if(!isdefined(param_00))
	{
		param_00 = "";
	}

	var_01 = strtok(param_00,";");
	foreach(var_03 in var_01)
	{
		var_04 = strtok(var_03,"=");
		if(var_04.size != 2)
		{
			continue;
		}

		if(var_04[1] == "undefined" || var_04[1] == "default")
		{
			self.params[var_04[0]] = undefined;
			continue;
		}

		switch(var_04[0])
		{
			case "move_time_offset":
			case "decel_frac":
			case "accel_frac":
			case "move_speed":
			case "delay_time":
			case "wait_time":
			case "decel_time":
			case "accel_time":
			case "move_time":
				self.params[var_04[0]] = script_mover_parse_range(var_04[1]);
				break;

			case "wait_till":
			case "delay_till":
			case "hintstring":
			case "name":
				self.params[var_04[0]] = var_04[1];
				break;

			case "delay_till_trigger":
			case "usable":
			case "solid":
				self.params[var_04[0]] = int(var_04[1]);
				break;

			case "script_params":
				var_05 = var_04[1];
				var_06 = level.script_mover_parameters[var_05];
				if(isdefined(var_06))
				{
					script_mover_parse_move_parameters(var_06);
				}
				break;

			default:
				break;
		}
	}
}

//Function Number: 18
script_mover_parse_range(param_00)
{
	var_01 = 0;
	var_02 = strtok(param_00,",");
	if(var_02.size == 1)
	{
		var_01 = float(var_02[0]);
	}
	else if(var_02.size == 2)
	{
		var_03 = float(var_02[0]);
		var_04 = float(var_02[1]);
		if(var_03 >= var_04)
		{
			var_01 = var_03;
		}
		else
		{
			var_01 = randomfloatrange(var_03,var_04);
		}
	}

	return var_01;
}

//Function Number: 19
script_mover_apply_move_parameters(param_00)
{
	foreach(var_03, var_02 in param_00.params)
	{
		script_mover_set_param(var_03,var_02);
	}

	script_mover_set_defaults();
}

//Function Number: 20
script_mover_set_param(param_00,param_01)
{
	if(!isdefined(param_00))
	{
		return;
	}

	if(param_00 == "usable" && isdefined(param_01))
	{
		script_mover_set_usable(self,param_01);
	}

	self.params[param_00] = param_01;
}

//Function Number: 21
script_mover_allow_usable(param_00)
{
	if(self.params["usable"])
	{
		script_mover_set_usable(self,param_00);
	}

	foreach(var_02 in self.use_triggers)
	{
		script_mover_set_usable(var_02,param_00);
	}
}

//Function Number: 22
script_mover_set_usable(param_00,param_01)
{
	if(param_01)
	{
		param_00 makeusable();
		param_00 setcursorhint("HINT_NOICON");
		param_00 sethintstring(level.script_mover_hintstrings[self.params["hintstring"]]);
		return;
	}

	param_00 makeunusable();
}

//Function Number: 23
script_mover_save_default_move_parameters()
{
	self.params_default = [];
	foreach(var_02, var_01 in self.params)
	{
		self.params_default[var_02] = var_01;
	}
}

//Function Number: 24
script_mover_set_defaults()
{
	foreach(var_02, var_01 in level.script_mover_defaults)
	{
		if(!isdefined(self.params[var_02]))
		{
			script_mover_set_param(var_02,var_01);
		}
	}

	if(isdefined(self.params_default))
	{
		foreach(var_02, var_01 in self.params_default)
		{
			if(!isdefined(self.params[var_02]))
			{
				script_mover_set_param(var_02,var_01);
			}
		}
	}
}

//Function Number: 25
init()
{
	level thread script_mover_agent_spawn_watch();
}

//Function Number: 26
script_mover_agent_spawn_watch()
{
	for(;;)
	{
		level waittill("spawned_agent",var_00);
		var_00 thread player_unresolved_collision_watch();
	}
}

//Function Number: 27
player_unresolved_collision_watch()
{
	self endon("disconnect");
	if(isagent(self))
	{
		self endon("death");
	}

	self.var_12BE5 = 0;
	for(;;)
	{
		self waittill("unresolved_collision",var_00);
		self.var_12BE5++;
		thread func_418E();
		var_01 = 3;
		if(isdefined(var_00) && isdefined(var_00.unresolved_collision_notify_min))
		{
			var_01 = var_00.unresolved_collision_notify_min;
		}

		if(self.var_12BE5 >= var_01)
		{
			if(isdefined(var_00))
			{
				if(isdefined(var_00.unresolved_collision_func))
				{
					var_00 [[ var_00.unresolved_collision_func ]](self);
				}
				else if(isdefined(var_00.unresolved_collision_kill) && var_00.unresolved_collision_kill)
				{
					var_00 unresolved_collision_owner_damage(self);
				}
				else
				{
					var_00 unresolved_collision_nearest_node(self);
				}
			}
			else
			{
				unresolved_collision_nearest_node(self);
			}

			self.var_12BE5 = 0;
		}
	}
}

//Function Number: 28
func_418E()
{
	self endon("unresolved_collision");
	scripts\engine\utility::waitframe();
	if(isdefined(self))
	{
		self.var_12BE5 = 0;
	}
}

//Function Number: 29
unresolved_collision_owner_damage(param_00)
{
	var_01 = self;
	if(!isdefined(var_01.triggerportableradarping))
	{
		param_00 mover_suicide();
		return;
	}

	var_02 = 0;
	if(level.teambased)
	{
		if(isdefined(var_01.triggerportableradarping.team) && var_01.triggerportableradarping.team != param_00.team)
		{
			var_02 = 1;
		}
	}
	else if(param_00 != var_01.triggerportableradarping)
	{
		var_02 = 1;
	}

	if(!var_02)
	{
		param_00 mover_suicide();
		return;
	}

	var_03 = 1000;
	if(isdefined(var_01.unresolved_collision_damage))
	{
		var_03 = var_01.unresolved_collision_damage;
	}

	param_00 dodamage(var_03,var_01.origin,var_01.triggerportableradarping,var_01,"MOD_CRUSH");
}

//Function Number: 30
unresolved_collision_nearest_node(param_00,param_01)
{
	if(isdefined(level.var_C81D))
	{
		self [[ level.var_C81D ]](param_00,param_01);
		return;
	}

	var_02 = self.unresolved_collision_nodes;
	if(isdefined(var_02))
	{
		var_02 = sortbydistance(var_02,param_00.origin);
	}
	else
	{
		var_02 = getnodesinradius(param_00.origin,300,0,200);
		var_02 = sortbydistance(var_02,param_00.origin);
	}

	var_03 = (0,0,-100);
	param_00 cancelmantle();
	param_00 dontinterpolate();
	param_00 setorigin(param_00.origin + var_03);
	for(var_04 = 0;var_04 < var_02.size;var_04++)
	{
		var_05 = var_02[var_04];
		var_06 = var_05.origin;
		if(!canspawn(var_06))
		{
			continue;
		}

		if(positionwouldtelefrag(var_06))
		{
			continue;
		}

		if(param_00 getstance() == "prone")
		{
			param_00 setstance("crouch");
		}

		param_00 setorigin(var_06);
		return;
	}

	param_00 setorigin(param_00.origin - var_03);
	if(!isdefined(param_01))
	{
		param_01 = 1;
	}

	if(param_01)
	{
		param_00 mover_suicide();
	}
}

//Function Number: 31
func_12BEE(param_00)
{
}

//Function Number: 32
mover_suicide()
{
	if(isdefined(level.var_9E36) && !isagent(self))
	{
		return;
	}

	scripts\cp\utility::_suicide();
}

//Function Number: 33
player_pushed_kill(param_00)
{
	self endon("death");
	self endon("stop_player_pushed_kill");
	for(;;)
	{
		self waittill("player_pushed",var_01,var_02);
		if(isplayer(var_01) || isagent(var_01))
		{
			var_03 = length(var_02);
			if(var_03 >= param_00)
			{
				unresolved_collision_owner_damage(var_01);
			}
		}
	}
}

//Function Number: 34
stop_player_pushed_kill()
{
	self notify("stop_player_pushed_kill");
}

//Function Number: 35
script_mover_get_top_parent()
{
	var_00 = self getlinkedparent();
	for(var_01 = var_00;isdefined(var_01);var_01 = var_01 getlinkedparent())
	{
		var_00 = var_01;
	}

	return var_00;
}

//Function Number: 36
script_mover_start_use(param_00)
{
	var_01 = param_00 script_mover_get_top_parent();
	if(isdefined(var_01))
	{
		var_01.startuseorigin = var_01.origin;
	}

	self.startusemover = self getmovingplatformparent();
	if(isdefined(self.startusemover))
	{
		var_02 = self.startusemover script_mover_get_top_parent();
		if(isdefined(var_02))
		{
			self.startusemover = var_02;
		}

		self.startusemover.startuseorigin = self.startusemover.origin;
	}
}

//Function Number: 37
script_mover_has_parent_moved(param_00)
{
	if(!isdefined(param_00))
	{
		return 0;
	}

	return lengthsquared(param_00.origin - param_00.startuseorigin) > 0.001;
}

//Function Number: 38
script_mover_use_can_link(param_00)
{
	if(!isplayer(self))
	{
		return 1;
	}

	if(!isdefined(param_00))
	{
		return 0;
	}

	var_01 = param_00 script_mover_get_top_parent();
	var_02 = self.startusemover;
	if(!isdefined(var_01) && !isdefined(var_02))
	{
		return 1;
	}

	if(isdefined(var_01) && isdefined(var_02) && var_01 == var_02)
	{
		return 1;
	}

	if(script_mover_has_parent_moved(var_01))
	{
		return 0;
	}

	if(script_mover_has_parent_moved(var_02))
	{
		return 0;
	}

	return 1;
}

//Function Number: 39
script_mover_link_to_use_object(param_00)
{
	if(isplayer(param_00))
	{
		param_00 script_mover_start_use(self);
		var_01 = param_00 getmovingplatformparent();
		var_02 = undefined;
		if(isdefined(var_01))
		{
			var_02 = var_01;
		}
		else if(!isdefined(script_mover_get_top_parent()))
		{
			var_02 = self;
		}
		else
		{
			var_02 = spawn("script_model",param_00.origin);
			var_02 setmodel("tag_origin");
			param_00.var_EF85 = var_02;
			param_00 thread func_EC11(var_02);
		}

		param_00 playerlinkto(var_02);
	}
	else
	{
		param_00 linkto(self);
	}

	param_00 playerlinkedoffsetenable();
}

//Function Number: 40
script_mover_unlink_from_use_object(param_00)
{
	param_00 unlink();
	if(isdefined(param_00.var_EF85))
	{
		param_00 notify("removeMoverLinkDummy");
		param_00.var_EF85 delete();
		param_00.var_EF85 = undefined;
	}
}

//Function Number: 41
func_EC11(param_00)
{
	self endon("removeMoverLinkDummy");
	scripts\engine\utility::waittill_any_3("death","disconnect");
	self.var_EF85 delete();
	self.var_EF85 = undefined;
}

//Function Number: 42
notify_moving_platform_invalid()
{
	var_00 = self getlinkedchildren(0);
	if(!isdefined(var_00))
	{
		return;
	}

	foreach(var_02 in var_00)
	{
		if(isdefined(var_02.no_moving_platfrom_unlink) && var_02.no_moving_platfrom_unlink)
		{
			continue;
		}

		var_02 unlink();
		var_02 notify("invalid_parent",self);
	}
}

//Function Number: 43
process_moving_platform_death(param_00,param_01)
{
	if(isdefined(param_01) && isdefined(param_01.no_moving_platfrom_death) && param_01.no_moving_platfrom_death)
	{
		return;
	}

	if(isdefined(param_00.playdeathfx))
	{
		playfx(scripts\engine\utility::getfx("airdrop_crate_destroy"),self.origin);
	}

	if(isdefined(param_00.deathoverridecallback))
	{
		param_00.lasttouchedplatform = param_01;
		self thread [[ param_00.deathoverridecallback ]](param_00);
		return;
	}

	self delete();
}

//Function Number: 44
handle_moving_platform_touch(param_00)
{
	self notify("handle_moving_platform_touch");
	self endon("handle_moving_platform_touch");
	level endon("game_ended");
	self endon("death");
	self endon("stop_handling_moving_platforms");
	if(isdefined(param_00.endonstring))
	{
		self endon(param_00.endonstring);
	}

	for(;;)
	{
		self waittill("touching_platform",var_01);
		if(isdefined(param_00.var_13139) && param_00.var_13139)
		{
			if(!self istouching(var_01))
			{
				wait(0.05);
				continue;
			}
		}

		thread process_moving_platform_death(param_00,var_01);
		break;
	}
}

//Function Number: 45
handle_moving_platform_invalid(param_00)
{
	self notify("handle_moving_platform_invalid");
	self endon("handle_moving_platform_invalid");
	level endon("game_ended");
	self endon("death");
	self endon("stop_handling_moving_platforms");
	if(isdefined(param_00.endonstring))
	{
		self endon(param_00.endonstring);
	}

	self waittill("invalid_parent",var_01);
	if(isdefined(param_00.invalidparentoverridecallback))
	{
		self thread [[ param_00.invalidparentoverridecallback ]](param_00);
		return;
	}

	thread process_moving_platform_death(param_00,var_01);
}

//Function Number: 46
handle_moving_platforms(param_00)
{
	self notify("handle_moving_platforms");
	self endon("handle_moving_platforms");
	level endon("game_ended");
	self endon("death");
	self endon("stop_handling_moving_platforms");
	if(!isdefined(param_00))
	{
		param_00 = spawnstruct();
	}

	if(isdefined(param_00.endonstring))
	{
		self endon(param_00.endonstring);
	}

	if(isdefined(param_00.linkparent))
	{
		var_01 = self getlinkedparent();
		if(!isdefined(var_01) || var_01 != param_00.linkparent)
		{
			self linkto(param_00.linkparent);
		}
	}

	thread handle_moving_platform_touch(param_00);
	thread handle_moving_platform_invalid(param_00);
}

//Function Number: 47
stop_handling_moving_platforms()
{
	self notify("stop_handling_moving_platforms");
}

//Function Number: 48
moving_platform_empty_func(param_00)
{
}