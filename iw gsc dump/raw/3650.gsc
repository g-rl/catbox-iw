/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 3650.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 20
 * Decompile Time: 12 ms
 * Timestamp: 10/27/2023 12:30:59 AM
*******************************************************************/

//Function Number: 1
init()
{
	level.perksetfuncs = [];
	level.perkunsetfuncs = [];
	level.player.perks = [];
	level.player.perksblocked = [];
	level.var_12F75 = [];
	level.var_12F79 = [];
	level.scriptperks = [];
	level.scriptperks["specialty_steadyaim"] = 1;
	level.scriptperks["specialty_quickswap"] = 1;
	level.scriptperks["specialty_quickdraw"] = 1;
	level.scriptperks["specialty_focus"] = 1;
	level.scriptperks["specialty_fastreload"] = 1;
	level.scriptperks["specialty_agility"] = 1;
	level.scriptperks["specialty_extraequipment"] = 1;
	level.scriptperks["specialty_blastshield"] = 1;
	level.scriptperks["specialty_fastregen"] = 1;
	level.scriptperks["specialty_slasher"] = 1;
	level.scriptperks["specialty_shocker"] = 1;
	level.scriptperks["upgrade_frag_1"] = 1;
	level.scriptperks["upgrade_frag_2"] = 1;
	level.scriptperks["upgrade_shock_1"] = 1;
	level.scriptperks["upgrade_shock_2"] = 1;
	level.scriptperks["upgrade_antigrav_1"] = 1;
	level.scriptperks["upgrade_antigrav_2"] = 1;
	level.scriptperks["upgrade_seeker_1"] = 1;
	level.scriptperks["upgrade_seeker_2"] = 1;
	level.scriptperks["upgrade_hack_1"] = 1;
	level.scriptperks["upgrade_shield_1"] = 1;
	level.scriptperks["upgrade_drone_1"] = 1;
	level.scriptperks["upgrade_cover_1"] = 1;
	level.perksetfuncs["specialty_fastreload"] = ::lib_0E41::func_F701;
	level.perkunsetfuncs["specialty_fastreload"] = ::lib_0E41::func_12CBC;
	level.perksetfuncs["specialty_steadyaim"] = ::lib_0E41::setstaticuicircles;
	level.perkunsetfuncs["specialty_steadyaim"] = ::lib_0E41::unsetspotter;
	level.perksetfuncs["specialty_quickswap"] = ::lib_0E41::setquickswap;
	level.perkunsetfuncs["specialty_quickswap"] = ::lib_0E41::unsetquickswap;
	level.perksetfuncs["specialty_focus"] = ::lib_0E41::func_F712;
	level.perkunsetfuncs["specialty_focus"] = ::lib_0E41::func_12CBE;
	level.perksetfuncs["specialty_quickdraw"] = ::lib_0E41::func_F80F;
	level.perkunsetfuncs["specialty_quickdraw"] = ::lib_0E41::func_12D12;
	level.perksetfuncs["specialty_agility"] = ::lib_0E41::func_F636;
	level.perkunsetfuncs["specialty_agility"] = ::lib_0E41::func_12C6F;
	level.perksetfuncs["specialty_extraequipment"] = ::lib_0E41::setextraequipment;
	level.perkunsetfuncs["specialty_extraequipment"] = ::lib_0E41::unsetextraequipment;
	level.perksetfuncs["specialty_blastshield"] = ::lib_0E41::setblastshield;
	level.perkunsetfuncs["specialty_blastshield"] = ::lib_0E41::unsetblastshield;
	level.perksetfuncs["specialty_fastregen"] = ::lib_0E41::func_F700;
	level.perkunsetfuncs["specialty_fastregen"] = ::lib_0E41::func_12CBB;
	level.perksetfuncs["specialty_slasher"] = ::lib_0E41::func_F849;
	level.var_12F75["specialty_slasher"] = "specialty_shocker";
	level.perkunsetfuncs["specialty_slasher"] = ::lib_0E41::func_12D2F;
	level.perksetfuncs["specialty_shocker"] = ::lib_0E41::func_F83E;
	level.var_12F75["specialty_shocker"] = "specialty_slasher";
	level.perkunsetfuncs["specialty_shocker"] = ::lib_0E41::func_12D2A;
	level.perksetfuncs["upgrade_frag_1"] = ::lib_0E41::func_FAB8;
	level.perkunsetfuncs["upgrade_frag_1"] = ::lib_0E41::func_12D5A;
	level.var_12F79[level.var_12F79.size] = "upgrade_frag_1";
	level.perksetfuncs["upgrade_frag_2"] = ::lib_0E41::func_FAB9;
	level.perkunsetfuncs["upgrade_frag_2"] = ::lib_0E41::func_12D5B;
	level.var_12F75["upgrade_frag_2"] = "upgrade_frag_1";
	level.var_12F79[level.var_12F79.size] = "upgrade_frag_2";
	level.perksetfuncs["upgrade_shock_1"] = ::lib_0E41::func_FAC0;
	level.perkunsetfuncs["upgrade_shock_1"] = ::lib_0E41::func_12D62;
	level.var_12F79[level.var_12F79.size] = "upgrade_shock_1";
	level.perksetfuncs["upgrade_shock_2"] = ::lib_0E41::func_FAC1;
	level.perkunsetfuncs["upgrade_shock_2"] = ::lib_0E41::func_12D63;
	level.var_12F75["upgrade_shock_2"] = "upgrade_shock_1";
	level.var_12F79[level.var_12F79.size] = "upgrade_shock_2";
	level.perksetfuncs["upgrade_antigrav_1"] = ::lib_0E41::func_FAB2;
	level.perkunsetfuncs["upgrade_antigrav_1"] = ::lib_0E41::func_12D54;
	level.var_12F79[level.var_12F79.size] = "upgrade_antigrav_1";
	level.perksetfuncs["upgrade_antigrav_2"] = ::lib_0E41::func_FAB3;
	level.perkunsetfuncs["upgrade_antigrav_2"] = ::lib_0E41::func_12D55;
	level.var_12F75["upgrade_antigrav_2"] = "upgrade_antigrav_1";
	level.var_12F79[level.var_12F79.size] = "upgrade_antigrav_2";
	level.perksetfuncs["upgrade_seeker_1"] = ::lib_0E41::func_FABC;
	level.perkunsetfuncs["upgrade_seeker_1"] = ::lib_0E41::func_12D5E;
	level.var_12F79[level.var_12F79.size] = "upgrade_seeker_1";
	level.perksetfuncs["upgrade_seeker_2"] = ::lib_0E41::func_FABD;
	level.perkunsetfuncs["upgrade_seeker_2"] = ::lib_0E41::func_12D5F;
	level.var_12F75["upgrade_seeker_2"] = "upgrade_seeker_1";
	level.var_12F79[level.var_12F79.size] = "upgrade_seeker_2";
	level.perksetfuncs["upgrade_hack_1"] = ::lib_0E41::func_FABA;
	level.perkunsetfuncs["upgrade_hack_1"] = ::lib_0E41::func_12D5C;
	level.var_12F79[level.var_12F79.size] = "upgrade_hack_1";
	level.perksetfuncs["upgrade_shield_1"] = ::lib_0E41::func_FABE;
	level.perkunsetfuncs["upgrade_shield_1"] = ::lib_0E41::func_12D60;
	level.var_12F79[level.var_12F79.size] = "upgrade_shield_1";
	level.perksetfuncs["upgrade_drone_1"] = ::lib_0E41::func_FAB6;
	level.perkunsetfuncs["upgrade_drone_1"] = ::lib_0E41::func_12D58;
	level.var_12F79[level.var_12F79.size] = "upgrade_drone_1";
	level.perksetfuncs["upgrade_cover_1"] = ::lib_0E41::func_FAB4;
	level.perkunsetfuncs["upgrade_cover_1"] = ::lib_0E41::func_12D56;
	level.var_12F79[level.var_12F79.size] = "upgrade_cover_1";
	func_98B0();
}

//Function Number: 2
func_98B0()
{
}

//Function Number: 3
giveperks(param_00)
{
	foreach(var_02 in param_00)
	{
		giveperk(var_02);
	}
}

//Function Number: 4
giveperk(param_00)
{
	_setperk(param_00);
}

//Function Number: 5
removeperk(param_00)
{
	_unsetperk(param_00);
}

//Function Number: 6
takeallweapons(param_00)
{
	foreach(var_02 in param_00)
	{
		switchtoweaponimmediate(var_02);
	}
}

//Function Number: 7
switchtoweaponimmediate(param_00)
{
	if(isdefined(level.var_12F75[param_00]))
	{
		var_01 = level.var_12F75[param_00];
		while(_hasperk(var_01))
		{
			_unsetperk(var_01);
		}
	}

	_setperk(param_00);
}

//Function Number: 8
func_E187(param_00)
{
	_unsetperk(param_00);
}

//Function Number: 9
_setperk(param_00)
{
	if(!isdefined(self.perks[param_00]))
	{
		self.perks[param_00] = 1;
	}
	else
	{
		self.perks[param_00]++;
	}

	if(self.perks[param_00] == 1 && !isdefined(self.perksblocked[param_00]))
	{
		func_13D2(param_00);
	}
}

//Function Number: 10
func_13D2(param_00)
{
	var_01 = level.perksetfuncs[param_00];
	if(isdefined(var_01))
	{
		self thread [[ var_01 ]]();
	}

	self setperk(param_00,!isdefined(level.scriptperks[param_00]));
}

//Function Number: 11
_unsetperk(param_00)
{
	if(!isdefined(self.perks[param_00]))
	{
		return;
	}

	self.perks[param_00]--;
	if(self.perks[param_00] == 0)
	{
		if(!isdefined(self.perksblocked[param_00]))
		{
			func_1431(param_00);
		}

		self.perks[param_00] = undefined;
	}
}

//Function Number: 12
func_1431(param_00)
{
	if(isdefined(level.perkunsetfuncs[param_00]))
	{
		self thread [[ level.perkunsetfuncs[param_00] ]]();
	}
}

//Function Number: 13
_hasperk(param_00)
{
	return isdefined(self.perks) && isdefined(self.perks[param_00]);
}

//Function Number: 14
_clearperks()
{
	foreach(var_02, var_01 in self.perks)
	{
		if(func_12F9(var_02))
		{
			continue;
		}

		if(isdefined(level.perkunsetfuncs[var_02]))
		{
			self [[ level.perkunsetfuncs[var_02] ]]();
		}

		self.perks[var_02] = undefined;
	}

	self.perksblocked = [];
}

//Function Number: 15
func_11AB()
{
	foreach(var_02, var_01 in self.perks)
	{
		if(!func_12F9(var_02))
		{
			continue;
		}

		if(isdefined(level.perkunsetfuncs[var_02]))
		{
			self [[ level.perkunsetfuncs[var_02] ]]();
		}

		self.perks[var_02] = undefined;
	}

	self.perksblocked = [];
}

//Function Number: 16
func_12F9(param_00)
{
	if(scripts\engine\utility::array_contains(level.var_12F79,param_00))
	{
		return 1;
	}

	return 0;
}

//Function Number: 17
cameraunlink(param_00)
{
	return tablelookup("sp/perkTable.csv",1,param_00,3);
}

//Function Number: 18
cancelmantle(param_00)
{
	return tablelookupistring("sp/perkTable.csv",1,param_00,2);
}

//Function Number: 19
blockperkfunction(param_00)
{
	if(!isdefined(self.perksblocked[param_00]))
	{
		self.perksblocked[param_00] = 1;
	}
	else
	{
		self.perksblocked[param_00]++;
	}

	if(self.perksblocked[param_00] == 1 && _hasperk(param_00))
	{
		func_1431(param_00);
	}
}

//Function Number: 20
unblockperkfunction(param_00)
{
	self.perksblocked[param_00]--;
	if(self.perksblocked[param_00] == 0)
	{
		self.perksblocked[param_00] = undefined;
		if(_hasperk(param_00))
		{
			func_13D2(param_00);
		}
	}
}