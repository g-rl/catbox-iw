/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\agents\ratking\ratking_agent.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 22
 * Decompile Time: 1147 ms
 * Timestamp: 10/27/2023 12:11:21 AM
*******************************************************************/

//Function Number: 1
registerscriptedagent()
{
	scripts/aitypes/bt_util::init();
	behaviortree\ratking::func_DEE8();
	scripts\asm\ratking\mp\states::func_2371();
	scripts\mp\agents\ratking\ratking_tunedata::setuptunedata();
	thread func_FAB0();
}

//Function Number: 2
func_FAB0()
{
	level endon("game_ended");
	if(!isdefined(level.agent_definition))
	{
		level waittill("scripted_agents_initialized");
	}

	level.agent_definition["ratking"]["setup_func"] = ::setupagent;
	level.agent_definition["ratking"]["setup_model_func"] = ::func_FACE;
	level.agent_funcs["ratking"]["on_damaged_finished"] = ::onratkingdamagefinished;
	level.agent_funcs["ratking"]["on_killed"] = ::onratkingkilled;
}

//Function Number: 3
func_FACE(param_00)
{
	self setmodel("zmb_rat_king");
	thread delaygiveequipment();
}

//Function Number: 4
delaygiveequipment()
{
	level endon("game_ended");
	self endon("fake_death");
	wait(0.1);
	self setscriptablepartstate("staff","staff_activate");
	self setscriptablepartstate("shield","shield_activate");
}

//Function Number: 5
setupzombiegametypevars()
{
	self.class = undefined;
	self.movespeedscaler = undefined;
	self.avoidkillstreakonspawntimer = undefined;
	self.guid = undefined;
	self.name = undefined;
	self.saved_actionslotdata = undefined;
	self.perks = undefined;
	self.weaponlist = undefined;
	self.objectivescaler = undefined;
	self.sessionteam = undefined;
	self.sessionstate = undefined;
	self.disabledweapon = undefined;
	self.disabledweaponswitch = undefined;
	self.disabledoffhandweapons = undefined;
	self.disabledusability = 1;
	self.nocorpse = undefined;
	self.ignoreme = 0;
	self.precacheleaderboards = 0;
	self.ten_percent_of_max_health = undefined;
	self.command_given = undefined;
	self.current_icon = undefined;
	self.do_immediate_ragdoll = undefined;
	self.can_be_killed = 0;
	self.attack_spot = undefined;
	self.entered_playspace = 0;
	self.marked_for_death = undefined;
	self.trap_killed_by = undefined;
	self.hastraversed = 0;
	self.attackent = undefined;
	self.aistate = "idle";
	self.synctransients = "walk";
	self.sharpturnnotifydist = 100;
	self.fgetarg = 15;
	self.height = 40;
	self.var_252B = 26 + self.fgetarg;
	self.var_B640 = "normal";
	self.var_B641 = 50;
	self.var_2539 = 54;
	self.var_253A = -64;
	self.var_4D45 = 2250000;
	self.precacheminimapicon = 1;
	self.guid = self getentitynumber();
	self.moveratescale = 1;
	self.var_C081 = 1;
	self.traverseratescale = 1;
	self.generalspeedratescale = 1;
	self.var_2AB2 = 0;
	self.var_2AB8 = 1;
	self.timelineevents = 0;
	self.var_2F = 1;
	self.var_B5F9 = 40;
	self.var_B62E = 75;
	self.meleeradiuswhentargetnotonnavmesh = 120;
	self.meleeradiusbasesq = squared(self.var_B62E);
	self.defaultgoalradius = self.fgetarg + 1;
	self.meleedot = 0.5;
	self.dismember_crawl = 0;
	self.is_crawler = 0;
	self.died_poorly = 0;
	self.damaged_by_player = 0;
	self.isfrozen = undefined;
	self.flung = undefined;
	self.var_B0FC = 1;
	self.full_gib = 0;
	self.loadstartpointtransients = undefined;
	self.var_E821 = undefined;
	self.last_damage_time_on_player = [];
	self.var_8C12 = 0;
	self.hasplayedvignetteanim = undefined;
	self.is_cop = undefined;
	self.pointonsegmentnearesttopoint = 200;
	self.deathmethod = undefined;
	self.var_10A57 = undefined;
	self.gib_fx_override = undefined;
	self.var_CE65 = undefined;
	self.var_29D2 = 1;
	self.vignette_nocorpse = undefined;
	self.death_anim_no_ragdoll = undefined;
	self.dont_cleanup = 1;
	self.hasshield = 1;
	self.hasstaff = 1;
	self.next_block_fx_time = 0;
	self.next_pain_time = 0;
	self.next_forced_teleport_time = 0;
	self.fake_death = undefined;
	if(getdvarint("scr_zombie_left_foot_sharp_turn_only",0) == 1)
	{
		self.var_AB3F = 1;
	}
}

//Function Number: 6
setupagent()
{
	setupzombiegametypevars();
	self.height = self.var_18F4;
	self.fgetarg = self.var_18F9;
	self.immune_against_nuke = 1;
	self.var_B62D = 75;
	self.var_B62E = 75;
	self.meleeradiuswhentargetnotonnavmesh = 120;
	self.meleeradiusbasesq = squared(self.var_B62E);
	self.defaultgoalradius = self.fgetarg + 1;
	self.meleedot = 0.5;
	self.var_B601 = 67;
	self.fake_death = undefined;
	self.meleeattackchance["melee_attack"] = 70;
	self.meleeattackchance["staff_stomp"] = 30;
	self.var_504E = 55;
	self.var_129AF = 55;
	self.var_368 = -60;
	self.isbot = 60;
	self.objective_team = "slasher_grenade_zm";
	self.objective_state = 999;
	self.ground_pound_damage = 50;
	self.footstepdetectdist = 2500;
	self.footstepdetectdistwalk = 2500;
	self.footstepdetectdistsprint = 2500;
	self.var_71D0 = ::shouldratkingplaypainanim;
	thread listen_for_fake_death();
}

//Function Number: 7
accumulatedamage(param_00,param_01)
{
	if(!isdefined(self.damageaccumulator))
	{
		self.damageaccumulator = spawnstruct();
		self.damageaccumulator.accumulateddamage = 0;
	}
	else if(!isdefined(self.damageaccumulator.lastdamagetime) || gettime() > self.damageaccumulator.lastdamagetime + 1000)
	{
		self.damageaccumulator.accumulateddamage = 0;
		self.damageaccumulator.lastdamagetime = 0;
	}

	self.damageaccumulator.lastdamagetime = gettime();
	if(!isdefined(param_01))
	{
		param_01 = (1,1,1);
	}

	self.damageaccumulator.lastdir = param_01;
	if(isdefined(self.fake_damage))
	{
		self.damageaccumulator.accumulateddamage = self.damageaccumulator.accumulateddamage + self.fake_damage;
		self.fake_damage = undefined;
		return;
	}

	self.damageaccumulator.accumulateddamage = self.damageaccumulator.accumulateddamage + param_00;
}

//Function Number: 8
isinravemode()
{
	if(self isethereal())
	{
		return 1;
	}

	return 0;
}

//Function Number: 9
onratkingdamagefinished(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B,param_0C)
{
	accumulatedamage(param_02,param_07);
	ratking_on_damage_finished(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,0,param_0B,param_0C);
}

//Function Number: 10
ratking_on_damage_finished(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B,param_0C)
{
	var_0D = self.health;
	if(isdefined(param_07))
	{
		var_0E = vectortoyaw(param_07);
		var_0F = self.angles[1];
		self.var_E3 = angleclamp180(var_0E - var_0F);
	}
	else
	{
		self.var_E3 = 0;
	}

	self.var_DD = param_08;
	self.var_DE = param_04;
	self.damagedby = param_01;
	self.var_DC = param_07;
	self.var_E1 = param_02;
	self.var_E2 = param_05;
	self.var_4D62 = param_06;
	if(param_02 >= self.health)
	{
		param_02 = 0;
		level.rat_king_death_pos = self.origin;
		if(scripts\engine\utility::array_contains(level.spawned_enemies,self))
		{
			level.spawned_enemies = scripts\engine\utility::array_remove(level.spawned_enemies,self);
		}

		self notify("fake_death");
	}

	self getrespawndelay(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,0,param_0B,param_0C,0,1);
	if(self.health > 0 && self.health < var_0D)
	{
		self notify("pain");
	}

	if(isalive(self) && isdefined(self.agent_type))
	{
		var_10 = level.agent_funcs[self.agent_type]["gametype_on_damage_finished"];
		if(isdefined(var_10))
		{
			[[ var_10 ]](param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B,param_0C);
		}
	}
}

//Function Number: 11
onratkingkilled(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08)
{
	self.nocorpse = 1;
	scripts\mp\mp_agent::default_on_killed(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08);
}

//Function Number: 12
getratkinggrenadehandoffset()
{
	return (12,12,100);
}

//Function Number: 13
getratkinghandposition()
{
	return self gettweakablevalue(self.origin + (12,12,100));
}

//Function Number: 14
shouldratkingplaypainanim()
{
	return 0;
}

//Function Number: 15
getstructpos()
{
	if(isdefined(self.ratkingbouncetarget))
	{
		return self.ratkingbouncetarget;
	}

	return undefined;
}

//Function Number: 16
getenemy()
{
	if(isdefined(self.ratkingenemy) && isalive(self.ratkingenemy))
	{
		return self.ratkingenemy;
	}

	return undefined;
}

//Function Number: 17
lookatspot()
{
	var_00 = getstructpos();
	if(isdefined(var_00))
	{
		var_01 = var_00.origin - self.origin;
		var_02 = vectortoangles(var_01);
		self orientmode("face angle abs",(0,var_02[1],0));
		return;
	}

	self orientmode("face angle abs",self.angles);
}

//Function Number: 18
lookatenemy()
{
	var_00 = getenemy();
	if(isdefined(var_00))
	{
		var_01 = var_00.origin - self.origin;
		var_02 = vectortoangles(var_01);
		self orientmode("face angle abs",(0,var_02[1],0));
		return;
	}

	self orientmode("face angle abs",self.angles);
}

//Function Number: 19
executefakedeath()
{
	self setethereal(1);
	wait(0.2);
	self suicide();
	wait(0.2);
}

//Function Number: 20
listen_for_fake_death()
{
	self endon("death");
	for(;;)
	{
		self waittill("fake_death");
		if(!scripts\engine\utility::istrue(level.ratking_fight))
		{
			self.fake_death = 1;
			scripts\cp\maps\cp_disco\rat_king_fight::forcerkteleport();
			continue;
		}

		if(scripts\engine\utility::istrue(level.ratking_fight))
		{
			self.precacheleaderboards = 1;
			self.scripted_mode = 1;
			foreach(var_01 in level.players)
			{
				var_01 thread scripts\cp\maps\cp_disco\rat_king_fight::outroblackscreen();
			}

			wait(2);
			self suicide();
		}
	}
}

//Function Number: 21
rkhasstaff()
{
	return scripts\engine\utility::istrue(self.hasstaff);
}

//Function Number: 22
rkhasshield()
{
	return self.asm.shieldstate == "equipped";
}