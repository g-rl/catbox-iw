/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 3326.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 25
 * Decompile Time: 10 ms
 * Timestamp: 10/27/2023 12:26:33 AM
*******************************************************************/

//Function Number: 1
func_98B1()
{
	func_958F();
}

//Function Number: 2
init_perks_from_table()
{
	if(!isdefined(level.var_1B8F))
	{
		level.var_1B8F = "cp/alien/perks_tree.csv";
	}

	level.alien_perks = [];
	func_12E03(0,"perk_0");
	func_12E03(100,"perk_1");
	func_12E03(200,"perk_2");
}

//Function Number: 3
func_976C()
{
	level.coop_perk_callbacks = [];
	register_perk_callback("perk_health",::scripts/cp/perks/perkfunctions::func_F4DD,::scripts/cp/perks/perkfunctions::func_12C21);
	register_perk_callback("perk_health_1",::scripts/cp/perks/perkfunctions::func_F4DE,::scripts/cp/perks/perkfunctions::func_12C22);
	register_perk_callback("perk_health_2",::scripts/cp/perks/perkfunctions::func_F4DF,::scripts/cp/perks/perkfunctions::func_12C23);
	register_perk_callback("perk_health_3",::scripts/cp/perks/perkfunctions::func_F4E0,::scripts/cp/perks/perkfunctions::func_12C24);
	register_perk_callback("perk_health_4",::scripts/cp/perks/perkfunctions::func_F4E1,::scripts/cp/perks/perkfunctions::func_12C25);
	register_perk_callback("perk_pistol_znrg",::scripts/cp/perks/perkfunctions::func_F50B,::scripts/cp/perks/perkfunctions::func_12C4F);
	register_perk_callback("perk_pistol_znrg_1",::scripts/cp/perks/perkfunctions::func_F50C,::scripts/cp/perks/perkfunctions::func_12C50);
	register_perk_callback("perk_pistol_znrg_2",::scripts/cp/perks/perkfunctions::func_F50D,::scripts/cp/perks/perkfunctions::func_12C51);
	register_perk_callback("perk_pistol_znrg_3",::scripts/cp/perks/perkfunctions::func_F50E,::scripts/cp/perks/perkfunctions::func_12C52);
	register_perk_callback("perk_pistol_znrg_4",::scripts/cp/perks/perkfunctions::func_F50F,::scripts/cp/perks/perkfunctions::func_12C53);
	register_perk_callback("perk_pistol_magnum",::scripts/cp/perks/perkfunctions::func_F4F2,::scripts/cp/perks/perkfunctions::func_12C36);
	register_perk_callback("perk_pistol_magnum_1",::scripts/cp/perks/perkfunctions::func_F4F3,::scripts/cp/perks/perkfunctions::func_12C37);
	register_perk_callback("perk_pistol_magnum_2",::scripts/cp/perks/perkfunctions::func_F4F4,::scripts/cp/perks/perkfunctions::func_12C38);
	register_perk_callback("perk_pistol_magnum_3",::scripts/cp/perks/perkfunctions::func_F4F5,::scripts/cp/perks/perkfunctions::func_12C39);
	register_perk_callback("perk_pistol_magnum_4",::scripts/cp/perks/perkfunctions::func_F4F6,::scripts/cp/perks/perkfunctions::func_12C3A);
	register_perk_callback("perk_pistol_zg18",::scripts/cp/perks/perkfunctions::func_F506,::scripts/cp/perks/perkfunctions::func_12C4A);
	register_perk_callback("perk_pistol_zg18_1",::scripts/cp/perks/perkfunctions::func_F507,::scripts/cp/perks/perkfunctions::func_12C4B);
	register_perk_callback("perk_pistol_zg18_2",::scripts/cp/perks/perkfunctions::func_F508,::scripts/cp/perks/perkfunctions::func_12C4C);
	register_perk_callback("perk_pistol_zg18_3",::scripts/cp/perks/perkfunctions::func_F509,::scripts/cp/perks/perkfunctions::func_12C4D);
	register_perk_callback("perk_pistol_zg18_4",::scripts/cp/perks/perkfunctions::func_F50A,::scripts/cp/perks/perkfunctions::func_12C4E);
	register_perk_callback("perk_pistol_zemc",::scripts/cp/perks/perkfunctions::func_F501,::scripts/cp/perks/perkfunctions::func_12C45);
	register_perk_callback("perk_pistol_zemc_1",::scripts/cp/perks/perkfunctions::func_F502,::scripts/cp/perks/perkfunctions::func_12C46);
	register_perk_callback("perk_pistol_zemc_2",::scripts/cp/perks/perkfunctions::func_F503,::scripts/cp/perks/perkfunctions::func_12C47);
	register_perk_callback("perk_pistol_zemc_3",::scripts/cp/perks/perkfunctions::func_F504,::scripts/cp/perks/perkfunctions::func_12C48);
	register_perk_callback("perk_pistol_zemc_4",::scripts/cp/perks/perkfunctions::func_F505,::scripts/cp/perks/perkfunctions::func_12C49);
	register_perk_callback("perk_bullet_damage",::scripts/cp/perks/perkfunctions::func_F4CE,::scripts/cp/perks/perkfunctions::func_12C12);
	register_perk_callback("perk_bullet_damage_1",::scripts/cp/perks/perkfunctions::func_F4CF,::scripts/cp/perks/perkfunctions::func_12C13);
	register_perk_callback("perk_bullet_damage_2",::scripts/cp/perks/perkfunctions::func_F4D0,::scripts/cp/perks/perkfunctions::func_12C14);
	register_perk_callback("perk_bullet_damage_3",::scripts/cp/perks/perkfunctions::func_F4D1,::scripts/cp/perks/perkfunctions::func_12C15);
	register_perk_callback("perk_bullet_damage_4",::scripts/cp/perks/perkfunctions::func_F4D2,::scripts/cp/perks/perkfunctions::func_12C16);
	register_perk_callback("perk_medic",::scripts/cp/perks/perkfunctions::func_F4E7,::scripts/cp/perks/perkfunctions::func_12C2B);
	register_perk_callback("perk_medic_1",::scripts/cp/perks/perkfunctions::func_F4E8,::scripts/cp/perks/perkfunctions::func_12C2C);
	register_perk_callback("perk_medic_2",::scripts/cp/perks/perkfunctions::func_F4E9,::scripts/cp/perks/perkfunctions::func_12C2D);
	register_perk_callback("perk_medic_3",::scripts/cp/perks/perkfunctions::func_F4EA,::scripts/cp/perks/perkfunctions::func_12C2E);
	register_perk_callback("perk_medic_4",::scripts/cp/perks/perkfunctions::func_F4EB,::scripts/cp/perks/perkfunctions::func_12C2F);
	register_perk_callback("perk_rigger",::scripts/cp/perks/perkfunctions::func_F510,::scripts/cp/perks/perkfunctions::func_12C54);
	register_perk_callback("perk_rigger_1",::scripts/cp/perks/perkfunctions::func_F511,::scripts/cp/perks/perkfunctions::func_12C55);
	register_perk_callback("perk_rigger_2",::scripts/cp/perks/perkfunctions::func_F512,::scripts/cp/perks/perkfunctions::func_12C56);
	register_perk_callback("perk_rigger_3",::scripts/cp/perks/perkfunctions::func_F513,::scripts/cp/perks/perkfunctions::func_12C57);
	register_perk_callback("perk_rigger_4",::scripts/cp/perks/perkfunctions::func_F514,::scripts/cp/perks/perkfunctions::func_12C58);
	register_perk_callback("perk_robotics",::scripts/cp/perks/perkfunctions::func_F515,::scripts/cp/perks/perkfunctions::func_12C59);
	register_perk_callback("perk_robotics_1",::scripts/cp/perks/perkfunctions::func_F516,::scripts/cp/perks/perkfunctions::func_12C5A);
	register_perk_callback("perk_robotics_2",::scripts/cp/perks/perkfunctions::func_F517,::scripts/cp/perks/perkfunctions::func_12C5B);
	register_perk_callback("perk_robotics_3",::scripts/cp/perks/perkfunctions::func_F518,::scripts/cp/perks/perkfunctions::func_12C5C);
	register_perk_callback("perk_robotics_4",::scripts/cp/perks/perkfunctions::func_F519,::scripts/cp/perks/perkfunctions::func_12C5D);
	register_perk_callback("perk_demolition",::scripts/cp/perks/perkfunctions::func_F4D3,::scripts/cp/perks/perkfunctions::func_12C17);
	register_perk_callback("perk_demolition_1",::scripts/cp/perks/perkfunctions::func_F4D4,::scripts/cp/perks/perkfunctions::func_12C18);
	register_perk_callback("perk_demolition_2",::scripts/cp/perks/perkfunctions::func_F4D5,::scripts/cp/perks/perkfunctions::func_12C19);
	register_perk_callback("perk_demolition_3",::scripts/cp/perks/perkfunctions::func_F4D6,::scripts/cp/perks/perkfunctions::func_12C1A);
	register_perk_callback("perk_demolition_4",::scripts/cp/perks/perkfunctions::func_F4D7,::scripts/cp/perks/perkfunctions::func_12C1B);
	register_perk_callback("perk_gunslinger",::scripts/cp/perks/perkfunctions::func_F4D8,::scripts/cp/perks/perkfunctions::func_12C1C);
	register_perk_callback("perk_gunslinger_1",::scripts/cp/perks/perkfunctions::func_F4D9,::scripts/cp/perks/perkfunctions::func_12C1D);
	register_perk_callback("perk_gunslinger_2",::scripts/cp/perks/perkfunctions::func_F4DA,::scripts/cp/perks/perkfunctions::func_12C1E);
	register_perk_callback("perk_gunslinger_3",::scripts/cp/perks/perkfunctions::func_F4DB,::scripts/cp/perks/perkfunctions::func_12C1F);
	register_perk_callback("perk_gunslinger_4",::scripts/cp/perks/perkfunctions::func_F4DC,::scripts/cp/perks/perkfunctions::func_12C20);
	register_perk_callback("perk_hybrid",::scripts/cp/perks/perkfunctions::func_F4E2,::scripts/cp/perks/perkfunctions::func_12C26);
	register_perk_callback("perk_hybrid_1",::scripts/cp/perks/perkfunctions::func_F4E3,::scripts/cp/perks/perkfunctions::func_12C27);
	register_perk_callback("perk_hybrid_2",::scripts/cp/perks/perkfunctions::func_F4E4,::scripts/cp/perks/perkfunctions::func_12C28);
	register_perk_callback("perk_hybrid_3",::scripts/cp/perks/perkfunctions::func_F4E5,::scripts/cp/perks/perkfunctions::func_12C29);
	register_perk_callback("perk_hybrid_4",::scripts/cp/perks/perkfunctions::func_F4E6,::scripts/cp/perks/perkfunctions::func_12C2A);
	register_perk_callback("perk_none",::scripts/cp/perks/perkfunctions::func_F4EC,::scripts/cp/perks/perkfunctions::func_12C30);
	register_perk_callback("perk_none_1",::scripts/cp/perks/perkfunctions::func_F4EC,::scripts/cp/perks/perkfunctions::func_12C30);
	register_perk_callback("perk_none_2",::scripts/cp/perks/perkfunctions::func_F4EC,::scripts/cp/perks/perkfunctions::func_12C30);
	register_perk_callback("perk_none_3",::scripts/cp/perks/perkfunctions::func_F4EC,::scripts/cp/perks/perkfunctions::func_12C30);
	register_perk_callback("perk_none_4",::scripts/cp/perks/perkfunctions::func_F4EC,::scripts/cp/perks/perkfunctions::func_12C30);
}

//Function Number: 4
init_zombie_perks_callback()
{
	level.coop_perk_callbacks = [];
	register_perk_callback("perk_health",::blank,::blank);
	register_perk_callback("perk_health_1",::blank,::blank);
	register_perk_callback("perk_health_2",::blank,::blank);
	register_perk_callback("perk_health_3",::blank,::blank);
	register_perk_callback("perk_health_4",::blank,::blank);
	register_perk_callback("perk_pistol_znrg",::blank,::blank);
	register_perk_callback("perk_pistol_znrg_1",::blank,::blank);
	register_perk_callback("perk_pistol_znrg_2",::blank,::blank);
	register_perk_callback("perk_pistol_znrg_3",::blank,::blank);
	register_perk_callback("perk_pistol_znrg_4",::blank,::blank);
	register_perk_callback("perk_pistol_magnum",::blank,::blank);
	register_perk_callback("perk_pistol_magnum_1",::blank,::blank);
	register_perk_callback("perk_pistol_magnum_2",::blank,::blank);
	register_perk_callback("perk_pistol_magnum_3",::blank,::blank);
	register_perk_callback("perk_pistol_magnum_4",::blank,::blank);
	register_perk_callback("perk_pistol_zg18",::blank,::blank);
	register_perk_callback("perk_pistol_zg18_1",::blank,::blank);
	register_perk_callback("perk_pistol_zg18_2",::blank,::blank);
	register_perk_callback("perk_pistol_zg18_3",::blank,::blank);
	register_perk_callback("perk_pistol_zg18_4",::blank,::blank);
	register_perk_callback("perk_pistol_zemc",::blank,::blank);
	register_perk_callback("perk_pistol_zemc_1",::blank,::blank);
	register_perk_callback("perk_pistol_zemc_2",::blank,::blank);
	register_perk_callback("perk_pistol_zemc_3",::blank,::blank);
	register_perk_callback("perk_pistol_zemc_4",::blank,::blank);
	register_perk_callback("perk_bullet_damage",::blank,::blank);
	register_perk_callback("perk_bullet_damage_1",::blank,::blank);
	register_perk_callback("perk_bullet_damage_2",::blank,::blank);
	register_perk_callback("perk_bullet_damage_3",::blank,::blank);
	register_perk_callback("perk_bullet_damage_4",::blank,::blank);
	register_perk_callback("perk_medic",::blank,::blank);
	register_perk_callback("perk_medic_1",::blank,::blank);
	register_perk_callback("perk_medic_2",::blank,::blank);
	register_perk_callback("perk_medic_3",::blank,::blank);
	register_perk_callback("perk_medic_4",::blank,::blank);
	register_perk_callback("perk_rigger",::blank,::blank);
	register_perk_callback("perk_rigger_1",::blank,::blank);
	register_perk_callback("perk_rigger_2",::blank,::blank);
	register_perk_callback("perk_rigger_3",::blank,::blank);
	register_perk_callback("perk_rigger_4",::blank,::blank);
	register_perk_callback("perk_robotics",::blank,::blank);
	register_perk_callback("perk_robotics_1",::blank,::blank);
	register_perk_callback("perk_robotics_2",::blank,::blank);
	register_perk_callback("perk_robotics_3",::blank,::blank);
	register_perk_callback("perk_robotics_4",::blank,::blank);
	register_perk_callback("perk_demolition",::blank,::blank);
	register_perk_callback("perk_demolition_1",::blank,::blank);
	register_perk_callback("perk_demolition_2",::blank,::blank);
	register_perk_callback("perk_demolition_3",::blank,::blank);
	register_perk_callback("perk_demolition_4",::blank,::blank);
	register_perk_callback("perk_gunslinger",::blank,::blank);
	register_perk_callback("perk_gunslinger_1",::blank,::blank);
	register_perk_callback("perk_gunslinger_2",::blank,::blank);
	register_perk_callback("perk_gunslinger_3",::blank,::blank);
	register_perk_callback("perk_gunslinger_4",::blank,::blank);
	register_perk_callback("perk_hybrid",::blank,::blank);
	register_perk_callback("perk_hybrid_1",::blank,::blank);
	register_perk_callback("perk_hybrid_2",::blank,::blank);
	register_perk_callback("perk_hybrid_3",::blank,::blank);
	register_perk_callback("perk_hybrid_4",::blank,::blank);
	register_perk_callback("perk_none",::blank,::blank);
	register_perk_callback("perk_none_1",::blank,::blank);
	register_perk_callback("perk_none_2",::blank,::blank);
	register_perk_callback("perk_none_3",::blank,::blank);
	register_perk_callback("perk_none_4",::blank,::blank);
	if(isdefined(level.gamemode_perk_callback_init_func))
	{
		[[ level.gamemode_perk_callback_init_func ]]();
	}
}

//Function Number: 5
blank()
{
}

//Function Number: 6
register_perk_callback(param_00,param_01,param_02)
{
	var_03 = spawnstruct();
	var_03.set = param_01;
	var_03.unset = param_02;
	level.coop_perk_callbacks[param_00] = var_03;
}

//Function Number: 7
func_12E03(param_00,param_01)
{
	level.alien_perks[param_01] = [];
	for(var_02 = param_00;var_02 <= param_00 + 100;var_02++)
	{
		var_03 = func_7B7A(var_02);
		if(var_03 == "")
		{
			break;
		}

		if(!isdefined(level.alien_perks[var_03]))
		{
			var_04 = spawnstruct();
			var_04.var_12F7A = [];
			var_04.unlock = func_7D30(var_03);
			var_04.name = func_7B06(var_03);
			var_04.icon = func_7A26(var_03);
			var_04.ref = var_03;
			var_04.type = param_01;
			var_04.callbacks = level.coop_perk_callbacks[var_03];
			var_04.var_28A3 = var_02;
			level.alien_perks[param_01][var_03] = var_04;
		}

		for(var_05 = var_02;var_05 <= param_00 + 100;var_05++)
		{
			var_06 = func_7B7A(var_05);
			if(var_06 == "")
			{
				break;
			}

			if(var_06 == var_03 || func_9C63(var_03,var_06))
			{
				var_07 = spawnstruct();
				var_07.ref = var_06;
				var_07.var_525F = func_7936(var_06);
				var_07.var_D634 = func_7BC4(var_06);
				level.alien_perks[param_01][var_03].var_12F7A[var_05 - var_02] = var_07;
				continue;
			}

			break;
		}

		var_02 = var_05 - 1;
	}
}

//Function Number: 8
func_9C63(param_00,param_01)
{
	if(param_00 == param_01)
	{
		return 0;
	}

	if(!issubstr(param_01,param_00))
	{
		return 0;
	}

	var_02 = strtok(param_00,"_");
	var_03 = strtok(param_01,"_");
	if(var_03.size - var_02.size != 1)
	{
		return 0;
	}

	for(var_04 = 0;var_04 < var_03.size - 1;var_04++)
	{
		if(var_03[var_04] != var_02[var_04])
		{
			return 0;
		}
	}

	return 1;
}

//Function Number: 9
func_7B7A(param_00)
{
	return tablelookup(level.var_1B8F,0,param_00,1);
}

//Function Number: 10
func_7B06(param_00)
{
	return tablelookup(level.var_1B8F,1,param_00,4);
}

//Function Number: 11
func_7A26(param_00)
{
	return tablelookup(level.var_1B8F,1,param_00,6);
}

//Function Number: 12
func_7936(param_00)
{
	return tablelookup(level.var_1B8F,1,param_00,5);
}

//Function Number: 13
func_7BC4(param_00)
{
	return int(tablelookup(level.var_1B8F,1,param_00,3));
}

//Function Number: 14
func_7D30(param_00)
{
	return int(tablelookup(level.var_1B8F,1,param_00,2));
}

//Function Number: 15
func_7A50(param_00)
{
	return int(tablelookup(level.var_1B8F,1,param_00,7));
}

//Function Number: 16
func_958F()
{
	level.perksetfuncs = [];
	level.scriptperks = [];
	level.perksetfuncs = [];
	level.perkunsetfuncs = [];
	level.scriptperks["specialty_falldamage"] = 1;
	level.scriptperks["specialty_armorpiercing"] = 1;
	level.scriptperks["specialty_gung_ho"] = 1;
	level.scriptperks["specialty_momentum"] = 1;
	level.perksetfuncs["specialty_momentum"] = ::setmomentum;
	level.perkunsetfuncs["specialty_momentum"] = ::unsetmomentum;
	level.perksetfuncs["specialty_falldamage"] = ::setfreefall;
	level.perkunsetfuncs["specialty_falldamage"] = ::unsetfreefall;
}

//Function Number: 17
setfreefall()
{
}

//Function Number: 18
unsetfreefall()
{
}

//Function Number: 19
setmomentum()
{
	thread func_E863();
}

//Function Number: 20
func_E863()
{
	self endon("death");
	self endon("disconnect");
	self endon("momentum_unset");
	for(;;)
	{
		if(self issprinting())
		{
			_meth_848B();
			self.movespeedscaler = 1;
			if(isdefined(level.move_speed_scale))
			{
				self [[ level.move_speed_scale ]]();
			}
		}

		wait(0.1);
	}
}

//Function Number: 21
_meth_848B()
{
	self endon("death");
	self endon("disconnect");
	self endon("momentum_reset");
	self endon("momentum_unset");
	thread func_B944();
	thread func_B943();
	var_00 = 0;
	while(var_00 < 0.08)
	{
		self.movespeedscaler = self.movespeedscaler + 0.01;
		if(isdefined(level.move_speed_scale))
		{
			self [[ level.move_speed_scale ]]();
		}

		wait(0.4375);
		var_00 = var_00 + 0.01;
	}

	self playlocalsound("ftl_phase_in");
	self notify("momentum_max_speed");
	thread momentum_endaftermax();
	self waittill("momentum_reset");
}

//Function Number: 22
momentum_endaftermax()
{
	self endon("momentum_unset");
	self waittill("momentum_reset");
	self playlocalsound("ftl_phase_out");
}

//Function Number: 23
func_B944()
{
	self endon("death");
	self endon("disconnect");
	self endon("momentum_unset");
	for(;;)
	{
		if(!self issprinting() || self issprintsliding() || !self isonground() || self gold_teeth_hint_func())
		{
			wait(0.25);
			if(!self issprinting() || self issprintsliding() || !self isonground() || self gold_teeth_hint_func())
			{
				self notify("momentum_reset");
				break;
			}
		}

		scripts\engine\utility::waitframe();
	}
}

//Function Number: 24
func_B943()
{
	self endon("death");
	self endon("disconnect");
	self waittill("damage");
	self notify("momentum_reset");
}

//Function Number: 25
unsetmomentum()
{
	self notify("momentum_unset");
}