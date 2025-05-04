/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 2576.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 6
 * Decompile Time: 1 ms
 * Timestamp: 10/27/2023 12:23:23 AM
*******************************************************************/

//Function Number: 1
func_9898(param_00)
{
	self.meleerangesq = 12100;
	self.meleechargedist = 160;
	self.meleechargedistvsplayer = 200;
	self.meleechargedistreloadmultiplier = 1;
	self.var_B627 = 36;
	self.meleeactorboundsradius = 32;
	self.acceptablemeleefraction = 0.98;
	self.fnismeleevalid = ::ismeleevalid;
	self.fncanmovefrompointtopoint = ::canmovefrompointtopoint;
	return level.success;
}

//Function Number: 2
func_3376(param_00)
{
	self.meleerangesq = 5184;
	self.meleechargedist = 160;
	self.meleechargedistvsplayer = 200;
	self.meleechargedistreloadmultiplier = 1;
	self.var_B627 = 36;
	self.meleeactorboundsradius = 40;
	self.acceptablemeleefraction = 0.98;
	self.fnismeleevalid = ::func_3381;
	self.fncanmovefrompointtopoint = ::canmovefrompointtopoint;
	return level.success;
}

//Function Number: 3
func_F13B(param_00)
{
	self.meleerangesq = 5184;
	self.meleechargedist = 256;
	self.meleechargedistvsplayer = 512;
	self.meleechargedistreloadmultiplier = 1;
	self.var_B627 = 36;
	self.meleeactorboundsradius = 40;
	self.acceptablemeleefraction = 0.98;
	self.fnismeleevalid = ::ismeleevalid;
	self.fncanmovefrompointtopoint = ::canmovefrompointtopoint;
	return level.success;
}

//Function Number: 4
canmovefrompointtopoint(param_00,param_01)
{
	return self maymovefrompointtopoint(param_00,param_01,0,1);
}

//Function Number: 5
func_3381(param_00,param_01)
{
	if(isai(param_00))
	{
		if(param_00.unittype != "soldier")
		{
			return 0;
		}
	}

	return ismeleevalid(param_00,param_01);
}

//Function Number: 6
ismeleevalid(param_00,param_01)
{
	if(!scripts/aitypes/melee::ismeleevalid_common(param_00,param_01))
	{
		return 0;
	}

	if(param_01)
	{
		if(isdefined(self.a.onback) || self.a.pose == "prone")
		{
			return 0;
		}

		if(isdefined(self.unittype) && self.unittype == "seeker")
		{
			if(!isplayer(self.triggerportableradarping) && !lib_0F3D::func_B575(self.unittype))
			{
				return 0;
			}
		}
		else
		{
			if(scripts\anim\utility_common::isusingsidearm() && !isplayer(param_00))
			{
				return 0;
			}

			if(!lib_0F3D::func_B575(self.unittype,1))
			{
				return 0;
			}
		}
	}

	if(isdefined(self.objective_position) && self.objective_additionalcurrent == 1)
	{
		return 0;
	}

	if(isdefined(self.var_A985) && self.isnodeoccupied == self.var_A985 && gettime() <= self.var_BF90)
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

		if(self.unittype == "soldier" && param_00.unittype == "c6")
		{
			return 0;
		}

		if(self.unittype == "c6" && param_00.unittype == "c6i")
		{
			return 0;
		}

		if(param_00.unittype != "soldier" && param_00.unittype != "c6" && param_00.unittype != "c6i" && param_00.unittype != "civilian")
		{
			return 0;
		}
	}

	if(!isdefined(self.var_B622) || !self.var_B622 || !isplayer(param_00))
	{
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