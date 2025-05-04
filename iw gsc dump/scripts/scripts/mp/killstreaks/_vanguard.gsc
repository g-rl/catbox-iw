/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\killstreaks\_vanguard.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 48
 * Decompile Time: 2310 ms
 * Timestamp: 10/27/2023 12:30:00 AM
*******************************************************************/

//Function Number: 1
init()
{
	func_FAB1();
	func_FAC4();
	scripts\mp\killstreaks\_killstreaks::registerkillstreak("vanguard",::func_1290D);
	level.remote_uav = [];
	level.vanguard_lastdialogtime = 0;
	level.var_1317F = ::vanguard_firemissile;
	level.var_A864 = loadfx("vfx/misc/laser_glow");
}

//Function Number: 2
func_FAB1()
{
}

//Function Number: 3
func_FAC4()
{
	level.var_13182 = getentarray("remote_heli_range","targetname");
	level.var_13181 = getent("airstrikeheight","targetname");
	if(isdefined(level.var_13181))
	{
		level.var_13180 = level.var_13181.origin[2];
		level.var_13183 = 163840000;
	}

	level.var_9C46 = 0;
	if(scripts\mp\_utility::getmapname() == "mp_descent" || scripts\mp\_utility::getmapname() == "mp_descent_new")
	{
		level.var_13180 = level.var_13182[0].origin[2] + 360;
		level.var_9C46 = 1;
	}
}

//Function Number: 4
func_1290D(param_00,param_01)
{
	return func_130F5(param_00,param_01);
}

//Function Number: 5
func_130F5(param_00,param_01)
{
	if(scripts\mp\_utility::isusingremote() || self isusingturret())
	{
		return 0;
	}

	if(isdefined(self.underwater) && self.underwater)
	{
		return 0;
	}

	if(exceededmaxvanguards(self.team) || level.littlebirds.size >= 4)
	{
		scripts\mp\_hud_message::showerrormessage("KILLSTREAKS_AIR_SPACE_TOO_CROWDED");
		return 0;
	}
	else if(scripts\mp\_utility::currentactivevehiclecount() >= scripts\mp\_utility::maxvehiclesallowed() || level.fauxvehiclecount + 1 >= scripts\mp\_utility::maxvehiclesallowed())
	{
		scripts\mp\_hud_message::showerrormessage("KILLSTREAKS_TOO_MANY_VEHICLES");
		return 0;
	}
	else if(isdefined(self.drones_disabled))
	{
		scripts\mp\_hud_message::showerrormessage("KILLSTREAKS_UNAVAILABLE");
		return 0;
	}

	scripts\mp\_utility::incrementfauxvehiclecount();
	var_02 = _meth_8356(param_00,param_01);
	if(!isdefined(var_02))
	{
		scripts\mp\_utility::decrementfauxvehiclecount();
		return 0;
	}

	scripts\mp\_matchdata::logkillstreakevent(param_01,self.origin);
	return func_10E0A(var_02,param_01,param_00);
}

//Function Number: 6
exceededmaxvanguards(param_00)
{
	if(level.teambased)
	{
		return isdefined(level.remote_uav[param_00]);
	}

	return isdefined(level.remote_uav[param_00]) || isdefined(level.remote_uav[level.otherteam[param_00]]);
}

//Function Number: 7
func_6CCC(param_00,param_01)
{
	var_02 = anglestoforward(self.angles);
	var_03 = anglestoright(self.angles);
	var_04 = self geteye();
	var_05 = var_04 + (0,0,param_01);
	var_06 = var_05 + param_00 * var_02;
	if(func_3E5C(var_04,var_06))
	{
		return var_06;
	}

	var_06 = var_05 - param_00 * var_02;
	if(func_3E5C(var_04,var_06))
	{
		return var_06;
	}

	var_06 = var_06 + param_00 * var_03;
	if(func_3E5C(var_04,var_06))
	{
		return var_06;
	}

	var_06 = var_05 - param_00 * var_03;
	if(func_3E5C(var_04,var_06))
	{
		return var_06;
	}

	var_06 = var_05;
	if(func_3E5C(var_04,var_06))
	{
		return var_06;
	}

	scripts\engine\utility::waitframe();
	var_06 = var_05 + 0.707 * param_00 * var_02 + var_03;
	if(func_3E5C(var_04,var_06))
	{
		return var_06;
	}

	var_06 = var_05 + 0.707 * param_00 * var_02 - var_03;
	if(func_3E5C(var_04,var_06))
	{
		return var_06;
	}

	var_06 = var_05 + 0.707 * param_00 * var_03 - var_02;
	if(func_3E5C(var_04,var_06))
	{
		return var_06;
	}

	var_06 = var_05 + 0.707 * param_00 * -1 * var_02 - var_03;
	if(func_3E5C(var_04,var_06))
	{
		return var_06;
	}

	return undefined;
}

//Function Number: 8
func_3E5C(param_00,param_01)
{
	var_02 = 0;
	if(capsuletracepassed(param_01,20,40.01,undefined,1,1))
	{
		var_02 = bullettracepassed(param_00,param_01,0,undefined);
	}

	return var_02;
}

//Function Number: 9
_meth_8356(param_00,param_01,param_02)
{
	var_03 = scripts\mp\_spawnscoring::func_6CB5(self,90,20,192);
	if(!isdefined(var_03))
	{
		var_03 = scripts\mp\_spawnscoring::func_6CB5(self,0,20,192);
		if(!isdefined(var_03))
		{
			var_03 = func_6CCC(80,35);
			if(!isdefined(var_03))
			{
				var_03 = func_6CCC(80,0);
			}
		}
	}

	if(isdefined(var_03))
	{
		var_04 = self.angles;
		var_05 = func_4A30(param_00,self,param_01,var_03,var_04,param_02);
		if(!isdefined(var_05))
		{
			scripts\mp\_hud_message::showerrormessage("KILLSTREAKS_AIR_SPACE_TOO_CROWDED");
		}

		return var_05;
	}

	scripts\mp\_hud_message::showerrormessage("KILLSTREAKS_VANGUARD_NO_SPAWN_POINT");
	return undefined;
}

//Function Number: 10
func_10E0A(param_00,param_01,param_02)
{
	scripts\mp\_utility::setusingremote(param_01);
	scripts\mp\_utility::freezecontrolswrapper(1);
	self.restoreangles = self.angles;
	if(getdvarint("camera_thirdPerson"))
	{
		scripts\mp\_utility::setthirdpersondof(0);
	}

	thread watchintrocleared(param_00);
	var_03 = scripts\mp\killstreaks\_killstreaks::initridekillstreak("vanguard");
	if(var_03 != "success")
	{
		param_00 notify("death");
		return 0;
	}
	else if(!isdefined(param_00))
	{
		return 0;
	}

	scripts\mp\_utility::freezecontrolswrapper(0);
	param_00.playerlinked = 1;
	self cameralinkto(param_00,"tag_origin");
	self remotecontrolvehicle(param_00);
	param_00.ammocount = 100;
	self.remote_uav_ridelifeid = param_02;
	self.remoteuav = param_00;
	thread scripts\mp\_utility::teamplayercardsplash("used_vanguard",self);
	return 1;
}

//Function Number: 11
func_1316F(param_00)
{
	if(!isdefined(param_00.lasttouchedplatform.destroydroneoncollision) || param_00.lasttouchedplatform.destroydroneoncollision || !isdefined(self.var_108D4) || gettime() > self.var_108D4)
	{
		thread handledeathdamage(undefined,undefined,undefined,undefined);
		return;
	}

	wait(1);
	thread scripts\mp\_movers::handle_moving_platform_touch(param_00);
}

//Function Number: 12
func_4A30(param_00,param_01,param_02,param_03,param_04,param_05)
{
	var_06 = spawnhelicopter(param_01,param_03,param_04,"remote_uav_mp","veh_mil_air_un_pocketdrone_mp");
	if(!isdefined(var_06))
	{
		return undefined;
	}

	var_06 scripts\mp\killstreaks\_helicopter::addtolittlebirdlist();
	var_06 thread scripts\mp\killstreaks\_helicopter::func_E111();
	var_06 makevehiclesolidcapsule(20,-5,10);
	var_06.attackarrow = spawn("script_model",(0,0,0));
	var_06.attackarrow setmodel("tag_origin");
	var_06.attackarrow.angles = (-90,0,0);
	var_06.attackarrow.offset = 4;
	var_07 = spawnturret("misc_turret",var_06.origin,"ball_drone_gun_mp",0);
	var_07 linkto(var_06,"tag_turret_attach",(0,0,0),(0,0,0));
	var_07 setmodel("veh_mil_air_un_pocketdrone_gun_mp");
	var_07 getvalidattachments();
	var_06.turret = var_07;
	var_07 makeunusable();
	var_06.lifeid = param_00;
	var_06.team = param_01.team;
	var_06.pers["team"] = param_01.team;
	var_06.triggerportableradarping = param_01;
	var_06 scripts\mp\sentientpoolmanager::registersentient("Killstreak_Air",param_01);
	if(issentient(var_06))
	{
		var_06 give_zombies_perk("DogsDontAttack");
	}

	var_06.health = 999999;
	var_06.maxhealth = 750;
	var_06.var_E1 = 0;
	var_06.var_1037E = 0;
	var_06.inheliproximity = 0;
	var_06.helitype = "remote_uav";
	var_07.triggerportableradarping = param_01;
	var_07 setentityowner(var_06);
	var_07 thread scripts\mp\_weapons::doblinkinglight("tag_fx1");
	var_07.parent = var_06;
	var_07.health = 999999;
	var_07.maxhealth = 250;
	var_07.var_E1 = 0;
	level thread func_1316B(var_06);
	level thread func_1316E(var_06,param_05);
	level thread func_13169(var_06);
	level thread func_1316D(var_06);
	var_06 thread func_1317D();
	var_06 thread func_1317E();
	var_06 thread vanguard_handledamage();
	var_06.turret thread func_1317B();
	var_06 thread watchempdamage();
	var_08 = spawn("script_model",var_06.origin);
	var_08 setscriptmoverkillcam("explosive");
	var_08 linkto(var_06,"tag_player",(-10,0,20),(0,0,0));
	var_06.killcament = var_08;
	var_06.var_108D4 = gettime() + 2000;
	var_09 = spawnstruct();
	var_09.var_13139 = 1;
	var_09.deathoverridecallback = ::func_1316F;
	var_06 thread scripts\mp\_movers::handle_moving_platforms(var_09);
	level.remote_uav[var_06.team] = var_06;
	return var_06;
}

//Function Number: 13
watchhostmigrationfinishedinit(param_00)
{
	self endon("disconnect");
	self endon("joined_team");
	self endon("joined_spectators");
	level endon("game_ended");
	param_00 endon("death");
	for(;;)
	{
		level waittill("host_migration_end");
		func_98DE();
		param_00 thread func_13175();
	}
}

//Function Number: 14
watchintrocleared(param_00)
{
	self endon("disconnect");
	self endon("joined_team");
	self endon("joined_spectators");
	level endon("game_ended");
	param_00 endon("death");
	self waittill("intro_cleared");
	func_98DE();
	param_00 getrandomweaponfromcategory();
	thread func_1317A(param_00);
	thread func_1316A(param_00);
	thread func_1316C(param_00);
	thread func_1317C(param_00);
	param_00 thread func_13175();
	if(!level.hardcoremode)
	{
		param_00 thread func_13176();
	}

	thread watchhostmigrationfinishedinit(param_00);
	scripts\mp\_utility::freezecontrolswrapper(0);
}

//Function Number: 15
func_98DE()
{
	self thermalvisionfofoverlayon();
	self setclientomnvar("ui_vanguard",1);
}

//Function Number: 16
func_1316C(param_00)
{
	level endon("game_ended");
	self endon("disconnect");
	param_00 endon("death");
	param_00 endon("end_remote");
	param_00 thread scripts\mp\killstreaks\_killstreaks::allowridekillstreakplayerexit();
	param_00 waittill("killstreakExit");
	if(isdefined(param_00.triggerportableradarping))
	{
		param_00.triggerportableradarping scripts\mp\_utility::leaderdialogonplayer("gryphon_gone");
	}

	param_00 notify("death");
}

//Function Number: 17
func_1317C(param_00)
{
	level endon("game_ended");
	self endon("disconnect");
	param_00 endon("death");
	param_00 endon("end_remote");
	while(!isdefined(param_00.attackarrow))
	{
		wait(0.05);
	}

	param_00 setotherent(param_00.attackarrow);
	param_00 setturrettargetent(param_00.attackarrow);
}

//Function Number: 18
func_1317A(param_00)
{
	level endon("game_ended");
	self endon("disconnect");
	param_00 endon("death");
	param_00 endon("end_remote");
	for(;;)
	{
		if(param_00 scripts\mp\_utility::touchingbadtrigger("gryphon"))
		{
			param_00 notify("damage",1019,self,self.angles,self.origin,"MOD_EXPLOSIVE",undefined,undefined,undefined,undefined,"c4_mp");
		}

		self.var_AEF8 = param_00.attackarrow.origin;
		scripts\engine\utility::waitframe();
	}
}

//Function Number: 19
func_13175()
{
	playfxontagforclients(level.vanguard_fx["target_marker_circle"],self.attackarrow,"tag_origin",self.triggerportableradarping);
	thread func_13179();
}

//Function Number: 20
func_13176()
{
	self endon("death");
	self endon("end_remote");
	for(;;)
	{
		level waittill("joined_team",var_00);
		stopfxontag(level.vanguard_fx["target_marker_circle"],self.attackarrow,"tag_origin");
		scripts\engine\utility::waitframe();
		func_13175();
	}
}

//Function Number: 21
func_13179()
{
	self endon("death");
	self endon("end_remote");
	if(!level.hardcoremode)
	{
		foreach(var_01 in level.players)
		{
			if(self.triggerportableradarping scripts\mp\_utility::isenemy(var_01))
			{
				scripts\engine\utility::waitframe();
				playfxontagforclients(level.vanguard_fx["target_marker_circle"],self.attackarrow,"tag_origin",var_01);
			}
		}
	}
}

//Function Number: 22
func_13178(param_00)
{
	var_01 = isdualwielding(param_00.triggerportableradarping,param_00);
	if(isdefined(var_01))
	{
		param_00.attackarrow.origin = var_01[0] + (0,0,4);
		return var_01[0];
	}

	return undefined;
}

//Function Number: 23
isdualwielding(param_00,param_01)
{
	var_02 = param_01.turret gettagorigin("tag_flash");
	var_03 = param_00 getplayerangles();
	var_04 = anglestoforward(var_03);
	var_05 = var_02 + var_04 * 15000;
	var_06 = bullettrace(var_02,var_05,0,param_01);
	if(var_06["surfacetype"] == "none")
	{
		return undefined;
	}

	if(var_06["surfacetype"] == "default")
	{
		return undefined;
	}

	var_07 = var_06["entity"];
	var_08 = [];
	var_08[0] = var_06["position"];
	var_08[1] = var_06["normal"];
	return var_08;
}

//Function Number: 24
func_1316A(param_00)
{
	self endon("disconnect");
	level endon("game_ended");
	param_00 endon("death");
	param_00 endon("end_remote");
	self notifyonplayercommand("vanguard_fire","+attack");
	self notifyonplayercommand("vanguard_fire","+attack_akimbo_accessible");
	param_00.var_6D7F = gettime();
	for(;;)
	{
		self waittill("vanguard_fire");
		scripts\mp\_hostmigration::waittillhostmigrationdone();
		if(isdefined(level.hostmigrationtimer))
		{
			continue;
		}

		if(isdefined(self.var_AEF8) && gettime() >= param_00.var_6D7F)
		{
			self thread [[ level.var_1317F ]](param_00,self.var_AEF8);
		}
	}
}

//Function Number: 25
func_13177(param_00,param_01,param_02)
{
	self endon("disconnect");
	level endon("game_ended");
	param_00 endon("death");
	param_00 endon("end_remote");
	param_00 notify("end_rumble");
	param_00 endon("end_rumble");
	for(var_03 = 0;var_03 < param_02;var_03++)
	{
		self playrumbleonentity(param_01);
		scripts\engine\utility::waitframe();
	}
}

//Function Number: 26
looptriggeredeffect(param_00,param_01)
{
	param_01 endon("death");
	level endon("game_ended");
	self endon("death");
	for(;;)
	{
		triggerfx(param_00);
		wait(0.25);
	}
}

//Function Number: 27
vanguard_firemissile(param_00,param_01)
{
	level endon("game_ended");
	if(param_00.ammocount <= 0)
	{
		return;
	}

	var_02 = param_00.turret gettagorigin("tag_fire");
	var_02 = var_02 + (0,0,-25);
	if(distancesquared(var_02,param_01) < 10000)
	{
		param_00 playsoundtoplayer("weap_vanguard_fire_deny",self);
		return;
	}

	param_00.var_1E41--;
	self playlocalsound("weap_gryphon_fire_plr");
	scripts\mp\_utility::playsoundinspace("weap_gryphon_fire_npc",param_00.origin);
	thread func_13177(param_00,"shotgun_fire",1);
	earthquake(0.3,0.25,param_00.origin,60);
	var_03 = scripts\mp\_utility::_magicbullet("remote_tank_projectile_mp",var_02,param_01,self);
	var_03.vehicle_fired_from = param_00;
	var_04 = 1500;
	param_00.var_6D7F = gettime() + var_04;
	thread func_12F63(param_00,var_04 * 0.001);
	var_03 scripts\mp\_hostmigration::waittill_notify_or_timeout_hostmigration_pause("death",4);
	earthquake(0.3,0.75,param_01,128);
	if(isdefined(param_00))
	{
		earthquake(0.25,0.75,param_00.origin,60);
		thread func_13177(param_00,"damage_heavy",3);
		if(param_00.ammocount == 0)
		{
			wait(0.75);
			param_00 notify("death");
		}
	}
}

//Function Number: 28
func_12F63(param_00,param_01)
{
	level endon("game_ended");
	self endon("disconnect");
	param_00 endon("death");
	param_00 endon("end_remote");
	self setclientomnvar("ui_vanguard_ammo",-1);
	wait(param_01);
	self setclientomnvar("ui_vanguard_ammo",param_00.ammocount);
}

//Function Number: 29
getturrettarget(param_00,param_01)
{
	var_02 = (3000,3000,3000);
	var_03 = vectornormalize(param_00.origin - param_01 + (0,0,-400));
	var_04 = rotatevector(var_03,(0,25,0));
	var_05 = param_01 + var_04 * var_02;
	if(func_9FE6(var_05,param_01))
	{
		return var_05;
	}

	var_04 = rotatevector(var_03,(0,-25,0));
	var_05 = param_01 + var_04 * var_02;
	if(func_9FE6(var_05,param_01))
	{
		return var_05;
	}

	var_05 = param_01 + var_03 * var_02;
	if(func_9FE6(var_05,param_01))
	{
		return var_05;
	}

	return param_01 + (0,0,3000);
}

//Function Number: 30
func_9FE6(param_00,param_01)
{
	var_02 = bullettrace(param_00,param_01,0);
	if(var_02["fraction"] > 0.99)
	{
		return 1;
	}

	return 0;
}

//Function Number: 31
func_1317D()
{
	self endon("death");
	var_00 = self.origin;
	self.var_DCCE = 0;
	for(;;)
	{
		if(!isdefined(self))
		{
			return;
		}

		if(!isdefined(self.triggerportableradarping))
		{
			return;
		}

		if(!vanguard_in_range())
		{
			while(!vanguard_in_range())
			{
				if(!isdefined(self))
				{
					return;
				}

				if(!isdefined(self.triggerportableradarping))
				{
					return;
				}

				if(!self.var_DCCE)
				{
					self.var_DCCE = 1;
					thread func_13173();
				}

				if(isdefined(self.heliinproximity))
				{
					var_01 = distance(self.origin,self.heliinproximity.origin);
				}
				else if(isdefined(level.var_5618))
				{
					var_01 = 467.5;
				}
				else
				{
					var_01 = distance(self.origin,var_00);
				}

				var_02 = getentityvelocity(var_01);
				self.triggerportableradarping setclientomnvar("ui_vanguard",var_02);
				wait(0.1);
			}

			self notify("in_range");
			self.var_DCCE = 0;
			self.triggerportableradarping setclientomnvar("ui_vanguard",1);
		}

		var_03 = int(angleclamp(self.angles[1]));
		self.triggerportableradarping setclientomnvar("ui_vanguard_heading",var_03);
		var_04 = self.origin[2] * 0.0254;
		var_04 = int(clamp(var_04,-250,250));
		self.triggerportableradarping setclientomnvar("ui_vanguard_altitude",var_04);
		var_05 = distance2d(self.origin,self.attackarrow.origin) * 0.0254;
		var_05 = int(clamp(var_05,0,256));
		self.triggerportableradarping setclientomnvar("ui_vanguard_range",var_05);
		var_00 = self.origin;
		wait(0.1);
	}
}

//Function Number: 32
getentityvelocity(param_00)
{
	param_00 = clamp(param_00,50,550);
	return 2 + int(8 * param_00 - 50 / 500);
}

//Function Number: 33
vanguard_in_range()
{
	if(!isdefined(level.var_13183) || !isdefined(level.var_13180))
	{
		return 0;
	}

	if(isdefined(self.inheliproximity) && self.inheliproximity)
	{
		return 0;
	}

	if(isdefined(level.var_5618))
	{
		return 0;
	}

	if(isdefined(level.var_13182[0]))
	{
		foreach(var_01 in level.var_13182)
		{
			if(self istouching(var_01))
			{
				return 0;
			}
		}

		if(level.var_9C46)
		{
			return self.origin[2] < level.var_13180;
		}
		else
		{
			return 1;
		}
	}
	else if(distance2dsquared(self.origin,level.mapcenter) < level.var_13183 && self.origin[2] < level.var_13180)
	{
		return 1;
	}

	return 0;
}

//Function Number: 34
func_13173()
{
	self endon("death");
	self endon("in_range");
	if(isdefined(self.heliinproximity))
	{
		var_00 = 3;
	}
	else
	{
		var_00 = 6;
	}

	scripts\mp\_hostmigration::waitlongdurationwithhostmigrationpause(var_00);
	self notify("death","range_death");
}

//Function Number: 35
func_1316B(param_00)
{
	param_00 endon("death");
	param_00.triggerportableradarping scripts\engine\utility::waittill_any_3("killstreak_disowned");
	param_00 notify("death");
}

//Function Number: 36
func_1316E(param_00,param_01)
{
	param_00 endon("death");
	var_02 = 60;
	scripts\mp\_hostmigration::waitlongdurationwithhostmigrationpause(var_02);
	if(isdefined(param_00.triggerportableradarping))
	{
		param_00.triggerportableradarping scripts\mp\_utility::leaderdialogonplayer("gryphon_gone");
	}

	param_00 notify("death");
}

//Function Number: 37
func_13169(param_00)
{
	level endon("game_ended");
	level endon("objective_cam");
	var_01 = param_00.turret;
	param_00 waittill("death");
	param_00 scripts\mp\_weapons::stopblinkinglight();
	stopfxontag(level.vanguard_fx["target_marker_circle"],param_00.attackarrow,"tag_origin");
	playfx(level.vanguard_fx["explode"],param_00.origin);
	param_00 playsound("ball_drone_explode");
	var_01 delete();
	if(isdefined(param_00.var_1155D))
	{
		param_00.var_1155D delete();
	}

	vanguard_endride(param_00.triggerportableradarping,param_00);
}

//Function Number: 38
func_1316D(param_00)
{
	param_00 endon("death");
	level scripts\engine\utility::waittill_any_3("objective_cam","game_ended");
	playfx(level.vanguard_fx["explode"],param_00.origin);
	param_00 playsound("ball_drone_explode");
	vanguard_endride(param_00.triggerportableradarping,param_00);
}

//Function Number: 39
vanguard_endride(param_00,param_01)
{
	param_01 notify("end_remote");
	param_01.playerlinked = 0;
	param_01 setotherent(undefined);
	func_13174(param_00,param_01);
	stopfxontag(level.vanguard_fx["smoke"],param_01,"tag_origin");
	level.remote_uav[param_01.team] = undefined;
	scripts\mp\_utility::decrementfauxvehiclecount();
	if(isdefined(param_01.killcament))
	{
		param_01.killcament delete();
	}

	param_01.attackarrow delete();
	param_01 delete();
}

//Function Number: 40
func_E2E5()
{
	self visionsetnakedforplayer("",1);
	scripts\mp\_utility::set_visionset_for_watching_players("",1);
}

//Function Number: 41
func_13174(param_00,param_01)
{
	if(!isdefined(param_00))
	{
		return;
	}

	param_00 scripts\mp\_utility::clearusingremote();
	param_00 func_E2E5();
	param_00 setclientomnvar("ui_vanguard",0);
	if(getdvarint("camera_thirdPerson"))
	{
		param_00 scripts\mp\_utility::setthirdpersondof(1);
	}

	param_00 cameraunlink(param_01);
	param_00 remotecontrolvehicleoff(param_01);
	param_00 thermalvisionfofoverlayoff();
	param_00 setplayerangles(param_00.restoreangles);
	param_00.remoteuav = undefined;
	if(param_00.team == "spectator")
	{
		return;
	}

	level thread vanguard_freezecontrolsbuffer(param_00);
}

//Function Number: 42
vanguard_freezecontrolsbuffer(param_00)
{
	param_00 endon("disconnect");
	param_00 endon("death");
	level endon("game_ended");
	param_00 scripts\mp\_utility::freezecontrolswrapper(1);
	wait(0.5);
	param_00 scripts\mp\_utility::freezecontrolswrapper(0);
}

//Function Number: 43
func_1317E()
{
	level endon("game_ended");
	self endon("death");
	self endon("end_remote");
	for(;;)
	{
		var_00 = 0;
		foreach(var_02 in level.helis)
		{
			if(distance(var_02.origin,self.origin) < 300)
			{
				var_00 = 1;
				self.heliinproximity = var_02;
			}
		}

		foreach(var_05 in level.littlebirds)
		{
			if(var_05 != self && !isdefined(var_05.helitype) || var_05.helitype != "remote_uav" && distance(var_05.origin,self.origin) < 300)
			{
				var_00 = 1;
				self.heliinproximity = var_05;
			}
		}

		if(!self.inheliproximity && var_00)
		{
			self.inheliproximity = 1;
		}
		else if(self.inheliproximity && !var_00)
		{
			self.inheliproximity = 0;
			self.heliinproximity = undefined;
		}

		wait(0.05);
	}
}

//Function Number: 44
vanguard_handledamage()
{
	self endon("death");
	level endon("game_ended");
	self setcandamage(1);
	for(;;)
	{
		self waittill("damage",var_00,var_01,var_02,var_03,var_04,var_05,var_06,var_07,var_08,var_09);
		scripts\mp\_damage::monitordamageoneshot(var_00,var_01,var_02,var_03,var_04,var_05,var_06,var_07,var_08,var_09,"remote_uav",::handledeathdamage,::modifydamage,1);
	}
}

//Function Number: 45
func_1317B()
{
	self endon("death");
	level endon("game_ended");
	self getvalidlocation();
	self setcandamage(1);
	for(;;)
	{
		self waittill("damage",var_00,var_01,var_02,var_03,var_04,var_05,var_06,var_07,var_08,var_09);
		if(isdefined(self.parent))
		{
			self.parent scripts\mp\_damage::monitordamageoneshot(var_00,var_01,var_02,var_03,var_04,var_05,var_06,var_07,var_08,var_09,"remote_uav",::handledeathdamage,::modifydamage,1);
		}
	}
}

//Function Number: 46
modifydamage(param_00,param_01,param_02,param_03)
{
	var_04 = param_03;
	var_04 = scripts\mp\_damage::handleempdamage(param_01,param_02,var_04);
	var_04 = scripts\mp\_damage::handlemissiledamage(param_01,param_02,var_04);
	var_04 = scripts\mp\_damage::handlegrenadedamage(param_01,param_02,var_04);
	var_04 = scripts\mp\_damage::handleapdamage(param_01,param_02,var_04);
	if(param_02 == "MOD_MELEE")
	{
		var_04 = self.maxhealth * 0.34;
	}

	playfxontagforclients(level.vanguard_fx["hit"],self,"tag_origin",self.triggerportableradarping);
	if(self.var_1037E == 0 && self.var_E1 >= self.maxhealth / 2)
	{
		self.var_1037E = 1;
		playfxontag(level.vanguard_fx["smoke"],self,"tag_origin");
	}

	return var_04;
}

//Function Number: 47
handledeathdamage(param_00,param_01,param_02,param_03)
{
	if(isdefined(self.triggerportableradarping))
	{
		self.triggerportableradarping scripts\mp\_utility::leaderdialogonplayer("gryphon_destroyed");
	}

	scripts\mp\_damage::onkillstreakkilled("vanguard",param_00,param_01,param_02,param_03,"destroyed_vanguard",undefined,"callout_destroyed_vanguard");
	if(isdefined(param_00))
	{
		param_00 scripts\mp\_missions::processchallenge("ch_gryphondown");
		scripts\mp\_missions::func_3DE3(param_00,self,param_01);
	}
}

//Function Number: 48
watchempdamage()
{
	self endon("death");
	level endon("game_ended");
	for(;;)
	{
		self waittill("emp_damage",var_00,var_01);
		stopfxontag(level.vanguard_fx["target_marker_circle"],self.attackarrow,"tag_origin");
		scripts\engine\utility::waitframe();
		thread func_13179();
		playfxontag(scripts\engine\utility::getfx("emp_stun"),self,"tag_origin");
		wait(var_01);
		stopfxontag(level.vanguard_fx["target_marker_circle"],self.attackarrow,"tag_origin");
		scripts\engine\utility::waitframe();
		thread func_13175();
	}
}