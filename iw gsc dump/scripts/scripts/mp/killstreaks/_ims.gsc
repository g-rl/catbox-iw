/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\killstreaks\_ims.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 49
 * Decompile Time: 2890 ms
 * Timestamp: 10/27/2023 12:28:50 AM
*******************************************************************/

//Function Number: 1
init()
{
	scripts\mp\killstreaks\_killstreaks::registerkillstreak("ims",::func_128EA);
	level.var_9385 = [];
	var_00 = spawnstruct();
	var_00.var_39B = "ims_projectile_mp";
	var_00.modelbase = "ims_scorpion_body_iw6";
	var_00.modelplacement = "ims_scorpion_body_iw6_placement";
	var_00.modelplacementfailed = "ims_scorpion_body_iw6_placement_failed";
	var_00.modeldestroyed = "ims_scorpion_body_iw6";
	var_00.modelbombsquad = "ims_scorpion_body_iw6_bombsquad";
	var_00.pow = &"KILLSTREAKS_HINTS_IMS_PICKUP_TO_MOVE";
	var_00.placestring = &"KILLSTREAKS_HINTS_IMS_PLACE";
	var_00.cannotplacestring = &"KILLSTREAKS_HINTS_IMS_CANNOT_PLACE";
	var_00.streakname = "ims";
	var_00.var_10A38 = "used_ims";
	var_00.maxhealth = 670;
	var_00.lifespan = 90;
	var_00.var_DDAC = 0.5;
	var_00._meth_8487 = 0.4;
	var_00.var_C228 = 4;
	var_00.var_6A03 = "ims_scorpion_explosive_iw6";
	var_00.placementheighttolerance = 30;
	var_00.placementradius = 24;
	var_00.var_AC49 = "tag_lid";
	var_00.var_AC47 = [];
	var_00.var_AC47[1] = "IMS_Scorpion_door_1";
	var_00.var_AC47[2] = "IMS_Scorpion_door_2";
	var_00.var_AC47[3] = "IMS_Scorpion_door_3";
	var_00.var_AC47[4] = "IMS_Scorpion_door_4";
	var_00.var_AC48 = [];
	var_00.var_AC48[1] = "IMS_Scorpion_1_opened";
	var_00.var_AC48[2] = "IMS_Scorpion_2_opened";
	var_00.var_AC48[3] = "IMS_Scorpion_3_opened";
	var_00.var_6A09 = "tag_explosive";
	var_00.killcamoffset = (0,0,12);
	level.var_9385["ims"] = var_00;
	level._effect["ims_explode_mp"] = loadfx("vfx/iw7/_requests/mp/vfx_generic_equipment_exp_lg.vfx");
	level._effect["ims_smoke_mp"] = loadfx("vfx/core/mp/killstreaks/vfx_sg_damage_blacksmoke");
	level._effect["ims_sensor_explode"] = loadfx("vfx/core/mp/killstreaks/vfx_ims_sparks");
	level._effect["ims_antenna_light_mp"] = loadfx("vfx/core/mp/killstreaks/vfx_light_detonator_blink");
	level.placedims = [];
}

//Function Number: 2
func_128EA(param_00)
{
	var_01 = [];
	if(isdefined(self.var_9382))
	{
		var_01 = self.var_9382;
	}

	var_02 = _meth_836E("ims",param_00);
	if(!isdefined(var_02))
	{
		var_02 = 0;
		if(isdefined(self.var_9382))
		{
			if(!var_01.size && self.var_9382.size)
			{
				var_02 = 1;
			}

			if(var_01.size && var_01[0] != self.var_9382[0])
			{
				var_02 = 1;
			}
		}
	}

	if(var_02)
	{
		scripts\mp\_matchdata::logkillstreakevent(param_00.streakname,self.origin);
	}

	self.iscarrying = 0;
	return var_02;
}

//Function Number: 3
_meth_836E(param_00,param_01)
{
	var_02 = createimsforplayer(param_00,self);
	param_01.var_9380 = var_02;
	removeperks();
	self.carriedims = var_02;
	var_02.firstplacement = 1;
	var_03 = func_F684(var_02,1);
	self.carriedims = undefined;
	thread restoreperks();
	return var_03;
}

//Function Number: 4
func_F684(param_00,param_01)
{
	self endon("death");
	self endon("disconnect");
	param_00 thread func_9377(self);
	scripts\engine\utility::allow_weapon(0);
	if(!isai(self))
	{
		self notifyonplayercommand("place_ims","+attack");
		self notifyonplayercommand("place_ims","+attack_akimbo_accessible");
		if(!level.console)
		{
			self notifyonplayercommand("cancel_ims","+actionslot 5");
			self notifyonplayercommand("cancel_ims","+actionslot 6");
			self notifyonplayercommand("cancel_ims","+actionslot 7");
		}
	}

	for(;;)
	{
		var_02 = scripts\engine\utility::waittill_any_return("place_ims","cancel_ims","force_cancel_placement","killstreak_trigger_blocked");
		if(var_02 == "cancel_ims" || var_02 == "force_cancel_placement" || var_02 == "killstreak_trigger_blocked")
		{
			if(!param_01 && var_02 == "cancel_ims" || var_02 == "killstreak_trigger_blocked")
			{
				continue;
			}

			param_00 ims_setcancelled(var_02 == "force_cancel_placement" && !isdefined(param_00.firstplacement));
			return 0;
		}

		if(!param_00.canbeplaced)
		{
			continue;
		}

		param_00 thread func_9379();
		self notify("IMS_placed");
		scripts\engine\utility::allow_weapon(1);
		return 1;
	}
}

//Function Number: 5
removeweapons()
{
	if(self hasweapon("iw6_riotshield_mp"))
	{
		self.restoreweapon = "iw6_riotshield_mp";
		scripts\mp\_utility::_takeweapon("iw6_riotshield_mp");
	}
}

//Function Number: 6
removeperks()
{
	if(scripts\mp\_utility::_hasperk("specialty_explosivebullets"))
	{
		self.restoreperk = "specialty_explosivebullets";
		scripts\mp\_utility::removeperk("specialty_explosivebullets");
	}
}

//Function Number: 7
restoreweapons()
{
	if(isdefined(self.restoreweapon))
	{
		scripts\mp\_utility::_giveweapon(self.restoreweapon);
		self.restoreweapon = undefined;
	}
}

//Function Number: 8
restoreperks()
{
	if(isdefined(self.restoreperk))
	{
		scripts\mp\_utility::giveperk(self.restoreperk);
		self.restoreperk = undefined;
	}
}

//Function Number: 9
waitrestoreperks()
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	wait(0.05);
	restoreperks();
}

//Function Number: 10
createimsforplayer(param_00,param_01)
{
	if(isdefined(param_01.iscarrying) && param_01.iscarrying)
	{
		return;
	}

	var_02 = spawnturret("misc_turret",param_01.origin + (0,0,25),"sentry_minigun_mp");
	var_02.angles = param_01.angles;
	var_02.var_9386 = param_00;
	var_02.triggerportableradarping = param_01;
	var_02 setmodel(level.var_9385[param_00].modelbase);
	var_02 getvalidattachments();
	var_02 setturretmodechangewait(1);
	var_02 give_player_session_tokens("sentry_offline");
	var_02 makeunusable();
	var_02 setsentryowner(param_01);
	return var_02;
}

//Function Number: 11
createims(param_00)
{
	var_01 = param_00.triggerportableradarping;
	var_02 = param_00.var_9386;
	var_03 = spawn("script_model",param_00.origin);
	var_03 setmodel(level.var_9385[var_02].modelbase);
	var_03.var_EB9C = 3;
	var_03.angles = param_00.angles;
	var_03.var_9386 = var_02;
	var_03.triggerportableradarping = var_01;
	var_03 setotherent(var_01);
	var_03.team = var_01.team;
	var_03.shouldsplash = 0;
	var_03.hidden = 0;
	var_03.var_252E = 1;
	var_03 getqacalloutalias();
	var_03.var_8BF0 = [];
	var_03.config = level.var_9385[var_02];
	var_03 thread func_9369();
	var_03 thread func_937C();
	var_03 thread func_9363();
	var_03 thread func_9372();
	return var_03;
}

//Function Number: 12
func_9363()
{
	var_00 = spawn("script_model",self.origin);
	var_00.angles = self.angles;
	var_00 hide();
	var_00 thread scripts\mp\_weapons::bombsquadvisibilityupdater(self.triggerportableradarping);
	var_00 setmodel(level.var_9385[self.var_9386].modelbombsquad);
	var_00 linkto(self);
	var_00 setcontents(0);
	self.bombsquadmodel = var_00;
	self waittill("death");
	if(isdefined(var_00))
	{
		var_00 delete();
	}
}

//Function Number: 13
func_936D(param_00)
{
	self.var_933C = 1;
	self notify("death");
}

//Function Number: 14
func_9366()
{
	self endon("carried");
	scripts\mp\_damage::monitordamage(self.config.maxhealth,"ims",::func_9368,::func_936C,1);
}

//Function Number: 15
func_936C(param_00,param_01,param_02,param_03,param_04)
{
	if(self.hidden || param_01 == "ims_projectile_mp")
	{
		return -1;
	}

	var_05 = param_03;
	if(param_02 == "MOD_MELEE")
	{
		var_05 = self.maxhealth * 0.25;
	}

	if(function_0107(param_02))
	{
		var_05 = param_03 * 1.5;
	}

	var_05 = scripts\mp\_damage::handlemissiledamage(param_01,param_02,var_05);
	var_05 = scripts\mp\_damage::handleapdamage(param_01,param_02,var_05);
	return var_05;
}

//Function Number: 16
func_9368(param_00,param_01,param_02,param_03)
{
	var_04 = scripts\mp\_damage::onkillstreakkilled("ims",param_00,param_01,param_02,param_03,"destroyed_ims","ims_destroyed");
	if(var_04)
	{
		param_00 notify("destroyed_equipment");
	}
}

//Function Number: 17
func_9367()
{
	self endon("carried");
	self waittill("death");
	func_E10B();
	if(!isdefined(self))
	{
		return;
	}

	func_9378();
	self playsound("ims_destroyed");
	if(isdefined(self.inuseby))
	{
		playfx(scripts\engine\utility::getfx("ims_explode_mp"),self.origin + (0,0,10));
		playfx(scripts\engine\utility::getfx("ims_smoke_mp"),self.origin);
		self.inuseby restoreperks();
		self.inuseby restoreweapons();
		self notify("deleting");
		wait(1);
	}
	else if(isdefined(self.var_933C))
	{
		playfx(scripts\engine\utility::getfx("ims_explode_mp"),self.origin + (0,0,10));
		self notify("deleting");
	}
	else
	{
		playfx(scripts\engine\utility::getfx("ims_explode_mp"),self.origin + (0,0,10));
		playfx(scripts\engine\utility::getfx("ims_smoke_mp"),self.origin);
		wait(3);
		self playsound("ims_fire");
		self notify("deleting");
	}

	if(isdefined(self.objidfriendly))
	{
		scripts\mp\objidpoolmanager::returnminimapid(self.objidfriendly);
	}

	if(isdefined(self.var_C2BA))
	{
		scripts\mp\objidpoolmanager::returnminimapid(self.var_C2BA);
	}

	scripts\mp\_weapons::equipmentdeletevfx();
	self _meth_80D4();
	self delete();
}

//Function Number: 18
watchempdamage()
{
	self endon("carried");
	self endon("death");
	level endon("game_ended");
	for(;;)
	{
		self waittill("emp_damage",var_00,var_01);
		scripts\mp\_weapons::stopblinkinglight();
		playfx(scripts\engine\utility::getfx("emp_stun"),self.origin);
		playfx(scripts\engine\utility::getfx("ims_smoke_mp"),self.origin);
		wait(var_01);
		func_937B();
	}
}

//Function Number: 19
func_9369()
{
	self endon("death");
	level endon("game_ended");
	for(;;)
	{
		self waittill("trigger",var_00);
		if(!scripts\mp\_utility::isreallyalive(var_00))
		{
			continue;
		}

		if(self.var_E1 >= self.maxhealth)
		{
			continue;
		}

		var_01 = createimsforplayer(self.var_9386,var_00);
		if(!isdefined(var_01))
		{
			continue;
		}

		var_01.var_935F = self;
		func_9378();
		func_936A();
		if(isdefined(self getlinkedparent()))
		{
			self unlink();
		}

		var_00 func_F684(var_01,0);
	}
}

//Function Number: 20
func_9379()
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
	var_00 = undefined;
	if(isdefined(self.var_935F))
	{
		var_00 = self.var_935F;
		var_00 endon("death");
		var_00.origin = self.origin;
		var_00.angles = self.angles;
		var_00.carriedby = undefined;
		var_00 func_937A();
		if(isdefined(var_00.bombsquadmodel))
		{
			var_00.bombsquadmodel show();
			var_00 func_9383(var_00.bombsquadmodel,1);
			level notify("update_bombsquad");
		}
	}
	else
	{
		var_00 = createims(self);
	}

	var_00 func_184F();
	var_00.isplaced = 1;
	var_00 thread func_9366();
	var_00 thread watchempdamage();
	var_00 thread func_9367();
	var_00 setcandamage(1);
	self playsound("ims_plant");
	self notify("placed");
	var_00 thread func_9375();
	var_01 = spawnstruct();
	if(isdefined(self.moving_platform))
	{
		var_01.linkparent = self.moving_platform;
	}

	var_01.endonstring = "carried";
	var_01.deathoverridecallback = ::func_936D;
	var_00 thread scripts\mp\_movers::handle_moving_platforms(var_01);
	self delete();
}

//Function Number: 21
ims_setcancelled(param_00)
{
	if(isdefined(self.carriedby))
	{
		var_01 = self.carriedby;
		var_01 getrigindexfromarchetyperef();
		var_01.iscarrying = undefined;
		var_01.carrieditem = undefined;
		var_01 scripts\engine\utility::allow_weapon(1);
		if(isdefined(var_01.var_9382))
		{
			foreach(var_03 in var_01.var_9382)
			{
				if(isdefined(var_03.bombsquadmodel))
				{
					var_03.bombsquadmodel delete();
				}
			}
		}
	}

	if(isdefined(param_00) && param_00)
	{
		scripts\mp\_weapons::equipmentdeletevfx();
	}

	self delete();
}

//Function Number: 22
func_9377(param_00)
{
	func_E10B();
	self setmodel(level.var_9385[self.var_9386].modelplacement);
	self setsentrycarrier(param_00);
	self setcontents(0);
	self setcandamage(0);
	self.carriedby = param_00;
	param_00.iscarrying = 1;
	param_00 thread func_12EB0(self);
	thread func_936E(param_00);
	thread func_936F(param_00);
	thread func_9371();
	thread func_9370(param_00);
	self notify("carried");
	if(isdefined(self.var_935F))
	{
		self.var_935F notify("carried");
		self.var_935F.carriedby = param_00;
		self.var_935F.isplaced = 0;
		if(isdefined(self.var_935F.bombsquadmodel))
		{
			self.var_935F.bombsquadmodel hide();
		}
	}
}

//Function Number: 23
func_12EB0(param_00)
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	param_00 endon("placed");
	param_00 endon("death");
	param_00.canbeplaced = 1;
	var_01 = -1;
	var_02 = level.var_9385[param_00.var_9386];
	for(;;)
	{
		var_03 = self canplayerplacesentry(1,var_02.placementradius);
		param_00.origin = var_03["origin"];
		param_00.angles = var_03["angles"];
		param_00.canbeplaced = self isonground() && var_03["result"] && abs(param_00.origin[2] - self.origin[2]) < var_02.placementheighttolerance;
		if(isdefined(var_03["entity"]))
		{
			param_00.moving_platform = var_03["entity"];
		}
		else
		{
			param_00.moving_platform = undefined;
		}

		if(param_00.canbeplaced != var_01)
		{
			if(param_00.canbeplaced)
			{
				param_00 setmodel(level.var_9385[param_00.var_9386].modelplacement);
				self forceusehinton(level.var_9385[param_00.var_9386].placestring);
			}
			else
			{
				param_00 setmodel(level.var_9385[param_00.var_9386].modelplacementfailed);
				self forceusehinton(level.var_9385[param_00.var_9386].cannotplacestring);
			}
		}

		var_01 = param_00.canbeplaced;
		wait(0.05);
	}
}

//Function Number: 24
func_936E(param_00)
{
	self endon("placed");
	self endon("death");
	param_00 endon("disconnect");
	param_00 waittill("death");
	if(self.canbeplaced && param_00.team != "spectator")
	{
		thread func_9379();
		return;
	}

	ims_setcancelled();
}

//Function Number: 25
func_936F(param_00)
{
	self endon("placed");
	self endon("death");
	param_00 waittill("disconnect");
	ims_setcancelled();
}

//Function Number: 26
func_9370(param_00)
{
	self endon("placed");
	self endon("death");
	for(;;)
	{
		if(isdefined(self.carriedby.onhelisniper) && self.carriedby.onhelisniper)
		{
			self notify("death");
		}

		wait(0.1);
	}
}

//Function Number: 27
func_9371(param_00)
{
	self endon("placed");
	self endon("death");
	level waittill("game_ended");
	ims_setcancelled();
}

//Function Number: 28
func_9375()
{
	self setcursorhint("HINT_NOICON");
	self sethintstring(level.var_9385[self.var_9386].pow);
	var_00 = self.triggerportableradarping;
	var_00 getrigindexfromarchetyperef();
	if(level.teambased)
	{
		scripts\mp\_entityheadicons::setteamheadicon(self.team,(0,0,60));
	}
	else
	{
		scripts\mp\_entityheadicons::setplayerheadicon(var_00,(0,0,60));
	}

	self makeusable();
	self setcandamage(1);
	if(isdefined(var_00.var_9382))
	{
		foreach(var_02 in var_00.var_9382)
		{
			if(var_02 == self)
			{
				continue;
			}

			var_02 notify("death");
		}
	}

	var_00.var_9382 = [];
	var_00.var_9382[0] = self;
	foreach(var_05 in level.players)
	{
		if(var_05 == var_00)
		{
			self enableplayeruse(var_05);
			continue;
		}

		self disableplayeruse(var_05);
	}

	if(self.shouldsplash)
	{
		level thread scripts\mp\_utility::teamplayercardsplash(level.var_9385[self.var_9386].var_10A38,var_00);
		self.shouldsplash = 0;
	}

	var_07 = (0,0,20);
	var_08 = (0,0,256) - var_07;
	var_09 = [];
	self.var_A637 = [];
	for(var_0A = 0;var_0A < self.config.var_C228;var_0A++)
	{
		if(func_C229())
		{
			var_0B = func_FCA8(var_0A + 1,self.config.var_C228 - 4);
		}
		else
		{
			var_0B = var_0A + 1;
		}

		var_0C = self gettagorigin(self.config.var_6A09 + var_0B + "_attach");
		var_0D = self gettagorigin(self.config.var_6A09 + var_0B + "_attach") + var_07;
		var_09[var_0A] = bullettrace(var_0D,var_0D + var_08,0,self);
		if(var_0A < 4)
		{
			var_0E = spawn("script_model",var_0C + self.config.killcamoffset);
			var_0E setscriptmoverkillcam("explosive");
			self.var_A637[self.var_A637.size] = var_0E;
		}
	}

	var_0F = var_09[0];
	for(var_0A = 0;var_0A < var_09.size;var_0A++)
	{
		if(var_09[var_0A]["position"][2] < var_0F["position"][2])
		{
			var_0F = var_09[var_0A];
		}
	}

	self.var_2514 = var_0F["position"] - (0,0,20) - self.origin;
	var_10 = spawn("trigger_radius",self.origin,0,256,100);
	self.var_2536 = var_10;
	self.var_2536 enablelinkto();
	self.var_2536 linkto(self);
	self.var_2528 = length(self.var_2514) / 200;
	func_937F();
	func_937B();
	thread func_937D();
	foreach(var_05 in level.players)
	{
		thread func_9374(var_05);
	}
}

//Function Number: 29
func_937D()
{
	self endon("death");
	for(;;)
	{
		level waittill("connected",var_00);
		func_9373(var_00);
	}
}

//Function Number: 30
func_9373(param_00)
{
	self endon("death");
	param_00 endon("disconnect");
	param_00 waittill("spawned_player");
	self disableplayeruse(param_00);
}

//Function Number: 31
func_9374(param_00)
{
	self endon("death");
	param_00 endon("disconnect");
	for(;;)
	{
		param_00 waittill("joined_team");
		self disableplayeruse(param_00);
	}
}

//Function Number: 32
func_9372()
{
	self endon("death");
	level endon("game_ended");
	self.triggerportableradarping waittill("killstreak_disowned");
	if(isdefined(self.isplaced))
	{
		self notify("death");
		return;
	}

	ims_setcancelled(0);
}

//Function Number: 33
func_937B()
{
	thread scripts\mp\_weapons::doblinkinglight("tag_fx");
	thread func_9362();
}

//Function Number: 34
func_9378()
{
	self makeunusable();
	if(level.teambased)
	{
		scripts\mp\_entityheadicons::setteamheadicon("none",(0,0,0));
	}
	else if(isdefined(self.triggerportableradarping))
	{
		scripts\mp\_entityheadicons::setplayerheadicon(undefined,(0,0,0));
	}

	if(isdefined(self.var_2536))
	{
		self.var_2536 delete();
	}

	if(isdefined(self.var_A637))
	{
		foreach(var_01 in self.var_A637)
		{
			if(isdefined(var_01))
			{
				if(isdefined(self.triggerportableradarping) && isdefined(self.triggerportableradarping.var_9381) && var_01 == self.triggerportableradarping.var_9381)
				{
					continue;
				}
				else
				{
					var_01 delete();
				}
			}
		}
	}

	if(isdefined(self.var_69F6))
	{
		self.var_69F6 delete();
		self.var_69F6 = undefined;
	}

	scripts\mp\_weapons::stopblinkinglight();
}

//Function Number: 35
isfriendlytoims(param_00)
{
	if(level.teambased && self.team == param_00.team)
	{
		return 1;
	}

	return 0;
}

//Function Number: 36
func_9362()
{
	self endon("death");
	self endon("emp_damage");
	level endon("game_ended");
	for(;;)
	{
		if(!isdefined(self.var_2536))
		{
			break;
		}

		self.var_2536 waittill("trigger",var_00);
		if(isplayer(var_00))
		{
			if(isdefined(self.triggerportableradarping) && var_00 == self.triggerportableradarping)
			{
				continue;
			}

			if(level.teambased && var_00.pers["team"] == self.team)
			{
				continue;
			}

			if(!scripts\mp\_utility::isreallyalive(var_00))
			{
				continue;
			}
		}
		else if(isdefined(var_00.triggerportableradarping))
		{
			if(isdefined(self.triggerportableradarping) && var_00.triggerportableradarping == self.triggerportableradarping)
			{
				continue;
			}

			if(level.teambased && var_00.triggerportableradarping.pers["team"] == self.team)
			{
				continue;
			}
		}

		var_01 = var_00.origin + (0,0,50);
		if(!sighttracepassed(self.var_2514 + self.origin,var_01,0,self))
		{
			continue;
		}

		var_02 = 0;
		for(var_03 = 1;var_03 <= self.config.var_C228;var_03++)
		{
			if(var_03 > 4)
			{
				break;
			}

			if(sighttracepassed(self gettagorigin(self.config.var_AC49 + var_03),var_01,0,self))
			{
				var_02 = 1;
				break;
			}
		}

		if(!var_02)
		{
			continue;
		}

		self playsound("ims_trigger");
		scripts\mp\_weapons::explosivetrigger(var_00,level.var_9385[self.var_9386]._meth_8487,"ims");
		if(!isdefined(self.var_2536))
		{
			break;
		}

		if(!isdefined(self.var_8BF0[self.var_252E]))
		{
			self.var_8BF0[self.var_252E] = 1;
			thread func_6D2C(var_00,self.var_252E);
			self.var_252E++;
		}

		if(self.var_252E > self.config.var_C228)
		{
			break;
		}

		func_937F();
		self waittill("sensor_exploded");
		wait(self.config.var_DDAC);
		if(!isdefined(self.triggerportableradarping))
		{
			break;
		}
	}

	if(isdefined(self.carriedby) && isdefined(self.triggerportableradarping) && self.carriedby == self.triggerportableradarping)
	{
		return;
	}

	self notify("death");
}

//Function Number: 37
func_6D2C(param_00,param_01)
{
	if(func_C229())
	{
		param_01 = func_FCA8(param_01,self.config.var_C228 - 4);
	}

	var_02 = self.var_69F6;
	self.var_69F6 = undefined;
	var_03 = self.config.var_AC49 + param_01;
	playfxontag(level._effect["ims_sensor_explode"],self,var_03);
	func_9384(param_01,self.config);
	var_04 = self.config.var_39B;
	var_05 = self.triggerportableradarping;
	var_02 unlink();
	var_02 rotateyaw(3600,self.var_2528);
	var_02 moveto(self.var_2514 + self.origin,self.var_2528,self.var_2528 * 0.25,self.var_2528 * 0.25);
	if(isdefined(var_02.killcament))
	{
		var_06 = var_02.killcament;
		var_06 unlink();
		if(isdefined(self.triggerportableradarping))
		{
			self.triggerportableradarping.var_9381 = var_06;
		}

		var_06 moveto(self.var_2514 + self.origin + self.config.killcamoffset,self.var_2528,self.var_2528 * 0.25,self.var_2528 * 0.25);
		if(!func_C229())
		{
			var_06 thread deleteaftertime(5);
		}
	}

	var_02 playsound("ims_launch");
	var_02 waittill("movedone");
	playfx(level._effect["ims_sensor_explode"],var_02.origin);
	var_07 = [];
	var_07[0] = param_00.origin;
	for(var_08 = 0;var_08 < var_07.size;var_08++)
	{
		if(isdefined(var_05))
		{
			scripts\mp\_utility::_magicbullet(var_04,var_02.origin,var_07[var_08],var_05);
			continue;
		}

		scripts\mp\_utility::_magicbullet(var_04,var_02.origin,var_07[var_08]);
	}

	var_02 delete();
	self notify("sensor_exploded");
}

//Function Number: 38
deleteaftertime(param_00)
{
	self endon("death");
	level scripts\mp\_hostmigration::waitlongdurationwithhostmigrationpause(param_00);
	if(isdefined(self))
	{
		self delete();
	}
}

//Function Number: 39
func_937C()
{
	self endon("death");
	level endon("game_ended");
	var_00 = level.var_9385[self.var_9386].lifespan;
	while(var_00)
	{
		wait(1);
		scripts\mp\_hostmigration::waittillhostmigrationdone();
		if(!isdefined(self.carriedby))
		{
			var_00 = max(0,var_00 - 1);
		}
	}

	self notify("death");
}

//Function Number: 40
func_184F()
{
	var_00 = self getentitynumber();
	level.placedims[var_00] = self;
}

//Function Number: 41
func_E10B()
{
	var_00 = self getentitynumber();
	level.placedims[var_00] = undefined;
}

//Function Number: 42
func_936A()
{
	self hide();
	self.hidden = 1;
}

//Function Number: 43
func_937A()
{
	self show();
	self.hidden = 0;
	func_9383(self,1);
}

//Function Number: 44
func_937E(param_00)
{
	var_01 = spawn("script_model",self gettagorigin(self.config.var_6A09 + param_00 + "_attach"));
	var_01 setmodel(self.config.var_6A03);
	var_01.angles = self.angles;
	var_01.killcament = self.var_A637[param_00 - 1];
	var_01.killcament linkto(self);
	return var_01;
}

//Function Number: 45
func_937F()
{
	for(var_00 = 1;var_00 <= self.config.var_C228 && isdefined(self.var_8BF0[var_00]);var_00++)
	{
	}

	if(var_00 <= self.config.var_C228)
	{
		if(func_C229())
		{
			var_00 = func_FCA8(var_00,self.config.var_C228 - 4);
		}

		var_01 = func_937E(var_00);
		var_01 linkto(self);
		self.var_69F6 = var_01;
	}
}

//Function Number: 46
func_9384(param_00,param_01,param_02)
{
	var_03 = param_01.var_AC49 + param_00 + "_attach";
	var_04 = undefined;
	if(isdefined(param_02))
	{
		var_04 = param_01.var_AC48[param_00];
	}
	else
	{
		var_04 = param_01.var_AC47[param_00];
	}

	self scriptmodelplayanim(var_04);
	var_05 = param_01.var_6A09 + param_00 + "_attach";
	self hidepart(var_05);
}

//Function Number: 47
func_9383(param_00,param_01)
{
	var_02 = self.var_8BF0.size;
	if(var_02 > 0)
	{
		if(func_C229())
		{
			var_02 = func_FCA8(var_02,self.config.var_C228 - 4);
		}

		param_00 func_9384(var_02,self.config,param_01);
	}
}

//Function Number: 48
func_C229()
{
	return self.config.var_C228 > 4;
}

//Function Number: 49
func_FCA8(param_00,param_01)
{
	var_02 = param_00 - param_01;
	var_02 = max(1,var_02);
	return int(var_02);
}