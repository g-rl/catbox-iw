/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\engine\_trace.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 40
 * Decompile Time: 1986 ms
 * Timestamp: 10/27/2023 12:10:51 AM
*******************************************************************/

//Function Number: 1
ray_trace(param_00,param_01,param_02,param_03,param_04,param_05)
{
	var_06 = scripts\engine\utility::ter_op(isdefined(param_03),param_03,create_default_contents());
	var_07 = scripts\engine\utility::ter_op(isdefined(param_05),param_05,0);
	var_08 = function_0287(param_00,param_01,var_06,param_02,0,"physicsquery_closest",var_07);
	if(var_08.size)
	{
		var_08 = var_08[0];
	}
	else
	{
		var_08 = internal_pack_default_trace(param_01);
	}

	if(isdefined(param_04) && param_04)
	{
		var_08 = convert_surface_flag(var_08);
	}

	return var_08;
}

//Function Number: 2
ray_trace_detail(param_00,param_01,param_02,param_03,param_04,param_05)
{
	var_06 = scripts\engine\utility::ter_op(isdefined(param_03),param_03,create_default_contents());
	var_07 = scripts\engine\utility::ter_op(isdefined(param_05),param_05,0);
	var_08 = function_0287(param_00,param_01,var_06,param_02,1,"physicsquery_closest",var_07);
	if(var_08.size)
	{
		var_08 = var_08[0];
	}
	else
	{
		var_08 = internal_pack_default_trace(param_01);
	}

	if(isdefined(param_04) && param_04)
	{
		var_08 = convert_surface_flag(var_08);
	}

	return var_08;
}

//Function Number: 3
ray_trace_get_all_results(param_00,param_01,param_02,param_03,param_04)
{
	var_05 = scripts\engine\utility::ter_op(isdefined(param_03),param_03,create_default_contents());
	var_06 = function_0287(param_00,param_01,var_05,param_02,0,"physicsquery_all");
	if(isdefined(param_04) && param_04)
	{
		foreach(var_08 in var_06)
		{
			var_08 = convert_surface_flag(var_08);
		}
	}

	return var_06;
}

//Function Number: 4
ray_trace_passed(param_00,param_01,param_02,param_03)
{
	var_04 = scripts\engine\utility::ter_op(isdefined(param_03),param_03,create_default_contents());
	return !function_0287(param_00,param_01,var_04,param_02,0,"physicsquery_any");
}

//Function Number: 5
ray_trace_detail_passed(param_00,param_01,param_02,param_03)
{
	var_04 = scripts\engine\utility::ter_op(isdefined(param_03),param_03,create_default_contents());
	return !function_0287(param_00,param_01,var_04,param_02,1,"physicsquery_any");
}

//Function Number: 6
sphere_trace(param_00,param_01,param_02,param_03,param_04,param_05)
{
	var_06 = scripts\engine\utility::ter_op(isdefined(param_04),param_04,create_default_contents());
	var_07 = function_0288(param_00,param_01,param_02,var_06,param_03,"physicsquery_closest");
	if(var_07.size)
	{
		var_07 = var_07[0];
	}
	else
	{
		var_07 = internal_pack_default_trace(param_01);
	}

	if(isdefined(param_05) && param_05)
	{
		var_07 = convert_surface_flag(var_07);
	}

	return var_07;
}

//Function Number: 7
sphere_trace_get_all_results(param_00,param_01,param_02,param_03,param_04,param_05)
{
	var_06 = scripts\engine\utility::ter_op(isdefined(param_04),param_04,create_default_contents());
	var_07 = function_0288(param_00,param_01,param_02,var_06,param_03,"physicsquery_all");
	if(isdefined(param_05) && param_05)
	{
		foreach(var_09 in var_07)
		{
			var_09 = convert_surface_flag(var_09);
		}
	}

	return var_07;
}

//Function Number: 8
sphere_trace_passed(param_00,param_01,param_02,param_03,param_04)
{
	var_05 = scripts\engine\utility::ter_op(isdefined(param_04),param_04,create_default_contents());
	return !function_0288(param_00,param_01,param_02,var_05,param_03,"physicsquery_any");
}

//Function Number: 9
sphere_get_closest_point(param_00,param_01,param_02,param_03,param_04,param_05)
{
	var_06 = scripts\engine\utility::ter_op(isdefined(param_04),param_04,create_default_contents());
	var_07 = function_028C(param_00,param_01,param_02,var_06,param_03,"physicsquery_closest");
	if(var_07.size)
	{
		var_07 = var_07[0];
	}
	else
	{
		var_07 = internal_pack_default_trace(param_00);
	}

	if(isdefined(param_05) && param_05)
	{
		var_07 = convert_surface_flag(var_07);
	}

	return var_07;
}

//Function Number: 10
capsule_trace(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07)
{
	if(!isdefined(param_04))
	{
		param_04 = (0,0,0);
	}

	var_08 = scripts\engine\utility::ter_op(isdefined(param_06),param_06,create_default_contents());
	var_09 = convert_capsule_data(param_00,param_01,param_02,param_03,param_04);
	var_0A = function_0289(var_09["trace_start"],var_09["trace_end"],param_02,var_09["half_height"],param_04,var_08,param_05,"physicsquery_closest");
	if(var_0A.size)
	{
		var_0A = var_0A[0];
	}
	else
	{
		var_0A = internal_pack_default_trace(param_01);
	}

	if(isdefined(param_07) && param_07)
	{
		var_0A = convert_surface_flag(var_0A);
	}

	return var_0A;
}

//Function Number: 11
capsule_trace_get_all_results(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07)
{
	if(!isdefined(param_04))
	{
		param_04 = (0,0,0);
	}

	var_08 = scripts\engine\utility::ter_op(isdefined(param_06),param_06,create_default_contents());
	var_09 = convert_capsule_data(param_00,param_01,param_02,param_03,param_04);
	var_0A = function_0289(var_09["trace_start"],var_09["trace_end"],param_02,var_09["half_height"],param_04,var_08,param_05,"physicsquery_all");
	if(isdefined(param_07) && param_07)
	{
		foreach(var_0C in var_0A)
		{
			var_0C = convert_surface_flag(var_0C);
		}
	}

	return var_0A;
}

//Function Number: 12
capsule_trace_passed(param_00,param_01,param_02,param_03,param_04,param_05,param_06)
{
	if(!isdefined(param_04))
	{
		param_04 = (0,0,0);
	}

	var_07 = scripts\engine\utility::ter_op(isdefined(param_06),param_06,create_default_contents());
	var_08 = convert_capsule_data(param_00,param_01,param_02,param_03,param_04);
	return !function_0289(var_08["trace_start"],var_08["trace_end"],param_02,var_08["half_height"],param_04,var_07,param_05,"physicsquery_any");
}

//Function Number: 13
capsule_get_closest_point(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07)
{
	if(!isdefined(param_03))
	{
		param_03 = (0,0,0);
	}

	var_08 = scripts\engine\utility::ter_op(isdefined(param_06),param_06,create_default_contents());
	var_09 = convert_capsule_data(param_00,undefined,param_01,param_02,param_03);
	var_0A = function_028D(var_09["trace_start"],param_01,var_09["half_height"],param_03,param_04,var_08,param_05,"physicsquery_closest");
	if(var_0A.size)
	{
		var_0A = var_0A[0];
	}
	else
	{
		var_0A = internal_pack_default_trace(param_00);
	}

	if(isdefined(param_07) && param_07)
	{
		var_0A = convert_surface_flag(var_0A);
	}

	return var_0A;
}

//Function Number: 14
player_trace(param_00,param_01,param_02,param_03,param_04,param_05,param_06)
{
	if(!isplayer(self))
	{
		return;
	}

	if(!isdefined(param_02))
	{
		param_02 = self getplayerangles();
	}

	var_07 = scripts\engine\utility::ter_op(isdefined(param_04),param_04,create_default_contents());
	if(!isdefined(param_06))
	{
		param_06 = 0;
	}

	var_08 = function_0298(param_00,param_01,self,param_06,param_02,var_07,param_03,"physicsquery_closest");
	if(var_08.size)
	{
		var_08 = var_08[0];
	}
	else
	{
		var_08 = internal_pack_default_trace(param_01);
	}

	if(isdefined(param_05) && param_05)
	{
		var_08 = convert_surface_flag(var_08);
	}

	return var_08;
}

//Function Number: 15
player_trace_get_all_results(param_00,param_01,param_02,param_03,param_04,param_05,param_06)
{
	if(!isplayer(self))
	{
		return;
	}

	if(!isdefined(param_02))
	{
		param_02 = self getplayerangles();
	}

	var_07 = scripts\engine\utility::ter_op(isdefined(param_04),param_04,create_default_contents());
	if(!isdefined(param_06))
	{
		param_06 = 0;
	}

	var_08 = function_0298(param_00,param_01,self,param_06,param_02,var_07,param_03,"physicsquery_all");
	if(isdefined(param_05) && param_05)
	{
		foreach(var_0A in var_08)
		{
			var_0A = convert_surface_flag(var_0A);
		}
	}

	return var_08;
}

//Function Number: 16
player_trace_passed(param_00,param_01,param_02,param_03,param_04,param_05)
{
	if(!isplayer(self))
	{
		return;
	}

	if(!isdefined(param_02))
	{
		param_02 = self getplayerangles();
	}

	var_06 = scripts\engine\utility::ter_op(isdefined(param_04),param_04,create_default_contents());
	if(!isdefined(param_05))
	{
		param_05 = 0;
	}

	return !function_0298(param_00,param_01,self,param_05,param_02,var_06,param_03,"physicsquery_any");
}

//Function Number: 17
player_get_closest_point_static(param_00,param_01,param_02,param_03)
{
	return player_get_closest_point(self.origin,self.angles,param_00,param_01,param_02,param_03);
}

//Function Number: 18
player_get_closest_point(param_00,param_01,param_02,param_03,param_04,param_05)
{
	if(!isplayer(self))
	{
		return;
	}

	if(!isdefined(param_01))
	{
		param_01 = self getplayerangles();
	}

	if(!isdefined(param_02))
	{
		param_02 = 0;
	}

	if(isarray(param_03))
	{
		param_03 = scripts\engine\utility::array_add(param_03,self);
	}
	else
	{
		param_03 = self;
	}

	var_06 = scripts\engine\utility::ter_op(isdefined(param_04),param_04,create_default_contents());
	var_07 = function_0299(param_00,self,0,param_01,param_02,var_06,param_03,"physicsquery_closest");
	if(var_07.size)
	{
		var_07 = var_07[0];
	}
	else
	{
		var_07 = internal_pack_default_trace(param_00);
	}

	if(isdefined(param_05) && param_05)
	{
		var_07 = convert_surface_flag(var_07);
	}

	return var_07;
}

//Function Number: 19
ai_trace(param_00,param_01,param_02,param_03,param_04,param_05,param_06)
{
	if(!isai(self))
	{
		return;
	}

	if(!isdefined(param_02))
	{
		param_02 = self.angles;
	}

	var_07 = scripts\engine\utility::ter_op(isdefined(param_04),param_04,create_default_contents());
	if(!isdefined(param_06))
	{
		param_06 = 0;
	}

	var_08 = function_0298(param_00,param_01,self,param_06,param_02,var_07,param_03,"physicsquery_closest");
	if(var_08.size)
	{
		var_08 = var_08[0];
	}
	else
	{
		var_08 = internal_pack_default_trace(param_01);
	}

	if(isdefined(param_05) && param_05)
	{
		var_08 = convert_surface_flag(var_08);
	}

	return var_08;
}

//Function Number: 20
ai_trace_get_all_results(param_00,param_01,param_02,param_03,param_04,param_05,param_06)
{
	if(!isai(self))
	{
		return;
	}

	if(!isdefined(param_02))
	{
		param_02 = self.angles;
	}

	var_07 = scripts\engine\utility::ter_op(isdefined(param_04),param_04,create_default_contents());
	if(!isdefined(param_06))
	{
		param_06 = 0;
	}

	var_08 = function_0298(param_00,param_01,self,param_06,param_02,var_07,param_03,"physicsquery_all");
	if(isdefined(param_05) && param_05)
	{
		foreach(var_0A in var_08)
		{
			var_0A = convert_surface_flag(var_0A);
		}
	}

	return var_08;
}

//Function Number: 21
ai_trace_passed(param_00,param_01,param_02,param_03,param_04,param_05)
{
	if(!isai(self))
	{
		return;
	}

	if(!isdefined(param_02))
	{
		param_02 = self.angles;
	}

	var_06 = scripts\engine\utility::ter_op(isdefined(param_04),param_04,create_default_contents());
	if(!isdefined(param_05))
	{
		param_05 = 0;
	}

	return !function_0298(param_00,param_01,self,param_05,param_02,var_06,param_03,"physicsquery_any");
}

//Function Number: 22
ai_get_closest_point(param_00,param_01,param_02,param_03,param_04,param_05)
{
	if(!isai(self))
	{
		return;
	}

	if(!isdefined(param_01))
	{
		param_01 = self.angles;
	}

	if(!isdefined(param_02))
	{
		param_02 = 0;
	}

	var_06 = scripts\engine\utility::ter_op(isdefined(param_04),param_04,create_default_contents());
	var_07 = function_0299(param_00,self,param_01,param_02,var_06,param_03,"physicsquery_closest");
	if(var_07.size)
	{
		var_07 = var_07[0];
	}
	else
	{
		var_07 = internal_pack_default_trace(param_00);
	}

	if(isdefined(param_05) && param_05)
	{
		var_07 = convert_surface_flag(var_07);
	}

	return var_07;
}

//Function Number: 23
create_solid_ai_contents(param_00)
{
	var_01 = ["physicscontents_solid","physicscontents_monsterclip","physicscontents_aiavoid","physicscontents_glass","physicscontents_vehicle"];
	if(!isdefined(param_00) || !param_00)
	{
		var_01 = scripts\engine\utility::array_add(var_01,"physicscontents_player");
	}

	return physics_createcontents(var_01);
}

//Function Number: 24
create_world_contents()
{
	var_00 = ["physicscontents_solid","physicscontents_water","physicscontents_sky"];
	return physics_createcontents(var_00);
}

//Function Number: 25
create_glass_contents()
{
	var_00 = ["physicscontents_glass"];
	return physics_createcontents(var_00);
}

//Function Number: 26
create_item_contents()
{
	var_00 = ["physicscontents_item"];
	return physics_createcontents(var_00);
}

//Function Number: 27
create_vehicle_contents()
{
	var_00 = ["physicscontents_vehicle"];
	return physics_createcontents(var_00);
}

//Function Number: 28
create_shotclip_contents()
{
	var_00 = ["physicscontents_clipshot","physicscontents_corpseclipshot","physicscontents_missileclip"];
	return physics_createcontents(var_00);
}

//Function Number: 29
create_playerclip_contents()
{
	var_00 = ["physicscontents_playerclip"];
	return physics_createcontents(var_00);
}

//Function Number: 30
create_character_contents()
{
	var_00 = ["physicscontents_player","physicscontents_actor"];
	return physics_createcontents(var_00);
}

//Function Number: 31
create_default_contents(param_00)
{
	if(!isdefined(param_00))
	{
		param_00 = 0;
	}

	return create_contents(!param_00,1,1,1,0,1);
}

//Function Number: 32
create_contents(param_00,param_01,param_02,param_03,param_04,param_05,param_06)
{
	var_07 = 0;
	if(isdefined(param_00) && param_00)
	{
		var_07 = var_07 + create_character_contents();
	}

	if(isdefined(param_01) && param_01)
	{
		var_07 = var_07 + create_world_contents();
	}

	if(isdefined(param_02) && param_02)
	{
		var_07 = var_07 + create_glass_contents();
	}

	if(isdefined(param_03) && param_03)
	{
		var_07 = var_07 + create_shotclip_contents();
	}

	if(isdefined(param_04) && param_04)
	{
		var_07 = var_07 + create_item_contents();
	}

	if(isdefined(param_05) && param_05)
	{
		var_07 = var_07 + create_vehicle_contents();
	}

	if(isdefined(param_06) && param_06)
	{
		var_07 = var_07 + create_playerclip_contents();
	}

	return var_07;
}

//Function Number: 33
create_all_contents()
{
	var_00 = ["physicscontents_solid","physicscontents_foliage","physicscontents_aiavoid","physicscontents_vehicletrigger","physicscontents_glass","physicscontents_water","physicscontents_canshootclip","physicscontents_missileclip","physicscontents_item","physicscontents_vehicleclip","physicscontents_itemclip","physicscontents_sky","physicscontents_ainosight","physicscontents_clipshot","physicscontents_actor","physicscontents_corpseclipshot","physicscontents_playerclip","physicscontents_monsterclip","physicscontents_sentienttrigger","physicscontents_teamtrigger","physicscontents_use","physicscontents_nonsentienttrigger","physicscontents_vehicle","physicscontents_mantle","physicscontents_player","physicscontents_corpse","physicscontents_detail","physicscontents_structural","physicscontents_translucent","physicscontents_playertrigger","physicscontents_nodrop"];
	return physics_createcontents(var_00);
}

//Function Number: 34
convert_surface_flag(param_00)
{
	var_01 = physics_getsurfacetypefromflags(param_00["surfaceflags"]);
	param_00["surfaceindex"] = var_01["index"];
	param_00["surfacetype"] = var_01["name"];
	return param_00;
}

//Function Number: 35
convert_capsule_data(param_00,param_01,param_02,param_03,param_04)
{
	if(!isdefined(param_04))
	{
		param_04 = (0,0,0);
	}

	var_05 = param_03 * 0.5;
	var_06 = anglestoforward(param_04);
	var_07 = anglestoup(param_04);
	var_08 = [];
	var_08["trace_start"] = param_00 + var_07 * var_05;
	if(isdefined(param_01))
	{
		var_08["trace_end"] = param_01 + var_07 * var_05;
	}

	var_08["radius"] = param_02;
	var_08["angles"] = param_04;
	var_08["half_height"] = var_05;
	return var_08;
}

//Function Number: 36
draw_trace(param_00,param_01,param_02,param_03)
{
}

//Function Number: 37
draw_trace_hit(param_00,param_01,param_02,param_03,param_04)
{
}

//Function Number: 38
draw_trace_type(param_00,param_01,param_02)
{
}

//Function Number: 39
internal_pack_default_trace(param_00)
{
	var_01 = [];
	var_01["fraction"] = 1;
	var_01["surfaceflags"] = 0;
	var_01["distance"] = 0;
	var_01["position"] = param_00;
	var_01["shape_position"] = param_00;
	var_01["normal"] = (0,0,0);
	var_01["contact_normal"] = (0,0,0);
	var_01["hittype"] = "hittype_none";
	return var_01;
}

//Function Number: 40
internal_create_debug_data(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08)
{
}