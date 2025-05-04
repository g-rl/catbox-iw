/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\killstreaks\_juggernaut.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 14
 * Decompile Time: 779 ms
 * Timestamp: 10/27/2023 12:28:57 AM
*******************************************************************/

//Function Number: 1
init()
{
	level.var_A4AD = [];
	level.var_A4AD["juggernaut"] = spawnstruct();
	level.var_A4AD["juggernaut"].var_10A41 = "used_juggernaut";
	level.var_A4AD["juggernaut_recon"] = spawnstruct();
	level.var_A4AD["juggernaut_recon"].var_10A41 = "used_juggernaut_recon";
	level.var_A4AD["juggernaut_maniac"] = spawnstruct();
	level.var_A4AD["juggernaut_maniac"].var_10A41 = "used_juggernaut_maniac";
	level thread func_13AB0();
}

//Function Number: 2
givejuggernaut(param_00)
{
	self endon("death");
	self endon("disconnect");
	wait(0.05);
	if(isdefined(self.lightarmorhp))
	{
		scripts\mp\perks\_perkfunctions::unsetlightarmor();
	}

	scripts\mp\_weapons::func_5608();
	if(scripts\mp\_utility::_hasperk("specialty_explosivebullets"))
	{
		scripts\mp\_utility::removeperk("specialty_explosivebullets");
	}

	self.health = self.maxhealth;
	var_01 = 1;
	switch(param_00)
	{
		case "juggernaut":
			self.isjuggernaut = 1;
			self.var_A4AA = 0.8;
			scripts\mp\_class::giveloadout(self.pers["team"],param_00,0);
			self.movespeedscaler = 0.8;
			scripts\mp\_utility::giveperk("specialty_scavenger");
			scripts\mp\_utility::giveperk("specialty_quickdraw");
			scripts\mp\_utility::giveperk("specialty_detectexplosive");
			scripts\mp\_utility::giveperk("specialty_sharp_focus");
			scripts\mp\_utility::giveperk("specialty_radarjuggernaut");
			break;

		case "juggernaut_recon":
			self.isjuggernautrecon = 1;
			self.var_A4AA = 0.8;
			scripts\mp\_class::giveloadout(self.pers["team"],param_00);
			self.movespeedscaler = 0.8;
			scripts\mp\_utility::giveperk("specialty_scavenger");
			scripts\mp\_utility::giveperk("specialty_coldblooded");
			scripts\mp\_utility::giveperk("specialty_noscopeoutline");
			scripts\mp\_utility::giveperk("specialty_detectexplosive");
			scripts\mp\_utility::giveperk("specialty_sharp_focus");
			scripts\mp\_utility::giveperk("specialty_radarjuggernaut");
			if(!isagent(self))
			{
				self makeportableradar(self);
				scripts\mp\_missions::processchallenge("ch_airdrop_juggernaut_recon");
			}
			break;

		case "juggernaut_maniac":
			self.isjuggernautmaniac = 1;
			self.var_A4AA = 1.15;
			scripts\mp\_class::giveloadout(self.pers["team"],param_00,0);
			scripts\mp\_utility::giveperk("specialty_blindeye");
			scripts\mp\_utility::giveperk("specialty_coldblooded");
			scripts\mp\_utility::giveperk("specialty_noscopeoutline");
			scripts\mp\_utility::giveperk("specialty_detectexplosive");
			scripts\mp\_utility::giveperk("specialty_marathon");
			scripts\mp\_utility::giveperk("specialty_falldamage");
			self.movespeedscaler = 1.15;
			break;

		default:
			var_01 = self [[ level.var_B331 ]](param_00);
			break;
	}

	if(func_CA4E("specialty_hardline"))
	{
		scripts\mp\_utility::giveperk("specialty_hardline");
	}

	scripts\mp\_weapons::updatemovespeedscale();
	self disableweaponpickup();
	if(!isagent(self))
	{
		if(var_01)
		{
			self setclientomnvar("ui_juggernaut",1);
			thread scripts\mp\_utility::teamplayercardsplash(level.var_A4AD[param_00].var_10A41,self);
			thread func_A4A9();
			thread func_139F1();
			thread func_13A13();
		}
	}

	if(self.streaktype == "specialist")
	{
		thread scripts\mp\killstreaks\_killstreaks::func_41C0();
	}

	thread func_A4AC();
	if(isdefined(self.carryflag))
	{
		wait(0.05);
		self attach(self.carryflag,"J_spine4",1);
	}

	level notify("juggernaut_equipped",self);
	scripts\mp\_matchdata::logkillstreakevent(param_00,self.origin);
}

//Function Number: 3
func_CA4E(param_00)
{
	var_01 = self.pers["loadoutPerks"];
	foreach(var_03 in var_01)
	{
		if(var_03 == param_00)
		{
			return 1;
		}
	}

	return 0;
}

//Function Number: 4
func_A4A9()
{
	level endon("game_ended");
	self endon("death");
	self endon("disconnect");
	self endon("jugg_removed");
	for(;;)
	{
		wait(3);
		scripts\mp\_utility::playplayerandnpcsounds(self,"juggernaut_breathing_player","juggernaut_breathing_sound");
	}
}

//Function Number: 5
func_13AB0()
{
	level endon("game_ended");
	for(;;)
	{
		level waittill("host_migration_end");
		foreach(var_01 in level.players)
		{
			if(isai(var_01))
			{
				continue;
			}
			else
			{
				if(var_01 scripts\mp\_utility::isjuggernaut() && !isdefined(var_01.isjuggernautlevelcustom) && var_01.isjuggernautlevelcustom)
				{
					var_01 setclientomnvar("ui_juggernaut",1);
					continue;
				}

				var_01 setclientomnvar("ui_juggernaut",0);
			}
		}
	}
}

//Function Number: 6
func_A4AC()
{
	level endon("game_ended");
	self endon("disconnect");
	self endon("jugg_removed");
	thread func_A4AB();
	scripts\engine\utility::waittill_any_3("death","joined_team","joined_spectators","lost_juggernaut");
	self enableweaponpickup();
	self.isjuggernaut = 0;
	self.isjuggernautdef = 0;
	self.isjuggernautgl = 0;
	self.isjuggernautrecon = 0;
	self.isjuggernautmaniac = 0;
	self.isjuggernautlevelcustom = 0;
	if(isplayer(self))
	{
		self setclientomnvar("ui_juggernaut",0);
	}

	self unsetperk("specialty_radarjuggernaut",1);
	self notify("jugg_removed");
}

//Function Number: 7
func_A4AB()
{
	self endon("disconnect");
	self endon("jugg_removed");
	level waittill("game_ended");
	if(isplayer(self))
	{
		self setclientomnvar("ui_juggernaut",0);
	}
}

//Function Number: 8
func_F766()
{
	if(isdefined(self.headmodel))
	{
		self detach(self.headmodel,"");
		self.headmodel = undefined;
	}

	self setmodel("mp_fullbody_juggernaut_heavy_black");
	self givegoproattachments("viewhands_juggernaut_ally");
	self give_explosive_touch_on_revived("vestheavy");
}

//Function Number: 9
func_F767()
{
	if(isdefined(self.headmodel))
	{
		self detach(self.headmodel,"");
		self.headmodel = undefined;
	}

	self setmodel("mp_fullbody_heavy");
	self givegoproattachments("viewhands_juggernaut_ally");
	self attach("mp_warfighter_head_1","",1);
	self.headmodel = "mp_warfighter_head_1";
	self give_explosive_touch_on_revived("nylon");
}

//Function Number: 10
func_55F4()
{
	if(scripts\mp\_utility::isjuggernaut())
	{
		self.var_A4A4 = 1;
		self setclientomnvar("ui_juggernaut",0);
	}
}

//Function Number: 11
func_626C()
{
	if(scripts\mp\_utility::isjuggernaut())
	{
		self.var_A4A4 = undefined;
		self setclientomnvar("ui_juggernaut",1);
	}
}

//Function Number: 12
func_139F1()
{
	self endon("death");
	self endon("disconnect");
	self endon("jugg_removed");
	level endon("game_ended");
	for(;;)
	{
		if(!isdefined(self.var_A4A4) && scripts\mp\_utility::isusingremote())
		{
			self waittill("black_out_done");
			func_55F4();
		}

		wait(0.05);
	}
}

//Function Number: 13
func_13A13()
{
	self endon("death");
	self endon("disconnect");
	self endon("jugg_removed");
	level endon("game_ended");
	for(;;)
	{
		if(isdefined(self.var_A4A4) && !scripts\mp\_utility::isusingremote())
		{
			func_626C();
		}

		wait(0.05);
	}
}

//Function Number: 14
func_988F(param_00,param_01,param_02,param_03)
{
	level.var_B331 = param_00;
	level.var_B333 = param_01;
	level.var_B332 = param_03;
	game["allies_model"]["JUGGERNAUT_CUSTOM"] = param_02;
	game["axis_model"]["JUGGERNAUT_CUSTOM"] = param_02;
}