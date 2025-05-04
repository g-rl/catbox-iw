/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\cp\crafted_trap_hypnosis.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 27
 * Decompile Time: 1357 ms
 * Timestamp: 10/27/2023 12:10:21 AM
*******************************************************************/

//Function Number: 1
init()
{
	level._effect["boombox_explode"] = loadfx("vfx/iw7/_requests/coop/vfx_ghetto_blast.vfx");
	var_00 = spawnstruct();
	var_00.timeout = 18;
	var_00.modelplacement = "cp_town_hypnosis_device_good";
	var_00.modelplacementfailed = "cp_town_hypnosis_device_bad";
	var_00.placedmodel = "cp_town_hypnosis_device";
	var_00.placestring = &"COOP_CRAFTABLES_PLACE";
	var_00.cannotplacestring = &"COOP_CRAFTABLES_CANNOT_PLACE";
	var_00.placecancelablestring = &"COOP_CRAFTABLES_PLACE_CANCELABLE";
	var_00.placementheighttolerance = 30;
	var_00.placementradius = 16;
	var_00.carriedtrapoffset = (0,0,35);
	var_00.carriedtrapangles = (0,-90,0);
	level.crafted_hypnosis_settings = [];
	level.crafted_hypnosis_settings["crafted_hypnosis"] = var_00;
}

//Function Number: 2
give_crafted_hypnosis(param_00,param_01)
{
	param_01 thread watch_dpad();
	param_01 notify("new_power","crafted_hypnosis");
	param_01 setclientomnvar("zom_crafted_weapon",14);
	scripts\cp\utility::set_crafted_inventory_item("crafted_hypnosis",::give_crafted_hypnosis,param_01);
}

//Function Number: 3
watch_dpad()
{
	self endon("disconnect");
	self endon("death");
	self notify("craft_dpad_watcher");
	self endon("craft_dpad_watcher");
	self notifyonplayercommand("pullout_hypnosis","+actionslot 3");
	for(;;)
	{
		self waittill("pullout_hypnosis");
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

	thread give_hypnosis(1);
}

//Function Number: 4
give_hypnosis(param_00,param_01)
{
	self endon("disconnect");
	scripts\cp\utility::clearlowermessage("msg_power_hint");
	var_02 = createhypnosisforplayer(self);
	self.itemtype = var_02.name;
	removeperks();
	var_02 = createhypnosisforplayer(self);
	self.carriedsentry = var_02;
	var_02.firstplacement = 1;
	var_03 = setcarryinghypnosis(var_02,param_00,param_01);
	self.carriedsentry = undefined;
	thread waitrestoreperks();
	self.iscarrying = 0;
	if(isdefined(var_02))
	{
		return 1;
	}

	return 0;
}

//Function Number: 5
setcarryinghypnosis(param_00,param_01,param_02)
{
	self endon("disconnect");
	param_00 hypnosis_setcarried(self,param_01);
	scripts\engine\utility::allow_weapon(0);
	self notifyonplayercommand("place_hypnosis","+attack");
	self notifyonplayercommand("place_hypnosis","+attack_akimbo_accessible");
	self notifyonplayercommand("cancel_hypnosis","+actionslot 3");
	if(!level.console)
	{
		self notifyonplayercommand("cancel_hypnosis","+actionslot 5");
		self notifyonplayercommand("cancel_hypnosis","+actionslot 6");
		self notifyonplayercommand("cancel_hypnosis","+actionslot 7");
	}

	for(;;)
	{
		var_03 = scripts\engine\utility::waittill_any_return("place_hypnosis","cancel_hypnosis","force_cancel_placement");
		if(!isdefined(param_00))
		{
			scripts\engine\utility::allow_weapon(1);
			return 1;
		}

		if(!isdefined(var_03))
		{
			var_03 = "force_cancel_placement";
		}

		if(var_03 == "cancel_hypnosis" || var_03 == "force_cancel_placement")
		{
			if(!param_01 && var_03 == "cancel_hypnosis")
			{
				continue;
			}

			scripts\engine\utility::allow_weapon(1);
			param_00 hypnosis_setcancelled();
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

		param_00 hypnosis_setplaced(param_02,self);
		scripts\engine\utility::allow_weapon(1);
		return 1;
	}
}

//Function Number: 6
removeweapons()
{
	if(self.hasriotshield)
	{
		var_00 = scripts\cp\utility::riotshieldname();
		self.restoreweapon = var_00;
		self.riotshieldammo = self getrunningforwardpainanim(var_00);
		self takeweapon(var_00);
	}
}

//Function Number: 7
removeperks()
{
	if(scripts\cp\utility::_hasperk("specialty_explosivebullets"))
	{
		self.restoreperk = "specialty_explosivebullets";
		scripts\cp\utility::_unsetperk("specialty_explosivebullets");
	}
}

//Function Number: 8
restoreweapons()
{
	if(isdefined(self.restoreweapon))
	{
		scripts\cp\utility::_giveweapon(self.restoreweapon);
		if(self.hasriotshield)
		{
			var_00 = scripts\cp\utility::riotshieldname();
			self setweaponammoclip(var_00,self.riotshieldammo);
		}
	}

	self.restoreweapon = undefined;
}

//Function Number: 9
restoreperks()
{
	if(isdefined(self.restoreperk))
	{
		scripts\cp\utility::giveperk(self.restoreperk);
		self.restoreperk = undefined;
	}
}

//Function Number: 10
waitrestoreperks()
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	wait(0.05);
	restoreperks();
}

//Function Number: 11
createhypnosisforplayer(param_00)
{
	var_01 = spawnturret("misc_turret",param_00.origin + (0,0,25),"sentry_minigun_mp");
	var_01.angles = param_00.angles;
	var_01.triggerportableradarping = param_00;
	var_01.name = "crafted_hypnosis";
	var_01.carriedhypnosis = spawn("script_model",var_01.origin);
	var_01.carriedhypnosis.angles = param_00.angles;
	var_01 getvalidattachments();
	var_01 setturretmodechangewait(1);
	var_01 give_player_session_tokens("sentry_offline");
	var_01 makeunusable();
	var_01 setsentryowner(param_00);
	var_01 hypnosis_inithypnosis(param_00);
	return var_01;
}

//Function Number: 12
hypnosis_inithypnosis(param_00)
{
	self.canbeplaced = 1;
	hypnosis_setinactive();
}

//Function Number: 13
hypnosis_handledeath(param_00)
{
	self waittill("death");
	if(!isdefined(self))
	{
		return;
	}

	hypnosis_setinactive();
	self playsound("sentry_explode");
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

//Function Number: 14
hypnosis_setplaced(param_00,param_01)
{
	var_02 = self.carriedhypnosis.origin - (0,0,35);
	var_03 = self.carriedhypnosis.angles;
	self.carriedby getrigindexfromarchetyperef();
	self.carriedby = undefined;
	param_01.iscarrying = 0;
	self.carriedhypnosis delete();
	self delete();
	var_04 = spawn("script_model",var_02);
	var_04.angles = var_03;
	var_04.triggerportableradarping = param_01;
	var_04.team = "allies";
	var_04 setmodel(level.crafted_hypnosis_settings["crafted_hypnosis"].placedmodel);
	var_04.name = "crafted_hypnosis";
	var_04.lastkilltime = gettime();
	var_04.lastmultikilltime = gettime();
	var_04 thread hypnosis_setactive(param_00);
	var_04 playsound("trap_boom_box_drop");
	self notify("placed");
}

//Function Number: 15
hypnosis_setcancelled()
{
	self.carriedby getrigindexfromarchetyperef();
	if(isdefined(self.triggerportableradarping))
	{
		self.triggerportableradarping.iscarrying = 0;
	}

	self.carriedhypnosis delete();
	self delete();
}

//Function Number: 16
hypnosis_setcarried(param_00,param_01)
{
	if(isdefined(self.originalowner))
	{
	}
	else
	{
	}

	self setmodel(level.crafted_hypnosis_settings["crafted_hypnosis"].modelplacement);
	self hide();
	self setsentrycarrier(param_00);
	self setcandamage(0);
	self.carriedby = param_00;
	param_00.iscarrying = 1;
	param_00 thread scripts\cp\utility::update_trap_placement_internal(self,self.carriedhypnosis,level.crafted_hypnosis_settings["crafted_hypnosis"],1);
	thread scripts\cp\utility::item_oncarrierdeath(param_00);
	thread scripts\cp\utility::item_oncarrierdisconnect(param_00);
	thread scripts\cp\utility::item_ongameended(param_00);
	hypnosis_setinactive();
	self notify("carried");
}

//Function Number: 17
hypnosis_setactive(param_00)
{
	wait(0.5);
	playfxontag(level._effect["hypnosis_active"],self,"tag_origin");
	create_attract_positions((1,1,0),0,15,36);
	thread hypnosis_handledeath(self.triggerportableradarping);
	thread scripts\cp\utility::item_handleownerdisconnect("elechypnosis_handleOwner");
	thread scripts\cp\utility::item_timeout(param_00,level.crafted_hypnosis_settings["crafted_hypnosis"].timeout,"explode");
	thread hypnosis_trap_enemies();
	thread hypnosis_sfx();
	thread hypnosis_explode();
	scripts\cp\utility::addtotraplist();
}

//Function Number: 18
hypnosis_setinactive()
{
	self stoploopsound("trap_medusa_charging_lp");
	scripts\cp\utility::removefromtraplist();
}

//Function Number: 19
hypnosis_trap_enemies()
{
	self endon("death");
	self endon("explode");
	self.dancers = [];
	var_00 = 262144;
	for(;;)
	{
		var_01 = scripts\cp\cp_agent_utils::getaliveagentsofteam("axis");
		var_01 = scripts\engine\utility::get_array_of_closest(self.origin,var_01);
		foreach(var_03 in var_01)
		{
			if(!scripts\cp\utility::should_be_affected_by_trap(var_03) || scripts\engine\utility::istrue(var_03.about_to_dance) || scripts\engine\utility::istrue(var_03.controlled))
			{
				continue;
			}

			if(var_03.agent_type == "crab_mini" || var_03.agent_type == "crab_brute")
			{
				continue;
			}

			if(distancesquared(self.origin,var_03.origin) < var_00)
			{
				var_04 = get_closest_attract_position(self,var_03);
				var_03 thread go_to_radio_and_dance(self,var_04);
				var_03 thread release_zombie_on_radio_death(self);
				scripts\engine\utility::waitframe();
			}
		}

		wait(0.1);
	}
}

//Function Number: 20
hypnosis_sfx()
{
	self playloopsound("town_hypnosis_tone_lp");
	self waittill("explode");
	self playsound("town_hypnosis_build_up_to_explode");
	wait(0.25);
	self playloopsound("town_hypnosis_tone_head_crush_lp");
	wait(1.15);
	if(isdefined(self))
	{
		self stoploopsound();
	}

	thread func_66A7();
}

//Function Number: 21
go_to_radio_and_dance(param_00,param_01)
{
	param_00 endon("death");
	self endon("death");
	self endon("turned");
	param_00 endon("explode");
	self.about_to_dance = 1;
	self.scripted_mode = 1;
	self.og_goalradius = self.objective_playermask_showto;
	self.objective_playermask_showto = 32;
	self.og_movemode = self.synctransients;
	self.synctransients = "sprint";
	var_02 = param_00.origin - param_01.origin;
	var_03 = vectortoangles(var_02);
	self.desired_dance_angles = (0,var_03[1],0);
	self give_mp_super_weapon(param_01.origin);
	scripts\engine\utility::waittill_any_3("goal","goal_reached");
	self setscriptablepartstate("eyes","hypnotized");
	self.var_CF80 = param_00.triggerportableradarping;
	self.is_dancing = 1;
	param_00.dancers[param_00.dancers.size] = self;
}

//Function Number: 22
release_zombie_on_radio_death(param_00)
{
	self endon("death");
	param_00 scripts\engine\utility::waittill_any_3("death","explode");
	if(isdefined(self.og_goalradius))
	{
		self.objective_playermask_showto = self.og_goalradius;
	}

	self.synctransients = self.og_movemode;
	self.og_goalradius = undefined;
	self.about_to_dance = 0;
	self.scripted_mode = 0;
}

//Function Number: 23
hypnosis_explode()
{
	self waittill("explode");
	var_00 = self.dancers;
	foreach(var_03, var_02 in var_00)
	{
		var_02 thread hypnosis_delayed_death(var_03,self);
		if(isdefined(self.triggerportableradarping))
		{
			self.triggerportableradarping scripts\cp\cp_merits::processmerit("mt_dlc3_crafted_kills");
		}
	}
}

//Function Number: 24
func_66A7()
{
	self playsound("trap_boom_box_explode");
	playfx(level._effect["violet_light_explode"],self.origin);
	wait(0.1);
	radiusdamage(self.origin + (0,0,40),200,500,250,self,"MOD_EXPLOSIVE","zmb_imsprojectile_mp");
	self hide();
	wait(0.65);
	physicsexplosionsphere(self.origin,256,256,2);
	wait(0.1);
	self delete();
}

//Function Number: 25
hypnosis_delayed_death(param_00,param_01)
{
	self endon("death");
	wait(param_00 * 0.05);
	self.deathmethod = "hypnosis";
	if(!scripts\engine\utility::istrue(self.is_crawler))
	{
		scripts/asm/asm::asm_setstate("hypnosisdeath");
		return;
	}

	scripts/asm/asm::asm_setstate("hypnosisdeathcrawling");
}

//Function Number: 26
get_closest_attract_position(param_00,param_01)
{
	var_02 = sortbydistance(param_00.attract_positions,param_01.origin);
	foreach(var_04 in var_02)
	{
		if(!var_04.occupied)
		{
			var_04.occupied = 1;
			return var_04;
		}
	}

	return var_02[0];
}

//Function Number: 27
create_attract_positions(param_00,param_01,param_02,param_03)
{
	self endon("death");
	var_04 = -27120;
	var_05 = 0;
	var_06 = 360 / param_02;
	self.attract_positions = [];
	for(var_07 = param_01;var_07 < 360 + param_01;var_07 = var_07 + var_06)
	{
		var_08 = param_00 * param_03;
		var_09 = (cos(var_07) * var_08[0] - sin(var_07) * var_08[1],sin(var_07) * var_08[0] + cos(var_07) * var_08[1],var_08[2]);
		var_0A = getclosestpointonnavmesh(self.origin + var_09 + (0,0,10));
		if(!scripts\cp\loot::is_in_active_volume(var_0A))
		{
			continue;
		}

		if(isdefined(var_0A) && distancesquared(var_0A,self.origin) > var_04)
		{
			continue;
		}
		else
		{
			if(abs(var_0A[2] - self.origin[2]) < 60)
			{
				var_0B = spawnstruct();
				var_0B.origin = var_0A;
				var_0B.occupied = 0;
				self.attract_positions[self.attract_positions.size] = var_0B;
				continue;
			}

			var_05++;
		}
	}

	for(var_07 = param_01;var_07 < 360 + param_01;var_07 = var_07 + var_06)
	{
		var_08 = param_00 * param_03 + 56;
		var_09 = (cos(var_07) * var_08[0] - sin(var_07) * var_08[1],sin(var_07) * var_08[0] + cos(var_07) * var_08[1],var_08[2]);
		var_0A = getclosestpointonnavmesh(self.origin + var_09 + (0,0,10));
		if(!scripts\cp\loot::is_in_active_volume(var_0A))
		{
			continue;
		}

		if(isdefined(var_0A) && distancesquared(var_0A,self.origin) > var_04)
		{
			continue;
		}
		else
		{
			if(abs(var_0A[2] - self.origin[2]) < 60)
			{
				var_0B = spawnstruct();
				var_0B.origin = var_0A;
				var_0B.occupied = 0;
				self.attract_positions[self.attract_positions.size] = var_0B;
				continue;
			}

			var_05++;
		}
	}

	return var_05;
}