/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 3372.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 19
 * Decompile Time: 20 ms
 * Timestamp: 10/27/2023 12:26:47 AM
*******************************************************************/

//Function Number: 1
init()
{
	level.var_138A1 = [];
	level.magic_weapons = [];
	level.all_magic_weapons = [];
	level.var_47AD = [];
	level.pap = [];
	level.var_138CB = [];
	func_C906();
	var_00 = spawnstruct();
	var_00.var_DB01 = "tickets";
	var_00.model = "zmb_lethal_cryo_grenade_wm";
	var_00.var_39C = "zfreeze_semtex_mp";
	level.var_138A1["zfreeze_semtex_mp"] = var_00;
	scripts\engine\utility::flag_init("wall_buy_setup_done");
}

//Function Number: 2
func_48CD(param_00,param_01,param_02,param_03,param_04)
{
	var_05 = spawnstruct();
	param_00 = int(param_00);
	var_05.var_394 = param_01;
	if(param_04 != "")
	{
		var_05.var_EC13 = param_04;
	}

	var_05.model = function_00EA(param_01);
	var_05.var_DB01 = param_03;
	level.var_138A1[param_02] = var_05;
}

//Function Number: 3
func_C906()
{
	var_00 = 0;
	if(isdefined(level.coop_weapontable))
	{
		var_01 = level.coop_weapontable;
	}
	else
	{
		var_01 = "cp/cp_weapontable.csv";
	}

	for(;;)
	{
		var_02 = tablelookupbyrow(var_01,var_00,0);
		if(var_02 == "")
		{
			break;
		}

		var_03 = tablelookupbyrow(var_01,var_00,1);
		var_04 = tablelookupbyrow(var_01,var_00,2);
		var_05 = tablelookupbyrow(var_01,var_00,4);
		var_06 = tablelookupbyrow(var_01,var_00,5);
		var_07 = scripts\cp\utility::getrawbaseweaponname(var_03);
		var_08 = strtok(var_04," ");
		foreach(var_0A in var_08)
		{
			switch(var_0A)
			{
				case "craft":
					level.var_47AD[var_07] = var_03;
					break;
	
				case "magic":
					level.magic_weapons[var_07] = getweaponbasename(var_03);
					level.all_magic_weapons[var_07] = var_03;
					break;
	
				case "upgrade":
					level.pap[var_07] = var_03;
					break;
	
				case "wall":
				case "tickets":
					func_48CD(var_02,var_03,var_07,var_0A,var_06);
					break;
			}
		}

		var_00++;
	}
}

//Function Number: 4
func_FA1D(param_00)
{
	level endon("game_ended");
	param_00 endon("disconnect");
	var_01 = 0;
	var_02 = 1;
	var_03 = 2;
	var_04 = 3;
	var_05 = 6;
	param_00.weapon_build_models = [];
	param_00.rofweaponslist = [];
	param_00.var_13C38 = [];
	if(scripts\cp\utility::map_check(2))
	{
		var_06 = "cp/cp_disco_wall_buy_models.csv";
	}
	else if(scripts\cp\utility::map_check(3))
	{
		var_06 = "cp/cp_town_wall_buy_models.csv";
	}
	else if(scripts\cp\utility::map_check(4))
	{
		var_06 = "cp/cp_final_wall_buy_models.csv";
	}
	else
	{
		var_06 = "cp/cp_wall_buy_models.csv";
	}

	var_07 = 0;
	for(;;)
	{
		var_08 = tablelookupbyrow(var_06,var_07,var_02);
		if(var_08 == "")
		{
			break;
		}

		var_09 = "none";
		var_0A = "none";
		var_0B = "none";
		var_0C = -1;
		if(isdefined(var_08))
		{
			var_0D = tablelookup(var_06,var_01,var_07,var_03);
			var_0E = tablelookup(var_06,var_01,var_07,var_04);
			var_0F = [];
			if(isdefined(var_0D) && var_0D != "")
			{
				var_10 = scripts\cp\cp_relics::func_7D6C(param_00,var_0D);
				if(var_10.size > 0)
				{
					param_00.var_13C38[var_0D] = var_10;
				}

				for(var_11 = 0;var_11 < var_05;var_11++)
				{
					var_12 = param_00 getplayerdata("cp","zombiePlayerLoadout","zombiePlayerWeaponModels",var_0D,"attachment",var_11);
					if(isdefined(var_12) && var_12 != "none")
					{
						var_0F[var_0F.size] = var_12;
					}
				}

				var_09 = scripts\cp\utility::getweaponcamo(var_0D);
				var_0A = scripts\cp\utility::getweaponcosmeticattachment(var_0D);
				var_0B = scripts\cp\utility::getweaponreticle(var_0D);
				var_0C = scripts\cp\utility::getweaponpaintjobid(var_0D);
			}

			param_00.weapon_build_models[var_08] = scripts\cp\utility::mpbuildweaponname(scripts\cp\utility::getweaponrootname(var_0E),var_0F,var_09,var_0B,scripts\cp\utility::get_weapon_variant_id(param_00,var_0E),self getentitynumber(),self.clientid,var_0C,var_0A);
			if(var_08 == "g18")
			{
				param_00 loadweaponsforplayer([param_00.weapon_build_models[var_08]],1);
			}

			var_13 = function_00E3(param_00.weapon_build_models[var_08]);
			foreach(var_12 in var_13)
			{
				if(issubstr(var_12,"rof"))
				{
					param_00.rofweaponslist[param_00.rofweaponslist.size] = getweaponbasename(param_00.weapon_build_models[var_08]);
				}
			}
		}

		var_07++;
	}

	param_00.weaponkitinitialized = 1;
	param_00 notify("player_weapon_build_kit_initialized");
}

//Function Number: 5
func_23DA()
{
	if(scripts\cp\utility::map_check(2))
	{
		var_00 = "cp/cp_disco_wall_buy_models.csv";
	}
	else if(scripts\cp\utility::map_check(3))
	{
		var_00 = "cp/cp_town_wall_buy_models.csv";
	}
	else if(scripts\cp\utility::map_check(4))
	{
		var_00 = "cp/cp_final_wall_buy_models.csv";
	}
	else
	{
		var_00 = "cp/cp_wall_buy_models.csv";
	}

	if(!scripts\engine\utility::flag_exist("wall_buy_setup_done"))
	{
		scripts\engine\utility::flag_init("wall_buy_setup_done");
	}

	var_01 = [];
	var_02 = 0;
	for(;;)
	{
		var_03 = tablelookupbyrow(var_00,var_02,1);
		if(var_03 == "")
		{
			break;
		}

		var_01[var_01.size] = var_03;
		var_02++;
	}

	var_04 = [];
	var_05 = scripts\engine\utility::getstructarray("interaction","targetname");
	foreach(var_07 in var_05)
	{
		if(isdefined(var_07.name) && var_07.name == "wall_buy")
		{
			var_04[var_04.size] = var_07;
			if(isdefined(var_07.target))
			{
				if(scripts\engine\utility::istrue(var_07.already_used))
				{
					continue;
				}

				var_08 = scripts\engine\utility::getstructarray(var_07.target,"target");
				foreach(var_0A in var_08)
				{
					if(var_0A == var_07)
					{
						continue;
					}

					var_0A.already_used = 1;
					var_0A.parent_struct = var_07;
				}
			}
		}
	}

	while(level.players.size < 1)
	{
		wait(0.05);
	}

	var_0D = sortbydistance(var_04,level.players[0].origin);
	foreach(var_0F in var_0D)
	{
		var_0F.script_noteworthy = strtok(var_0F.script_noteworthy,"+")[0];
		var_10 = var_0F.script_noteworthy;
		var_11 = scripts\cp\utility::getrawbaseweaponname(var_0F.script_noteworthy);
		var_12 = undefined;
		if(!isdefined(level.var_138A1[var_11]))
		{
			var_0F.disabled = 1;
			continue;
		}

		if(!scripts\engine\utility::istrue(var_0F.already_used))
		{
			if(isdefined(var_0F.target))
			{
				var_13 = scripts\engine\utility::getstruct(var_0F.target,"targetname");
				var_14 = var_13.origin;
				var_15 = var_13.angles;
			}
			else
			{
				var_14 = var_11.origin;
				var_15 = var_10.angles;
			}

			for(var_02 = 0;var_02 < var_01.size;var_02++)
			{
				if(var_01[var_02] == var_11)
				{
					var_12 = var_02;
					break;
				}
			}

			if(isdefined(var_12))
			{
				var_0F.trigger = spawn("script_weapon",var_14,0,0,var_12);
			}
			else
			{
				var_16 = (0,0,0);
				var_17 = (0,0,0);
				if(issubstr(var_0F.script_noteworthy,"forgefreeze"))
				{
					var_16 = (3.25,-18,9.75);
					var_17 = (0,0,-90);
				}

				if(isdefined(var_15))
				{
					var_15 = var_15 + var_17;
				}

				var_0F.trigger = spawn("script_model",var_14 + var_16);
				if(isdefined(var_10))
				{
					var_0F.trigger setmodel(level.var_138A1[var_11].model);
				}
				else
				{
					var_0F.trigger setmodel("tag_origin");
				}
			}

			if(isdefined(var_15))
			{
				var_0F.trigger.angles = var_15;
			}

			var_0F.trigger thread func_16F5(var_0F,var_0F.trigger,var_10,var_11);
			level.var_138CB[level.var_138CB.size] = var_0F.trigger;
		}
		else if(isdefined(var_0F.parent_struct.trigger))
		{
			var_0F.trigger = var_0F.parent_struct.trigger;
		}
		else
		{
			var_0F thread applyparentstructvalues(var_0F);
		}

		var_0F.var_394 = var_10;
	}

	scripts\engine\utility::flag_set("wall_buy_setup_done");
}

//Function Number: 6
applyparentstructvalues(param_00)
{
	level endon("game_ended");
	while(!isdefined(param_00.parent_struct.trigger))
	{
		scripts\engine\utility::waitframe();
	}

	param_00.trigger = param_00.parent_struct.trigger;
}

//Function Number: 7
func_16F5(param_00,param_01,param_02,param_03)
{
	if(!scripts\engine\utility::flag("init_interaction_done"))
	{
		scripts\engine\utility::flag_wait("init_interaction_done");
	}

	param_01.cost = level.interactions[param_02].cost;
	param_01.struct = param_00;
	if(isdefined(param_03) && issubstr(param_03,"harpoon") || issubstr(param_03,"slasher") || issubstr(param_03,"katana"))
	{
		return;
	}

	if(param_00.script_parameters != "tickets")
	{
		level.outline_weapon_watch_list[level.outline_weapon_watch_list.size] = param_01;
	}
}

//Function Number: 8
func_A02D(param_00)
{
	param_00 _meth_834A(self);
}

//Function Number: 9
givevalidweapon(param_00,param_01)
{
	level endon("game_ended");
	param_00 endon("game_ended");
	param_00 endon("disconnect");
	param_00 notify("weapon_purchased");
	if(scripts\engine\utility::istrue(param_00.isusingsupercard))
	{
		wait(0.5);
	}

	var_02 = undefined;
	if(scripts\cp\zombies\zombies_weapons::should_take_players_current_weapon(param_00))
	{
		var_03 = param_00 scripts\cp\utility::getvalidtakeweapon();
		var_04 = scripts\cp\utility::getrawbaseweaponname(var_03);
		param_00 takeweapon(var_03);
		if(isdefined(param_00.pap[var_04]))
		{
			param_00.pap[var_04] = undefined;
			param_00 notify("weapon_level_changed");
		}
	}

	var_05 = scripts\cp\utility::getrawbaseweaponname(param_01);
	param_00 scripts\cp\utility::take_fists_weapon(param_00);
	if(isdefined(param_00.weapon_build_models[var_05]))
	{
		param_01 = param_00.weapon_build_models[var_05];
	}

	var_06 = function_00E3(param_01);
	param_01 = param_00 scripts\cp\cp_weapon::return_weapon_name_with_like_attachments(param_01,undefined,var_06,undefined,undefined);
	param_01 = param_00 scripts\cp\utility::_giveweapon(param_01,undefined,undefined,0);
	var_07 = spawnstruct();
	var_07.lvl = 1;
	param_00.pap[var_05] = var_07;
	param_00 scripts\cp\cp_merits::processmerit("mt_purchased_weapon");
	param_00 notify("weapon_level_changed");
	param_00 givemaxammo(param_01);
	param_00 switchtoweapon(param_01);
}

//Function Number: 10
_meth_834A(param_00)
{
	var_01 = 0;
	var_02 = undefined;
	var_03 = param_00.trigger.cost;
	var_04 = undefined;
	var_05 = undefined;
	var_06 = undefined;
	var_07 = self getweaponslistprimaries();
	var_08 = self getweaponslistprimaries().size;
	var_09 = 3;
	var_0A = scripts\cp\utility::getrawbaseweaponname(param_00.script_noteworthy);
	if(param_00.script_noteworthy == "iw7_forgefreeze_zm")
	{
		level.magic_weapons["forgefreeze"] = "iw7_forgefreeze_zm+forgefreezealtfire";
		var_01 = 1;
	}

	if(param_00.script_noteworthy == "iw7_venomx_zm")
	{
		level.magic_weapons["venomx"] = "iw7_venomx_zm";
		if(isdefined(level.venomx_count) && level.venomx_count >= level.players.size)
		{
			var_01 = 1;
		}
	}

	if(scripts\cp\utility::weapon_is_dlc_melee(param_00.script_noteworthy))
	{
		var_01 = 1;
	}

	if(!scripts\cp\cp_weapon::has_weapon_variation(param_00.script_noteworthy))
	{
		var_0B = scripts\cp\utility::getvalidtakeweapon();
		self.curr_weap = var_0B;
		if(isdefined(var_0B))
		{
			var_02 = 1;
			var_0C = scripts\cp\utility::getrawbaseweaponname(var_0B);
			if(scripts\cp\utility::has_special_weapon() && var_08 < var_09 + 1)
			{
				var_02 = 0;
			}

			foreach(var_0E in var_07)
			{
				if(scripts\cp\utility::isstrstart(var_0E,"alt_"))
				{
					var_09++;
				}
			}

			if(scripts\cp\utility::has_zombie_perk("perk_machine_more"))
			{
				var_09++;
			}

			if(var_07.size < var_09)
			{
				var_02 = 0;
			}

			if(var_02)
			{
				if(isdefined(self.pap[var_0C]))
				{
					self.pap[var_0C] = undefined;
					self notify("weapon_level_changed");
				}

				thread scripts\cp\cp_interaction::play_weapon_purchase_vo(param_00,self);
				self takeweapon(var_0B);
			}
		}

		if(isdefined(self.weapon_build_models[var_0A]))
		{
			var_04 = self.weapon_build_models[var_0A];
		}
		else
		{
			var_04 = param_00.var_394;
		}

		if(scripts\cp\utility::is_consumable_active("wall_power"))
		{
			var_10 = scripts\engine\utility::array_combine(function_00E3(var_04),["pap1"]);
			if(issubstr(var_04,"venomx"))
			{
				var_10 = undefined;
				var_06 = undefined;
				if(scripts\engine\utility::istrue(level.completed_venomx_pap1_challenges))
				{
					var_04 = "iw7_venomx_zm_pap1";
					var_06 = level.pap_1_camo;
				}
			}
			else
			{
				if(isdefined(level.no_pap_camos) && scripts\engine\utility::array_contains(level.no_pap_camos,var_0A))
				{
					var_06 = undefined;
				}
				else if(isdefined(level.pap_1_camo))
				{
					var_06 = level.pap_1_camo;
				}

				switch(var_0A)
				{
					case "dischord":
						var_06 = "camo20";
						break;

					case "facemelter":
						var_06 = "camo22";
						break;

					case "headcutter":
						var_06 = "camo21";
						break;

					case "shredder":
						var_06 = "camo23";
						break;
				}
			}

			var_11 = scripts\cp\cp_weapon::return_weapon_name_with_like_attachments(var_04,undefined,var_10,undefined,var_06);
			var_11 = scripts\cp\utility::_giveweapon(var_11,undefined,undefined,1);
			var_12 = scripts\cp\utility::getrawbaseweaponname(var_11);
			scripts\cp\cp_merits::processmerit("mt_upgrade_weapons");
			var_13 = spawnstruct();
			var_13.lvl = 2;
			self.pap[var_12] = var_13;
			if(!scripts\engine\utility::istrue(level.completed_venomx_pap1_challenges) && issubstr(var_04,"venomx"))
			{
				scripts\cp\utility::take_fists_weapon(self);
				self notify("wor_item_pickup",var_11);
				scripts\cp\cp_merits::processmerit("mt_purchased_weapon");
				self givemaxammo(var_11);
				self notify("weapon_level_changed");
				self switchtoweapon(var_11);
				wait(0.25);
				while(self isswitchingweapon())
				{
					wait(0.05);
				}

				self notify("weapon_purchased");
				wait(0.05);
				self.purchasing_ammo = undefined;
				scripts\cp\cp_interaction::refresh_interaction();
				return;
			}

			scripts\cp\utility::notify_used_consumable("wall_power");
			scripts\cp\utility::take_fists_weapon(self);
		}
		else
		{
			var_10 = function_00E3(var_07);
			var_11 = scripts\cp\cp_weapon::return_weapon_name_with_like_attachments(var_06,undefined,var_13);
			var_13 = scripts\cp\utility::_giveweapon(var_13,undefined,undefined,1);
			self.itempicked = var_13;
			level.transactionid = randomint(100);
			scripts\cp\zombies\zombie_analytics::log_purchasingaweapon(1,self,self.itempicked,self.curr_weap,level.wave_num,var_01.name,self.wavesheldwithweapon,self.killsperweaponlog,self.downsperweaponlog);
			scripts\cp\utility::take_fists_weapon(self);
			var_13 = spawnstruct();
			var_13.lvl = 1;
			self.pap[var_0A] = var_13;
		}

		if(var_01)
		{
			param_00.trigger delete();
			scripts\cp\cp_interaction::remove_from_current_interaction_list(param_00);
		}

		self notify("wor_item_pickup",var_11);
		scripts\cp\cp_merits::processmerit("mt_purchased_weapon");
		self givemaxammo(var_11);
		self notify("weapon_level_changed");
		self switchtoweapon(var_11);
		wait(0.25);
		while(self isswitchingweapon())
		{
			wait(0.05);
		}
	}
	else
	{
		self.purchasing_ammo = 1;
		var_0A = undefined;
		var_14 = self getweaponslistall();
		var_15 = self getcurrentweapon();
		var_16 = scripts\cp\utility::getrawbaseweaponname(param_00.script_noteworthy);
		var_17 = undefined;
		foreach(var_19 in var_14)
		{
			var_0A = scripts\cp\utility::getrawbaseweaponname(var_19);
			if(var_0A == var_16)
			{
				var_17 = var_19;
				break;
			}
		}

		var_1B = function_0249(var_17);
		var_1C = scripts/cp/perks/prestige::prestige_getminammo();
		var_1D = int(var_1C * var_1B);
		var_1E = self getweaponammostock(var_17);
		if(var_1E < var_1D)
		{
			self setweaponammostock(var_17,var_1D);
		}

		if(self hasweapon("alt_" + var_17))
		{
			var_1B = function_0249("alt_" + var_17);
			var_1C = scripts/cp/perks/prestige::prestige_getminammo();
			var_1D = int(var_1C * var_1B);
			var_1E = self getweaponammostock("alt_" + var_17);
			if(var_1E < var_1D)
			{
				self setweaponammostock("alt_" + var_17,var_1D);
			}
		}

		thread scripts\cp\cp_vo::try_to_play_vo("pillage_ammo","zmb_comment_vo","low",10,0,1,1,50);
	}

	self notify("weapon_purchased");
	wait(0.05);
	self.purchasing_ammo = undefined;
	scripts\cp\cp_interaction::refresh_interaction();
}

//Function Number: 11
func_E229(param_00)
{
	if(isdefined(self.var_10936))
	{
		self.var_10936 = undefined;
	}

	if(isdefined(self.var_10939))
	{
		self.var_10939 = undefined;
	}

	if(isdefined(self.var_10938))
	{
		self.var_10938 = undefined;
	}

	if(isdefined(self.special_ammocount_comb))
	{
		self.special_ammocount_comb = undefined;
	}

	if(isdefined(self.special_ammocount))
	{
		self.special_ammocount = undefined;
	}
}

//Function Number: 12
setgrenadethrowscale()
{
	if(scripts/cp/perks/prestige::prestige_getnodeployables() == 1)
	{
		var_00 = self getweaponslistprimaries();
		foreach(var_02 in var_00)
		{
			var_03 = scripts\cp\utility::coop_getweaponclass(var_02);
			if(var_03 == "weapon_pistol")
			{
				var_04 = function_0249(var_02);
				var_05 = int(var_04 * 0.25);
				var_06 = self getrunningforwardpainanim(var_02);
				if(var_05 > var_06)
				{
					self setweaponammostock(var_02,var_05);
				}
			}
		}
	}
}

//Function Number: 13
func_7D6F(param_00)
{
	var_01 = self getweaponslistprimaries();
	foreach(var_03 in var_01)
	{
		var_04 = scripts\cp\cp_persistence::get_base_weapon_name(var_03);
		if(issubstr(param_00,var_04))
		{
			return var_03;
		}
	}

	return undefined;
}

//Function Number: 14
func_7C04()
{
	var_00 = self getweaponslistprimaries();
	var_01 = 3;
	foreach(var_03 in var_00)
	{
		if(scripts\cp\utility::isstrstart(var_03,"alt_"))
		{
			var_01++;
		}
	}

	if(scripts\cp\utility::has_zombie_perk("perk_machine_more"))
	{
		var_01++;
	}

	if(var_00.size >= var_01)
	{
		var_05 = self getcurrentweapon();
		var_06 = 0;
		if(var_05 == "none")
		{
			var_06 = 1;
		}
		else if(scripts\engine\utility::array_contains(level.additional_laststand_weapon_exclusion,var_05))
		{
			var_06 = 1;
		}
		else if(scripts\engine\utility::array_contains(level.additional_laststand_weapon_exclusion,getweaponbasename(var_05)))
		{
			var_06 = 1;
		}
		else if(scripts\cp\utility::is_melee_weapon(var_05,1))
		{
			var_06 = 1;
		}

		if(var_06)
		{
			self.copy_fullweaponlist = self getweaponslistall();
			var_05 = scripts\cp\cp_laststand::choose_last_weapon(level.additional_laststand_weapon_exclusion,1,1);
		}

		self.copy_fullweaponlist = undefined;
		if(function_0244(var_05) == "altmode")
		{
			var_05 = func_7D66(var_05);
		}

		return var_05;
	}

	return undefined;
}

//Function Number: 15
func_7D66(param_00)
{
	if(function_0244(param_00) != "altmode")
	{
		return param_00;
	}

	return getsubstr(param_00,4);
}

//Function Number: 16
can_give_weapon(param_00)
{
	var_01 = self getweaponslistprimaries();
	var_02 = self getcurrentweapon();
	var_03 = scripts\cp\utility::coop_getweaponclass(var_02);
	var_04 = scripts\cp\utility::getbaseweaponname(var_02);
	foreach(param_00 in var_01)
	{
		if(scripts\cp\utility::isstrstart(param_00,"alt_"))
		{
			var_01 = scripts\engine\utility::array_remove(var_01,param_00);
		}
	}

	var_07 = 0;
	if(!scripts\cp\utility::has_zombie_perk("perk_machine_more"))
	{
		var_08 = 3;
	}
	else
	{
		var_08 = 4;
	}

	if(isdefined(self.var_C20E))
	{
		var_08 = var_08 + self.var_C20E;
	}

	while(self isswitchingweapon())
	{
		wait(0.05);
	}

	if(var_02 == "none")
	{
		return 0;
	}

	if(isdefined(level.var_4C40))
	{
		if(![[ level.var_4C40 ]](var_01,var_02,var_03,var_08))
		{
			return 0;
		}
	}

	if(isdefined(scripts\cp\utility::has_special_weapon()) && scripts\cp\utility::has_special_weapon())
	{
		return 0;
	}

	if(var_01.size >= var_08 + 1 && self.hasriotshield)
	{
		return 0;
	}

	if(var_01.size >= var_08 + 2 && self.hasriotshield)
	{
		return 0;
	}

	if(var_01.size >= var_08 + 1 && !self.hasriotshieldequipped)
	{
		return 0;
	}

	if(var_01.size >= var_08 + 2 && self.hasriotshieldequipped)
	{
		return 0;
	}

	if(self.hasriotshieldequipped && var_01.size >= var_08 + 1)
	{
		return 0;
	}

	if(self.hasriotshieldequipped && var_01.size >= var_08 + 1)
	{
		return 0;
	}

	if(!scripts\cp\utility::is_holding_deployable())
	{
		return 1;
	}
	else
	{
		return 0;
	}

	return 0;
}

//Function Number: 17
interaction_purchase_weapon(param_00,param_01)
{
	if(scripts\cp\utility::is_weapon_purchase_disabled())
	{
		return;
	}

	if(issubstr(param_00.script_noteworthy,"venomx"))
	{
		var_02 = param_01 getweaponslistall();
		foreach(var_04 in var_02)
		{
			if(issubstr(var_04,"venomx"))
			{
				return;
			}
		}

		if(scripts\engine\utility::flag_exist("completepuzzles_step4") && scripts\engine\utility::flag("completepuzzles_step4"))
		{
			var_02 = param_01 getweaponslistall();
			foreach(var_04 in var_02)
			{
				if(issubstr(var_04,"venomx"))
				{
					return;
				}
			}

			param_01 thread scripts\cp\cp_vo::try_to_play_vo("quest_venx_weapon","final_comment_vo");
			if(!isdefined(level.venomx_count))
			{
				level.venomx_count = 1;
			}

			param_00 func_A02D(param_01);
			param_01.last_interaction_point = undefined;
			param_01 scripts/cp/zombies/achievement::update_achievement("EGG_SLAYER",1);
			scripts\cp\cp_interaction::remove_from_current_interaction_list_for_player(param_00,param_01);
			return;
		}

		return;
	}

	var_02 func_A02D(var_03);
	var_03.last_interaction_point = undefined;
}

//Function Number: 18
get_wall_buy_hint_func(param_00,param_01)
{
	if(issubstr(param_00.script_noteworthy,"venomx"))
	{
		if(!scripts\engine\utility::flag("completepuzzles_step4"))
		{
			return "";
		}

		var_02 = param_01 getweaponslistall();
		foreach(var_04 in var_02)
		{
			if(issubstr(var_04,"venomx"))
			{
				return &"COOP_INTERACTIONS_CANNOT_BUY";
			}
		}
	}

	if(scripts\cp\utility::is_weapon_purchase_disabled())
	{
		return &"CP_ZMB_INTERACTIONS_WALL_BUY_DISABLED";
	}

	if(!param_01 can_give_weapon(param_00))
	{
		return &"COOP_INTERACTIONS_CANNOT_BUY";
	}

	var_06 = [[ level.weapon_hint_func ]](param_00,param_01);
	if(isdefined(var_06))
	{
		return var_06;
	}

	var_07 = getweaponbasename(param_00.script_noteworthy);
	return level.interaction_hintstrings[var_07];
}

//Function Number: 19
set_weapon_purchase_disabled(param_00)
{
	level.weapon_purchase_disabled = param_00;
}