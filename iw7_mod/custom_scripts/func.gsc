#include scripts\engine\utility;
#include scripts\cp\utility;
#include scripts\cp\cp_hud_util;
#include custom_scripts\catbox;
#include custom_scripts\util;
#include custom_scripts\menu;

/*
// breaks script on any other map than spaceland so this cant be used lol
give_sunglasses() // im so cool and epic and stuff
{
    // cant just call give_glasses_power because when you force give & turn off vision doesnt go away
    self thread launch_glasses_hook();
}

// hook so the glasses dont fucking launch in front of you
launch_glasses_hook()
{
    if (getdvar("mapname") == "cp_zmb")
    {
        self endon("deleting_glasses");
        // scripts\cp\powers\coop_powers::removepower("power_glasses"); // causes a shit ton of errors for some reason lol
        var_00 = 25;
        var_01 = self gettagorigin("tag_eye");
        var_02 = self gettagangles("tag_eye");
        var_02 = anglestoforward(var_02);
        var_03 = vectornormalize(var_02) + (0,0,0.25);
        var_03 = var_03 * var_00;
        var_04 = self getvelocity();
        var_03 = var_03 + var_04;
        var_05 = spawn("script_model",var_01);
        var_05 setmodel("zmb_sunglass_01_wm");
        var_05 physicslaunchserver(var_01,var_03);
        wait(0.1);
        var_05 thread scripts\cp\zombies\zombies_wor::pick_up_knocked_off_glasses();
        var_05 thread scripts\cp\zombies\zombies_wor::delete_glasses_after_time(10);
        var_05 waittill("trigger",var_06);
        var_06 scripts\cp\zombies\zombies_wor::give_glasses_power();
        var_05 notify("glasses_picked_up");
        var_05 delete();
    }
}

*/

check_weapon_class()
{
    self endon("disconnect");
    level endon("game_ended");

    for(;;)
    {
        // self iprintlnbold("^:" + self getcurrentweapon() + " | " + getweaponclass(self getcurrentweapon()));
        print(self getcurrentweapon() + " | " + getweaponclass(self getcurrentweapon()));
        wait 1;
    }
}

add_points(value)
{
    self setplayerdata("cp", "alienSession", "currency", value);
}

// zombies stuff
teleport_zombies()
{
    zombies = scripts\cp\cp_agent_utils::getaliveagentsofteam("axis");

    foreach(zombie in zombies)
    {
        zombie setorigin(bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglestoforward(self getplayerangles()) * 1000000, 0, self)["position"]);
    }
}

freeze_all_zombies()
{
    if (!self.frozen_zombies)
    {
        self iprintlnbold("zombies ^2frozen");
        self.frozen_zombies = true;

        foreach(zombie in get_zombies())
        {
            zombie freezecontrols(true);
        }
    }
    else
    {
        self iprintlnbold("zombies ^1unfrozen");
        self.frozen_zombies = false;

        foreach(zombie in get_zombies())
        {
            zombie freezecontrols(false);
        }
    }
}

zombies_ignore_me()
{
    if (!self.ignoreme) // works sort of in this game
    {
        self iprintlnbold("zombies ignore you ^2on");
        self.ignoreme = true;
    }
    else
    {
        self iprintlnbold("zombies ignore you ^1off");
        self.ignoreme = false;
    }
}

g_weapon(i)
{
    if (is_true(self.take_weapon) && i != "c4_zm") // allow giving c4 still (might need to do for more)
        self takeweapon(self getcurrentweapon());

    self scripts\cp\utility::_giveweapon(i);
    self switchtoweapon(i);
    self givemaxammo(i);
}

take_my_weapon(i)
{
    self takeweapon(self getcurrentweapon());
    self switchtoweapon(self getweaponslistprimaries()[1]);
}

drop_weapon(i)
{
    self dropitem(self getcurrentweapon());
}

intro()
{
    self iprintlnbold("^:welcome, " + self get_name());
}

// save and loading
save_position()
{
    self.saved_origin = self getorigin();
    self.saved_angles = self getplayerangles();
    self iprintlnbold("^:position saved - " + self.saved_origin + " / " + self.saved_angles);
}

load_position()
{
    if (!isdefined(self.saved_origin))
        return;

    self SetOrigin(self.saved_origin);
    self SetPlayerAngles(self.saved_angles);
}

save_pos_bind()
{
    self endon("disconnect");
    level endon("game_ended");

    for(;;)
    {
        self waittill("+actionslot 2");

        if (self GetStance() == "crouch")
        {
            self thread save_position();
        }
    }
}

load_pos_bind()
{
    self endon("disconnect");
    level endon("game_ended");

    for(;;)
    {
        self waittill("+actionslot 1");

        if (self GetStance() == "crouch")
        {
            self thread load_position();
        }
    }
}

// no clipping - fucks up sometimes and doesnt let you unlink ..
no_clip()
{
    self endon("nomoreufo");
    b = 0;
    for(;;)
    {
        self waittill("+melee_zoom");
        if (self adsButtonPressed())
        {
            if (b == 0)
            {
                b = 1;
                self thread go_no_clip();
            }
            else
            {
                b = 0;
                self notify("stop_noclip");
                self unlink();
            }
        }
    }
}

go_no_clip()
{
    self endon("stop_noclip");

    if (isdefined(self.newufo)) self.newufo delete();

    self.newufo = spawn("script_origin", self.origin);
    self.newufo.origin = self.origin;
    self playerlinkto(self.newufo);

    for(;;)
    {
        vec = anglestoforward(self getplayerangles());

        if (self FragButtonPressed())
        {
            end=(vec[0]*60,vec[1]*60,vec[2]*60);
            self.newufo.origin=self.newufo.origin+end;
        }
        wait 0.05;
    }
}

unlink_player() // cheeky fix for when no clip breaks lol
{
    self unlink();
}

toggle_take_weapon()
{
    self.take_weapon = !toggle(self.take_weapon);
    /*
    if (!isdefined(self.take_weapon)) self.take_weapon = false;
    self.take_weapon = !self.take_weapon;
    self iprintlnbold("taking weapon " + (self.take_weapon ? "^2on" : "^1off"));
    */
}

// fills but doesnt let you select -- look into this
fill_consumables() // fill all card slots
{
    self notify("meter_full");
    self.consumable_meter_full = 1;
    self.card_refills = 1;
    self setweaponammoclip("super_default_zm", 1);
    self setclientomnvar("zm_dpad_up_activated", 1);
    self setclientomnvar("zm_dpad_up_fill", 3000);
    self setclientomnvar("zm_consumables_remaining", 5);

    thread scripts\cp\zombies\zombies_consumables::dpad_consumable_selection_watch();
}

// perks
set_zombie_perk(perk)
{
    if (!scripts\cp\utility::has_zombie_perk(perk))
    {
        self thread give_zombie_perk(perk);
    }
    else
    {
        self thread take_zombie_perk(perk);
    }
}

// give perks immediately for no gesture anim
give_zombie_perk(perk)
{
    self thread scripts\cp\zombies\zombies_perk_machines::give_zombies_perk_immediate(perk, 1);
}

take_zombie_perk(perk)
{
    self thread scripts\cp\zombies\zombies_perk_machines::take_zombies_perk_immediate(perk);
}

perkaholic()
{
    foreach(perk in level.perks)
    {
        // give all perks except mule kick
        if (perk != "perk_machine_more")
        {
            self thread set_zombie_perk(perk);
        }
    }
}

get_perk_display_name(perk)
{
    switch(perk)
    {
    case "perk_machine_revive":
        return "Up n Atoms";
    case "perk_machine_tough":
        return "Tuff Enuff";
    case "perk_machine_run":
        return "Racing Stripes";
    case "perk_machine_flash":
        return "Quickies";
    case "perk_machine_more":
        return "Mule Munchies";
    case "perk_machine_rat_a_tat":
        return "Bang Bangs";
    case "perk_machine_boom":
        return "Bomb Stoppers";
    case "perk_machine_zap":
        return "Blue Boltz";
    case "perk_machine_fwoosh":
        return "Trail Blazers";
    case "perk_machine_smack":
        return "Slappy Taffy";
    case "perk_machine_deadeye":
        return "Deadeye Dewdrops";
    case "perk_machine_change":
        return "Change Chews";
    default:
        break;
    }
}

set_starter_perks()
{
    self scripts\cp\utility::giveperk("specialty_quickswap");
    self scripts\cp\utility::giveperk("specialty_stalker");
    self scripts\cp\utility::giveperk("specialty_fastoffhand");
    self scripts\cp\utility::giveperk("specialty_quickdraw");
    self scripts\cp\utility::giveperk("specialty_longersprint");
    self scripts\cp\utility::giveperk("specialty_fastsprintrecovery");
    self scripts\cp\utility::giveperk("specialty_reducedsway");
    self scripts\cp\utility::giveperk("specialty_bulletpenetration");
    self scripts\cp\utility::giveperk("specialty_marathon");

    // i actually have no clue what these do but whatever
    self setaimspreadmovementscale(0.5);
    self.perk_data["damagemod"].bullet_damage_scalar = 1.5;
    self.movespeedscaler = 1.1 * scripts\cp\perks\prestige::prestige_getmoveslowscalar();
    self.perk_data["gunslinger"].var_8723 = self.movespeedscaler;
}

// gestures
toggle_gesture_bind()
{
    if (!isdefined(self.gesture_bind)) self.gesture_bind = false;

    if (!self.gesture_bind)
    {
        self iprintlnbold("gesture bind ^:enabled ^7([{+actionslot 4}])");
        self thread gesture_bind();
    }
    else if (self.gesture_bind)
    {
        self iprintlnbold("gesture bind ^1off");
        self notify("stop_gesture_bind");
    }

    self.gesture_bind = !self.gesture_bind;
}

gesture_bind()
{
    self endon("disconnect");
    self endon("stop_gesture_bind");
    level endon("game_ended");

    for(;;)
    {
        self waittill("+actionslot 4");
        gestures = randomize("perk_machine_boom,perk_machine_revive.perk_machine_fwoosh,perk_machine_run,perk_machine_deadeye,perk_machine_change,perk_machine_rat_a_tat,perk_machine_zap,perk_machine_tough,perk_machine_flash,perk_machine_smack,perk_machine_more");
        self thread play_gesture(gestures);
    }
}

play_gesture(gesture)
{
    if (is_true(self.playingperkgesture))
        return;

    self thread scripts\cp\zombies\zombies_perk_machines::play_perk_gesture(gesture);
}

refill_my_ammo()
{
    weapons = self getweaponslistall();

    foreach(weap in weapons)
    {
        self max_ammo(weap);
    }
}

// fake bounces
spawn_bounce()
{
    x = int(self getpers("bouncecount"));
    x++;

    self setpers("bouncecount", x);
    self setpers("bouncepos" + x, self getorigin()[0] + "," + self getorigin()[1] + "," + self getorigin()[2]);
    self iprintlnbold("^:spawned a bounce at " + self getorigin());
}

delete_bounce()
{
    x = int(self getpers("bouncecount"));

    if (x == 0)
        return self iprintlnbold("no bounces to delete");

    iprintlnbold("^:bounce " + x + "deleted");
    x--;
    self setpers("bouncecount", x);
}

bounce_loop()
{
    while(!isdefined(undefined))
    {
        for(i=1; i<int(self getpers("bouncecount")) + 1; i++)
        {
            pos = perstovector(self getpers("bouncepos" + i));
            if (distance(self getorigin(), pos) < 90 && self getvelocity()[2] < -250)
            {
                self setvelocity(self getvelocity() - (0,0,self getvelocity()[2] * 2));
                wait 0.2;
            }
        }
        waitframe();
    }
}

// fake elevators
toggle_elevators()
{
    self.elevators = !toggle(self.elevators);

    if (self.elevators)
    {
        self thread elevators();
    }
    else
    {
        self notify("stop_elevator");
    }
}

elevators()
{
    self endon("disconnect");
    self endon("stop_elevator");
    level endon("game_ended");

    for(;;)
    {
        if (self adsButtonPressed() && self isButtonPressed("+stance") && self isOnGround() && !self isOnLadder() && !self isMantling())
        {
            self thread elevator_logic();
            wait 0.25;
        }
        else if (self isButtonPressed("+gostand"))
        {
            self thread stop_elevator();
            wait 0.05;
        }

        wait 0.05;
    }
}

elevator_logic()
{
    self endon("end_elevator");
    level endon("game_ended");
    self endon("disconnect");

    self.elevator = spawn("script_origin", self.origin, 1);
    self playerLinkTo(self.elevator, undefined);

    for(;;)
    {
        self.elevating = true;
        self.o = self.elevator.origin;
        wait 0.05;
        time = randomintrange(8,20);
        self.elevator.origin = self.o + (0, 0, time);
        wait 0.05;
    }
}

stop_elevator()
{
    if (isdefined(self.elevator))
    {
        self unlink();
        self.elevator delete();
        self.elevating = undefined;
        self notify("end_elevator");
    }
}

// auto proning
do_auto_prone()
{
    self.auto_prone = !toggle(self.auto_prone);

    if (self.auto_prone)
    {
        self thread auto_prone();
    }
    else
    {
        self notify("stop_auto_prone");
    }
}

auto_prone()
{
    self endon("disconnect");
    self endon("stop_auto_prone");

    for(;;)
    {
        self waittill("weapon_fired", weapon);

        if (self isOnGround())
        {
            wait 0.05;
            continue;
        }

        if (is_valid_weapon(weapon))
        {
            self thread loop_auto_prone();
            wait 0.2;
            self notify("temp_end");
        }
        else
        {
            wait 0.05;
            continue;
        }

        wait 0.05;
    }
}

loop_auto_prone()
{
    self endon("temp_end");
    self endon("stop_auto_prone");
    self endon("disconnect");
    level endon("game_ended");

    for(;;)
    {
        self setStance("prone");
        wait .01;
    }
}

// auto reload
do_auto_reload()
{
    self.auto_reload = !toggle(self.auto_reload);

    if (self.auto_reload)
    {
        self thread auto_reload();
    }
    else
    {
        self notify("stop_autoreload");
    }
}

auto_reload()
{
    self endon("stop_autoreload");
    self endon("disconnect");
    self waittill("next_wave_notify");

    weapon = self getcurrentweapon();
    self setweaponammoclip(weapon, 0);

    self thread auto_reload(); // reset function for next round
}

outline_zombies()
{
    self.zombie_outline = !toggle(self.zombie_outline);

    if (self.zombie_outline)
    {
        self thread zombie_outline_loop();
    }
    else
    {
        self notify("stop_outlining_zombies");

        foreach(zombie in get_zombies())
        {
            scripts\cp\cp_outline::disable_outline_for_players(zombie, get_players());
        }
    }
}

zombie_outline_loop()
{
    self endon("stop_outlining_zombies");
    level endon("game_ended");

    if (!isdefined(self.outline_color))
    {
        self.outline_color = 0;
    }

    for(;;)
    {
        foreach(zombie in get_zombies())
        {
            scripts\cp\cp_outline::enable_outline_for_players(zombie, get_players(), self.outline_color, 0, 0, "high");
        }
        wait 0.1;
    }
}

set_outline_color(value)
{
    self.outline_color = value;
}

spawn_zombie(archetype)
{
    team = "axis";

    if (archetype == "zombie_grey")
    {
        weapon = "iw7_zapper_grey";
    }
    else if (archetype == "the_hoff" || archetype == "pamgrier" || archetype == "elvira")
    {
        weapon = "iw7_ake_zmr+akepap2";
        team = "allies";
    }
    else
    {
        weapon = undefined;
    }

    scripts\mp\mp_agent::spawnnewagent(archetype, team, self bullet_trace(), self.angles, weapon);
}

set_round(value)
{
    level.wave_num = value;
}

hide_ui()
{
    self.hide_ui = !toggle(self.hide_ui);
    setdvar("cg_draw2d", !self.hide_ui);
}

toggle_branding()
{
    self.branding = !toggle(self.branding);
    setdvar("branding", !self.branding);
}


toggle_frozen_box()
{
    if (!isdefined(self.frozen_box)) self.frozen_box = false;

    if (!self.frozen_box)
    {
        self thread frozen_box_loop();
    }
    else if (self.frozen_box)
    {
        level.var_B162  = 1;
        level.var_13D01 = 4;
        self notify("stop_frozen_box");
    }

    self.frozen_box = !self.frozen_box;
}

frozen_box_loop()
{
    self endon("death");
    self endon("disconnect");
    self endon("stop_frozen_box");

    for(;;)
    {
        level.var_13D01 = 0;
        wait 1;
    }
}

set_max_bank()
{
    level.atm_amount_deposited = 2147483647;
}

demi_god()
{
    self endon("disconnect");
    level endon("game_ended");

    for(;;)
    {
        self.health = self.maxhealth;
        wait 0.05;
    }
}

toggle_third_person()
{
    if (!isdefined(self.third_person)) self.third_person = false;

    if (!self.third_person)
    {
        setdvar("camera_thirdPerson", 1);
        scripts\cp\utility::setthirdpersondof(1);
    }
    else if (self.third_person)
    {
        setdvar("camera_thirdPerson", 0);
        scripts\cp\utility::setthirdpersondof(0);
    }

    self.third_person = !self.third_person;
}

toggle_exo_movement()
{
    self.exo_movement = !toggle(self.exo_movement);

    if (self.exo_movement)
    {
        self allowdoublejump(1);
        self allowwallrun(1);
        self allowdodge(1);
        self allowMantle(1);
        self.disabledMantle = 0;
    }
    else
    {
        self allowdoublejump(0);
        self allowwallrun(0);
        self allowdodge(0);
        self allowMantle(0);
        self.disabledMantle = 1;
    }
}

self_revive_loop()
{
    level endon("game_ended");
    for(;;)
    {
        self.self_revive = 1;
        wait 3;
    }
}

// aimbot stuff
toggle_aimbot()
{
    self.aimbot = !toggle(self.aimbot);

    if (self.aimbot)
    {
        self.aimbot_weapon = self getcurrentweapon();
        self thread aimbot();
    }
    else
    {
        self notify("stop_aimbot");
    }
}

/*
aimbot()
{
    self endon("disconnect");
    self endon("stop_aimbot");

    for(;;)
    {
        self waittill("weapon_fired");

        foreach(zombie in get_zombies())
        {
            if (self getcurrentweapon() == self.aimbot_weapon)
            {
                trace = self bullet_trace();
                if (distance(zombie.origin, trace) < self.aimbot_range)
                {
                    // so we have to do a dodamage call here because callbackplayerdamage cries for some reason
                    // i really need to find the red hitmarker feedback idk what the shader is lol
                    if (self.aimbot_delay != 0)
                        wait (self.aimbot_delay);

                    zombie dodamage(500, zombie.origin, self, self, "MOD_TRIGGER_HURT", self getcurrentweapon());
                    self scripts\cp\cp_damage::updatedamagefeedback("hitcritical");
                }
            }
        }
    }
}
*/

aimbot() // from lurkzy
{
    while(true)
    {
        self waittill("weapon_fired", weapon);

        if(weapon == self.aimbot_weapon && !level.is_recording)
        {
            foreach(zombie in get_zombies())
            {
                data = get_random_hitloc();
                tag = zombie getTagOrigin( data[0] );
                hitloc = data[1];
                mod = data[2];
                offset = 0;
                MagicBullet(weapon, self getTagOrigin("j_head"), tag, self);
                zombie dodamage(500, zombie.origin, self, self, "MOD_TRIGGER_HURT", self getcurrentweapon());
                self scripts\cp\cp_damage::updatedamagefeedback("hitcritical");
            }
        }
    }
}

get_random_hitloc()
{
    data = [];
    data[data.size] = "j_hip_ri:right_leg_upper:MOD_RIFLE_BULLET:flesh_body";
    data[data.size] = "j_hip_le:left_leg_upper:MOD_RIFLE_BULLET:flesh_body";
    data[data.size] = "j_spineupper:torso_lower:MOD_RIFLE_BULLET:flesh_body";
    data[data.size] = "j_spinelower:torso_lower:MOD_RIFLE_BULLET:flesh_body";
    data[data.size] = "j_mainroot:torso_lower:MOD_RIFLE_BULLET:flesh_body";
    data[data.size] = "j_clavicle_ri:torso_upper:MOD_RIFLE_BULLET:flesh_body";
    data[data.size] = "j_clavicle_le:torso_upper:MOD_RIFLE_BULLET:flesh_body";
    data[data.size] = "j_shoulder_ri:right_arm_upper:MOD_RIFLE_BULLET:flesh_body";
    data[data.size] = "j_shoulder_le:left_arm_upper:MOD_RIFLE_BULLET:flesh_body";
    data[data.size] = "j_neck:neck:MOD_HEAD_SHOT:flesh_head";
    data[data.size] = "j_head:head:MOD_HEAD_SHOT:flesh_head";
    data[data.size] = "j_elbow_ri:right_arm_lower:MOD_RIFLE_BULLET:flesh_body";
    data[data.size] = "j_elbow_le:left_arm_lower:MOD_RIFLE_BULLET:flesh_body";
    data[data.size] = "j_wrist_ri:right_hand:MOD_RIFLE_BULLET:flesh_body";
    data[data.size] = "j_wrist_le:left_hand:MOD_RIFLE_BULLET:flesh_body";
    return strTok( data[ randomInt( data.size ) ], ":" );
}

// set to int & floats just incase here
set_aimbot_range(value)
{
    self.aimbot_range = int(value);
}

set_aimbot_delay(value)
{
    self.aimbot_delay = float(value);
}

set_aimbot_weapon()
{
    self.aimbot_weapon = self getcurrentweapon();
    self iprintlnbold("aimbot weapon set to ^:" + self.aimbot_weapon);
}

// set dvar stuff
set_timescale(value)
{
    setdvar("timescale", value);
}

set_gravity(value)
{
    setdvar("g_gravity", value);
    setdvar("bg_gravity", value);
}

set_bounces(value)
{
    setdvar("bg_bounces", value);
}

set_speed(value)
{
    setdvar("g_speed", value);
}

set_unlimited_sprint(value)
{
    setdvar("player_sprintUnlimited", value);
}

set_jump_height(value)
{
    setdvar("jump_height", value);
}

set_weapon_spread(value)
{
    setdvar("perk_weapSpreadMultiplier", value);
}

set_reload_time(value)
{
    setdvar("perk_weapReloadMultiplier", value);
}

set_empty_reload_time(value)
{
    setdvar("perk_weapReloadMultiplierEmpty", value);
}

set_full_bright(value)
{
    setdvar("r_fullbright", value);
}

give_xp(xp) // xp popup
{
    self thread scripts\cp\cp_persistence::give_player_xp(xp, 1);
}

max_ammo()
{
    weapons = self getWeaponsListPrimaries();
    foreach(weap in weapons)
    {
        self setweaponammostock(weap, 9999);
        //self setweaponammostock(weap, 9999, "left");
        // self setweaponammostock(weap, 9999, "right");
        self scripts\cp\powers\coop_powers::power_adjustcharges(2, "primary", 2);
        self scripts\cp\powers\coop_powers::power_adjustcharges(2, "secondary", 2);
    }
}

set_spectator()
{
    self.is_spectating = !toggle(self.is_spectating);

    if (self.is_spectating)
    {
        scripts\cp\utility::updatesessionstate("spectator");
    }
    else
    {
        scripts\cp\utility::updatesessionstate("playing");
    }
}

spawn_powerup(powerup)
{
    trace = self bullet_trace();
    level scripts\cp\loot::drop_loot(trace, undefined, powerup, undefined, undefined, 1);
}

derank()
{
    self thread set_rank(0);
    self thread set_prestige(0);
    self iprintlnbold("^:set rank & prestige to 0");
}

set_zombie_health()
{
    self endon("disconnect");
    level endon("game_ended");

    for(;;)
    {
        foreach(zombie in get_zombies())
        {
            zombie.maxhealth = 1;
            zombie.health = zombie.maxhealth;
        }

        wait 0.25;
    }
}

toggle_infinite_ammo()
{
    self.infinite_ammo = !toggle(self.infinite_ammo);

    if (self.infinite_ammo)
    {
        self thread infinite_ammo();
    }
    else
    {
        self notify("stop_infinite_ammo");
    }
}

infinite_ammo()
{
    self endon("disconnect");
    self endon("stop_infinite_ammo");
    level endon("game_ended");

    for(;;)
    {
        self waittill("reload");
        self setweaponammostock(self getcurrentweapon(), 9999);
        // self setweaponammostock(self getcurrentweapon(), 9999, "left");
        // self setweaponammostock(self getcurrentweapon(), 9999, "right");
        self scripts\cp\powers\coop_powers::power_adjustcharges(2, "primary", 2);
        self scripts\cp\powers\coop_powers::power_adjustcharges(2, "secondary", 2);
    }
}

toggle_infinite_equipment()
{
    self.infinite_equipment = !toggle(self.infinite_equipment);

    if (self.infinite_equipment)
    {
        self thread infinite_equipment();
    }
    else
    {
        self notify("stop_infinite_equipment");
    }
}

infinite_equipment()
{
    self endon("disconnect");
    self endon("stop_infinite_equipment");
    level endon("game_ended");

    for(;;)
    {
        self scripts\cp\powers\coop_powers::power_adjustcharges(2, "primary", 2);
        self scripts\cp\powers\coop_powers::power_adjustcharges(2, "secondary", 2);
        wait 2;
    }
}

set_first_weapon()
{
    self.weapon_one = self getcurrentweapon();
    self iprintlnbold("first weapon: ^:" + self.weapon_one);
}

set_second_weapon()
{
    self.weapon_two = self getcurrentweapon();
    self iprintlnbold("second weapon: ^:" + self.weapon_two);
}

nac_bind()
{
    self endon("disconnect");
    level endon("game_ended");

    for(;;)
    {
        self waittill("+actionslot 1");

        if (self in_menu())
            continue;

        if (self.weapon_one == "none" || self.weapon_two == "none")
        {
            // self iprintlnbold("select ^:both weapons^7 in the menu!");
            continue;
        }

        if (self getcurrentweapon() == self.weapon_one)
        {
            self nacto(self.weapon_two);
        }
        else
        {
            if (self getcurrentweapon() == self.weapon_two)
            {
                self nacto(self.weapon_one);
            }
        }
    }
}

nacto(weapon)
{
    current = self getcurrentweapon();
    self take_weapon(current);

    if (!self hasweapon(weapon))
    {
        self giveweapon(weapon);
    }

    self switchtoweapon(weapon);
    wait 0.1;
    self give_weapon(current);
}

instaswapto(weapon)
{
    current = self getcurrentweapon();
    self take_weapon(current);

    if (!self hasweapon(weapon))
    {
        self giveweapon(weapon);
    }

    self setspawnweapon(weapon);
    wait 0.1;
    self give_weapon(current);
}

take_weapon(weapon)
{
    if (!isdefined(self.givetake_weapons))
    {
        self.givetake_weapons = [];
    }

    self.givetake_weapons[weapon] = spawnstruct();
    self.givetake_weapons[weapon].stock = self getweaponammostock(weapon);
    self.givetake_weapons[weapon].clip = [];
    self.givetake_weapons[weapon].clip[0] = self getweaponammoclip(weapon, "right");
    self.givetake_weapons[weapon].clip[1] = self getweaponammoclip(weapon, "left");
    self takeweapon(weapon);
}

give_weapon(weapon)
{
    self giveweapon(weapon);

    if (isdefined(self.givetake_weapons) && isdefined(self.givetake_weapons[weapon]))
    {
        self setweaponammostock(weapon, self.givetake_weapons[weapon].stock);
        self setweaponammoclip(weapon, self.givetake_weapons[weapon].clip[0], "right");
        self setweaponammoclip(weapon, self.givetake_weapons[weapon].clip[1], "left");
    }
}

set_prestige(value)
{
    self setplayerdata("cp", "progression", "playerLevel", "prestige", value);
}

set_rank(value)
{
    value--;
    self setplayerdata("cp", "progression", "playerLevel", "xp", int(tablelookup("cp/zombies/rankTable.csv", 0, value, (value == int(tablelookup("cp/zombies/rankTable.csv", 0, "maxrank", 1))) ? 7 : 2)));
}

set_max_weapons()
{
    for(x = 1; x < 62; x++)
    {
        weapon = TableLookup("mp/statstable.csv", 0, x, 4);

        if (!isdefined(weapon) || weapon == "")
        {
            continue;
        }

        self setplayerdata("common", "sharedProgression", "weaponLevel", weapon, "cpXP", 54300);
        self setplayerdata("common", "sharedProgression", "weaponLevel", weapon, "prestige", 3);

        self iprintlnbold("set ^:" + weapon + "^7 to max");

        wait 0.175;
    }
}

complete_challenges()
{
    merits = getarraykeys(level.meritinfo);

    if (!isdefined(merits) || !merits.size)
    {
        return;
    }

    foreach(merit in merits)
    {
        meritInfo = level.meritinfo[merit]["targetval"];
        meritState = self getrankedplayerdata("cp", "meritState", merit);
        meritProgress = self getrankedplayerdata("cp", "meritProgress", merit);

        if (!isdefined(meritInfo))
        {
            continue;
        }

        if (meritState < meritInfo.size || meritProgress < meritInfo[(meritInfo.size - 1)])
        {
            if (meritProgress < meritInfo[(meritInfo.size - 1)])
            {
                self setplayerdata("cp", "meritProgress", merit, meritInfo[(meritInfo.size - 1)]);
                self iprintlnbold("completed challenge " + merit);
            }

            if (meritState < meritInfo.size)
            {
                self setplayerdata("cp", "meritState", merit, meritInfo.size);
                self iprintlnbold("completed challenge " + merit);
            }

            wait 0.175;
        }
    }
}

complete_active_contracts()
{
    contracts = getarraykeys(self.contracts);

    if (!isdefined(contracts) || !contracts.size)
    {
        return;
    }

    foreach(contract in contracts)
    {
        target = self.contracts[contract].target;
        progress = self getrankedplayerdata("cp", "contracts", "challenges", contract, "progress");

        if (!isdefined(progress) || !isdefined(target) || progress >= target)
        {
            continue;
        }

        self setplayerdata("cp", "contracts", "challenges", contract, "progress", target);
        self setplayerdata("cp", "contracts", "challenges", contract, "completed", 1);

        wait 0.01;
    }
}

unlock_soul_keys()
{
    self setplayerdata("cp", "haveSoulKeys", "soul_key_1", 1);
    self setplayerdata("cp", "haveSoulKeys", "soul_key_2", 1);
    self setplayerdata("cp", "haveSoulKeys", "soul_key_3", 1);
    self setplayerdata("cp", "haveSoulKeys", "soul_key_4", 1);
    self setplayerdata("cp", "haveSoulKeys", "soul_key_5", 1);

    self iprintlnbold("soul keys ^2given");
    wait 2.5;
    self iprintlnbold("active the jar to unlock director's cut");

    self set_position((-10250, 875, -1630), (0, 90, 0));
}

temp_directors_cut()
{
    self.temp_directors_cut = !toggle(self.temp_directors_cut);

    if (self.temp_directors_cut)
    {
        self setplayerdata("cp", "dc", 1);
    }
    else
    {
        self setplayerdata("cp", "dc", 0);
    }
}

itr_weapons()
{
    level.weaponArray = [];

    for(i=0; i<128; i++)
    {
        if (level.script == "cp_zmb")
            weapons_table = "cp/cp_weapontable.csv";
        else
            weapons_table = "cp/" + level.script + "_weapontable.csv";

        internalname = tablelookupbyrow(weapons_table, i, 1);
        if(internalname == "")
            continue;

        level.weaponArray[level.weaponArray.size] = internalname;
    }
}

pause_wave_progression()
{
    level waittill( "regular_wave_starting" );

    scripts\engine\utility::flag_set( "pause_wave_progression" );
    level.zombies_paused = 1;
    level.dont_resume_wave_after_solo_afterlife = 1;
}
