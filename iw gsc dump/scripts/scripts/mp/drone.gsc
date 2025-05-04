/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\drone_pet.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 8
 * Decompile Time: 423 ms
 * Timestamp: 10/27/2023 12:15:12 AM
*******************************************************************/

//Function Number: 1
init()
{
	thread func_13962();
	level.var_5CC0 = [];
	level.var_5CC0["ability_pet_1"] = spawnstruct();
	level.var_5CC0["ability_pet_1"].var_1088C = ::func_10610;
	level.var_5CC0["ability_pet_2"] = spawnstruct();
	level.var_5CC0["ability_pet_2"].var_1088C = ::func_10611;
	level.var_5CC0["ability_pet_3"] = spawnstruct();
	level.var_5CC0["ability_pet_3"].var_1088C = ::func_10612;
	level.var_5CC0["ability_pet_4"] = spawnstruct();
	level.var_5CC0["ability_pet_4"].var_1088C = ::func_10613;
}

//Function Number: 2
func_13962()
{
	for(;;)
	{
		level waittill("connected",var_00);
		var_00 thread func_D2FA();
	}
}

//Function Number: 3
func_D2FA()
{
	self endon("disconnect");
	for(;;)
	{
		if(getdvarint("scr_drone_pet_debug_spawn") != 0)
		{
			self waittill("spawned_player");
			var_00 = getdvarint("scr_drone_pet_debug_spawn");
			var_01 = "select_ability";
		}
		else
		{
			self waittill("luinotifyserver",var_01,var_00);
			if(var_01 != "select_ability")
			{
				continue;
			}
		}

		if(!scripts\mp\killstreaks\_ball_drone::tryuseballdrone(0,"ball_drone_ability_pet"))
		{
			continue;
		}

		self.balldrone.var_151C = var_00;
		var_02 = "ability_pet_" + var_00 + 1;
		var_03 = level.var_5CC0[var_02];
		self [[ var_03.var_1088C ]]();
	}
}

//Function Number: 4
func_10610()
{
	level.supportcranked = 1;
	level.crankedbombtimer = 30;
	scripts\mp\utility::func_B2AC("");
}

//Function Number: 5
func_10611()
{
	self.health = 200;
	self.movespeedscaler = 0.6;
	scripts\mp\weapons::updatemovespeedscale();
}

//Function Number: 6
func_10612()
{
	var_00 = self getcurrentprimaryweapon();
	if(var_00 == "none")
	{
		var_00 = scripts\engine\utility::getlastweapon();
	}

	if(!self hasweapon(var_00))
	{
		var_00 = scripts\mp\killstreaks\_utility::getfirstprimaryweapon();
	}

	scripts\mp\utility::_takeweapon(var_00);
	scripts\mp\utility::_giveweapon("iw7_knife_mp",0);
	scripts\mp\utility::_switchtoweapon("iw7_knife_mp");
	thread func_94A9();
}

//Function Number: 7
func_10613()
{
	var_00 = self getcurrentprimaryweapon();
	if(var_00 == "none")
	{
		var_00 = scripts\engine\utility::getlastweapon();
	}

	if(!self hasweapon(var_00))
	{
		var_00 = scripts\mp\killstreaks\_utility::getfirstprimaryweapon();
	}

	scripts\mp\utility::_takeweapon(var_00);
	scripts\mp\utility::_giveweapon("iw7_knife_mp",0);
	scripts\mp\utility::_switchtoweapon("iw7_knife_mp");
	self.movespeedscaler = 1.5;
}

//Function Number: 8
func_94A9()
{
	self endon("disconnect");
	self endon("death");
	for(;;)
	{
		var_00 = self getcurrentoffhand();
		self givemaxammo(var_00);
		wait(2);
	}
}