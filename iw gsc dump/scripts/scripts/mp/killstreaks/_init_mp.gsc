/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\killstreaks\_init_mp.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 1
 * Decompile Time: 53 ms
 * Timestamp: 10/27/2023 12:28:51 AM
*******************************************************************/

//Function Number: 1
init()
{
	scripts\mp\killstreaks\_killstreaks::func_9888();
	level.killstreaksetups = [];
	thread scripts\mp\killstreaks\_target_marker::init();
	thread scripts\mp\killstreaks\_uav::init();
	thread scripts\mp\killstreaks\_plane::init();
	thread scripts\mp\killstreaks\_airdrop::init();
	thread scripts\mp\killstreaks\_helicopter::init();
	thread scripts\mp\killstreaks\_nuke::init();
	thread scripts\mp\killstreaks\_a10::init();
	thread scripts\mp\killstreaks\_portableaoegenerator::init();
	thread scripts\mp\killstreaks\_ims::init();
	thread scripts\mp\killstreaks\_perkstreaks::init();
	thread scripts\mp\killstreaks\_juggernaut::init();
	thread scripts\mp\killstreaks\_ball_drone::init();
	thread scripts\mp\killstreaks\_autosentry::init();
	thread scripts\mp\killstreaks\_remotemissile::init();
	thread scripts\mp\killstreaks\_deployablebox::init();
	thread scripts\mp\killstreaks\_deployablebox_vest::init();
	thread scripts\mp\killstreaks\_deployablebox_gun::init();
	thread scripts\mp\killstreaks\_helisniper::init();
	thread scripts\mp\killstreaks\_helicopter_pilot::init();
	thread scripts\mp\killstreaks\_vanguard::init();
	thread scripts\mp\killstreaks\_uplink::init();
	thread scripts\mp\killstreaks\_dronehive::init();
	thread scripts\mp\killstreaks\_jammer_drone::init();
	thread scripts\mp\killstreaks\_air_superiority::init();
	thread scripts\mp\killstreaks\_odin::init();
	thread scripts\mp\killstreaks\_highvaluetarget::init();
	thread scripts\mp\killstreaks\_aalauncher::init();
	thread scripts\mp\killstreaks\_airstrike::init();
	thread scripts\mp\killstreaks\_orbital_deployment::init();
	thread scripts\mp\killstreaks\_deployable_speed_strip::init();
	thread scripts\mp\killstreaks\_deployable_adrenaline_mist::init();
	thread scripts\mp\killstreaks\_minijackal::init();
	thread scripts\mp\killstreaks\_spiderbot::init();
	thread scripts\mp\killstreaks\_thor::init();
	thread scripts\mp\killstreaks\_rc8::init();
	thread scripts\mp\killstreaks\_bombardment::init();
	thread scripts\mp\killstreaks\_venom::init();
	level.killstreakweildweapons = [];
	level.killstreakweildweapons["sentry_minigun_mp"] = "sentry";
	level.killstreakweildweapons["sentry_laser_mp"] = "sentry";
	level.killstreakweildweapons["sentry_shock_mp"] = "sentry_shock";
	level.killstreakweildweapons["sentry_shock_fast_mp"] = "sentry_shock";
	level.killstreakweildweapons["sentry_shock_missile_mp"] = "sentry_shock";
	level.killstreakweildweapons["sentry_shock_grenade_mp"] = "sentry_shock";
	level.killstreakweildweapons["hind_bomb_mp"] = "helicopter";
	level.killstreakweildweapons["hind_missile_mp"] = "helicopter";
	level.killstreakweildweapons["cobra_20mm_mp"] = "helicopter";
	level.killstreakweildweapons["nuke_mp"] = "nuke";
	level.killstreakweildweapons["manned_littlebird_sniper_mp"] = "heli_sniper";
	level.killstreakweildweapons["iw6_minigunjugg_mp"] = "airdrop_juggernaut";
	level.killstreakweildweapons["iw6_p226jugg_mp"] = "airdrop_juggernaut";
	level.killstreakweildweapons["mortar_shelljugg_mp"] = "airdrop_juggernaut";
	level.killstreakweildweapons["iw6_riotshieldjugg_mp"] = "airdrop_juggernaut_recon";
	level.killstreakweildweapons["iw6_magnumjugg_mp"] = "airdrop_juggernaut_recon";
	level.killstreakweildweapons["smoke_grenadejugg_mp"] = "airdrop_juggernaut_recon";
	level.killstreakweildweapons["iw7_knifejugg_mp"] = "airdrop_juggernaut_maniac";
	level.killstreakweildweapons["throwingknifejugg_mp"] = "airdrop_juggernaut_maniac";
	level.killstreakweildweapons["deployable_vest_marker_mp"] = "deployable_vest";
	level.killstreakweildweapons["deployable_weapon_crate_marker_mp"] = "deployable_ammo";
	level.killstreakweildweapons["heli_pilot_turret_mp"] = "heli_pilot";
	level.killstreakweildweapons["guard_dog_mp"] = "guard_dog";
	level.killstreakweildweapons["ims_projectile_mp"] = "ims";
	level.killstreakweildweapons["ball_drone_gun_mp"] = "ball_drone_backup";
	level.killstreakweildweapons["drone_hive_projectile_mp"] = "drone_hive";
	level.killstreakweildweapons["switch_blade_child_mp"] = "drone_hive";
	level.killstreakweildweapons["drone_hive_impulse_mp"] = "drone_hive";
	level.killstreakweildweapons["switch_blade_impulse_mp"] = "drone_hive";
	level.killstreakweildweapons["killstreak_uplink_mp"] = "uplink";
	level.killstreakweildweapons["odin_projectile_large_rod_mp"] = "odin_assault";
	level.killstreakweildweapons["odin_projectile_small_rod_mp"] = "odin_assault";
	level.killstreakweildweapons["iw6_gm6helisnipe_mp"] = "heli_sniper";
	level.killstreakweildweapons["iw6_gm6helisnipe_mp_gm6scope"] = "heli_sniper";
	level.killstreakweildweapons["aamissile_projectile_mp"] = "air_superiority";
	level.killstreakweildweapons["airdrop_marker_mp"] = "airdrop";
	level.killstreakweildweapons["remote_tank_projectile_mp"] = "vanguard";
	level.killstreakweildweapons["killstreak_vanguard_mp"] = "vanguard";
	level.killstreakweildweapons["agent_mp"] = "agent";
	level.killstreakweildweapons["agent_support_mp"] = "recon_agent";
	level.killstreakweildweapons["iw6_axe_mp"] = "juggernaut_swamp_slasher";
	level.killstreakweildweapons["venomxgun_mp"] = "venom_x_gun";
	level.killstreakweildweapons["venomxproj_mp"] = "venom_x_projectile";
	level.killstreakweildweapons["artillery_mp"] = "precision_airstrike";
	level.killstreakweildweapons["deployable_speed_strip_marker_mp"] = "deployable_speed_strip";
	level.killstreakweildweapons["deployable_adrenaline_mist_marker_mp"] = "deployable_adrenaline_mist";
	level.killstreakweildweapons["killstreak_fleet_swarm_mp"] = "fleet_swarm";
	level.killstreakweildweapons["fleet_swarm_projectile_mp"] = "fleet_swarm";
	level.killstreakweildweapons["killstreak_orbital_deployment_mp"] = "orbital_deployment";
	level.killstreakweildweapons["shockproj_mp"] = "minijackal";
	level.killstreakweildweapons["thorproj_mp"] = "thor";
	level.killstreakweildweapons["thorproj_tracking_mp"] = "thor";
	level.killstreakweildweapons["thorproj_zoomed_mp"] = "thor";
	level.killstreakweildweapons["minijackal_strike_mp"] = "minijackal";
	level.killstreakweildweapons["minijackal_assault_mp"] = "minijackal";
	level.killstreakweildweapons["killstreak_spiderbot_mp"] = "spiderbot";
	level.killstreakweildweapons["iw7_webhook_mp"] = "spiderbot";
	level.killstreakweildweapons["bombproj_mp"] = "bombardment";
	level.killstreakweildweapons["dummy_spike_large_mp"] = "remote_c8";
	level.killstreakweildweapons["iw7_c8destruct_mp"] = "remote_c8";
	level.killstreakweildweapons["iw7_c8shutdown_mp"] = "remote_c8";
	level.killstreakweildweapons["iw7_c8landing_mp"] = "remote_c8";
	level.killstreakweildweapons["iw7_c8offhandshield_mp"] = "remote_c8";
	level.killstreakweildweapons["iw7_chargeshot_c8_mp"] = "remote_c8";
	level.killstreakweildweapons["iw7_minigun_c8_mp"] = "remote_c8";
	level.killstreakweildweapons["dummy_spike_mp"] = "remote_c8";
	level.killstreakweildweapons["venomproj_mp"] = "venom";
	level.killstreakweildweapons["shard_ball_mp"] = "venom";
	level.killstreakweildweapons["jackal_turret_mp"] = "jackal";
	level.killstreakweildweapons["jackal_cannon_mp"] = "jackal";
	level.killstreakweildweapons["jackal_fast_cannon_mp"] = "airdrop";
	level.killstreakweildweapons["jackal_airstrike_turret_mp"] = "precision_airstrike";
	level.killstreakweildweapons["deploy_dronepackage_mp"] = "marker";
	level.killstreakweildweapons["deploy_rc8_mp"] = "marker";
	level.killstreakweildweapons["deploy_warden_mp"] = "marker";
	if(isdefined(level.var_B334))
	{
		[[ level.var_B334 ]]();
	}

	level.var_A6AA = scripts\mp\_utility::getintproperty("scr_game_killstreakdelay",12);
	level thread scripts\mp\killstreaks\_killstreaks::onplayerconnect();
	scripts\mp\killstreaks\_mapselect::func_B337();
}