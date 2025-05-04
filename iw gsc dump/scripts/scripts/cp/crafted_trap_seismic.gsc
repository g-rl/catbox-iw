/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\cp\crafted_trap_seismic.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 20
 * Decompile Time: 989 ms
 * Timestamp: 10/27/2023 12:10:29 AM
*******************************************************************/

//Function Number: 1
init()
{
	level.seismic_trap_settings = [];
	var_00 = spawnstruct();
	var_00.var_39B = "zmb_robotprojectile_mp";
	var_00.modelbase = "cp_town_seismic_wave_device";
	var_00.modelplacement = "cp_town_seismic_wave_device_good";
	var_00.modelplacementfailed = "cp_town_seismic_wave_device_bad";
	var_00.pow = &"COOP_CRAFTABLES_PICKUP";
	var_00.placestring = &"COOP_CRAFTABLES_PLACE";
	var_00.cannotplacestring = &"COOP_CRAFTABLES_CANNOT_PLACE";
	var_00.placecancelablestring = &"COOP_CRAFTABLES_PLACE_CANCELABLE";
	var_00.lifespan = 45;
	var_00.placementheighttolerance = 30;
	var_00.placementradius = 24;
	var_00.carriedtrapoffset = (0,0,0);
	var_00.carriedtrapangles = (0,0,0);
	level.seismic_trap_settings["crafted_seismic"] = var_00;
}

//Function Number: 2
give_crafted_seismic_trap(param_00,param_01)
{
	param_01 thread watch_dpad();
	param_01 notify("new_power","crafted_seismic");
	param_01 setclientomnvar("zom_crafted_weapon",17);
	scripts\cp\utility::set_crafted_inventory_item("crafted_seismic",::give_crafted_seismic_trap,param_01);
}

//Function Number: 3
watch_dpad()
{
	self endon("death");
	self endon("disconnect");
	self notify("craft_dpad_watcher");
	self endon("craft_dpad_watcher");
	self notifyonplayercommand("pullout_ims","+actionslot 3");
	for(;;)
	{
		self waittill("pullout_ims");
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

	thread give_seismic_trap("crafted_seismic");
}

//Function Number: 4
give_seismic_trap(param_00)
{
	self endon("disconnect");
	scripts\cp\utility::clearlowermessage("msg_power_hint");
	var_01 = create_seismic_trap_for_player(param_00,self);
	self.itemtype = var_01.name;
	scripts\cp\utility::remove_player_perks();
	self.carried_seismic_trap = var_01;
	var_01.firstplacement = 1;
	var_02 = set_carrying_seismic(var_01,1);
	self.carried_seismic_trap = undefined;
	thread scripts\cp\utility::restore_player_perk();
	return var_02;
}

//Function Number: 5
set_carrying_seismic(param_00,param_01,param_02)
{
	self endon("disconnect");
	param_00 thread seismic_trap_setcarried(self);
	scripts\engine\utility::allow_weapon(0);
	self notifyonplayercommand("place_ims","+attack");
	self notifyonplayercommand("place_ims","+attack_akimbo_accessible");
	self notifyonplayercommand("cancel_ims","+actionslot 3");
	if(!level.console)
	{
		self notifyonplayercommand("cancel_ims","+actionslot 5");
		self notifyonplayercommand("cancel_ims","+actionslot 6");
		self notifyonplayercommand("cancel_ims","+actionslot 7");
	}

	for(;;)
	{
		var_03 = scripts\engine\utility::waittill_any_return("place_ims","cancel_ims","force_cancel_placement","player_action_slot_restart");
		if(!isdefined(var_03))
		{
			var_03 = "force_cancel_placement";
		}

		if(var_03 == "cancel_ims" || var_03 == "force_cancel_placement" || var_03 == "player_action_slot_restart")
		{
			if(!param_01 && var_03 == "cancel_ims")
			{
				continue;
			}

			param_00 seismic_trap_setcancelled(var_03 == "force_cancel_placement" && !isdefined(param_00.firstplacement));
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

		param_00 thread seismic_trap_setplaced(param_02);
		self notify("IMS_placed");
		scripts\engine\utility::delaythread(0.5,::scripts\engine\utility::allow_weapon,1);
		return 1;
	}
}

//Function Number: 6
create_seismic_trap_for_player(param_00,param_01)
{
	if(isdefined(param_01.iscarrying) && param_01.iscarrying)
	{
		return;
	}

	var_02 = spawnturret("misc_turret",param_01.origin + (0,0,25),"sentry_minigun_mp");
	var_02.angles = param_01.angles;
	var_02.seismic_trap_type = param_00;
	var_02.triggerportableradarping = param_01;
	var_02.name = "crafted_seismic";
	var_02.carried_seismic_trap = spawn("script_model",var_02.origin);
	var_02.carried_seismic_trap.angles = param_01.angles;
	var_02 getvalidattachments();
	var_02 setturretmodechangewait(1);
	var_02 give_player_session_tokens("sentry_offline");
	var_02 makeunusable();
	var_02 setsentryowner(param_01);
	return var_02;
}

//Function Number: 7
create_seismic_trap(param_00,param_01)
{
	var_02 = param_00.triggerportableradarping;
	var_03 = param_00.seismic_trap_type;
	var_04 = spawn("script_model",param_00.origin + (0,0,2));
	var_04 setmodel(level.seismic_trap_settings[var_03].modelbase);
	var_04.var_EB9C = 3;
	var_04.angles = (0,param_00.carried_seismic_trap.angles[1],0);
	var_04.seismic_trap_type = var_03;
	var_04.triggerportableradarping = var_02;
	var_04 setotherent(var_02);
	var_04.team = var_02.team;
	var_04.name = "crafted_seismic";
	var_04.shouldsplash = 0;
	var_04.hidden = 0;
	var_04.config = level.seismic_trap_settings[var_03];
	var_04 thread seismic_trap_handleuse();
	if(isdefined(param_01))
	{
		var_04 thread scripts\cp\utility::item_timeout(param_01);
	}
	else
	{
		var_04 thread scripts\cp\utility::item_timeout(undefined,level.seismic_trap_settings[self.seismic_trap_type].lifespan);
	}

	return var_04;
}

//Function Number: 8
func_936D(param_00)
{
	self.var_933C = 1;
	self notify("death");
}

//Function Number: 9
func_9367(param_00)
{
	self endon("carried");
	self waittill("death");
	if(!isdefined(self))
	{
		return;
	}

	seismic_trap_setinactive();
	if(isdefined(self.inuseby))
	{
		self.inuseby scripts\cp\utility::restore_player_perk();
		self notify("deleting");
		wait(1);
	}

	func_66A7();
	self delete();
}

//Function Number: 10
func_66A7()
{
	self playsound("trap_boom_box_explode");
	playfx(level._effect["violet_light_explode"],self.origin);
	wait(0.1);
	radiusdamage(self.origin + (0,0,40),200,500,250,self,"MOD_EXPLOSIVE","zmb_imsprojectile_mp");
	self hide();
	wait(0.65);
	physicsexplosionsphere(self.origin,256,256,2);
}

//Function Number: 11
seismic_trap_handleuse()
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

		if(scripts\engine\utility::istrue(var_00.kung_fu_mode))
		{
			continue;
		}

		var_01 = create_seismic_trap_for_player(self.seismic_trap_type,var_00);
		if(!isdefined(var_01))
		{
			continue;
		}

		seismic_trap_setinactive();
		if(isdefined(self getlinkedparent()))
		{
			self unlink();
		}

		var_00 thread set_carrying_seismic(var_01,0,self.lifespan);
		self delete();
		break;
	}
}

//Function Number: 12
seismic_trap_setplaced(param_00)
{
	self endon("death");
	level endon("game_ended");
	if(isdefined(self.carriedby))
	{
		self.carriedby getrigindexfromarchetyperef();
	}

	self.carriedby = undefined;
	if(isdefined(self.triggerportableradarping))
	{
		self.triggerportableradarping.iscarrying = 0;
	}

	self.firstplacement = undefined;
	var_01 = create_seismic_trap(self,param_00);
	var_01.isplaced = 1;
	var_01 thread func_9367(self.triggerportableradarping);
	self playsound("trap_boom_box_drop");
	self notify("placed");
	var_01 thread seismic_trap_setactive();
	var_02 = spawnstruct();
	if(isdefined(self.moving_platform))
	{
		var_02.linkparent = self.moving_platform;
	}

	var_02.endonstring = "carried";
	var_02.deathoverridecallback = ::func_936D;
	var_01 thread scripts\cp\cp_movers::handle_moving_platforms(var_02);
	self.carried_seismic_trap delete();
	self delete();
}

//Function Number: 13
seismic_trap_setcancelled(param_00)
{
	if(isdefined(self.carriedby))
	{
		var_01 = self.carriedby;
		var_01 getrigindexfromarchetyperef();
		var_01.iscarrying = undefined;
		var_01.carrieditem = undefined;
		var_01 scripts\engine\utility::allow_weapon(1);
	}

	if(isdefined(param_00) && param_00)
	{
		func_66A7();
	}

	self.carried_seismic_trap delete();
	self delete();
}

//Function Number: 14
seismic_trap_setcarried(param_00)
{
	self setsentrycarrier(param_00);
	self setcontents(0);
	self setcandamage(0);
	self.carriedby = param_00;
	param_00.iscarrying = 1;
	param_00 thread scripts\cp\utility::update_trap_placement_internal(self,self.carried_seismic_trap,level.seismic_trap_settings["crafted_seismic"]);
	thread scripts\cp\utility::item_oncarrierdeath(param_00);
	thread func_936F(param_00);
	thread func_9371(param_00);
	if(isdefined(level.var_5CF2))
	{
		self thread [[ level.var_5CF2 ]](param_00);
	}

	self notify("carried");
}

//Function Number: 15
func_936F(param_00)
{
	self endon("placed");
	self endon("death");
	param_00 endon("last_stand");
	param_00 waittill("disconnect");
	seismic_trap_setcancelled();
}

//Function Number: 16
func_9371(param_00)
{
	self endon("placed");
	self endon("death");
	param_00 endon("last_stand");
	level waittill("game_ended");
	seismic_trap_setcancelled();
}

//Function Number: 17
seismic_trap_setactive()
{
	self endon("death");
	self setcursorhint("HINT_NOICON");
	self sethintstring(level.seismic_trap_settings[self.seismic_trap_type].pow);
	scripts\cp\utility::addtotraplist();
	var_00 = self.triggerportableradarping;
	var_00 getrigindexfromarchetyperef();
	scripts\cp\utility::setselfusable(var_00);
	self setusefov(120);
	self setuserange(96);
	if(isdefined(level.mpq_arm_func))
	{
		self thread [[ level.mpq_arm_func ]]();
	}

	thread seismic_trap_kill_zombies();
	thread scripts\cp\utility::item_handleownerdisconnect("seismic_disconnect");
	if(!isdefined(var_00.next_trap_time))
	{
		var_00.next_trap_time = gettime();
	}

	wait(1);
	if(isdefined(var_00))
	{
		if(gettime() >= var_00.next_trap_time)
		{
			self setscriptablepartstate("seismic","on");
		}
		else
		{
			while(gettime() <= var_00.next_trap_time)
			{
				wait(0.05);
			}

			self setscriptablepartstate("seismic","on");
		}

		if(isdefined(var_00))
		{
			var_00.next_trap_time = gettime() + 3000;
			return;
		}

		return;
	}

	self notify("death");
}

//Function Number: 18
seismic_trap_setinactive()
{
	self makeunusable();
	self stoploopsound();
	self setscriptablepartstate("seismic","off");
	if(isdefined(self.dmg_trig))
	{
		self.dmg_trig delete();
	}

	scripts\cp\utility::removefromtraplist();
}

//Function Number: 19
seismic_trap_kill_zombies()
{
	self endon("death");
	self.dmg_trig = spawn("trigger_radius",self.origin,0,250,64);
	for(;;)
	{
		self waittill("scriptableNotification");
		var_00 = scripts\cp\cp_agent_utils::getaliveagentsofteam("axis");
		foreach(var_02 in var_00)
		{
			if(!var_02 istouching(self.dmg_trig))
			{
				continue;
			}

			if(!scripts\cp\utility::should_be_affected_by_trap(var_02))
			{
				continue;
			}

			if(var_02.agent_type == "crab_mini" || var_02.agent_type == "crab_brute")
			{
				continue;
			}

			level thread fling_zombie(self,var_02);
			if(isdefined(self.triggerportableradarping))
			{
				self.triggerportableradarping scripts\cp\cp_merits::processmerit("mt_dlc3_crafted_kills");
			}
		}

		foreach(var_05 in level.players)
		{
			if(var_05 istouching(self.dmg_trig))
			{
				var_05 shellshock("seismic",0.5);
			}
		}

		wait(0.1);
		physicsexplosionsphere(self.origin + (0,0,-20),200,150,250);
	}
}

//Function Number: 20
fling_zombie(param_00,param_01)
{
	param_01 endon("death");
	param_01.dontmutilate = 1;
	param_01.do_immediate_ragdoll = 1;
	param_01.customdeath = 1;
	param_01.ragdollhitloc = "torso_lower";
	var_02 = param_00.origin - param_01.origin;
	var_02 = vectornormalize((var_02[0],var_02[1],0));
	param_01.ragdollimpactvector = var_02 * 3500;
	var_03 = undefined;
	if(isdefined(param_00.triggerportableradarping) && param_00.triggerportableradarping scripts\cp\utility::is_valid_player())
	{
		var_03 = param_00.triggerportableradarping;
	}

	param_01 dodamage(param_01.health + 100,param_00.origin + (0,0,-50),var_03,var_03,"MOD_UNKNOWN","iw7_fantrap_zm");
}