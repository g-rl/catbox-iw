/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\bots\gametype_ctf.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 11
 * Decompile Time: 608 ms
 * Timestamp: 10/27/2023 12:11:53 AM
*******************************************************************/

//Function Number: 1
main()
{
	setup_callbacks();
	setup_bot_ctf();
}

//Function Number: 2
setup_callbacks()
{
	level.bot_funcs["crate_can_use"] = ::crate_can_use;
	level.bot_funcs["gametype_think"] = ::bot_ctf_think;
}

//Function Number: 3
setup_bot_ctf()
{
	scripts\mp\bots\_bots_util::bot_waittill_bots_enabled();
	level.teamflags["allies"].label = "allies";
	level.teamflags["axis"].label = "axis";
	var_00[0] = level.teamflags["allies"].curorigin;
	var_01[0] = "flag_" + level.teamflags["allies"].label;
	var_00[1] = level.teamflags["axis"].curorigin;
	var_01[1] = "flag_" + level.teamflags["axis"].label;
	scripts\mp\bots\_bots_util::func_2D18(var_00,var_01);
	var_02 = getzonenearest(level.teamflags["allies"].curorigin);
	if(isdefined(var_02))
	{
		function_002B(var_02,"allies");
	}

	var_02 = getzonenearest(level.teamflags["axis"].curorigin);
	if(isdefined(var_02))
	{
		function_002B(var_02,"axis");
	}

	level.bot_gametype_precaching_done = 1;
}

//Function Number: 4
crate_can_use(param_00)
{
	if(isagent(self) && !isdefined(param_00.boxtype))
	{
		return 0;
	}

	if(isdefined(self.carryflag))
	{
		return 0;
	}

	if(!level.teamflags[self.team] scripts\mp\_gameobjects::ishome())
	{
		return 0;
	}

	return 1;
}

//Function Number: 5
func_46BE()
{
	var_00 = 0;
	foreach(var_02 in level.participants)
	{
		if(!isdefined(var_02.team))
		{
			continue;
		}

		if(var_02 == self)
		{
			continue;
		}

		if(scripts\mp\_utility::isteamparticipant(var_02) && var_02.team == self.team)
		{
			var_00++;
		}
	}

	return var_00;
}

//Function Number: 6
bot_ctf_think()
{
	self notify("bot_ctf_think");
	self endon("bot_ctf_think");
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	while(!isdefined(level.bot_gametype_precaching_done))
	{
		wait(0.05);
	}

	init_bot_game_ctf();
	self.var_BF69 = gettime();
	self.var_BF3E = gettime();
	self botsetflag("separation",0);
	if(!isdefined(level.var_BF3F))
	{
		level.var_BF3F = gettime() - 100;
	}

	for(;;)
	{
		wait(0.05);
		if(gettime() >= level.var_BF3F)
		{
			func_12DC1();
			level.var_BF3F = gettime() + 100;
		}

		if(self.health <= 0)
		{
			continue;
		}

		if(!isdefined(self.role))
		{
			func_F319();
		}

		if(isdefined(self.carryflag))
		{
			clear_defend();
			if(!isdefined(level.var_6E28[level.otherteam[self.team]]) || scripts\engine\utility::istrue(level.capturecondition))
			{
				self botsetscriptgoal(level.capzones[self.team].curorigin,16,"critical");
			}
			else if(isdefined(level.var_6E28[level.otherteam[self.team]]) && func_46BE() == 0)
			{
				self botclearscriptgoal();
				self botsetscriptgoal(level.var_6E28[level.otherteam[self.team]].origin,256,"guard");
			}
			else if(gettime() > self.var_BF3E)
			{
				var_00 = getnodesinradius(level.capzones[self.team].curorigin,900,0,300);
				var_01 = self botnodepick(var_00,var_00.size * 0.15,"node_hide");
				if(isdefined(var_01))
				{
					self botsetscriptgoalnode(var_01,"critical");
				}

				self.var_BF3E = gettime() + 10000;
			}

			continue;
		}

		if(self.role == "attacker")
		{
			if(isdefined(level.var_6E28[self.team]))
			{
				if(!scripts\mp\bots\_bots_util::bot_is_bodyguarding())
				{
					scripts\mp\bots\_bots_strategy::bot_guard_player(level.var_6E28[self.team],400);
				}
			}
			else
			{
				clear_defend();
				self botsetscriptgoal(level.teamflags[level.otherteam[self.team]].curorigin,16,"guard");
			}

			continue;
		}

		if(!level.teamflags[self.team] scripts\mp\_gameobjects::ishome())
		{
			if(!isdefined(level.var_6E28[level.otherteam[self.team]]))
			{
				clear_defend();
				self botsetscriptgoal(level.teamflags[self.team].curorigin,16,"critical");
			}
			else
			{
				var_02 = level.var_6E28[level.otherteam[self.team]];
				if(gettime() > self.var_BF69 || self botcanseeentity(var_02))
				{
					clear_defend();
					self botsetscriptgoal(var_02.origin,16,"critical");
					self.var_BF69 = gettime() + randomintrange(4500,5500);
				}
			}

			continue;
		}

		if(!is_protecting_flag())
		{
			self botclearscriptgoal();
			var_03["entrance_points_index"] = "flag_" + level.teamflags[self.team].label;
			scripts\mp\bots\_bots_strategy::bot_protect_point(level.teamflags[self.team].curorigin,600,var_03);
		}
	}
}

//Function Number: 7
clear_defend()
{
	if(scripts\mp\bots\_bots_util::bot_is_defending())
	{
		scripts\mp\bots\_bots_strategy::bot_defend_stop();
	}
}

//Function Number: 8
is_protecting_flag()
{
	return scripts\mp\bots\_bots_util::bot_is_protecting();
}

//Function Number: 9
func_F319()
{
	self.role = level.var_BF57[self.team];
	if(level.var_BF57[self.team] == "attacker")
	{
		level.var_BF57[self.team] = "defender";
		return;
	}

	if(level.var_BF57[self.team] == "defender")
	{
		level.var_BF57[self.team] = "attacker";
	}
}

//Function Number: 10
init_bot_game_ctf()
{
	if(isdefined(level.bots_gametype_initialized) && level.bots_gametype_initialized)
	{
		return;
	}

	level.bots_gametype_initialized = 1;
	level.var_BF57["allies"] = "attacker";
	level.var_BF57["axis"] = "attacker";
	level.var_6E28 = [];
}

//Function Number: 11
func_12DC1()
{
	level.var_6E28["allies"] = undefined;
	level.var_6E28["axis"] = undefined;
	foreach(var_01 in level.participants)
	{
		if(isalive(var_01) && isdefined(var_01.carryflag))
		{
			level.var_6E28[var_01.team] = var_01;
		}
	}

	var_03 = [];
	var_04 = [];
	var_05 = [];
	var_06 = [];
	foreach(var_01 in level.participants)
	{
		if(isdefined(var_01.role))
		{
			if(var_01.team == "allies")
			{
				if(var_01.role == "attacker")
				{
					var_03[var_03.size] = var_01;
				}
				else if(var_01.role == "defender")
				{
					var_04[var_04.size] = var_01;
				}

				continue;
			}

			if(var_01.team == "axis")
			{
				if(var_01.role == "attacker")
				{
					var_05[var_05.size] = var_01;
					continue;
				}

				if(var_01.role == "defender")
				{
					var_06[var_06.size] = var_01;
				}
			}
		}
	}

	if(var_04.size > var_03.size)
	{
		scripts\engine\utility::random(var_04).role = undefined;
	}
	else if(var_03.size > var_04.size + 1)
	{
		scripts\engine\utility::random(var_03).role = undefined;
	}

	if(var_06.size > var_05.size)
	{
		scripts\engine\utility::random(var_06).role = undefined;
		return;
	}

	if(var_05.size > var_06.size + 1)
	{
		scripts\engine\utility::random(var_05).role = undefined;
	}
}