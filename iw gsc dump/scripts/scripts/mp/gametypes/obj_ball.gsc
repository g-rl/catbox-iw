/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\gametypes\obj_ball.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 106
 * Decompile Time: 5410 ms
 * Timestamp: 10/27/2023 12:12:50 AM
*******************************************************************/

//Function Number: 1
ball_default_origins()
{
	level.default_goal_origins = [];
	level.magicbullet = getentarray("flag_primary","targetname");
	foreach(var_01 in level.magicbullet)
	{
		switch(var_01.script_label)
		{
			case "_a":
				level.default_goal_origins[game["attackers"]] = var_01.origin;
				break;

			case "_b":
				level.default_ball_origin = var_01.origin;
				break;

			case "_c":
				level.default_goal_origins[game["defenders"]] = var_01.origin;
				break;
		}
	}
}

//Function Number: 2
ball_init_map_min_max()
{
	level.ball_mins = (1000,1000,1000);
	level.ball_maxs = (-1000,-1000,-1000);
	var_00 = function_0076();
	if(var_00.size > 0)
	{
		foreach(var_02 in var_00)
		{
			level.ball_mins = scripts\mp\_spawnlogic::expandmins(level.ball_mins,var_02.origin);
			level.ball_maxs = scripts\mp\_spawnlogic::expandmaxs(level.ball_maxs,var_02.origin);
		}

		return;
	}

	level.ball_mins = level.spawnmins;
	level.ball_maxs = level.spawnmaxs;
}

//Function Number: 3
ball_create_ball_starts()
{
	if(!isdefined(level.devball))
	{
		level.devball = 0;
	}

	var_00 = getballstarts();
	level.ball_triggers = getballtriggers();
	checkpostshipballspawns(var_00);
	if(var_00.size > 1 && level.satellitecount > 1)
	{
		for(var_01 = 0;var_01 < level.satellitecount;var_01++)
		{
			var_02 = getballorigin(var_00[var_01]);
			ball_add_start(var_02);
		}
	}
	else
	{
		var_03 = [];
		var_03[0] = (0,0,0);
		var_03[1] = (50,0,0);
		var_03[2] = (-50,0,0);
		var_03[3] = (0,50,0);
		var_03[4] = (0,-50,0);
		for(var_01 = 0;var_01 < level.satellitecount;var_01++)
		{
			var_02 = getballorigin(var_00[var_01]);
			ball_add_start(var_02 + var_03[var_01]);
		}
	}

	level thread scripts\mp\_utility::global_physics_sound_monitor();
}

//Function Number: 4
checkpostshipballspawns(param_00)
{
	if(level.mapname == "mp_divide")
	{
		param_00[0].origin = (-261,235,610);
		param_00[1].origin = (-211,235,610);
		param_00[2].origin = (-311,235,610);
		param_00[3].origin = (-311,500,610);
		param_00[4].origin = (-211,500,610);
	}
}

//Function Number: 5
getballstarts()
{
	var_00 = undefined;
	if(level.gametype == "tdef")
	{
		var_00 = scripts\engine\utility::getstructarray("tdef_ball_start","targetname");
	}

	if(!isdefined(var_00) || !var_00.size)
	{
		var_00 = scripts\engine\utility::getstructarray("ball_start","targetname");
	}

	if(level.satellitecount > 1)
	{
		var_00 = sortballarray(var_00);
	}

	return var_00;
}

//Function Number: 6
getballtriggers()
{
	var_00 = undefined;
	if(level.gametype == "tdef")
	{
		var_00 = getentarray("tdef_ball_pickup","targetname");
	}

	if(!isdefined(var_00) || !var_00.size)
	{
		var_00 = getentarray("ball_pickup","targetname");
	}

	if(level.satellitecount > 1)
	{
		var_00 = sortballarray(var_00);
	}

	return var_00;
}

//Function Number: 7
getballorigin(param_00)
{
	if(isdefined(param_00))
	{
		var_01 = param_00.origin;
	}
	else if(level.devball)
	{
		var_01 = level.players[0].origin + (0,0,30);
	}
	else
	{
		var_01 = level.default_ball_origin;
	}

	return var_01;
}

//Function Number: 8
ball_add_start(param_00)
{
	var_01 = 30;
	var_02 = spawnstruct();
	var_02.origin = param_00;
	var_03 = param_00;
	var_02 ball_find_ground();
	var_02.origin = var_02.ground_origin + (0,0,var_01);
	var_02.in_use = 0;
	if(level.mapname == "mp_desert")
	{
		var_03 = var_02.ground_origin;
	}

	if(level.mapname == "mp_divide")
	{
		var_03 = var_02.ground_origin;
	}

	if(level.gametype == "tdef")
	{
		level.ballbases[level.ballbases.size] = createballbase(var_03);
	}

	level.ball_starts[level.ball_starts.size] = var_02;
}

//Function Number: 9
ball_find_ground(param_00)
{
	var_01 = self.origin + (0,0,32);
	var_02 = self.origin + (0,0,-1000);
	var_03 = scripts\common\trace::create_contents(1,1,1,1,0,1,1);
	var_04 = [];
	var_05 = scripts\common\trace::ray_trace(var_01,var_02,var_04,var_03);
	self.ground_origin = var_05["position"];
	return var_05["fraction"] != 0 && var_05["fraction"] != 1;
}

//Function Number: 10
createballbase(param_00)
{
	var_01 = spawn("script_model",param_00);
	var_01 setmodel("ctf_game_flag_unsa_base_wm");
	var_01 setasgametypeobjective();
	var_01.baseeffectpos = param_00;
	return var_01;
}

//Function Number: 11
showballbaseeffecttoplayer(param_00)
{
	if(isdefined(param_00._baseeffect[0]))
	{
		param_00._baseeffect[0] delete();
	}

	var_01 = undefined;
	var_02 = param_00.team;
	var_03 = param_00 ismlgspectator();
	if(var_03)
	{
		var_02 = param_00 getmlgspectatorteam();
	}
	else if(var_02 == "spectator")
	{
		var_02 = "allies";
	}

	var_04 = function_01E1(level._effect["ball_base_glow"],self.baseeffectpos,param_00);
	var_04 setfxkilldefondelete();
	param_00._baseeffect[0] = var_04;
	triggerfx(var_04);
}

//Function Number: 12
ball_spawn(param_00)
{
	if(!isdefined(param_00))
	{
		param_00 = 0;
	}

	var_01 = level.ball_starts[level.balls.size];
	var_02 = spawn("script_model",var_01.origin);
	var_02 setasgametypeobjective();
	if(level.gametype == "ball" || getdvarint("scr_uplink_create_ball") == 1)
	{
		var_02 setmodel("uplink_ball_drone_wm");
		var_02 setnonstick(1);
		level.ballweapon = "iw7_uplinkball_mp";
		level.ballpassdist = 1000000;
	}
	else
	{
		var_02 setmodel("tdef_ball_drone_wm");
		var_02 setnonstick(1);
		level.ballweapon = "iw7_tdefball_mp";
		level.ballpassdist = 250000;
	}

	var_03 = 32;
	var_04 = undefined;
	if(isdefined(level.ball_triggers) && level.ball_triggers.size > 0)
	{
		var_04 = level.ball_triggers[param_00];
		var_04.origin = var_02.origin;
	}
	else
	{
		var_04 = spawn("trigger_radius",var_02.origin - (0,0,var_03 / 2),0,var_03,var_03);
	}

	var_04 enablelinkto();
	var_04 linkto(var_02);
	var_04.no_moving_platfrom_unlink = 1;
	var_04.linktoenabledflag = 1;
	var_04.baseorigin = var_04.origin;
	var_04.no_moving_platfrom_unlink = 1;
	var_05 = [var_02];
	var_06 = scripts\mp\_gameobjects::createcarryobject("any",var_04,var_05,(0,0,32));
	var_06.objectiveonvisuals = 1;
	var_06 scripts\mp\_gameobjects::allowcarry("any");
	var_06 ball_waypoint_neutral();
	var_06.allowweapons = 0;
	var_06.carryweapon = level.ballweapon;
	var_06.keepcarryweapon = 0;
	var_06.visualgroundoffset = (0,0,30);
	var_06.canuseobject = ::ball_can_pickup;
	var_06.onpickup = ::ball_on_pickup;
	var_06.setdropped = ::ball_set_dropped;
	var_06.onreset = ::ball_on_reset;
	var_06.carryweaponthink = ::ball_pass_or_shoot;
	var_06.in_goal = 0;
	var_06.lastcarrierscored = 0;
	var_06.pass = 0;
	var_06.requireslos = 1;
	var_06.lastcarrierteam = "none";
	var_06.ballindex = level.balls.size;
	var_06.playeroutlineid = undefined;
	var_06.playeroutlined = undefined;
	var_06.passtargetoutlineid = undefined;
	var_06.passtargetent = undefined;
	var_06.visuals[0] fixlinktointerpolationbug(1);
	var_06.visuals[0] give_player_tickets(1);
	if(isdefined(level.showenemycarrier))
	{
		switch(level.showenemycarrier)
		{
			case 0:
				var_06 scripts\mp\_gameobjects::setvisibleteam("friendly");
				var_06.objidpingenemy = 0;
				var_06.objidpingfriendly = 1;
				var_06.objpingdelay = 60;
				break;

			case 1:
				var_06 scripts\mp\_gameobjects::setvisibleteam("any");
				var_06.objidpingenemy = 0;
				var_06.objidpingfriendly = 0;
				var_06.objpingdelay = 0.05;
				break;

			case 2:
				var_06 scripts\mp\_gameobjects::setvisibleteam("any");
				var_06.objidpingenemy = 0;
				var_06.objidpingfriendly = 1;
				var_06.objpingdelay = 1;
				break;

			case 3:
				var_06 scripts\mp\_gameobjects::setvisibleteam("any");
				var_06.objidpingenemy = 0;
				var_06.objidpingfriendly = 1;
				var_06.objpingdelay = 1.5;
				break;

			case 4:
				var_06 scripts\mp\_gameobjects::setvisibleteam("any");
				var_06.objidpingenemy = 0;
				var_06.objidpingfriendly = 1;
				var_06.objpingdelay = 2;
				break;

			case 5:
				var_06 scripts\mp\_gameobjects::setvisibleteam("any");
				var_06.objidpingenemy = 0;
				var_06.objidpingfriendly = 1;
				var_06.objpingdelay = 3;
				break;

			case 6:
				var_06 scripts\mp\_gameobjects::setvisibleteam("any");
				var_06.objidpingenemy = 0;
				var_06.objidpingfriendly = 1;
				var_06.objpingdelay = 4;
				break;
		}
	}
	else
	{
		var_06 scripts\mp\_gameobjects::setvisibleteam("any");
		var_06.objidpingenemy = 0;
		var_06.objidpingfriendly = 1;
		var_06.objpingdelay = 3;
	}

	var_06 ball_assign_start(var_01);
	level.balls[level.balls.size] = var_06;
	if(level.gametype == "tdef")
	{
		level.balls[0] thread starthoveranim();
	}

	if(!scripts\mp\_utility::istrue(level.devball))
	{
		var_06 thread ball_fx_start(1,1);
	}

	var_06 thread ball_location_hud();
	var_06.visuals[0] playloopsound("uplink_ball_hum_lp");
	var_07 = ["physicscontents_clipshot","physicscontents_corpseclipshot","physicscontents_missileclip","physicscontents_solid","physicscontents_vehicle","physicscontents_player","physicscontents_actor","physicscontents_glass","physicscontents_itemclip"];
	var_08 = physics_createcontents(var_07);
	level.ballphysicscontentoverride = var_08;
	level.balltraceradius = 10;
	if(level.gametype == "tdef")
	{
		level.balltraceradius = 20;
	}
}

//Function Number: 13
ball_can_pickup(param_00)
{
	if(isdefined(self.droptime) && self.droptime >= gettime())
	{
		return 0;
	}

	if(isplayer(param_00))
	{
		if(!param_00 scripts\engine\utility::isweaponallowed())
		{
			return 0;
		}

		if(isdefined(param_00.manuallyjoiningkillstreak) && param_00.manuallyjoiningkillstreak)
		{
			return 0;
		}

		if(scripts\mp\_utility::istrue(param_00.iscarrying))
		{
			return 0;
		}

		if(scripts\mp\_utility::istrue(param_00.using_remote_turret))
		{
			return 0;
		}

		if(!valid_ball_super_pickup(param_00))
		{
			return 0;
		}

		var_01 = param_00 getcurrentweapon();
		if(isdefined(var_01))
		{
			if(!valid_ball_pickup_weapon(var_01))
			{
				return 0;
			}
		}

		var_02 = param_00.changingweapon;
		if(isdefined(var_02) && param_00 isswitchingweapon())
		{
			if(!valid_ball_pickup_weapon(var_02))
			{
				return 0;
			}
		}

		if(param_00 scripts\mp\_utility::isanymonitoredweaponswitchinprogress())
		{
			var_02 = param_00 scripts\mp\_utility::getcurrentmonitoredweaponswitchweapon();
			if(!valid_ball_pickup_weapon(var_02))
			{
				return 0;
			}
		}

		if(param_00 scripts\mp\_utility::isusingremote())
		{
			return 0;
		}

		if(param_00 player_no_pickup_time())
		{
			return 0;
		}
	}
	else
	{
		return 0;
	}

	return 1;
}

//Function Number: 14
ball_on_pickup(param_00)
{
	param_00 notify("obj_picked_up");
	param_00 thread checkgesturethread();
	var_01 = 0;
	if(level.ballreset)
	{
		if(givegrabscore(param_00))
		{
			param_00 thread scripts\mp\_utility::giveunifiedpoints("ball_grab");
		}

		level.ballpickupscorefrozen = gettime();
		level.ballreset = 0;
		if(isdefined(level.possessionresetcondition) && level.possessionresetcondition == 1 && scripts\mp\_utility::istrue(level.possessionresettime))
		{
			var_01 = 1;
		}

		param_00 notify("ball_grab");
	}

	if(isdefined(level.possessionresetcondition) && level.possessionresetcondition == 2 && scripts\mp\_utility::istrue(level.possessionresettime) && isdefined(self.lastcarrier) && self.lastcarrier != param_00)
	{
		var_01 = 1;
	}

	if(level.gametype == "tdef")
	{
		param_00 scripts\mp\gametypes\tdef::getsettdefsuit();
		level thread scripts\mp\gametypes\tdef::awardcapturepoints(param_00.team);
		if(!level.timerstoppedforgamemode)
		{
			level scripts\mp\_gamelogic::pausetimer();
		}
	}

	if(scripts\mp\_utility::istrue(level.possessionresetcondition))
	{
		level updatetimers(param_00.team,0,0,var_01);
	}

	level.usestartspawns = 0;
	level.codcasterball = undefined;
	level.codcasterballinitialforcevector = undefined;
	var_02 = self.visuals[0] getlinkedparent();
	if(isdefined(var_02))
	{
		self.visuals[0] unlink();
	}

	if(!scripts\mp\_utility::istrue(level.devball))
	{
		param_00 scripts\mp\_utility::giveperk("specialty_ballcarrier");
	}

	param_00.ball_carried = self;
	param_00.objective = 1;
	self.carrier scripts\mp\_utility::giveperk("specialty_sprintfire");
	self.carrier.hasperksprintfire = 1;
	if(!scripts\mp\_utility::istrue(level.devball))
	{
		param_00 scripts\mp\_lightarmor::setlightarmorvalue(param_00,level.carrierarmor);
	}

	if(!scripts\mp\_utility::istrue(level.devball))
	{
		thread ball_play_local_team_sound(param_00.team,"mp_uplink_ball_pickedup_friendly","mp_uplink_ball_pickedup_enemy");
	}

	param_00 scripts\engine\utility::allow_usability(0);
	foreach(var_05, var_04 in param_00.powers)
	{
		param_00 scripts\mp\_powers::func_D727(var_05);
	}

	self.visuals[0] physicslaunchserver(self.visuals[0].origin,(0,0,0));
	self.visuals[0] physicsstopserver();
	self.visuals[0] scripts\mp\_movers::notify_moving_platform_invalid();
	self.pass = 0;
	self.visuals[0] stop_fx_idle();
	self.visuals[0] show();
	self.visuals[0] hide(1);
	self.visuals[0] linkto(param_00,"j_wrist_ri",(0,0,0),param_00.angles);
	self.visuals[0] setscriptablepartstate("uplink_drone_hide","hide",0);
	self.trigger scripts\mp\_movers::stop_handling_moving_platforms();
	self.current_start.in_use = 0;
	var_06 = 0;
	if(isdefined(self.projectile))
	{
		var_06 = 1;
		self.projectile delete();
	}

	var_07 = param_00.team;
	var_08 = scripts\mp\_utility::getotherteam(param_00.team);
	self.visuals[0] setotherent(param_00);
	if(var_06)
	{
		if(self.lastcarrierteam == param_00.team)
		{
			if(!scripts\mp\_utility::istrue(level.devball))
			{
				scripts\mp\_utility::statusdialog("pass_complete",var_07);
			}

			param_00.passtime = gettime();
			param_00.passplayer = self.lastcarrier;
		}
		else
		{
			if(!scripts\mp\_utility::istrue(level.devball))
			{
				scripts\mp\_utility::statusdialog("pass_intercepted",var_08);
			}

			param_00 thread scripts\mp\_awards::givemidmatchaward("mode_uplink_intercept");
			if(isplayer(param_00))
			{
				param_00 thread scripts\mp\_matchdata::loggameevent("pickup_interception",param_00.origin);
			}
		}
	}
	else
	{
		if(!scripts\mp\_utility::istrue(level.devball) && self.lastcarrierteam != param_00.team)
		{
			scripts\mp\_utility::statusdialog("ally_own_drone",var_07);
			scripts\mp\_utility::statusdialog("enemy_own_drone",var_08);
		}

		if(isplayer(param_00))
		{
			param_00 thread scripts\mp\_matchdata::loggameevent("pickup",param_00.origin);
		}
	}

	if(!scripts\mp\_utility::istrue(level.devball))
	{
		ball_fx_stop();
	}

	self.lastcarrierscored = 0;
	self.lastcarrier = param_00;
	self.lastcarrierteam = param_00.team;
	self.ownerteam = param_00.team;
	ball_waypoint_held(self.ownerteam);
	scripts\mp\_utility::setmlgannouncement(12,param_00.team,param_00 getentitynumber());
	param_00 setweaponammoclip(level.ballweapon,1);
	if(getdvarint("com_codcasterEnabled",0) == 1)
	{
		param_00 setgametypevip(1);
	}

	param_00 thread player_update_pass_target(self);
	if(!scripts\mp\_utility::istrue(level.devball))
	{
		scripts\mp\_gamelogic::sethasdonecombat(param_00,1);
	}

	self notify("physics_timeout");
}

//Function Number: 15
checkgesturethread()
{
	self endon("death");
	self endon("disconnect");
	self endon("drop_object");
	wait(0.05);
	if(isdefined(self.gestureweapon) && self isgestureplaying(self.gestureweapon))
	{
		self stopgestureviewmodel(self.gestureweapon,0.05,1);
	}
}

//Function Number: 16
detonateball()
{
	var_00 = spawn("script_model",self.curorigin);
	var_00 setmodel("tag_origin");
	var_01 = self.lastcarrier scripts\mp\_utility::_launchgrenade("blackhole_grenade_mp",self.curorigin,(0,0,0));
	var_01 linkto(var_00,"tag_origin");
	var_01.triggerportableradarping = self.lastcarrier;
	var_01 hide(1);
	var_01.triggerportableradarping thread scripts\mp\_blackholegrenade::func_2B3E(var_01);
}

//Function Number: 17
givegrabscore(param_00)
{
	if(level.gametype == "tdef")
	{
		var_01 = 15000;
	}
	else
	{
		var_01 = 10000;
	}

	var_02 = param_00 updatebpm();
	if(var_02)
	{
		return 0;
	}

	if(isdefined(self.lastcarrier) && param_00.team == self.lastcarrier.team && gettime() < level.ballpickupscorefrozen + var_01)
	{
		return 0;
	}

	return 1;
}

//Function Number: 18
updatebpm()
{
	if(!isdefined(self.bpm))
	{
		self.numgrabs = 0;
		self.bpm = 0;
	}

	self.var_C230++;
	if(scripts\mp\_utility::getminutespassed() < 1)
	{
		return 0;
	}

	self.bpm = self.numgrabs / scripts\mp\_utility::getminutespassed();
	if(self.bpm < 4)
	{
		return 0;
	}

	return 1;
}

//Function Number: 19
ball_play_local_team_sound(param_00,param_01,param_02)
{
	var_03 = scripts\mp\_utility::getotherteam(param_00);
	foreach(var_05 in level.players)
	{
		if(var_05.team == param_00)
		{
			var_05 playlocalsound(param_01);
			continue;
		}

		if(var_05.team == var_03)
		{
			var_05 playlocalsound(param_02);
		}
	}
}

//Function Number: 20
ball_set_dropped(param_00,param_01,param_02,param_03)
{
	if(!isdefined(param_00))
	{
		param_00 = 0;
	}

	var_04 = 0;
	self.isresetting = 1;
	self.droptime = gettime();
	self notify("dropped");
	var_05 = (0,0,0);
	var_06 = self.carrier;
	if(isdefined(var_06) && var_06.team != "spectator")
	{
		var_07 = var_06.origin;
		var_05 = var_06.angles;
		var_06 notify("ball_dropped");
	}
	else if(isdefined(param_02))
	{
		var_07 = param_02;
	}
	else
	{
		var_07 = self.safeorigin;
	}

	var_07 = var_07 + (0,0,40);
	if(isdefined(self.projectile))
	{
		self.projectile delete();
	}

	for(var_08 = 0;var_08 < self.visuals.size;var_08++)
	{
		self.visuals[var_08].origin = var_07;
		self.visuals[var_08].angles = var_05;
		self.visuals[var_08] show();
		var_09 = self.visuals[var_08] getlinkedparent();
		if(isdefined(var_09))
		{
			self.visuals[var_08] unlink();
		}

		self.visuals[var_08] setscriptablepartstate("uplink_drone_hide","show",0);
	}

	if(scripts\mp\_utility::istrue(param_03) || scripts\mp\_utility::istrue(param_02))
	{
		var_04 = 1;
	}

	ball_carrier_cleanup(var_04);
	if(!isdefined(level.scorefrozenuntil))
	{
		level.scorefrozenuntil = 0;
	}

	if(level.scorefrozenuntil > 0)
	{
		self.trigger.origin = self.trigger.origin - (0,0,10000);
	}
	else
	{
		self.trigger.origin = var_07;
	}

	ball_dont_interpolate();
	self.curorigin = self.trigger.origin;
	if(!scripts\mp\_utility::istrue(level.devball))
	{
		thread ball_fx_start(0);
	}

	self.ownerteam = "any";
	ball_waypoint_neutral();
	scripts\mp\_gameobjects::clearcarrier();
	if(isdefined(var_06))
	{
		var_06 player_update_pass_target_hudoutline();
	}

	scripts\mp\_gameobjects::updatecompassicons();
	scripts\mp\_gameobjects::updateworldicons();
	self.isresetting = 0;
	if(!param_00)
	{
		var_0A = self.lastcarrierteam;
		var_0B = scripts\mp\_utility::getotherteam(var_0A);
		if(!scripts\mp\_utility::istrue(level.devball) && !isdefined(param_01) && !scripts\mp\_utility::istrue(param_02))
		{
			scripts\mp\_utility::statusdialog("ally_drop_drone",var_0A);
			scripts\mp\_utility::statusdialog("enemy_drop_drone",var_0B);
		}

		var_0C = (0,var_05[1],0);
		var_0D = anglestoforward(var_0C);
		if(isdefined(param_01))
		{
			var_0E = var_0D * 20 + (0,0,80);
		}
		else
		{
			var_0E = var_0E * 200 + (0,0,80);
		}

		ball_physics_launch(var_0E);
	}

	var_0F = spawnstruct();
	var_0F.carryobject = self;
	var_0F.deathoverridecallback = ::ball_overridemovingplatformdeath;
	self.trigger thread scripts\mp\_movers::handle_moving_platforms(var_0F);
	if(level.timerstoppedforgamemode)
	{
		level scripts\mp\_gamelogic::resumetimer();
	}

	return 1;
}

//Function Number: 21
ball_carrier_cleanup(param_00)
{
	if(isdefined(self.carrier))
	{
		if(level.gametype == "tdef")
		{
			self.carrier scripts\mp\gametypes\tdef::getsettdefsuit();
		}

		self.carrier.balldropdelay = undefined;
		self.carrier.nopickuptime = gettime() + 500;
		self.carrier player_clear_pass_target();
		self.carrier notify("cancel_update_pass_target");
		self.carrier.ball_carried = undefined;
		if(!scripts\mp\_utility::istrue(level.devball))
		{
			self.carrier scripts\mp\_utility::removeperk("specialty_ballcarrier");
			self.carrier scripts\mp\_lightarmor::lightarmor_unset(self.carrier);
		}

		if(self.carrier.hasperksprintfire)
		{
			self.carrier scripts\mp\_utility::removeperk("specialty_sprintfire");
		}

		self.carrier.hasperksprintfire = 0;
		if(getdvarint("com_codcasterEnabled",0) == 1)
		{
			self.carrier setgametypevip(0);
		}

		self.carrier scripts\engine\utility::allow_usability(1);
		if(scripts\mp\_utility::istrue(param_00))
		{
			foreach(var_03, var_02 in self.carrier.powers)
			{
				self.carrier scripts\mp\_powers::func_D72D(var_03);
			}
		}

		self.carrier setballpassallowed(0);
		self.carrier.objective = 0;
		self.visuals[0] setotherent(undefined);
	}
}

//Function Number: 22
ball_on_reset()
{
	ball_assign_start(level.ball_starts[self.ballindex]);
	ball_restore_contents();
	var_00 = self.visuals[0];
	var_00 scripts\mp\_movers::notify_moving_platform_invalid();
	var_01 = var_00 getlinkedparent();
	if(isdefined(var_01))
	{
		var_00 unlink();
	}

	self.visuals[0] stop_fx_idle();
	var_00 physicslaunchserver(var_00.origin,(0,0,0));
	var_00 physicsstopserver();
	ball_dont_interpolate();
	if(isdefined(self.projectile))
	{
		self.projectile delete();
	}

	var_02 = "none";
	var_03 = self.lastcarrierteam;
	if(isdefined(var_03))
	{
		var_02 = scripts\mp\_utility::getotherteam(var_03);
	}

	self.lastcarrierteam = "none";
	ball_carrier_cleanup(1);
	self.trigger scripts\mp\_movers::stop_handling_moving_platforms();
	ball_waypoint_download();
	if(level.gametype != "tdef")
	{
		scripts\mp\_gameobjects::setposition(var_00.baseorigin + (0,0,4000),(0,0,0));
		var_00 moveto(var_00.baseorigin,3,0,3);
		var_00 rotatevelocity((0,720,0),3,0,3);
	}
	else
	{
		if(!level.timerstoppedforgamemode)
		{
			level scripts\mp\_gamelogic::pausetimer();
		}

		var_00 hide(1);
		self.visuals[0] setscriptablepartstate("uplink_drone_hide","hide",0);
		thread waitforreset(var_00);
	}

	if(!scripts\mp\_utility::istrue(level.devball))
	{
		playsoundatpos(var_00.baseorigin,"mp_uplink_ball_reset");
	}

	if(!self.lastcarrierscored && isdefined(var_03) && isdefined(var_02))
	{
		if(!scripts\mp\_utility::istrue(level.devball) && var_03 != "none")
		{
			scripts\mp\_utility::statusdialog("drone_reset",var_03);
			scripts\mp\_utility::statusdialog("drone_reset",var_02);
		}

		if(isdefined(self.lastcarrier))
		{
		}
	}

	self.ownerteam = "any";
	if(level.gametype == "ball" || level.devball)
	{
		thread ball_download_wait(3);
	}

	if(!scripts\mp\_utility::istrue(level.devball))
	{
		thread ball_download_fx(var_00,3);
	}

	thread scripts\mp\_matchdata::loggameevent("obj_return",var_00.baseorigin);
}

//Function Number: 23
ball_clear_contents()
{
	self.visuals[0].oldcontents = self.visuals[0] setcontents(0);
}

//Function Number: 24
ball_pass_or_shoot()
{
	self endon("disconnect");
	thread ball_pass_watch();
	thread ball_shoot_watch();
	thread ball_weapon_change_watch();
	self.carryobject waittill("dropped");
}

//Function Number: 25
ball_pass_watch()
{
	level endon("game_ended");
	self endon("disconnect");
	self endon("death");
	self endon("drop_object");
	for(;;)
	{
		self waittill("ball_pass",var_00);
		if(var_00 != level.ballweapon)
		{
			continue;
		}

		if(!isdefined(self.pass_target))
		{
			self iprintlnbold("No Pass Target");
			continue;
		}

		self.carryobject.pass = 1;
		break;
	}

	if(isdefined(self.carryobject))
	{
		thread ball_pass_or_throw_active();
		var_01 = self.pass_target;
		var_02 = self.pass_target.origin;
		wait(0.15);
		if(isdefined(self.pass_target))
		{
			var_01 = self.pass_target;
		}

		self.carryobject thread ball_pass_projectile(self,var_01,var_02);
	}
}

//Function Number: 26
ball_shoot_watch()
{
	level endon("game_ended");
	self endon("disconnect");
	self endon("death");
	self endon("drop_object");
	if(level.gametype != "tdef")
	{
		var_00 = getdvarfloat("scr_ball_shoot_extra_pitch",0);
		var_01 = getdvarfloat("scr_ball_shoot_force",825);
	}
	else
	{
		var_00 = getdvarfloat("scr_tdef_shoot_extra_pitch",-3);
		var_01 = getdvarfloat("scr_tdef_shoot_force",450);
	}

	for(;;)
	{
		self waittill("weapon_fired",var_02);
		if(var_02 != level.ballweapon)
		{
			continue;
		}

		self setweaponammoclip(level.ballweapon,0);
		break;
	}

	if(isdefined(self.carryobject))
	{
		thread scripts\mp\_matchdata::loggameevent("pass",self.origin);
		if(!scripts\mp\_utility::istrue(level.devball))
		{
			self playsound("mp_uplink_ball_pass");
		}

		wait(0.15);
		if(self issprintsliding())
		{
			var_00 = -12;
			if(level.gametype == "tdef")
			{
				var_01 = var_01 + 200;
			}
		}

		var_03 = self getplayerangles();
		var_03 = var_03 + (var_00,0,0);
		var_03 = (clamp(var_03[0],-85,85),var_03[1],var_03[2]);
		var_04 = anglestoforward(var_03);
		thread ball_pass_or_throw_active();
		thread ball_check_pass_kill_pickup(self.carryobject);
		self.carryobject ball_create_killcam_ent();
		self.carryobject thread ball_physics_launch_drop(var_04 * var_01,self);
	}
}

//Function Number: 27
ball_weapon_change_watch()
{
	level endon("game_ended");
	self endon("disconnect");
	self endon("death");
	self endon("drop_object");
	thread superabilitywatcher();
	var_00 = level.ballweapon;
	for(;;)
	{
		if(var_00 == self getcurrentweapon())
		{
			break;
		}

		self waittill("weapon_change");
	}

	for(;;)
	{
		self waittill("weapon_change",var_01);
		var_02 = self.super;
		var_03 = var_02.staticdata.useweapon;
		if(!isdefined(var_03))
		{
			continue;
		}

		if(isdefined(var_01) && var_01 == var_03)
		{
			break;
		}
	}

	var_04 = self getplayerangles();
	var_04 = (clamp(var_04[0],-85,85),scripts\engine\utility::absangleclamp180(var_04[1] + 20),var_04[2]);
	var_05 = anglestoforward(var_04);
	var_06 = 90;
	self.carryobject thread ball_physics_launch_drop(var_05 * var_06,self,1);
}

//Function Number: 28
superabilitywatcher()
{
	self endon("death");
	self endon("disconnect");
	self endon("drop_object");
	self endon("unsetBallCarrier");
	self waittill("super_started");
	var_00 = self.super;
	switch(var_00.staticdata.ref)
	{
		case "super_chargemode":
		case "super_phaseshift":
			ball_drop_on_ability();
			break;

		case "super_teleport":
		case "super_rewind":
			scripts\engine\utility::waittill_any_3("teleport_success","rewind_success");
			ball_drop_on_ability();
			break;
	}
}

//Function Number: 29
ball_drop_on_ability()
{
	var_00 = self getplayerangles();
	var_00 = (clamp(var_00[0],-85,85),scripts\engine\utility::absangleclamp180(var_00[1] + 20),var_00[2]);
	var_01 = anglestoforward(var_00);
	var_02 = 90;
	self.carryobject thread ball_physics_launch_drop(var_01 * var_02,self,1);
}

//Function Number: 30
ball_pass_or_throw_active()
{
	self endon("death");
	self endon("disconnect");
	self.pass_or_throw_active = 1;
	self allowmelee(0);
	while(level.ballweapon == self getcurrentweapon())
	{
		scripts\engine\utility::waitframe();
	}

	self allowmelee(1);
	self.pass_or_throw_active = 0;
	foreach(var_02, var_01 in self.powers)
	{
		scripts\mp\_powers::func_D72D(var_02);
	}
}

//Function Number: 31
ball_physics_launch_drop(param_00,param_01,param_02)
{
	ball_set_dropped(1,undefined,0,param_02);
	ball_physics_launch(param_00,param_01);
}

//Function Number: 32
ball_pass_projectile(param_00,param_01,param_02)
{
	ball_set_dropped(1);
	if(isdefined(param_01))
	{
		param_02 = param_01.origin;
	}

	var_03 = param_00 getpasserorigin();
	var_04 = param_00 getpasserdirection();
	if(!validatepasstarget(self,param_00,param_01))
	{
		var_03 = self.lastvalidpassorg;
		var_04 = self.lastvalidpassdir;
	}

	var_05 = var_04 * 30;
	var_06 = var_04 * 60;
	var_07 = var_03 + var_05;
	var_08 = param_01 gettargetorigin();
	var_09 = scripts\common\trace::sphere_trace(var_07,var_08,level.balltraceradius,param_00,level.ballphysicscontentoverride,0);
	var_0A = 1;
	if(var_09["fraction"] < 1 || !scripts\mp\_utility::isreallyalive(param_01))
	{
		if(var_09["hittype"] == "hittype_entity" && isdefined(var_09["entity"]) && isplayer(var_09["entity"]))
		{
			var_0A = max(0.1,0.7 * var_09["fraction"]);
		}
		else
		{
			var_0A = 0.7 * var_09["fraction"];
		}

		scripts\mp\_gameobjects::setposition(var_07 + var_05 * var_0A,self.visuals[0].angles);
	}
	else
	{
		scripts\mp\_gameobjects::setposition(var_09["position"],self.visuals[0].angles);
	}

	if(isdefined(param_01))
	{
		self.projectile = scripts\mp\_utility::_magicbullet("uplinkball_tracking_mp",var_07 + var_06 * var_0A,var_08,param_00);
		self.projectile missile_settargetent(param_01,param_01 gettargetoffset());
	}

	self.trigger.origin = self.trigger.origin - (0,0,10000);
	param_01 thread adjust_for_stance(self.projectile);
	self.visuals[0] linkto(self.projectile);
	ball_dont_interpolate();
	ball_create_killcam_ent();
	ball_clear_contents();
	level.codcasterball = self.visuals[0];
	thread ball_on_projectile_hit_client();
	thread ball_on_projectile_death();
	thread ball_on_host_migration();
	thread ball_track_pass_velocity(param_01);
	thread ball_track_pass_lifetime();
	thread ball_track_target(param_01);
	if(level.gametype == "ball")
	{
		thread scripts\mp\gametypes\ball::ball_pass_touch_goal();
	}
}

//Function Number: 33
player_update_pass_target(param_00)
{
	self endon("disconnect");
	self endon("cancel_update_pass_target");
	player_update_pass_target_hudoutline();
	childthread player_joined_update_pass_target_hudoutline();
	for(;;)
	{
		var_01 = undefined;
		if(!self isonladder())
		{
			var_02 = [];
			foreach(var_04 in level.players)
			{
				if(!isdefined(var_04.team))
				{
					continue;
				}

				if(var_04.team != self.team)
				{
					continue;
				}

				if(!scripts\mp\_utility::isreallyalive(var_04))
				{
					continue;
				}

				if(!param_00 ball_can_pickup(var_04))
				{
					continue;
				}

				if(validatepasstarget(param_00,self,var_04))
				{
					var_02[var_02.size] = var_04;
				}
			}

			if(isdefined(var_02) && var_02.size > 0)
			{
				var_02 = scripts\mp\_utility::quicksort(var_02,::compare_player_pass_dot);
				var_06 = self geteye();
				foreach(var_04 in var_02)
				{
					var_08 = var_04 gettargetorigin();
					if(sighttracepassed(var_06,var_08,0,self,var_04))
					{
						var_01 = var_04;
						break;
					}
				}
			}
		}

		player_set_pass_target(var_01);
		scripts\engine\utility::waitframe();
	}
}

//Function Number: 34
validatepasstarget(param_00,param_01,param_02)
{
	var_03 = 0.85;
	var_04 = param_01 getpasserorigin();
	var_05 = param_01 getpasserdirection();
	var_06 = param_02 gettargetorigin();
	var_07 = distancesquared(var_06,var_04);
	if(var_07 > level.ballpassdist)
	{
		return 0;
	}

	var_08 = vectornormalize(var_06 - var_04);
	var_09 = vectordot(var_05,var_08);
	if(var_09 > var_03)
	{
		var_0A = var_05 * 30;
		var_0B = var_04 + var_0A;
		var_0C = scripts\common\trace::sphere_trace(var_0B,var_06,level.balltraceradius,param_01,level.ballphysicscontentoverride,0);
		if((isdefined(var_0C["entity"]) && isplayer(var_0C["entity"])) || var_0C["fraction"] > 0.8)
		{
			param_02.pass_dot = var_09;
			param_00.lastvalidpassorg = var_04;
			param_00.lastvalidpassdir = var_05;
			return 1;
		}
	}

	return 0;
}

//Function Number: 35
player_update_pass_target_hudoutline()
{
	if(!isdefined(self))
	{
		return;
	}

	if(!isdefined(self.carryobject))
	{
		return;
	}

	if(isdefined(self.carryobject.passtargetoutlineid) && isdefined(self.carryobject.passtargetent))
	{
		scripts\mp\_utility::outlinedisable(self.carryobject.passtargetoutlineid,self.carryobject.passtargetent);
		self.carryobject.passtargetoutlineid = undefined;
		self.carryobject.passtargetent = undefined;
	}

	if(isdefined(self.carryobject.playeroutlineid) && isdefined(self.carryobject.playeroutlined))
	{
		scripts\mp\_utility::outlinedisable(self.carryobject.playeroutlineid,self.carryobject.playeroutlined);
		self.carryobject.playeroutlineid = undefined;
		self.carryobject.playeroutlined = undefined;
	}

	if(self.carryobject.isresetting)
	{
		return;
	}

	var_00 = [];
	var_01 = [];
	var_02 = scripts\mp\_utility::getotherteam(self.team);
	var_03 = undefined;
	var_04 = undefined;
	foreach(var_06 in level.players)
	{
		if(var_06 == self)
		{
			continue;
		}

		if(var_06.team == self.team)
		{
			var_00[var_00.size] = var_06;
			continue;
		}

		if(var_06.team == var_02)
		{
			var_01[var_01.size] = var_06;
		}
	}

	foreach(var_06 in var_00)
	{
		var_09 = isdefined(self.pass_target) && self.pass_target == var_06;
	}

	if(isdefined(self.pass_target))
	{
		var_03 = scripts\mp\_utility::outlineenableforplayer(self.pass_target,"cyan",self,1,0,"level_script");
	}

	self.carryobject.passtargetoutlineid = var_03;
	self.carryobject.passtargetent = self.pass_target;
	if(level.gametype == "tdef" && var_00.size > 0)
	{
		var_04 = scripts\mp\_utility::outlineenableforteam(self,"cyan",self.team,0,1,"level_script");
	}

	self.carryobject.playeroutlineid = var_04;
	self.carryobject.playeroutlined = self;
}

//Function Number: 36
adjust_for_stance(param_00)
{
	var_01 = self;
	param_00 endon("pass_end");
	while(isdefined(var_01) && isdefined(param_00))
	{
		param_00 missile_settargetent(var_01,var_01 gettargetoffset());
		scripts\engine\utility::waitframe();
	}
}

//Function Number: 37
compare_player_pass_dot(param_00,param_01)
{
	return param_00.pass_dot >= param_01.pass_dot;
}

//Function Number: 38
player_joined_update_pass_target_hudoutline()
{
	for(;;)
	{
		level waittill("joined_team",var_00);
		player_update_pass_target_hudoutline();
	}
}

//Function Number: 39
player_set_pass_target(param_00)
{
	var_01 = 80;
	var_02 = 0;
	if(isdefined(param_00))
	{
		switch(param_00 getstance())
		{
			case "crouch":
				var_01 = 60;
				break;

			case "prone":
				var_01 = 35;
				break;
		}

		if(!isdefined(self.pass_icon_offset) || self.pass_icon_offset != var_01)
		{
			var_02 = 1;
			self.pass_icon_offset = var_01;
		}
	}

	var_03 = (0,0,var_01);
	if(isdefined(self.pass_target) && isdefined(param_00) && self.pass_target == param_00)
	{
		if(var_02)
		{
			self.pass_icon = param_00 scripts\mp\_entityheadicons::setheadicon(self,"waypoint_ball_pass",var_03,10,10,0,0.05,0,1,0,0);
		}

		return;
	}

	if(!isdefined(self.pass_target) && !isdefined(param_00))
	{
		return;
	}

	player_clear_pass_target();
	if(isdefined(param_00))
	{
		self.pass_icon = param_00 scripts\mp\_entityheadicons::setheadicon(self,"waypoint_ball_pass",var_03,10,10,0,0.05,0,1,0,0);
		self.pass_target = param_00;
		var_04 = [];
		foreach(var_06 in level.players)
		{
			if(var_06.team == self.team && var_06 != self && var_06 != param_00)
			{
				var_04[var_04.size] = var_06;
			}
		}

		self setballpassallowed(1);
	}

	player_update_pass_target_hudoutline();
}

//Function Number: 40
player_clear_pass_target()
{
	if(isdefined(self.pass_icon))
	{
		self.pass_icon destroy();
	}

	var_00 = [];
	foreach(var_02 in level.players)
	{
		if(var_02.team == self.team && var_02 != self)
		{
			var_00[var_00.size] = var_02;
		}
	}

	self.pass_target = undefined;
	self setballpassallowed(0);
	player_update_pass_target_hudoutline();
}

//Function Number: 41
player_no_pickup_time()
{
	return (isdefined(self.nopickuptime) && self.nopickuptime > gettime()) || isdefined(self.ball_carried);
}

//Function Number: 42
valid_ball_super_pickup(param_00)
{
	if(!isdefined(param_00.super))
	{
		return 1;
	}

	if(!isdefined(param_00.super.isinuse) || !param_00.super.isinuse)
	{
		return 1;
	}

	if(param_00.super.staticdata.ref == "super_phaseshift")
	{
		return 0;
	}

	return 1;
}

//Function Number: 43
valid_ball_pickup_weapon(param_00)
{
	if(param_00 == "none")
	{
		return 0;
	}

	if(param_00 == level.ballweapon)
	{
		return 0;
	}

	if(param_00 == "ks_remote_map_mp")
	{
		return 0;
	}

	if(param_00 == "ks_remote_device_mp")
	{
		return 0;
	}

	if(scripts\mp\_utility::iskillstreakweapon(param_00))
	{
		return 0;
	}

	return 1;
}

//Function Number: 44
ball_on_host_migration()
{
	self.visuals[0] endon("pass_end");
	level waittill("host_migration_begin");
	if(isdefined(self.projectile))
	{
		if(!isdefined(self.pass_target) && !isdefined(self.carrier) && !self.in_goal)
		{
			if(self.visuals[0].origin != self.visuals[0].baseorigin + (0,0,4000))
			{
				ball_restore_contents();
				if(!isdefined(self.lastpassdir))
				{
					self.lastpassdir = (0,0,1);
				}

				ball_physics_launch(self.lastpassdir * 400);
				return;
			}
		}
	}
}

//Function Number: 45
ball_track_pass_velocity(param_00)
{
	self.visuals[0] endon("pass_end");
	self.projectile endon("projectile_impact_player");
	self.projectile endon("death");
	self.lastpassdir = vectornormalize(param_00.origin - self.projectile.origin);
	var_01 = undefined;
	for(;;)
	{
		if(isdefined(var_01))
		{
			self.lastpassdir = vectornormalize(self.projectile.origin - var_01);
		}

		var_01 = self.projectile.origin;
		scripts\engine\utility::waitframe();
	}
}

//Function Number: 46
ball_track_pass_lifetime()
{
	self.visuals[0] endon("pass_end");
	self.projectile endon("projectile_impact_player");
	self.projectile endon("death");
	var_00 = gettime();
	for(var_01 = var_00;var_01 < var_00 + 2000;var_01 = gettime())
	{
		scripts\engine\utility::waitframe();
	}

	self.projectile delete();
}

//Function Number: 47
ball_track_target(param_00)
{
	self.visuals[0] endon("pass_end");
	self.projectile endon("projectile_impact_player");
	self.projectile endon("death");
	for(;;)
	{
		if(!isdefined(param_00))
		{
			break;
		}

		if(!scripts\mp\_utility::isreallyalive(param_00))
		{
			break;
		}

		if(isdefined(param_00.super) && scripts\mp\_utility::istrue(param_00.super.isinuse))
		{
			if(param_00.super.staticdata.ref == "super_phaseshift")
			{
				break;
			}
		}

		scripts\engine\utility::waitframe();
	}

	self.projectile delete();
}

//Function Number: 48
ball_on_projectile_death()
{
	self endon("reset");
	self.projectile waittill("death");
	waittillframeend;
	if(!isdefined(self.carrier))
	{
		self.trigger.origin = self.curorigin;
	}

	var_00 = self.visuals[0];
	if(!isdefined(self.carrier) && !self.in_goal)
	{
		if(var_00.origin != var_00.baseorigin + (0,0,4000))
		{
			ball_restore_contents();
			if(!isdefined(self.lastpassdir))
			{
				self.lastpassdir = (0,0,1);
			}

			ball_physics_launch(self.lastpassdir * 400);
		}
	}

	ball_restore_contents();
	var_00 notify("pass_end");
}

//Function Number: 49
ball_on_projectile_hit_client()
{
	self.visuals[0] endon("pass_end");
	self.projectile waittill("projectile_impact_player",var_00);
	self.trigger.origin = self.visuals[0].origin;
	self.trigger notify("trigger",var_00);
}

//Function Number: 50
ball_physics_launch(param_00,param_01)
{
	var_02 = self.visuals[0];
	var_02.origin_prev = undefined;
	var_03 = var_02.origin;
	var_04 = var_02;
	if(isdefined(param_01))
	{
		var_04 = param_01;
		var_03 = param_01 geteye();
		var_05 = anglestoright(param_00);
		var_03 = var_03 + (var_05[0],var_05[1],0) * 7;
		if(param_01 issprintsliding())
		{
			var_03 = var_03 + (0,0,10);
		}

		var_06 = var_03;
		var_07 = vectornormalize(param_00) * 80;
		var_08 = ["physicscontents_clipshot","physicscontents_corpseclipshot","physicscontents_missileclip","physicscontents_solid","physicscontents_vehicle","physicscontents_player","physicscontents_actor","physicscontents_glass","physicscontents_itemclip"];
		var_09 = physics_createcontents(var_08);
		var_0A = scripts\common\trace::sphere_trace(var_06,var_06 + var_07,38,param_01,var_09);
		if(var_0A["fraction"] < 1)
		{
			var_0B = 0.7 * var_0A["fraction"];
			scripts\mp\_gameobjects::setposition(var_06 + var_07 * var_0B,var_02.angles);
		}
		else
		{
			scripts\mp\_gameobjects::setposition(var_0A["position"],var_02.angles);
		}
	}

	self.visuals[0] physicslaunchserver(var_02.origin,param_00);
	self.visuals[0] thread scripts\mp\_utility::register_physics_collisions();
	self.visuals[0] physics_registerforcollisioncallback();
	scripts\mp\_utility::register_physics_collision_func(self.visuals[0],::ball_impact_sounds);
	self.visuals[0].origin = self.trigger.origin;
	self.trigger linkto(self.visuals[0]);
	level.codcasterball = self.visuals[0];
	level.codcasterballowner = var_04;
	level.codcasterballinitialforcevector = param_00;
	thread ball_physics_timeout(param_01);
	thread ball_physics_bad_trigger_watch();
	thread ball_physics_out_of_level();
	if(level.gametype == "ball")
	{
		thread scripts\mp\gametypes\ball::ball_physics_touch_goal();
	}

	thread ball_physics_touch_cant_pickup_player(param_01);
}

//Function Number: 51
ball_physics_touch_cant_pickup_player(param_00)
{
	var_01 = self.visuals[0];
	var_02 = self.trigger;
	self.visuals[0] endon("physics_finished");
	self endon("physics_timeout");
	self endon("pickup_object");
	self endon("reset");
	self endon("score_event");
	for(;;)
	{
		var_02 waittill("trigger",var_03);
		if(scripts\mp\_utility::func_9F22(var_03))
		{
			continue;
		}

		if(!isplayer(var_03) && !isagent(var_03))
		{
			continue;
		}

		if(isdefined(param_00) && param_00 == var_03 && var_03 player_no_pickup_time())
		{
			continue;
		}

		if(self.droptime >= gettime())
		{
			continue;
		}

		if(var_01.origin == var_01.baseorigin + (0,0,4000))
		{
			continue;
		}

		if(!ball_can_pickup(var_03))
		{
			if(var_03 player_no_pickup_time())
			{
				continue;
			}

			var_03.nopickuptime = gettime() + 500;
			thread ball_physics_fake_bounce();
		}
	}
}

//Function Number: 52
ball_physics_fake_bounce(param_00)
{
	var_01 = self.visuals[0];
	var_02 = var_01 physics_getbodyid(0);
	var_03 = function_026E(var_02);
	if(isdefined(param_00) && param_00)
	{
		var_04 = length(var_03) * 0.4;
		thread watchstuckinnozone();
	}
	else
	{
		var_04 = length(var_04) / 10;
	}

	var_05 = vectornormalize(var_03);
	var_05 = (-1,-1,-0.5) * var_05;
	var_01 physicslaunchserver(var_01.origin,(0,0,0));
	var_01 physicsstopserver();
	var_01 physicslaunchserver(var_01.origin,var_05 * var_04);
	var_01.physicsactivated = 1;
}

//Function Number: 53
physics_impact_watch()
{
	self endon("death");
	for(;;)
	{
		self waittill("projectile_impact",var_00,var_01,var_02,var_03);
		var_04 = level._effect["ball_physics_impact"];
		if(isdefined(var_03) && isdefined(level._effect["ball_physics_impact_" + var_03]))
		{
			var_04 = level._effect["ball_physics_impact_" + var_03];
		}

		if(!scripts\mp\_utility::istrue(level.devball))
		{
			playfx(var_04,var_00,var_01);
		}

		wait(0.3);
	}
}

//Function Number: 54
ball_impact_sounds(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08)
{
	var_09 = param_00 physics_getbodyid(0);
	var_0A = function_026E(var_09);
	var_0B = length(var_0A);
	if(isdefined(param_00.playing_sound) || var_0B < 70)
	{
		return;
	}

	param_00 endon("death");
	param_00.playing_sound = 1;
	var_0C = "mp_uplink_ball_bounce";
	param_00 playsound(var_0C);
	var_0D = lookupsoundlength(var_0C);
	wait(0.1);
	param_00.playing_sound = undefined;
}

//Function Number: 55
ball_return_home(param_00,param_01)
{
	self.ball_fx_active = 0;
	if(scripts\mp\_utility::istrue(level.explodeonexpire) && scripts\mp\_utility::istrue(param_00))
	{
		detonateball();
	}

	if(scripts\mp\_utility::istrue(level.possessionresetcondition))
	{
		if(scripts\mp\_utility::istrue(level.ballactivationdelay))
		{
			level updatetimers("neutral",0,1);
		}
		else
		{
			level updatetimers("neutral",1,1);
		}
	}

	level.codcasterball = undefined;
	level.codcasterballinitialforcevector = undefined;
	level.ballreset = 1;
	self.in_goal = 0;
	var_02 = self.visuals[0];
	var_02 physicslaunchserver(var_02.origin,(0,0,0));
	var_02 physicsstopserver();
	if(!scripts\mp\_utility::istrue(level.devball))
	{
		playsoundatpos(var_02.origin,"mp_uplink_ball_out_of_bounds");
		playfx(scripts\engine\utility::getfx("ball_teleport"),var_02.origin);
	}

	if(param_01)
	{
		scripts\mp\_utility::setmlgannouncement(2,"free");
	}

	if(isdefined(self.carrier))
	{
		self.carrier scripts\engine\utility::delaythread(0.05,::player_update_pass_target_hudoutline);
	}

	self.visuals[0] setscriptablepartstate("uplink_drone_hide","show",0);
	thread scripts\mp\_gameobjects::returnobjectiveid();
}

//Function Number: 56
ball_overridemovingplatformdeath(param_00)
{
	param_00.carryobject ball_return_home(0,1);
}

//Function Number: 57
ball_download_wait(param_00)
{
	self endon("pickup_object");
	scripts\mp\_gameobjects::allowcarry("none");
	self.isresetting = 1;
	wait(param_00);
	self.isresetting = 0;
	ball_waypoint_neutral();
	scripts\mp\_gameobjects::allowcarry("any");
	self notify("ball_ready");
	if(!scripts\mp\_utility::istrue(level.devball))
	{
		playfx(level._effect["ball_download_end"],self.curorigin);
		thread ball_fx_start(0,1);
	}

	if(level.gametype == "tdef")
	{
		level updatetimers("neutral",1,1);
		level.balls[0] thread starthoveranim();
	}
}

//Function Number: 58
waitforreset(param_00)
{
	self endon("pickup_object");
	self endon("game_ended");
	scripts\mp\_gameobjects::allowcarry("none");
	if(level.ballactivationdelay != 0)
	{
		scripts\mp\_hostmigration::waitlongdurationwithhostmigrationpause(level.ballactivationdelay);
	}

	if(level.timerstoppedforgamemode)
	{
		level scripts\mp\_gamelogic::resumetimer();
	}

	scripts\mp\_gameobjects::setposition(param_00.baseorigin,(0,0,0));
	self.visuals[0] setscriptablepartstate("uplink_drone_hide","show",0);
	thread ball_download_wait(0);
	param_00 rotatevelocity((0,720,0),3,0,3);
}

//Function Number: 59
starthoveranim()
{
	self endon("death");
	self endon("reset");
	self endon("pickup_object");
	self notify("hoverAnimStart");
	self endon("hoverAnimStart");
	var_00 = self.visuals[0].origin;
	self.visuals[0] rotateyaw(2000,60,0.2,0.2);
	for(;;)
	{
		self.visuals[0] moveto(var_00 + (0,0,5),1,0.5,0.5);
		wait(1);
		self.visuals[0] moveto(var_00 - (0,0,5),1,0.5,0.5);
		wait(1);
	}
}

//Function Number: 60
ball_physics_out_of_level()
{
	self endon("reset");
	self endon("pickup_object");
	var_00 = self.visuals[0];
	var_01[0] = 200;
	var_01[1] = 200;
	var_01[2] = 1000;
	var_02[0] = 200;
	var_02[1] = 200;
	var_02[2] = 200;
	for(;;)
	{
		for(var_03 = 0;var_03 < 2;var_03++)
		{
			if(var_00.origin[var_03] > level.ball_maxs[var_03] + var_01[var_03])
			{
				ball_return_home(1,1);
				return;
			}

			if(var_00.origin[var_03] < level.ball_mins[var_03] - var_02[var_03])
			{
				ball_return_home(1,1);
				return;
			}
		}

		scripts\engine\utility::waitframe();
	}
}

//Function Number: 61
ball_physics_timeout(param_00)
{
	self endon("reset");
	self endon("pickup_object");
	self endon("score_event");
	if(!isdefined(level.idleresettime))
	{
		level.idleresettime = 15;
	}

	var_01 = level.idleresettime;
	var_02 = 10;
	var_03 = 3;
	if(var_01 >= var_02)
	{
		wait(var_03);
		var_01 = var_01 - var_03;
	}

	wait(var_01);
	self notify("physics_timeout");
	ball_return_home(1,1);
}

//Function Number: 62
ball_physics_bad_trigger_watch()
{
	self.visuals[0] endon("physics_finished");
	self endon("physics_timeout");
	self endon("pickup_object");
	self endon("reset");
	self endon("score_event");
	thread ball_physics_bad_trigger_at_rest();
	for(;;)
	{
		if(self.visuals[0] touchingnozonetrigger())
		{
			thread ball_physics_fake_bounce(1);
		}

		if(!self.visuals[0] scripts\mp\_utility::touchingballallowedtrigger())
		{
			if(self.visuals[0] scripts\mp\_utility::touchingbadtrigger() || self.visuals[0] scripts\mp\_utility::func_11A44())
			{
				ball_return_home(0,1);
				return;
			}
		}

		scripts\engine\utility::waitframe();
	}
}

//Function Number: 63
touchingnozonetrigger()
{
	if(level.nozonetriggers.size > 0)
	{
		foreach(var_01 in level.nozonetriggers)
		{
			if(self istouching(var_01))
			{
				return 1;
			}
		}
	}

	return 0;
}

//Function Number: 64
watchstuckinnozone()
{
	self.visuals[0] endon("physics_finished");
	self endon("physics_timeout");
	self endon("pickup_object");
	self endon("reset");
	self endon("score_event");
	var_00 = gettime();
	var_01 = var_00 + 500;
	for(;;)
	{
		if(self.visuals[0] touchingnozonetrigger() && var_01 < var_00)
		{
			ball_return_home(1,1);
			return;
		}

		wait(0.05);
		var_00 = gettime();
	}
}

//Function Number: 65
ball_physics_bad_trigger_at_rest()
{
	self endon("pickup_object");
	self endon("reset");
	self endon("score_event");
	var_00 = self.visuals[0];
	var_00 endon("death");
	var_00 waittill("physics_finished");
	if(scripts\mp\_utility::touchingbadtrigger())
	{
		ball_return_home(1,1);
	}
}

//Function Number: 66
ball_location_hud()
{
	for(;;)
	{
		var_00 = scripts\engine\utility::waittill_any_return("pickup_object","dropped","reset","ball_ready");
		switch(var_00)
		{
			case "pickup_object":
				setomnvar("ui_uplink_ball_carrier",self.carrier getentitynumber());
				setomnvar("ui_uplink_timer_text",1);
				break;
	
			case "dropped":
				setomnvar("ui_uplink_ball_carrier",-2);
				break;
	
			case "reset":
				setomnvar("ui_uplink_ball_carrier",-3);
				setomnvar("ui_uplink_timer_text",2);
				break;
	
			case "ball_ready":
				setomnvar("ui_uplink_timer_text",1);
				setomnvar("ui_uplink_ball_carrier",-1);
				break;
	
			default:
				break;
		}
	}
}

//Function Number: 67
ball_check_pass_kill_pickup(param_00)
{
	self endon("death");
	self endon("disconnect");
	param_00 endon("reset");
	var_01 = spawnstruct();
	var_01 endon("timer_done");
	var_01 thread timer_run(1.5);
	param_00 waittill("pickup_object");
	var_01 timer_cancel();
	if(!isdefined(param_00.carrier) || param_00.carrier.team == self.team)
	{
		return;
	}

	param_00.carrier endon("disconnect");
	var_01 thread timer_run(5);
	param_00.carrier waittill("death",var_02);
	var_01 timer_cancel();
	if(!isdefined(var_02) || var_02 != self)
	{
		return;
	}

	var_01 thread timer_run(2);
	param_00 waittill("pickup_object");
	var_01 timer_cancel();
	if(isdefined(param_00.carrier) && param_00.carrier == self)
	{
		thread scripts\mp\_utility::giveunifiedpoints("ball_pass_kill");
	}
}

//Function Number: 68
timer_run(param_00)
{
	self endon("cancel_timer");
	wait(param_00);
	self notify("timer_done");
}

//Function Number: 69
timer_cancel()
{
	self notify("cancel_timer");
}

//Function Number: 70
ball_waypoint_neutral()
{
	scripts\mp\_gameobjects::set2dicon("friendly","waypoint_neutral_ball");
	scripts\mp\_gameobjects::set2dicon("enemy","waypoint_neutral_ball");
	scripts\mp\_gameobjects::set3dicon("friendly","waypoint_neutral_ball");
	scripts\mp\_gameobjects::set3dicon("enemy","waypoint_neutral_ball");
}

//Function Number: 71
ball_waypoint_held(param_00)
{
	if(level.gametype == "ball")
	{
		var_01 = "waypoint_escort";
	}
	else
	{
		var_01 = "waypoint_defend_round";
	}

	scripts\mp\_gameobjects::set2dicon("friendly",var_01);
	scripts\mp\_gameobjects::set2dicon("enemy","waypoint_capture_kill_round");
	scripts\mp\_gameobjects::set3dicon("friendly",var_01);
	scripts\mp\_gameobjects::set3dicon("enemy","waypoint_capture_kill_round");
}

//Function Number: 72
ball_waypoint_download()
{
	if(level.gametype == "ball")
	{
		var_00 = "waypoint_ball_download";
	}
	else
	{
		var_00 = "waypoint_reset_marker";
	}

	scripts\mp\_gameobjects::set2dicon("friendly",var_00);
	scripts\mp\_gameobjects::set2dicon("enemy",var_00);
	scripts\mp\_gameobjects::set3dicon("friendly",var_00);
	scripts\mp\_gameobjects::set3dicon("enemy",var_00);
}

//Function Number: 73
ball_waypoint_upload()
{
	scripts\mp\_gameobjects::set2dicon("friendly","waypoint_ball_upload");
	scripts\mp\_gameobjects::set2dicon("enemy","waypoint_ball_upload");
	scripts\mp\_gameobjects::set3dicon("friendly","waypoint_ball_upload");
	scripts\mp\_gameobjects::set3dicon("enemy","waypoint_ball_upload");
}

//Function Number: 74
ball_restore_contents()
{
	if(isdefined(self.visuals[0].oldcontents))
	{
		self.visuals[0] setcontents(self.visuals[0].oldcontents);
		self.visuals[0].oldcontents = undefined;
	}
}

//Function Number: 75
ball_dont_interpolate()
{
	self.visuals[0] dontinterpolate();
	self.ball_fx_active = 0;
}

//Function Number: 76
ball_assign_start(param_00)
{
	foreach(var_02 in self.visuals)
	{
		var_02.baseorigin = param_00.origin;
	}

	self.trigger.baseorigin = param_00.origin;
	self.current_start = param_00;
	param_00.in_use = 1;
}

//Function Number: 77
ball_create_killcam_ent()
{
	if(isdefined(self.killcament))
	{
		self.killcament delete();
	}

	self.killcament = spawn("script_model",self.visuals[0].origin);
	self.killcament linkto(self.visuals[0]);
	self.killcament setcontents(0);
	self.killcament setscriptmoverkillcam("explosive");
}

//Function Number: 78
initballtimer()
{
	level.balltime = level.possessionresettime;
	level.balltimerpaused = 1;
	level.balltimerstopped = 0;
	if(isdefined(level.possessionresetcondition) && level.possessionresetcondition != 0)
	{
		setomnvar("ui_uplink_timer_show",1);
		setomnvar("ui_uplink_timer_text",1);
		thread createhudelems();
		return;
	}

	setomnvar("ui_uplink_timer_show",0);
}

//Function Number: 79
createhudelems()
{
	level endon("game_ended");
	scripts\mp\_utility::gameflagwait("prematch_done");
	updatetimers("neutral",1,1);
}

//Function Number: 80
updatetimers(param_00,param_01,param_02,param_03)
{
	if(!scripts\mp\_utility::istrue(level.possessionresetcondition))
	{
		return;
	}

	var_04 = undefined;
	var_05 = 1000 * level.possessionresettime;
	if(scripts\mp\_utility::istrue(param_02))
	{
		if(scripts\mp\_utility::istrue(level.ballactivationdelay) && !scripts\mp\_utility::istrue(level.ballreset))
		{
			var_05 = 1000 * level.ballactivationdelay;
		}
	}

	if(scripts\mp\_utility::istrue(param_02) || scripts\mp\_utility::istrue(param_03))
	{
		level.balltime = level.possessionresettime;
		level.ballendtime = int(gettime() + var_05);
	}
	else
	{
		level.ballendtime = int(gettime() + 1000 * level.balltime);
	}

	setomnvar("ui_hardpoint_timer",level.ballendtime);
	if(var_05 > 0 && scripts\mp\_utility::istrue(param_03) || !param_01 && level.balltimerpaused)
	{
		level.ball thread ballruntimer(param_00,var_04);
	}

	if(level.balltime > 1)
	{
		if(param_01)
		{
			level pauseballtimer();
		}
	}
}

//Function Number: 81
ballruntimer(param_00,param_01)
{
	level endon("game_ended");
	level endon("reset");
	level endon("pause_ball_timer");
	level notify("ballRunTimer");
	level endon("ballRunTimer");
	level.balltimerpaused = 0;
	balltimerwait(param_00,param_01);
	if(isdefined(level.ball) && isdefined(level.ball.carrier))
	{
		self.carrier scripts\mp\_missions::func_27FA();
	}

	if(!scripts\mp\_utility::istrue(level.ballreset))
	{
		scripts\mp\_gameobjects::allowcarry("none");
		ball_set_dropped(1,self.trigger.origin,1);
		ball_return_home(1,1);
	}
}

//Function Number: 82
balltimerwait(param_00,param_01)
{
	level endon("game_ended");
	level endon("pause_ball_timer");
	var_02 = scripts\engine\utility::ter_op(isdefined(param_01),param_01,int(level.balltime * 1000 + gettime()));
	level resumeballtimer(param_01);
	thread watchtimerpause();
	level thread handlehostmigration(var_02);
	waitballlongdurationwithgameendtimeupdate(level.balltime);
}

//Function Number: 83
waitballlongdurationwithgameendtimeupdate(param_00)
{
	level endon("game_ended");
	level endon("pause_ball_timer");
	if(param_00 == 0)
	{
		return;
	}

	var_01 = gettime();
	var_02 = gettime() + param_00 * 1000;
	while(gettime() < var_02)
	{
		waittillballhostmigrationstarts(var_02 - gettime() / 1000);
		while(isdefined(level.hostmigrationtimer))
		{
			var_02 = var_02 + 1000;
			function_01AF(int(var_02));
			wait(1);
		}
	}

	while(isdefined(level.hostmigrationtimer))
	{
		var_02 = var_02 + 1000;
		function_01AF(int(var_02));
		wait(1);
	}

	return gettime() - var_01;
}

//Function Number: 84
waittillballhostmigrationstarts(param_00)
{
	level endon("game_ended");
	level endon("pause_ball_timer");
	if(isdefined(level.hostmigrationtimer))
	{
		return;
	}

	level endon("host_migration_begin");
	wait(param_00);
}

//Function Number: 85
handlehostmigration(param_00)
{
	level endon("game_ended");
	level endon("disconnect");
	level waittill("host_migration_begin");
	setomnvar("ui_uplink_timer_stopped",1);
	var_01 = scripts\mp\_hostmigration::waittillhostmigrationdone();
	if(!level.balltimerstopped)
	{
		setomnvar("ui_uplink_timer_stopped",0);
	}

	if(var_01 > 0)
	{
		setomnvar("ui_hardpoint_timer",level.ballendtime + var_01);
		return;
	}

	setomnvar("ui_hardpoint_timer",level.ballendtime);
}

//Function Number: 86
watchtimerpause()
{
	level endon("game_ended");
	level notify("watchResetSoon");
	level endon("watchResetSoon");
	var_00 = 0;
	var_01 = undefined;
	while(level.balltime > 0 && !level.balltimerpaused)
	{
		var_02 = gettime();
		if(!var_00 && level.balltime < 10)
		{
			level scripts\mp\_utility::statusdialog("drone_reset_soon","allies");
			level scripts\mp\_utility::statusdialog("drone_reset_soon","axis");
			var_00 = 1;
		}

		if(isdefined(level.balls[0].carrier) && level.balltime < 5)
		{
			if(!isdefined(var_01) || var_02 > var_01 + 1000)
			{
				var_01 = var_02;
				level.balls[0].carrier playsoundtoplayer("mp_cranked_countdown",level.balls[0].carrier);
			}
		}

		var_03 = 0.05;
		wait(var_03);
		level.balltime = level.balltime - var_03;
	}

	if(level.balltimerpaused)
	{
		level notify("pause_ball_timer");
	}
}

//Function Number: 87
updateballtimerpausedness(param_00)
{
	var_01 = level.balltimerpaused || isdefined(level.hostmigrationtimer);
	if(!scripts\mp\_utility::gameflag("prematch_done"))
	{
		var_01 = 0;
	}

	if(!level.balltimerstopped && var_01)
	{
		level.balltimerstopped = 1;
		setomnvar("ui_uplink_timer_stopped",1);
		return;
	}

	if(level.balltimerstopped && !var_01)
	{
		level.balltimerstopped = 0;
		setomnvar("ui_uplink_timer_stopped",0);
	}
}

//Function Number: 88
pauseballtimer()
{
	level.balltimerpaused = 1;
	updateballtimerpausedness();
}

//Function Number: 89
resumeballtimer(param_00)
{
	level.balltimerpaused = 0;
	updateballtimerpausedness(param_00);
}

//Function Number: 90
ball_player_on_connect()
{
	if(!scripts\mp\_utility::istrue(level.devball))
	{
		foreach(var_01 in level.balls)
		{
			var_01 ball_fx_start_player(self);
		}
	}
}

//Function Number: 91
ball_fx_start_player(param_00)
{
	if(ball_fx_active())
	{
		self.visuals[0] setscriptablepartstate("uplink_drone_idle","normal",0);
		self.visuals[0] setscriptablepartstate("uplink_drone_tail","normal",0);
	}
}

//Function Number: 92
ball_fx_start(param_00,param_01)
{
	self endon("reset");
	self endon("pickup_object");
	if(scripts\mp\_utility::istrue(param_00))
	{
		wait(0.2);
	}
	else
	{
		wait(0.05);
	}

	if(!ball_fx_active())
	{
		self.visuals[0] setscriptablepartstate("uplink_drone_idle","normal",0);
		self.visuals[0] setscriptablepartstate("uplink_drone_tail","normal",0);
		self.ball_fx_active = 1;
	}
}

//Function Number: 93
ball_fx_active()
{
	return isdefined(self.ball_fx_active) && self.ball_fx_active;
}

//Function Number: 94
ball_fx_stop()
{
	if(ball_fx_active())
	{
		self.visuals[0] stop_fx_idle();
	}

	self.ball_fx_active = 0;
}

//Function Number: 95
stop_fx_idle()
{
	self setscriptablepartstate("uplink_drone_idle","off",0);
	self setscriptablepartstate("uplink_drone_tail","off",0);
}

//Function Number: 96
ball_download_fx(param_00,param_01)
{
	scripts\engine\utility::waittill_notify_or_timeout("pickup_object",param_01);
	level.scorefrozenuntil = 0;
	level notify("goal_ready");
}

//Function Number: 97
moveballtoplayer()
{
	level notify("practice");
	level endon("practice");
	level endon("game_ended");
	wait(5);
	for(;;)
	{
		self waittill("call_ball");
		if(!isdefined(level.balls[0].carrier))
		{
			level.balls[0].visuals[0] physicslaunchserver(level.balls[0].visuals[0].origin,(0,0,0));
			level.balls[0].visuals[0] physicsstopserver();
			while(!isdefined(level.balls[0].carrier))
			{
				var_00 = 40;
				switch(self getstance())
				{
					case "crouch":
						var_00 = 30;
						break;
	
					case "prone":
						var_00 = 15;
						break;
				}

				level.balls[0].visuals[0] moveto(self.origin + (0,0,var_00),0.3,0.15,0.1);
				wait(0.1);
			}
		}

		wait(1);
	}
}

//Function Number: 98
practicenotify()
{
	level endon("game_ended");
	self endon("disconnect");
	var_00 = 1;
	for(;;)
	{
		if(var_00)
		{
			self waittill("giveLoadout");
		}
		else
		{
			self waittill("spawned");
		}

		var_00 = 0;
		if(var_00)
		{
			wait(20);
		}
		else
		{
			wait(2);
		}

		thread givepracticemessage();
	}
}

//Function Number: 99
givepracticemessage()
{
	self notify("practiceMessage");
	self endon("practiceMessage");
	self endon("disconnect");
	self endon("death");
	level endon("game_ended");
	if(scripts\engine\utility::is_player_gamepad_enabled())
	{
		self notifyonplayercommand("call_ball","+actionslot 3");
		self iprintlnbold(&"PLATFORM_UPLINK_PRACTICE_SLOT3");
	}
	else
	{
		self notifyonplayercommand("call_ball","+actionslot 7");
		self iprintlnbold(&"PLATFORM_UPLINK_PRACTICE_SLOT7");
	}

	level.balls[0] waittill("score_event");
	wait(5);
	thread givepracticemessage();
}

//Function Number: 100
sortballarray(param_00)
{
	if(!isdefined(param_00) || param_00.size == 0)
	{
		return undefined;
	}

	var_01 = 1;
	for(var_02 = param_00.size;var_01;var_02--)
	{
		var_01 = 0;
		for(var_03 = 0;var_03 < var_02 - 1;var_03++)
		{
			if(compareballindexes(param_00[var_03],param_00[var_03 + 1]))
			{
				var_04 = param_00[var_03];
				param_00[var_03] = param_00[var_03 + 1];
				param_00[var_03 + 1] = var_04;
				var_01 = 1;
			}
		}
	}

	return param_00;
}

//Function Number: 101
compareballindexes(param_00,param_01)
{
	var_02 = int(param_00.script_label);
	var_03 = int(param_01.script_label);
	if(!isdefined(var_02) && !isdefined(var_03))
	{
		return 0;
	}

	if(!isdefined(var_02) && isdefined(var_03))
	{
		return 1;
	}

	if(isdefined(var_02) && !isdefined(var_03))
	{
		return 0;
	}

	if(var_02 > var_03)
	{
		return 1;
	}

	return 0;
}

//Function Number: 102
getpasserorigin()
{
	var_00 = 0;
	switch(self getstance())
	{
		case "crouch":
			var_00 = 5;
			break;

		case "prone":
			var_00 = 10;
			break;
	}

	var_01 = self getworldupreferenceangles();
	var_02 = anglestoup(var_01);
	var_03 = self geteye() + var_02 * var_00;
	return var_03;
}

//Function Number: 103
getpasserdirection()
{
	var_00 = self getplayerangles();
	var_01 = anglestoforward(var_00);
	return var_01;
}

//Function Number: 104
gettargetorigin()
{
	var_00 = 10;
	switch(self getstance())
	{
		case "crouch":
			var_00 = 15;
			break;

		case "prone":
			var_00 = 5;
			break;
	}

	var_01 = self getworldupreferenceangles();
	var_02 = anglestoup(var_01);
	var_03 = self gettagorigin("j_spinelower",1,1);
	var_04 = var_03 + var_02 * var_00;
	return var_04;
}

//Function Number: 105
gettargetoffset()
{
	var_00 = gettargetorigin();
	return (0,0,var_00[2] - self.origin[2]);
}

//Function Number: 106
hideballsongameended()
{
	level waittill("bro_shot_start");
	foreach(var_01 in level.balls)
	{
		var_01.visuals[0] setscriptablepartstate("uplink_drone_hide","hide",0);
		var_01.visuals[0] setscriptablepartstate("uplink_drone_idle","off",0);
		var_01.visuals[0] setscriptablepartstate("uplink_drone_tail","off",0);
	}
}