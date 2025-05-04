/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 3549.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 18
 * Decompile Time: 4 ms
 * Timestamp: 10/27/2023 12:30:39 AM
*******************************************************************/

//Function Number: 1
c4_set(param_00)
{
	thread c4_watchforaltdetonation();
}

//Function Number: 2
c4_used(param_00)
{
	self endon("disconnect");
	param_00 endon("death");
	scripts\mp\_utility::printgameaction("c4 spawn",param_00.triggerportableradarping);
	param_00.throwtime = gettime();
	c4_addtoarray(param_00);
	thread c4_watchfordetonation();
	thread c4_watchforaltdetonation();
	if(scripts\mp\_utility::_hasperk("specialty_rugged_eqp"))
	{
		param_00.hasruggedeqp = 1;
	}

	param_00 thread scripts\mp\_weapons::minedamagemonitor();
	param_00 thread c4_explodeonnotify();
	param_00 thread c4_destroyongameend();
	thread scripts\mp\_weapons::monitordisownedgrenade(self,param_00);
	param_00 waittill("missile_stuck");
	param_00 setotherent(self);
	param_00 give_player_tickets(1);
	scripts\mp\_weapons::onlethalequipmentplanted(param_00,"power_c4");
	thread scripts\mp\_weapons::monitordisownedequipment(self,param_00);
	param_00 thread scripts\mp\_weapons::makeexplosiveusabletag("tag_use",1);
	param_00 scripts\mp\sentientpoolmanager::registersentient("Lethal_Static",param_00.triggerportableradarping,1);
	param_00 thread c4_destroyonemp();
	param_00 thread scripts\mp\perks\_perk_equipmentping::runequipmentping();
	param_00 setscriptablepartstate("plant","active",0);
	thread scripts\mp\_weapons::outlineequipmentforowner(param_00,self);
	param_00 missilethermal();
	param_00 missileoutline();
	param_00 thread scripts\mp\_entityheadicons::setheadicon_factionimage(self,(0,0,20),0.1);
}

//Function Number: 3
c4_detonate()
{
	self endon("death");
	self.triggerportableradarping endon("disconnect");
	wait(0.1);
	thread c4_explode(self.triggerportableradarping);
}

//Function Number: 4
c4_explode(param_00)
{
	scripts\mp\_utility::printgameaction("c4 triggered",self.triggerportableradarping);
	thread c4_delete(0.1);
	self setentityowner(param_00);
	self _meth_8593();
	self setscriptablepartstate("plant","neutral",0);
	self setscriptablepartstate("explode","active",0);
}

//Function Number: 5
c4_destroy(param_00)
{
	thread c4_delete(0.1);
	self setscriptablepartstate("plant","neutral",0);
	self setscriptablepartstate("destroy","active",0);
}

//Function Number: 6
c4_delete(param_00)
{
	self notify("death");
	level.mines[self getentitynumber()] = undefined;
	self setcandamage(0);
	scripts\mp\_weapons::makeexplosiveunusuabletag();
	self.exploding = 1;
	var_01 = self.triggerportableradarping;
	if(isdefined(self.triggerportableradarping))
	{
		var_01.plantedlethalequip = scripts\engine\utility::array_remove(var_01.plantedlethalequip,self);
		var_01 notify("c4_update",0);
	}

	wait(param_00);
	self delete();
}

//Function Number: 7
c4_explodeonnotify()
{
	self endon("death");
	self.triggerportableradarping endon("disconnect");
	level endon("game_ended");
	var_00 = self.triggerportableradarping;
	self waittill("detonateExplosive",var_01);
	if(isdefined(var_01))
	{
		thread c4_explode(var_01);
		return;
	}

	thread c4_explode(var_00);
}

//Function Number: 8
c4_destroyonemp()
{
	self endon("death");
	self.triggerportableradarping endon("disconnect");
	self waittill("emp_damage",var_00,var_01,var_02,var_03,var_04);
	if(isdefined(var_03) && var_03 == "emp_grenade_mp")
	{
		if(scripts\mp\_utility::istrue(scripts\mp\_utility::playersareenemies(self.triggerportableradarping,var_00)))
		{
			var_00 scripts\mp\_missions::func_D991("ch_tactical_emp_eqp");
		}
	}

	if(scripts\mp\_utility::istrue(scripts\mp\_utility::playersareenemies(self.triggerportableradarping,var_00)))
	{
		var_00 notify("destroyed_equipment");
		var_00 scripts\mp\killstreaks\_killstreaks::_meth_83A0();
	}

	var_05 = "";
	if(scripts\mp\_utility::istrue(self.hasruggedeqp))
	{
		var_05 = "hitequip";
	}

	if(isplayer(var_00))
	{
		var_00 scripts\mp\_damagefeedback::updatedamagefeedback(var_05);
	}

	thread c4_destroy();
}

//Function Number: 9
c4_destroyongameend()
{
	self endon("death");
	level scripts\engine\utility::waittill_any_3("game_ended","bro_shot_start");
	thread c4_destroy();
}

//Function Number: 10
c4_validdetonationstate()
{
	if(!scripts\mp\_utility::isreallyalive(self))
	{
		return 0;
	}

	if(scripts\mp\_utility::isusingremote())
	{
		return 0;
	}

	if(scripts/mp/equipment/phase_shift::isentityphaseshifted(self))
	{
		return 0;
	}

	if(scripts/mp/supers/super_reaper::isusingreaper())
	{
		return 0;
	}

	if(self _meth_84CA())
	{
		return 0;
	}

	if(self _meth_8568())
	{
		return 0;
	}

	return 1;
}

//Function Number: 11
c4_candetonate()
{
	return gettime() - self.throwtime / 1000 > 0.3;
}

//Function Number: 12
c4_watchfordetonation()
{
	self endon("death");
	self endon("disconnect");
	self endon("c4_unset");
	level endon("game_ended");
	self notify("watchForDetonation");
	self endon("watchForDetonation");
	for(;;)
	{
		self waittill("detonate");
		thread c4_detonateall();
	}
}

//Function Number: 13
c4_watchforaltdetonation()
{
	self endon("death");
	self endon("disconnect");
	self endon("c4_unset");
	level endon("game_ended");
	self notify("watchForAltDetonation");
	self endon("watchForAltDetonation");
	while(self usebuttonpressed())
	{
		scripts\engine\utility::waitframe();
	}

	var_00 = 0;
	for(;;)
	{
		if(self usebuttonpressed())
		{
			var_00 = 0;
			while(self usebuttonpressed())
			{
				var_00 = var_00 + 0.05;
				wait(0.05);
			}

			if(var_00 >= 0.5)
			{
				continue;
			}

			var_00 = 0;
			while(!self usebuttonpressed() && var_00 < 0.25)
			{
				var_00 = var_00 + 0.05;
				wait(0.05);
			}

			if(var_00 >= 0.25)
			{
				continue;
			}

			if(c4_validdetonationstate())
			{
				thread c4_detonateall();
			}
		}

		wait(0.05);
	}
}

//Function Number: 14
c4_detonateall()
{
	if(isdefined(self.c4s))
	{
		foreach(var_01 in self.c4s)
		{
			if(var_01 c4_candetonate())
			{
				var_01 thread c4_detonate();
			}
		}
	}
}

//Function Number: 15
c4_resetaltdetonpickup()
{
	if(scripts\mp\_powers::hasequipment("power_c4"))
	{
		thread c4_watchforaltdetonation();
	}
}

//Function Number: 16
c4_addtoarray(param_00)
{
	var_01 = self.triggerportableradarping;
	if(!isdefined(self.c4s))
	{
		self.c4s = [];
	}

	self.c4s[param_00 getentitynumber()] = param_00;
	thread c4_removefromarrayondeath(param_00);
}

//Function Number: 17
c4_removefromarray(param_00)
{
	if(!isdefined(self.c4s))
	{
		return;
	}

	self.c4s[param_00] = undefined;
}

//Function Number: 18
c4_removefromarrayondeath(param_00)
{
	self endon("disconnect");
	var_01 = param_00 getentitynumber();
	param_00 waittill("death");
	c4_removefromarray(var_01);
}