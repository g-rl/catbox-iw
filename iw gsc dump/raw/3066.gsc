/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 3066.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 16
 * Decompile Time: 6 ms
 * Timestamp: 10/27/2023 12:26:05 AM
*******************************************************************/

//Function Number: 1
func_8987(param_00)
{
	if(!isdefined(param_00) || param_00 == 0)
	{
		scripts/asm/asm_bb::bb_requestcombatmovetype_facemotion();
		return;
	}

	if(param_00 == 1 || param_00 == 2)
	{
		if(self.bulletsinclip <= 0)
		{
			param_00 = 0;
		}
	}

	switch(param_00)
	{
		case 2:
			scripts/asm/asm_bb::func_295B();
			break;

		case 1:
			scripts/asm/asm_bb::bb_requestcombatmovetype_strafe();
			break;

		default:
			scripts/asm/asm_bb::bb_requestcombatmovetype_facemotion();
			break;
	}
}

//Function Number: 2
func_3E49(param_00)
{
	if(!isdefined(self.var_EF7D) && !isdefined(self.var_EF7A) && !isdefined(self.var_EF7C))
	{
		return level.failure;
	}

	func_8987(self.var_EF73);
	if(isdefined(self.isnodeoccupied))
	{
		if(isdefined(self.var_3123))
		{
			return level.failure;
		}

		if(isdefined(self.var_EF79) && self.var_EF79 > 0)
		{
			var_01 = self.var_EF79 * self.var_EF79;
			var_02 = distancesquared(self.origin,self.isnodeoccupied.origin);
			if(var_02 < var_01)
			{
				self.var_3123 = 1;
				return level.failure;
			}
		}
	}
	else
	{
		self.var_3123 = undefined;
	}

	if(isdefined(self.var_EF7E))
	{
		self ghostskulls_total_waves(self.var_EF7E);
		var_03 = self.var_EF7E;
	}
	else
	{
		var_03 = 4;
	}

	if(isdefined(self.var_EF7D))
	{
		self _meth_8484();
		self ghostskulls_complete_status(self.var_EF7D);
	}
	else if(isdefined(self.var_EF7A))
	{
		var_04 = distancesquared(self.origin,self.var_EF7A.origin);
		if(var_04 > var_03 * var_03)
		{
			self _meth_8484();
			self ghosts_attack_logic(self.var_EF7A);
		}
		else
		{
			return level.failure;
		}
	}
	else if(isdefined(self.var_EF7C))
	{
		self _meth_8484();
		self ghostshouldexplode(self.var_EF7C);
	}

	return level.success;
}

//Function Number: 3
func_930A(param_00)
{
	if(scripts/asm/asm_bb::bb_ismissingaleg())
	{
		return level.success;
	}

	return level.failure;
}

//Function Number: 4
func_930D(param_00)
{
	if(!scripts/asm/asm_bb::bb_ismissingaleg() || !isdefined(self.isnodeoccupied))
	{
		return level.failure;
	}

	var_01 = 0;
	if(scripts/asm/asm_bb::bb_moverequested())
	{
		var_01 = self pathdisttogoal();
	}

	if(var_01 == 0)
	{
		var_01 = distance2d(self.origin,self.isnodeoccupied.origin);
	}

	if(!scripts/aitypes/combat::hasammoinclip() || var_01 < self.forcefastcrawldist)
	{
		return level.success;
	}

	return level.failure;
}

//Function Number: 5
func_97FA(param_00)
{
	if(self.health > self.fastcrawlmaxhealth)
	{
		self.health = self.fastcrawlmaxhealth;
	}

	scripts/asm/asm_bb::func_2979(1);
	return level.success;
}

//Function Number: 6
func_5814()
{
	playfx(level._effect["sentry_explode_mp"],self.origin);
	earthquake(0.5,1,self.origin,512);
	radiusdamage(self.origin,self.explosionradius,self.explosiondamagemax,self.explosiondamagemax,self,"MOD_EXPLOSIVE");
	self suicide();
}

//Function Number: 7
func_5813(param_00)
{
	if(!isdefined(self.isnodeoccupied))
	{
		return level.failure;
	}

	var_01 = distancesquared(self.origin,self.isnodeoccupied.origin);
	if(var_01 < self.dismemberchargeexplodedistsq)
	{
		func_5814();
		return level.success;
	}

	return level.running;
}

//Function Number: 8
func_116F3(param_00)
{
	scripts/asm/asm_bb::func_2979(0);
}

//Function Number: 9
decidemovetype(param_00,param_01)
{
	if(isdefined(self.var_4F63))
	{
		[[ self.var_4F63 ]](param_00,param_01);
		return;
	}

	var_02 = gettime();
	if(self.last_enemy_sight_time < 0 || var_02 - self.last_enemy_sight_time < self.maxtimetostrafewithoutlos)
	{
		scripts/asm/asm_bb::bb_requestcombatmovetype_strafe();
		return;
	}

	self.strafeifwithindist = self.desiredenemydistmax + 100;
	if(param_01 < self.strafeifwithindist)
	{
		scripts/asm/asm_bb::bb_requestcombatmovetype_strafe();
		return;
	}

	scripts/asm/asm_bb::func_295B();
}

//Function Number: 10
func_9ED8()
{
	return 0;
}

//Function Number: 11
func_3DE6(param_00)
{
	if(!isdefined(self.isnodeoccupied))
	{
		if(isdefined(self.var_6571))
		{
			return level.failure;
		}

		if(!func_9ED8())
		{
			scripts/asm/asm_bb::bb_setshootparams(undefined);
			self clearpath();
		}

		return level.failure;
	}

	var_01 = gettime();
	if(isdefined(self.var_A938))
	{
		if(var_01 < self.var_A938 + 250)
		{
			return level.success;
		}
	}

	self.var_A938 = var_01;
	if(isdefined(self.last_enemy_seen) && isdefined(self.isnodeoccupied))
	{
		if(self.last_enemy_seen != self.isnodeoccupied)
		{
			self.last_enemy_sight_time = -99;
		}
	}
	else
	{
		self.last_enemy_sight_time = -99;
	}

	var_02 = 1;
	var_03 = self getpersstat(self.isnodeoccupied);
	var_04 = distance2d(self.origin,self.isnodeoccupied.origin);
	if(var_03)
	{
		var_02 = self canshoot(getdefaultenemychestpos());
	}
	else
	{
		var_02 = 0;
	}

	if(!var_02)
	{
		if(!scripts\engine\utility::istrue(self.var_3320))
		{
			decidemovetype(0,var_04);
			self _meth_8484();
			self ghostskulls_complete_status(self.isnodeoccupied.origin);
		}

		return level.success;
	}

	self.var_3320 = undefined;
	self.last_enemy_sight_time = gettime();
	self.last_enemy_seen = self.isnodeoccupied;
	if(var_04 > self.desiredenemydistmax)
	{
		decidemovetype(1,var_04);
		self _meth_8484();
		self ghostskulls_complete_status(self.isnodeoccupied.origin);
		return level.success;
	}

	if(var_04 < self.backawayenemydist)
	{
		var_01 = gettime();
		if(isdefined(self.var_A88C) && var_01 - self.var_A88C < 500 && isdefined(self.vehicle_getspawnerarray))
		{
			return level.success;
		}

		var_05 = vectornormalize(self.origin - self.isnodeoccupied.origin);
		var_06 = 100;
		var_07 = self.origin + var_05 * var_06;
		var_07 = getclosestpointonnavmesh(var_07,self);
		var_08 = var_07 - self.origin;
		var_08 = (var_08[0],var_08[1],0);
		var_09 = vectornormalize(var_08);
		var_0A = vectordot(var_09,var_05);
		if(var_0A > 0)
		{
			scripts/asm/asm_bb::bb_requestcombatmovetype_strafe();
			self _meth_8484();
			self ghostskulls_complete_status(var_07);
			return level.success;
		}
	}

	if(var_04 < self.desiredenemydistmin)
	{
		if(!func_9ED8())
		{
			self clearpath();
		}

		return level.success;
	}

	return level.success;
}

//Function Number: 12
picktargetingfunction()
{
	if(isdefined(self.isnodeoccupied) && isdefined(self.isnodeoccupied.dismember_crawl) && self.isnodeoccupied.dismember_crawl)
	{
		if(isdefined(self.var_3402))
		{
			return self.var_3402;
		}
	}

	var_00 = 0;
	var_01 = randomint(100);
	for(var_02 = 0;var_02 < self.var_3403.size;var_02++)
	{
		var_03 = self.var_3403[var_02];
		if(var_01 < var_03 + var_00)
		{
			return self.var_3404[var_02];
		}

		var_00 = var_00 + var_03;
	}

	return undefined;
}

//Function Number: 13
func_7E8E()
{
	var_00 = self.isnodeoccupied gettagorigin("j_head");
	return var_00;
}

//Function Number: 14
getdefaultenemychestpos()
{
	if(scripts\engine\utility::istrue(self.dismember_crawl))
	{
		return func_7E8E();
	}

	var_00 = 70;
	var_01 = 15;
	if(isdefined(self.isnodeoccupied.var_18F4))
	{
		var_00 = self.isnodeoccupied.var_18F4;
		var_01 = self.isnodeoccupied.var_18F9;
	}

	var_02 = var_00 * 0.75;
	var_03 = (0,0,var_02);
	var_04 = self.isnodeoccupied.origin + var_03;
	return var_04;
}

//Function Number: 15
updatetarget(param_00)
{
	if(!isdefined(self.var_3404))
	{
		return scripts/aitypes/combat::func_12EC2(param_00);
	}

	if(isdefined(self.isnodeoccupied))
	{
		self.doentitiessharehierarchy = undefined;
		if(!isdefined(self.fncustomtargetingfunc) || !isdefined(self.nexttargetchangetime) || gettime() > self.nexttargetchangetime)
		{
			self.fncustomtargetingfunc = picktargetingfunction();
			self.nexttargetchangetime = gettime() + randomintrange(1500,2500);
		}

		if(isdefined(self.fncustomtargetingfunc))
		{
			var_01 = self [[ self.fncustomtargetingfunc ]]();
			if(!self canshoot(var_01))
			{
				var_01 = getdefaultenemychestpos();
			}
		}
		else
		{
			var_01 = getdefaultenemychestpos();
		}

		self.setplayerignoreradiusdamage = var_01;
	}
	else
	{
		scripts/asm/asm_bb::bb_setshootparams(undefined);
		self.setplayerignoreradiusdamage = undefined;
		self.nexttargetchangetime = undefined;
	}

	return level.success;
}

//Function Number: 16
func_3401(param_00)
{
	if(!isdefined(self.setplayerignoreradiusdamage))
	{
		return scripts/aitypes/combat::func_FE88(param_00);
	}

	if(scripts/asm/asm::asm_ephemeraleventfired("shoot","shoot_finished"))
	{
		return level.success;
	}

	var_01 = self.bt.shootparams;
	if(self getpersstat(self.isnodeoccupied))
	{
		self.doentitiessharehierarchy = undefined;
		var_01.pos = self.setplayerignoreradiusdamage;
		var_01.ent = undefined;
	}
	else if(isdefined(self.goodshootpos))
	{
		var_01.pos = self.goodshootpos;
		var_01.ent = undefined;
	}
	else
	{
		return level.success;
	}

	if(!isdefined(var_01.objective))
	{
		var_01.objective = "normal";
	}

	scripts/asm/asm_bb::bb_setshootparams(var_01,self.isnodeoccupied);
	if(scripts/aitypes/combat::isaimedataimtarget())
	{
		if(!self.bt.m_bfiring)
		{
			scripts/aitypes/combat::resetmisstime_code();
			scripts/aitypes/combat::chooseshootstyle(var_01);
			scripts/aitypes/combat::choosenumshotsandbursts(var_01);
		}

		scripts/aitypes/combat::func_3EF8(var_01);
		self.bt.m_bfiring = 1;
	}
	else
	{
		self.bt.m_bfiring = 0;
	}

	if(!isdefined(var_01.pos) && !isdefined(var_01.ent))
	{
		return level.success;
	}

	scripts/asm/asm_bb::bb_requestfire(self.bt.m_bfiring);
	return level.running;
}