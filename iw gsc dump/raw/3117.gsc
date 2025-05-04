/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 3117.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 47
 * Decompile Time: 18 ms
 * Timestamp: 10/27/2023 12:26:09 AM
*******************************************************************/

//Function Number: 1
initzombieghost(param_00)
{
	self.bisghost = 1;
	self.animplaybackrate = 1;
	self.currentanimstate = undefined;
	self.currentanimindex = undefined;
	self gib_fx_override("noclip");
	self ghostskulls_total_waves(99999999);
	self scragentsetscripted(1);
	setghostnavmode("hover");
	thread scripts/asm/zombie_ghost/zombie_ghost_asm::zombieghost_constantanglesadjust();
	return level.success;
}

//Function Number: 2
ghostlaunched(param_00)
{
	if(getghostnavmode() == "launched")
	{
		if(ghostshouldexplode(self))
		{
			ghostexplode(self,self.player_entangled_by,getghostdetonateexplosionrange());
		}

		return level.running;
	}

	return level.failure;
}

//Function Number: 3
ghostentangled(param_00)
{
	if(getghostnavmode() == "entangled")
	{
		if(isdefined(self.player_entangled_by) && !scripts\cp\cp_laststand::player_in_laststand(self.player_entangled_by) && self.player_entangled_by attackbuttonpressed())
		{
			var_01 = self.player_entangled_by;
			var_02 = anglestoforward(self.player_entangled_by getplayerangles());
			var_03 = var_01.origin + (0,0,5);
			var_04 = var_03 + var_02 * get_ghost_entangled_dist_from_player();
			var_05 = bullettrace(var_03,var_04,0,var_01)["position"];
			if(distancesquared(self.origin,var_05) < 360000)
			{
				var_06 = var_05;
			}
			else
			{
				var_07 = vectornormalize(var_06 - self.origin);
				var_06 = self.origin + var_07 * 600;
			}

			self setorigin(var_06,0);
			self.ghost_target_position = var_01.origin;
			scripts\cp\maps\cp_zmb\cp_zmb_ghost_wave::update_entangler_progress(var_01,self);
			return level.success;
		}
		else
		{
			launchedawayfromplayer(self);
			return level.running;
		}
	}

	return level.failure;
}

//Function Number: 4
get_ghost_entangled_dist_from_player()
{
	return 175;
}

//Function Number: 5
ghosthover(param_00)
{
	if(getghostnavmode() == "hover")
	{
		clearhidenode();
		scripts/asm/asm_bb::bb_requestmovetype("fly");
		if(!isdefined(self.ghost_hover_node))
		{
			self.ghost_hover_node = scripts\engine\utility::getclosest(self.origin,level.zombie_ghost_hover_nodes);
			self.ghost_target_position = self.ghost_hover_node.origin;
			return level.success;
		}

		if(distancesquared(self.ghost_hover_node.origin,self.origin) < 4096)
		{
			self notify("ghost_reached_hover_node");
			var_01 = scripts\engine\utility::array_remove(level.zombie_ghost_hover_nodes,self.ghost_hover_node);
			var_02 = getaliveenemies();
			if(var_02.size > 0)
			{
				var_03 = scripts\engine\utility::random(var_02).origin;
			}
			else
			{
				var_03 = self.origin;
			}

			self.ghost_hover_node = getrandomhovernodesaroundtargetpos(var_03,var_01);
			self.ghost_target_position = self.ghost_hover_node.origin;
		}

		return level.success;
	}

	return level.failure;
}

//Function Number: 6
ghosthide(param_00)
{
	if(getghostnavmode() == "hide")
	{
		clearhovernode();
		scripts/asm/asm_bb::bb_requestmovetype("fly");
		if(!isdefined(self.ghost_hide_node))
		{
			self.ghost_hide_node = scripts\engine\utility::getclosest(self.origin,level.zombie_ghost_hide_nodes);
			self.ghost_target_position = self.ghost_hide_node.origin;
			return level.success;
		}

		if(distancesquared(self.ghost_hide_node.origin,self.origin) < 1024)
		{
			self notify("ghost_reached_hide_node");
			self.ghost_hide_node = scripts\engine\utility::getstruct(self.ghost_hide_node.target,"targetname");
			self.ghost_target_position = self.ghost_hide_node.origin;
		}

		return level.success;
	}

	return level.failure;
}

//Function Number: 7
checkattack(param_00)
{
	scripts/asm/asm_bb::bb_clearmeleerequest();
	if(!getghostnavmode() == "attack")
	{
		return level.failure;
	}

	if(self.precacheleaderboards)
	{
		return level.failure;
	}

	if(!isdefined(self.zombie_ghost_target))
	{
		return level.failure;
	}

	if(!scripts\cp\utility::isreallyalive(self.zombie_ghost_target))
	{
		return level.failure;
	}

	if(isdefined(self.zombie_ghost_target.ignoreme) && self.zombie_ghost_target.ignoreme == 1)
	{
		return level.failure;
	}

	if(self.aistate == "melee" || scripts\mp\agents\_scriptedagents::isstatelocked())
	{
		return level.failure;
	}

	if(distancesquared(self.zombie_ghost_target.origin,self.origin) > 9216)
	{
		return level.failure;
	}

	scripts/asm/asm_bb::bb_requestmelee(self.zombie_ghost_target);
	return level.failure;
}

//Function Number: 8
chaseenemy(param_00)
{
	if(!getghostnavmode() == "attack")
	{
		return level.failure;
	}

	if(self.precacheleaderboards)
	{
		self.curmeleetarget = undefined;
		return level.failure;
	}

	if(!isdefined(self.zombie_ghost_target))
	{
		return level.failure;
	}

	if(distancesquared(self.zombie_ghost_target.origin,self.origin) > 147456)
	{
		return level.failure;
	}

	self.ghost_target_position = self.zombie_ghost_target.origin;
	try_request_fly_type();
	return level.success;
}

//Function Number: 9
seekenemy(param_00)
{
	if(!getghostnavmode() == "attack")
	{
		return level.failure;
	}

	if(isdefined(self.dontseekenemies))
	{
		return level.failure;
	}

	if(!isdefined(self.zombie_ghost_target))
	{
		return level.failure;
	}

	self.ghost_target_position = self.zombie_ghost_target.origin;
	try_request_fly_type(1024);
	return level.failure;
}

//Function Number: 10
ghostattack(param_00)
{
	var_01 = self;
	var_01 endon("death");
	var_01 endon("ghost_stop_attack");
	level endon("game_ended");
	var_01 ghostattack_internal(param_00);
	var_02 = get_min_num_of_attacks();
	var_03 = get_max_num_of_attacks();
	var_04 = randomintrange(get_min_num_of_attacks(),get_max_num_of_attacks() + 1);
	for(var_05 = 0;var_05 < var_04;var_05++)
	{
		var_01 waittill("ghost_played_melee_anim");
	}

	if(isdefined(param_00))
	{
		param_00.var_C1F5--;
	}

	var_01 scripts/asm/asm_bb::bb_clearmeleerequest();
	var_01 clearhovernode();
	var_01 setghostnavmode("hover");
	var_01 waittill("ghost_reached_hover_node");
	var_01 updateghostanimplaybackrate(1);
}

//Function Number: 11
get_min_num_of_attacks()
{
	return 1;
}

//Function Number: 12
get_max_num_of_attacks()
{
	return 1;
}

//Function Number: 13
ghostattack_internal(param_00)
{
	setghosttarget(param_00);
	setghostnavmode("attack");
	updateghostanimplaybackrate(2.5);
}

//Function Number: 14
setghosttarget(param_00)
{
	self.zombie_ghost_target = param_00;
	self.ghost_target_position = param_00.origin;
}

//Function Number: 15
getaliveenemies()
{
	var_00 = [];
	foreach(var_02 in level.players)
	{
		if(var_02.ignoreme || isdefined(var_02.triggerportableradarping) && var_02.triggerportableradarping.ignoreme)
		{
			continue;
		}

		if(scripts/mp/agents/zombie/zombie_util::shouldignoreent(var_02))
		{
			continue;
		}

		if(!isalive(var_02))
		{
			continue;
		}

		var_00[var_00.size] = var_02;
	}

	return var_00;
}

//Function Number: 16
try_request_fly_type(param_00)
{
	if(!isdefined(param_00))
	{
		param_00 = 1;
	}

	if(isdefined(self.ghost_target_position) && distancesquared(self.ghost_target_position,self.origin) > param_00)
	{
		scripts/asm/asm_bb::bb_requestmovetype("fly");
		return;
	}

	scripts/asm/asm_bb::bb_requestmovetype("");
}

//Function Number: 17
entangleghost(param_00,param_01)
{
	param_00 notify("ghost_stop_attack");
	param_01.ghost_in_entanglement = param_00;
	param_00.player_entangled_by = param_01;
	param_00 setisentangled(param_00,1);
	param_00 setghostnavmode("entangled");
	param_00 clearhidenode();
	param_00 clearhovernode();
	param_00 updateghostanimplaybackrate(1);
	param_00 scripts/asm/asm_bb::bb_requestmovetype("entangled");
	param_00 scripts/asm/asm_bb::bb_clearmeleerequest();
	param_00 setmisttrailscriptable("off",param_00);
	if(isdefined(level.fbd) && isdefined(level.fbd.fightstarted) && level.fbd.fightstarted)
	{
		param_00 setscriptablepartstate("soul","captured");
	}
}

//Function Number: 18
escapefromentanglement(param_00)
{
	param_00 updateghostanimplaybackrate(1);
	param_00 setisentangled(param_00,0);
	param_00 setghostnavmode("hover");
	param_00 scripts/asm/asm_bb::bb_requestmovetype("fly");
	param_00 setbeingentangledscriptable("off",param_00);
	param_00 setmisttrailscriptable("active",param_00);
}

//Function Number: 19
launchedawayfromplayer(param_00)
{
	level thread launchfakeghost(param_00.origin,param_00.angles,param_00.color,param_00.player_entangled_by);
	param_00.nocorpse = 1;
	param_00 suicide();
}

//Function Number: 20
launchfakeghost(param_00,param_01,param_02,param_03)
{
	level endon("game_ended");
	param_03 endon("disconnect");
	param_03.ghost_in_entanglement = undefined;
	var_04 = spawn("script_model",param_00);
	var_04.angles = vectortoangles(param_01);
	var_04.color = get_fake_ghost_color(param_02);
	var_04 setmodel(get_fake_ghost_model(var_04.color));
	var_04 setscriptablepartstate("animation","on");
	if(isdefined(param_03))
	{
		var_05 = anglestoforward(param_03 getplayerangles());
	}
	else
	{
		var_05 = (0,0,1);
	}

	var_05 = var_05 * 9000;
	var_04 physicslaunchserver(var_04.origin,var_05);
	var_04 physics_registerforcollisioncallback();
	if(isdefined(level.fbd) && isdefined(level.fbd.fightstarted) && level.fbd.fightstarted)
	{
		thread [[ level.fbd.soulprojectilemonitorfunc ]](var_04,param_03);
		thread [[ level.fbd.soulprojectiledeathfunc ]](var_04);
	}

	var_04 thread physics_callback_monitor(var_04,param_03);
}

//Function Number: 21
get_fake_ghost_color(param_00)
{
	return param_00;
}

//Function Number: 22
get_fake_ghost_model(param_00)
{
	if(isdefined(level.get_fake_ghost_model_func))
	{
		return [[ level.get_fake_ghost_model_func ]](param_00);
	}

	return "fake_zombie_ghost_" + param_00;
}

//Function Number: 23
physics_callback_monitor(param_00,param_01)
{
	param_00 endon("death");
	param_00 waittill("collision",var_02,var_03,var_04,var_05,var_06,var_07,var_08,var_09);
	if(isdefined(level.fbd) && isdefined(level.fbd.fightstarted) && level.fbd.fightstarted)
	{
		var_0A = param_00 gettagorigin("j_spine4");
		playfx(level._effect["flying_soul_hit_fail"],var_0A,anglestoforward(param_00.angles),anglestoup(param_00.angles));
	}

	fake_ghost_explode(param_00,param_01,getghostimpactexplosionrange());
}

//Function Number: 24
fake_ghost_explode(param_00,param_01,param_02)
{
	if(isdefined(level.fbd) && isdefined(level.fbd.fightstarted) && level.fbd.fightstarted)
	{
		param_00 delete();
		return;
	}

	ghostexplosionradiusdamage(param_00,param_01,param_02);
	playfx(level._effect["ghost_explosion_death_" + get_exp_vfx_color(param_00.color)],param_00.origin,anglestoforward(param_00.angles),anglestoup(param_00.angles));
	param_00 setscriptablepartstate("animation","off");
	param_00 delete();
}

//Function Number: 25
get_exp_vfx_color(param_00)
{
	if(issubstr(param_00,"bomb"))
	{
		return strtok(param_00,"_")[0];
	}

	return param_00;
}

//Function Number: 26
ghostshouldexplode(param_00)
{
	if(isdefined(param_00.player_entangled_by) && param_00.player_entangled_by secondaryoffhandbuttonpressed())
	{
		return 1;
	}

	if(gettime() - param_00.start_being_launched > 5000)
	{
		return 1;
	}

	return 0;
}

//Function Number: 27
ghostexplode(param_00,param_01,param_02)
{
	playghostexplosionvfx(param_00);
	ghostexplosionradiusdamage(param_00,param_01,param_02);
	param_00.nocorpse = 1;
	param_00 suicide();
}

//Function Number: 28
ghostexplosionradiusdamage(param_00,param_01,param_02)
{
	var_03 = getclosestactivemovingtargetwithinrange(param_00,param_02);
	if(isplayer(param_01))
	{
		if(isdefined(var_03))
		{
			param_01 thread scripts\cp\cp_damage::updatedamagefeedback("hitcritical");
			if([[ level.should_moving_target_explode ]](param_00,var_03))
			{
				if(isdefined(level.process_player_gns_combo_func))
				{
					[[ level.process_player_gns_combo_func ]](param_01,var_03);
				}

				process_moving_target_hit(var_03,param_01,param_00);
				return;
			}

			if(isdefined(level.hit_wrong_moving_target_func))
			{
				[[ level.hit_wrong_moving_target_func ]](param_01,var_03,param_00);
				return;
			}

			return;
		}

		if(isdefined(level.process_player_gns_combo_func))
		{
			[[ level.process_player_gns_combo_func ]](param_01,var_03);
			return;
		}
	}
}

//Function Number: 29
process_moving_target_hit(param_00,param_01,param_02)
{
	if(isdefined(level.process_moving_target_hit_func))
	{
		[[ level.process_moving_target_hit_func ]](param_00,param_01,param_02);
		return;
	}

	remove_moving_target_default(param_00,param_01);
}

//Function Number: 30
remove_moving_target_default(param_00,param_01)
{
	remove_moving_target(param_00,param_01);
	scripts\cp\maps\cp_zmb\cp_zmb_ghost_wave::increment_alien_head_destroyed_count(param_01);
}

//Function Number: 31
remove_moving_target(param_00,param_01)
{
	param_00 setscriptablepartstate("skull_vfx","off");
	param_00 delete();
	param_01 thread scripts\cp\cp_vo::try_to_play_vo("killfirm_ghost","zmb_comment_vo","highest",10,0,0,1,10);
	scripts\cp\maps\cp_zmb\cp_zmb_ghost_wave::purge_undefined_from_moving_target_array();
}

//Function Number: 32
getclosestactivemovingtargetwithinrange(param_00,param_01)
{
	if(!isdefined(level.moving_target_groups))
	{
		return undefined;
	}

	var_02 = [];
	foreach(var_04 in level.moving_target_groups)
	{
		foreach(var_06 in var_04)
		{
			if(!isdefined(var_06))
			{
				continue;
			}

			if(distancesquared(param_00.origin,var_06.origin) < param_01)
			{
				var_02[var_02.size] = var_06;
			}
		}
	}

	var_09 = sortbydistance(var_02,param_00.origin);
	return var_09[0];
}

//Function Number: 33
getactiveghostswithinrange(param_00,param_01)
{
	var_02 = [];
	foreach(var_04 in level.zombie_ghosts)
	{
		if(var_04 == param_00)
		{
			continue;
		}

		if(isentangled(var_04))
		{
			continue;
		}

		if(distancesquared(param_00.origin,var_04.origin) < param_01)
		{
			var_02[var_02.size] = var_04;
		}
	}

	return var_02;
}

//Function Number: 34
getghostdetonateexplosionrange()
{
	return -25536;
}

//Function Number: 35
getghostimpactexplosionrange()
{
	return 7225;
}

//Function Number: 36
setisentangled(param_00,param_01)
{
	param_00.is_entangled = param_01;
}

//Function Number: 37
isentangled(param_00)
{
	return scripts\engine\utility::istrue(param_00.is_entangled);
}

//Function Number: 38
notargetfound(param_00)
{
	return level.failure;
}

//Function Number: 39
setghostnavmode(param_00)
{
	self.ghost_nav_mode = param_00;
}

//Function Number: 40
getghostnavmode()
{
	return self.ghost_nav_mode;
}

//Function Number: 41
clearhidenode()
{
	self.ghost_hide_node = undefined;
}

//Function Number: 42
clearhovernode()
{
	self.ghost_hover_node = undefined;
}

//Function Number: 43
updateghostanimplaybackrate(param_00)
{
	if(!isdefined(self.currentanimstate))
	{
		return;
	}

	if(!isdefined(self.currentanimindex))
	{
		return;
	}

	self.animplaybackrate = param_00;
	self setanimstate(self.currentanimstate,self.currentanimindex,self.animplaybackrate);
}

//Function Number: 44
setbeingentangledscriptable(param_00,param_01)
{
	param_01 setscriptablepartstate("being_entangled",param_00);
}

//Function Number: 45
setmisttrailscriptable(param_00,param_01)
{
	param_01 setscriptablepartstate("mist_trail",param_00);
}

//Function Number: 46
getrandomhovernodesaroundtargetpos(param_00,param_01)
{
	var_02 = 4;
	var_03 = sortbydistance(param_01,param_00);
	var_04 = scripts\engine\utility::ter_op(var_03.size > var_02,var_02,var_03.size);
	var_05 = randomint(var_04);
	return var_03[var_05];
}

//Function Number: 47
playghostexplosionvfx(param_00)
{
	var_01 = vectornormalize(param_00.var_381);
	if(var_01 == (0,0,0))
	{
		var_01 = (0,0,1);
	}

	var_02 = vectortoangles(var_01);
	playfx(level._effect["ghost_explosion_death"],param_00.origin,var_01,anglestoup(var_02));
}