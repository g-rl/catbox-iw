/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\killstreaks\_orbital_deployment.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 39
 * Decompile Time: 2390 ms
 * Timestamp: 10/27/2023 12:29:15 AM
*******************************************************************/

//Function Number: 1
init()
{
	level.rockets = [];
	level.remotekillstreaks["explode"] = loadfx("vfx/core/expl/aerial_explosion");
	scripts\mp\killstreaks\_killstreaks::registerkillstreak("orbital_deployment",::func_128F2);
	level._effect["odin_clouds"] = loadfx("vfx/core/mp/killstreaks/odin/odin_parallax_clouds");
	level._effect["odin_fisheye"] = loadfx("vfx/code/screen/vfx_scrnfx_odin_fisheye.vfx");
	level._effect["odin_targeting"] = loadfx("vfx/core/mp/killstreaks/odin/vfx_marker_good_target");
	level._effect["odin_targeting_bad"] = loadfx("vfx/core/mp/killstreaks/odin/vfx_marker_bad_target");
	level._effect["phase_out_friendly"] = loadfx("vfx/core/mp/killstreaks/vfx_phase_orbital_deployment_friendly");
	level._effect["phase_out_enemy"] = loadfx("vfx/core/mp/killstreaks/vfx_phase_orbital_deployment_enemy");
	level._effect["drop_pod_atmo"] = loadfx("vfx/core/expl/emp_flash_mp");
	level._effect["drop_pod_fx"] = loadfx("vfx/core/mp/killstreaks/odin/vfx_odin_flash_small");
	level.var_C6D7 = [];
	level.var_C6D7["orbital_deployment"] = spawnstruct();
	level.var_C6D7["orbital_deployment"].timeout = 60;
	level.var_C6D7["orbital_deployment"].streakname = "orbital_deployment";
	level.var_C6D7["orbital_deployment"].vehicleinfo = "odin_mp";
	level.var_C6D7["orbital_deployment"].modelbase = "vehicle_odin_mp";
	level.var_C6D7["orbital_deployment"].teamsplash = "used_orbital_deployment";
	level.var_C6D7["orbital_deployment"].votimedout = "odin_gone";
	level.var_C6D7["orbital_deployment"].var_1352D = "odin_target_killed";
	level.var_C6D7["orbital_deployment"].var_1352C = "odin_targets_killed";
	level.var_C6D7["orbital_deployment"].var_12B20 = 3;
	level.var_C6D7["orbital_deployment"].var_12B80 = &"KILLSTREAKS_ODIN_UNAVAILABLE";
	level.var_C6D7["orbital_deployment"].var_394["juggernaut"] = spawnstruct();
	level.var_C6D7["orbital_deployment"].var_394["juggernaut"].var_D5E4 = "null";
	level.var_C6D7["orbital_deployment"].var_394["juggernaut"].var_D5DD = "odin_jugg_launch";
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

	level.var_163A = [];
}

//Function Number: 2
func_128F2(param_00)
{
	self endon("disconnect");
	var_01 = param_00.var_98F2;
	if(isdefined(self.underwater) && self.underwater)
	{
		return 0;
	}

	var_02 = func_10DD3(param_00.streakname);
	if(!isdefined(var_02))
	{
		var_02 = 0;
	}

	return var_02;
}

//Function Number: 3
func_10DD3(param_00,param_01)
{
	level endon("game_ended");
	if(!isdefined(param_01))
	{
		param_01 = 0;
	}

	self.restoreangles = vectortoangles(anglestoforward(self.angles));
	func_C6CB();
	if(param_01 == 1)
	{
		scripts\engine\utility::allow_usability(0);
		scripts\engine\utility::allow_weapon_switch(0);
		scripts\mp\_utility::incrementfauxvehiclecount();
		var_02 = func_49FB();
		if(!isdefined(var_02))
		{
			scripts\engine\utility::allow_weapon_switch(1);
			scripts\mp\_utility::decrementfauxvehiclecount();
			return 0;
		}

		self remotecontrolvehicle(var_02);
	}
	else
	{
		scripts\engine\utility::allow_usability(0);
		scripts\engine\utility::allow_weapon_switch(0);
		var_03 = scripts\mp\killstreaks\_mapselect::_meth_8112(param_00);
		if(!isdefined(var_03))
		{
			func_C6C4();
			scripts\engine\utility::allow_usability(1);
			scripts\engine\utility::allow_weapon_switch(1);
			return 0;
		}

		func_10DD4(var_03[0].location,var_03[0].location + (0,0,10000),param_00);
	}

	return 1;
}

//Function Number: 4
func_49FB()
{
	var_00 = (0,0,0);
	var_01 = self.origin * (1,1,0) + level.heli_pilot_mesh.origin - scripts\mp\_utility::gethelipilotmeshoffset() * (0,0,1);
	var_02 = spawnhelicopter(self,var_01,var_00,level.var_C6D7["orbital_deployment"].vehicleinfo,level.var_C6D7["orbital_deployment"].modelbase);
	if(!isdefined(var_02))
	{
		return;
	}

	var_02.getclosestpointonnavmesh3d = 40;
	var_02.triggerportableradarping = self;
	var_02.team = self.team;
	var_02.streakname = "orbital_deployment";
	level.var_163A["orbital_deployment"] = 1;
	self.var_98FF = 1;
	self.var_A641 = 0;
	self.var_C6C3 = var_02;
	var_02 thread func_C6D4();
	var_02 thread func_C6D3();
	var_02 thread func_C6D0();
	var_02 thread func_C6D2();
	return var_02;
}

//Function Number: 5
func_C6D4()
{
	self endon("death");
	level endon("game_ended");
	var_00 = self.triggerportableradarping;
	var_00 endon("disconnect");
	var_00 endon("juggernaut_dead");
	if(!isai(var_00))
	{
		var_00 notifyonplayercommand("orbital_deployment_action","+attack");
		var_00 notifyonplayercommand("orbital_deployment_action","+attack_akimbo_accessible");
	}

	for(;;)
	{
		var_00 waittill("orbital_deployment_action");
		if(scripts\mp\_utility::istrue(self.targeting_marker.var_EA21))
		{
			var_00 setclientomnvar("ui_odin",-1);
			var_00 func_10DD4(self.targeting_marker.origin,self.origin,self.streakname);
			var_00 remotecontrolvehicleoff(self);
			func_4074();
			self notify("death");
			break;
		}
		else
		{
			var_00 scripts\mp\_utility::_playlocalsound("odin_negative_action");
		}

		wait(1.1);
	}
}

//Function Number: 6
func_7E6A(param_00)
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

//Function Number: 7
func_C6D3()
{
	level endon("game_ended");
	self endon("death");
	self.triggerportableradarping endon("disconnect");
	self.triggerportableradarping endon("joined_team");
	self.triggerportableradarping endon("joined_spectators");
	var_00 = level.var_C6D7["orbital_deployment"];
	scripts\mp\_hostmigration::waitlongdurationwithhostmigrationpause(var_00.timeout);
	thread func_C6C7();
}

//Function Number: 8
func_C6D0()
{
	level endon("game_ended");
	self endon("death");
	self endon("leaving");
	self.triggerportableradarping scripts\engine\utility::waittill_any_3("disconnect","joined_team","joined_spectators");
	thread func_C6C7();
}

//Function Number: 9
func_C6D2()
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
	self setotherent(var_04);
}

//Function Number: 10
func_B9F2(param_00)
{
	param_00 endon("disconnect");
	self endon("death");
	level endon("game_ended");
	wait(1.5);
	var_01 = [];
	for(;;)
	{
		var_02 = func_7E6A(self.origin);
		if(isdefined(var_02))
		{
			self.var_EA21 = 1;
			stopfxontag(level._effect["odin_targeting_bad"],self,"tag_origin");
			wait(0.05);
			playfxontag(level._effect["odin_targeting"],self,"tag_origin");
		}
		else
		{
			self.var_EA21 = 0;
			stopfxontag(level._effect["odin_targeting"],self,"tag_origin");
			wait(0.05);
			playfxontag(level._effect["odin_targeting_bad"],self,"tag_origin");
		}

		var_03 = param_00 scripts\mp\_utility::get_players_watching();
		foreach(var_05 in var_01)
		{
			if(!scripts\engine\utility::array_contains(var_03,var_05))
			{
				var_01 = scripts\engine\utility::array_remove(var_01,var_05);
				self hide();
				self showtoplayer(param_00);
			}
		}

		foreach(var_05 in var_03)
		{
			self showtoplayer(var_05);
			if(!scripts\engine\utility::array_contains(var_01,var_05))
			{
				var_01 = scripts\engine\utility::array_add(var_01,var_05);
				stopfxontag(level._effect["odin_targeting"],self,"tag_origin");
				wait(0.05);
				playfxontag(level._effect["odin_targeting"],self,"tag_origin");
			}
		}

		wait(0.05);
	}
}

//Function Number: 11
func_10129()
{
	self endon("death");
	wait(1);
	var_00 = func_7E6A(self.targeting_marker.origin);
	if(isdefined(var_00))
	{
		playfxontag(level._effect["odin_targeting"],self.targeting_marker,"tag_origin");
		return;
	}

	playfxontag(level._effect["odin_targeting_bad"],self.targeting_marker,"tag_origin");
}

//Function Number: 12
func_C6C7(param_00)
{
	self endon("death");
	self notify("leaving");
	var_01 = level.var_C6D7["orbital_deployment"];
	scripts\mp\_utility::leaderdialog(var_01.votimedout);
	if(isdefined(self.triggerportableradarping))
	{
		self.triggerportableradarping func_C6C5(self,param_00);
	}

	self notify("gone");
	func_4074();
	func_C6CC(3);
	scripts\mp\_utility::decrementfauxvehiclecount();
	level.var_163A["orbital_deployment"] = undefined;
	self delete();
}

//Function Number: 13
func_4074()
{
	if(isdefined(self.targeting_marker))
	{
		self.targeting_marker delete();
	}

	if(isdefined(self.var_C6CA))
	{
		self.var_C6CA delete();
	}
}

//Function Number: 14
func_C6CC(param_00)
{
	while(isdefined(self.var_9BE2) && param_00 > 0)
	{
		wait(0.05);
		param_00 = param_00 - 0.05;
	}
}

//Function Number: 15
func_C6C5(param_00,param_01)
{
	if(isdefined(param_00))
	{
		self setclientomnvar("ui_odin",-1);
		param_00 notify("end_remote");
		self notify("odin_ride_ended");
		func_C6C4();
		if(getdvarint("camera_thirdPerson"))
		{
			scripts\mp\_utility::setthirdpersondof(1);
		}

		self thermalvisionfofoverlayoff();
		self remotecontrolvehicleoff(param_00);
		self setplayerangles(self.restoreangles);
		if(isdefined(param_01) && param_01)
		{
			func_108F5();
			self.var_A641 = 0;
			scripts\engine\utility::allow_weapon(1);
			self notify("weapon_change",self getcurrentweapon());
		}

		self stoplocalsound("odin_negative_action");
		self stoplocalsound("odin_positive_action");
		foreach(var_03 in level.var_C6D7["orbital_deployment"].var_394)
		{
			if(isdefined(var_03.var_D5E4))
			{
				self stoplocalsound(var_03.var_D5E4);
			}

			if(isdefined(var_03.var_D5DD))
			{
				self stoplocalsound(var_03.var_D5DD);
			}
		}

		if(isdefined(param_00.var_A4A3))
		{
			param_00.var_A4A3 scripts\mp\bots\_bots_strategy::bot_guard_player(self,350);
		}

		self notify("stop_odin");
	}
}

//Function Number: 16
func_108F5()
{
	self.var_98FF = 0;
	var_00 = self [[ level.getspawnpoint ]]();
	var_01 = var_00.origin;
	var_02 = var_00.angles;
	self.angles = var_02;
	self setorigin(var_01,1);
	foreach(var_04 in level.players)
	{
		if(var_04 != self)
		{
			self showtoplayer(var_04);
		}
	}
}

//Function Number: 17
func_10DD8()
{
	var_00 = undefined;
	if(self.team == "allies")
	{
		var_00 = "axis";
	}
	else if(self.team == "axis")
	{
		var_00 = "allies";
	}
	else
	{
	}

	var_01 = anglestoforward(self.angles);
	var_02 = anglestoup(self.angles);
	foreach(var_04 in level.players)
	{
		if(var_04 != self)
		{
			self hidefromplayer(var_04);
			if(var_04.team == self.team)
			{
				playfx(level._effect["phase_out_friendly"],self.origin,var_01,var_02);
				continue;
			}

			playfx(level._effect["phase_out_enemy"],self.origin,var_01,var_02);
		}
	}
}

//Function Number: 18
func_C6CB()
{
	scripts\mp\_utility::setusingremote("orbital_deployment");
}

//Function Number: 19
func_C6C4()
{
	if(isdefined(self))
	{
		scripts\mp\_utility::clearusingremote();
	}
}

//Function Number: 20
func_10DD4(param_00,param_01,param_02)
{
	func_10D70();
	self waittill("blackout_done");
	scripts\mp\_utility::freezecontrolswrapper(1);
	level thread func_B9CB(self);
	level thread monitorgameend(self);
	level thread monitorobjectivecamera(self);
	var_03 = scripts\mp\killstreaks\_killstreaks::initridekillstreak(param_02);
	if(var_03 == "success")
	{
		level thread func_1285(param_00,param_01,self,param_02);
	}
	else
	{
		self notify("end_kill_streak");
		func_C6C4();
		scripts\engine\utility::allow_usability(1);
		scripts\engine\utility::allow_weapon_switch(1);
	}

	level thread scripts\mp\_utility::teamplayercardsplash(level.var_C6D7["orbital_deployment"].teamsplash,self);
}

//Function Number: 21
func_1285(param_00,param_01,param_02,param_03)
{
	param_02.var_98FF = 1;
	var_04 = 0;
	var_05 = param_00;
	var_06 = param_01;
	var_07 = vectornormalize(var_06 - var_05);
	var_06 = var_07 * 14000 + var_05;
	var_08 = scripts\mp\_utility::_magicbullet("drone_hive_projectile_mp",var_06 - (0,0,5000),var_05,param_02);
	var_08 give_player_next_weapon(1);
	var_09 = spawn("script_model",var_08.origin);
	var_09 setmodel("jsp_drop_pod_top");
	var_09 linkto(var_08,"tag_origin");
	var_09 setotherent(var_08);
	var_09.team = param_02.team;
	var_09.triggerportableradarping = param_02;
	var_09 scripts\mp\killstreaks\_utility::func_1843(param_03,"Killstreak_Air",var_09.triggerportableradarping,1);
	if(scripts\mp\_utility::isreallyalive(param_02))
	{
		param_02 func_10DD8();
	}

	if(isdefined(param_02.fauxdeath) && param_02.fauxdeath)
	{
		param_02.faux_spawn_stance = param_02 getstance();
		param_02 thread scripts\mp\_playerlogic::spawnplayer(0);
		var_04 = 1;
	}

	param_02 setorigin(var_08.origin + (0,0,10),1);
	var_08 thread func_13A22("large_rod");
	var_08.team = param_02.team;
	var_08.type = "remote";
	var_08.triggerportableradarping = param_02;
	var_08 thread scripts\mp\killstreaks\_remotemissile::handledamage();
	level.remotemissileinprogress = 1;
	level thread monitordeath(var_08,1);
	level thread monitorboost(var_08);
	func_C6D6(param_02,var_08);
	param_02 setclientomnvar("ui_predator_missile",3);
	param_02 setclientomnvar("ui_predator_missiles_left",0);
	playfx(level._effect["drop_pod_atmo"],var_08.origin);
	var_08 thread func_5821();
	var_08 thread func_13AA4(param_02);
	var_08 thread func_13AA3(param_02);
	for(;;)
	{
		var_0A = var_08 scripts\engine\utility::waittill_any_return("death","missileTargetSet");
		scripts\mp\_hostmigration::waittillhostmigrationdone();
		if(var_0A == "death")
		{
			break;
		}

		if(!isdefined(var_08))
		{
			break;
		}
	}

	if(isdefined(var_08))
	{
		param_00 = var_08.origin;
		if(isdefined(param_02))
		{
			param_02 scripts\mp\_matchdata::logkillstreakevent(param_03,var_08.origin);
		}
	}

	level thread func_E474(param_02,undefined,param_00,var_09,var_04);
}

//Function Number: 22
monitorboost(param_00)
{
	param_00 endon("death");
	for(;;)
	{
		param_00.triggerportableradarping waittill("missileTargetSet");
		param_00 notify("missileTargetSet");
	}
}

//Function Number: 23
func_C6D6(param_00,param_01)
{
	param_00 scripts\mp\_utility::freezecontrolswrapper(1);
	param_00 cameralinkto(param_01,"tag_origin");
	param_00 controlslinkto(param_01);
	param_00 visionsetmissilecamforplayer("default",0);
	param_00 thread scripts\mp\_utility::set_visionset_for_watching_players("default",0,undefined,1);
	param_00 visionsetmissilecamforplayer(game["thermal_vision"],1);
	param_00 thread delayedfofoverlay();
}

//Function Number: 24
delayedfofoverlay()
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	scripts\mp\_hostmigration::waitlongdurationwithhostmigrationpause(0.25);
	self thermalvisionfofoverlayon();
}

//Function Number: 25
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

//Function Number: 26
func_13AA4(param_00)
{
	param_00 endon("killstreak_disowned");
	param_00 endon("disconnect");
	level endon("game_ended");
	self endon("death");
	for(;;)
	{
		level waittill("host_migration_begin");
		if(isdefined(self))
		{
			param_00 visionsetmissilecamforplayer(game["thermal_vision"],0);
			param_00 scripts\mp\_utility::set_visionset_for_watching_players("default",0,undefined,1);
			param_00 thermalvisionfofoverlayon();
			continue;
		}

		param_00 setclientomnvar("ui_predator_missile",2);
	}
}

//Function Number: 27
func_13AA3(param_00)
{
	param_00 endon("killstreak_disowned");
	param_00 endon("disconnect");
	level endon("game_ended");
	self endon("death");
	for(;;)
	{
		level waittill("host_migration_end");
		if(isdefined(self))
		{
			param_00 setclientomnvar("ui_predator_missile",3);
			continue;
		}

		param_00 setclientomnvar("ui_predator_missile",2);
	}
}

//Function Number: 28
func_B9CB(param_00)
{
	param_00 endon("disconnect");
	param_00 endon("end_kill_streak");
	param_00 waittill("killstreak_disowned");
	level thread func_E474(param_00);
}

//Function Number: 29
monitorgameend(param_00)
{
	param_00 endon("disconnect");
	param_00 endon("end_kill_streak");
	level waittill("game_ended");
	level thread func_E474(param_00);
}

//Function Number: 30
monitorobjectivecamera(param_00)
{
	param_00 endon("end_kill_streak");
	param_00 endon("disconnect");
	level waittill("objective_cam");
	level thread func_E474(param_00,1);
}

//Function Number: 31
monitordeath(param_00,param_01)
{
	param_00 waittill("death");
	scripts\mp\_hostmigration::waittillhostmigrationdone();
	if(isdefined(param_00.var_114F1))
	{
		param_00.var_114F1 delete();
	}

	if(isdefined(param_00.entitynumber))
	{
		level.rockets[param_00.entitynumber] = undefined;
	}

	if(param_01)
	{
		level.remotemissileinprogress = undefined;
	}
}

//Function Number: 32
func_E474(param_00,param_01,param_02,param_03,param_04)
{
	if(!isdefined(param_00))
	{
		if(isdefined(param_03))
		{
			param_03 thread func_51B1();
		}

		return;
	}

	param_00 setclientomnvar("ui_predator_missile",2);
	param_00 notify("end_kill_streak");
	param_00 notify("orbital_deployment_complete");
	param_00 thermalvisionfofoverlayoff();
	param_00 controlsunlink();
	if(!isdefined(param_01))
	{
		scripts\mp\_hostmigration::waitlongdurationwithhostmigrationpause(0.95);
	}

	param_00 cameraunlink();
	param_00 setclientomnvar("ui_predator_missile",0);
	if(!param_04)
	{
		param_00 func_C6C4();
		param_00 scripts\engine\utility::allow_weapon_switch(1);
	}
	else
	{
		param_00 scripts\engine\utility::allow_offhand_weapons(0);
		param_00 scripts\engine\utility::allow_weapon_switch(0);
		param_00 func_C6C4();
		param_00 scripts\engine\utility::allow_weapon_switch(1);
	}

	param_00 scripts\mp\_utility::freezecontrolswrapper(0);
	param_00 scripts\engine\utility::allow_usability(1);
	if(isdefined(param_02))
	{
		param_00 func_10D89(param_02,param_03);
	}
}

//Function Number: 33
func_10D89(param_00,param_01)
{
	var_02 = spawn("script_model",param_00);
	var_02.angles = self.angles;
	var_02.triggerportableradarping = self;
	var_02.team = self.team;
	self.var_98FF = 0;
	self setorigin(param_00 + (0,0,15),1);
	foreach(var_04 in level.players)
	{
		if(var_04 != self)
		{
			self showtoplayer(var_04);
		}
	}

	self notify("weapon_change",self getcurrentweapon());
	param_01 thread func_51B1();
}

//Function Number: 34
func_51B1()
{
	wait(0.7);
	playfx(scripts\engine\utility::getfx("trophy_spark_fx"),self.origin);
	self delete();
}

//Function Number: 35
func_10D70()
{
	var_00 = newclienthudelem(self);
	var_00.x = 0;
	var_00.y = 0;
	var_00.alignx = "left";
	var_00.aligny = "top";
	var_00.sort = 1;
	var_00.horzalign = "fullscreen";
	var_00.vertalign = "fullscreen";
	var_00.foreground = 1;
	var_00 setshader("black",640,480);
	thread func_50E0(var_00,0,0.05,1);
	var_01 = 0.1;
	childthread func_50DE(var_00,var_01);
}

//Function Number: 36
func_50E0(param_00,param_01,param_02,param_03)
{
	self endon("disconnect");
	wait(param_01);
	param_00 fadeovertime(param_02);
}

//Function Number: 37
func_50DE(param_00,param_01)
{
	wait(param_01);
	param_00 destroy();
	self notify("blackout_done");
}

//Function Number: 38
func_5821()
{
	wait(0.5);
	playfx(level._effect["drop_pod_fx"],self.origin);
	wait(0.3);
	playfx(level._effect["drop_pod_fx"],self.origin);
	wait(0.3);
	playfx(level._effect["drop_pod_fx"],self.origin);
}

//Function Number: 39
func_D39C(param_00)
{
	var_01 = self.pers["killstreaks"];
	for(var_02 = 0;var_02 <= 3;var_02++)
	{
		var_03 = var_01[var_02];
		if(isdefined(var_03) && var_03.streakname == param_00 && var_03.var_269A)
		{
			return 1;
		}
	}

	return 0;
}