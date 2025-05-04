/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\mp_agent.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 47
 * Decompile Time: 1728 ms
 * Timestamp: 10/27/2023 12:21:06 AM
*******************************************************************/

//Function Number: 1
init_agent(param_00)
{
	level.agent_definition = [];
	level.agent_available_to_spawn_time = [];
	level.agent_recycle_interval = 500;
	var_01 = [];
	var_01["species"] = 3;
	var_01["traversal_unit_type"] = 4;
	var_01["body_model"] = 5;
	var_01["animclass"] = 6;
	var_01["health"] = 7;
	var_01["xp"] = 8;
	var_01["reward"] = 9;
	var_01["behaviorTree"] = 10;
	var_01["asm"] = 11;
	var_01["radius"] = 12;
	var_01["height"] = 13;
	var_02 = 0;
	var_03 = 50;
	for(var_04 = var_02;var_04 <= var_03;var_04++)
	{
		var_05 = tablelookupbyrow(param_00,var_04,2);
		if(var_05 == "")
		{
			break;
		}

		var_06 = [];
		foreach(var_0B, var_08 in var_01)
		{
			var_09 = tablelookupbyrow(param_00,var_04,var_08);
			if(var_09 == "0")
			{
				var_09 = 0;
			}
			else if(int(var_09) != 0)
			{
				var_0A = var_09 + "";
				if(issubstr(var_0A,"."))
				{
					var_09 = float(var_09);
				}
				else
				{
					var_09 = int(var_09);
				}
			}

			var_06[var_0B] = var_09;
		}

		level.agent_definition[var_05] = var_06;
	}

	level notify("scripted_agents_initialized");
}

//Function Number: 2
func_F8ED()
{
	var_00 = level.agent_definition[self.agent_type];
	if(!isdefined(var_00["behaviorTree"]) || var_00["behaviorTree"] == "")
	{
		return;
	}

	scripts\mp\agents\_scriptedagents::func_197F(var_00["behaviorTree"],var_00["asm"]);
}

//Function Number: 3
func_FAFA(param_00)
{
	self.var_394 = param_00;
	self giveweapon(param_00);
	self setspawnweapon(param_00);
	self.bulletsinclip = weaponclipsize(param_00);
	self.primaryweapon = param_00;
}

//Function Number: 4
setup_spawn_struct(param_00)
{
	self.spawner = param_00;
}

//Function Number: 5
spawnnewagent(param_00,param_01,param_02,param_03,param_04,param_05)
{
	var_06 = getfreeagent(param_00);
	if(isdefined(var_06))
	{
		if(!isdefined(param_03))
		{
			param_03 = (0,0,0);
		}

		var_06.connecttime = gettime();
		if(isdefined(param_05))
		{
			var_06 setup_spawn_struct(param_05);
		}

		var_06 set_agent_model(var_06,param_00);
		var_06 set_agent_species(var_06,param_00);
		if(is_scripted_agent(param_00))
		{
			var_06 = spawn_scripted_agent(var_06,param_00,param_02,param_03);
		}
		else
		{
			var_06 = spawn_regular_agent(var_06,param_02,param_03);
		}

		var_06 setup_agent(param_00);
		var_06 set_agent_team(param_01);
		var_06 set_agent_spawn_health(var_06,param_00);
		var_06 set_agent_traversal_unit_type(var_06,param_00);
		var_06 addtocharactersarray();
		if(isdefined(param_04))
		{
			var_06 func_FAFA(param_04);
		}

		if(func_9CF8(param_00))
		{
			var_06 func_F8ED();
		}

		var_06 activateagent();
	}

	return var_06;
}

//Function Number: 6
set_agent_traversal_unit_type(param_00,param_01)
{
	if(!can_set_traversal_unit_type(param_00))
	{
		return;
	}

	param_00 _meth_828C(level.agent_definition[param_01]["traversal_unit_type"]);
}

//Function Number: 7
can_set_traversal_unit_type(param_00)
{
	if(is_agent_scripted(param_00))
	{
		return 1;
	}

	return 0;
}

//Function Number: 8
set_agent_model(param_00,param_01)
{
	var_02 = level.agent_definition[param_01]["setup_model_func"];
	if(isdefined(var_02))
	{
		param_00 [[ var_02 ]](param_01);
		return;
	}

	param_00 detachall();
	param_00 setmodel(level.agent_definition[param_01]["body_model"]);
	param_00 show();
}

//Function Number: 9
is_scripted_agent(param_00)
{
	return level.agent_definition[param_00]["animclass"] != "";
}

//Function Number: 10
func_9CF8(param_00)
{
	if(!isdefined(level.agent_definition[param_00]))
	{
		return 0;
	}

	return level.agent_definition[param_00]["behaviorTree"] != "";
}

//Function Number: 11
spawn_scripted_agent(param_00,param_01,param_02,param_03)
{
	param_00.onenteranimstate = param_00 speciesfunc("on_enter_animstate");
	param_00.is_scripted_agent = 1;
	var_04 = level.agent_definition[param_01]["radius"];
	if(!isdefined(var_04))
	{
		var_04 = 15;
	}

	var_05 = level.agent_definition[param_01]["height"];
	if(!isdefined(var_05))
	{
		var_05 = 50;
	}

	param_00 giveplaceable(param_02,param_03,level.agent_definition[param_01]["animclass"],var_04,var_05);
	param_00.var_18F4 = var_05;
	param_00.var_18F9 = var_04;
	return param_00;
}

//Function Number: 12
spawn_regular_agent(param_00,param_01,param_02)
{
	param_00.is_scripted_agent = 0;
	param_00 giveplaceable(param_01,param_02);
	return param_00;
}

//Function Number: 13
is_agent_scripted(param_00)
{
	return param_00.is_scripted_agent;
}

//Function Number: 14
agent_go_to_pos(param_00,param_01,param_02,param_03,param_04)
{
	if(is_agent_scripted(self))
	{
		self ghostskulls_complete_status(param_00);
		return;
	}

	self botsetscriptgoal(param_00,param_01,param_02,param_03,param_04);
}

//Function Number: 15
setup_agent(param_00)
{
	var_01 = level.agent_definition[param_00];
	if(!isdefined(var_01))
	{
		return;
	}

	var_02 = var_01["setup_func"];
	if(!isdefined(var_02))
	{
		return;
	}

	self [[ var_02 ]]();
}

//Function Number: 16
set_agent_species(param_00,param_01)
{
	if(!isdefined(level.agent_funcs[param_01]))
	{
		level.agent_funcs[param_01] = [];
	}

	param_00.species = level.agent_definition[param_01]["species"];
	if(!isdefined(level.species_funcs[param_00.species]) || !isdefined(level.species_funcs[param_00.species]["on_enter_animstate"]))
	{
		level.species_funcs[param_00.species] = [];
		level.species_funcs[param_00.species]["on_enter_animstate"] = ::func_5005;
	}

	assign_agent_func("spawn",::default_spawn_func);
	assign_agent_func("on_damaged",::default_on_damage);
	assign_agent_func("on_damaged_finished",::default_on_damage_finished);
	assign_agent_func("on_killed",::default_on_killed);
}

//Function Number: 17
assign_agent_func(param_00,param_01)
{
	var_02 = self.agent_type;
	if(!isdefined(level.agent_funcs[var_02][param_00]))
	{
		if(!isdefined(level.species_funcs[self.species]) || !isdefined(level.species_funcs[self.species][param_00]))
		{
			level.agent_funcs[var_02][param_00] = param_01;
			return;
		}

		level.agent_funcs[var_02][param_00] = level.species_funcs[self.species][param_00];
	}
}

//Function Number: 18
set_agent_spawn_health(param_00,param_01)
{
	param_00 set_agent_health(level.agent_definition[param_01]["health"]);
}

//Function Number: 19
get_agent_type(param_00)
{
	return param_00.agent_type;
}

//Function Number: 20
getfreeagentcount()
{
	if(!isdefined(level.agentarray))
	{
		return 0;
	}

	var_00 = gettime();
	var_01 = 0;
	foreach(var_03 in level.agentarray)
	{
		if(!isdefined(var_03.isactive) || !var_03.isactive)
		{
			if(isdefined(var_03.waitingtodeactivate) && var_03.waitingtodeactivate)
			{
				continue;
			}

			var_04 = var_03 getentitynumber();
			if(isdefined(level.agent_available_to_spawn_time) && isdefined(level.agent_available_to_spawn_time[var_04]) && var_00 < level.agent_available_to_spawn_time[var_04])
			{
				continue;
			}

			var_01++;
		}
	}

	return var_01;
}

//Function Number: 21
getfreeagent(param_00)
{
	var_01 = undefined;
	var_02 = gettime();
	if(isdefined(level.agentarray))
	{
		foreach(var_04 in level.agentarray)
		{
			if(!isdefined(var_04.isactive) || !var_04.isactive)
			{
				if(isdefined(var_04.waitingtodeactivate) && var_04.waitingtodeactivate)
				{
					continue;
				}

				var_05 = var_04 getentitynumber();
				if(isdefined(level.agent_available_to_spawn_time) && isdefined(level.agent_available_to_spawn_time[var_05]) && var_02 < level.agent_available_to_spawn_time[var_05])
				{
					continue;
				}

				level.agent_available_to_spawn_time[var_05] = undefined;
				var_01 = var_04;
				var_01.agent_type = param_00;
				var_01 initagentscriptvariables();
				var_01 notify("agent_in_use");
				break;
			}
		}
	}

	return var_01;
}

//Function Number: 22
initagentscriptvariables()
{
	self.pers = [];
	self.hasdied = 0;
	self.isactive = 0;
	self.spawntime = 0;
	self.entity_number = self getentitynumber();
	self.agent_gameparticipant = 0;
	self detachall();
	initplayerscriptvariables();
}

//Function Number: 23
initplayerscriptvariables()
{
	self.class = undefined;
	self.movespeedscaler = undefined;
	self.avoidkillstreakonspawntimer = undefined;
	self.guid = undefined;
	self.name = undefined;
	self.saved_actionslotdata = undefined;
	self.perks = undefined;
	self.weaponlist = undefined;
	self.objectivescaler = undefined;
	self.sessionteam = undefined;
	self.sessionstate = undefined;
	self.disabledweapon = undefined;
	self.disabledweaponswitch = undefined;
	self.disabledoffhandweapons = undefined;
	self.disabledusability = 1;
	self.nocorpse = undefined;
	self.ignoreme = 0;
	self.precacheleaderboards = 0;
	self.ten_percent_of_max_health = undefined;
	self.command_given = undefined;
	self.current_icon = undefined;
	self.do_immediate_ragdoll = undefined;
	if(isdefined(level.var_768B))
	{
		self [[ level.var_768B ]]();
	}
}

//Function Number: 24
set_agent_team(param_00,param_01)
{
	self.team = param_00;
	self.var_20 = param_00;
	self.pers["team"] = param_00;
	self.triggerportableradarping = param_01;
	self setotherent(param_01);
	self setentityowner(param_01);
}

//Function Number: 25
addtocharactersarray()
{
	for(var_00 = 0;var_00 < level.characters.size;var_00++)
	{
		if(level.characters[var_00] == self)
		{
			return;
		}
	}

	level.characters[level.characters.size] = self;
}

//Function Number: 26
agentfunc(param_00)
{
	return level.agent_funcs[self.agent_type][param_00];
}

//Function Number: 27
speciesfunc(param_00)
{
	return level.species_funcs[self.species][param_00];
}

//Function Number: 28
validateattacker(param_00)
{
	if(isagent(param_00) && !isdefined(param_00.isactive) || !param_00.isactive)
	{
		return undefined;
	}

	if(isagent(param_00) && !isdefined(param_00.classname))
	{
		return undefined;
	}

	return param_00;
}

//Function Number: 29
set_agent_health(param_00)
{
	self.var_1E = param_00;
	self.health = param_00;
	self.maxhealth = param_00;
}

//Function Number: 30
default_spawn_func(param_00,param_01,param_02)
{
}

//Function Number: 31
is_friendly_damage(param_00,param_01)
{
	if(isdefined(param_01))
	{
		if(isdefined(param_01.team) && param_01.team == param_00.team)
		{
			return 1;
		}

		if(isdefined(param_01.triggerportableradarping) && isdefined(param_01.triggerportableradarping.team) && param_01.triggerportableradarping.team == param_00.team)
		{
			return 1;
		}
	}

	return 0;
}

//Function Number: 32
default_on_damage(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B)
{
	var_0C = self;
	var_0D = level.agent_funcs[self.agent_type]["gametype_on_damaged"];
	if(isdefined(var_0D))
	{
		[[ var_0D ]](param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B);
	}

	if(is_friendly_damage(var_0C,param_00))
	{
		return;
	}

	var_0C [[ level.agent_funcs[var_0C.agent_type]["on_damaged_finished"] ]](param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,0,param_0A,param_0B);
}

//Function Number: 33
default_on_damage_finished(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B,param_0C)
{
	var_0D = self.health;
	if(isdefined(param_07))
	{
		var_0E = vectortoyaw(param_07);
		var_0F = self.angles[1];
		self.var_E3 = angleclamp180(var_0E - var_0F);
	}
	else
	{
		self.var_E3 = 0;
	}

	self.var_DD = param_08;
	self.var_DE = param_04;
	self.damagedby = param_01;
	self.var_DC = param_07;
	self.var_E1 = param_02;
	self.var_E2 = param_05;
	self.var_4D62 = param_06;
	self getrespawndelay(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,0,param_0B,param_0C);
	if(self.health > 0 && self.health < var_0D)
	{
		self notify("pain");
	}

	if(isalive(self) && isdefined(self.agent_type))
	{
		var_10 = level.agent_funcs[self.agent_type]["gametype_on_damage_finished"];
		if(isdefined(var_10))
		{
			[[ var_10 ]](param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B,param_0C);
		}
	}
}

//Function Number: 34
default_on_killed(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08)
{
	if(isdefined(level.var_C4BD))
	{
		self [[ level.var_C4BD ]](param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,0);
	}
	else
	{
		on_humanoid_agent_killed_common(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,0);
	}

	var_09 = level.agent_funcs[self.agent_type]["gametype_on_killed"];
	if(isdefined(var_09))
	{
		[[ var_09 ]](param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08);
	}

	deactivateagent();
}

//Function Number: 35
func_5005(param_00,param_01)
{
	self.aistate = param_01;
	switch(param_01)
	{
		case "traverse":
			self.do_immediate_ragdoll = 1;
			lib_0F3C::func_5AC0();
			self.do_immediate_ragdoll = 0;
			break;

		default:
			break;
	}

	cleardamagehistory();
}

//Function Number: 36
cleardamagehistory()
{
	self.recentdamages = [];
	self.damagelistindex = 0;
}

//Function Number: 37
deactivateagent()
{
	var_00 = self getentitynumber();
	level.agent_available_to_spawn_time[var_00] = gettime() + 500;
}

//Function Number: 38
getnumactiveagents(param_00)
{
	if(!isdefined(param_00))
	{
		param_00 = "all";
	}

	var_01 = getactiveagentsoftype(param_00);
	return var_01.size;
}

//Function Number: 39
getactiveagentsoftype(param_00)
{
	var_01 = [];
	if(!isdefined(level.agentarray))
	{
		return var_01;
	}

	foreach(var_03 in level.agentarray)
	{
		if(isdefined(var_03.isactive) && var_03.isactive)
		{
			if(param_00 == "all" || var_03.agent_type == param_00)
			{
				var_01[var_01.size] = var_03;
			}
		}
	}

	return var_01;
}

//Function Number: 40
getaliveagentsofteam(param_00)
{
	returnAgent = [];
	foreach(agent in level.agentarray)
	{
		if(isalive(agent) && isdefined(agent.team) && agent.team == param_00)
		{
			returnAgent[returnAgent.size] = agent;
		}
	}

	return returnAgent;
}

//Function Number: 41
getactiveagentsofspecies(param_00)
{
	var_01 = [];
	if(!isdefined(level.agentarray))
	{
		return var_01;
	}

	foreach(var_03 in level.agentarray)
	{
		if(isdefined(var_03.isactive) && var_03.isactive)
		{
			if(var_03.species == param_00)
			{
				var_01[var_01.size] = var_03;
			}
		}
	}

	return var_01;
}

//Function Number: 42
getaliveagents()
{
	var_00 = [];
	foreach(var_02 in level.agentarray)
	{
		if(isalive(var_02))
		{
			var_00[var_00.size] = var_02;
		}
	}

	return var_00;
}

//Function Number: 43
activateagent()
{
	self.isactive = 1;
	self.spawn_time = gettime();
}

//Function Number: 44
on_humanoid_agent_killed_common(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09)
{
	var_0A = self.var_164D[self.asmname].var_4BC0;
	var_0B = level.asm[self.asmname].states[var_0A];
	if(scripts/asm/asm_mp::func_2382(self.asmname,var_0B))
	{
		scripts/asm/asm::func_231E(self.asmname,var_0B,var_0A);
	}

	if(isdefined(self.nocorpse))
	{
		return;
	}

	var_0C = self;
	self.body = self getplayerviewmodelfrombody(param_08);
	if(should_do_immediate_ragdoll(self))
	{
		do_immediate_ragdoll(self.body);
		return;
	}

	thread delaystartragdoll(self.body,param_06,param_05,param_04,param_00,param_03);
}

//Function Number: 45
should_do_immediate_ragdoll(param_00)
{
	if(isdefined(param_00.do_immediate_ragdoll) && param_00.do_immediate_ragdoll)
	{
		return 1;
	}

	return 0;
}

//Function Number: 46
do_immediate_ragdoll(param_00)
{
	if(isdefined(param_00))
	{
		param_00 giverankxp();
	}
}

//Function Number: 47
delaystartragdoll(param_00,param_01,param_02,param_03,param_04,param_05)
{
	if(isdefined(param_00))
	{
		var_06 = param_00 _meth_8112();
		if(animhasnotetrack(var_06,"ignore_ragdoll"))
		{
			return;
		}
	}

	if(isdefined(level.noragdollents) && level.noragdollents.size)
	{
		foreach(var_08 in level.noragdollents)
		{
			if(distancesquared(param_00.origin,var_08.origin) < 65536)
			{
				return;
			}
		}
	}

	wait(0.2);
	if(!isdefined(param_00))
	{
		return;
	}

	if(param_00 _meth_81B7())
	{
		return;
	}

	var_06 = param_00 _meth_8112();
	var_0A = 0.35;
	if(animhasnotetrack(var_06,"start_ragdoll"))
	{
		var_0B = getnotetracktimes(var_06,"start_ragdoll");
		if(isdefined(var_0B))
		{
			var_0A = var_0B[0];
		}
	}

	var_0C = var_0A * getanimlength(var_06) - 0.2;
	if(var_0C > 0)
	{
		wait(var_0C);
	}

	if(isdefined(param_00))
	{
		if(isdefined(param_00.ragdollhitloc) && isdefined(param_00.ragdollimpactvector))
		{
			param_00 giverankxp_regularmp(param_00.ragdollhitloc,param_00.ragdollimpactvector);
			return;
		}

		param_00 giverankxp();
	}
}