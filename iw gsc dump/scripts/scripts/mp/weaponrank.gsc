/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\weaponrank.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 25
 * Decompile Time: 962 ms
 * Timestamp: 10/27/2023 12:22:16 AM
*******************************************************************/

//Function Number: 1
init()
{
	loadweaponranktable();
	var_00 = getdvarint("online_mp_weapon_xpscale",1);
	addglobalweaponrankxpmultiplier(var_00,"online_mp_weapon_xpscale");
	level thread onplayerconnect();
}

//Function Number: 2
onplayerconnect()
{
	for(;;)
	{
		level waittill("connected",var_00);
		if(!isai(var_00))
		{
			if(var_00 scripts\mp\utility::rankingenabled())
			{
				var_01 = getdvarint("online_mp_party_weapon_xpscale");
				var_02 = var_00 _meth_85BE() > 1;
				if(var_02)
				{
					var_00 addweaponrankxpmultiplier(var_01,"online_mp_party_weapon_xpscale");
				}
			}
		}
	}
}

//Function Number: 3
loadweaponranktable()
{
	level.weaponranktable = spawnstruct();
	level.weaponranktable.rankinfo = [];
	var_00 = 0;
	for(;;)
	{
		var_01 = int(tablelookuprownum("mp/weaponRankTable.csv",0,var_00));
		if(!isdefined(var_01) || var_01 < 0)
		{
			break;
		}

		var_02 = spawnstruct();
		level.weaponranktable.rankinfo[var_00] = var_02;
		var_02.minxp = int(tablelookupbyrow("mp/weaponRankTable.csv",var_00,1));
		var_02.xptonextrank = int(tablelookupbyrow("mp/weaponRankTable.csv",var_00,2));
		var_02.maxxp = int(tablelookupbyrow("mp/weaponRankTable.csv",var_00,3));
		var_00++;
	}

	level.weaponranktable.maxrank = var_00 - 1;
	level.weaponranktable.maxweaponranks = [];
	var_03 = 1;
	for(;;)
	{
		var_01 = int(tablelookuprownum("mp/statstable.csv",0,var_03));
		if(!isdefined(var_01) || var_01 < 0)
		{
			break;
		}

		var_04 = tablelookupbyrow("mp/statstable.csv",var_01,4);
		var_05 = tablelookupbyrow("mp/statstable.csv",var_01,42);
		if(!isdefined(var_04) || var_04 == "" || !isdefined(var_05) || var_05 == "")
		{
		}
		else
		{
			var_05 = int(var_05);
			level.weaponranktable.maxweaponranks[var_04] = var_05;
		}

		var_03++;
	}
}

//Function Number: 4
getplayerweaponrank(param_00)
{
	var_01 = getplayerweaponrankxp(param_00);
	var_02 = getweaponrankforxp(var_01);
	return var_02;
}

//Function Number: 5
getplayerweaponrankxp(param_00,param_01)
{
	if(!isdefined(param_01))
	{
		param_01 = "all";
	}

	switch(param_01)
	{
		case "mp":
			var_02 = self getplayerdata("common","sharedProgression","weaponLevel",param_00,"mpXP");
			return var_02;

		case "cp":
			var_03 = self getplayerdata("common","sharedProgression","weaponLevel",param_01,"cpXP");
			return var_03;

		case "all":
			var_02 = self getplayerdata("common","sharedProgression","weaponLevel",var_02,"mpXP");
			var_03 = self getplayerdata("common","sharedProgression","weaponLevel",param_01,"cpXP");
			return var_02 + var_03;
	}
}

//Function Number: 6
isplayerweaponatmaxxp(param_00)
{
	var_01 = getplayerweaponrankxp(param_00);
	var_02 = getweaponmaxrankxp(param_00);
	return var_01 >= var_02;
}

//Function Number: 7
func_13CCA(param_00)
{
	if(!self isitemunlocked("cac","feature"))
	{
		return 0;
	}

	var_01 = scripts\mp\utility::getweaponrootname(param_00);
	return func_13C97(var_01);
}

//Function Number: 8
func_13C97(param_00)
{
	if(!isdefined(level.weaponranktable.maxweaponranks[param_00]))
	{
		return 0;
	}

	return level.weaponranktable.maxweaponranks[param_00] > 0;
}

//Function Number: 9
getweaponmaxrankxp(param_00)
{
	var_01 = getmaxweaponrankforrootweapon(param_00);
	return getweaponrankinfomaxxp(var_01);
}

//Function Number: 10
getweaponrankforxp(param_00)
{
	if(param_00 == 0)
	{
		return 0;
	}

	for(var_01 = getmaxweaponrank() - 1;var_01 >= 0;var_01--)
	{
		if(param_00 >= getweaponrankinfominxp(var_01))
		{
			return var_01;
		}
	}

	return var_01;
}

//Function Number: 11
func_7FA6(param_00)
{
	var_01 = scripts\mp\utility::getweaponrootname(param_00);
	return getmaxweaponrankforrootweapon(var_01);
}

//Function Number: 12
getmaxweaponrankforrootweapon(param_00)
{
	return level.weaponranktable.maxweaponranks[param_00];
}

//Function Number: 13
getmaxweaponrank()
{
	return level.weaponranktable.maxrank;
}

//Function Number: 14
getweaponrankinfominxp(param_00)
{
	return level.weaponranktable.rankinfo[param_00].minxp;
}

//Function Number: 15
playlocalsound(param_00)
{
	return level.weaponranktable.rankinfo[param_00].xptonextrank;
}

//Function Number: 16
getweaponrankinfomaxxp(param_00)
{
	return level.weaponranktable.rankinfo[param_00].maxxp;
}

//Function Number: 17
_meth_8394(param_00,param_01,param_02)
{
	if(isai(self) || !isplayer(self) || !isdefined(param_02) || param_02 == 0 || !scripts\mp\utility::rankingenabled())
	{
		return;
	}

	var_03 = scripts\mp\utility::getweaponrootname(param_00);
	if(!self isitemunlocked(var_03,"weapon"))
	{
		return;
	}

	if(!func_13C97(var_03))
	{
		return;
	}

	var_04 = remapscoreeventforweapon(param_01);
	if(var_04 != param_01)
	{
		param_01 = var_04;
		param_02 = scripts\mp\rank::getscoreinfovalue(param_01);
	}

	if(param_02 < 0)
	{
		return;
	}

	var_05 = param_02;
	param_02 = param_02 * _meth_8233();
	param_02 = int(param_02);
	if(param_02 > getweaponmaxrankxp(var_03))
	{
		return;
	}

	var_06 = getplayerweaponrankxp(var_03,"mp");
	var_07 = getplayerweaponrankxp(var_03,"cp");
	var_08 = var_06 + var_07;
	var_09 = getweaponrankforxp(var_08);
	var_0A = getweaponmaxrankxp(var_03);
	var_0B = var_0A - var_07;
	var_0C = var_06 + param_02;
	if(var_0C > var_0B)
	{
		var_0C = var_0B;
	}

	var_0D = var_0C + var_07;
	var_0E = getmaxweaponrankforrootweapon(var_03);
	var_0F = self getplayerdata("common","sharedProgression","weaponLevel",var_03,"prestige");
	var_10 = int(min(getweaponrankforxp(var_0D),var_0E));
	scripts\mp\analyticslog::logevent_givempweaponxp(param_00,var_0F,var_10,param_02,param_01);
	self setplayerdata("common","sharedProgression","weaponLevel",var_03,"mpXP",var_0C);
	var_11 = function_02C4(param_00);
	scripts\mp\matchdata::func_AFDC(var_03,"xp",param_02,var_11);
	if(var_09 < var_10)
	{
		scripts\mp\hud_message::showsplash("ranked_up_weapon_" + var_03,var_10 + 1);
		var_12 = "weapon_rank_up_0_4";
		if(var_10 >= 15)
		{
			var_12 = "weapon_rank_up_15_plus";
		}
		else if(var_10 >= 10)
		{
			var_12 = "weapon_rank_up_10_14";
		}
		else if(var_10 >= 5)
		{
			var_12 = "weapon_rank_up_5_9";
		}

		var_13 = scripts\mp\rank::getscoreinfovalue(var_12);
		scripts\mp\rank::giverankxp(var_12,var_13);
	}
}

//Function Number: 18
remapscoreeventforweapon(param_00)
{
	switch(param_00)
	{
		case "kill":
			param_00 = "kill_weapon";
			break;

		case "challenge":
			param_00 = "weapon_challenge";
			break;
	}

	return param_00;
}

//Function Number: 19
addglobalweaponrankxpmultiplier(param_00,param_01)
{
	level addweaponrankxpmultiplier(param_00,param_01);
}

//Function Number: 20
getglobalweaponrankxpmultiplier()
{
	return level getweaponrankxpmultiplier();
}

//Function Number: 21
addweaponrankxpmultiplier(param_00,param_01)
{
	if(!isdefined(self.weaponrankxpmultipliers))
	{
		self.weaponrankxpmultipliers = [];
	}

	if(isdefined(self.weaponrankxpmultipliers[param_01]))
	{
		self.weaponrankxpmultipliers[param_01] = max(self.weaponrankxpmultipliers[param_01],param_00);
		return;
	}

	self.weaponrankxpmultipliers[param_01] = param_00;
}

//Function Number: 22
getweaponrankxpmultiplier()
{
	if(!isdefined(self.weaponrankxpmultipliers))
	{
		return 1;
	}

	var_00 = 1;
	foreach(var_02 in self.weaponrankxpmultipliers)
	{
		if(!isdefined(var_02))
		{
			continue;
		}

		var_00 = var_00 * var_02;
	}

	return var_00;
}

//Function Number: 23
removeglobalweaponrankxpmultiplier(param_00)
{
	level removeweaponrankxpmultiplier(param_00);
}

//Function Number: 24
removeweaponrankxpmultiplier(param_00)
{
	if(!isdefined(self.weaponrankxpmultipliers))
	{
		return;
	}

	if(!isdefined(self.weaponrankxpmultipliers[param_00]))
	{
		return;
	}

	self.rankxpmultipliers[param_00] = undefined;
}

//Function Number: 25
_meth_8233()
{
	var_00 = getweaponrankxpmultiplier();
	var_01 = getglobalweaponrankxpmultiplier();
	return var_00 * var_01;
}