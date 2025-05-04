/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\cp\zombies\solo_challenges.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 28
 * Decompile Time: 1381 ms
 * Timestamp: 10/27/2023 12:09:07 AM
*******************************************************************/

//Function Number: 1
init_solo_challenges()
{
	func_956D();
	func_97B0();
}

//Function Number: 2
func_956D()
{
	var_00 = getdvar("ui_mapname");
	level.zombie_challenge_table = "cp/zombies/" + var_00 + "_challenges.csv";
	if(!tableexists(level.zombie_challenge_table))
	{
		level.zombie_challenge_table = undefined;
	}

	level.challenge_data = [];
	if(isdefined(level.challenge_registration_func))
	{
		[[ level.challenge_registration_func ]]();
	}
}

//Function Number: 3
update_challenge(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09)
{
	if(isplayer(self))
	{
		if(!current_challenge_is(param_00))
		{
			return;
		}

		var_0A = self.current_challenge;
		self thread [[ var_0A.var_12E9C ]](param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09);
		return;
	}

	if(!var_0A current_challenge_is(param_01))
	{
		return;
	}

	var_0A = var_0A.current_challenge;
	param_09 thread [[ var_0A.var_12E9C ]](param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09);
}

//Function Number: 4
func_62C6()
{
	if(current_challenge_exist() && scripts\cp\utility::coop_mode_has("challenge"))
	{
		deactivate_current_challenge();
	}
}

//Function Number: 5
deactivate_current_challenge(param_00)
{
	if(!current_challenge_exist())
	{
		return;
	}

	var_01 = param_00.current_challenge;
	param_00 func_12BF7();
	if(var_01 [[ var_01.var_9F82 ]](param_00))
	{
		func_56AD("challenge_success",0,undefined,param_00);
		var_01 [[ var_01.var_E4C5 ]]();
		var_02 = "challenge";
		if(isdefined(level.var_3C24))
		{
			var_02 = level.var_3C24;
		}

		if(func_9F17(var_01))
		{
			if(param_00.vo_prefix == "p5_" || param_00.vo_prefix == "p6_")
			{
				param_00 thread scripts\cp\cp_vo::try_to_play_vo("challenge_success","zmb_comment_vo");
			}
		}
	}
	else
	{
		func_56AD("challenge_failed",0,undefined,param_00);
		if(func_9F17(var_01))
		{
			if(isdefined(level.var_3C2B[var_01.ref]) && func_9F17(var_01))
			{
				level.var_3C2B[var_01.ref]++;
			}

			if(var_01.ref == "no_laststand" || var_01.ref == "no_bleedout" || var_01.ref == "protect_player")
			{
				scripts\cp\zombies\zombie_analytics::func_AF64(var_01.ref,level.wave_num,0,level.var_3C2B[var_01.ref]);
			}
			else
			{
				scripts\cp\zombies\zombie_analytics::func_AF64(var_01.ref,level.wave_num,var_01.current_progress / var_01.objective_icon * 100,level.var_3C2B[var_01.ref]);
			}

			foreach(param_00 in level.players)
			{
				if(!scripts\cp\utility::isplayingsolo() && level.players.size > 1)
				{
					scripts\cp\cp_vo::try_to_play_vo_on_all_players("challenge_fail_team");
					continue;
				}

				param_00 thread scripts\cp\cp_vo::try_to_play_vo("challenge_fail_solo","zmb_comment_vo");
			}
		}

		var_01 [[ var_01.var_6AD0 ]]();
		level.var_1BE8 = 0;
		scripts\cp\cp_persistence::update_lb_aliensession_challenge(0);
		scripts\cp\cp_analytics::update_challenges_status(var_01.ref,0);
	}

	level notify("challenge_deactivated");
	var_01 [[ var_01.var_4DDE ]](param_00);
}

//Function Number: 6
func_9F17(param_00)
{
	switch(param_00.ref)
	{
		case "challenge_success":
		case "challenge_failed":
		case "next_challenge":
			return 0;

		default:
			return 1;
	}
}

//Function Number: 7
copy_challenge_struct(param_00)
{
	var_01 = level.challenge_data[param_00];
	var_02 = spawnstruct();
	var_02.ref = var_01.ref;
	var_02.objective_icon = var_01.objective_icon;
	var_02.default_success = var_01.default_success;
	var_02.var_9F82 = var_01.var_9F82;
	var_02.var_386E = var_01.var_386E;
	var_02.var_1609 = var_01.var_1609;
	var_02.var_4DDE = var_01.var_4DDE;
	var_02.var_6ACB = var_01.var_6ACB;
	var_02.var_12E9C = var_01.var_12E9C;
	var_02.var_E4C5 = var_01.var_E4C5;
	var_02.var_6AD0 = var_01.var_6AD0;
	return var_02;
}

//Function Number: 8
activate_new_challenge(param_00,param_01)
{
	param_01.current_challenge = copy_challenge_struct(param_00);
	if(param_01.current_challenge [[ param_01.current_challenge.var_386E ]]())
	{
		var_02 = func_7897(param_00);
		if(isdefined(var_02))
		{
			param_01.current_challenge.objective_icon = var_02;
		}
		else
		{
			level.current_challenge_scalar = -1;
		}

		func_56AD(param_00,1,var_02,param_01);
		param_01 func_F31A(param_00);
		param_01 notify("new_challenge_started");
		param_01.current_challenge [[ param_01.current_challenge.var_1609 ]](param_01);
		return;
	}

	param_01.current_challenge [[ param_01.current_challenge.var_6ACB ]]();
}

//Function Number: 9
func_7897(param_00)
{
	return [[ level.challenge_scalar_func ]](param_00);
}

//Function Number: 10
func_56AD(param_00,param_01,param_02,param_03)
{
	var_04 = tablelookup(level.zombie_challenge_table,1,param_00,0);
	if(param_01)
	{
		if(param_00 == "next_challenge")
		{
			param_03 playlocalsound("zmb_challenge_config");
		}
		else
		{
			param_03 playlocalsound("zmb_challenge_start");
		}

		param_03 setclientomnvar("zm_show_challenge",-1);
		wait(0.05);
		if(level.script != "cp_disco")
		{
			param_03 setclientomnvar("ui_intel_active_index",-1);
		}

		param_03 setclientomnvar("ui_intel_progress_current",-1);
		wait(0.05);
		param_03 setclientomnvar("ui_intel_progress_max",-1);
		param_03 setclientomnvar("ui_intel_percent",-1);
		wait(0.05);
		param_03 setclientomnvar("ui_intel_target_player",-1);
		param_03 setclientomnvar("ui_intel_prechallenge",0);
		wait(0.05);
		param_03 setclientomnvar("ui_intel_timer",-1);
		param_03 setclientomnvar("ui_intel_challenge_scalar",-1);
		wait(0.3);
		if(isdefined(param_02))
		{
			var_05 = param_02;
			if(isdefined(param_03.kung_fu_progression) && isdefined(param_03.kung_fu_progression.active_discipline))
			{
				var_05 = param_02 - param_03.kung_fu_progression.challenge_progress[param_03.kung_fu_progression.active_discipline];
			}

			param_03 setclientomnvar("ui_intel_challenge_scalar",param_02);
			param_03 setclientomnvar("ui_intel_progress_max",param_02);
			param_03 setclientomnvar("ui_intel_progress_current",var_05);
		}
		else
		{
			param_03 setclientomnvar("ui_intel_challenge_scalar",-1);
		}

		param_03 setclientomnvar("ui_intel_prechallenge",1);
		param_03 setclientomnvar("ui_intel_active_index",int(var_04));
		param_03.current_challenge_index = int(var_04);
		param_03 setclientomnvar("ui_intel_timer",-1);
		param_03 setclientomnvar("zm_show_challenge",4);
		return;
	}

	level thread func_100CB(param_00,var_04,param_03);
}

//Function Number: 11
func_100CB(param_00,param_01,param_02)
{
	level endon("game_ended");
	param_02 endon("disconnect");
	wait(1);
	if(param_00 == "challenge_failed")
	{
		param_02 playlocalsound("zmb_challenge_fail");
		param_02 setclientomnvar("zm_show_challenge",2);
	}
	else
	{
		param_02 playlocalsound("zmb_challenge_complete");
		param_02 setclientomnvar("zm_show_challenge",3);
	}

	if(isdefined(level.show_challenge_outcome_func))
	{
		[[ level.show_challenge_outcome_func ]](param_00,param_01,param_02);
		return;
	}

	wait(3);
	param_02 thread reset_omnvars();
	setomnvar("zm_challenge_progress",0);
}

//Function Number: 12
reset_omnvars()
{
	self notify("challenge_complete");
	wait(0.5);
	if(level.script != "cp_disco")
	{
		self setclientomnvar("ui_intel_active_index",-1);
	}

	self setclientomnvar("ui_intel_progress_current",-1);
	self setclientomnvar("ui_intel_progress_max",-1);
	self setclientomnvar("ui_intel_percent",-1);
	self setclientomnvar("ui_intel_target_player",-1);
	self setclientomnvar("ui_intel_prechallenge",0);
	self setclientomnvar("ui_intel_timer",-1);
	self setclientomnvar("ui_intel_challenge_scalar",-1);
	self setclientomnvar("zm_show_challenge",-1);
}

//Function Number: 13
register_challenge(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A)
{
	var_0B = spawnstruct();
	var_0B.ref = param_00;
	var_0B.objective_icon = param_01;
	var_0B.default_success = param_02;
	var_0B.var_9F82 = ::func_4FFA;
	if(isdefined(param_03))
	{
		var_0B.var_9F82 = param_03;
	}

	var_0B.var_386E = ::func_4FDD;
	if(isdefined(param_04))
	{
		var_0B.var_386E = param_04;
	}

	var_0B.var_1609 = param_05;
	var_0B.var_4DDE = param_06;
	var_0B.var_6ACB = ::func_4FED;
	if(isdefined(param_07))
	{
		var_0B.var_6ACB = param_07;
	}

	var_0B.var_12E9C = param_08;
	var_0B.var_E4C5 = ::func_5011;
	if(isdefined(param_09))
	{
		var_0B.var_E4C5 = param_09;
	}

	var_0B.var_6AD0 = ::func_4FEE;
	if(isdefined(param_0A))
	{
		var_0B.var_6AD0 = param_0A;
	}

	level.challenge_data[param_00] = var_0B;
}

//Function Number: 14
update_challenge_progress(param_00,param_01)
{
	self setclientomnvar("zm_show_challenge",1);
	self setclientomnvar("ui_intel_progress_current",param_00);
}

//Function Number: 15
func_4FDD()
{
	return 1;
}

//Function Number: 16
func_4FED()
{
}

//Function Number: 17
func_4FFA()
{
	if(isdefined(self.success))
	{
		return self.success;
	}

	return 0;
}

//Function Number: 18
default_successfunc()
{
	if(isdefined(self.success))
	{
		return self.success;
	}

	return self.default_success;
}

//Function Number: 19
func_4FEE()
{
}

//Function Number: 20
default_resetsuccess()
{
	self.current_challenge.success = self.current_challenge.default_success;
}

//Function Number: 21
func_5011()
{
}

//Function Number: 22
current_challenge_exist()
{
	return isdefined(self.current_challenge);
}

//Function Number: 23
current_challenge_is(param_00)
{
	return current_challenge_exist() && self.current_player_challenge == param_00;
}

//Function Number: 24
func_12BF7()
{
	self.current_challenge = undefined;
}

//Function Number: 25
func_F31A(param_00)
{
	self.current_player_challenge = param_00;
}

//Function Number: 26
func_97B0()
{
	if(!isdefined(level.zombie_challenge_table))
	{
		return;
	}

	var_00 = level.zombie_challenge_table;
	var_01 = 0;
	var_02 = 1;
	var_03 = 99;
	var_04 = 1;
	var_05 = 2;
	var_06 = 6;
	var_07 = 7;
	var_08 = 8;
	for(var_09 = var_02;var_09 <= var_03;var_09++)
	{
		var_0A = tablelookup(var_00,var_01,var_09,var_04);
		if(var_0A == "")
		{
			break;
		}

		var_0B = tablelookup(var_00,var_01,var_09,var_05);
		var_0C = tablelookup(var_00,var_01,var_09,var_08);
		if(isdefined(level.challenge_data[var_0A]))
		{
			level.challenge_data[var_0A].var_1C81 = var_0B;
			level.challenge_data[var_0A].var_1C8C = int(tablelookup(var_00,var_01,var_09,var_06));
			level.challenge_data[var_0A].active_time = strtok(var_0C," ");
		}
	}
}

//Function Number: 27
func_4FE2(param_00)
{
	return 1;
}

//Function Number: 28
update_death_challenges(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08)
{
	if(scripts\engine\utility::istrue(self.died_poorly))
	{
		return;
	}

	var_09 = param_01;
	if(isdefined(param_01.playerowner) && param_01.playerowner scripts\cp\utility::is_valid_player(1))
	{
		var_09 = param_01.playerowner;
	}

	if(!isplayer(var_09))
	{
		return;
	}

	if(!isdefined(var_09.current_challenge))
	{
		return;
	}

	var_0A = var_09.current_challenge;
	if(isdefined(level.custom_death_challenge_func))
	{
		var_0B = self [[ level.custom_death_challenge_func ]](param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08);
		if(!scripts\engine\utility::istrue(var_0B))
		{
			return;
		}
	}
}