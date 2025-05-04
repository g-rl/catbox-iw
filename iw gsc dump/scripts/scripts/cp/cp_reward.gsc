/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\cp\cp_reward.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 4
 * Decompile Time: 252 ms
 * Timestamp: 10/27/2023 12:09:59 AM
*******************************************************************/

//Function Number: 1
give_attacker_kill_rewards(param_00,param_01)
{
	if(self.team == "allies")
	{
		return;
	}

	if(scripts\engine\utility::istrue(self.died_poorly))
	{
		return;
	}

	if(scripts\cp\cp_agent_utils::get_agent_type(self) == "elite" || scripts\cp\cp_agent_utils::get_agent_type(self) == "mammoth")
	{
		var_02 = get_reward_point_for_kill();
		foreach(var_04 in level.players)
		{
			givekillreward(var_04,var_02,"large");
		}

		return;
	}

	if(isdefined(self.attacker_damage) || isdefined(self.marked_by_hybrid))
	{
		if(isdefined(self.marked_by_hybrid))
		{
			foreach(var_06 in level.players)
			{
				if(isdefined(self.player_who_tagged) && self.player_who_tagged == var_06 && var_06 != var_03)
				{
					var_07 = getassistbonusamount();
					if(isdefined(level.cash_scalar))
					{
						var_07 = var_07 * level.cash_scalar;
					}

					givekillreward(var_06,var_07 * 2);
					var_06 scripts\cp\cp_persistence::eog_player_update_stat("assists",1);
					self.hybrid_assist = 1;
				}
			}
		}

		if(!isdefined(self.hybrid_assist))
		{
			var_09 = 0.1;
			var_0A = self.maxhealth * var_09;
			var_07 = getassistbonusamount();
			if(isdefined(level.cash_scalar))
			{
				var_07 = var_07 * level.cash_scalar;
			}

			foreach(var_0C in self.attacker_damage)
			{
				if(var_0C.player == var_04 || isdefined(var_04.triggerportableradarping) && var_0C.player == var_04.triggerportableradarping)
				{
					continue;
				}

				if(var_0C.var_DA >= var_0A)
				{
					if(isdefined(var_0C.player) && var_0C.player != var_04)
					{
						var_0C.player scripts\cp\cp_persistence::eog_player_update_stat("assists",1);
						givekillreward(var_0C.player,var_07);
					}
				}
			}
		}
	}

	if(!isdefined(var_04))
	{
		return;
	}

	if(!isplayer(var_04) && !isdefined(var_04.triggerportableradarping) || !isplayer(var_04.triggerportableradarping))
	{
		return;
	}

	var_0E = 0;
	if(isdefined(var_04.triggerportableradarping))
	{
		var_04 = var_04.triggerportableradarping;
		var_0E = 1;
	}

	var_02 = get_reward_point_for_kill();
	if(isdefined(var_04) && var_04 == "soft" && !var_05)
	{
		var_0E = int(var_0E * 1.5);
	}

	givekillreward(var_03,var_0E,"large",var_04);
}

//Function Number: 2
getassistbonusamount()
{
	return level.agent_definition[scripts\cp\cp_agent_utils::get_agent_type(self)]["reward"] * 0.5;
}

//Function Number: 3
get_reward_point_for_kill()
{
	return level.agent_definition[scripts\cp\cp_agent_utils::get_agent_type(self)]["reward"];
}

//Function Number: 4
givekillreward(param_00,param_01,param_02,param_03)
{
	var_04 = param_01 * level.cycle_reward_scalar;
	if(isdefined(level.cash_scalar))
	{
		var_04 = var_04 * level.cash_scalar;
	}

	param_00 scripts\cp\cp_persistence::give_player_currency(var_04,param_02,param_03);
	if(isdefined(level.zombie_xp))
	{
		param_00 scripts\cp\cp_persistence::give_player_xp(int(var_04));
	}

	if(scripts\engine\utility::flag_exist("cortex_started") && scripts\engine\utility::flag("cortex_started"))
	{
		if(isdefined(level.add_cortex_charge_func))
		{
			[[ level.add_cortex_charge_func ]](param_01);
		}
	}
}