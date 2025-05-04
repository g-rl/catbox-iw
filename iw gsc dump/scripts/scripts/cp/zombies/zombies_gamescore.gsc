/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: zombies_gamescore.gsc //was 3418.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 29
 * Decompile Time: 5 ms
 * Timestamp: 10/27/2023 12:27:10 AM
*******************************************************************/

//Function Number: 1
init_zombie_scoring()
{
	func_95CA(["money_earned"]);
	func_95C7(["money_earned"]);
	func_F450();
	func_F44F();
}

//Function Number: 2
func_F450()
{
	level.cycle_score_scalar = 1;
}

//Function Number: 3
func_F44F()
{
	level.endgameencounterscorefunc = ::func_13FA1;
}

//Function Number: 4
func_95CA(param_00)
{
	foreach(var_02 in param_00)
	{
		switch(var_02)
		{
			case "damage":
				scripts/cp/cp_gamescore::register_eog_score_component("damage",29);
				break;

			case "money_earned":
				scripts/cp/cp_gamescore::register_eog_score_component("money_earned",30);
				break;

			case "tickets_earned":
				scripts/cp/cp_gamescore::register_eog_score_component("tickets_earned",31);
				break;

			case "consumables_earned":
				scripts/cp/cp_gamescore::register_eog_score_component("consumables_earned",32);
				break;

			default:
				break;
		}
	}
}

//Function Number: 5
func_95C7(param_00)
{
	level.encounter_score_components = [];
	foreach(var_02 in param_00)
	{
		switch(var_02)
		{
			case "damage":
				func_95A0();
				break;

			case "money_earned":
				func_9683();
				break;

			case "tickets_earned":
				func_9784();
				break;

			case "consumables_earned":
				func_958B();
				break;

			default:
				break;
		}
	}
}

//Function Number: 6
func_95A0()
{
	scripts/cp/cp_gamescore::register_encounter_score_component("damage",::func_959F,::func_E22D,::func_E214,::func_36E5,29,"damage");
}

//Function Number: 7
func_9683()
{
	scripts/cp/cp_gamescore::register_encounter_score_component("money_earned",::func_9682,::func_E230,::func_E218,::func_36F8,30,"money_earned");
}

//Function Number: 8
func_9784()
{
	scripts/cp/cp_gamescore::register_encounter_score_component("tickets_earned",::func_9783,::func_E233,::func_E220,::func_3707,31,"tickets_earned");
}

//Function Number: 9
func_958B()
{
	scripts/cp/cp_gamescore::register_encounter_score_component("consumables_earned",::func_958A,::func_E22C,::func_E213,::func_36E3,32,"consumables_earned");
}

//Function Number: 10
func_958A(param_00)
{
	return param_00;
}

//Function Number: 11
func_E22C(param_00)
{
	return param_00;
}

//Function Number: 12
func_E213(param_00)
{
	param_00.encounter_performance["total_consumables_earned"] = 0;
}

//Function Number: 13
func_36E3(param_00,param_01)
{
	var_02 = scripts/cp/cp_gamescore::get_player_encounter_performance(param_00,"total_consumables_earned");
	var_03 = min(-15536,var_02 * 10000);
	return int(var_03);
}

//Function Number: 14
func_9783(param_00)
{
	return param_00;
}

//Function Number: 15
func_E233(param_00)
{
	return param_00;
}

//Function Number: 16
func_E220(param_00)
{
	param_00.encounter_performance["total_tickets_earned"] = 0;
}

//Function Number: 17
func_3707(param_00,param_01)
{
	var_02 = scripts/cp/cp_gamescore::get_player_encounter_performance(param_00,"total_tickets_earned");
	var_03 = min(999999,var_02 * 1);
	return int(var_03);
}

//Function Number: 18
func_9682(param_00)
{
	return param_00;
}

//Function Number: 19
func_E230(param_00)
{
	return param_00;
}

//Function Number: 20
func_E218(param_00)
{
	param_00.encounter_performance["total_money_earned"] = 0;
}

//Function Number: 21
func_36F8(param_00,param_01)
{
	var_02 = scripts/cp/cp_gamescore::get_player_encounter_performance(param_00,"total_money_earned");
	var_03 = min(999999,var_02 * 1);
	return int(var_03);
}

//Function Number: 22
func_959F(param_00)
{
	return param_00;
}

//Function Number: 23
func_E22D(param_00)
{
	return param_00;
}

//Function Number: 24
func_E214(param_00)
{
	param_00.encounter_performance["damage_done_on_agent"] = 0;
}

//Function Number: 25
func_36E5(param_00,param_01)
{
	var_02 = scripts/cp/cp_gamescore::get_player_encounter_performance(param_00,"damage_done_on_agent");
	var_03 = min(999999,var_02 * 0.2);
	return int(var_03);
}

//Function Number: 26
update_agent_damage_performance(param_00,param_01,param_02)
{
	if(param_02 == "MOD_TRIGGER_HURT")
	{
		return;
	}

	var_03 = scripts\cp\utility::get_attacker_as_player(param_00);
	if(!isdefined(var_03))
	{
		return;
	}

	var_03 scripts/cp/cp_gamescore::update_personal_encounter_performance("damage","damage_done_on_agent",param_01);
}

//Function Number: 27
update_money_earned_performance(param_00,param_01)
{
	param_00 scripts/cp/cp_gamescore::update_personal_encounter_performance("money_earned","total_money_earned",param_01);
	scripts\cp\zombies\zombie_analytics::func_AF67(param_00,param_01);
}

//Function Number: 28
update_tickets_earned_performance(param_00,param_01)
{
	param_00 scripts/cp/cp_gamescore::update_personal_encounter_performance("tickets_earned","total_tickets_earned",param_01);
}

//Function Number: 29
func_13FA1(param_00)
{
	scripts/cp/cp_gamescore::calculate_encounter_scores(level.players,["money_earned"],param_00);
}