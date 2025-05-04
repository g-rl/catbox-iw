/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\common\fx.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 29
 * Decompile Time: 1526 ms
 * Timestamp: 10/27/2023 12:03:25 AM
*******************************************************************/

//Function Number: 1
initfx()
{
	if(!scripts\engine\utility::add_init_script("fx",::initfx))
	{
		return;
	}

	scripts\engine\utility::add_func_ref_MAYBE("create_triggerfx",::create_triggerfx);
	thread init_fx_thread();
}

//Function Number: 2
init_fx_thread()
{
	if(!isdefined(level._fx))
	{
		level._fx = spawnstruct();
	}

	scripts\engine\utility::create_lock("createfx_looper",20);
	level._fx.fireloopmod = 1;
	level._fx.exploderfunction = ::scripts\common\exploder::exploder_before_load;
	waittillframeend;
	waittillframeend;
	level._fx.exploderfunction = ::scripts\common\exploder::exploder_after_load;
	level._fx.server_culled_sounds = 0;
	if(getdvarint("serverCulledSounds") == 1)
	{
		level._fx.server_culled_sounds = 1;
	}

	if(level.createfx_enabled)
	{
		level._fx.server_culled_sounds = 0;
	}

	if(level.createfx_enabled)
	{
		level waittill("createfx_common_done");
	}

	for(var_00 = 0;var_00 < level.createfxent.size;var_00++)
	{
		var_01 = level.createfxent[var_00];
		var_01 scripts\common\createfx::set_forward_and_up_vectors();
		switch(var_01.v["type"])
		{
			case "loopfx":
				var_01 thread loopfxthread();
				break;

			case "oneshotfx":
				var_01 thread oneshotfxthread();
				break;

			case "soundfx":
				var_01 thread create_loopsound();
				break;

			case "soundfx_interval":
				var_01 thread create_interval_sound();
				break;

			case "reactive_fx":
				var_01 add_reactive_fx();
				break;
		}
	}

	check_createfx_limit();
}

//Function Number: 3
remove_dupes()
{
}

//Function Number: 4
offset_fix()
{
}

//Function Number: 5
check_createfx_limit()
{
}

//Function Number: 6
check_limit_type(param_00,param_01)
{
}

//Function Number: 7
print_org(param_00,param_01,param_02,param_03)
{
	if(getdvar("debug") == "1")
	{
	}
}

//Function Number: 8
func_C519(param_00,param_01,param_02,param_03)
{
}

//Function Number: 9
loopfx(param_00,param_01,param_02,param_03,param_04,param_05,param_06)
{
	var_07 = scripts\engine\utility::createloopeffect(param_00);
	var_07.v["origin"] = param_01;
	var_07.v["angles"] = (0,0,0);
	if(isdefined(param_03))
	{
		var_07.v["angles"] = vectortoangles(param_03 - param_01);
	}

	var_07.v["delay"] = param_02;
}

//Function Number: 10
create_looper()
{
	self.looper = function_0173(level._effect[self.v["fxid"]],self.v["delay"],self.v["origin"],0,self.v["forward"],self.v["up"]);
	create_loopsound();
}

//Function Number: 11
create_loopsound()
{
	self notify("stop_loop");
	if(!isdefined(self.v["soundalias"]))
	{
		return;
	}

	if(self.v["soundalias"] == "nil")
	{
		return;
	}

	var_00 = 0;
	var_01 = undefined;
	if(isdefined(self.v["stopable"]) && self.v["stopable"])
	{
		if(isdefined(self.looper))
		{
			var_01 = "death";
		}
		else
		{
			var_01 = "stop_loop";
		}
	}
	else if(level._fx.server_culled_sounds && isdefined(self.v["server_culled"]))
	{
		var_00 = self.v["server_culled"];
	}

	var_02 = self;
	if(isdefined(self.looper))
	{
		var_02 = self.looper;
	}

	var_03 = undefined;
	if(level.createfx_enabled)
	{
		var_03 = self;
	}

	var_02 scripts\engine\utility::loop_fx_sound_with_angles(self.v["soundalias"],self.v["origin"],self.v["angles"],var_00,var_01,var_03);
}

//Function Number: 12
create_interval_sound()
{
	self notify("stop_loop");
	if(!isdefined(self.v["soundalias"]))
	{
		return;
	}

	if(self.v["soundalias"] == "nil")
	{
		return;
	}

	var_00 = undefined;
	var_01 = self;
	if((isdefined(self.v["stopable"]) && self.v["stopable"]) || level.createfx_enabled)
	{
		if(isdefined(self.looper))
		{
			var_01 = self.looper;
			var_00 = "death";
		}
		else
		{
			var_00 = "stop_loop";
		}
	}

	var_01 thread scripts\engine\utility::loop_fx_sound_interval_with_angles(self.v["soundalias"],self.v["origin"],self.v["angles"],var_00,undefined,self.v["delay_min"],self.v["delay_max"]);
}

//Function Number: 13
loopfxthread()
{
	scripts\engine\utility::waitframe();
	if(isdefined(self.fxstart))
	{
		level waittill("start fx" + self.fxstart);
	}

	for(;;)
	{
		create_looper();
		if(isdefined(self.timeout))
		{
			thread loopfxstop(self.timeout);
		}

		if(isdefined(self.fxstop))
		{
			level waittill("stop fx" + self.fxstop);
		}
		else
		{
			return;
		}

		if(isdefined(self.looper))
		{
			self.looper delete();
		}

		if(isdefined(self.fxstart))
		{
			level waittill("start fx" + self.fxstart);
			continue;
		}
	}
}

//Function Number: 14
loopfxstop(param_00)
{
	self endon("death");
	wait(param_00);
	self.looper delete();
}

//Function Number: 15
loopsound(param_00,param_01,param_02)
{
	level thread loopsoundthread(param_00,param_01,param_02);
}

//Function Number: 16
loopsoundthread(param_00,param_01,param_02)
{
	var_03 = spawn("script_origin",param_01);
	var_03.origin = param_01;
	var_03 playloopsound(param_00);
}

//Function Number: 17
gunfireloopfx(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07)
{
	thread gunfireloopfxthread(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07);
}

//Function Number: 18
gunfireloopfxthread(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07)
{
	level endon("stop all gunfireloopfx");
	scripts\engine\utility::waitframe();
	if(param_07 < param_06)
	{
		var_08 = param_07;
		param_07 = param_06;
		param_06 = var_08;
	}

	var_09 = param_06;
	var_0A = param_07 - param_06;
	if(param_05 < param_04)
	{
		var_08 = param_05;
		param_05 = param_04;
		param_04 = var_08;
	}

	var_0B = param_04;
	var_0C = param_05 - param_04;
	if(param_03 < param_02)
	{
		var_08 = param_03;
		param_03 = param_02;
		param_02 = var_08;
	}

	var_0D = param_02;
	var_0E = param_03 - param_02;
	var_0F = spawnfx(level._effect[param_00],param_01);
	if(!level.createfx_enabled)
	{
		var_0F willneverchange();
	}

	for(;;)
	{
		var_10 = var_0D + randomint(var_0E);
		for(var_11 = 0;var_11 < var_10;var_11++)
		{
			triggerfx(var_0F);
			wait(var_0B + randomfloat(var_0C));
		}

		wait(var_09 + randomfloat(var_0A));
	}
}

//Function Number: 19
create_triggerfx()
{
	if(!verify_effects_assignment(self.v["fxid"]))
	{
		return;
	}

	self.looper = spawnfx(level._effect[self.v["fxid"]],self.v["origin"],self.v["forward"],self.v["up"]);
	triggerfx(self.looper,self.v["delay"]);
	if(!level.createfx_enabled)
	{
		self.looper willneverchange();
	}

	create_loopsound();
}

//Function Number: 20
verify_effects_assignment(param_00)
{
	if(isdefined(level._effect[param_00]))
	{
		return 1;
	}

	if(!isdefined(level._missing_fx))
	{
		level._missing_fx = [];
	}

	level._missing_fx[self.v["fxid"]] = param_00;
	verify_effects_assignment_print(param_00);
	return 0;
}

//Function Number: 21
verify_effects_assignment_print(param_00)
{
	level notify("verify_effects_assignment_print");
	level endon("verify_effects_assignment_print");
	wait(0.05);
	var_01 = getarraykeys(level._missing_fx);
	foreach(var_03 in var_01)
	{
	}
}

//Function Number: 22
oneshotfxthread()
{
	wait(0.05);
	if(self.v["delay"] > 0)
	{
		wait(self.v["delay"]);
	}

	[[ level.func["create_triggerfx"] ]]();
}

//Function Number: 23
add_reactive_fx()
{
	if(!scripts\engine\utility::issp() && getdvar("createfx") == "")
	{
		return;
	}

	if(!isdefined(level._fx.reactive_thread))
	{
		level._fx.reactive_thread = 1;
		level thread reactive_fx_thread();
	}

	if(!isdefined(level._fx.reactive_fx_ents))
	{
		level._fx.reactive_fx_ents = [];
	}

	level._fx.reactive_fx_ents[level._fx.reactive_fx_ents.size] = self;
	self.next_reactive_time = 3000;
}

//Function Number: 24
reactive_fx_thread()
{
	if(!scripts\engine\utility::issp())
	{
		if(getdvar("createfx") == "on")
		{
			scripts\engine\utility::flag_wait("createfx_started");
		}
	}

	level._fx.reactive_sound_ents = [];
	var_00 = 256;
	for(;;)
	{
		level waittill("code_damageradius",var_01,var_00,var_02,var_03,var_04);
		var_05 = sort_reactive_ents(var_02,var_00);
		foreach(var_08, var_07 in var_05)
		{
			var_07 thread play_reactive_fx(var_08,var_04);
		}
	}
}

//Function Number: 25
vector2d(param_00)
{
	return (param_00[0],param_00[1],0);
}

//Function Number: 26
sort_reactive_ents(param_00,param_01)
{
	var_02 = [];
	var_03 = gettime();
	foreach(var_05 in level._fx.reactive_fx_ents)
	{
		if(var_05.next_reactive_time > var_03)
		{
			continue;
		}

		var_06 = var_05.v["reactive_radius"] + param_01;
		var_06 = var_06 * var_06;
		if(distancesquared(param_00,var_05.v["origin"]) < var_06)
		{
			var_02[var_02.size] = var_05;
		}
	}

	foreach(var_05 in var_02)
	{
		var_09 = vector2d(var_05.v["origin"] - level.player.origin);
		var_0A = vector2d(param_00 - level.player.origin);
		var_0B = vectornormalize(var_09);
		var_0C = vectornormalize(var_0A);
		var_05.dot = vectordot(var_0B,var_0C);
	}

	for(var_0E = 0;var_0E < var_02.size - 1;var_0E++)
	{
		for(var_0F = var_0E + 1;var_0F < var_02.size;var_0F++)
		{
			if(var_02[var_0E].dot > var_02[var_0F].dot)
			{
				var_10 = var_02[var_0E];
				var_02[var_0E] = var_02[var_0F];
				var_02[var_0F] = var_10;
			}
		}
	}

	foreach(var_05 in var_02)
	{
		var_05.origin = undefined;
		var_05.dot = undefined;
	}

	for(var_0E = 4;var_0E < var_02.size;var_0E++)
	{
		var_02[var_0E] = undefined;
	}

	return var_02;
}

//Function Number: 27
play_reactive_fx(param_00,param_01)
{
	if(self.v["fxid"] != "No FX")
	{
		playfx(level._effect[self.v["fxid"]],self.v["origin"],self.v["forward"],self.v["up"]);
	}

	if(self.v["soundalias"] == "nil")
	{
		return;
	}

	var_02 = get_reactive_sound_ent();
	if(!isdefined(var_02))
	{
		return;
	}

	self.next_reactive_time = gettime() + 3000;
	var_02.origin = self.v["origin"];
	var_02.is_playing = 1;
	if(!isdefined(param_01))
	{
		param_01 = 0;
	}

	wait(param_00 * randomfloatrange(0.05,0.1) + param_01);
	if(scripts\engine\utility::issp())
	{
		var_02 playsound(self.v["soundalias"],"sounddone");
		var_02 waittill("sounddone");
	}
	else
	{
		var_02 playsound(self.v["soundalias"]);
		wait(2);
	}

	wait(0.1);
	var_02.is_playing = 0;
}

//Function Number: 28
get_reactive_sound_ent()
{
	foreach(var_01 in level._fx.reactive_sound_ents)
	{
		if(!var_01.is_playing)
		{
			return var_01;
		}
	}

	if(level._fx.reactive_sound_ents.size < 4)
	{
		var_01 = spawn("script_origin",(0,0,0));
		var_01.is_playing = 0;
		level._fx.reactive_sound_ents[level._fx.reactive_sound_ents.size] = var_01;
		return var_01;
	}

	return undefined;
}

//Function Number: 29
playfxnophase(param_00,param_01,param_02,param_03)
{
	var_04 = 0;
	var_05 = [];
	foreach(var_07 in level.players)
	{
		if(var_07 isinphase())
		{
			var_04 = 1;
			continue;
		}

		var_05[var_05.size] = var_07;
	}

	if(var_04)
	{
		foreach(var_07 in var_05)
		{
			playfx(param_00,param_01,param_02,param_03,var_07);
		}

		return;
	}

	playfx(param_00,param_01,param_02,param_03);
}