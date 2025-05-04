/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\cp\zombies\_powerup_ability.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 17
 * Decompile Time: 560 ms
 * Timestamp: 10/27/2023 12:23:45 AM
*******************************************************************/

//Function Number: 1
powershud_init()
{
	var_00 = spawnstruct();
	level.power_hud_info = var_00;
	var_00.omnvarnames = ["primary","secondary"];
	var_00.omnvarnames["primary"][0] = "ui_power_num_charges";
	var_00.omnvarnames["primary"][1] = "ui_power_max_charges";
	var_00.omnvarnames["primary"][2] = "ui_power_recharge";
	var_00.omnvarnames["primary"][3] = "ui_power_id";
	var_00.omnvarnames["primary"][4] = "ui_power_consume";
	var_00.omnvarnames["primary"][5] = "ui_power_disabled";
	var_00.omnvarnames["primary"][6] = "ui_power_state";
	var_00.omnvarnames["secondary"][0] = "ui_power_secondary_num_charges";
	var_00.omnvarnames["secondary"][1] = "ui_power_secondary_max_charges";
	var_00.omnvarnames["secondary"][2] = "ui_power_secondary_recharge";
	var_00.omnvarnames["secondary"][3] = "ui_powerfunc_secondary";
	var_00.omnvarnames["secondary"][4] = "ui_power_secondary_consume";
	var_00.omnvarnames["secondary"][5] = "ui_power_secondary_disabled";
	var_00.omnvarnames["secondary"][6] = "ui_power_secondary_state";
}

//Function Number: 2
powershud_assignpower(param_00,param_01,param_02,param_03)
{
	if(param_00 == "scripted")
	{
		return;
	}

	self setclientomnvar(powershud_getslotomnvar(param_00,3),param_01);
	var_04 = scripts\engine\utility::ter_op(param_02,1000,0);
	self setclientomnvar(powershud_getslotomnvar(param_00,2),var_04);
	if(!isdefined(param_03))
	{
		param_03 = 0;
	}

	self setclientomnvar(powershud_getslotomnvar(param_00,0),param_03);
	self setclientomnvar(powershud_getslotomnvar(param_00,4),0);
}

//Function Number: 3
powershud_clearpower(param_00)
{
	if(param_00 == "scripted")
	{
		return;
	}

	self setclientomnvar(powershud_getslotomnvar(param_00,3),-1);
	self setclientomnvar(powershud_getslotomnvar(param_00,2),-1);
	self setclientomnvar(powershud_getslotomnvar(param_00,0),0);
	self setclientomnvar(powershud_getslotomnvar(param_00,4),-1);
}

//Function Number: 4
powershud_updatepowercharges(param_00,param_01)
{
	self setclientomnvar(powershud_getslotomnvar(param_00,0),int(param_01));
}

//Function Number: 5
powershud_updatepowermaxcharges(param_00,param_01)
{
	self setclientomnvar(powershud_getslotomnvar(param_00,1),int(param_01));
}

//Function Number: 6
powershud_updatepowerdrain(param_00,param_01)
{
	self setclientomnvar(powershud_getslotomnvar(param_00,4),param_01);
}

//Function Number: 7
powershud_updatepowermeter(param_00,param_01)
{
	self setclientomnvar(powershud_getslotomnvar(param_00,2),int(param_01));
}

//Function Number: 8
powershud_updatepowerdisabled(param_00,param_01)
{
	self setclientomnvar(powershud_getslotomnvar(param_00,5),param_01);
}

//Function Number: 9
powershud_updatepoweroffcooldown(param_00,param_01)
{
	var_02 = scripts\engine\utility::ter_op(param_01,1,0);
	self setclientomnvar(powershud_getslotomnvar(param_00,6),var_02);
}

//Function Number: 10
powershud_updatepowerstate(param_00,param_01)
{
	self setclientomnvar(powershud_getslotomnvar(param_00,6),param_01);
}

//Function Number: 11
powershud_beginpowerdrain(param_00)
{
	powershud_updatepowerdrain(param_00,1);
}

//Function Number: 12
powershud_endpowerdrain(param_00)
{
	powershud_updatepowerdrain(param_00,0);
}

//Function Number: 13
powershud_beginpowercooldown(param_00,param_01)
{
	powershud_updatepowermeter(param_00,0);
	if(isdefined(param_01) && param_01)
	{
		powershud_updatepowerdisabled(param_00,1);
	}

	powershud_updatepowerstate(param_00,1);
}

//Function Number: 14
powershud_finishpowercooldown(param_00,param_01)
{
	powershud_updatepowermeter(param_00,1000);
	if(isdefined(param_01) && param_01)
	{
		powershud_updatepowerdisabled(param_00,0);
	}

	if(param_00 == "primary")
	{
		self playlocalsound("mp_ability_ready_L1");
	}
	else
	{
		self playlocalsound("mp_ability_ready_R1");
	}

	powershud_updatepowerstate(param_00,0);
}

//Function Number: 15
powershud_updatepowercooldown(param_00,param_01)
{
	powershud_updatepowermeter(param_00,1000 * param_01);
}

//Function Number: 16
powershud_updatepowerdrainprogress(param_00,param_01)
{
	powershud_updatepowermeter(param_00,1000 * param_01);
}

//Function Number: 17
powershud_getslotomnvar(param_00,param_01)
{
	if(param_00 == "scripted")
	{
		return;
	}

	return level.power_hud_info.omnvarnames[param_00][param_01];
}