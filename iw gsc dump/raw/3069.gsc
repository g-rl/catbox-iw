/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 3069.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 10
 * Decompile Time: 2 ms
 * Timestamp: 10/27/2023 12:26:06 AM
*******************************************************************/

//Function Number: 1
func_488D()
{
	self.meleerangesq = 9216;
	self.meleechargedist = 1000;
	self.meleechargedistvsplayer = 1000;
	self.var_B627 = 36;
	self.meleeactorboundsradius = 32;
	self.acceptablemeleefraction = 0.98;
	self.fnismeleevalid = ::func_9DA2;
}

//Function Number: 2
func_9DA0(param_00)
{
	if(isdefined(self.dontmelee))
	{
		return 0;
	}

	if(!isdefined(self.isnodeoccupied))
	{
		return 0;
	}

	if(isdefined(self.isnodeoccupied.dontmelee))
	{
		return 0;
	}

	if(isdefined(self._stealth) && !scripts/aitypes/melee::canmeleeduringstealth())
	{
		return 0;
	}

	if(isdefined(param_00) && param_00)
	{
		return 1;
	}

	if(scripts/aitypes/melee::func_9DD1())
	{
		return 0;
	}

	return 1;
}

//Function Number: 3
func_9D9F(param_00)
{
	if(!scripts/asm/asm_bb::bb_iscrawlmelee())
	{
		return level.failure;
	}

	return level.success;
}

//Function Number: 4
func_487C(param_00)
{
	if(randomint(100) < 25)
	{
		lib_0BFE::func_E1B1(randomintrange(3000,8000));
	}
	else
	{
		lib_0BFE::func_E1B2(randomintrange(3000,8000));
	}

	thread lib_0BFE::func_5671();
	func_488D();
	return level.success;
}

//Function Number: 5
func_487B()
{
	lib_0BFE::func_41DA();
	lib_0BFE::func_41DB();
	lib_0BFE::func_F6C7();
}

//Function Number: 6
func_FFDD(param_00)
{
	if(!func_9DA0(0))
	{
		func_487B();
		return level.failure;
	}

	if(![[ self.fnismeleevalid ]](self.isnodeoccupied,0))
	{
		func_487B();
		return level.failure;
	}

	return level.success;
}

//Function Number: 7
func_4881(param_00)
{
	self.bt.instancedata[param_00] = spawnstruct();
	self.bt.instancedata[param_00].var_3E30 = gettime() + 100;
	self.bt.instancedata[param_00].timeout = gettime() + 4000;
	self.bt.instancedata[param_00].var_6572 = self.isnodeoccupied.origin;
	self.melee.var_2AC7 = 1;
	self.melee.var_2AC6 = 1;
	self.var_B651 = 1;
	if(scripts/asm/asm_bb::bb_isselfdestruct() && isdefined(self.bt.var_F1F7))
	{
		self.bt.var_F1F7 stoploopsound();
		self.bt.var_F1F7 playloopsound("c6_mvmt_crawl_loop_vocal");
		return;
	}

	self playloopsound("c6_mvmt_crawl_loop_vocal");
}

//Function Number: 8
func_487A(param_00)
{
	self.melee.var_29B4 = 1;
	return level.success;
}

//Function Number: 9
func_488C(param_00)
{
	if(lib_0A0B::func_2EE1())
	{
		if(!isdefined(self.bt.var_487E))
		{
			self.bt.var_487E = 1;
			self.var_6D = 16;
			self _meth_8481(self.origin);
			thread lib_0BFE::func_F1F8();
		}

		return level.running;
	}

	return level.success;
}

//Function Number: 10
func_9DA2(param_00,param_01)
{
	if(scripts/aitypes/melee::ismeleevalid_common(param_00,param_01) == 0)
	{
		return 0;
	}

	if(param_01)
	{
		if(scripts\anim\utility_common::isusingsidearm())
		{
			return 0;
		}
	}

	if(isdefined(self.objective_position) && self.objective_additionalcurrent == 1)
	{
		return 0;
	}

	if(isdefined(param_00.var_5951) || isdefined(param_00.ignoreme) && param_00.ignoreme)
	{
		return 0;
	}

	if(!isai(param_00) && !isplayer(param_00))
	{
		return 0;
	}

	if(isdefined(self.var_B5DD) && isdefined(param_00.var_B5DD))
	{
		return 0;
	}

	if((isdefined(self.var_B5DD) && isdefined(param_00.var_B14F)) || isdefined(param_00.var_B5DD) && isdefined(self.var_B14F))
	{
		return 0;
	}

	if(isai(param_00))
	{
		if(param_00 _meth_81A6())
		{
			return 0;
		}

		if(param_00 scripts\sp\_utility::func_58DA() || param_00.var_EB)
		{
			return 0;
		}

		if(self.getcsplinepointtargetname != "none" || param_00.getcsplinepointtargetname != "none")
		{
			return 0;
		}

		if(param_00.unittype != "soldier" && param_00.unittype != "c6" && param_00.unittype != "c6i")
		{
			return 0;
		}
	}

	if(isplayer(param_00))
	{
		var_02 = param_00 getstance();
	}
	else
	{
		var_02 = param_01.a.pose;
	}

	if(var_02 != "stand" && var_02 != "crouch")
	{
		return 0;
	}

	if(isdefined(self.var_B14F) && isdefined(param_00.var_B14F))
	{
		return 0;
	}

	if(isdefined(param_00.objective_position))
	{
		return 0;
	}

	return 1;
}