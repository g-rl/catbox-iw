/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 3582.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 15
 * Decompile Time: 8 ms
 * Timestamp: 10/27/2023 12:30:48 AM
*******************************************************************/

//Function Number: 1
setrewind()
{
	thread func_13A62();
}

//Function Number: 2
unsetrewind(param_00)
{
	self notify("rewindUnset");
	if(!scripts\mp\_utility::istrue(param_00) && !scripts\mp\_utility::istrue(level.broshotrunning))
	{
		self setscriptablepartstate("jet_pack","neutral",0);
		self setscriptablepartstate("teamColorPins","teamColorPins",0);
	}

	if(self.loadoutarchetype == "archetype_scout")
	{
		self setscriptablepartstate("rewindIdle","neutral",0);
	}

	thread func_E163();
}

//Function Number: 3
func_10DEB()
{
	level thread scripts\mp\_battlechatter_mp::saytoself(self,"plr_perk_rewind",undefined,0.75);
	if(self.health < self.maxhealth)
	{
		scripts\mp\_missions::func_D991("ch_scout_damaged_rewind");
	}

	self.isrewinding = 1;
	self getweaponrankxpmultiplier();
	self setscriptablepartstate("jet_pack","off",0);
	self setscriptablepartstate("teamColorPins","off",0);
	self setscriptablepartstate("rewindStartFlash","active",0);
	self setscriptablepartstate("rewindIdle","active",0);
	self motionblurhqenable();
	applytempeffects();
}

//Function Number: 4
func_637E(param_00)
{
	func_E4D5();
	func_E4C7();
	self setscriptablepartstate("rewindIdle","neutral",0);
	if(!scripts\mp\_utility::istrue(level.broshotrunning))
	{
		self gold_teeth_pickup();
		if(!scripts\mp\_utility::istrue(param_00))
		{
			self setscriptablepartstate("jet_pack","neutral",0);
			self setscriptablepartstate("teamColorPins","teamColorPins",0);
			self setscriptablepartstate("rewindEndFlash","active",0);
		}
	}

	thread func_E163();
}

//Function Number: 5
func_E163()
{
	self.isrewinding = undefined;
	self motionblurhqdisable();
	removetempeffects();
}

//Function Number: 6
func_13A62()
{
	self endon("disconnect");
	self endon("rewindUnset");
	self notify("watchForRewind");
	self endon("watchForRewind");
	for(;;)
	{
		var_00 = spawnstruct();
		childthread func_13A66(var_00);
		childthread func_13A64(var_00);
		childthread func_13A63(var_00);
		childthread func_13A65(var_00);
		self waittill("rewindBeginRace");
		waittillframeend;
		if(isdefined(var_00.var_6ACF))
		{
			if(isplayer(self))
			{
				scripts\mp\_hud_message::showerrormessage("MP_REWIND_FAILED");
			}

			scripts\mp\_supers::refundsuper();
		}
		else if(isdefined(var_00.var_10DE6) && isdefined(var_00.var_4E59))
		{
			scripts\mp\_supers::refundsuper();
		}
		else if(isdefined(var_00.var_637B))
		{
			self notify("rewind_success");
			func_637E();
		}
		else if(isdefined(var_00.var_10DE6))
		{
			self notify("rewind_success");
			func_10DEB();
		}

		self notify("rewindEndRace");
	}
}

//Function Number: 7
func_13A66(param_00)
{
	self endon("rewindEndRace");
	self waittill("rewindStart");
	param_00.var_10DE6 = 1;
	self notify("rewindBeginRace");
}

//Function Number: 8
func_13A64(param_00)
{
	self endon("rewindEndRace");
	self waittill("rewindEnd");
	param_00.var_637B = 1;
	self notify("rewindBeginRace");
}

//Function Number: 9
func_13A63(param_00)
{
	self endon("rewindEndRace");
	self waittill("death");
	param_00.var_4E59 = 1;
	self notify("rewindBeginRace");
}

//Function Number: 10
func_13A65(param_00)
{
	self endon("rewindEndRace");
	self waittill("rewindFailed");
	param_00.var_6ACF = 1;
	self notify("rewindBeginRace");
}

//Function Number: 11
func_E4D5()
{
	if(scripts\mp\_utility::isanymlgmatch())
	{
		self.health = int(min(self.maxhealth,self.health + 25));
		return;
	}

	var_00 = self.maxhealth - self.health;
	self.health = self.maxhealth;
}

//Function Number: 12
func_E4C7()
{
	var_00 = self getweaponslistprimaries();
	var_01 = [];
	foreach(var_03 in var_00)
	{
		var_04 = scripts\mp\_utility::getweapongroup(var_03);
		if(var_04 == "super" || var_04 == "weapon_mg" || var_04 == "killstreak" || var_04 == "gamemode" || var_04 == "other")
		{
			var_01[var_01.size] = var_03;
			continue;
		}

		if(scripts\mp\_weapons::isaxeweapon(var_03) || scripts\mp\_weapons::isknifeonly(var_03))
		{
			var_01[var_01.size] = var_03;
			continue;
		}

		if(getsubstr(var_03,0,7) == "deploy_")
		{
			var_01[var_01.size] = var_03;
			continue;
		}

		if(scripts\mp\_weapons::isaltmodeweapon(var_03))
		{
			var_05 = 0;
			var_06 = scripts\mp\_utility::getweaponattachmentsbasenames(var_03);
			foreach(var_08 in var_06)
			{
				if(getsubstr(var_08,0,2) == "gl")
				{
					var_05 = 1;
					break;
				}
			}

			if(var_05)
			{
				continue;
			}

			if(self _meth_8519(var_03,1))
			{
				var_03 = getsubstr(var_03,4,var_03.size);
			}

			var_01[var_01.size] = var_03;
			continue;
		}
	}

	var_01 = scripts\engine\utility::array_remove_duplicates(var_01);
	foreach(var_03 in var_01)
	{
		var_00 = scripts\engine\utility::array_remove(var_00,var_03);
	}

	foreach(var_03 in var_00)
	{
		var_0E = 0;
		if(scripts\mp\_utility::getweaponrootname(var_03) == "iw7_fmg")
		{
			var_0E = self _meth_8519(var_03,1);
		}
		else if(issubstr(var_03,"akimbo"))
		{
			var_0E = 1;
		}

		if(var_0E)
		{
			var_0F = self getweaponammoclip(var_03,"left") + self getweaponammoclip(var_03,"right") + self getweaponammostock(var_03);
			var_0F = int(max(var_0F,function_024B(var_03)));
			var_10 = weaponclipsize(var_03);
			var_11 = int(max(0,var_0F - var_10 * 2));
			self setweaponammoclip(var_03,var_10,"left");
			self setweaponammoclip(var_03,var_10,"right");
			self setweaponammostock(var_03,var_11);
			continue;
		}

		var_0F = self getweaponammoclip(var_03) + self getweaponammostock(var_03);
		var_0F = int(max(var_0F,function_024B(var_03)));
		var_10 = weaponclipsize(var_03);
		var_11 = int(max(0,var_0F - var_10));
		self setweaponammoclip(var_03,var_10);
		self setweaponammostock(var_03,var_11);
	}
}

//Function Number: 13
applytempeffects()
{
	if(scripts\mp\_utility::istrue(self.rewind_appliedtempeffects))
	{
		return;
	}

	self.rewind_appliedtempeffects = 1;
	var_00 = self getcurrentweapon();
	if(var_00 == "briefcase_bomb_mp")
	{
		self takeweapon(var_00);
	}

	scripts\engine\utility::allow_weapon_switch(0);
	scripts\engine\utility::allow_usability(0);
	scripts\engine\utility::allow_ads(0);
	scripts\mp\_utility::giveperk("specialty_blindeye");
	scripts\mp\_utility::giveperk("specialty_spygame");
	scripts\mp\_utility::giveperk("specialty_coldblooded");
	scripts\mp\_utility::giveperk("specialty_noscopeoutline");
	scripts\mp\_utility::giveperk("specialty_no_target");
	thread applytempeffectscleanup();
}

//Function Number: 14
removetempeffects()
{
	if(!scripts\mp\_utility::istrue(self.rewind_appliedtempeffects))
	{
		return;
	}

	self.rewind_appliedtempeffects = undefined;
	scripts\engine\utility::allow_weapon_switch(1);
	scripts\engine\utility::allow_usability(1);
	scripts\engine\utility::allow_ads(1);
	scripts\mp\_utility::removeperk("specialty_blindeye");
	scripts\mp\_utility::removeperk("specialty_spygame");
	scripts\mp\_utility::removeperk("specialty_coldblooded");
	scripts\mp\_utility::removeperk("specialty_noscopeoutline");
	scripts\mp\_utility::removeperk("specialty_no_target");
}

//Function Number: 15
applytempeffectscleanup()
{
	self endon("disconnect");
	self endon("rewindUnset");
	self notify("applyTempEffectsCleanup");
	self endon("applyTempEffectsCleanup");
	self waittill("death");
	self.rewind_appliedtempeffects = undefined;
}