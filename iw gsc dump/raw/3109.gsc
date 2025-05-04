/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 3109.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 28
 * Decompile Time: 7 ms
 * Timestamp: 10/27/2023 12:26:08 AM
*******************************************************************/

//Function Number: 1
func_98CA(param_00)
{
	if(isdefined(self.bt.var_9882))
	{
		return level.success;
	}

	self.bt.var_F15D = undefined;
	self.bt.var_1152B = 0;
	self.bt.var_1154B = 0;
	self.asm.var_7360 = 0;
	self.asm.var_4C86 = spawnstruct();
	self.asm.footsteps = spawnstruct();
	self.asm.footsteps.foot = "invalid";
	self.asm.footsteps.time = 0;
	self.bt.var_54AE = 0;
	lib_0A10::func_F13B(param_00);
	thread func_AC76();
	thread damage_monitor();
	thread func_F16F();
	thread func_6744();
	thread func_EB63();
	thread func_13940();
	self give_zombies_perk("equipment");
	return level.success;
}

//Function Number: 2
func_6744()
{
	while(!isdefined(self.triggerportableradarping))
	{
		wait(0.05);
	}

	if(self.team == "allies")
	{
		self.bt.var_652A = "axis";
	}
	else if(self.team == "team3" && isdefined(self.var_C93D))
	{
		self.bt.var_652A = "team3";
	}
	else
	{
		self.bt.var_652A = "allies";
	}

	self.bt.var_F15D = self.triggerportableradarping;
	self.bt.var_9882 = 1;
}

//Function Number: 3
func_AC76()
{
	if(isdefined(self.bt.var_AC75))
	{
		return;
	}

	self endon("death");
	self.bt.var_AC75 = 40;
	var_00 = 2;
	var_01 = 0;
	while(var_01 != var_00)
	{
		wait(self.bt.var_AC75);
		if(isdefined(self.var_595E))
		{
			wait(5);
			continue;
		}

		if(func_9B71())
		{
			self.bt.var_AC75 = self.bt.var_AC75 * 0.5;
			var_01++;
			continue;
		}
		else
		{
			break;
		}
	}

	thread func_EA0E();
}

//Function Number: 4
damage_monitor()
{
	if(isdefined(self.damage_monitor))
	{
		return;
	}

	self.damage_monitor = 1;
	self endon("death");
	for(;;)
	{
		self waittill("damage",var_00,var_01,var_02,var_03,var_04,var_05,var_06,var_07,var_08,var_09);
		if(isdefined(var_01) && var_01 == self)
		{
			return;
		}

		if(isdefined(self.var_9BB9))
		{
			return;
		}

		if(isdefined(var_01) && var_01 func_9CB7())
		{
			self notify("force_detonate");
			return;
		}
	}
}

//Function Number: 5
func_F16F()
{
	self waittill("death");
	level.var_F10A.var_1633 = scripts\engine\utility::array_remove(level.var_F10A.var_1633,self);
	lib_0E46::func_DFE3();
	if(isdefined(self.var_9BB9) || isdefined(self.var_EA0E))
	{
		return;
	}

	lib_0E26::func_F11E(1);
}

//Function Number: 6
func_9B71()
{
	if(self.bt.var_F15D != self.triggerportableradarping && distancesquared(self.origin,self.bt.var_F15D.origin) < 640000 && self.var_164D["seeker"].var_4BC0 == "run_loop")
	{
		return 1;
	}

	return 0;
}

//Function Number: 7
func_EA0E()
{
	self.var_EA0E = 1;
	stopfxontag(level.var_7649[self.var_F166],self,"tag_fx");
	self _meth_8484();
	self _meth_8481(self.origin);
	if(isdefined(self.var_B14F))
	{
		scripts\sp\_utility::func_1101B();
	}

	playfxontag(level.var_7649["seeker_sparks"],self,"tag_fx");
	function_0178("seeker_expire",self.origin);
	function_0278("ent_" + self getentitynumber() + "_seeker_repulsor");
	self hudoutlinedisable();
	self _meth_81D0();
}

//Function Number: 8
func_EB63()
{
	self endon("death");
	for(;;)
	{
		if(isdefined(self.bt.var_F15D) && self.bt.var_F15D != self.triggerportableradarping && isdefined(self.vehicle_getspawnerarray))
		{
			self.var_A9CB = self.vehicle_getspawnerarray;
		}

		wait(0.25);
	}
}

//Function Number: 9
func_13940()
{
	self endon("death");
	for(;;)
	{
		self waittill("bad_path");
		if(isdefined(self.bt.var_F15D) && self.bt.var_F15D != self.triggerportableradarping)
		{
			if(isdefined(self.var_728A) || isplayer(self.bt.var_F15D))
			{
				if(isdefined(self.var_A9CB))
				{
					self._meth_8425 = 1;
					self _meth_8481(self.var_A9CB);
					wait(2);
					self._meth_8425 = undefined;
				}

				continue;
			}

			clear_scripted_anim(1);
		}
	}
}

//Function Number: 10
func_1572(param_00)
{
	if(!isdefined(self.bt.var_9882))
	{
		return level.failure;
	}

	if(isdefined(self.var_EA0E) || isdefined(self.var_C93D) || isdefined(self.var_9BB9) || isdefined(self.var_50EB))
	{
		return level.success;
	}

	if(isdefined(self.bt.var_F15D) && !isdefined(self.var_728A))
	{
		if(!isalive(self.bt.var_F15D) || self.bt.var_F15D.ignoreme || isdefined(self.bt.var_F15D.var_C012))
		{
			clear_scripted_anim(0);
		}
	}

	if(!self.bt.var_1152B)
	{
		var_01 = !isdefined(self.bt.var_F15D) || self.bt.var_F15D == self.triggerportableradarping;
		var_02 = lib_0E26::func_7C41(!var_01);
		if(isdefined(var_02) && var_02 != self.triggerportableradarping)
		{
			func_DED7(var_02);
		}
	}

	_meth_8420();
	if(isdefined(self.bt.var_F15D) && self.bt.var_F15D != self.triggerportableradarping && !isdefined(self.var_9BB9) && !self.bt.var_54AE)
	{
		self.bt.var_54AE = 1;
		self notify("stop soundseeker_seek_lp");
		function_0178("seeker_acquire_target",self.origin);
		if(self.var_2A4B)
		{
			thread func_CE01();
		}
	}

	return level.success;
}

//Function Number: 11
func_CE01()
{
	self endon("death");
	self endon("stop soundseeker_target_acquire_lp");
	wait(0.5);
	thread scripts\sp\_utility::play_loop_sound_on_entity_with_pitch("seeker_target_acquire_lp",undefined,3,18);
}

//Function Number: 12
func_F177(param_00)
{
	if(isdefined(self.var_55B1) && self.var_55B1)
	{
		return level.failure;
	}

	if(isdefined(self.var_9BB9) || isdefined(self.var_C93D) || isdefined(self.var_50EB))
	{
		return level.failure;
	}

	if(self.bt.var_F15D == self.triggerportableradarping)
	{
		return level.failure;
	}

	if(isdefined(self._meth_8425) || isdefined(self.var_391C))
	{
		return level.failure;
	}

	if(isdefined(self.bt.var_F15D.unittype))
	{
		var_01 = 0;
		switch(self.bt.var_F15D.unittype)
		{
			case "soldier":
			case "civilian":
			case "c6":
				var_01 = 1;
				break;
		}

		if(!var_01)
		{
			return level.failure;
		}
	}

	if(issubstr(self.bt.var_F15D.classname,"worker"))
	{
		return level.failure;
	}

	return scripts/aitypes/melee::shouldmelee(param_00,self.bt.var_F15D);
}

//Function Number: 13
func_13850(param_00)
{
	if(!isalive(self.bt.var_F15D))
	{
		if(isplayer(self.bt.var_F15D))
		{
			self _meth_8481(self.origin);
		}

		return level.failure;
	}

	if(isdefined(self.var_EA0E))
	{
		return level.success;
	}

	var_01 = distancesquared(self.origin,self.bt.var_F15D.origin);
	if(isdefined(self._meth_8425) && isdefined(self.var_A9CB))
	{
		var_01 = distancesquared(self.origin,self.var_A9CB);
	}
	else if(isdefined(self.var_391C) && isdefined(self.var_7296))
	{
		var_01 = distancesquared(self.origin,self.var_7296);
	}

	var_02 = 72;
	if(isplayer(self.bt.var_F15D))
	{
		var_02 = 25;
	}

	if(var_01 <= squared(var_02))
	{
		self _meth_8484();
		self _meth_8481(self.origin);
		return level.success;
	}
	else
	{
		_meth_8420();
	}

	return level.running;
}

//Function Number: 14
func_2BD3(param_00)
{
	if(isdefined(self.var_55B1) && self.var_55B1)
	{
		return level.failure;
	}

	if(self.bt.var_F15D == self.triggerportableradarping)
	{
		return level.failure;
	}

	if(isdefined(self.melee))
	{
		return level.failure;
	}

	if(isdefined(self.var_9BB9) || isdefined(self.var_C93D) || isdefined(self.var_50EB))
	{
		return level.failure;
	}

	thread lib_0E26::func_F11C();
	return level.running;
}

//Function Number: 15
_meth_8420()
{
	if(isdefined(self.var_EA0E) || isdefined(self.var_C93D))
	{
		return;
	}

	if(isplayer(self.bt.var_F15D))
	{
		if(self.bt.var_F15D == self.triggerportableradarping)
		{
			self.var_6D = 120;
		}
		else
		{
			self.var_6D = 13;
		}
	}
	else if(isdefined(self.bt.var_F15D) && self.bt.var_F15D == self.triggerportableradarping)
	{
		self.var_6D = 120;
	}
	else
	{
		self.var_6D = 60;
	}

	if(isdefined(self._meth_8425))
	{
		return;
	}

	if(isdefined(self.bt.var_F15D))
	{
		var_00 = getclosestpointonnavmesh(self.bt.var_F15D.origin,self);
		var_01 = distancesquared(var_00,self.bt.var_F15D.origin);
		if(var_01 <= squared(12))
		{
			self.var_391C = undefined;
			self.var_7296 = undefined;
			self _meth_8482(self.bt.var_F15D);
			return;
		}

		self.var_391C = 1;
		self.var_7296 = var_00;
		self _meth_8481(self.var_7296);
	}
}

//Function Number: 16
func_2295(param_00)
{
	return param_00.size > 0;
}

//Function Number: 17
func_CBC1()
{
	self.var_CBA0.var_1169D = [];
	self.var_CBA0.var_1169D["top"] = level.player func_CBA9();
	self.var_CBA0.var_1169D["bottom"] = level.player func_CBA9();
	self.var_CBA0.var_1169D["top"].x = 590;
	self.var_CBA0.var_1169D["top"].y = 21;
	self.var_CBA0.var_1169D["top"].font = "default";
	self.var_CBA0.var_1169D["top"].var_7253 = 0.2;
	self.var_CBA0.var_1169D["top"] settext("Seeker Online");
	self.var_CBA0.var_1169D["bottom"].x = 602;
	self.var_CBA0.var_1169D["bottom"].y = 165;
	self.var_CBA0.var_1169D["bottom"].font = "default";
	self.var_CBA0.var_1169D["bottom"].var_7253 = 0.2;
	self.var_CBA0.var_1169D["bottom"] settext("Target Acquired");
}

//Function Number: 18
func_CBA9()
{
	var_00 = newhudelem();
	var_00.x = 0;
	var_00.y = 0;
	var_00.alignx = "right";
	var_00.aligny = "top";
	var_00.sort = 10;
	var_00.foreground = 0;
	var_00.horzalign = "fullscreen";
	var_00.vertalign = "fullscreen";
	var_00.alpha = 1;
	return var_00;
}

//Function Number: 19
func_E098(param_00,param_01)
{
	param_00 endon("new_bt_target");
	param_00 scripts\sp\_utility::func_178D(::scripts\sp\_utility::func_137AA,"death");
	param_01 scripts\sp\_utility::func_178D(::scripts\sp\_utility::func_137AA,"death");
	param_01 scripts\sp\_utility::func_178D(::scripts\sp\_utility::func_137AA,"start_context_melee");
	scripts\sp\_utility::func_57D6();
	level.var_F10A.targets = scripts\engine\utility::array_remove(level.var_F10A.targets,param_01);
}

//Function Number: 20
func_F15F(param_00)
{
	if(scripts\engine\utility::array_contains(level.var_F10A.targets,param_00))
	{
		return 0;
	}

	return 1;
}

//Function Number: 21
func_DED7(param_00)
{
	if(isdefined(self.var_9BB9) || isdefined(self.var_EA0E) || isdefined(self.var_50EB))
	{
		return;
	}

	if(isdefined(self.bt.var_F15D) && self.bt.var_F15D == param_00)
	{
		return;
	}

	if(isdefined(self.bt.var_F15D) && self.bt.var_F15D != param_00 && scripts\engine\utility::array_contains(level.var_F10A.targets,self.bt.var_F15D))
	{
		clear_scripted_anim(0);
	}

	level.var_F10A.targets[level.var_F10A.targets.size] = param_00;
	self.loadstartpointtransients = param_00;
	self.bt.var_F15D = param_00;
	self.bt.var_1154B = gettime();
	param_00.var_F126 = self;
	self notify("set_bt_target");
	if(isai(param_00) && isdefined(self.triggerportableradarping) && isplayer(self.triggerportableradarping))
	{
		thread func_F120(param_00);
	}

	level thread func_E098(self,param_00);
}

//Function Number: 22
clear_scripted_anim(param_00)
{
	self notify("new_bt_target");
	self.bt.var_F15D notify("seeker_stop_outline");
	self notify("stop soundseeker_target_acquire_lp");
	if(param_00)
	{
		self.var_2745 = scripts\engine\utility::array_add(self.var_2745,self.bt.var_F15D);
	}

	level.var_F10A.targets = scripts\engine\utility::array_remove(level.var_F10A.targets,self.bt.var_F15D);
	if(isalive(self.triggerportableradarping))
	{
		self.bt.var_F15D = self.triggerportableradarping;
	}
	else
	{
		self.bt.var_F15D = undefined;
	}

	self.bt.var_1152B = 0;
	self.loadstartpointtransients = undefined;
	self.bt.var_1154B = 0;
	self.bt.var_54AE = 0;
}

//Function Number: 23
func_F120(param_00)
{
	param_00 endon("death");
	param_00 endon("seeker_stop_outline");
	self endon("meleegrab_start");
	self endon("death");
	thread func_F123(param_00);
	thread func_F125(param_00);
	thread func_F124(param_00);
	wait(0.25);
	param_00 scripts\sp\_utility::func_9196(1,0,1,"default_seeker");
	wait(0.15);
	param_00 scripts\sp\_utility::func_9193("default_seeker");
	wait(0.1);
	param_00 scripts\sp\_utility::func_9196(1,0,1,"default_seeker");
	wait(0.15);
	param_00 scripts\sp\_utility::func_9193("default_seeker");
	wait(0.1);
	param_00 scripts\sp\_utility::func_9196(1,0,1,"default_seeker");
	wait(0.15);
	param_00 scripts\sp\_utility::func_9193("default_seeker");
	wait(0.1);
	param_00 scripts\sp\_utility::func_9196(1,0,1,"default_seeker");
}

//Function Number: 24
func_F123(param_00)
{
	param_00 scripts\engine\utility::waittill_either("death","seeker_stop_outline");
	param_00 scripts\sp\_utility::func_9193("default_seeker");
}

//Function Number: 25
func_F125(param_00)
{
	param_00 endon("death");
	self endon("new_bt_target");
	self waittill("death");
	param_00 notify("seeker_stop_outline");
	param_00 scripts\sp\_utility::func_9193("default_seeker");
}

//Function Number: 26
func_F124(param_00)
{
	param_00 endon("death");
	self endon("death");
	self endon("new_bt_target");
	self waittill("meleegrab_start");
	waittillframeend;
	param_00 scripts\sp\_utility::func_9196(1,0,0,"default_seeker");
	scripts\sp\_utility::func_9196(3,0,0,"default_seeker");
}

//Function Number: 27
func_9CB7()
{
	return isdefined(self.asmname) && self.asmname == "seeker";
}

//Function Number: 28
func_4F0B(param_00)
{
}