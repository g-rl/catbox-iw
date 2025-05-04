/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\agents\_agents.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 12
 * Decompile Time: 473 ms
 * Timestamp: 10/27/2023 12:32:10 AM
*******************************************************************/

//Function Number: 1
main()
{
	if(isdefined(level.createfx_enabled) && level.createfx_enabled)
	{
		return;
	}

	setup_callbacks();
	level.badplace_cylinder_func = ::badplace_cylinder;
	level.badplace_delete_func = ::badplace_delete;
	scripts\mp\mp_agent::init_agent("mp/default_agent_definition.csv");
	lib_0F6E::registerscriptedagent();
	level thread scripts\mp\agents\_agent_common::init();
	level thread scripts\mp\killstreaks\_agent_killstreak::init();
}

//Function Number: 2
setup_callbacks()
{
	if(!isdefined(level.agent_funcs))
	{
		level.agent_funcs = [];
	}

	level.agent_funcs["player"] = [];
	level.agent_funcs["player"]["spawn"] = ::spawn_agent_player;
	level.agent_funcs["player"]["think"] = ::scripts\mp\bots\gametype_war::bot_war_think;
	level.agent_funcs["player"]["on_killed"] = ::on_agent_player_killed;
	level.agent_funcs["player"]["on_damaged"] = ::on_agent_player_damaged;
	level.agent_funcs["player"]["on_damaged_finished"] = ::agent_damage_finished;
	lib_0F6E::setupcallbacks();
	scripts/mp/equipment/phase_split::func_CAC9();
	scripts\mp\killstreaks\_agent_killstreak::setup_callbacks();
	scripts\mp\killstreaks\_rc8::setup_callbacks();
}

//Function Number: 3
wait_till_agent_funcs_defined()
{
	while(!isdefined(level.agent_funcs))
	{
		wait(0.05);
	}
}

//Function Number: 4
add_humanoid_agent(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B,param_0C,param_0D)
{
	var_0E = scripts\mp\agents\_agent_common::connectnewagent(param_00,param_01,param_02);
	if(isdefined(param_09))
	{
		var_0E.classcallback = param_09;
	}

	if(isdefined(var_0E))
	{
		var_0E thread [[ var_0E scripts/mp/agents/agent_utility::agentfunc("spawn") ]](param_03,param_04,param_05,param_06,param_07,param_08,param_0A,param_0B,param_0C,param_0D);
	}

	return var_0E;
}

//Function Number: 5
spawn_agent_player(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09)
{
	self endon("disconnect");
	while(!isdefined(level.getspawnpoint))
	{
		scripts\engine\utility::waitframe();
	}

	if(self.hasdied)
	{
		wait(randomintrange(6,10));
	}

	scripts/mp/agents/agent_utility::initplayerscriptvariables(1);
	if(isdefined(param_00) && isdefined(param_01))
	{
		var_0A = param_00;
		var_0B = param_01;
		self.lastspawnpoint = spawnstruct();
		self.lastspawnpoint.origin = var_0A;
		self.lastspawnpoint.angles = var_0B;
	}
	else
	{
		var_0C = self [[ level.getspawnpoint ]]();
		var_0A = var_0C.origin;
		var_0B = var_0C.angles;
		self.lastspawnpoint = var_0C;
	}

	scripts/mp/agents/agent_utility::activateagent();
	self.lastspawntime = gettime();
	self.spawntime = gettime();
	var_0D = var_0A + (0,0,25);
	var_0E = var_0A;
	var_0F = playerphysicstrace(var_0D,var_0E);
	if(distancesquared(var_0F,var_0D) > 1)
	{
		var_0A = var_0F;
	}

	self giveplaceable(var_0A,var_0B);
	if(isdefined(param_03) && param_03)
	{
		scripts\mp\bots\_bots_personality::bot_assign_personality_functions();
	}
	else
	{
		scripts\mp\bots\_bots_util::bot_set_personality("default");
	}

	if(isdefined(param_05))
	{
		scripts\mp\bots\_bots_util::bot_set_difficulty(param_05);
	}

	initplayerclass();
	scripts\mp\agents\_agent_common::set_agent_health(100);
	if(isdefined(param_04) && param_04)
	{
		self.respawn_on_death = 1;
	}

	if(isdefined(param_02))
	{
		scripts/mp/agents/agent_utility::set_agent_team(param_02.team,param_02);
	}

	if(isdefined(self.triggerportableradarping))
	{
		thread destroyonownerdisconnect(self.triggerportableradarping);
	}

	thread scripts\mp\_flashgrenades::func_B9D9();
	self getrank(0);
	self takeallweapons();
	self [[ level.onspawnplayer ]]();
	if(!scripts\mp\_utility::istrue(param_06))
	{
		scripts\mp\_class::giveloadout(self.team,self.class,1);
	}

	thread scripts\mp\bots\_bots::bot_think_watch_enemy(1);
	thread scripts\mp\bots\_bots::bot_think_crate();
	if(self.agent_type == "player")
	{
		thread scripts\mp\bots\_bots::bot_think_level_acrtions();
	}
	else if(self.agent_type == "odin_juggernaut")
	{
		thread scripts\mp\bots\_bots::bot_think_level_acrtions(128);
	}

	thread scripts\mp\bots\_bots_strategy::bot_think_tactical_goals();
	self thread [[ scripts/mp/agents/agent_utility::agentfunc("think") ]]();
	if(!self.hasdied)
	{
		scripts\mp\_spawnlogic::addtoparticipantsarray();
	}

	self.hasdied = 0;
	if(!scripts\mp\_utility::istrue(param_07))
	{
		thread scripts\mp\_weapons::onplayerspawned();
	}

	if(!scripts\mp\_utility::istrue(param_08))
	{
		thread scripts\mp\_healthoverlay::playerhealthregen();
	}

	if(!scripts\mp\_utility::istrue(param_09))
	{
		thread scripts\mp\_battlechatter_mp::onplayerspawned();
	}

	level notify("spawned_agent_player",self);
	level notify("spawned_agent",self);
	self notify("spawned_player");
}

//Function Number: 6
destroyonownerdisconnect(param_00)
{
	self endon("death");
	param_00 waittill("killstreak_disowned");
	self notify("owner_disconnect");
	if(scripts\mp\_hostmigration::waittillhostmigrationdone())
	{
		wait(0.05);
	}

	self suicide();
}

//Function Number: 7
agent_damage_finished(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B)
{
	if(isalive(self))
	{
		if(isdefined(param_00) || isdefined(param_01))
		{
			if(!isdefined(param_00))
			{
				param_00 = param_01;
			}

			if(isdefined(self.allowvehicledamage) && !self.allowvehicledamage)
			{
				if(isdefined(param_00.classname) && param_00.classname == "script_vehicle")
				{
					return 0;
				}
			}

			if(isdefined(param_00.classname) && param_00.classname == "auto_turret")
			{
				param_01 = param_00;
			}

			if(isdefined(param_01) && param_04 != "MOD_FALLING" && param_04 != "MOD_SUICIDE")
			{
				if(level.teambased)
				{
					if(isdefined(param_01.team) && param_01.team != self.team)
					{
						self give_ammo(param_01);
					}
				}
				else
				{
					self give_ammo(param_01);
				}
			}
		}

		self getrespawndelay(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,0,param_0A,param_0B);
		if(!isdefined(self.isactive))
		{
			self.waitingtodeactivate = 1;
		}

		return 1;
	}
}

//Function Number: 8
on_agent_generic_damaged(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B)
{
	var_0C = isdefined(param_01) && isdefined(self.triggerportableradarping) && self.triggerportableradarping == param_01;
	var_0D = scripts\mp\_utility::attackerishittingteam(self.triggerportableradarping,param_01) || var_0C;
	if(!var_0C && self.agent_type == "playerProxy")
	{
		if(level.teambased && var_0D && !level.friendlyfire)
		{
			return 0;
		}

		if(!level.teambased && var_0C)
		{
			return 0;
		}
	}

	if(isdefined(param_04) && param_04 == "MOD_CRUSH" && isdefined(param_00) && isdefined(param_00.classname) && param_00.classname == "script_vehicle")
	{
		return 0;
	}

	if(!isdefined(self) || !scripts\mp\_utility::isreallyalive(self))
	{
		return 0;
	}

	if(isdefined(param_01) && param_01.classname == "script_origin" && isdefined(param_01.type) && param_01.type == "soft_landing")
	{
		return 0;
	}

	if(param_05 == "killstreak_emp_mp")
	{
		return 0;
	}

	if(param_05 == "bouncingbetty_mp" && !scripts\mp\_weapons::minedamageheightpassed(param_00,self))
	{
		return 0;
	}

	if(issubstr(param_05,"throwingknife") && param_04 == "MOD_IMPACT")
	{
		param_02 = self.health + 1;
	}

	if(isdefined(param_00) && isdefined(param_00.stuckenemyentity) && param_00.stuckenemyentity == self)
	{
		param_02 = self.health + 1;
	}

	if(param_02 <= 0)
	{
		return 0;
	}

	if(isdefined(param_01) && param_01 != self && param_02 > 0 && !isdefined(param_08) || param_08 != "shield")
	{
		if(param_03 & level.idflags_stun)
		{
			var_0E = "stun";
		}
		else if(!scripts\mp\_damage::func_100C1(param_06))
		{
			var_0E = "none";
		}
		else
		{
			var_0E = "standard";
		}

		param_01 thread scripts\mp\_damagefeedback::updatedamagefeedback(var_0E,param_02 >= self.health);
	}

	if(isdefined(level.modifyplayerdamage))
	{
		param_02 = [[ level.modifyplayerdamage ]](self,param_01,param_02,param_04,param_05,param_06,param_07,param_08);
	}

	return self [[ scripts/mp/agents/agent_utility::agentfunc("on_damaged_finished") ]](param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B);
}

//Function Number: 9
on_agent_player_damaged(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B)
{
	var_0C = isdefined(param_01) && isdefined(self.triggerportableradarping) && self.triggerportableradarping == param_01;
	if(!level.teambased && var_0C)
	{
		return 0;
	}

	if(isdefined(level.weaponmapfunc))
	{
		param_05 = [[ level.weaponmapfunc ]](param_05,param_00);
	}

	scripts\mp\_damage::callback_playerdamage(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B);
}

//Function Number: 10
on_agent_player_killed(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08)
{
	on_humanoid_agent_killed_common(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,1);
	if(isplayer(param_01) && !isdefined(self.triggerportableradarping) || param_01 != self.triggerportableradarping)
	{
		scripts\mp\_damage::onkillstreakkilled("squad_mate",param_01,param_04,param_03,param_02,"destroyed_squad_mate");
	}

	scripts\mp\_weapons::dropscavengerfordeath(param_01);
	if(self.isactive)
	{
		self.hasdied = 1;
		if(scripts\mp\_utility::getgametypenumlives() != 1 && isdefined(self.respawn_on_death) && self.respawn_on_death)
		{
			self thread [[ scripts/mp/agents/agent_utility::agentfunc("spawn") ]]();
			return;
		}

		scripts/mp/agents/agent_utility::deactivateagent();
	}
}

//Function Number: 11
on_humanoid_agent_killed_common(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09)
{
	if(isdefined(self.hasriotshieldequipped) && self.hasriotshieldequipped)
	{
		scripts\mp\_damage::launchshield(param_02,param_03);
		if(!param_09)
		{
			var_0A = self dropitem(self getcurrentweapon());
			if(isdefined(var_0A))
			{
				var_0A thread scripts\mp\_weapons::deletepickupafterawhile();
				var_0A.triggerportableradarping = self;
				var_0A.ownersattacker = param_01;
				var_0A makeunusable();
			}
		}
	}

	if(param_09)
	{
		self [[ level.weapondropfunction ]](param_01,param_03);
	}

	scripts\mp\_utility::riotshield_clear();
	if(isdefined(self.nocorpse))
	{
		return;
	}

	self.body = self getplayerviewmodelfrombody(param_08);
	thread scripts\mp\_damage::delaystartragdoll(self.body,param_06,param_05,param_04,param_00,param_03);
}

//Function Number: 12
initplayerclass()
{
	if(isdefined(self.class_override))
	{
		self.class = self.class_override;
		return;
	}

	if(scripts\mp\bots\_bots_loadout::bot_setup_loadout_callback())
	{
		self.class = "callback";
		return;
	}

	self.class = "class1";
}