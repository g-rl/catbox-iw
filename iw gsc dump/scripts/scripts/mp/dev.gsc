/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\dev.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 26
 * Decompile Time: 1343 ms
 * Timestamp: 10/27/2023 12:15:08 AM
*******************************************************************/

//Function Number: 1
init()
{
}

//Function Number: 2
func_1014E(param_00,param_01,param_02,param_03,param_04,param_05)
{
}

//Function Number: 3
func_12F00()
{
}

//Function Number: 4
func_DE5E()
{
}

//Function Number: 5
reflectionprobe_hide_hp()
{
}

//Function Number: 6
reflectionprobe_hide_front()
{
}

//Function Number: 7
_meth_8470()
{
}

//Function Number: 8
allowmantle()
{
}

//Function Number: 9
devaliengiveplayersmoney()
{
}

//Function Number: 10
spam_points_popup()
{
	var_00 = ["headshot","avenger","longshot","posthumous","double","triple","multi"];
	for(var_01 = 0;var_01 < var_00.size;var_01++)
	{
		thread scripts\mp\rank::scorepointspopup(100);
		thread scripts\mp\rank::scoreeventpopup(var_00[var_01]);
		wait(2);
	}
}

//Function Number: 11
func_A5AC()
{
	for(;;)
	{
		if(getdvarint("scr_dropAllies") > 0)
		{
			break;
		}

		wait(1);
	}

	var_00 = undefined;
	foreach(var_02 in level.characters)
	{
		if(isplayer(var_02) && !isbot(var_02))
		{
			var_00 = var_02;
			break;
		}
	}

	if(!isdefined(var_00))
	{
		return;
	}

	foreach(var_02 in level.characters)
	{
		if(level.teambased)
		{
			if(var_02.team == var_00.team)
			{
				kick(var_02 getentitynumber());
			}

			continue;
		}

		return;
	}
}

//Function Number: 12
func_53EE()
{
	level.var_D788 = getdvarint("scr_power_short_cooldown",0);
	for(;;)
	{
		var_00 = getdvarint("scr_power_short_cooldown",0);
		if(var_00 != level.var_D788)
		{
			level.var_D788 = var_00;
			foreach(var_02 in level.players)
			{
				if(isbot(var_02))
				{
					continue;
				}

				var_03 = var_02 scripts\mp\powers::getcurrentequipment("primary");
				if(isdefined(var_03))
				{
					func_53E4(var_03,"primary");
				}

				var_03 = var_02 scripts\mp\powers::getcurrentequipment("secondary");
				if(isdefined(var_03))
				{
					func_53E4(var_03,"secondary");
				}
			}
		}

		wait(0.25);
	}
}

//Function Number: 13
func_53ED()
{
	level.var_D7A3 = getdvarint("scr_power_use_cooldown",-1);
	for(;;)
	{
		var_00 = getdvarint("scr_power_use_cooldown",-1);
		if(var_00 != level.var_D7A3)
		{
			level.var_D7A3 = var_00;
			foreach(var_02 in level.players)
			{
				if(isbot(var_02))
				{
					continue;
				}

				var_03 = var_02 scripts\mp\powers::getcurrentequipment("primary");
				if(isdefined(var_03))
				{
					func_53E4(var_03,"primary");
				}

				var_03 = var_02 scripts\mp\powers::getcurrentequipment("secondary");
				if(isdefined(var_03))
				{
					func_53E4(var_03,"secondary");
				}
			}
		}

		wait(0.25);
	}
}

//Function Number: 14
func_53EC()
{
	level.var_D777 = getdvarint("scr_power_extra_charge",0);
	for(;;)
	{
		var_00 = getdvarint("scr_power_extra_charge",0);
		if(var_00 != level.var_D777)
		{
			level.var_D777 = var_00;
			foreach(var_02 in level.players)
			{
				if(isbot(var_02))
				{
					continue;
				}

				var_03 = var_02 scripts\mp\powers::getcurrentequipment("primary");
				if(isdefined(var_03))
				{
					func_53E4(var_03,"primary");
				}

				var_03 = var_02 scripts\mp\powers::getcurrentequipment("secondary");
				if(isdefined(var_03))
				{
					func_53E4(var_03,"secondary");
				}
			}
		}

		wait(0.25);
	}
}

//Function Number: 15
func_53E5()
{
	for(;;)
	{
		var_00 = getdvar("scr_givepowerprimary","");
		if(var_00 != "")
		{
			func_53E4(var_00,"primary");
		}

		var_00 = getdvar("scr_givepowersecondary","");
		if(var_00 != "")
		{
			func_53E4(var_00,"secondary");
		}

		wait(0.25);
	}
}

//Function Number: 16
func_53E4(param_00,param_01)
{
	foreach(var_03 in level.players)
	{
		if(isbot(var_03))
		{
			continue;
		}

		var_04 = var_03 scripts\mp\powers::getcurrentequipment(param_01);
		if(isdefined(var_04))
		{
			var_03 scripts\mp\powers::removepower(var_04);
		}

		var_03 scripts\mp\powers::givepower(param_00,param_01,0);
	}
}

//Function Number: 17
devlistinventory()
{
	var_00 = getdvar("scr_list_inventory","");
	if(var_00 != "")
	{
		var_01 = devfindhost();
		if(!isdefined(var_01))
		{
			return;
		}

		var_02 = undefined;
		var_03 = undefined;
		var_04 = 0;
		if(var_00 == "all")
		{
			var_03 = "all weapons";
			var_02 = var_01 getweaponslistall();
		}
		else if(var_00 == "primaryCurrent")
		{
			var_03 = "current weapon";
			var_04 = 1;
			var_02 = [var_01 getcurrentweapon()];
		}
		else
		{
			var_03 = var_00 + " inventory";
			var_02 = var_01 getweaponslist(var_00);
		}

		var_01 devprintweaponlist(var_02,var_03,var_04);
	}
}

//Function Number: 18
devprintweaponlist(param_00,param_01,param_02)
{
	if(isdefined(param_00) && param_00.size > 0)
	{
		foreach(var_04 in param_00)
		{
			var_05 = self getweaponammoclip(var_04);
			var_06 = self getweaponammostock(var_04);
			var_07 = "  " + var_04 + " " + var_05 + "/" + var_06;
			if(param_02)
			{
				iprintlnbold(var_07);
			}
		}
	}
	else
	{
	}
}

//Function Number: 19
func_53E6()
{
	var_00 = getdvarint("scr_super_short_cooldown",0);
	for(;;)
	{
		var_01 = getdvar("scr_givesuper","");
		if(var_01 != "")
		{
			var_02 = devfindhost();
			var_02 scripts\mp\supers::stopridingvehicle(var_01);
		}

		if(getdvarint("scr_super_short_cooldown",0) != 0)
		{
			if(!var_00)
			{
				var_00 = 1;
				foreach(var_04 in level.players)
				{
					if(isbot(var_04))
					{
						continue;
					}

					if(var_04 scripts\mp\supers::issupercharging())
					{
						var_04 scripts\mp\supers::func_E276();
					}
				}
			}
		}
		else if(var_00)
		{
			var_00 = 0;
			foreach(var_04 in level.players)
			{
				if(isbot(var_04))
				{
					continue;
				}

				if(var_04 scripts\mp\supers::issupercharging())
				{
					var_04 scripts\mp\supers::func_E276();
				}
			}
		}

		wait(0.25);
	}
}

//Function Number: 20
devfindhost()
{
	var_00 = undefined;
	foreach(var_02 in level.players)
	{
		if(var_02 ishost())
		{
			var_00 = var_02;
			break;
		}
	}

	return var_00;
}

//Function Number: 21
func_53F0()
{
	var_00 = getdvar("scr_debug_streak_passive","none");
	for(;;)
	{
		var_01 = getdvar("scr_debug_streak_passive","none");
		if(var_00 != var_01)
		{
			iprintlnbold("All Killstreaks from the DevGui will have " + var_01);
			var_00 = var_01;
		}

		wait(1);
	}
}

//Function Number: 22
watchlethaldelaycancel()
{
	for(;;)
	{
		if(getdvarint("scr_lethalDelayCancel",0))
		{
			scripts\mp\weapons::cancellethaldelay();
			return;
		}

		wait(1);
	}
}

//Function Number: 23
watchsuperdelaycancel()
{
	for(;;)
	{
		if(getdvarint("scr_superDelayCancel",0))
		{
			scripts\mp\supers::cancelsuperdelay();
			return;
		}

		wait(1);
	}
}

//Function Number: 24
watchslowmo()
{
	for(;;)
	{
		if(getdvar("scr_slowmo") != "")
		{
			break;
		}

		wait(1);
	}

	var_00 = getdvarfloat("scr_slowmo");
	setslowmotion(var_00,var_00,0);
	thread watchslowmo();
}

//Function Number: 25
func_53E2()
{
	for(;;)
	{
		if(getdvar("scr_jt_devbroshot") != "")
		{
			iprintlnbold(" BRO ");
			level.doingbroshot = scripts\mp\broshot::initbroshot();
			if(level.doingbroshot)
			{
				setomnvarforallclients("post_game_state",6);
				wait(0.1);
				scripts\mp\broshot::func_10D73();
			}
		}

		if(getdvarint("scr_debug_start_broshot"))
		{
			iprintlnbold("Test Broshot");
			level.doingbroshot = scripts\mp\broshot::forceinitbroshot();
			if(level.doingbroshot)
			{
				setomnvarforallclients("post_game_state",6);
				wait(0.1);
				level.players[0] scripts\mp\broshot::func_10D73();
			}
		}

		if(getdvarint("scr_debug_change_rig_broshot"))
		{
			scripts\mp\broshot::changetestrig(getdvarint("scr_debug_change_rig_broshot"),1);
			iprintlnbold("Test Rig" + getdvarint("scr_debug_change_rig_broshot"));
		}

		if(getdvarint("scr_debug_assign_taunt_broshot"))
		{
			scripts\mp\broshot::changetesttaunt(getdvarint("scr_debug_assign_taunt_broshot"));
			iprintlnbold("Test Taunt" + getdvarint("scr_debug_assign_taunt_broshot"));
		}

		if(getdvarint("scr_debug_change_slot_broshot"))
		{
			scripts\mp\broshot::changetestslot(getdvarint("scr_debug_change_slot_broshot"));
			iprintlnbold("Test Slot Change" + getdvarint("scr_debug_change_slot_broshot"));
		}

		wait(0.05);
	}
}

//Function Number: 26
rangefinder()
{
	thread scripts\mp\rangefinder::runmprangefinder();
}