/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\anim\init.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 35
 * Decompile Time: 1782 ms
 * Timestamp: 10\27\2023 12:00:39 AM
*******************************************************************/

//Function Number: 1
func_98E1(param_00)
{
	self.var_39B[param_00] = spawnstruct();
	self.var_39B[param_00].weaponisauto = "none";
	self.var_39B[param_00].var_8BDE = 1;
	if(function_00E6(param_00) != "")
	{
		self.var_39B[param_00].var_13053 = 1;
		return;
	}

	self.var_39B[param_00].var_13053 = 0;
}

//Function Number: 2
func_A000(param_00)
{
	return isdefined(self.var_39B[param_00]);
}

//Function Number: 3
func_F724()
{
	anim.covercrouchleanpitch = 55;
	anim.var_1A52 = 10;
	anim.var_1A50 = 4096;
	anim.var_1A51 = 45;
	anim.var_1A44 = 20;
	anim.var_C88B = 25;
	anim.var_C889 = level.var_1A50;
	anim.var_C88A = level.var_1A51;
	anim.var_C87D = 30;
	anim.var_B480 = 65;
	anim.var_B47F = 65;
}

//Function Number: 4
func_68BD()
{
	if(scripts\anim\utility_common::isshotgun(self.secondaryweapon))
	{
		return 1;
	}

	if(weaponclass(self.primaryweapon) == "rocketlauncher")
	{
		return 1;
	}

	return 0;
}

//Function Number: 5
func_FAFB()
{
	self endon("death");
	scripts\common\utility::flag_wait("load_finished");
	if(isdefined(level.var_13CC8) && isdefined(level.var_13CC8[self.unittype]))
	{
		self [[ level.var_13CC8[self.unittype] ]]();
		return;
	}

	func_5031();
}

//Function Number: 6
main()
{
	self.a = spawnstruct();
	self.var_1491.laseron = 0;
	self.primaryweapon = self.var_394;
	func_6DE9();
	if(!scripts\common\utility::flag_exist("load_finished"))
	{
		scripts\common\utility::flag_init("load_finished");
	}

	if(self.primaryweapon == "")
	{
		self.primaryweapon = "none";
	}

	if(self.secondaryweapon == "")
	{
		self.secondaryweapon = "none";
	}

	if(self.var_101B4 == "")
	{
		self.var_101B4 = "none";
	}

	self.var_E6E6 = %root;
	self.var_1491.var_2C13 = %body;
	thread begingrenadetracking();
	self.var_1491.pose = "stand";
	self.var_1491.var_85E2 = "stand";
	self.var_1491.movement = "stop";
	self.var_1491.state = "stop";
	self.var_1491.var_10930 = "none";
	self.var_1491.var_870D = "none";
	self.var_1491.var_D8BD = -1;
	self.iscinematicplaying = 1;
	self.var_B781 = 750;
	thread func_FAFB();
	self.var_1491.needstorechamber = 0;
	self.var_1491.combatendtime = gettime();
	self.var_1491.lastenemytime = gettime();
	self.var_1491.var_112CB = 0;
	self.var_1491.disablelongdeath = !self gettargetchargepos();
	self.var_1491.var_AFFF = 0;
	self.var_1491.var_C888 = 0;
	self.var_1491.var_A9ED = 0;
	self.var_1491.nextgrenadetrytime = 0;
	self.var_1491.reacttobulletchance = 0.8;
	self.var_1491.var_D707 = undefined;
	self.var_1491.var_10B53 = "stand";
	self.var_3EF3 = ::scripts\anim\utility::func_3EF2;
	self.var_117C = 0;
	self.var_1300 = 0;
	thread func_6568();
	self.var_2894 = 1;
	self.var_1491.var_B8D6 = 0;
	self.var_1491.nodeath = 0;
	self.var_1491.var_B8D6 = 0;
	self.var_1491.var_B8D8 = 0;
	self.var_1491.var_5605 = 0;
	self.var_154E = 1;
	self.var_3D4B = 0;
	self.var_101E7 = 0;
	self.var_101E6 = 1;
	self.var_BE8B = 1;
	self.var_504E = 55;
	scripts\sp\_utility::func_F6FE("asm");
	self.var_1491.var_BFAF = 0;
	if(!isdefined(self.script_forcegrenade))
	{
		self.script_forcegrenade = 0;
	}

	func_FAF2();
	self.lastenemysighttime = 0;
	self.var_440E = 0;
	self.var_112C8 = 0;
	self.var_112CA = 0;
	if(self.team == "allies")
	{
		self.suppressionthreshold = 0.5;
	}
	else
	{
		self.suppressionthreshold = 0;
	}

	if(self.team == "allies")
	{
		self.var_DCAF = 0;
	}
	else
	{
		self.var_DCAF = 256;
	}

	self.ammocheatinterval = 8000;
	self.ammocheattime = 0;
	scripts\anim\animset::func_FA33();
	self.exception = [];
	self.exception["corner"] = 1;
	self.exception["cover_crouch"] = 1;
	self.exception["stop"] = 1;
	self.exception["stop_immediate"] = 1;
	self.exception["move"] = 1;
	self.exception["exposed"] = 1;
	self.exception["corner_normal"] = 1;
	var_00 = getarraykeys(self.exception);
	for(var_01 = 0;var_01 < var_00.size;var_01++)
	{
		scripts\common\utility::clear_exception(var_00[var_01]);
	}

	self.var_DD23 = 0;
	self.var_FFD3 = 0;
	if(!isdefined(level.var_55FE))
	{
		thread scripts\anim\combat_utility::func_B9D9();
	}

	thread ondeath_clearscriptedanim();
	if(getdvarint("ai_iw7",0) == 1 && !getdvarint("r_reflectionProbeGenerate"))
	{
		self _meth_8250(0);
		scripts\aitypes\bt_util::opcode::OP_ScriptThreadCallPointer();
		lib_0A1E::func_234D(self.var_1FA9,self.var_1FA8);
		thread func_19F7();
		self.var_1FA9 = undefined;
		self.var_1FA8 = undefined;
	}

	thread func_F7AC();
}

//Function Number: 7
func_1929()
{
	return self.var_1198.var_444A;
}

//Function Number: 8
func_100B4(param_00,param_01)
{
	if(!param_00 || self.unittype != "soldier" && self.unittype != "c6")
	{
		return 1;
	}

	var_02 = int(gettime() \ 50) % 2;
	return param_01 == var_02;
}

//Function Number: 9
func_1001A()
{
	return isdefined(self.var_3135.var_72EB) && self.var_3135.var_72EB;
}

//Function Number: 10
func_19F7()
{
	self endon("terminate_ai_threads");
	self endon("entitydeleted");
	thread lib_0A1E::func_51B8();
	thread lib_0A1E::traversehandler();
	var_00 = 1;
	var_01 = self getentitynumber() % 2;
	for(;;)
	{
		var_02 = 0;
		if(func_1001A())
		{
			scripts\aitypes\bt_util::opcode::OP_ClearArray();
			var_02 = 1;
			self.var_3135.var_72EB = undefined;
		}
		else if(var_00)
		{
			if(!func_1929())
			{
				scripts\aitypes\bt_util::opcode::OP_ClearArray();
				var_02 = 1;
			}
		}

		if(var_02)
		{
			scripts\asm\asm::func_2314();
		}

		if(isdefined(self.var_2303.var_10E23))
		{
			scripts\asm\asm::asm_clearevents(self.var_2303.var_10E23);
			self.var_2303.var_10E23 = undefined;
		}

		scripts\asm\asm::func_2389();
		wait(0.05);
		if(!isdefined(self))
		{
			break;
		}

		var_00 = func_100B4(var_02,var_01);
	}
}

//Function Number: 11
func_13CC7(param_00)
{
	var_01[0] = "m4_grenadier";
	var_01[1] = "m4_grunt";
	var_01[2] = "m4_silencer";
	var_01[3] = "m4m203";
	if(!isdefined(param_00))
	{
		return 0;
	}

	for(var_02 = 0;var_02 < var_01.size;var_02++)
	{
		if(issubstr(param_00,var_01[var_02]))
		{
			return 1;
		}
	}

	return 0;
}

//Function Number: 12
func_F7AC()
{
	self endon("death");
	if(!isdefined(level.var_AE64))
	{
		level waittill("loadout complete");
	}

	scripts\sp\_names::func_7B05();
	thread scripts\anim\squadmanager::func_185C();
}

//Function Number: 13
pollallowedstancesthread()
{
	for(;;)
	{
		if(self getteleportlonertargetplayer("stand"))
		{
			var_00[0] = "stand allowed";
			var_01[0] = (0,1,0);
		}
		else
		{
			var_00[0] = "stand not allowed";
			var_01[0] = (1,0,0);
		}

		if(self getteleportlonertargetplayer("crouch"))
		{
			var_00[1] = "crouch allowed";
			var_01[1] = (0,1,0);
		}
		else
		{
			var_00[1] = "crouch not allowed";
			var_01[1] = (1,0,0);
		}

		if(self getteleportlonertargetplayer("prone"))
		{
			var_00[2] = "prone allowed";
			var_01[2] = (0,1,0);
		}
		else
		{
			var_00[2] = "prone not allowed";
			var_01[2] = (1,0,0);
		}

		var_02 = self getshootatpos() + (0,0,30);
		var_03 = (0,0,-10);
		for(var_04 = 0;var_04 < var_00.size;var_04++)
		{
			var_05 = (var_02[0] + var_03[0] * var_04,var_02[1] + var_03[1] * var_04,var_02[2] + var_03[2] * var_04);
		}

		wait(0.05);
	}
}

//Function Number: 14
func_FAF2()
{
	if(!isdefined(self.animplaybackrate) || !isdefined(self.moveplaybackrate))
	{
		func_F2B0();
	}
}

//Function Number: 15
func_F2B0()
{
	self.animplaybackrate = 0.97 + randomfloat(0.13);
	self.var_BD22 = 0.97 + randomfloat(0.13);
	self.moveplaybackrate = self.var_BD22;
	self.var_101BB = 1.35;
}

//Function Number: 16
func_94AC(param_00,param_01,param_02,param_03)
{
	anim waittill("new exceptions");
}

//Function Number: 17
empty(param_00,param_01,param_02,param_03)
{
}

//Function Number: 18
func_6568()
{
	self endon("death");
	if(1)
	{
		return;
	}

	for(;;)
	{
		self waittill("enemy");
		if(!isalive(self.isnodeoccupied))
		{
			continue;
		}

		while(isplayer(self.isnodeoccupied))
		{
			if(scripts\anim\utility::func_8BED())
			{
				level.var_A9D0 = gettime();
			}

			wait(2);
		}
	}
}

//Function Number: 19
func_98E4()
{
	level.var_13D57[0] = -36.8552;
	level.var_13D57[1] = -27.0095;
	level.var_13D57[2] = -15.5981;
	level.var_13D57[3] = -4.37769;
	level.var_13D57[4] = 17.7776;
	level.var_13D57[5] = 59.8499;
	level.var_13D57[6] = 104.808;
	level.var_13D57[7] = 152.325;
	level.var_13D57[8] = 201.052;
	level.var_13D57[9] = 250.244;
	level.var_13D57[10] = 298.971;
	level.var_13D57[11] = 330.681;
}

//Function Number: 20
func_6DE9()
{
	if(getdvarint("ai_iw7",0) == 1)
	{
		func_6DEA();
		return;
	}

	if(isdefined(level.var_C122))
	{
		return;
	}

	anim.var_C122 = 1;
	scripts\anim\animset::func_94FD();
	anim.var_13086 = 0;
	lib_0B5F::func_965A();
	level.var_BF83 = randomint(3);
	level.var_A9D0 = 100;
	anim.defaultexception = ::empty;
	func_97F8();
	setdvarifuninitialized("scr_expDeathMayMoveCheck","on");
	scripts\sp\_names::func_F9E6();
	anim.var_1FB5 = 0;
	scripts\anim\init_move_transitions::func_98A0();
	anim.combatidlepreventoverlappingplayer = 10000;
	anim.combatmemorytimeconst = 6000;
	func_9811();
	func_97C0();
	if(!isdefined(level.optionalstepeffectfunction))
	{
		anim.optionalstepeffectsmallfunction = ::scripts\anim\notetracks::func_D480;
		anim.optionalstepeffectfunction = ::scripts\anim\notetracks::playfootstepeffect;
	}

	if(!isdefined(level.optionalstepeffects))
	{
		anim.optionalstepeffects = [];
	}

	if(!isdefined(level.optionalstepeffectssmall))
	{
		anim.optionalstepeffectssmall = [];
	}

	if(!isdefined(level.shootenemywrapper_func))
	{
		anim.shootenemywrapper_func = ::scripts\anim\utility::func_FE9D;
	}

	if(!isdefined(level.var_FED3))
	{
		anim.var_FED3 = ::scripts\anim\utility::func_FED2;
	}

	level.fire_notetrack_functions["scripted"] = ::scripts\anim\notetracks::fire_straight;
	level.fire_notetrack_functions["cover_right"] = ::scripts\anim\notetracks::shootnotetrack;
	level.fire_notetrack_functions["cover_left"] = ::scripts\anim\notetracks::shootnotetrack;
	level.fire_notetrack_functions["cover_crouch"] = ::scripts\anim\notetracks::shootnotetrack;
	level.fire_notetrack_functions["cover_stand"] = ::scripts\anim\notetracks::shootnotetrack;
	level.fire_notetrack_functions["move"] = ::scripts\anim\notetracks::shootnotetrack;
	scripts\anim\notetracks::registernotetracks();
	if(!isdefined(level.flag))
	{
		scripts\common\flags::init_flags();
	}

	scripts\sp\_gameskill::func_F848();
	level.var_C870 = undefined;
	scripts\anim\setposemovement::func_98BF();
	scripts\anim\face::initlevelface();
	anim.var_32BF = scripts\anim\utility::func_2274(1,2,2,2,3,3,3,3,4,4,5);
	anim.var_6B93 = scripts\anim\utility::func_2274(2,3,3,3,4,4,4,5,5);
	anim.var_F217 = scripts\anim\utility::func_2274(1,2,2,3,3,4,4,4,4,5,5,5);
	anim.var_2759 = [];
	anim.var_2755 = 0;
	anim.player = getentarray("player","classname")[0];
	func_97DA();
	func_98E4();
	scripts\anim\cqb::func_FA9F();
	func_97F5();
	func_F724();
	anim.var_A955 = -100000;
	anim.var_BF91 = 10000;
	func_FAE3();
	level.player thread scripts\anim\combat_utility::func_13B22();
	thread func_1B08();
}

//Function Number: 21
func_97F8()
{
}

//Function Number: 22
func_97DA()
{
	if(!isdefined(level.player.team))
	{
		level.player.team = "allies";
	}

	scripts\anim\squadmanager::func_9763();
	level.player thread scripts\anim\squadmanager::func_1811();
	level.player thread scripts\anim\squadmanager::func_D362();
	scripts\anim\battlechatter::func_9542();
	level.player thread scripts\anim\battlechatter_ai::func_185D();
	lib_0E4E::func_96F1();
	anim thread scripts\anim\battlechatter::func_29C9();
}

//Function Number: 23
func_97F5()
{
	anim.var_C222 = randomintrange(0,15);
	anim.var_C221 = randomintrange(0,10);
	anim.var_BF77 = gettime() + randomintrange(0,20000);
	anim.var_BF78 = gettime() + randomintrange(0,10000);
	anim.var_BF76 = gettime() + randomintrange(0,15000);
}

//Function Number: 24
func_9811()
{
	for(var_00 = 0;var_00 < level.players.size;var_00++)
	{
		var_01 = level.players[var_00];
		var_01.grenadetimers["fraggrenade"] = randomintrange(1000,20000);
		var_01.grenadetimers["frag"] = randomintrange(1000,20000);
		var_01.grenadetimers["frag_main"] = randomintrange(1000,20000);
		var_01.grenadetimers["frag_vr"] = randomintrange(1000,20000);
		var_01.grenadetimers["flash_grenade"] = randomintrange(1000,20000);
		var_01.grenadetimers["emp"] = randomintrange(1000,20000);
		var_01.grenadetimers["antigrav"] = randomintrange(1000,20000);
		var_01.grenadetimers["seeker"] = randomintrange(1000,20000);
		var_01.grenadetimers["c8_grenade"] = randomintrange(1000,10000);
		var_01.grenadetimers["double_grenade"] = randomintrange(1000,-5536);
		var_01.numgrenadesinprogresstowardsplayer = 0;
		var_01.var_A990 = -1000000;
		var_01.lastfraggrenadetoplayerstart = -1000000;
		var_01 thread func_F7B3();
	}

	level.grenadetimers["AI_fraggrenade"] = randomintrange(0,20000);
	level.grenadetimers["AI_frag"] = randomintrange(0,20000);
	level.grenadetimers["AI_seeker"] = randomintrange(0,20000);
	level.grenadetimers["AI_frag_main"] = randomintrange(0,20000);
	level.grenadetimers["AI_frag_vr"] = randomintrange(0,20000);
	level.grenadetimers["AI_flash_grenade"] = randomintrange(0,20000);
	level.grenadetimers["AI_smoke_grenade_american"] = randomintrange(0,20000);
	level.grenadetimers["AI_emp"] = randomintrange(0,20000);
	level.grenadetimers["AI_antigrav"] = randomintrange(0,20000);
	level.grenadetimers["AI_c8_grenade"] = randomintrange(0,10000);
	scripts\anim\combat_utility::func_9812();
}

//Function Number: 25
func_97C0()
{
	level.var_A936 = [];
	level.var_A936["axis"] = 0;
	level.var_A936["allies"] = 0;
	level.var_A936["team3"] = 0;
	level.var_A936["neutral"] = 0;
	level.var_A934 = [];
	level.var_A934["axis"] = (0,0,0);
	level.var_A934["allies"] = (0,0,0);
	level.var_A934["team3"] = (0,0,0);
	level.var_A934["neutral"] = (0,0,0);
	level.var_A935 = [];
	level.var_A935["axis"] = (0,0,0);
	level.var_A935["allies"] = (0,0,0);
	level.var_A935["team3"] = (0,0,0);
	level.var_A935["neutral"] = (0,0,0);
	level.var_A933 = [];
	level.var_18D5 = [];
	level.var_18D5["axis"] = 0;
	level.var_18D5["allies"] = 0;
	level.var_18D5["team3"] = 0;
	level.var_18D5["neutral"] = 0;
	level.var_18D7 = 30000;
	level.var_18D6 = 3;
}

//Function Number: 26
func_9897()
{
	level.var_B5F8["c6"] = 0;
	level.var_B5F5["c6"] = 9000;
	level.var_B5F7["c6"] = 0;
	level.var_B5F6["c6"] = 15000;
	level.var_B5F8["seeker"] = 0;
	level.var_B5F5["seeker"] = 9000;
	level.var_B5F7["seeker"] = 0;
	level.var_B5F6["seeker"] = 15000;
}

//Function Number: 27
func_1B08()
{
	var_00 = 0;
	var_01 = 3;
	for(;;)
	{
		var_02 = function_0072();
		if(var_02.size == 0)
		{
			wait(0.05);
			var_00 = 0;
			continue;
		}

		for(var_03 = 0;var_03 < var_02.size;var_03++)
		{
			if(!isdefined(var_02[var_03]))
			{
				continue;
			}

			var_02[var_03] notify("do_slow_things");
			var_00++;
			if(var_00 == var_01)
			{
				wait(0.05);
				var_00 = 0;
			}
		}
	}
}

//Function Number: 28
func_F7B3()
{
	waittillframeend;
	if(isdefined(self.var_86A9.var_D397))
	{
		var_00 = int(self.var_86A9.var_D397 * 0.7);
		if(var_00 < 1)
		{
			var_00 = 1;
		}

		self.grenadetimers["frag"] = randomintrange(0,var_00);
		self.grenadetimers["flash_grenade"] = randomintrange(0,var_00);
		self.grenadetimers["seeker"] = randomintrange(0,var_00);
	}

	if(isdefined(self.var_86A9.var_D382))
	{
		var_00 = int(self.var_86A9.var_D382);
		var_01 = int(var_00 \ 2);
		if(var_00 <= var_01)
		{
			var_00 = var_01 + 1;
		}

		self.grenadetimers["double_grenade"] = randomintrange(var_01,var_00);
	}
}

//Function Number: 29
begingrenadetracking()
{
	if(isdefined(level.var_55F1))
	{
		return;
	}

	self endon("death");
	for(;;)
	{
		self waittill("grenade_fire",var_00,var_01);
		if(isdefined(var_00) && scripts\common\utility::istrue(var_00._meth_8589))
		{
			continue;
		}

		if(isdefined(level.func["ai_grenade_thrown"]))
		{
			level thread [[ level.func["ai_grenade_thrown"] ]](var_00);
		}

		switch(var_01)
		{
			case "frag":
				thread scripts\sp\_detonategrenades::func_734F(var_00);
				break;
	
			case "emp":
				thread lib_0E25::func_615B(var_00);
				break;
	
			case "seeker":
				thread lib_0E26::func_F135(var_00);
				break;
	
			case "antigrav":
				thread lib_0E21::func_2013(var_00);
				break;
	
			default:
				var_00 thread scripts\sp\_utility::grenade_earthquake();
				break;
		}
	}
}

//Function Number: 30
func_FAE3()
{
	anim.var_DCB3 = 60;
	anim.var_DCB2 = [];
	for(var_00 = 0;var_00 < level.var_DCB3;var_00++)
	{
		level.var_DCB2[var_00] = var_00;
	}

	for(var_00 = 0;var_00 < level.var_DCB3;var_00++)
	{
		var_01 = randomint(level.var_DCB3);
		var_02 = level.var_DCB2[var_00];
		level.var_DCB2[var_00] = level.var_DCB2[var_01];
		level.var_DCB2[var_01] = var_02;
	}
}

//Function Number: 31
ondeath_clearscriptedanim()
{
	if(isdefined(level.var_5613))
	{
		return;
	}

	self waittill("death");
	if(!isdefined(self))
	{
		if(isdefined(self.var_1491.usingworldspacehitmarkers))
		{
			self.var_1491.usingworldspacehitmarkers delete();
		}
	}
}

//Function Number: 32
func_6DEA()
{
	if(isdefined(level.var_C122))
	{
		return;
	}

	anim.var_C122 = 1;
	anim.var_13086 = 0;
	lib_0B5F::func_965A();
	level.var_BF83 = randomint(3);
	level.var_A9D0 = 100;
	anim.defaultexception = ::empty;
	if(!isdefined(level.var_7649))
	{
		level.var_7649 = [];
	}

	func_97F8();
	scripts\sp\_names::func_F9E6();
	anim.var_1FB5 = 0;
	anim.combatidlepreventoverlappingplayer = 10000;
	anim.combatmemorytimeconst = 6000;
	anim.var_13CC8 = [];
	level.var_13CC8["c12"] = ::func_363B;
	anim.var_5667 = [];
	anim.var_13CD3 = ::scripts\anim\shared::func_CB29;
	func_9811();
	func_97C0();
	func_9897();
	if(!isdefined(level.optionalstepeffectfunction))
	{
		anim.optionalstepeffectsmallfunction = ::scripts\anim\notetracks::func_D480;
		anim.optionalstepeffectfunction = ::scripts\anim\notetracks::playfootstepeffect;
	}

	if(!isdefined(level.optionalstepeffects))
	{
		anim.optionalstepeffects = [];
	}

	if(!isdefined(level.optionalstepeffectssmall))
	{
		anim.optionalstepeffectssmall = [];
	}

	if(!isdefined(level.shootenemywrapper_func))
	{
		anim.shootenemywrapper_func = ::scripts\anim\utility::func_FE9D;
	}

	if(!isdefined(level.var_FED3))
	{
		anim.var_FED3 = ::scripts\anim\utility::func_FED2;
	}

	anim.fire_notetrack_functions = [];
	scripts\anim\notetracks::registernotetracks();
	if(!isdefined(level.flag))
	{
		scripts\common\flags::init_flags();
	}

	scripts\sp\_gameskill::func_F848();
	level.var_C870 = undefined;
	scripts\anim\setposemovement::func_98BF();
	scripts\anim\face::initlevelface();
	anim.var_32BF = scripts\anim\utility::func_2274(1,2,2,2,3,3,3,3,4,4,5);
	anim.var_6B93 = scripts\anim\utility::func_2274(2,3,3,3,4,4,4,5,5);
	anim.var_F217 = scripts\anim\utility::func_2274(1,2,2,3,3,4,4,4,4,5,5,5);
	anim.var_2759 = [];
	anim.var_2755 = 0;
	if(!isdefined(level.var_3D4B))
	{
		if(scripts\common\utility::player_is_in_jackal())
		{
			anim.player = level.var_D127;
		}
		else
		{
			anim.player = getentarray("player","classname")[0];
		}

		func_97DA();
	}

	func_98E4();
	scripts\anim\cqb::func_FA9F();
	func_97F5();
	anim.var_A955 = -100000;
	func_FAE3();
	level.player thread scripts\anim\combat_utility::func_13B22();
}

//Function Number: 33
func_5031()
{
	func_98E1(self.primaryweapon);
	func_98E1(self.secondaryweapon);
	func_98E1(self.var_101B4);
	self _meth_82D0();
	self.var_1491.weaponpos["left"] = "none";
	self.var_1491.weaponpos["right"] = "none";
	self.var_1491.weaponpos["chest"] = "none";
	self.var_1491.weaponpos["back"] = "none";
	self.var_1491.weaponposdropping["left"] = "none";
	self.var_1491.weaponposdropping["right"] = "none";
	self.var_1491.weaponposdropping["chest"] = "none";
	self.var_1491.weaponposdropping["back"] = "none";
	self.lastweapon = self.var_394;
	var_00 = scripts\anim\utility_common::usingrocketlauncher();
	self.var_1491.var_BEF9 = var_00;
	if(var_00)
	{
		thread scripts\anim\shared::func_E775();
	}

	self.var_1491.rockets = 3;
	self.var_1491.rocketvisible = 1;
	scripts\anim\shared::placeweaponon(self.primaryweapon,"right");
	if(scripts\anim\utility_common::isshotgun(self.secondaryweapon))
	{
		scripts\anim\shared::placeweaponon(self.secondaryweapon,"back");
	}

	if(self.team != "allies")
	{
		self.var_8B95 = 1;
	}

	scripts\anim\weaponlist::refillclip();
}

//Function Number: 34
func_3597()
{
	if(scripts\anim\utility_common::usingrocketlauncher())
	{
		return "rocket";
	}
	else if(scripts\anim\utility_common::usingriflelikeweapon())
	{
		return "minigun";
	}

	return undefined;
}

//Function Number: 35
func_363B()
{
	self.var_13CC3 = [];
	if(self.primaryweapon != "" && self.primaryweapon != "none")
	{
		self.var_394 = self.primaryweapon;
		self.var_13CC3["right"] = func_3597();
	}

	if(self.secondaryweapon != "" && self.secondaryweapon != "none")
	{
		self.var_394 = self.secondaryweapon;
		self.var_13CC3["left"] = func_3597();
	}

	self.var_394 = "";
	self.bulletsinclip = 1;
}