/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\killstreaks\_odin.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 48
 * Decompile Time: 2562 ms
 * Timestamp: 10/27/2023 12:29:12 AM
*******************************************************************/

//Function Number: 1
init()
{
	scripts\mp\killstreaks\_killstreaks::registerkillstreak("odin_support",::func_128F1);
	scripts\mp\killstreaks\_killstreaks::registerkillstreak("odin_assault",::func_128F1);
	level._effect["odin_clouds"] = loadfx("vfx/core/mp/killstreaks/odin/odin_parallax_clouds");
	level._effect["odin_fisheye"] = loadfx("vfx/code/screen/vfx_scrnfx_odin_fisheye.vfx");
	level._effect["odin_targeting"] = loadfx("vfx/core/mp/killstreaks/odin/vfx_marker_odin_cyan");
	level.var_C321 = [];
	level.var_C321["odin_support"] = spawnstruct();
	level.var_C321["odin_support"].timeout = 60;
	level.var_C321["odin_support"].streakname = "odin_support";
	level.var_C321["odin_support"].vehicleinfo = "odin_mp";
	level.var_C321["odin_support"].modelbase = "vehicle_odin_mp";
	level.var_C321["odin_support"].teamsplash = "used_odin_support";
	level.var_C321["odin_support"].votimedout = "odin_gone";
	level.var_C321["odin_support"].var_1352D = "odin_target_killed";
	level.var_C321["odin_support"].var_1352C = "odin_targets_killed";
	level.var_C321["odin_support"].var_12B20 = 1;
	level.var_C321["odin_support"].var_12B80 = &"KILLSTREAKS_ODIN_UNAVAILABLE";
	level.var_C321["odin_support"].var_394["airdrop"] = spawnstruct();
	level.var_C321["odin_support"].var_394["airdrop"].projectile = "odin_projectile_airdrop_mp";
	level.var_C321["odin_support"].var_394["airdrop"].var_E7BA = "smg_fire";
	level.var_C321["odin_support"].var_394["airdrop"].var_1E44 = "ui_odin_airdrop_ammo";
	level.var_C321["odin_support"].var_394["airdrop"].var_1AA0 = "airdrop_support";
	level.var_C321["odin_support"].var_394["airdrop"].var_DF5D = 20;
	level.var_C321["odin_support"].var_394["airdrop"].var_12B22 = -1;
	level.var_C321["odin_support"].var_394["airdrop"].var_13521 = "odin_carepackage";
	level.var_C321["odin_support"].var_394["airdrop"].var_D5E4 = "odin_carepack_ready";
	level.var_C321["odin_support"].var_394["airdrop"].var_D5DD = "odin_carepack_launch";
	level.var_C321["odin_support"].var_394["marking"] = spawnstruct();
	level.var_C321["odin_support"].var_394["marking"].projectile = "odin_projectile_marking_mp";
	level.var_C321["odin_support"].var_394["marking"].var_E7BA = "heavygun_fire";
	level.var_C321["odin_support"].var_394["marking"].var_1E44 = "ui_odin_marking_ammo";
	level.var_C321["odin_support"].var_394["marking"].var_DF5D = 4;
	level.var_C321["odin_support"].var_394["marking"].var_12B22 = -1;
	level.var_C321["odin_support"].var_394["marking"].var_1354C = "odin_marking";
	level.var_C321["odin_support"].var_394["marking"].var_1354B = "odin_marked";
	level.var_C321["odin_support"].var_394["marking"].var_1354A = "odin_m_marked";
	level.var_C321["odin_support"].var_394["marking"].var_D5E4 = "odin_flash_ready";
	level.var_C321["odin_support"].var_394["marking"].var_D5DD = "odin_flash_launch";
	level.var_C321["odin_support"].var_394["smoke"] = spawnstruct();
	level.var_C321["odin_support"].var_394["smoke"].projectile = "odin_projectile_smoke_mp";
	level.var_C321["odin_support"].var_394["smoke"].var_E7BA = "smg_fire";
	level.var_C321["odin_support"].var_394["smoke"].var_1E44 = "ui_odin_smoke_ammo";
	level.var_C321["odin_support"].var_394["smoke"].var_DF5D = 7;
	level.var_C321["odin_support"].var_394["smoke"].var_12B22 = -1;
	level.var_C321["odin_support"].var_394["smoke"].var_13551 = "odin_smoke";
	level.var_C321["odin_support"].var_394["smoke"].var_D5E4 = "odin_smoke_ready";
	level.var_C321["odin_support"].var_394["smoke"].var_D5DD = "odin_smoke_launch";
	level.var_C321["odin_support"].var_394["juggernaut"] = spawnstruct();
	level.var_C321["odin_support"].var_394["juggernaut"].projectile = "odin_projectile_smoke_mp";
	level.var_C321["odin_support"].var_394["juggernaut"].var_E7BA = "heavygun_fire";
	level.var_C321["odin_support"].var_394["juggernaut"].var_1E44 = "ui_odin_juggernaut_ammo";
	level.var_C321["odin_support"].var_394["juggernaut"].var_A4AF = "juggernaut_recon";
	level.var_C321["odin_support"].var_394["juggernaut"].var_DF5D = level.var_C321["odin_support"].timeout;
	level.var_C321["odin_support"].var_394["juggernaut"].var_12B22 = -1;
	level.var_C321["odin_support"].var_394["juggernaut"].var_12B23 = -2;
	level.var_C321["odin_support"].var_394["juggernaut"].var_12B21 = -3;
	level.var_C321["odin_support"].var_394["juggernaut"].var_1352B = "odin_moving";
	level.var_C321["odin_support"].var_394["juggernaut"].var_D5E4 = "null";
	level.var_C321["odin_support"].var_394["juggernaut"].var_D5DD = "odin_jugg_launch";
	level.var_C321["odin_assault"] = spawnstruct();
	level.var_C321["odin_assault"].timeout = 60;
	level.var_C321["odin_assault"].streakname = "odin_assault";
	level.var_C321["odin_assault"].vehicleinfo = "odin_mp";
	level.var_C321["odin_assault"].modelbase = "vehicle_odin_mp";
	level.var_C321["odin_assault"].teamsplash = "used_odin_assault";
	level.var_C321["odin_assault"].votimedout = "loki_gone";
	level.var_C321["odin_assault"].var_1352D = "odin_target_killed";
	level.var_C321["odin_assault"].var_1352C = "odin_targets_killed";
	level.var_C321["odin_assault"].var_12B20 = 2;
	level.var_C321["odin_assault"].var_12B80 = &"KILLSTREAKS_LOKI_UNAVAILABLE";
	level.var_C321["odin_assault"].var_394["airdrop"] = spawnstruct();
	level.var_C321["odin_assault"].var_394["airdrop"].projectile = "odin_projectile_airdrop_mp";
	level.var_C321["odin_assault"].var_394["airdrop"].var_E7BA = "smg_fire";
	level.var_C321["odin_assault"].var_394["airdrop"].var_1E44 = "ui_odin_airdrop_ammo";
	level.var_C321["odin_assault"].var_394["airdrop"].var_1AA0 = "airdrop_assault";
	level.var_C321["odin_assault"].var_394["airdrop"].var_DF5D = 20;
	level.var_C321["odin_assault"].var_394["airdrop"].var_12B22 = -1;
	level.var_C321["odin_assault"].var_394["airdrop"].var_13521 = "odin_carepackage";
	level.var_C321["odin_assault"].var_394["airdrop"].var_D5E4 = "odin_carepack_ready";
	level.var_C321["odin_assault"].var_394["airdrop"].var_D5DD = "odin_carepack_launch";
	level.var_C321["odin_assault"].var_394["large_rod"] = spawnstruct();
	level.var_C321["odin_assault"].var_394["large_rod"].projectile = "odin_projectile_large_rod_mp";
	level.var_C321["odin_assault"].var_394["large_rod"].var_E7BA = "heavygun_fire";
	level.var_C321["odin_assault"].var_394["large_rod"].var_1E44 = "ui_odin_marking_ammo";
	level.var_C321["odin_assault"].var_394["large_rod"].var_DF5D = 4;
	level.var_C321["odin_assault"].var_394["large_rod"].var_12B22 = -2;
	level.var_C321["odin_assault"].var_394["large_rod"].var_D5E4 = "null";
	level.var_C321["odin_assault"].var_394["large_rod"].var_D5DD = "ac130_105mm_fire";
	level.var_C321["odin_assault"].var_394["large_rod"].var_C195 = "ac130_105mm_fire_npc";
	level.var_C321["odin_assault"].var_394["small_rod"] = spawnstruct();
	level.var_C321["odin_assault"].var_394["small_rod"].projectile = "odin_projectile_small_rod_mp";
	level.var_C321["odin_assault"].var_394["small_rod"].var_E7BA = "smg_fire";
	level.var_C321["odin_assault"].var_394["small_rod"].var_1E44 = "ui_odin_smoke_ammo";
	level.var_C321["odin_assault"].var_394["small_rod"].var_DF5D = 2;
	level.var_C321["odin_assault"].var_394["small_rod"].var_12B22 = -2;
	level.var_C321["odin_assault"].var_394["small_rod"].var_D5E4 = "null";
	level.var_C321["odin_assault"].var_394["small_rod"].var_D5DD = "ac130_40mm_fire";
	level.var_C321["odin_assault"].var_394["small_rod"].var_C195 = "ac130_40mm_fire_npc";
	level.var_C321["odin_assault"].var_394["juggernaut"] = spawnstruct();
	level.var_C321["odin_assault"].var_394["juggernaut"].projectile = "odin_projectile_smoke_mp";
	level.var_C321["odin_assault"].var_394["juggernaut"].var_E7BA = "heavygun_fire";
	level.var_C321["odin_assault"].var_394["juggernaut"].var_1E44 = "ui_odin_juggernaut_ammo";
	level.var_C321["odin_assault"].var_394["juggernaut"].var_A4AF = "juggernaut";
	level.var_C321["odin_assault"].var_394["juggernaut"].var_DF5D = level.var_C321["odin_assault"].timeout;
	level.var_C321["odin_assault"].var_394["juggernaut"].var_12B22 = -1;
	level.var_C321["odin_assault"].var_394["juggernaut"].var_12B23 = -2;
	level.var_C321["odin_assault"].var_394["juggernaut"].var_12B21 = -3;
	level.var_C321["odin_assault"].var_394["juggernaut"].var_1352B = "odin_moving";
	level.var_C321["odin_assault"].var_394["juggernaut"].var_D5E4 = "null";
	level.var_C321["odin_assault"].var_394["juggernaut"].var_D5DD = "odin_jugg_launch";
	if(!isdefined(level.heli_pilot_mesh))
	{
		level.heli_pilot_mesh = getent("heli_pilot_mesh","targetname");
		if(!isdefined(level.heli_pilot_mesh))
		{
		}
		else
		{
			level.heli_pilot_mesh.origin = level.heli_pilot_mesh.origin + scripts\mp\_utility::gethelipilotmeshoffset();
		}
	}

	scripts\mp\agents\_agents::wait_till_agent_funcs_defined();
	level.agent_funcs["odin_juggernaut"] = level.agent_funcs["player"];
	level.agent_funcs["odin_juggernaut"]["think"] = ::scripts\engine\utility::empty_init_func;
	level.odin_marking_flash_radius_max = 800;
	level.odin_marking_flash_radius_min = 200;
	level.var_1639 = [];
}

//Function Number: 2
func_128F1(param_00,param_01)
{
	if(isdefined(self.underwater) && self.underwater)
	{
		return 0;
	}

	var_02 = param_01;
	var_03 = 1;
	if(scripts\mp\_utility::currentactivevehiclecount() >= scripts\mp\_utility::maxvehiclesallowed() || level.fauxvehiclecount + var_03 >= scripts\mp\_utility::maxvehiclesallowed())
	{
		self iprintlnbold(&"KILLSTREAKS_TOO_MANY_VEHICLES");
		return 0;
	}

	if(isdefined(level.var_1639[var_02]))
	{
		self iprintlnbold(level.var_C321[var_02].var_12B80);
		return 0;
	}

	scripts\mp\_utility::incrementfauxvehiclecount();
	var_04 = func_49F9(var_02);
	if(!isdefined(var_04))
	{
		scripts\mp\_utility::decrementfauxvehiclecount();
		return 0;
	}

	var_05 = func_10DD2(var_04);
	if(!isdefined(var_05))
	{
		var_05 = 0;
	}

	return var_05;
}

//Function Number: 3
watchhostmigrationfinishedinit(param_00)
{
	param_00 endon("disconnect");
	param_00 endon("joined_team");
	param_00 endon("joined_spectators");
	param_00 endon("killstreak_disowned");
	level endon("game_ended");
	self endon("death");
	for(;;)
	{
		level waittill("host_migration_end");
		param_00 setclientomnvar("ui_odin",level.var_C321[self.odintype].var_12B20);
		param_00 thermalvisionfofoverlayon();
		playfxontag(level._effect["odin_targeting"],self.targeting_marker,"tag_origin");
		self.targeting_marker showtoplayer(param_00);
	}
}

//Function Number: 4
func_49F9(param_00)
{
	var_01 = self.origin * (1,1,0) + level.heli_pilot_mesh.origin - scripts\mp\_utility::gethelipilotmeshoffset() * (0,0,1);
	var_02 = (0,0,0);
	var_03 = spawnhelicopter(self,var_01,var_02,level.var_C321[param_00].vehicleinfo,level.var_C321[param_00].modelbase);
	if(!isdefined(var_03))
	{
		return;
	}

	var_03.getclosestpointonnavmesh3d = 40;
	var_03.triggerportableradarping = self;
	var_03.team = self.team;
	var_03.odintype = param_00;
	level.var_1639[param_00] = 1;
	self.odin = var_03;
	var_03 thread func_C318();
	var_03 thread func_C31F();
	var_03 thread func_C31B();
	var_03 thread func_C31D();
	var_03 thread func_C31E();
	var_03 thread func_C319();
	var_03 thread func_C31A();
	var_03 thread func_C31C();
	var_03 thread func_C2DD();
	var_03 thread odin_onplayerconnect();
	var_03.triggerportableradarping scripts\mp\_matchdata::logkillstreakevent(level.var_C321[param_00].streakname,var_01);
	return var_03;
}

//Function Number: 5
func_10DD2(param_00)
{
	level endon("game_ended");
	param_00 endon("death");
	self.restoreangles = vectortoangles(anglestoforward(self.angles));
	func_C30E(param_00);
	if(getdvarint("camera_thirdPerson"))
	{
		scripts\mp\_utility::setthirdpersondof(0);
	}

	thread watchintrocleared(param_00);
	scripts\mp\_utility::freezecontrolswrapper(1);
	func_C320(param_00);
	thread scripts\mp\killstreaks\_juggernaut::func_55F4();
	var_01 = scripts\mp\killstreaks\_killstreaks::initridekillstreak(param_00.odintype);
	if(var_01 != "success")
	{
		if(isdefined(self.disabledweapon) && self.disabledweapon)
		{
			scripts\engine\utility::allow_weapon(1);
		}

		param_00 notify("death");
		return 0;
	}

	scripts\mp\_utility::freezecontrolswrapper(0);
	self remotecontrolvehicle(param_00);
	param_00 thread watchhostmigrationfinishedinit(self);
	param_00.odin_overlay_ent = function_01E1(level._effect["odin_fisheye"],self geteye(),self);
	triggerfx(param_00.odin_overlay_ent);
	param_00.odin_overlay_ent setfxkilldefondelete();
	level thread scripts\mp\_utility::teamplayercardsplash(level.var_C321[param_00.odintype].teamsplash,self);
	self thermalvisionfofoverlayon();
	thread func_1369B(param_00);
	return 1;
}

//Function Number: 6
func_1369B(param_00)
{
	self endon("disconnect");
	param_00 endon("death");
	wait(1);
	var_01 = scripts\mp\_utility::outlineenableforplayer(self,"cyan",self,0,0,"killstreak");
	param_00 thread removeoutline(var_01,self);
}

//Function Number: 7
func_C320(param_00)
{
	var_01 = spawn("script_model",param_00.origin + (0,0,3000));
	var_01.angles = vectortoangles((0,0,1));
	var_01 setmodel("tag_origin");
	var_01 thread waitanddelete(5);
	var_02 = "odin_zoom_up";
	var_03 = var_01 getentitynumber();
	var_04 = self getentitynumber();
	var_05 = bullettrace(self.origin,param_00.origin,0,self);
	if(var_05["surfacetype"] != "none")
	{
		var_02 = "odin_zoom_down";
		var_03 = param_00 getentitynumber();
		var_04 = var_01 getentitynumber();
	}

	var_06 = scripts\engine\utility::array_add(scripts\mp\_utility::get_players_watching(),self);
	foreach(var_08 in var_06)
	{
		var_08 setclientomnvar("cam_scene_name",var_02);
		var_08 setclientomnvar("cam_scene_lead",var_03);
		var_08 setclientomnvar("cam_scene_support",var_04);
		var_08 thread clouds();
	}
}

//Function Number: 8
waitanddelete(param_00)
{
	self endon("death");
	level endon("game_ended");
	wait(param_00);
	self delete();
}

//Function Number: 9
clouds()
{
	level endon("game_ended");
	var_00 = spawn("script_model",self.origin + (0,0,250));
	var_00.angles = vectortoangles((0,0,1));
	var_00 setmodel("tag_origin");
	var_00 thread waitanddelete(2);
	wait(0.1);
	playfxontagforclients(level._effect["odin_clouds"],var_00,"tag_origin",self);
}

//Function Number: 10
func_C30E(param_00)
{
	scripts\mp\_utility::setusingremote(param_00.odintype);
	self.odin = param_00;
}

//Function Number: 11
func_C2DA(param_00)
{
	param_00.odin_juggernautusetime = undefined;
	param_00.odin_markingusetime = undefined;
	param_00.odin_smokeusetime = undefined;
	param_00.odin_airdropusetime = undefined;
	param_00.odin_largerodusetime = undefined;
	param_00.odin_smallrodusetime = undefined;
	if(isdefined(self))
	{
		scripts\mp\_utility::clearusingremote();
		self.odin = undefined;
	}
}

//Function Number: 12
watchintrocleared(param_00)
{
	self endon("disconnect");
	self endon("joined_team");
	self endon("joined_spectators");
	level endon("game_ended");
	param_00 endon("death");
	self waittill("intro_cleared");
	self setclientomnvar("ui_odin",level.var_C321[param_00.odintype].var_12B20);
	watchearlyexit(param_00);
}

//Function Number: 13
func_C317(param_00)
{
	while(isdefined(self.var_9BE2) && param_00 > 0)
	{
		wait(0.05);
		param_00 = param_00 - 0.05;
	}
}

//Function Number: 14
func_C318()
{
	level endon("game_ended");
	self endon("gone");
	self waittill("death");
	if(isdefined(self.triggerportableradarping))
	{
		self.triggerportableradarping func_C2E3(self);
	}

	func_4074();
	func_C317(3);
	scripts\mp\_utility::decrementfauxvehiclecount();
	level.var_1639[self.odintype] = undefined;
	self delete();
}

//Function Number: 15
func_C31F()
{
	level endon("game_ended");
	self endon("death");
	self.triggerportableradarping endon("disconnect");
	self.triggerportableradarping endon("joined_team");
	self.triggerportableradarping endon("joined_spectators");
	var_00 = level.var_C321[self.odintype];
	var_01 = var_00.timeout;
	scripts\mp\_hostmigration::waitlongdurationwithhostmigrationpause(var_01);
	thread odin_leave();
}

//Function Number: 16
func_C31B()
{
	level endon("game_ended");
	self endon("death");
	self endon("leaving");
	self.triggerportableradarping scripts\engine\utility::waittill_any_3("disconnect","joined_team","joined_spectators");
	thread odin_leave();
}

//Function Number: 17
func_C319()
{
	level endon("game_ended");
	self endon("death");
	self endon("leaving");
	self.triggerportableradarping endon("disconnect");
	self.triggerportableradarping endon("joined_team");
	self.triggerportableradarping endon("joined_spectators");
	level waittill("objective_cam");
	thread odin_leave();
}

//Function Number: 18
func_C31D()
{
	self endon("death");
	self endon("leaving");
	self.triggerportableradarping endon("disconnect");
	self.triggerportableradarping endon("joined_team");
	self.triggerportableradarping endon("joined_spectators");
	level scripts\engine\utility::waittill_any_3("round_end_finished","game_ended");
	thread odin_leave();
}

//Function Number: 19
odin_leave()
{
	self endon("death");
	self notify("leaving");
	var_00 = level.var_C321[self.odintype];
	scripts\mp\_utility::leaderdialog(var_00.votimedout);
	if(isdefined(self.triggerportableradarping))
	{
		self.triggerportableradarping func_C2E3(self);
	}

	self notify("gone");
	func_4074();
	func_C317(3);
	scripts\mp\_utility::decrementfauxvehiclecount();
	level.var_1639[self.odintype] = undefined;
	self delete();
}

//Function Number: 20
func_C2E3(param_00)
{
	if(isdefined(param_00))
	{
		self setclientomnvar("ui_odin",-1);
		param_00 notify("end_remote");
		self notify("odin_ride_ended");
		func_C2DA(param_00);
		if(getdvarint("camera_thirdPerson"))
		{
			scripts\mp\_utility::setthirdpersondof(1);
		}

		self thermalvisionfofoverlayoff();
		self remotecontrolvehicleoff(param_00);
		self setplayerangles(self.restoreangles);
		thread func_C2EB();
		self stoplocalsound("odin_negative_action");
		self stoplocalsound("odin_positive_action");
		foreach(var_02 in level.var_C321[param_00.odintype].var_394)
		{
			if(isdefined(var_02.var_D5E4))
			{
				self stoplocalsound(var_02.var_D5E4);
			}

			if(isdefined(var_02.var_D5DD))
			{
				self stoplocalsound(var_02.var_D5DD);
			}
		}

		if(isdefined(param_00.var_A4A3))
		{
			param_00.var_A4A3 scripts\mp\bots\_bots_strategy::bot_guard_player(self,350);
		}
	}
}

//Function Number: 21
func_C2EB()
{
	self endon("disconnect");
	self endon("death");
	level endon("game_ended");
	scripts\mp\_utility::freezecontrolswrapper(1);
	wait(0.5);
	scripts\mp\_utility::freezecontrolswrapper(0);
}

//Function Number: 22
func_C31E()
{
	self endon("death");
	level endon("game_ended");
	var_00 = self.triggerportableradarping;
	var_00 endon("disconnect");
	var_01 = var_00 getvieworigin();
	var_02 = var_01 + anglestoforward(self gettagangles("tag_player")) * 10000;
	var_03 = bullettrace(var_01,var_02,0,self);
	var_04 = spawn("script_model",var_03["position"]);
	var_04.angles = vectortoangles((0,0,1));
	var_04 setmodel("tag_origin");
	self.targeting_marker = var_04;
	var_04 endon("death");
	var_05 = bullettrace(var_04.origin + (0,0,50),var_04.origin + (0,0,-100),0,var_04);
	var_04.origin = var_05["position"] + (0,0,50);
	var_04 hide();
	var_04 showtoplayer(var_00);
	var_04 childthread func_B9F2(var_00);
	thread func_10129();
	thread func_1399C();
	thread func_13AAF();
	switch(self.odintype)
	{
		case "odin_support":
			thread func_13B49();
			thread func_13ACA();
			break;

		case "odin_assault":
			thread func_13AB1();
			thread func_13B47();
			break;
	}

	self setotherent(var_04);
}

//Function Number: 23
func_B9F2(param_00)
{
	wait(1.5);
	var_01 = [];
	for(;;)
	{
		var_02 = param_00 scripts\mp\_utility::get_players_watching();
		foreach(var_04 in var_01)
		{
			if(!scripts\engine\utility::array_contains(var_02,var_04))
			{
				var_01 = scripts\engine\utility::array_remove(var_01,var_04);
				self hide();
				self showtoplayer(param_00);
			}
		}

		foreach(var_04 in var_02)
		{
			self showtoplayer(var_04);
			if(!scripts\engine\utility::array_contains(var_01,var_04))
			{
				var_01 = scripts\engine\utility::array_add(var_01,var_04);
				stopfxontag(level._effect["odin_targeting"],self,"tag_origin");
				wait(0.05);
				playfxontag(level._effect["odin_targeting"],self,"tag_origin");
			}
		}

		wait(0.25);
	}
}

//Function Number: 24
func_1399C()
{
	self endon("death");
	level endon("game_ended");
	var_00 = self.triggerportableradarping;
	var_00 endon("disconnect");
	var_01 = level.var_C321[self.odintype].var_394["airdrop"];
	self.odin_airdropusetime = 0;
	var_00 setclientomnvar(var_01.var_1E44,level.var_C321[self.odintype].var_12B20);
	if(!isai(var_00))
	{
		var_00 notifyonplayercommand("airdrop_action","+smoke");
	}

	for(;;)
	{
		var_00 waittill("airdrop_action");
		if(isdefined(level.hostmigrationtimer))
		{
			continue;
		}

		if(!isdefined(var_00.odin))
		{
			return;
		}

		if(gettime() >= self.odin_airdropusetime)
		{
			if(level.teambased)
			{
				scripts\mp\_utility::leaderdialog(var_01.var_13521,self.team);
			}
			else
			{
				var_00 scripts\mp\_utility::leaderdialogonplayer(var_01.var_13521);
			}

			self.odin_airdropusetime = func_C2E6("airdrop");
			var_01 = level.var_C321[self.odintype].var_394["airdrop"];
			level thread scripts\mp\killstreaks\_airdrop::doflyby(var_00,self.targeting_marker.origin,randomfloat(360),var_01.var_1AA0);
		}
		else
		{
			var_00 scripts\mp\_utility::_playlocalsound("odin_negative_action");
		}

		wait(1);
	}
}

//Function Number: 25
func_13B49()
{
	self endon("death");
	level endon("game_ended");
	var_00 = self.triggerportableradarping;
	var_00 endon("disconnect");
	var_01 = level.var_C321[self.odintype].var_394["smoke"];
	self.odin_smokeusetime = 0;
	var_00 setclientomnvar(var_01.var_1E44,level.var_C321[self.odintype].var_12B20);
	if(!isai(var_00))
	{
		var_00 notifyonplayercommand("smoke_action","+speed_throw");
		var_00 notifyonplayercommand("smoke_action","+ads_akimbo_accessible");
		if(!level.console)
		{
			var_00 notifyonplayercommand("smoke_action","+toggleads_throw");
		}
	}

	for(;;)
	{
		var_00 waittill("smoke_action");
		if(isdefined(level.hostmigrationtimer))
		{
			continue;
		}

		if(!isdefined(var_00.odin))
		{
			return;
		}

		if(gettime() >= self.odin_smokeusetime)
		{
			if(level.teambased)
			{
				scripts\mp\_utility::leaderdialog(var_01.var_13551,self.team);
			}
			else
			{
				var_00 scripts\mp\_utility::leaderdialogonplayer(var_01.var_13551);
			}

			self.odin_smokeusetime = func_C2E6("smoke");
		}
		else
		{
			var_00 scripts\mp\_utility::_playlocalsound("odin_negative_action");
		}

		wait(1);
	}
}

//Function Number: 26
func_13ACA()
{
	self endon("death");
	level endon("game_ended");
	var_00 = self.triggerportableradarping;
	var_00 endon("disconnect");
	var_01 = level.var_C321[self.odintype].var_394["marking"];
	self.odin_markingusetime = 0;
	var_00 setclientomnvar(var_01.var_1E44,level.var_C321[self.odintype].var_12B20);
	if(!isai(var_00))
	{
		var_00 notifyonplayercommand("marking_action","+attack");
		var_00 notifyonplayercommand("marking_action","+attack_akimbo_accessible");
	}

	for(;;)
	{
		var_00 waittill("marking_action");
		if(isdefined(level.hostmigrationtimer))
		{
			continue;
		}

		if(!isdefined(var_00.odin))
		{
			return;
		}

		if(gettime() >= self.odin_markingusetime)
		{
			self.odin_markingusetime = func_C2E6("marking");
			thread func_58EE(self.targeting_marker.origin + (0,0,10));
		}
		else
		{
			var_00 scripts\mp\_utility::_playlocalsound("odin_negative_action");
		}

		wait(1);
	}
}

//Function Number: 27
func_13AAF()
{
	self endon("death");
	level endon("game_ended");
	var_00 = self.triggerportableradarping;
	var_00 endon("disconnect");
	var_00 endon("juggernaut_dead");
	var_01 = level.var_C321[self.odintype].var_394["juggernaut"];
	self.odin_juggernautusetime = 0;
	var_00 setclientomnvar(var_01.var_1E44,level.var_C321[self.odintype].var_12B20);
	if(!isai(var_00))
	{
		var_00 notifyonplayercommand("juggernaut_action","+frag");
	}

	for(;;)
	{
		var_00 waittill("juggernaut_action");
		if(isdefined(level.hostmigrationtimer))
		{
			continue;
		}

		if(!isdefined(var_00.odin))
		{
			return;
		}

		if(gettime() >= self.odin_juggernautusetime)
		{
			var_02 = func_7F26(self.targeting_marker.origin);
			if(isdefined(var_02))
			{
				self.odin_juggernautusetime = func_C2E6("juggernaut");
				thread func_1369E(var_02);
			}
			else
			{
				var_00 scripts\mp\_utility::_playlocalsound("odin_negative_action");
			}
		}
		else if(isdefined(self.var_A4A3))
		{
			var_02 = func_7F25(self.targeting_marker.origin);
			if(isdefined(var_02))
			{
				var_00 scripts\mp\_utility::leaderdialogonplayer(var_01.var_1352B);
				var_00 scripts\mp\_utility::_playlocalsound("odin_positive_action");
				var_00 playrumbleonentity("pistol_fire");
				self.var_A4A3 scripts\mp\bots\_bots_strategy::bot_protect_point(var_02.origin,128);
				var_00 setclientomnvar(var_01.var_1E44,level.var_C321[self.odintype].var_12B20);
			}
			else
			{
				var_00 scripts\mp\_utility::_playlocalsound("odin_negative_action");
			}
		}

		wait(1.1);
		if(isdefined(self.var_A4A3))
		{
			var_00 setclientomnvar(var_01.var_1E44,var_01.var_12B23);
		}
	}
}

//Function Number: 28
func_13AB1()
{
	self endon("death");
	level endon("game_ended");
	var_00 = self.triggerportableradarping;
	var_00 endon("disconnect");
	var_01 = level.var_C321[self.odintype].var_394["large_rod"];
	self.odin_largerodusetime = 0;
	var_00 setclientomnvar(var_01.var_1E44,level.var_C321[self.odintype].var_12B20);
	if(!isai(var_00))
	{
		var_00 notifyonplayercommand("large_rod_action","+attack");
		var_00 notifyonplayercommand("large_rod_action","+attack_akimbo_accessible");
	}

	for(;;)
	{
		var_00 waittill("large_rod_action");
		if(isdefined(level.hostmigrationtimer))
		{
			continue;
		}

		if(!isdefined(var_00.odin))
		{
			return;
		}

		if(gettime() >= self.odin_largerodusetime)
		{
			self.odin_largerodusetime = func_C2E6("large_rod");
		}
		else
		{
			var_00 scripts\mp\_utility::_playlocalsound("odin_negative_action");
		}

		wait(1);
	}
}

//Function Number: 29
func_13B47()
{
	self endon("death");
	level endon("game_ended");
	var_00 = self.triggerportableradarping;
	var_00 endon("disconnect");
	var_01 = level.var_C321[self.odintype].var_394["small_rod"];
	self.odin_smallrodusetime = 0;
	var_00 setclientomnvar(var_01.var_1E44,level.var_C321[self.odintype].var_12B20);
	if(!isai(var_00))
	{
		var_00 notifyonplayercommand("small_rod_action","+speed_throw");
		var_00 notifyonplayercommand("small_rod_action","+ads_akimbo_accessible");
		if(!level.console)
		{
			var_00 notifyonplayercommand("small_rod_action","+toggleads_throw");
		}
	}

	for(;;)
	{
		var_00 waittill("small_rod_action");
		if(isdefined(level.hostmigrationtimer))
		{
			continue;
		}

		if(!isdefined(var_00.odin))
		{
			return;
		}

		if(gettime() >= self.odin_smallrodusetime)
		{
			self.odin_smallrodusetime = func_C2E6("small_rod");
		}
		else
		{
			var_00 scripts\mp\_utility::_playlocalsound("odin_negative_action");
		}

		wait(1);
	}
}

//Function Number: 30
func_C2E6(param_00)
{
	self.var_9BE2 = 1;
	var_01 = self.triggerportableradarping;
	var_02 = level.var_C321[self.odintype].var_394[param_00];
	var_03 = anglestoforward(var_01 getplayerangles());
	var_04 = self.origin + var_03 * 100;
	var_01 setclientomnvar(var_02.var_1E44,var_02.var_12B22);
	thread func_13B21(var_02);
	var_05 = self.targeting_marker.origin;
	var_06 = gettime() + var_02.var_DF5D * 1000;
	if(param_00 == "large_rod")
	{
		wait(0.5);
		var_01 playrumbleonentity(var_02.var_E7BA);
		earthquake(0.3,1.5,self.origin,1000);
		var_01 playsoundtoplayer(var_02.var_D5DD,var_01);
		playsoundatpos(self.origin,var_02.var_C195);
		wait(1.5);
	}
	else if(param_00 == "small_rod")
	{
		wait(0.5);
		var_01 playrumbleonentity(var_02.var_E7BA);
		earthquake(0.2,1,self.origin,1000);
		var_01 playsoundtoplayer(var_02.var_D5DD,var_01);
		playsoundatpos(self.origin,var_02.var_C195);
		wait(0.3);
	}
	else
	{
		if(isdefined(var_02.var_D5DD))
		{
			var_01 playsoundtoplayer(var_02.var_D5DD,var_01);
		}

		if(isdefined(var_02.var_C195))
		{
			playsoundatpos(self.origin,var_02.var_C195);
		}

		var_01 playrumbleonentity(var_02.var_E7BA);
	}

	var_07 = scripts\mp\_utility::_magicbullet(var_02.projectile,var_04,var_05,var_01);
	var_07.type = "odin";
	var_07 thread func_13A22(param_00);
	if(param_00 == "smoke" || param_00 == "juggernaut" || param_00 == "large_rod")
	{
		level notify("smoke",var_07,var_02.projectile);
	}

	self.var_9BE2 = undefined;
	return var_06;
}

//Function Number: 31
func_13A22(param_00)
{
	self waittill("explode",var_01);
	if(param_00 == "small_rod")
	{
		playrumbleonposition("grenade_rumble",var_01);
		earthquake(0.7,1,var_01,1000);
		return;
	}

	if(param_00 == "large_rod")
	{
		playrumbleonposition("artillery_rumble",var_01);
		earthquake(1,1,var_01,2000);
	}
}

//Function Number: 32
func_7F26(param_00)
{
	if(!isdefined(param_00))
	{
		return;
	}

	var_01 = getnodesinradiussorted(param_00,256,0,128,"Path");
	if(!isdefined(var_01[0]))
	{
		return;
	}

	return var_01[0];
}

//Function Number: 33
func_7F25(param_00)
{
	if(!isdefined(param_00))
	{
		return;
	}

	var_01 = getnodesinradiussorted(param_00,128,0,64,"Path");
	if(!isdefined(var_01[0]))
	{
		return;
	}

	return var_01[0];
}

//Function Number: 34
func_1369E(param_00)
{
	self endon("death");
	level endon("game_ended");
	var_01 = self.triggerportableradarping;
	var_01 endon("disconnect");
	var_02 = self.targeting_marker.origin;
	wait(3);
	var_03 = scripts\mp\agents\_agents::add_humanoid_agent("odin_juggernaut",var_01.team,"class1",param_00.origin,vectortoangles(var_02 - param_00.origin),var_01,0,0,"veteran");
	if(isdefined(var_03))
	{
		var_04 = level.var_C321[self.odintype].var_394["juggernaut"];
		var_03 thread scripts\mp\killstreaks\_juggernaut::givejuggernaut(var_04.var_A4AF);
		var_03 thread scripts\mp\killstreaks\_agent_killstreak::sendagentweaponnotify();
		var_03 scripts\mp\bots\_bots_strategy::bot_protect_point(param_00.origin,128);
		self.var_A4A3 = var_03;
		thread func_13AAE();
		var_01 setclientomnvar(var_04.var_1E44,var_04.var_12B23);
		var_05 = scripts\mp\_utility::outlineenableforplayer(var_03,"cyan",self.triggerportableradarping,0,0,"killstreak");
		thread removeoutline(var_05,var_03);
		var_03 scripts\mp\_utility::_setnameplatematerial("player_name_bg_green_agent","player_name_bg_red_agent");
		return;
	}

	var_01 iprintlnbold(&"KILLSTREAKS_AGENT_MAX");
}

//Function Number: 35
func_13AAE()
{
	self endon("death");
	level endon("game_ended");
	self.var_A4A3 waittill("death");
	self.triggerportableradarping notify("juggernaut_dead");
	var_00 = level.var_C321[self.odintype].var_394["juggernaut"];
	self.triggerportableradarping setclientomnvar(var_00.var_1E44,var_00.var_12B21);
	self.var_A4A3 = undefined;
}

//Function Number: 36
func_10129()
{
	self endon("death");
	wait(1);
	playfxontag(level._effect["odin_targeting"],self.targeting_marker,"tag_origin");
}

//Function Number: 37
func_13B21(param_00)
{
	self endon("death");
	level endon("game_ended");
	var_01 = self.triggerportableradarping;
	var_01 endon("disconnect");
	var_01 endon("odin_ride_ended");
	var_02 = param_00.var_1E44;
	var_03 = param_00.var_DF5D;
	var_04 = param_00.var_D5E4;
	var_05 = level.var_C321[self.odintype].var_12B20;
	wait(var_03);
	if(!isdefined(var_01.odin))
	{
		return;
	}

	if(isdefined(var_04))
	{
		var_01 scripts\mp\_utility::_playlocalsound(var_04);
	}

	var_01 setclientomnvar(var_02,var_05);
}

//Function Number: 38
func_58EE(param_00)
{
	level endon("game_ended");
	var_01 = self.triggerportableradarping;
	var_02 = level.odin_marking_flash_radius_max * level.odin_marking_flash_radius_max;
	var_03 = level.odin_marking_flash_radius_min * level.odin_marking_flash_radius_min;
	var_04 = 60;
	var_05 = 40;
	var_06 = 11;
	var_07 = 0;
	foreach(var_09 in level.participants)
	{
		if(!scripts\mp\_utility::isreallyalive(var_09) || var_09.sessionstate != "playing")
		{
			continue;
		}

		if(level.teambased && var_09.team == self.team)
		{
			continue;
		}

		var_0A = distancesquared(param_00,var_09.origin);
		if(var_0A > var_02)
		{
			continue;
		}

		var_0B = var_09 getstance();
		var_0C = var_09.origin;
		switch(var_0B)
		{
			case "stand":
				var_0C = (var_0C[0],var_0C[1],var_0C[2] + var_04);
				break;

			case "crouch":
				var_0C = (var_0C[0],var_0C[1],var_0C[2] + var_05);
				break;

			case "prone":
				var_0C = (var_0C[0],var_0C[1],var_0C[2] + var_06);
				break;
		}

		if(!bullettracepassed(param_00,var_0C,0,var_09))
		{
			continue;
		}

		if(var_0A <= var_03)
		{
			var_0D = 1;
		}
		else
		{
			var_0D = 1 - var_0A - var_03 / var_02 - var_03;
		}

		var_0E = anglestoforward(var_09 getplayerangles());
		var_0F = param_00 - var_0C;
		var_0F = vectornormalize(var_0F);
		var_10 = 0.5 * 1 + vectordot(var_0E,var_0F);
		var_11 = 1;
		var_09 notify("flashbang",param_00,var_0D,var_10,var_01,var_11);
		var_07++;
		if(!func_6565(var_09))
		{
			if(level.teambased)
			{
				var_12 = scripts\mp\_utility::outlineenableforteam(var_09,"orange",self.team,0,0,"killstreak");
			}
			else
			{
				var_12 = scripts\mp\_utility::outlineenableforplayer(var_0A,"orange",self.triggerportableradarping,0,0,"killstreak");
			}

			thread removeoutline(var_12,var_09,3);
		}
	}

	var_14 = level.var_C321[self.odintype].var_394["marking"];
	if(var_07 == 1)
	{
		if(level.teambased)
		{
			scripts\mp\_utility::leaderdialog(var_14.var_1354B,self.team);
		}
		else
		{
			var_01 scripts\mp\_utility::leaderdialogonplayer(var_14.var_1354B);
		}
	}
	else if(var_07 > 1)
	{
		if(level.teambased)
		{
			scripts\mp\_utility::leaderdialog(var_14.var_1354A,self.team);
		}
		else
		{
			var_01 scripts\mp\_utility::leaderdialogonplayer(var_14.var_1354A);
		}
	}

	var_15 = scripts\mp\_weapons::getempdamageents(param_00,512,0);
	foreach(var_17 in var_15)
	{
		if(isdefined(var_17.triggerportableradarping) && !scripts\mp\_weapons::friendlyfirecheck(self.triggerportableradarping,var_17.triggerportableradarping))
		{
			continue;
		}

		var_17 notify("emp_damage",self.triggerportableradarping,8);
	}
}

//Function Number: 39
func_20D2(param_00)
{
	if(level.teambased && param_00.team == self.team)
	{
		return;
	}
	else if(!level.teambased && param_00 == self.triggerportableradarping)
	{
		return;
	}

	if(func_6565(param_00))
	{
		return;
	}

	var_01 = scripts\mp\_utility::outlineenableforplayer(param_00,"orange",self.triggerportableradarping,1,0,"killstreak");
	thread removeoutline(var_01,param_00);
}

//Function Number: 40
func_6565(param_00)
{
	return param_00 scripts\mp\_utility::_hasperk("specialty_noplayertarget");
}

//Function Number: 41
removeoutline(param_00,param_01,param_02)
{
	if(isdefined(param_01))
	{
		param_01 endon("disconnect");
	}

	level endon("game_ended");
	var_03 = ["leave","death"];
	if(isdefined(param_02))
	{
		scripts\engine\utility::waittill_any_in_array_or_timeout_no_endon_death(var_03,param_02);
	}
	else
	{
		scripts\engine\utility::waittill_any_in_array_return_no_endon_death(var_03);
	}

	if(isdefined(param_01))
	{
		scripts\mp\_utility::outlinedisable(param_00,param_01);
	}
}

//Function Number: 42
func_C31A()
{
	self endon("death");
	level endon("game_ended");
	foreach(var_01 in level.participants)
	{
		func_20D2(var_01);
	}
}

//Function Number: 43
func_C31C()
{
	self endon("death");
	level endon("game_ended");
	self.enemieskilledintimewindow = 0;
	for(;;)
	{
		level waittill("odin_killed_player",var_00);
		self.var_63AB++;
		self notify("odin_enemy_killed");
	}
}

//Function Number: 44
func_C2DD(param_00)
{
	self endon("death");
	level endon("game_ended");
	var_01 = level.var_C321[self.odintype];
	var_02 = 1;
	for(;;)
	{
		self waittill("odin_enemy_killed");
		wait(var_02);
		if(self.enemieskilledintimewindow > 1)
		{
			self.triggerportableradarping scripts\mp\_utility::leaderdialogonplayer(var_01.var_1352C);
		}
		else
		{
			self.triggerportableradarping scripts\mp\_utility::leaderdialogonplayer(var_01.var_1352D);
		}

		self.enemieskilledintimewindow = 0;
	}
}

//Function Number: 45
odin_onplayerconnect()
{
	self endon("death");
	level endon("game_ended");
	for(;;)
	{
		level waittill("connected",var_00);
		var_00 thread odin_onplayerspawned(self);
	}
}

//Function Number: 46
odin_onplayerspawned(param_00)
{
	self endon("disconnect");
	self waittill("spawned_player");
	param_00 func_20D2(self);
}

//Function Number: 47
func_4074()
{
	if(isdefined(self.targeting_marker))
	{
		self.targeting_marker delete();
	}

	if(isdefined(self.odin_overlay_ent))
	{
		self.odin_overlay_ent delete();
	}
}

//Function Number: 48
watchearlyexit(param_00)
{
	level endon("game_ended");
	param_00 endon("death");
	param_00 thread scripts\mp\killstreaks\_killstreaks::allowridekillstreakplayerexit();
	param_00 waittill("killstreakExit");
	var_01 = level.var_C321[param_00.odintype];
	scripts\mp\_utility::leaderdialog(var_01.votimedout);
	param_00 notify("death");
}