/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\killstreaks\_placeable.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 30
 * Decompile Time: 1476 ms
 * Timestamp: 10/27/2023 12:29:17 AM
*******************************************************************/

//Function Number: 1
init()
{
	if(!isdefined(level.placeableconfigs))
	{
		level.placeableconfigs = [];
	}
}

//Function Number: 2
giveplaceable(param_00,param_01)
{
	var_02 = createplaceable(param_00);
	removeperks();
	self.carrieditem = var_02;
	var_03 = onbeginnewmode(param_00,var_02,1,param_01);
	self.carrieditem = undefined;
	restoreperks();
	return isdefined(var_02);
}

//Function Number: 3
createplaceable(param_00)
{
	if(isdefined(self.iscarrying) && self.iscarrying)
	{
		return;
	}

	var_01 = level.placeableconfigs[param_00];
	var_02 = spawn("script_model",self.origin);
	var_02 setmodel(var_01.modelbase);
	var_02.angles = self.angles;
	var_02.triggerportableradarping = self;
	var_02.team = self.team;
	var_02.config = var_01;
	var_02.firstplacement = 1;
	if(isdefined(var_01.var_C4DE))
	{
		var_02 [[ var_01.var_C4DE ]](param_00);
	}

	var_02 deactivate(param_00);
	var_02 thread timeout(param_00);
	var_02 thread func_89FA(param_00);
	var_02 thread func_C547(param_00);
	var_02 thread ongameended(param_00);
	var_02 thread createbombsquadmodel(param_00);
	return var_02;
}

//Function Number: 4
func_89FA(param_00)
{
	self endon("death");
	level endon("game_ended");
	for(;;)
	{
		self waittill("trigger",var_01);
		if(!scripts\mp\_utility::isreallyalive(var_01))
		{
			continue;
		}

		if(isdefined(self getlinkedparent()))
		{
			self unlink();
		}

		var_01 onbeginnewmode(param_00,self,0);
	}
}

//Function Number: 5
onbeginnewmode(param_00,param_01,param_02,param_03)
{
	self endon("death");
	self endon("disconnect");
	param_01 thread oncarried(param_00,self);
	scripts\engine\utility::allow_weapon(0);
	if(!isai(self))
	{
		self notifyonplayercommand("placePlaceable","+attack");
		self notifyonplayercommand("placePlaceable","+attack_akimbo_accessible");
		self notifyonplayercommand("cancelPlaceable","+actionslot 4");
		if(!level.console)
		{
			self notifyonplayercommand("cancelPlaceable","+actionslot 5");
			self notifyonplayercommand("cancelPlaceable","+actionslot 6");
			self notifyonplayercommand("cancelPlaceable","+actionslot 7");
		}
	}

	for(;;)
	{
		if(isdefined(param_03) && param_03 == 1 && !self isonladder() && self isonground() && !self ismantling())
		{
			var_04 = "placePlaceable";
		}
		else
		{
			var_04 = scripts\engine\utility::waittill_any_return("placePlaceable","cancelPlaceable","force_cancel_placement");
		}

		if(!isdefined(param_01))
		{
			scripts\engine\utility::allow_weapon(1);
			return 1;
		}
		else if((var_04 == "cancelPlaceable" && param_02) || var_04 == "force_cancel_placement")
		{
			param_01 oncancel(param_00,var_04 == "force_cancel_placement" && !isdefined(param_01.firstplacement));
			return 0;
		}
		else if(param_01.canbeplaced)
		{
			param_01 thread onplaced(param_00);
			scripts\engine\utility::allow_weapon(1);
			return 1;
		}
		else
		{
			wait(0.05);
		}
	}
}

//Function Number: 6
oncancel(param_00,param_01)
{
	if(isdefined(self.carriedby))
	{
		var_02 = self.carriedby;
		var_02 getrigindexfromarchetyperef();
		var_02.iscarrying = undefined;
		var_02.carrieditem = undefined;
		var_02 scripts\engine\utility::allow_weapon(1);
	}

	if(isdefined(self.bombsquadmodel))
	{
		self.bombsquadmodel delete();
	}

	if(isdefined(self.carriedobj))
	{
		self.carriedobj delete();
	}

	var_03 = level.placeableconfigs[param_00];
	if(isdefined(var_03.oncanceldelegate))
	{
		self [[ var_03.oncanceldelegate ]](param_00);
	}

	if(isdefined(param_01) && param_01)
	{
		scripts\mp\_weapons::equipmentdeletevfx();
	}

	self delete();
}

//Function Number: 7
onplaced(param_00)
{
	var_01 = level.placeableconfigs[param_00];
	self.origin = self.var_CC24;
	self.angles = self.carriedobj.angles;
	self playsound(var_01.var_CC15);
	showplacedmodel(param_00);
	if(isdefined(var_01.onplaceddelegate))
	{
		self [[ var_01.onplaceddelegate ]](param_00);
	}

	self setcursorhint("HINT_NOICON");
	self sethintstring(var_01.pow);
	var_02 = self.triggerportableradarping;
	var_02 getrigindexfromarchetyperef();
	var_02.iscarrying = undefined;
	self.carriedby = undefined;
	self.isplaced = 1;
	self.firstplacement = undefined;
	if(isdefined(var_01.var_8C79))
	{
		if(level.teambased)
		{
			scripts\mp\_entityheadicons::setteamheadicon(self.team,(0,0,var_01.var_8C79));
		}
		else
		{
			scripts\mp\_entityheadicons::setplayerheadicon(var_02,(0,0,var_01.var_8C79));
		}
	}

	thread handledamage(param_00);
	thread handledeath(param_00);
	self makeusable();
	scripts\mp\sentientpoolmanager::registersentient("Killstreak_Ground",self.triggerportableradarping);
	foreach(var_04 in level.players)
	{
		if(var_04 == var_02)
		{
			self enableplayeruse(var_04);
			continue;
		}

		self disableplayeruse(var_04);
	}

	if(isdefined(self.shouldsplash))
	{
		level thread scripts\mp\_utility::teamplayercardsplash(var_01.var_10A38,var_02);
		self.shouldsplash = 0;
	}

	var_06 = spawnstruct();
	var_06.linkparent = self.moving_platform;
	var_06.playdeathfx = 1;
	var_06.endonstring = "carried";
	if(isdefined(var_01.var_C55B))
	{
		var_06.deathoverridecallback = var_01.var_C55B;
	}

	thread scripts\mp\_movers::handle_moving_platforms(var_06);
	thread watchplayerconnected();
	self notify("placed");
	self.carriedobj delete();
	self.carriedobj = undefined;
}

//Function Number: 8
oncarried(param_00,param_01)
{
	var_02 = level.placeableconfigs[param_00];
	self.carriedobj = param_01 createcarriedobject(param_00);
	self.isplaced = undefined;
	self.carriedby = param_01;
	param_01.iscarrying = 1;
	deactivate(param_00);
	hideplacedmodel(param_00);
	if(isdefined(var_02.oncarrieddelegate))
	{
		self [[ var_02.oncarrieddelegate ]](param_00);
	}

	thread updateplacement(param_00,param_01);
	thread oncarrierdeath(param_00,param_01);
	self notify("carried");
}

//Function Number: 9
updateplacement(param_00,param_01)
{
	param_01 endon("death");
	param_01 endon("disconnect");
	level endon("game_ended");
	self endon("placed");
	self endon("death");
	self.canbeplaced = 1;
	var_02 = -1;
	var_03 = level.placeableconfigs[param_00];
	var_04 = (0,0,0);
	if(isdefined(var_03.var_CC23))
	{
		var_04 = (0,0,var_03.var_CC23);
	}

	var_05 = self.carriedobj;
	for(;;)
	{
		var_06 = param_01 canplayerplacesentry(1,var_03.placementradius);
		self.var_CC24 = var_06["origin"];
		var_05.origin = self.var_CC24 + var_04;
		var_05.angles = var_06["angles"];
		self.canbeplaced = param_01 isonground() && var_06["result"] && abs(self.var_CC24[2] - param_01.origin[2]) < var_03.placementheighttolerance;
		if(isdefined(var_06["entity"]))
		{
			self.moving_platform = var_06["entity"];
		}
		else
		{
			self.moving_platform = undefined;
		}

		if(self.canbeplaced != var_02)
		{
			if(self.canbeplaced)
			{
				var_05 setmodel(var_03.modelplacement);
				param_01 forceusehinton(var_03.placestring);
			}
			else
			{
				var_05 setmodel(var_03.modelplacementfailed);
				param_01 forceusehinton(var_03.cannotplacestring);
			}
		}

		var_02 = self.canbeplaced;
		wait(0.05);
	}
}

//Function Number: 10
deactivate(param_00)
{
	self makeunusable();
	hideheadicons();
	var_01 = level.placeableconfigs[param_00];
	if(isdefined(var_01.ondeactivedelegate))
	{
		self [[ var_01.ondeactivedelegate ]](param_00);
	}
}

//Function Number: 11
hideheadicons()
{
	if(level.teambased)
	{
		scripts\mp\_entityheadicons::setteamheadicon("none",(0,0,0));
		return;
	}

	if(isdefined(self.triggerportableradarping))
	{
		scripts\mp\_entityheadicons::setplayerheadicon(undefined,(0,0,0));
	}
}

//Function Number: 12
handledamage(param_00)
{
	self endon("carried");
	var_01 = level.placeableconfigs[param_00];
	scripts\mp\_damage::monitordamage(var_01.maxhealth,var_01.damagefeedback,::handledeathdamage,::modifydamage,1);
}

//Function Number: 13
modifydamage(param_00,param_01,param_02,param_03,param_04)
{
	var_05 = param_03;
	var_06 = self.config;
	if(isdefined(var_06.allowmeleedamage) && var_06.allowmeleedamage)
	{
		var_05 = scripts\mp\_damage::handlemeleedamage(param_01,param_02,var_05);
	}

	if(isdefined(var_06.var_1C8F) && var_06.var_1C8F)
	{
		var_05 = scripts\mp\_damage::handleempdamage(param_01,param_02,var_05);
	}

	var_05 = scripts\mp\_damage::handlemissiledamage(param_01,param_02,var_05);
	var_05 = scripts\mp\_damage::handlegrenadedamage(param_01,param_02,var_05);
	var_05 = scripts\mp\_damage::handleapdamage(param_01,param_02,var_05);
	if(isdefined(var_06.modifydamage))
	{
		var_05 = self [[ var_06.modifydamage ]](param_01,param_02,var_05);
	}

	return var_05;
}

//Function Number: 14
handledeathdamage(param_00,param_01,param_02,param_03)
{
	var_04 = self.config;
	var_05 = scripts\mp\_damage::onkillstreakkilled(self.streakname,param_00,param_01,param_02,param_03,var_04.scorepopup,var_04.var_52DA);
	if(var_05 && isdefined(var_04.var_C4F3))
	{
		self [[ var_04.var_C4F3 ]](self.streakname,param_00,self.triggerportableradarping,param_02);
	}
}

//Function Number: 15
handledeath(param_00)
{
	self endon("carried");
	self waittill("death");
	var_01 = level.placeableconfigs[param_00];
	if(isdefined(self))
	{
		deactivate(param_00);
		if(isdefined(var_01.modeldestroyed))
		{
			self setmodel(var_01.modeldestroyed);
		}

		if(isdefined(var_01.ondeathdelegate))
		{
			self [[ var_01.ondeathdelegate ]](param_00);
		}

		self delete();
	}
}

//Function Number: 16
oncarrierdeath(param_00,param_01)
{
	self endon("placed");
	self endon("death");
	param_01 endon("disconnect");
	param_01 waittill("death");
	if(self.canbeplaced)
	{
		thread onplaced(param_00);
		return;
	}

	oncancel(param_00);
}

//Function Number: 17
func_C547(param_00)
{
	self endon("death");
	level endon("game_ended");
	self.triggerportableradarping waittill("killstreak_disowned");
	cleanup(param_00);
}

//Function Number: 18
ongameended(param_00)
{
	self endon("death");
	level waittill("game_ended");
	cleanup(param_00);
}

//Function Number: 19
cleanup(param_00)
{
	if(isdefined(self.isplaced))
	{
		self notify("death");
		return;
	}

	oncancel(param_00);
}

//Function Number: 20
watchplayerconnected()
{
	self endon("death");
	for(;;)
	{
		level waittill("connected",var_00);
		thread onplayerconnected(var_00);
	}
}

//Function Number: 21
onplayerconnected(param_00)
{
	self endon("death");
	param_00 endon("disconnect");
	param_00 waittill("spawned_player");
	self disableplayeruse(param_00);
}

//Function Number: 22
timeout(param_00)
{
	self endon("death");
	level endon("game_ended");
	var_01 = level.placeableconfigs[param_00];
	var_02 = var_01.lifespan;
	while(var_02 > 0)
	{
		wait(1);
		scripts\mp\_hostmigration::waittillhostmigrationdone();
		if(!isdefined(self.carriedby))
		{
			var_02 = var_02 - 1;
		}
	}

	if(isdefined(self.triggerportableradarping) && isdefined(var_01.gonevo))
	{
		self.triggerportableradarping thread scripts\mp\_utility::leaderdialogonplayer(var_01.gonevo);
	}

	self notify("death");
}

//Function Number: 23
removeweapons()
{
	if(self hasweapon("iw6_riotshield_mp"))
	{
		self.restoreweapon = "iw6_riotshield_mp";
		scripts\mp\_utility::_takeweapon("iw6_riotshield_mp");
	}
}

//Function Number: 24
removeperks()
{
	if(scripts\mp\_utility::_hasperk("specialty_explosivebullets"))
	{
		self.restoreperk = "specialty_explosivebullets";
		scripts\mp\_utility::removeperk("specialty_explosivebullets");
	}
}

//Function Number: 25
restoreweapons()
{
	if(isdefined(self.restoreweapon))
	{
		scripts\mp\_utility::_giveweapon(self.restoreweapon);
		self.restoreweapon = undefined;
	}
}

//Function Number: 26
restoreperks()
{
	if(isdefined(self.restoreperk))
	{
		scripts\mp\_utility::giveperk(self.restoreperk);
		self.restoreperk = undefined;
	}
}

//Function Number: 27
createbombsquadmodel(param_00)
{
	var_01 = level.placeableconfigs[param_00];
	if(isdefined(var_01.modelbombsquad))
	{
		var_02 = spawn("script_model",self.origin);
		var_02.angles = self.angles;
		var_02 hide();
		var_02 thread scripts\mp\_weapons::bombsquadvisibilityupdater(self.triggerportableradarping);
		var_02 setmodel(var_01.modelbombsquad);
		var_02 linkto(self);
		var_02 setcontents(0);
		self.bombsquadmodel = var_02;
		self waittill("death");
		if(isdefined(var_02))
		{
			var_02 delete();
			self.bombsquadmodel = undefined;
		}
	}
}

//Function Number: 28
showplacedmodel(param_00)
{
	self show();
	if(isdefined(self.bombsquadmodel))
	{
		self.bombsquadmodel show();
		level notify("update_bombsquad");
	}
}

//Function Number: 29
hideplacedmodel(param_00)
{
	self hide();
	if(isdefined(self.bombsquadmodel))
	{
		self.bombsquadmodel hide();
	}
}

//Function Number: 30
createcarriedobject(param_00)
{
	if(isdefined(self.iscarrying) && self.iscarrying)
	{
		return;
	}

	var_01 = spawnturret("misc_turret",self.origin + (0,0,25),"sentry_minigun_mp");
	var_01.angles = self.angles;
	var_01.triggerportableradarping = self;
	var_02 = level.placeableconfigs[param_00];
	var_01 setmodel(var_02.modelbase);
	var_01 getvalidattachments();
	var_01 setturretmodechangewait(1);
	var_01 give_player_session_tokens("sentry_offline");
	var_01 makeunusable();
	var_01 setsentryowner(self);
	var_01 setsentrycarrier(self);
	var_01 setcandamage(0);
	var_01 setcontents(0);
	return var_01;
}