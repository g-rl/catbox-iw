/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\globallogic.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 9
 * Decompile Time: 363 ms
 * Timestamp: 10/27/2023 12:20:30 AM
*******************************************************************/

//Function Number: 1
init()
{
	setdvar("match_running",1);
	level.splitscreen = function_0114();
	scripts\mp\utility::func_F305();
	level.onlinegame = getdvarint("onlinegame");
	level.rankedmatch = (level.onlinegame && !getdvarint("xblive_privatematch")) || getdvarint("force_ranking");
	scripts\mp\utility::func_F7F1();
	level.script = tolower(getdvar("mapname"));
	level.gametype = tolower(getdvar("g_gametype"));
	level.teamnamelist = ["axis","allies"];
	level.otherteam["allies"] = "axis";
	level.otherteam["axis"] = "allies";
	level.multiteambased = 0;
	level.teambased = 0;
	level.objectivebased = 0;
	level.var_6329 = 1;
	level.showingfinalkillcam = 0;
	level.tispawndelay = getdvarint("scr_tispawndelay");
	if(!isdefined(level.var_12AC9))
	{
		scripts\mp\tweakables::init();
	}

	level.var_8865 = "halftime";
	level.var_AA1E = 0;
	level.waswinning = "none";
	level.var_A9F1 = 0;
	level.placement["allies"] = [];
	level.placement["axis"] = [];
	level.placement["all"] = [];
	level.var_D706 = 3.5;
	level.var_D420 = [];
	func_DEEC();
	if(scripts\mp\utility::matchmakinggame())
	{
		var_00 = " LB_MAP_" + getdvar("ui_mapname");
		var_01 = "";
		var_02 = "";
		var_02 = "LB_GB_TOTALXP_AT LB_GB_TOTALXP_LT LB_GB_WINS_AT LB_GB_WINS_LT LB_GB_KILLS_AT LB_GB_KILLS_LT LB_GB_ACCURACY_AT LB_ACCOLADES";
		var_01 = " LB_GM_" + level.gametype;
		if(getdvarint("g_hardcore"))
		{
			var_01 = var_01 + "_HC";
		}

		precacheleaderboards(var_02 + var_01 + var_00);
	}

	level.teamcount["allies"] = 0;
	level.teamcount["axis"] = 0;
	level.teamcount["spectator"] = 0;
	level.alivecount["allies"] = 0;
	level.alivecount["axis"] = 0;
	level.alivecount["spectator"] = 0;
	level.livescount["allies"] = 0;
	level.livescount["axis"] = 0;
	level.var_C50B = [];
	level.hasspawned["allies"] = 0;
	level.hasspawned["axis"] = 0;
	var_03 = 9;
	func_9694(var_03);
}

//Function Number: 2
endmatchonhostdisconnect()
{
	level endon("game_ended");
	for(;;)
	{
		level waittill("connected",var_00);
		if(var_00 ishost())
		{
			var_01 = var_00;
			break;
		}
	}

	var_01 waittill("disconnect");
	thread scripts\mp\gamelogic::endgame("draw",game["end_reason"]["host_ended_game"]);
}

//Function Number: 3
func_9694(param_00)
{
	for(var_01 = 0;var_01 < param_00;var_01++)
	{
		var_02 = "team_" + var_01;
		level.placement[var_02] = [];
		level.teamcount[var_02] = 0;
		level.alivecount[var_02] = 0;
		level.livescount[var_02] = 0;
		level.hasspawned[var_02] = 0;
	}
}

//Function Number: 4
func_DEEC()
{
	setomnvar("ui_bomb_timer",0);
	if(getdvar("r_reflectionProbeGenerate") != "1")
	{
		setomnvar("ui_nuke_end_milliseconds",0);
	}

	setdvar("ui_danger_team","");
	setdvar("ui_inhostmigration",0);
	setdvar("ui_override_halftime",0);
	setdvar("camera_thirdPerson",getdvarint("scr_thirdPerson"));
}

//Function Number: 5
setupcallbacks()
{
	setdefaultcallbacks();
	scripts\mp\callbacksetup::setupdamageflags();
	scripts\mp\gametypes\common::setupcommoncallbacks();
	level.getspawnpoint = ::blank;
	level.onspawnplayer = ::scripts\mp\gametypes\common::onspawnplayer;
	level.onrespawndelay = ::blank;
	level.ontimelimit = ::scripts\mp\gamelogic::default_ontimelimit;
	level.var_C539 = ::scripts\mp\gamelogic::default_onhalftime;
	level.ondeadevent = ::scripts\mp\gamelogic::func_5007;
	level.ononeleftevent = ::scripts\mp\gamelogic::default_ononeleftevent;
	level.onprecachegametype = ::blank;
	level.onstartgametype = ::blank;
	level.onplayerkilled = ::blank;
	level.var_A6A2 = ::scripts\mp\killstreaks\_init_mp::init;
	level.var_B3E7 = ::scripts\mp\matchevents::init;
	level.var_9994 = ::scripts\mp\intel::init;
	level.matchrecording_init = ::scripts\mp\matchrecording::init;
	level.weaponmapfunc = ::scripts\mp\utility::func_13CA1;
	level.initagentscriptvariables = ::scripts/mp/agents/agent_utility::initagentscriptvariables;
	level.setagentteam = ::scripts/mp/agents/agent_utility::set_agent_team;
	level.agentvalidateattacker = ::scripts\mp\utility::_validateattacker;
	level.agentfunc = ::scripts/mp/agents/agent_utility::agentfunc;
	level.getfreeagent = ::scripts/mp/agents/agent_utility::getfreeagent;
	level.addtocharactersarray = ::scripts\mp\spawnlogic::addtocharactersarray;
}

//Function Number: 6
setdefaultcallbacks()
{
	level.callbackstartgametype = ::scripts\mp\gamelogic::callback_startgametype;
	level.callbackplayerconnect = ::scripts\mp\playerlogic::callback_playerconnect;
	level.callbackplayerdisconnect = ::scripts\mp\playerlogic::callback_playerdisconnect;
	level.callbackplayerdamage = ::scripts\mp\damage::callback_playerdamage;
	level.callbackplayerimpaled = ::scripts\mp\damage::callback_playerimpaled;
	level.callbackplayerkilled = ::scripts\mp\damage::callback_playerkilled;
	level.callbackplayerlaststand = ::scripts\mp\damage::callback_playerlaststand;
	level.callbackplayermigrated = ::scripts\mp\playerlogic::callback_playermigrated;
	level.callbackhostmigration = ::scripts\mp\hostmigration::callback_hostmigration;
	level.callbackfinishweaponchange = ::scripts\mp\weapons::callback_finishweaponchange;
}

//Function Number: 7
blank(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09)
{
}

//Function Number: 8
func_11757()
{
	self endon("death");
	self endon("disconnect");
	for(;;)
	{
		wait(3);
		var_00 = randomint(6);
		for(var_01 = 0;var_01 < var_00;var_01++)
		{
			iprintlnbold(var_00);
			self shellshock("frag_grenade_mp",0.2);
			wait(0.1);
		}
	}
}

//Function Number: 9
debugline(param_00,param_01)
{
	for(var_02 = 0;var_02 < 50;var_02++)
	{
		wait(0.05);
	}
}