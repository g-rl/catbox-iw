/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 3172.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 30
 * Decompile Time: 10 ms
 * Timestamp: 10/27/2023 12:26:24 AM
*******************************************************************/

//Function Number: 1
func_9D87(param_00,param_01,param_02,param_03)
{
	return isdefined(self.melee) && isdefined(self.melee.var_2FB1);
}

//Function Number: 2
func_D4CD(param_00)
{
	self endon(param_00 + "_finished");
	var_01 = 4900;
	var_02 = scripts/asm/asm_bb::bb_getmeleetarget();
	for(;;)
	{
		if(!isdefined(var_02))
		{
			break;
		}

		var_03 = distancesquared(self.origin,var_02.origin);
		if(var_03 <= var_01)
		{
			if(isdefined(self.melee))
			{
				self.melee.var_2FB1 = 1;
			}

			break;
		}

		wait(0.05);
	}
}

//Function Number: 3
donotetracks_vsplayer(param_00,param_01)
{
	for(;;)
	{
		self waittill(param_01,var_02);
		if(!isarray(var_02))
		{
			var_02 = [var_02];
		}

		foreach(var_10, var_04 in var_02)
		{
			switch(var_04)
			{
				case "end":
					break;
	
				case "stop":
					var_05 = scripts/asm/asm_bb::bb_getmeleetarget();
					if(!isdefined(var_05))
					{
						return;
					}
		
					if(!isalive(var_05))
					{
						return;
					}
		
					if(!isdefined(self.isnodeoccupied) || self.isnodeoccupied != var_05)
					{
						return;
					}
		
					var_06 = distancesquared(var_05.origin,self.origin);
					if(var_06 > 4096)
					{
						return;
					}
					break;
	
				case "fire":
					var_05 = scripts/asm/asm_bb::bb_getmeleetarget();
					if(!isdefined(var_05))
					{
						return;
					}
		
					if(isalive(var_05))
					{
						if(isplayer(var_05))
						{
							if(isdefined(self.var_B621))
							{
								var_07 = distance2dsquared(var_05.origin,self.origin);
							}
							else
							{
								var_07 = distancesquared(var_07.origin,self.origin);
							}
		
							var_08 = 4096;
							if(isdefined(self.var_B5E1))
							{
								var_08 = self.var_B5E1;
							}
		
							if(var_07 <= var_08)
							{
								var_09 = undefined;
								var_0A = undefined;
								var_0B = undefined;
								var_0C = 20;
								var_0D = 0.45;
								var_0E = 0.35;
								var_0F = isdefined(level.player.var_C337) && level.player.var_C337.var_19;
								if(self.var_394 == "none")
								{
									var_09 = self.var_12B7F;
								}
		
								if(self.unittype == "c8")
								{
									var_09 = self.var_3507;
									var_0A = 24;
									var_0B = 24;
									self playsound("c8_melee_shield_swing");
								}
		
								if(var_0F)
								{
									var_0C = 10;
									var_0D = 0.7;
									var_0E = 0.5;
									function_01C5("player_meleeDamageMultiplier",0.05);
								}
		
								self melee(undefined,var_09,sqrt(var_08),var_0A,var_0B);
								if(var_0F && self.unittype == "soldier")
								{
									self playsound("ai_melee_vs_shield");
								}
		
								if(isdefined(self.unittype) && self.unittype == "c6")
								{
									self playsound("c6_punch_impact_plr");
								}
								else if(isdefined(self.unittype) && self.unittype == "c8")
								{
									self playsound("c8_melee_shield_impact");
								}
		
								level.player func_D0EA(self.origin,var_0C);
								earthquake(0.45,0.35,level.player.origin,1000);
								level.player playrumbleonentity("damage_heavy");
								if(!var_0F)
								{
									level.player thread scripts\sp\_gameskill::func_2BDB(0.3,0.25);
									level.player viewkick(30,self.origin);
								}
								else
								{
									function_01C5("player_meleeDamageMultiplier",level.playermeleedamagemultiplier_dvar);
								}
							}
						}
						else
						{
							self melee();
						}
					}
					break;
	
				default:
					scripts\anim\notetracks::handlenotetrack(var_04,param_01);
					break;
			}
		}
	}
}

//Function Number: 4
func_D0EA(param_00,param_01)
{
	if(!self isonground())
	{
		param_01 = param_01 * 0.1;
	}

	var_02 = vectornormalize(self.origin + (0,0,45) - param_00);
	var_03 = var_02 * param_01 * 10;
	self setvelocity(var_03);
}

//Function Number: 5
func_B57F()
{
	var_00 = self.melee.target;
	if(isdefined(self.var_B5DD))
	{
		self.melee.var_13D8A = 1;
		var_00.melee.var_13D8A = 0;
		return;
	}
	else if(isdefined(var_00.var_B5DD))
	{
		self.melee.var_13D8A = 0;
		var_00.melee.var_13D8A = 1;
		return;
	}

	if(isdefined(self.var_B14F))
	{
		self.melee.var_13D8A = 1;
		var_00.melee.var_13D8A = 0;
		return;
	}

	if(isdefined(var_00.var_B14F))
	{
		self.melee.var_13D8A = 0;
		var_00.melee.var_13D8A = 1;
		return;
	}

	self.melee.var_13D8A = scripts\engine\utility::cointoss();
	var_00.melee.var_13D8A = !self.melee.var_13D8A;
}

//Function Number: 6
func_B5B6(param_00,param_01,param_02,param_03)
{
	if(!isdefined(self.melee))
	{
		return 1;
	}

	if(isdefined(self.melee.var_2720))
	{
		return 1;
	}

	if(!isdefined(self.melee.target))
	{
		return 1;
	}

	if(!isalive(self.melee.target))
	{
		return 1;
	}

	if(isdefined(self.melee.target.dontmelee) && self.melee.target.dontmelee)
	{
		return 1;
	}

	return 0;
}

//Function Number: 7
melee_shouldabort(param_00,param_01,param_02,param_03)
{
	if(!isdefined(self.melee))
	{
		return 1;
	}

	if(isdefined(self.melee.var_2720))
	{
		if(isdefined(self.melee.var_3321))
		{
			var_04 = scripts/asm/asm::func_232B(param_01,"melee_stop");
			if(var_04)
			{
				self.melee.var_312C = 1;
			}

			return var_04;
		}
		else if(isdefined(self.melee.var_11095))
		{
			var_05 = scripts/asm/asm::func_233F(param_02,"melee_stop");
			if(!isdefined(var_05))
			{
				self.melee.var_3321 = 1;
				return 0;
			}
			else
			{
				self.melee.var_312C = 1;
			}
		}

		return 1;
	}

	return 0;
}

//Function Number: 8
func_B5AD(param_00,param_01,param_02)
{
	self.melee.bcharge = 1;
	self.melee.var_B5DE = param_00;
	self.melee.var_22E6 = param_01;
	self.melee.var_29B0 = param_02;
}

//Function Number: 9
func_B573(param_00,param_01,param_02,param_03)
{
	return isdefined(self.melee.bcharge) && self.melee.bcharge;
}

//Function Number: 10
func_B571()
{
	self.melee.bcharge = undefined;
}

//Function Number: 11
func_B59A(param_00,param_01,param_02,param_03)
{
	if(self.melee.var_13D8A != param_03)
	{
		return 0;
	}

	return !func_B573();
}

//Function Number: 12
func_B5B8(param_00,param_01,param_02,param_03)
{
	return !isai(self.melee.target);
}

//Function Number: 13
func_B59B(param_00,param_01,param_02,param_03)
{
	var_04 = self.melee.target scripts/asm/asm_bb::bb_getcovernode();
	return var_04.type == param_03;
}

//Function Number: 14
func_38A0(param_00,param_01,param_02,param_03)
{
}

//Function Number: 15
func_67D6(param_00,param_01,param_02,param_03)
{
	var_04 = self.melee.target;
	if(isplayer(var_04))
	{
		return 0;
	}

	if(isdefined(var_04.var_596E) && var_04.var_596E)
	{
		return 0;
	}

	if(!isdefined(self.melee.var_13D8A) || !isdefined(var_04.melee.var_13D8A))
	{
		func_B57F();
	}

	var_05 = param_03[0];
	if(self.melee.var_13D8A != var_05)
	{
		return 0;
	}

	var_06 = self [[ self.var_7191 ]](param_00,param_02);
	var_07 = func_38A7(var_06);
	if(!var_07)
	{
		return 0;
	}

	var_08 = param_03[1];
	var_09 = 30;
	var_0A = angleclamp180(self.melee.var_10D6D[1] - self.angles[1]);
	if(abs(var_0A) > var_09)
	{
		return 0;
	}

	if(var_08)
	{
		var_0B = var_04.angles - (0,var_0A * 0.5,0);
		var_0C = function_00CE(var_04.origin,var_0B,var_06);
	}
	else
	{
		var_0C = self.melee.areanynavvolumesloaded;
		var_0B = self.melee.var_10D6D;
	}

	var_0D = self.origin - var_0C;
	var_0E = vectornormalize(var_04.origin - var_0C);
	var_0F = vectordot(var_0E,var_0D);
	if(var_0F > 12)
	{
		return 0;
	}

	if(var_08)
	{
		self.melee.var_10D6D = self.angles + (0,var_0A * 0.5,0);
		var_04.melee.var_10D6D = var_0B;
	}

	var_04.melee.var_331C = 1;
	return 1;
}

//Function Number: 16
func_38AA(param_00,param_01,param_02,param_03)
{
}

//Function Number: 17
func_38AB(param_00,param_01,param_02,param_03)
{
}

//Function Number: 18
func_38AC(param_00,param_01,param_02,param_03)
{
}

//Function Number: 19
func_38AD(param_00,param_01,param_02,param_03)
{
}

//Function Number: 20
func_38A8(param_00,param_01,param_02,param_03)
{
}

//Function Number: 21
func_38A9(param_00,param_01,param_02,param_03)
{
}

//Function Number: 22
func_38A7(param_00)
{
	var_01 = self.melee.target;
	var_02 = var_01.origin;
	var_03 = self.origin - var_02;
	var_04 = vectortoangles(var_03);
	var_05 = function_00CE(var_02,var_04,param_00);
	self.melee.areanynavvolumesloaded = var_05;
	self.melee.var_10D6D = function_00CD(var_02,var_04,param_00);
	var_01.melee.var_10E0E = var_04[1];
	return 1;
}

//Function Number: 23
func_38A6(param_00)
{
}

//Function Number: 24
func_B5D5(param_00,param_01,param_02)
{
}

//Function Number: 25
func_D4D6(param_00)
{
	self endon(param_00 + "_finished");
	self waittill("melee_exit");
	self unlink();
	if(scripts/asm/asm::func_232B(param_00,"melee_interact") && !scripts/asm/asm::func_232B(param_00,"melee_death"))
	{
		if(isdefined(self.melee.var_9A08))
		{
			self.melee.var_112E2 = !scripts/asm/asm::func_232B(param_00,"drop");
		}
		else
		{
			self.melee.var_112E2 = 1;
		}
	}

	if(!isdefined(self.melee.var_2BE6))
	{
		self.melee.var_2720 = 1;
	}
}

//Function Number: 26
func_B5B7(param_00,param_01,param_02,param_03)
{
	return isdefined(self.melee.var_112E2);
}

//Function Number: 27
func_B5B9(param_00,param_01,param_02,param_03)
{
	return isdefined(self.melee.var_312C);
}

//Function Number: 28
func_B5D7(param_00)
{
	self endon(param_00 + "_finished");
	self waittill("weapon_dropped",var_01);
	if(isdefined(var_01))
	{
		self.melee.var_5D3E = var_01;
	}
}

//Function Number: 29
func_B58E()
{
	self.melee = undefined;
	self.var_B647 = undefined;
	self.physics_setgravityragdollscalar = undefined;
}

//Function Number: 30
func_B590(param_00)
{
	if(issubstr(param_00,"ps_"))
	{
		var_01 = getsubstr(param_00,3);
		self playsound(var_01);
		return;
	}

	switch(var_01)
	{
		case "sync":
			if(!isdefined(self.melee.var_2720))
			{
				if(isdefined(self.melee.target))
				{
					if(isalive(self.melee.target))
					{
						self linktoblendtotag(self.melee.target,"tag_sync",1,1);
					}
				}
				else if(isdefined(self.melee.var_331C) && isdefined(self.melee.partner))
				{
					if(isalive(self.melee.partner))
					{
						self linktoblendtotag(self.melee.partner,"tag_sync",1,1);
					}
				}
			}
			break;

		case "unsync":
			if(isdefined(self.melee.var_71D3))
			{
				self [[ self.melee.var_71D3 ]]();
			}
			else
			{
				self unlink();
			}
			break;

		case "melee_interact":
			self.melee.var_112E3 = 1;
			break;

		case "melee_death":
			if(isdefined(self.melee.var_112E2))
			{
				return var_01;
			}
			return var_01;

		case "attach_knife":
			self attach("tactical_knife_iw7","TAG_INHAND",1);
			self.melee.var_8C04 = 1;
			break;

		case "detach_knife":
			self detach("tactical_knife_iw7","TAG_INHAND",1);
			self.melee.var_8C04 = undefined;
			break;

		case "stab":
			self playsound("melee_knife_hit_body");
			playfxontag(level._effect["melee_knife_ai"],self,"TAG_KNIFE_FX");
			break;

		case "melee_stop":
			break;
	}
}