/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\common\exploder.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 32
 * Decompile Time: 1623 ms
 * Timestamp: 10/27/2023 12:03:23 AM
*******************************************************************/

//Function Number: 1
setup_individual_exploder(param_00)
{
	var_01 = param_00.script_exploder;
	if(!isdefined(level.exploders[var_01]))
	{
		level.exploders[var_01] = [];
	}

	var_02 = param_00.var_336;
	if(!isdefined(var_02))
	{
		var_02 = "";
	}

	level.exploders[var_01][level.exploders[var_01].size] = param_00;
	if(exploder_model_starts_hidden(param_00))
	{
		param_00 hide();
		return;
	}

	if(exploder_model_is_damaged_model(param_00))
	{
		param_00 hide();
		param_00 notsolid();
		if(isdefined(param_00.spawnimpulsefield) && param_00.spawnimpulsefield & 1)
		{
			if(isdefined(param_00.script_disconnectpaths))
			{
				param_00 connectpaths();
			}
		}

		return;
	}

	if(exploder_model_is_chunk(param_00))
	{
		param_00 hide();
		param_00 notsolid();
		if(isdefined(param_00.spawnimpulsefield) && param_00.spawnimpulsefield & 1)
		{
			param_00 connectpaths();
		}
	}
}

//Function Number: 2
setupexploders()
{
	scripts\engine\utility::set_createfx_enabled();
	level.exploders = [];
	var_00 = getentarray("script_brushmodel","classname");
	var_01 = getentarray("script_model","classname");
	for(var_02 = 0;var_02 < var_01.size;var_02++)
	{
		var_00[var_00.size] = var_01[var_02];
	}

	foreach(var_04 in var_00)
	{
		if(isdefined(var_04.script_prefab_exploder))
		{
			var_04.script_exploder = var_04.script_prefab_exploder;
		}

		if(isdefined(var_04.masked_exploder))
		{
			continue;
		}

		if(isdefined(var_04.script_exploder))
		{
			setup_individual_exploder(var_04);
		}
	}

	var_06 = [];
	var_07 = getentarray("script_brushmodel","classname");
	for(var_02 = 0;var_02 < var_07.size;var_02++)
	{
		if(isdefined(var_07[var_02].script_prefab_exploder))
		{
			var_07[var_02].script_exploder = var_07[var_02].script_prefab_exploder;
		}

		if(isdefined(var_07[var_02].script_exploder))
		{
			var_06[var_06.size] = var_07[var_02];
		}
	}

	var_07 = getentarray("script_model","classname");
	for(var_02 = 0;var_02 < var_07.size;var_02++)
	{
		if(isdefined(var_07[var_02].script_prefab_exploder))
		{
			var_07[var_02].script_exploder = var_07[var_02].script_prefab_exploder;
		}

		if(isdefined(var_07[var_02].script_exploder))
		{
			var_06[var_06.size] = var_07[var_02];
		}
	}

	var_07 = getentarray("item_health","classname");
	for(var_02 = 0;var_02 < var_07.size;var_02++)
	{
		if(isdefined(var_07[var_02].script_prefab_exploder))
		{
			var_07[var_02].script_exploder = var_07[var_02].script_prefab_exploder;
		}

		if(isdefined(var_07[var_02].script_exploder))
		{
			var_06[var_06.size] = var_07[var_02];
		}
	}

	var_07 = level.struct;
	for(var_02 = 0;var_02 < var_07.size;var_02++)
	{
		if(!isdefined(var_07[var_02]))
		{
			continue;
		}

		if(isdefined(var_07[var_02].script_prefab_exploder))
		{
			var_07[var_02].script_exploder = var_07[var_02].script_prefab_exploder;
		}

		if(isdefined(var_07[var_02].script_exploder))
		{
			if(!isdefined(var_07[var_02].angles))
			{
				var_07[var_02].angles = (0,0,0);
			}

			var_06[var_06.size] = var_07[var_02];
		}
	}

	if(!isdefined(level.createfxent))
	{
		level.createfxent = [];
	}

	var_08 = [];
	var_08["exploderchunk visible"] = 1;
	var_08["exploderchunk"] = 1;
	var_08["exploder"] = 1;
	thread setup_flag_exploders();
	for(var_02 = 0;var_02 < var_06.size;var_02++)
	{
		var_09 = var_06[var_02];
		var_04 = scripts\engine\utility::createexploder(var_09.script_fxid);
		var_04.v = [];
		var_04.v["origin"] = var_09.origin;
		var_04.v["angles"] = var_09.angles;
		var_04.v["delay"] = var_09.script_delay;
		var_04.v["delay_post"] = var_09.script_delay_post;
		var_04.v["firefx"] = var_09.script_firefx;
		var_04.v["firefxdelay"] = var_09.script_firefxdelay;
		var_04.v["firefxsound"] = var_09.script_firefxsound;
		var_04.v["earthquake"] = var_09.script_earthquake;
		var_04.v["rumble"] = var_09.script_rumble;
		var_04.v["damage"] = var_09.script_damage;
		var_04.v["damage_radius"] = var_09.script_radius;
		var_04.v["soundalias"] = var_09.script_soundalias;
		var_04.v["repeat"] = var_09.script_repeat;
		var_04.v["delay_min"] = var_09.script_delay_min;
		var_04.v["delay_max"] = var_09.script_delay_max;
		var_04.v["target"] = var_09.target;
		var_04.v["ender"] = var_09.script_ender;
		var_04.v["physics"] = var_09.script_physics;
		var_04.v["type"] = "exploder";
		if(!isdefined(var_09.script_fxid))
		{
			var_04.v["fxid"] = "No FX";
		}
		else
		{
			var_04.v["fxid"] = var_09.script_fxid;
		}

		var_04.v["exploder"] = var_09.script_exploder;
		if(isdefined(level.createfxexploders))
		{
			var_0A = level.createfxexploders[var_04.v["exploder"]];
			if(!isdefined(var_0A))
			{
				var_0A = [];
			}

			var_0A[var_0A.size] = var_04;
			level.createfxexploders[var_04.v["exploder"]] = var_0A;
		}

		if(!isdefined(var_04.v["delay"]))
		{
			var_04.v["delay"] = 0;
		}

		if(isdefined(var_09.target))
		{
			var_0B = getentarray(var_04.v["target"],"targetname")[0];
			if(isdefined(var_0B))
			{
				var_0C = var_0B.origin;
				var_04.v["angles"] = vectortoangles(var_0C - var_04.v["origin"]);
			}
			else
			{
				var_0B = scripts\engine\utility::get_target_ent(var_04.v["target"]);
				if(isdefined(var_0B))
				{
					var_0C = var_0B.origin;
					var_04.v["angles"] = vectortoangles(var_0C - var_04.v["origin"]);
				}
			}
		}

		if(!isdefined(var_09.var_9F))
		{
			var_04.model = var_09;
			if(isdefined(var_04.model.script_modelname))
			{
				precachemodel(var_04.model.script_modelname);
			}
		}
		else if(var_09.var_9F == "script_brushmodel" || isdefined(var_09.model))
		{
			var_04.model = var_09;
			var_04.model.disconnect_paths = var_09.script_disconnectpaths;
		}

		if(isdefined(var_09.var_336) && isdefined(var_08[var_09.var_336]))
		{
			var_04.v["exploder_type"] = var_09.var_336;
		}
		else
		{
			var_04.v["exploder_type"] = "normal";
		}

		if(isdefined(var_09.masked_exploder))
		{
			var_04.v["masked_exploder"] = var_09.model;
			var_04.v["masked_exploder_spawnflags"] = var_09.spawnimpulsefield;
			var_04.v["masked_exploder_script_disconnectpaths"] = var_09.script_disconnectpaths;
			var_09 delete();
		}

		var_04 scripts\common\createfx::post_entity_creation_function();
	}
}

//Function Number: 3
setup_flag_exploders()
{
	waittillframeend;
	waittillframeend;
	waittillframeend;
	var_00 = [];
	foreach(var_02 in level.createfxent)
	{
		if(var_02.v["type"] != "exploder")
		{
			continue;
		}

		var_03 = var_02.v["flag"];
		if(!isdefined(var_03))
		{
			continue;
		}

		if(var_03 == "nil")
		{
			var_02.v["flag"] = undefined;
		}

		var_00[var_03] = 1;
	}

	foreach(var_07, var_06 in var_00)
	{
		thread exploder_flag_wait(var_07);
	}
}

//Function Number: 4
exploder_flag_wait(param_00)
{
	if(!scripts\engine\utility::flag_exist(param_00))
	{
		scripts\engine\utility::flag_init(param_00);
	}

	scripts\engine\utility::flag_wait(param_00);
	foreach(var_02 in level.createfxent)
	{
		if(var_02.v["type"] != "exploder")
		{
			continue;
		}

		var_03 = var_02.v["flag"];
		if(!isdefined(var_03))
		{
			continue;
		}

		if(var_03 != param_00)
		{
			continue;
		}

		var_02 scripts\engine\utility::activate_individual_exploder();
	}
}

//Function Number: 5
exploder_model_is_damaged_model(param_00)
{
	return isdefined(param_00.var_336) && param_00.var_336 == "exploder";
}

//Function Number: 6
exploder_model_starts_hidden(param_00)
{
	return param_00.model == "fx" && !isdefined(param_00.var_336) || param_00.var_336 != "exploderchunk";
}

//Function Number: 7
exploder_model_is_chunk(param_00)
{
	return isdefined(param_00.var_336) && param_00.var_336 == "exploderchunk";
}

//Function Number: 8
show_exploder_models_proc(param_00)
{
	param_00 = param_00 + "";
	if(isdefined(level.createfxexploders))
	{
		var_01 = level.createfxexploders[param_00];
		if(isdefined(var_01))
		{
			foreach(var_03 in var_01)
			{
				if(!exploder_model_starts_hidden(var_03.model) && !exploder_model_is_damaged_model(var_03.model) && !exploder_model_is_chunk(var_03.model))
				{
					var_03.model show();
				}

				if(isdefined(var_03.brush_shown))
				{
					var_03.model show();
				}
			}

			return;
		}

		return;
	}

	var_05 = 0;
	while(var_03 < level.createfxent.size)
	{
		var_05 = level.createfxent[var_03];
		if(!isdefined(var_05))
		{
			continue;
		}

		if(var_05.v["type"] != "exploder")
		{
			continue;
		}

		if(!isdefined(var_05.v["exploder"]))
		{
			continue;
		}

		if(var_05.v["exploder"] + "" != var_02)
		{
			continue;
		}

		if(isdefined(var_05.model))
		{
			if(!exploder_model_starts_hidden(var_05.model) && !exploder_model_is_damaged_model(var_05.model) && !exploder_model_is_chunk(var_05.model))
			{
				var_05.model show();
			}

			if(isdefined(var_05.brush_shown))
			{
				var_05.model show();
			}
		}

		var_03++;
	}
}

//Function Number: 9
stop_exploder_proc(param_00)
{
	param_00 = param_00 + "";
	if(isdefined(level.createfxexploders))
	{
		var_01 = level.createfxexploders[param_00];
		if(isdefined(var_01))
		{
			foreach(var_03 in var_01)
			{
				if(!isdefined(var_03.looper))
				{
					continue;
				}

				if(isdefined(var_03.loopsound_ent))
				{
					var_03.loopsound_ent stoploopsound();
					var_03.loopsound_ent delete();
				}

				var_03.looper delete();
			}

			return;
		}

		return;
	}

	var_05 = 0;
	while(var_03 < level.createfxent.size)
	{
		var_05 = level.createfxent[var_03];
		if(!isdefined(var_05))
		{
			continue;
		}

		if(var_05.v["type"] != "exploder")
		{
			continue;
		}

		if(!isdefined(var_05.v["exploder"]))
		{
			continue;
		}

		if(var_05.v["exploder"] + "" != var_02)
		{
			continue;
		}

		if(!isdefined(var_05.looper))
		{
			continue;
		}

		if(isdefined(var_05.loopsound_ent))
		{
			var_05.loopsound_ent stoploopsound();
			var_05.loopsound_ent delete();
		}

		var_05.looper delete();
		var_03++;
	}
}

//Function Number: 10
get_exploder_array_proc(param_00)
{
	param_00 = param_00 + "";
	var_01 = [];
	if(isdefined(level.createfxexploders))
	{
		var_02 = level.createfxexploders[param_00];
		if(isdefined(var_02))
		{
			var_01 = var_02;
		}
	}
	else
	{
		foreach(var_04 in level.createfxent)
		{
			if(var_04.v["type"] != "exploder")
			{
				continue;
			}

			if(!isdefined(var_04.v["exploder"]))
			{
				continue;
			}

			if(var_04.v["exploder"] + "" != param_00)
			{
				continue;
			}

			var_01[var_01.size] = var_04;
		}
	}

	return var_01;
}

//Function Number: 11
hide_exploder_models_proc(param_00)
{
	param_00 = param_00 + "";
	if(isdefined(level.createfxexploders))
	{
		var_01 = level.createfxexploders[param_00];
		if(isdefined(var_01))
		{
			foreach(var_03 in var_01)
			{
				if(isdefined(var_03.model))
				{
					var_03.model hide();
				}
			}

			return;
		}

		return;
	}

	var_05 = 0;
	while(var_03 < level.createfxent.size)
	{
		var_05 = level.createfxent[var_03];
		if(!isdefined(var_05))
		{
			continue;
		}

		if(var_05.v["type"] != "exploder")
		{
			continue;
		}

		if(!isdefined(var_05.v["exploder"]))
		{
			continue;
		}

		if(var_05.v["exploder"] + "" != var_02)
		{
			continue;
		}

		if(isdefined(var_05.model))
		{
			var_05.model hide();
		}

		var_03++;
	}
}

//Function Number: 12
delete_exploder_proc(param_00)
{
	param_00 = param_00 + "";
	if(isdefined(level.createfxexploders))
	{
		var_01 = level.createfxexploders[param_00];
		if(isdefined(var_01))
		{
			foreach(var_03 in var_01)
			{
				if(isdefined(var_03.model))
				{
					var_03.model delete();
				}
			}
		}
	}
	else
	{
		for(var_05 = 0;var_05 < level.createfxent.size;var_05++)
		{
			var_03 = level.createfxent[var_05];
			if(!isdefined(var_03))
			{
				continue;
			}

			if(var_03.v["type"] != "exploder")
			{
				continue;
			}

			if(!isdefined(var_03.v["exploder"]))
			{
				continue;
			}

			if(var_03.v["exploder"] + "" != param_00)
			{
				continue;
			}

			if(isdefined(var_03.model))
			{
				var_03.model delete();
			}
		}
	}

	level notify("killexplodertridgers" + param_00);
}

//Function Number: 13
exploder_damage()
{
	if(isdefined(self.v["delay"]))
	{
		var_00 = self.v["delay"];
	}
	else
	{
		var_00 = 0;
	}

	if(isdefined(self.v["damage_radius"]))
	{
		var_01 = self.v["damage_radius"];
	}
	else
	{
		var_01 = 128;
	}

	var_02 = self.v["damage"];
	var_03 = self.v["origin"];
	wait(var_00);
	if(isdefined(level.custom_radius_damage_for_exploders))
	{
		[[ level.custom_radius_damage_for_exploders ]](var_03,var_01,var_02);
		return;
	}

	radiusdamage(var_03,var_01,var_02,var_02);
}

//Function Number: 14
activate_individual_exploder_proc()
{
	if(isdefined(self.v["firefx"]))
	{
		thread fire_effect();
	}

	if(isdefined(self.v["fxid"]) && self.v["fxid"] != "No FX")
	{
		thread cannon_effect();
	}
	else if(isdefined(self.v["soundalias"]) && self.v["soundalias"] != "nil")
	{
		thread sound_effect();
	}

	if(isdefined(self.v["loopsound"]) && self.v["loopsound"] != "nil")
	{
		thread effect_loopsound();
	}

	if(isdefined(self.v["damage"]))
	{
		thread exploder_damage();
	}

	if(isdefined(self.v["earthquake"]))
	{
		thread exploder_earthquake();
	}

	if(isdefined(self.v["rumble"]))
	{
		thread exploder_rumble();
	}

	if(self.v["exploder_type"] == "exploder")
	{
		thread brush_show();
		return;
	}

	if(self.v["exploder_type"] == "exploderchunk" || self.v["exploder_type"] == "exploderchunk visible")
	{
		thread brush_throw();
		return;
	}

	thread brush_delete();
}

//Function Number: 15
brush_delete()
{
	var_00 = self.v["exploder"];
	if(isdefined(self.v["delay"]))
	{
		wait(self.v["delay"]);
	}
	else
	{
		wait(0.05);
	}

	if(!isdefined(self.model))
	{
		return;
	}

	if(isdefined(self.model.classname))
	{
		if(!function_02A4(self.model) && isdefined(self.model.classname))
		{
			if(scripts\engine\utility::issp() && self.model.spawnimpulsefield & 1)
			{
				self.model [[ level.func["connectPaths"] ]]();
			}
		}
	}

	if(level.createfx_enabled)
	{
		if(isdefined(self.exploded))
		{
			return;
		}

		self.exploded = 1;
		self.model hide();
		self.model notsolid();
		wait(3);
		self.exploded = undefined;
		self.model show();
		self.model solid();
		return;
	}

	if(!isdefined(self.v["fxid"]) || self.v["fxid"] == "No FX")
	{
		self.v["exploder"] = undefined;
	}

	waittillframeend;
	if(isdefined(self.model) && !function_02A4(self.model) && isdefined(self.model.classname))
	{
		self.model delete();
	}
}

//Function Number: 16
brush_throw()
{
	if(isdefined(self.v["delay"]))
	{
		wait(self.v["delay"]);
	}

	var_00 = undefined;
	if(isdefined(self.v["target"]))
	{
		var_00 = scripts\engine\utility::get_target_ent(self.v["target"]);
	}

	if(!isdefined(var_00))
	{
		self.model delete();
		return;
	}

	self.model show();
	if(isdefined(self.v["delay_post"]))
	{
		wait(self.v["delay_post"]);
	}

	var_01 = self.v["origin"];
	var_02 = self.v["angles"];
	var_03 = var_00.origin;
	var_04 = isdefined(self.v["physics"]);
	if(var_04)
	{
		var_05 = undefined;
		if(isdefined(var_00.target))
		{
			var_05 = var_00 scripts\engine\utility::get_target_ent();
		}

		if(isdefined(var_05))
		{
			var_06 = var_00.origin;
			var_07 = vectornormalize(var_05.origin - var_00.origin);
		}
		else
		{
			var_06 = self.model.origin;
			var_07 = vectornormalize(var_04 - self.model.origin);
		}

		var_07 = var_07 * self.v["physics"];
		self.model physicslaunchserver(var_06,var_07);
		return;
	}
	else
	{
		var_07 = var_06 - self.model.origin;
		self.model rotatevelocity(var_07,12);
		self.model movegravity(var_07,12);
	}

	if(level.createfx_enabled)
	{
		if(isdefined(self.exploded))
		{
			return;
		}

		self.exploded = 1;
		wait(3);
		self.exploded = undefined;
		self.v["origin"] = var_03;
		self.v["angles"] = var_04;
		self.model hide();
		return;
	}

	self.v["exploder"] = undefined;
	wait(6);
	self.model delete();
}

//Function Number: 17
brush_show()
{
	if(isdefined(self.v["delay"]))
	{
		wait(self.v["delay"]);
	}

	if(!isdefined(self.model.script_modelname))
	{
		self.model show();
		self.model solid();
	}
	else
	{
		var_00 = self.model scripts\engine\utility::spawn_tag_origin();
		if(isdefined(self.model.destroynavobstacle))
		{
			var_00.destroynavobstacle = self.model.destroynavobstacle;
		}

		var_00 setmodel(self.model.script_modelname);
		var_00 show();
	}

	self.brush_shown = 1;
	if(scripts\engine\utility::issp() && !isdefined(self.model.script_modelname) && self.model.spawnimpulsefield & 1)
	{
		if(!isdefined(self.model.disconnect_paths))
		{
			self.model [[ level.func["connectPaths"] ]]();
		}
		else
		{
			self.model [[ level.func["disconnectPaths"] ]]();
		}
	}

	if(level.createfx_enabled)
	{
		if(isdefined(self.exploded))
		{
			return;
		}

		self.exploded = 1;
		wait(3);
		self.exploded = undefined;
		if(!isdefined(self.model.script_modelname))
		{
			self.model hide();
			self.model notsolid();
		}
	}
}

//Function Number: 18
exploder_rumble()
{
	if(!scripts\engine\utility::issp())
	{
		return;
	}

	exploder_delay();
	level.player playrumbleonentity(self.v["rumble"]);
}

//Function Number: 19
exploder_delay()
{
	if(!isdefined(self.v["delay"]))
	{
		self.v["delay"] = 0;
	}

	var_00 = self.v["delay"];
	var_01 = self.v["delay"] + 0.001;
	if(isdefined(self.v["delay_min"]))
	{
		var_00 = self.v["delay_min"];
	}

	if(isdefined(self.v["delay_max"]))
	{
		var_01 = self.v["delay_max"];
	}

	if(var_00 > 0)
	{
		wait(randomfloatrange(var_00,var_01));
	}
}

//Function Number: 20
effect_loopsound()
{
	if(isdefined(self.loopsound_ent))
	{
		self.loopsound_ent stoploopsound();
		self.loopsound_ent delete();
	}

	var_00 = self.v["origin"];
	var_01 = self.v["loopsound"];
	exploder_delay();
	self.loopsound_ent = scripts\engine\utility::play_loopsound_in_space(var_01,var_00);
}

//Function Number: 21
sound_effect()
{
	effect_soundalias();
}

//Function Number: 22
effect_soundalias()
{
	var_00 = self.v["origin"];
	var_01 = self.v["soundalias"];
	exploder_delay();
	scripts\engine\utility::play_sound_in_space(var_01,var_00);
}

//Function Number: 23
exploder_earthquake()
{
	exploder_delay();
	scripts\engine\utility::do_earthquake(self.v["earthquake"],self.v["origin"]);
}

//Function Number: 24
exploder_playsound()
{
	if(!isdefined(self.v["soundalias"]) || self.v["soundalias"] == "nil")
	{
		return;
	}

	scripts\engine\utility::play_sound_in_space(self.v["soundalias"],self.v["origin"]);
}

//Function Number: 25
fire_effect()
{
	var_00 = self.v["forward"];
	var_01 = self.v["up"];
	var_02 = undefined;
	var_03 = self.v["firefxsound"];
	var_04 = self.v["origin"];
	var_05 = self.v["firefx"];
	var_06 = self.v["ender"];
	if(!isdefined(var_06))
	{
		var_06 = "createfx_effectStopper";
	}

	var_07 = 0.5;
	if(isdefined(self.v["firefxdelay"]))
	{
		var_07 = self.v["firefxdelay"];
	}

	exploder_delay();
	if(isdefined(var_03))
	{
		scripts\engine\utility::loop_fx_sound(var_03,var_04,1,var_06);
	}

	playfx(level._effect[var_05],self.v["origin"],var_00,var_01);
}

//Function Number: 26
cannon_effect()
{
	if(isdefined(self.v["repeat"]))
	{
		thread exploder_playsound();
		for(var_00 = 0;var_00 < self.v["repeat"];var_00++)
		{
			playfx(level._effect[self.v["fxid"]],self.v["origin"],self.v["forward"],self.v["up"]);
			exploder_delay();
		}

		return;
	}

	exploder_delay();
	if(isdefined(self.looper))
	{
		self.looper delete();
	}

	self.looper = spawnfx(scripts\engine\utility::getfx(self.v["fxid"]),self.v["origin"],self.v["forward"],self.v["up"]);
	triggerfx(self.looper);
	exploder_playsound();
}

//Function Number: 27
activate_exploder(param_00,param_01,param_02)
{
	param_00 = param_00 + "";
	level notify("exploding_" + param_00);
	var_03 = 0;
	if(isdefined(level.createfxexploders) && !level.createfx_enabled)
	{
		var_04 = level.createfxexploders[param_00];
		if(isdefined(var_04))
		{
			foreach(var_06 in var_04)
			{
				var_06 scripts\engine\utility::activate_individual_exploder();
				var_03 = 1;
			}
		}
	}
	else
	{
		for(var_08 = 0;var_08 < level.createfxent.size;var_08++)
		{
			var_06 = level.createfxent[var_08];
			if(!isdefined(var_06))
			{
				continue;
			}

			if(var_06.v["type"] != "exploder")
			{
				continue;
			}

			if(!isdefined(var_06.v["exploder"]))
			{
				continue;
			}

			if(var_06.v["exploder"] + "" != param_00)
			{
				continue;
			}

			var_06 scripts\engine\utility::activate_individual_exploder();
			var_03 = 1;
		}
	}

	if(!shouldrunserversideeffects() && !var_03)
	{
		activate_clientside_exploder(param_00,param_01,param_02);
	}
}

//Function Number: 28
activate_clientside_exploder(param_00,param_01,param_02)
{
	if(!is_valid_clientside_exploder_name(param_00))
	{
		return;
	}

	var_03 = int(param_00);
	activateclientexploder(var_03,param_01,param_02);
}

//Function Number: 29
is_valid_clientside_exploder_name(param_00)
{
	if(!isdefined(param_00))
	{
		return 0;
	}

	var_01 = param_00;
	if(isstring(param_00))
	{
		var_01 = int(param_00);
		if(var_01 == 0 && param_00 != "0")
		{
			return 0;
		}
	}

	return var_01 >= 0;
}

//Function Number: 30
shouldrunserversideeffects()
{
	if(scripts\engine\utility::issp())
	{
		return 1;
	}

	if(!isdefined(level.createfx_enabled))
	{
		scripts\engine\utility::set_createfx_enabled();
	}

	if(level.createfx_enabled)
	{
		return 1;
	}

	return getdvar("clientSideEffects") != "1";
}

//Function Number: 31
exploder_before_load(param_00,param_01,param_02)
{
	waittillframeend;
	waittillframeend;
	activate_exploder(param_00,param_01,param_02);
}

//Function Number: 32
exploder_after_load(param_00,param_01,param_02)
{
	activate_exploder(param_00,param_01,param_02);
}