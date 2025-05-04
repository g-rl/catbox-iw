/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\cp\zombies\craftables\_revocator.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 22
 * Decompile Time: 850 ms
 * Timestamp: 10/27/2023 12:23:41 AM
*******************************************************************/

//Function Number: 1
init()
{
	level._effect["revocator_idle"] = loadfx("vfx/iw7/core/zombie/vfx_zmb_revocator_idle.vfx");
	level._effect["revocator_activate"] = loadfx("vfx/iw7/_requests/coop/vfx_revocator_use.vfx");
	var_00 = spawnstruct();
	var_00.timeout = 30;
	var_00.modelbase = "revocator";
	var_00.modelplacement = "revocator";
	var_00.modelplacementfailed = "revocator_bad";
	var_00.placedmodel = "revocator";
	var_00.pow = &"COOP_CRAFTABLES_PICKUP";
	var_00.placestring = &"COOP_CRAFTABLES_PLACE";
	var_00.cannotplacestring = &"COOP_CRAFTABLES_CANNOT_PLACE";
	var_00.placecancelablestring = &"COOP_CRAFTABLES_PLACE_CANCELABLE";
	var_00.placementheighttolerance = 30;
	var_00.placementradius = 24;
	var_00.carriedtrapoffset = (0,0,25);
	var_00.carriedtrapangles = (0,0,0);
	level.var_47B1 = [];
	level.var_47B1["crafted_revocator"] = var_00;
}

//Function Number: 2
give_crafted_revocator(param_00,param_01)
{
	param_01 thread watch_dpad();
	param_01 notify("new_power","crafted_revocator");
	param_01 setclientomnvar("zom_crafted_weapon",6);
	param_01 thread scripts\cp\utility::usegrenadegesture(param_01,"iw7_pickup_zm");
	scripts\cp\utility::set_crafted_inventory_item("crafted_revocator",::give_crafted_revocator,param_01);
}

//Function Number: 3
watch_dpad()
{
	self endon("disconnect");
	self endon("death");
	self notify("craft_dpad_watcher");
	self endon("craft_dpad_watcher");
	self notifyonplayercommand("pullout_revocator","+actionslot 3");
	for(;;)
	{
		self waittill("pullout_revocator");
		if(scripts\engine\utility::istrue(self.iscarrying))
		{
			continue;
		}

		if(scripts\engine\utility::istrue(self.linked_to_coaster))
		{
			continue;
		}

		if(isdefined(self.allow_carry) && self.allow_carry == 0)
		{
			continue;
		}

		if(scripts\cp\utility::is_valid_player())
		{
			break;
		}
	}

	thread _meth_8329(1);
}

//Function Number: 4
_meth_8329(param_00,param_01,param_02)
{
	self endon("disconnect");
	scripts\cp\utility::clearlowermessage("msg_power_hint");
	var_03 = func_4A08(self,param_02);
	self.itemtype = var_03.name;
	removeperks();
	self.carriedsentry = var_03;
	if(param_00)
	{
		var_03.firstplacement = 1;
	}

	var_04 = func_F687(var_03,param_00,param_01);
	self.carriedsentry = undefined;
	thread waitrestoreperks();
	self.iscarrying = 0;
	if(isdefined(var_03))
	{
		return 1;
	}

	return 0;
}

//Function Number: 5
func_F687(param_00,param_01,param_02)
{
	self endon("disconnect");
	param_00 func_E4B7(self,param_01);
	scripts\engine\utility::allow_weapon(0);
	self notifyonplayercommand("place_revocator","+attack");
	self notifyonplayercommand("place_revocator","+attack_akimbo_accessible");
	self notifyonplayercommand("cancel_revocator","+actionslot 3");
	if(!level.console)
	{
		self notifyonplayercommand("cancel_revocator","+actionslot 5");
		self notifyonplayercommand("cancel_revocator","+actionslot 6");
		self notifyonplayercommand("cancel_revocator","+actionslot 7");
	}

	for(;;)
	{
		var_03 = scripts\engine\utility::waittill_any_return("place_revocator","cancel_revocator","force_cancel_placement");
		if(!isdefined(param_00))
		{
			scripts\engine\utility::allow_weapon(1);
			return 1;
		}

		if(!isdefined(var_03))
		{
			var_03 = "force_cancel_placement";
		}

		if(var_03 == "cancel_revocator" || var_03 == "force_cancel_placement")
		{
			if(!param_01 && var_03 == "cancel_revocator")
			{
				continue;
			}

			scripts\engine\utility::allow_weapon(1);
			param_00 func_E4B6();
			if(var_03 != "force_cancel_placement")
			{
				thread watch_dpad();
			}
			else if(param_01)
			{
				scripts\cp\utility::remove_crafted_item_from_inventory(self);
			}

			return 0;
		}

		if(!param_00.canbeplaced)
		{
			continue;
		}

		if(param_01)
		{
			scripts\cp\utility::remove_crafted_item_from_inventory(self);
		}

		param_00 func_E4B9(param_02,self);
		scripts\engine\utility::allow_weapon(1);
		return 1;
	}
}

//Function Number: 6
removeperks()
{
	if(scripts\cp\utility::_hasperk("specialty_explosivebullets"))
	{
		self.restoreperk = "specialty_explosivebullets";
		scripts\cp\utility::_unsetperk("specialty_explosivebullets");
	}
}

//Function Number: 7
restoreperks()
{
	if(isdefined(self.restoreperk))
	{
		scripts\cp\utility::giveperk(self.restoreperk);
		self.restoreperk = undefined;
	}
}

//Function Number: 8
waitrestoreperks()
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	wait(0.05);
	restoreperks();
}

//Function Number: 9
func_4A08(param_00,param_01)
{
	var_02 = spawnturret("misc_turret",param_00.origin + (0,0,25),"sentry_minigun_mp");
	var_02.angles = param_00.angles;
	var_02.triggerportableradarping = param_00;
	var_02.name = "crafted_revocator";
	var_02.carriedrevocator = spawn("script_model",var_02.origin);
	var_02.carriedrevocator.angles = param_00.angles;
	var_02 getvalidattachments();
	var_02 setturretmodechangewait(1);
	var_02 give_player_session_tokens("sentry_offline");
	var_02 makeunusable();
	var_02 setsentryowner(param_00);
	if(!isdefined(param_01))
	{
		var_02.var_130D2 = 1;
	}
	else
	{
		var_02.var_130D2 = param_01;
	}

	var_02 func_E4B4(param_00);
	return var_02;
}

//Function Number: 10
func_E4B4(param_00)
{
	self.canbeplaced = 1;
	func_E4B8();
}

//Function Number: 11
func_E4B1(param_00)
{
	self waittill("death");
	if(!isdefined(self))
	{
		return;
	}

	func_E4B8();
	playsoundatpos(self.origin,"trap_revocator_deactivate");
	if(isdefined(self.charge_fx))
	{
		self.charge_fx delete();
	}

	if(isdefined(self.zap_model))
	{
		self.zap_model delete();
	}

	scripts\cp\utility::removefromtraplist();
	if(isdefined(self))
	{
		self delete();
	}
}

//Function Number: 12
func_E4B9(param_00,param_01)
{
	var_02 = spawn("script_model",self.origin + (0,0,1));
	var_02.angles = self.angles;
	var_02 solid();
	var_02 setmodel(level.var_47B1["crafted_revocator"].placedmodel);
	self.carriedby getrigindexfromarchetyperef();
	self.carriedby = undefined;
	param_01.iscarrying = 0;
	var_02.triggerportableradarping = param_01;
	var_02.var_130D2 = self.var_130D2;
	var_02.name = "crafted_revocator";
	var_02 thread func_E4B5(param_00);
	var_02 playsound("trap_revocator_activate");
	self notify("placed");
	self.carriedrevocator delete();
	self delete();
}

//Function Number: 13
func_E4B6()
{
	self.carriedby getrigindexfromarchetyperef();
	if(isdefined(self.triggerportableradarping))
	{
		self.triggerportableradarping.iscarrying = 0;
	}

	self.carriedrevocator delete();
	self delete();
}

//Function Number: 14
func_E4B7(param_00,param_01)
{
	self setmodel(level.var_47B1["crafted_revocator"].modelplacement);
	self hide();
	self setsentrycarrier(param_00);
	self setcandamage(0);
	self.carriedby = param_00;
	param_00.iscarrying = 1;
	param_00 thread scripts\cp\utility::update_trap_placement_internal(self,self.carriedrevocator,level.var_47B1["crafted_revocator"]);
	thread scripts\cp\utility::item_oncarrierdeath(param_00);
	thread scripts\cp\utility::item_oncarrierdisconnect(param_00);
	thread scripts\cp\utility::item_ongameended(param_00);
	func_E4B8();
	self notify("carried");
}

//Function Number: 15
func_E4B5(param_00)
{
	self endon("death");
	self setcursorhint("HINT_NOICON");
	self sethintstring(level.var_47B1["crafted_revocator"].pow);
	self makeusable();
	self _meth_84A7("tag_fx");
	self setusefov(120);
	self setuserange(96);
	thread func_E4B1(self.triggerportableradarping);
	thread scripts\cp\utility::item_handleownerdisconnect("elecrevocator_handleOwner");
	thread scripts\cp\utility::item_timeout(param_00,level.var_47B1["crafted_revocator"].timeout);
	thread func_E4B2();
	thread func_E4BA();
	scripts\cp\utility::addtotraplist();
	wait(1);
	self setscriptablepartstate("base","idle");
}

//Function Number: 16
func_E4B2()
{
	self endon("death");
	level endon("game_ended");
	for(;;)
	{
		self waittill("trigger",var_00);
		if(!var_00 scripts\cp\utility::is_valid_player())
		{
			continue;
		}

		if(scripts\engine\utility::istrue(var_00.iscarrying))
		{
			continue;
		}

		self playsound("trap_revocator_pickup");
		var_00 thread _meth_8329(0,self.lifespan,self.var_130D2);
		if(isdefined(self.charge_fx))
		{
			self.charge_fx delete();
		}

		scripts\cp\utility::removefromtraplist();
		self delete();
	}
}

//Function Number: 17
func_E4B8()
{
	self makeunusable();
	scripts\cp\utility::removefromtraplist();
}

//Function Number: 18
func_E4BA()
{
	self endon("death");
	var_00 = 0;
	var_01 = 1600;
	while(self.var_130D2 > 0)
	{
		var_02 = scripts\cp\cp_agent_utils::getaliveagents();
		var_02 = scripts\engine\utility::get_array_of_closest(self.origin,var_02);
		foreach(var_04 in var_02)
		{
			if(!isdefined(var_04.agent_type))
			{
				continue;
			}

			if(var_04.agent_type == "superslasher" || var_04.agent_type == "slasher" || var_04.agent_type == "zombie_sasquatch" || var_04.agent_type == "lumberjack" || scripts\engine\utility::istrue(var_04.is_skeleton))
			{
				continue;
			}

			if(!isdefined(var_04) || !isalive(var_04) || !var_04.entered_playspace || scripts\engine\utility::istrue(var_04.marked_for_death) || var_04.agent_type == "zombie_brute" || var_04.agent_type == "zombie_grey" || var_04.agent_type == "zombie_ghost" || var_04.team == "allies")
			{
				continue;
			}

			if(distancesquared(self.origin,var_04.origin) < var_01)
			{
				self setscriptablepartstate("base","active");
				if(scripts\engine\utility::istrue(var_04.is_suicide_bomber) || scripts\engine\utility::istrue(var_04.is_dancing) || scripts\engine\utility::flag_exist("defense_sequence_active") && scripts\engine\utility::flag("defense_sequence_active"))
				{
					var_04 dodamage(var_04.health + 50,self.origin);
				}
				else
				{
					var_04 turn_zombie(self.triggerportableradarping);
				}

				self.var_130D2--;
				wait(1);
				self setscriptablepartstate("base","idle");
				if(self.var_130D2 <= 0)
				{
					break;
				}
			}
		}

		wait(0.1);
	}

	self notify("death");
}

//Function Number: 19
turn_zombie(param_00)
{
	var_01 = self;
	var_01.team = "allies";
	var_01.synctransients = "sprint";
	var_01.is_reserved = 1;
	var_01.is_turned = 1;
	var_01.maxhealth = 900;
	var_01.health = 900;
	var_01.allowpain = 0;
	var_01 notify("turned");
	if(scripts\engine\utility::istrue(var_01.about_to_dance))
	{
		if(isdefined(var_01.og_goalradius))
		{
			var_01.objective_playermask_showto = var_01.og_goalradius;
		}

		var_01.og_goalradius = undefined;
		var_01.about_to_dance = 0;
		var_01.scripted_mode = 0;
	}

	var_01.melee_damage_amt = int(scripts\cp\zombies\zombies_spawning::calculatezombiehealth("generic_zombie") * 0.5);
	level.spawned_enemies = scripts\engine\utility::array_remove(level.spawned_enemies,var_01);
	level.var_4B6E++;
	level.var_4B95--;
	var_01 setscriptablepartstate("eyes","turned_eyes");
	var_01 setscriptablepartstate("pet","active");
	var_01 thread kill_turned_zombie_after_time(180);
	var_01 thread remove_zombie_from_turned_list_on_death();
	if(isdefined(param_00))
	{
		param_00 scripts\cp\cp_merits::processmerit("mt_turned_zombies");
	}

	func_B2EB(var_01);
}

//Function Number: 20
func_B2EB(param_00)
{
	if(!isdefined(level.turned_zombies))
	{
		level.turned_zombies = [];
	}

	level.turned_zombies[level.turned_zombies.size] = param_00;
	if(level.turned_zombies.size > 6)
	{
		param_00 = level.turned_zombies[0];
		level.turned_zombies = scripts\engine\utility::array_remove(level.turned_zombies,param_00);
		param_00 dodamage(param_00.health + 100,param_00.origin);
	}
}

//Function Number: 21
kill_turned_zombie_after_time(param_00)
{
	self endon("death");
	while(param_00 > 0)
	{
		wait(1);
		param_00--;
	}

	self dodamage(self.health + 100,self.origin);
}

//Function Number: 22
remove_zombie_from_turned_list_on_death()
{
	self waittill("death");
	level.turned_zombies = scripts\engine\utility::array_remove(level.turned_zombies,self);
	scripts\cp\zombies\zombies_spawning::decrease_reserved_spawn_slots(1);
}