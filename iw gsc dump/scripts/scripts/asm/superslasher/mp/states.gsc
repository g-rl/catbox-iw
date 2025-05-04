/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\asm\superslasher\mp\states.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 1
 * Decompile Time: 112 ms
 * Timestamp: 10\27\2023 12:02:14 AM
*******************************************************************/

//Function Number: 1
func_2371()
{
	if(scripts\asm\asm::func_232E("superslasher"))
	{
		return;
	}

	scripts\asm\asm::func_230B("superslasher","superslasherinit");
	scripts\asm\asm::func_2374("superslasherinit",::scripts\asm\superslasher\superslasher_asm::superslasher_init,undefined,undefined,undefined,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,1);
	scripts\asm\asm::func_2375("ground_idle",undefined,::scripts\asm\shared_utility::func_12668,undefined);
	scripts\asm\asm::func_2374("rooftop_idle",::scripts\asm\superslasher\superslasher_asm::ss_play_roofidle,undefined,undefined,undefined,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"anim deltas",undefined);
	scripts\asm\asm::func_2375("jump_to_ground",undefined,::scripts\asm\superslasher\superslasher_asm::superslasher_gotogroundrequested,undefined);
	scripts\asm\asm::func_2375("rooftop_taunt",undefined,::scripts\asm\superslasher\superslasher_asm::superslasher_tauntrequested,undefined);
	scripts\asm\asm::func_2375("roof_throw_saw",undefined,::scripts\asm\superslasher\superslasher_asm::superslasher_shouldthrowsaw,undefined);
	scripts\asm\asm::func_2375("roof_wires",undefined,::scripts\asm\superslasher\superslasher_asm::superslasher_wiresrequested,undefined);
	scripts\asm\asm::func_2375("roof_shockwave_start",undefined,::scripts\asm\superslasher\superslasher_asm::superslasher_shockwaverequested,undefined);
	scripts\asm\asm::func_2374("death_generic",::lib_0C71::func_CF0E,undefined,undefined,undefined,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined);
	scripts\asm\asm::func_2374("jump_to_ground",::scripts\asm\superslasher\superslasher_asm::ss_play_jumptoground,undefined,undefined,::scripts\asm\superslasher\superslasher_asm::ss_play_jumptoground_clean,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"jumptoground",undefined,undefined,undefined);
	scripts\asm\asm::func_2375("ground_idle",undefined,::scripts\asm\asm::func_68B0,"end");
	scripts\asm\asm::func_2374("ground_idle",::scripts\asm\superslasher\superslasher_asm::ss_play_groundidle,undefined,undefined,::scripts\asm\superslasher\superslasher_asm::ss_play_groundidle_clean,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"face current","anim deltas",undefined);
	scripts\asm\asm::func_2375("intro",undefined,::scripts\asm\superslasher\superslasher_asm::superslasher_shoulddointro,undefined);
	scripts\asm\asm::func_2375("ground_jump_move_pass",undefined,::scripts\asm\superslasher\superslasher_asm::superslasher_shouldjumpmove,undefined);
	scripts\asm\asm::func_2375("jump_to_roof",undefined,::scripts\asm\superslasher\superslasher_asm::superslasher_gotoroofrequested,undefined);
	scripts\asm\asm::func_2375("ground_pound",undefined,::scripts\asm\superslasher\superslasher_asm::superslasher_groundpoundrequested,undefined);
	scripts\asm\asm::func_2375("ground_swipe",undefined,::scripts\asm\asm_bb::bb_meleerequested,undefined);
	scripts\asm\asm::func_2375("ground_stomp",undefined,::scripts\asm\superslasher\superslasher_asm::superslasher_stomprequested,undefined);
	scripts\asm\asm::func_2375("ground_idle_turn",undefined,::scripts\asm\superslasher\superslasher_asm::superslasher_needstoturn,undefined);
	scripts\asm\asm::func_2375("move_exit",undefined,::scripts\asm\asm::func_BCE7,undefined);
	scripts\asm\asm::func_2375("ground_throw_saw_charge_start",undefined,::scripts\asm\superslasher\superslasher_asm::superslasher_shouldthrowsaw,undefined);
	scripts\asm\asm::func_2375("ground_throw_saw_fan",undefined,::scripts\asm\superslasher\superslasher_asm::superslasher_shouldthrowsawfan,undefined);
	scripts\asm\asm::func_2375("ground_sharks",undefined,::scripts\asm\superslasher\superslasher_asm::superslasher_sharksrequested,undefined);
	scripts\asm\asm::func_2374("move_exit",::scripts\asm\zombie\zombie::func_CEB7,undefined,undefined,undefined,undefined,::lib_0F3B::func_3E9F,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"face current","anim deltas",undefined);
	scripts\asm\asm::func_2375("move_exit_complete",undefined,::scripts\asm\asm::func_68B0,"code_move");
	scripts\asm\asm::func_2375("move_exit_complete",undefined,::scripts\asm\asm::func_68B0,"end");
	scripts\asm\asm::func_2374("move_loop",::scripts\asm\superslasher\superslasher_asm::superslasher_playmoveloop,undefined,undefined,::scripts\asm\superslasher\superslasher_asm::superslasher_playmoveloop_clean,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"face motion","code_move",undefined);
	scripts\asm\asm::func_2375("move_swipe",undefined,::scripts\asm\superslasher\superslasher_asm::superslasher_shouldmovemelee,undefined);
	scripts\asm\asm::func_2375("move_charge",undefined,::scripts\asm\asm_bb::bb_meleechargerequested,undefined);
	scripts\asm\asm::func_2375("ground_jump_move_pass",undefined,::scripts\asm\superslasher\superslasher_asm::superslasher_shouldjumpmove,undefined);
	scripts\asm\asm::func_2375("ground_idle",undefined,::scripts\asm\asm::func_C17F,undefined);
	scripts\asm\asm::func_2375("move_arrival",undefined,::scripts\asm\superslasher\superslasher_asm::superslasher_shouldstartarrival,undefined);
	scripts\asm\asm::func_2375("move_turn",undefined,::lib_0F3B::func_FFF8,"move_turn");
	scripts\asm\asm::func_2374("move_arrival",::scripts\asm\superslasher\superslasher_asm::ss_play_arrival,undefined,undefined,::scripts\asm\superslasher\superslasher_asm::ss_play_arrival_clean,undefined,::scripts\asm\shared_utility::func_2B58,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined);
	scripts\asm\asm::func_2375("ground_idle",undefined,::scripts\asm\asm::func_68B0,"end");
	scripts\asm\asm::func_2374("rooftop_taunt",::scripts\asm\superslasher\superslasher_asm::ss_play_rooftaunt,undefined,undefined,::scripts\asm\superslasher\superslasher_asm::ss_play_rooftaunt_clean,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"tauntanim","face current","anim deltas",undefined);
	scripts\asm\asm::func_2375("rooftop_idle",undefined,::scripts\asm\asm::func_68B0,"end");
	scripts\asm\asm::func_2374("ground_pound",::scripts\asm\superslasher\superslasher_asm::ss_play_groundpound,undefined,undefined,undefined,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"groundpoundanim","face current","anim deltas",undefined);
	scripts\asm\asm::func_2375("ground_idle",undefined,::scripts\asm\asm::func_68B0,"end");
	scripts\asm\asm::func_2374("move_turn",::scripts\asm\shared\mp\move_v2::playsharpturnanimv2,undefined,undefined,undefined,undefined,::lib_0F3B::func_3EF5,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"face current","anim deltas",undefined);
	scripts\asm\asm::func_2375("move_loop",undefined,::scripts\asm\asm::func_68B0,"code_move");
	scripts\asm\asm::func_2375("move_loop",undefined,::scripts\asm\asm::func_68B0,"end");
	scripts\asm\asm::func_2374("ground_idle_turn",::scripts\asm\superslasher\superslasher_asm::ss_play_turn,undefined,undefined,::scripts\asm\superslasher\superslasher_asm::ss_play_turn_clean,undefined,::scripts\asm\superslasher\superslasher_asm::superslasher_chooseanim_turn,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined);
	scripts\asm\asm::func_2375("ground_idle",undefined,::scripts\asm\asm::func_68B0,"end");
	scripts\asm\asm::func_2375("ground_idle",undefined,::scripts\asm\asm::func_68B0,"turn_done");
	scripts\asm\asm::func_2374("move_swipe",::scripts\asm\superslasher\superslasher_asm::ss_play_movemelee,undefined,::scripts\asm\superslasher\superslasher_asm::ss_play_movemelee_nt,undefined,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"meleeanim",undefined,"anim deltas",undefined);
	scripts\asm\asm::func_2375("ground_idle",undefined,::scripts\asm\asm::func_68B0,"end");
	scripts\asm\asm::func_2374("ground_swipe",::scripts\asm\superslasher\superslasher_asm::ss_play_standmelee,undefined,::scripts\asm\superslasher\superslasher_asm::ss_play_movemelee_nt,undefined,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"meleeanim",undefined,"anim deltas",undefined);
	scripts\asm\asm::func_2375("ground_idle",undefined,::scripts\asm\asm::func_68B0,"end");
	scripts\asm\asm::func_2374("ground_stagger",::lib_0F3C::func_CEA8,undefined,undefined,undefined,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"staggeranim","face current","anim deltas",undefined);
	scripts\asm\asm::func_2375("ground_idle",undefined,::scripts\asm\asm::func_68B0,"end");
	scripts\asm\asm::func_2374("roof_throw_saw",::scripts\asm\superslasher\superslasher_asm::ss_play_throwsaw,undefined,::scripts\asm\superslasher\superslasher_asm::ss_play_throwsaw_nt,undefined,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"throwsawanim","face current","anim deltas",undefined);
	scripts\asm\asm::func_2375("rooftop_idle",undefined,::scripts\asm\asm::func_68B0,"end");
	scripts\asm\asm::func_2374("ground_throw_saw",::scripts\asm\superslasher\superslasher_asm::ss_play_throwsaw,undefined,::scripts\asm\superslasher\superslasher_asm::ss_play_throwsaw_nt,undefined,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"throwsawanim",undefined,"anim deltas",undefined);
	scripts\asm\asm::func_2375("ground_idle",undefined,::scripts\asm\asm::func_68B0,"end");
	scripts\asm\asm::func_2374("roof_stagger",::lib_0F3C::func_CEA8,undefined,undefined,undefined,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"face current","anim deltas",undefined);
	scripts\asm\asm::func_2375("rooftop_idle",undefined,::scripts\asm\asm::func_68B0,"end");
	scripts\asm\asm::func_2374("move_charge",::scripts\asm\superslasher\superslasher_asm::ss_play_meleecharge,undefined,undefined,::scripts\asm\superslasher\superslasher_asm::ss_play_meleecharge_clean,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"anim deltas",undefined);
	scripts\asm\asm::func_2375("move_swipe",undefined,::scripts\asm\superslasher\superslasher_asm::superslasher_shouldmovemelee,undefined);
	scripts\asm\asm::func_2375("move_loop",undefined,::scripts\asm\asm_bb::func_2957,undefined);
	scripts\asm\asm::func_2374("move_exit_complete",::scripts\asm\shared_utility::func_2B58,undefined,undefined,undefined,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,1);
	scripts\asm\asm::func_2375("move_charge",undefined,::scripts\asm\asm_bb::bb_meleechargerequested,undefined);
	scripts\asm\asm::func_2375("move_loop",undefined,::scripts\asm\shared_utility::func_12668,undefined);
	scripts\asm\asm::func_2374("ground_throw_saw_fan",::lib_0F3C::func_CEA8,undefined,::scripts\asm\superslasher\superslasher_asm::ss_play_throwsawfan_nt,undefined,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"sawfananim","face current","anim deltas",undefined);
	scripts\asm\asm::func_2375("ground_idle",undefined,::scripts\asm\asm::func_68B0,"end");
	scripts\asm\asm::func_2374("ground_jump_move",::scripts\asm\superslasher\superslasher_asm::ss_play_jumpmove,undefined,::scripts\asm\superslasher\superslasher_asm::ss_play_jumpmove_nt,::scripts\asm\superslasher\superslasher_asm::ss_play_jumpmove_clean,undefined,::lib_0F3C::func_3E96,"arc",undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined);
	scripts\asm\asm::func_2375("ground_jump_move_end",undefined,::scripts\asm\asm::func_68B0,"end");
	scripts\asm\asm::func_2374("ground_trapped",::scripts\asm\superslasher\superslasher_asm::ss_play_trapped,undefined,undefined,::scripts\asm\superslasher\superslasher_asm::ss_play_trapped_clean,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"face current","anim deltas",undefined);
	scripts\asm\asm::func_2375("ground_idle",undefined,::scripts\asm\asm::func_68B0,"trap_end");
	scripts\asm\asm::func_2374("ground_throw_saw_charge_start",::scripts\asm\superslasher\superslasher_asm::ss_play_sawcharge_start,undefined,undefined,::scripts\asm\superslasher\superslasher_asm::ss_play_sawcharge_start_clean,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"anim deltas",undefined);
	scripts\asm\asm::func_2375("ground_throw_saw_charge_start_complete",undefined,::scripts\asm\asm::func_68B0,"end");
	scripts\asm\asm::func_2374("ground_throw_saw_charge_loop",::scripts\asm\superslasher\superslasher_asm::ss_play_sawcharge,undefined,undefined,::scripts\asm\superslasher\superslasher_asm::ss_play_sawcharge_clean,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"face current","anim deltas",undefined);
	scripts\asm\asm::func_2375("ground_throw_saw",undefined,::scripts\asm\asm::func_68B0,"saw_charge_loop_complete");
	scripts\asm\asm::func_2374("ground_throw_saw_charge_start_complete",::lib_0F3C::func_CEA8,undefined,undefined,undefined,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,1);
	scripts\asm\asm::func_2375("ground_throw_saw_charge_loop",undefined,::scripts\asm\superslasher\superslasher_asm::superslasher_shouldsawchargeloop,undefined);
	scripts\asm\asm::func_2375("ground_throw_saw",undefined,::scripts\asm\shared_utility::func_12668,undefined);
	scripts\asm\asm::func_2374("ground_stomp",::scripts\asm\superslasher\superslasher_asm::ss_play_stomp,undefined,undefined,undefined,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"stompanim",undefined,"anim deltas",undefined);
	scripts\asm\asm::func_2375("ground_idle",undefined,::scripts\asm\asm::func_68B0,"end");
	scripts\asm\asm::func_2374("ground_jump_move_start",::scripts\asm\superslasher\superslasher_asm::ss_play_jumpmove_start,undefined,::scripts\asm\superslasher\superslasher_asm::ss_play_jumpmove_nt,::scripts\asm\superslasher\superslasher_asm::ss_play_jumpmove_start_clean,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined);
	scripts\asm\asm::func_2375("ground_jump_move",undefined,::scripts\asm\asm::func_68B0,"end");
	scripts\asm\asm::func_2374("ground_jump_move_end",::scripts\asm\superslasher\superslasher_asm::ss_play_jumpmove_end,undefined,::scripts\asm\superslasher\superslasher_asm::ss_play_jumpmove_nt,::scripts\asm\superslasher\superslasher_asm::ss_play_jumpmove_end_clean,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined);
	scripts\asm\asm::func_2375("ground_idle",undefined,::scripts\asm\asm::func_68B0,"end");
	scripts\asm\asm::func_2374("jump_to_roof",::scripts\asm\superslasher\superslasher_asm::ss_play_jumptoroof,undefined,undefined,::scripts\asm\superslasher\superslasher_asm::ss_play_jumptoroof_clean,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"jumptoroof",undefined,undefined,undefined);
	scripts\asm\asm::func_2375("rooftop_turn",undefined,::scripts\asm\asm::func_68B0,"end");
	scripts\asm\asm::func_2374("rooftop_turn",::scripts\asm\superslasher\superslasher_asm::ss_play_turn,undefined,undefined,::scripts\asm\superslasher\superslasher_asm::ss_play_turn_clean,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined);
	scripts\asm\asm::func_2375("rooftop_idle",undefined,::scripts\asm\asm::func_68B0,"turn_done");
	scripts\asm\asm::func_2374("ground_jump_move_end_2",::scripts\asm\superslasher\superslasher_asm::ss_play_jumpmove_end,undefined,::scripts\asm\superslasher\superslasher_asm::ss_play_jumpmove_nt,::scripts\asm\superslasher\superslasher_asm::ss_play_jumpmove_end_clean,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined);
	scripts\asm\asm::func_2375("ground_idle",undefined,::scripts\asm\asm::func_68B0,"end");
	scripts\asm\asm::func_2374("ground_jump_move_2",::scripts\asm\superslasher\superslasher_asm::ss_play_jumpmove,undefined,::scripts\asm\superslasher\superslasher_asm::ss_play_jumpmove_nt,::scripts\asm\superslasher\superslasher_asm::ss_play_jumpmove_clean,undefined,::lib_0F3C::func_3E96,"arc",undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined);
	scripts\asm\asm::func_2375("ground_jump_move_end_2",undefined,::scripts\asm\asm::func_68B0,"end");
	scripts\asm\asm::func_2374("ground_jump_move_start_2",::scripts\asm\superslasher\superslasher_asm::ss_play_jumpmove_start,undefined,::scripts\asm\superslasher\superslasher_asm::ss_play_jumpmove_nt,::scripts\asm\superslasher\superslasher_asm::ss_play_jumpmove_start_clean,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined);
	scripts\asm\asm::func_2375("ground_jump_move_2",undefined,::scripts\asm\asm::func_68B0,"end");
	scripts\asm\asm::func_2374("ground_jump_move_randomizer",::lib_0F3C::func_CEA8,undefined,undefined,undefined,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,1);
	scripts\asm\asm::func_2375("ground_jump_move_start",undefined,::scripts\asm\shared_utility::func_12668,undefined);
	scripts\asm\asm::func_2375("ground_jump_move_start_2",undefined,::scripts\asm\shared_utility::func_12668,undefined);
	scripts\asm\asm::func_2374("ground_jump_move_pass",::lib_0F3C::func_CEA8,undefined,undefined,undefined,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,1);
	scripts\asm\asm::func_2375("ground_jump_move_randomizer",undefined,::scripts\asm\shared_utility::randomizepassthroughchildren,undefined);
	scripts\asm\asm::func_2374("roof_wires",::scripts\asm\superslasher\superslasher_asm::ss_play_wires,undefined,undefined,undefined,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"wiresanim","face current","anim deltas",undefined);
	scripts\asm\asm::func_2375("rooftop_idle",undefined,::scripts\asm\asm::func_68B0,"end");
	scripts\asm\asm::func_2374("roof_shockwave_loop",::scripts\asm\superslasher\superslasher_asm::ss_play_shockwave_loop,undefined,undefined,undefined,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"face current","anim deltas",undefined);
	scripts\asm\asm::func_2375("roof_shockwave_end",undefined,::scripts\asm\asm::func_68B0,"shockwave_loop_complete");
	scripts\asm\asm::func_2374("ground_sharks",::scripts\asm\superslasher\superslasher_asm::ss_play_summonsharks,undefined,undefined,undefined,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"sharksanim","face current","anim deltas",undefined);
	scripts\asm\asm::func_2375("ground_idle",undefined,::scripts\asm\asm::func_68B0,"end");
	scripts\asm\asm::func_2374("roof_shockwave_start",::scripts\asm\superslasher\superslasher_asm::ss_play_shockwave_start,undefined,undefined,undefined,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"face current","anim deltas",undefined);
	scripts\asm\asm::func_2375("roof_shockwave_loop",undefined,::scripts\asm\asm::func_68B0,"end");
	scripts\asm\asm::func_2374("roof_shockwave_end",::scripts\asm\superslasher\superslasher_asm::ss_play_shockwave_finish,undefined,undefined,undefined,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"shockwaveanim",undefined,undefined,undefined);
	scripts\asm\asm::func_2375("rooftop_idle",undefined,::scripts\asm\asm::func_68B0,"end");
	scripts\asm\asm::func_2374("intro",::lib_0F3C::func_CEA8,undefined,undefined,undefined,undefined,::lib_0F3C::func_3E96,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,"intro_anim","face current","anim deltas",undefined);
	scripts\asm\asm::func_2375("ground_idle",undefined,::scripts\asm\asm::func_68B0,"end");
	scripts\asm\asm::func_2327();
}