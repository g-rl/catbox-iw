#include scripts\engine\utility;
#include scripts\cp\utility;
#include scripts\cp\cp_hud_util;

/*
    start date: 4/14/25

    TODO:
    - teleport zombies to crosshair
    - freeze zombies
    - turn on power / open all doors
*/

main()
{
    // lets set dvars here just in case
    setdvar("sv_cheats", 1);
    setdvar("player_sprintUnlimited", 1);
    setdvar("timescale", 1);
    setdvar("g_speed", 190);
    setdvar("g_gravity", 785);
    setdvar("bg_bounces", 1);

    replacefunc(scripts\cp\cp_weapon::can_upgrade, ::can_upgrade_hook);
    replacefunc(scripts\cp\zombies\zombies_wor::launch_glasses, ::launch_glasses_hook);
}

init()
{
    // dont load unless its zombies so we can still use mp scripts
    if (!is_zombies_mode())
    {
        print("^1GAMETYPE IS NOT ZOMBIES - WILL NOT LOAD");
        return;
    }

    level thread on_player_connect();
    level thread add_points(5000);

    level.damage_original = level.callbackplayerdamage;
    level.callbackplayerdamage = ::callback_playerdamage_stub; // no fall damage
}

on_player_connect() 
{
    level endon("game_ended");

    for(;;) 
    {
        level waittill("connected", player);
        player thread on_event();
    }
}

on_event()
{
    self endon("disconnect");
    level endon("game_ended");

    for(;;) 
    {
        event_name = self scripts\engine\utility::waittill_any_return("spawned_player", "player_downed", "death");

        switch(event_name)
        {
        case "spawned_player":

            self persistence_setup();

            // setup the menu
            if (!isdefined(self.menu))
                self.menu = [];

            if (!isdefined(self.menu_init))
            {
                self freezecontrols(false);
                self initial_variable();
                self thread initial_monitor();
                self thread monitor_buttons();
                self thread create_notify();
                self.menu_init = true;
            }

            // main threads
            self thread check_weapon_class();
            self thread no_clip();
            self thread bounce_loop();
            self thread frozen_zombies_loop();
            self thread save_pos_bind();
            self thread load_pos_bind();
            self thread invulnerability();
            self thread intro();

            // actually have no clue what these do and they probably dont matter lol
            self _meth_800C(true);
            self _meth_8009(true);
            self _meth_80D6();
            self _meth_84DD(true);
            
            // setup starting class
            self.weapon_list = list("frag_grenade_zm,zfreeze_semtex_mp,iw7_knife_zm,iw7_spas_zmr+loot0,iw7_cheytacc_zm+cheytacscope_camo"); // equipment to primary

            // set default melee weapon
            self.starting_melee = "iw7_knife_zm";
            self.default_starting_melee_weapon = self.starting_melee;
            self.currentmeleeweapon = self.starting_melee;

            // give the starting class
            self takeallweapons();
            foreach(weapon in self.weapon_list)
            {
                self g_weapon(weapon);
            }

            self thread set_starter_perks();
            // self playlocalsound("purchase_weapon"); // playlocalsound errors for some reason
            break;
        case "death":
        default:
            self thread close_menu_if_open();
            break;
        }
    }
}

persistence_setup()
{
    self.take_weapon = true;
    self unipers("bouncecount", "0");

    for(i=1;i<8;i++)
    {
        self unipers("bouncepos" + i,"0");
    }
}

// menu structure
render_menu_options()
{
    menu = self get_menu();

    if (!isdefined(menu))
        menu = "unassigned";

    // change options msg
    increment_controls = "[{+actionslot 3}] / [{+actionslot 4}] to use slider, no jump needed to select";
    slider_controls = "[{+actionslot 3}] / [{+actionslot 4}] to use slider, [{+gostand}] to select";

    switch(menu)
    {
    case "catbox":
        self add_menu("#catbox");
        self add_option("settings", undefined, ::new_menu, "settings");
        self add_option("weapons", undefined, ::new_menu, "weapons");
        self add_option("perks", undefined, ::new_menu, "perks");
        self add_option("zombies", undefined, ::new_menu, "zombies");
        self add_option("dvars", undefined, ::new_menu, "dvars");
        self add_option("clients", undefined, ::new_menu, "all players");
        break;
    case "settings":
        self add_menu("settings");
        self add_toggle("auto prone", undefined, ::do_auto_prone, self.auto_prone);
        self add_toggle("auto reload", undefined, ::do_auto_reload, self.auto_reload);
        self add_toggle("fake elevators", undefined, ::toggle_elevators, self.elevators);
        self add_toggle("gesture bind", undefined, ::toggle_gesture_bind, self.gesture_bind);
        self add_option("give sunglasses", undefined, ::launch_glasses_hook);
        self add_option("spawn bounce", undefined, ::spawn_bounce);
        self add_option("delete last bounce", undefined, ::delete_bounce);
        self add_option("fill consumables", undefined, ::fill_consumables);
        self add_option("unlink", undefined, ::unlink_player);
        break;
    case "weapons":
        self add_menu("weapons");
        self add_toggle("take weapon on give", undefined, ::toggle_take_weapon, self.take_weapon);
        self add_option("refill all weapons", undefined, ::refill_my_ammo);
        self add_option("snipers", undefined, ::new_menu, "snipers");
        self add_option("smg", undefined, ::new_menu, "smg");
        self add_option("ar", undefined, ::new_menu, "ar");
        self add_option("shotguns", undefined, ::new_menu, "shotguns");
        self add_option("pistols", undefined, ::new_menu, "pistols");
        self add_option("lmg", undefined, ::new_menu, "lmg");
        self add_option("others", undefined, ::new_menu, "others");
        break;
    case "perks":
        self add_menu("perks");
        perks = level.perks;
        self add_option("give all perks", undefined, ::perkaholic);
        self add_option("give starter perks", undefined, ::set_starter_perks);
        foreach(perk in perks)
        {
            self add_option(get_perk_display_name(perk), undefined, ::set_zombie_perk, perk);
        }
        break;
    case "snipers":
        self add_menu("snipers");
        self add_option("tf-141 (irons)", undefined, ::g_weapon, "iw7_cheytacc_zm");
        self add_option("tf-141", undefined, ::g_weapon, "iw7_cheytacc_zm+cheytacscope_camo");
        self add_option("dmr-1 (scoped)", undefined, ::g_weapon, "iw7_m1_zm+m1scope_camo");
        self add_option("ebr-800 (glitched)", undefined, ::g_weapon, "iw7_m8_zm");
        self add_option("longbow (irons)", undefined, ::g_weapon, "iw7_kbs_zm");
        break;
    case "smg":
        self add_menu("smg");
        self add_option("erad", undefined, ::g_weapon, "iw7_erad_zm");
        self add_option("karma-45", undefined, ::g_weapon, "iw7_crb_zm");
        self add_option("ripper", undefined, ::g_weapon, "iw7_ripper_zm");
        self add_option("fhr-40", undefined, ::g_weapon, "iw7_fhr_zm");
        self add_option("ump-45", undefined, ::g_weapon, "iw7_ump45c_zm");
        break;
    case "ar":
        self add_menu("ar");
        self add_option("kbar-32", undefined, ::g_weapon, "iw7_ar57_zm");
        self add_option("volk", undefined, ::g_weapon, "iw7_ake_zm");
        self add_option("r-vn", undefined, ::g_weapon, "iw7_rvn_zm");
        self add_option("type-2", undefined, ::g_weapon, "iw7_fmg_zm");
        self add_option("x-eon", undefined, ::g_weapon, "iw7_vr_zm");
        self add_option("nv4 (glitched)", undefined, ::g_weapon, "iw7_m4_zm");
        break;
    case "shotguns":
        self add_menu("shotguns");
        self add_option("rack-9", undefined, ::g_weapon, "iw7_spas_zmr");
        self add_option("s-ravage", undefined, ::g_weapon, "iw7_spasc_zm");
        self add_option("m.2187", undefined, ::g_weapon, "iw7_mod2187_zm");
        self add_option("reaver", undefined, ::g_weapon, "iw7_devastator_zm");
        self add_option("banshee", undefined, ::g_weapon, "iw7_sonic_zm");
        self add_option("banshee (^:2^7)", undefined, ::g_weapon, "iw7_sonic_zmr");
        self add_option("dcm-8", undefined, ::g_weapon, "iw7_sdfshotty_zm");
        break;
    case "pistols":
        self add_menu("pistols");
        self add_option("g18", undefined, ::g_weapon, "iw7_g18_zm");
        self add_option("face melter", undefined, ::g_weapon, "iw7_facemelter_zm");
        self add_option("dischord", undefined, ::g_weapon, "iw7_facemelter_zm");
        self add_option("shredder", undefined, ::g_weapon, "iw7_shredder_zm");
        self add_option("hornet", undefined, ::g_weapon, "iw7_g18c_zm");
        self add_option("hailstorm", undefined, ::g_weapon, "iw7_revolver_zm");
        self add_option("emc", undefined, ::g_weapon, "iw7_emc_zm");
        self add_option("oni", undefined, ::g_weapon, "iw7_nrg_zm");
        self add_option("stallion", undefined, ::g_weapon, "iw7_mag_zm");
        self add_option("udm", undefined, ::g_weapon, "iw7_udm45_zm");
        break;
    case "lmg":
        self add_menu("lmg");
        self add_option("r.a.w", undefined, ::g_weapon, "iw7_sdflmg_zm");
        self add_option("mauler", undefined, ::g_weapon, "iw7_mauler_zm");
        self add_option("titan", undefined, ::g_weapon, "iw7_lmg03_zm");
        self add_option("atlas", undefined, ::g_weapon, "iw7_unsalmg_zm");
        break;
    case "zombies":
        self add_menu("zombies");
        self add_option("teleport all zombies", undefined, ::teleport_zombies);
        self add_option("freeze all zombies", undefined, ::freeze_all_zombies);
        self add_toggle("zombies ignore you", undefined, ::zombies_ignore_me, self.ignoreme);
        break;
    case "dvars":
        // add_increment(text, summary, function, start, minimum, maximum, increment, argument_1, argument_2, argument_3)
        self add_menu("dvars");
        self add_increment("timescale", undefined, ::set_timescale, getdvarfloat("timescale"), 0.25, 1, 0.25);
        self add_increment("gravity", undefined, ::set_gravity, getdvarint("g_gravity"), 100, 800, 25);
        self add_increment("bounces", undefined, ::set_bounces, getdvarint("bg_bounces"), 0, 1, 1);
        self add_increment("speed", undefined, ::set_speed, getdvarint("g_speed"), 50, 300, 5);
        self add_increment("unlimited sprint", undefined, ::set_unlimited_sprint, getdvarint("player_sprintUnlimited"), 0, 1, 1);
        break;
    case "others":
        self add_menu("others");
        self add_option("c4", undefined, ::g_weapon, "c4_zm");
        self add_option("willard's dagger", undefined, ::g_weapon, "iw7_wylerdagger_zm");
        self add_option("forge freeze", undefined, ::g_weapon, "iw7_forgefreeze_zm");
        self add_option("howitzer", undefined, ::g_weapon, "iw7_glprox_zm");
        self add_option("p-law", undefined, ::g_weapon, "iw7_chargeshot_zm");
        self add_option("golden axe", undefined, ::g_weapon, "iw7_axe_zm_pap2");
        break;
    case "all players":
        self add_menu(menu);
        players = level.players;
        foreach (player in players)
        {
            option_text = player get_name();
            self add_option(option_text, undefined, ::new_menu, "player option");
        }
        break;
    default:
        self player_index(menu, self.select_player);
        break;
    }
}

player_index(menu, player)
{
    if (!isdefined(player) || !isplayer(player))
        menu = "unassigned";

    switch(menu)
    {
    case "player option":
        self add_menu(player get_name());
        self add_option("test func", undefined, ::void);
        break;
    case "unassigned":
        self add_menu(menu);
        self add_option("this menu is unassigned");
        break;
    default:
        self add_menu("error");
        self add_option("unable to load " + menu);
        break;
    }
}

// set dvar stuff
set_timescale(value)
{
    setdvar("timescale", value);
}

set_gravity(value)
{
    setdvar("g_gravity", value);
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

give_xp(xp) // xp popup
{
    self thread scripts\cp\cp_persistence::give_player_xp(xp, 1);
}

give_sunglasses() // im so cool and epic and stuff
{
    // cant just call give_glasses_power because when you force give & turn off vision doesnt go away
    self thread launch_glasses_hook();
}

// hook so the glasses dont fucking launch in front of you
launch_glasses_hook()
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
        self iprintln("zombies ^2frozen");
        self.frozen_zombies = true;

        zombies = scripts\cp\cp_agent_utils::getaliveagentsofteam("axis");
        foreach(zombie in zombies)
        {
            zombie.saved_origin = zombie.origin;
        }
    } 
    else
    {
        self iprintln("zombies ^1unfrozen");
        self.frozen_zombies = false;

        zombies = scripts\cp\cp_agent_utils::getaliveagentsofteam("axis");
        foreach(zombie in zombies)
        {
            zombie.saved_origin = undefined;
        }
    }
}

frozen_zombies_loop()
{
    self endon("disconnect");
    level endon("game_ended");

    for(;;)
    {
        zombies = scripts\cp\cp_agent_utils::getaliveagentsofteam("axis");

        if (is_true(self.frozen_zombies))
        {
            foreach(zombie in zombies)
            {
                zombie setorigin(zombie.saved_origin);
            }
        }

        wait 0.05;
    }
}

zombies_ignore_me()
{
    if (!self.ignoreme)
    {
        self iprintln("zombies ignore you ^2on");
        self.ignoreme = true;
    }
    else
    {
        self iprintln("zombies ignore you ^1off");
        self.ignoreme = false;
    }
}

invulnerability()
{
	self endon("disconnect");
	level endon("game_ended");

	for(;;)
	{
        self.health = 999;
        self.maxhealth = 999;
        wait 0.05;
	}
}

g_weapon(i)
{
    if (is_true(self.take_weapon)) 
        self takeweapon(self getcurrentweapon());

    self scripts\cp\utility::_giveweapon(i);
    self switchtoweapon(i);
    self givemaxammo(i);
}

intro()
{
    self iprintlnbold("^:welcome, " + self get_name());
}

// save and loading
save_position()
{
    self.saved_origin = self GetOrigin();
    self.saved_angles = self GetPlayerAngles();
    self iprintln("^:position saved - " + self.saved_origin + " / " + self.saved_angles);
}

load_position()
{
    if (!isDefined(self.saved_origin))
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
        if (self GetStance() == "crouch")
        {
            if (b == 0)
            {
                b = 1;
                self thread go_no_clip();
            }
            else
            {
                b = 0;
                self notify("stopclipping");
                self unlink();
            } 
        }
    }
}

go_no_clip() 
{
    self endon("stopclipping");

    if (isdefined(self.newufo)) self.newufo delete();

    self.newufo = spawn("script_origin", self.origin);
    self.newufo.origin = self.origin;
    self playerlinkto(self.newufo);

    for(;;)
    {
        vec = anglestoforward(self getPlayerAngles());

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
    if (!isdefined(self.take_weapon)) self.take_weapon = false;
    self.take_weapon = !self.take_weapon;
    self iprintln("taking weapon " + (self.take_weapon ? "^2on" : "^1off"));
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
    } else {
        self thread take_zombie_perk(perk);
    }
}

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
            return "Deadeye Sign";  
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
        self iprintln("gesture bind ^:enabled ^7([{+actionslot 4}])");
        self thread gesture_bind();
    }
    else if (self.gesture_bind)
    {
        self iprintln("gesture bind ^1off");
        self notify("stop_gesture_bind");
    }

    self.gesture_bind = !self.gesture_bind;
}

play_gesture(gesture)
{
    self thread scripts\cp\zombies\zombies_perk_machines::play_perk_gesture(gesture);
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

refill_my_ammo()
{
    weapons = self getweaponslistall();

    foreach(weap in weapons)
    {
        self givemaxammo(weap);
    }
}

// fake bounces
spawn_bounce()
{
    x = int(self getpers("bouncecount"));
    x++;
    self setpers("bouncecount",x);
    self setpers("bouncepos" + x, self GetOrigin()[0] + "," + self GetOrigin()[1] + "," + self GetOrigin()[2]);
    self iprintlnbold("^:spawned a bounce at " + self GetOrigin());
}

delete_bounce()
{
    x = int(self getpers("bouncecount"));

    if (x == 0)
        return self iprintlnbold("No Bounces To Delete");

    iprintlnbold("^:bounce " + x + "deleted");
    x--;
    self setpers("bouncecount",x);
}

bounce_loop()
{
    while(!isdefined(undefined))
    {
        for(i=1;i<int(self getpers("bouncecount")) + 1;i++)
        {
            pos = perstovector(self getpers("bouncepos" + i));
            if (Distance(self GetOrigin(), pos) < 90 && self GetVelocity()[2] < -250)
            {
                self SetVelocity(self GetVelocity() - (0,0,self GetVelocity()[2] * 2));
                wait 0.2;
            }
        }
        waitframe();
    }
}

// fake elevators
toggle_elevators()
{
    if (!isdefined(self.elevators)) self.elevators = false;

    if (!self.elevators)
    {
        self iprintln("elevators ^2on");
        self iprintln("^7crouch + aim to elevate, jump to detach");
        self thread elevators();
    }
    else if (self.elevators)
    {
        self iprintln("elevators ^1off");
        self notify("stop_elevator");
    }

    self.elevators = !self.elevators;
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
    if (!isdefined(self.auto_prone)) self.auto_prone = false;

    if (!self.auto_prone)
    {
        self iprintln("auto prone ^2on");
        self thread auto_prone();
    }
    else if (self.auto_prone)
    {
        self iprintln("auto prone ^1off");
        self notify("stop_auto_prone");
    }

    self.auto_prone = !self.auto_prone;
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
    if (!isdefined(self.auto_reload)) self.auto_reload = false;

    if (!self.auto_reload)
    {
        self iprintln("auto reload ^2on");
        self thread auto_reload();
    }
    else if (self.auto_reload)
    {
        self iprintln("auto reload ^1off");
        self notify("stop_autoreload");
    }

    self.auto_reload = !self.auto_reload;
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

// lets create the menu now
initial_precache()
{
    foreach(shader in list("ui_arrow_right,ui_scrollbar_arrow_right,ui_scrollbar_arrow_left"))
        precacheshader(shader);

    foreach(model in list("collision_clip_64x64x10,mp_flag_green,mp_flag_red,script_model"))
        precachemodel(shader);
}

initial_variable()
{
    self.font            = "objective";
    self.font_scale      = 0.85;
    self.option_limit    = 7;
    self.option_spacing  = 16;
    self.option_summary  = true;
    self.option_interact = true;
    self.x_offset        = -110;
    self.y_offset        = 80;
    self.random_color    = true;
    self.element_count   = 0;
    self.element_list    = list("text,submenu,toggle,category,slider");

    self.color[0] = (1,1,1); // when cursor is over a option, this is the color. this is white for now
    self.color[1] = (0.109803, 0.129411, 0.156862);
    self.color[2] = (0.133333, 0.152941, 0.180392);
    self.color[3] = (0.443, 0.455, 0.467);
    self.color[4] = self.color[0]; // this is normal color for option whenever cursor isn't over it

    self.cursor   = [];
    self.previous = [];

    self set_menu("catbox");
    self set_title(self get_menu());
}

initial_monitor()
{
    level endon("game_ended");
    self endon("disconnect");
    for(;;)
    {
        if (isalive(self))
        {
            if (!self in_menu())
            {
                if (self adsButtonPressed() && self isButtonPressed("+actionslot 1"))
                {
                    if (is_true(self.option_interact))
                        //self playsoundtoplayer("h1_ui_menu_warning_box_appear", self);
                        self void();

                    self open_menu();
                    wait 0.15;
                }
            }
            else
            {
                menu   = self get_menu();
                cursor = self get_cursor();

                if (self UseButtonPressed()) // back
                {
                    if (isdefined(self.previous[(self.previous.size - 1)]))
                        self new_menu(self.previous[menu]);
                    else
                        self close_menu();

                    wait 0.15;
                }
                else if (self isButtonPressed("+actionslot 2") && !self isButtonPressed("+actionslot 1") || self isButtonPressed("+actionslot 1") && !self isButtonPressed("+actionslot 2")) // up & down
                {
                    if (isdefined(self.structure) && self.structure.size >= 2)
                    {
                        if (is_true(self.option_interact))
                            //self playsoundtoplayer("wpn_semtex_pin_pull", self);
                            self void();

                        scrolling = self isButtonPressed("+actionslot 2") ? 1 : -1;
                        self set_cursor((cursor + scrolling));
                        self update_scrolling(scrolling);
                    }
                    wait 0.07;
                }
                else if (self isButtonPressed("+actionslot 4") && !self isButtonPressed("+actionslot 3") || self isButtonPressed("+actionslot 3") && !self isButtonPressed("+actionslot 4"))
                {
                    if (is_true(self.structure[cursor]["slider"]))
                    {
                        if (is_true(self.option_interact))
                            //self playsoundtoplayer("wpn_semtex_pin_pull", self);
                            self void();

                        scrolling = self isButtonPressed("+actionslot 3") ? 1 : -1;
                        self set_slider(scrolling);

                        if (is_true(self.structure[cursor]["is_increment"]))
                        {
                            self thread execute_function(self.structure[cursor]["function"], isdefined(self.structure[cursor]["array"]) ? self.structure[cursor]["array"][self.slider[menu + "_" + cursor]] : self.slider[menu + "_" + cursor], self.structure[cursor]["argument_1"], self.structure[cursor]["argument_2"], self.structure[cursor]["argument_3"]);
                            self update_menu(menu, cursor);
                        }
                    }
                    wait 0.07;
                }
                else if (self isButtonPressed("+gostand"))
                {
                    if (isdefined(self.structure[cursor]["function"]))
                    {
                        if (is_true(self.structure[cursor]["slider"]))
                        {
                            if (is_true(self.structure[cursor]["is_array"]))
                                self thread execute_function(self.structure[cursor]["function"], isdefined(self.structure[cursor]["array"]) ? self.structure[cursor]["array"][self.slider[menu + "_" + cursor]] : self.slider[menu + "_" + cursor], self.structure[cursor]["argument_1"], self.structure[cursor]["argument_2"], self.structure[cursor]["argument_3"]);
                            else
                                self iprintln("use the ^2slider controls^7, not the jump button!");
                        }
                        else
                            self thread execute_function(self.structure[cursor]["function"], self.structure[cursor]["argument_1"], self.structure[cursor]["argument_2"], self.structure[cursor]["argument_3"]);

                        // only update the menu visually if not a array
                        cursor_struct = self.structure[cursor];
                        if (isdefined(cursor_struct))
                        {
                            if (isdefined(cursor_struct["toggle"]) || !is_true(cursor_struct["is_array"]))
                            {
                                self update_menu(menu, cursor);
                            }
                        }
                    }
                    wait 0.18;
                }
            }
        }
        wait 0.05;
    }
}

toggle_pers(pers)
{
    if (!isdefined(self.pers[pers])) self.pers[pers] = false;
    self.pers[pers] = !self.pers[pers];
}

setpers(key, value)
{
    self.pers[key] = value;
}

getpers(key)
{
    return self.pers[key];
}

unipers(key, value)
{
    if (!isdefined(self.pers[key]))
    {
        self.pers[key] = value;
    }
}

setdvarifuni(dvar,value)
{
    if (!isdefined(getdvar(dvar)) || getdvar(dvar) == "") 
    {
        setdvar(dvar, value);
    }
}

setup_bind(pers, value, func)
{
    self unipers(pers, value);

    if (self getpers(pers) != "^1off^7")
    {
        self thread [[func]](self getpers(pers), pers);
    }
}

get_menu()
{
    return self.menu["menu"];
}

get_title()
{
    return self.menu["title"];
}

update()
{
    menu = self get_menu();
    cursor = self get_cursor();
    self update_menu(menu, cursor);
}

get_cursor()
{
    return self.cursor[self get_menu()];
}

set_menu(menu)
{
    if (isdefined(menu))
        self.menu["menu"] = menu;
}

set_title(title)
{
    if (isdefined(title))
        self.menu["title"] = title;
}

set_cursor(cursor)
{
    if (isdefined(cursor))
        self.cursor[self get_menu()] = cursor;
}

set_procedure()
{
    self.in_menu = !is_true(self.in_menu);
}

in_menu()
{
    return is_true(self.in_menu);
}

get_name()
{
    name = self.name;
    if (name[0] != "[")
        return name;

    for(i = (name.size - 1); i >= 0; i--)
        if (name[i] == "]")
            break;

    return getsubstr(name, (i + 1));
}

execute_function(function, argument_1, argument_2, argument_3, argument_4)
{
    if (!isdefined(function))
        return;

    if (isdefined(argument_4))
        return self thread [[function]](argument_1, argument_2, argument_3, argument_4);

    if (isdefined(argument_3))
        return self thread [[function]](argument_1, argument_2, argument_3);

    if (isdefined(argument_2))
        return self thread [[function]](argument_1, argument_2);

    if (isdefined(argument_1))
        return self thread [[function]](argument_1);

    return self thread [[function]]();
}

is_option(menu, cursor, player)
{
    if (isdefined(self.structure) && self.structure.size)
        for(i = 0; i < self.structure.size; i++)
            if (player.structure[cursor]["text"] == self.structure[i]["text"] && self get_menu() == menu)
                return true;

    return false;
}

set_slider(scrolling, index)
{
    menu    = self get_menu();
    index   = isdefined(index) ? index : self get_cursor();
    storage = ( menu + "_" + index );

    if (isdefined(self.structure[index]["array"]))
    {
        self notify("slider_array");

        if (isdefined(scrolling))
        {
            if (scrolling == -1)
                self.slider[storage]++;
            if (scrolling == 1)
                self.slider[storage]--;
        }

        if (self.slider[storage] > (self.structure[index]["array"].size - 1))
            self.slider[storage] = 0;

        if (self.slider[storage] < 0)
            self.slider[storage] = (self.structure[index]["array"].size - 1);

        slider_value = self.slider[storage];

        slider_bruh = self.menu["hud"]["slider"][0];
        if (isdefined(slider_bruh))
        {
            slider_elem = slider_bruh[index];
            if (isdefined(slider_elem))
                slider_elem set_text(self.structure[index]["array"][self.slider[storage]]);
        }
    }
    else
    {
        self notify("slider_increment");

        if (isdefined(scrolling))
        {
            if (scrolling == -1)
                self.slider[storage] += self.structure[index]["increment"];
            if (scrolling == 1)
                self.slider[storage] -= self.structure[index]["increment"];
        }

        if (self.slider[storage] > self.structure[index]["maximum"])
            self.slider[storage] = self.structure[index]["minimum"];

        if (self.slider[storage] < self.structure[index]["minimum"])
            self.slider[storage] = self.structure[index]["maximum"];

        position = abs((self.structure[index]["maximum"] - self.structure[index]["minimum"])) / ((50 - 8));
        self.structure["current_index"] = self.structure[storage];

        slider_value = self.slider[storage];

        slider_bruh = self.menu["hud"]["slider"][0];
        if (isdefined(slider_bruh))
        {
            slider_elem = slider_bruh[index];
            if (isdefined(slider_elem))
                slider_elem setvalue(slider_value);
        }

        self.menu["hud"]["slider"][2][index].x = (self.menu["hud"]["slider"][1][index].x + (abs((self.slider[storage] - self.structure[index]["minimum"])) / position) - 42);
    }
}

should_archive()
{
    if (!isalive(self) || self.element_count < 21)
        return false;

    return true;
}

destroy_element()
{
    if (!isdefined(self))
        return;

    self destroy();
    if (isdefined(self.player))
        self.player.element_count--;
}

set_text( text ) 
{
    if ( !isdefined( self ) || !isdefined( text ) )
        return;
    
    self.text = text;
    self settext( text );
}

create_text(text, font, font_scale, alignment, relative, x_offset, y_offset, color, alpha, sort)
{
    element                = self scripts\cp\utility::createfontstring(font, font_scale);
    element.color          = color;
    element.alpha          = alpha;
    element.sort           = sort;
    element.player         = self;
    element.archived       = self should_archive();
    element.foreground     = true;
    element.hidewheninmenu = true;

    element scripts\cp\utility::setpoint(alignment, relative, x_offset, y_offset);

    if (typeof(text) == "int")
        element setvalue(text);
    else
    {
    	
        if (typeof(text) == "float")
            element setvalue(text);

        element set_text(text);
    }

    self.element_count++;

    return element;
}

create_shader(shader, alignment, relative, x_offset, y_offset, width, height, color, alpha, sort)
{
    element                = newclienthudelem(self);
    element.elemtype       = "icon";
    element.children       = [];
    element.color          = color;
    element.alpha          = alpha;
    element.sort           = sort;
    element.player         = self;
    element.archived       = self should_archive();
    element.foreground     = true;
    element.hidden         = false;
    element.hidewheninmenu = true;

    element scripts\cp\utility::setparent(level.uiparent);
    element scripts\cp\utility::setpoint(alignment, relative, x_offset, y_offset);
    element set_shader(shader, width, height);
    
    self.element_count++;

    return element;
}

set_shader(shader, width, height)
{
    if (!isdefined(shader))
    {
        if (!isdefined(self.shader))
            return;

        shader = self.shader;
    }

    if (!isdefined(width))
    {
        if (!isdefined(self.width))
            return;

        width = self.width;
    }

    if (!isdefined(height))
    {
        if (!isdefined(self.height))
            return;

        height = self.height;
    }

    self.shader = shader;
    self.width  = width;
    self.height = height;
    self setshader(shader, width, height);
}

clear_option()
{
    for(i = 0; i < self.element_list.size; i++)
    {
        clear_all(self.menu["hud"][self.element_list[i]]);
        self.menu["hud"][self.element_list[i]] = [];
    }
}

clear_all(array)
{
    if (!isdefined(array))
        return;

    keys = getarraykeys(array);
    for(i = 0; i < keys.size; i++)
    {
        if (isarray(array[keys[i]]))
        {
            foreach(key in array[keys[i]])
                if (isdefined(key))
                    key destroy_element();
        }
        else if (isdefined(array[keys[i]]))
            array[keys[i]] destroy_element();
    }
}

add_menu(title, shader)
{
    if (isdefined(title))
        self set_title(title);

    if (!isdefined(self.shader_option)) // shader_option needs to be defined before you try to add stuff to it
        self.shader_option = [];

    if (isdefined(shader))
        self.shader_option[self get_menu()] = true;

    self.structure = [];
}

add_option(text, summary, function, argument_1, argument_2, argument_3)
{
    option            = [];
    option["text"]       = text;
    option["summary"]    = summary;
    option["function"]   = function;
    option["argument_1"] = argument_1;
    option["argument_2"] = argument_2;
    option["argument_3"] = argument_3;
    self.structure[self.structure.size] = option;
}

add_toggle(text, summary, function, toggle, array, argument_1, argument_2, argument_3)
{
    option          = [];
    option["text"]     = text;
    option["summary"]  = summary;
    option["function"] = function;
    option["toggle"]   = is_true(toggle);
    if (isdefined(array))
    {
        option["slider"] = true;
        option["is_array"] = true;
        option["array"]  = array;
    }

    option["argument_1"] = argument_1;
    option["argument_2"] = argument_2;
    option["argument_3"] = argument_3;

    self.structure[self.structure.size] = option;
}

add_array(text, summary, function, array, argument_1, argument_2, argument_3)
{
    option            = [];
    option["text"]       = text;
    option["summary"]    = summary;
    option["function"]   = function;
    option["slider"]     = true;
    option["is_array"]   = true;
    option["array"]      = array;
    option["argument_1"] = argument_1;
    option["argument_2"] = argument_2;
    option["argument_3"] = argument_3;

    self.structure[self.structure.size] = option;
}

add_bind(text, summary, function, argument_1, argument_2, argument_3)
{
    option            = [];
    option["text"]       = text;
    option["summary"]    = summary;
    option["function"]   = function;
    option["slider"]     = true;
    option["is_array"]   = true;
    option["array"]      = "[{" + list("+actionslot 1,+actionslot 2,+actionslot 3,+actionslot 4") + "}]";
    option["argument_1"] = argument_1;
    option["argument_2"] = argument_2;
    option["argument_3"] = argument_3;

    self.structure[self.structure.size] = option;
}

actionslot_notify_map(slot)
{
    switch(slot)
    {
    case "[{+actionslot 1}]":
        return "+actionslot 1";
    case "[{+actionslot 2}]":
        return "+actionslot 2";
    case "[{+actionslot 3}]":
        return "+actionslot 3";
    case "[{+actionslot 4}]":
        return "+actionslot 4";
    default:
        break;
    }
}

add_increment(text, summary, function, start, minimum, maximum, increment, argument_1, argument_2, argument_3)
{
    option            = [];
    option["text"]       = text;
    option["summary"]    = summary;
    option["function"]   = function;
    option["slider"]     = true;
    option["is_increment"]  = true;
    option["start"]      = start;
    option["minimum"]    = minimum;
    option["maximum"]    = maximum;
    option["increment"]  = increment;
    option["argument_1"] = argument_1;
    option["argument_2"] = argument_2;
    option["argument_3"] = argument_3;

    self.structure[self.structure.size] = option;
}

add_category(text)
{
    option          = [];
    option["text"]     = text;
    option["category"] = true;

    self.structure[self.structure.size] = option;
}

new_menu(menu)
{
    if (self get_menu() == "all players")
    {
        players = level.players;
        player = players[(self get_cursor())];
        self.select_player = player;
    }

    if (!isdefined(menu))
    {
        menu = self.previous[(self.previous.size - 1)];
        self.previous[(self.previous.size - 1)] = undefined;
    }
    else
        self.previous[self.previous.size] = self get_menu();

    self set_menu(menu);
    self clear_option();
    self create_option();
}

open_menu(menu)
{
    if (!isdefined(menu))
        menu = isdefined(self get_menu()) && self get_menu() != "catbox" ? self get_menu() : "catbox";

    // setup menu hud arrays
    if (!isdefined(self.menu["hud"]))
    {
        self.menu["hud"] = [];
        self.menu["hud"]["background"] = [];
        self.menu["hud"]["foreground"] = [];
        self.menu["hud"]["submenu"] = [];
        self.menu["hud"]["toggle"] = [];
        self.menu["hud"]["slider"] = [];
        self.menu["hud"]["category"] = [];
        // category indexes need init too tbh but wtv for now
        self.menu["hud"]["text"] = [];
        self.menu["hud"]["arrow"] = [];
    }

    if (!isdefined(self.slider))
        self.slider = [];

    self.current_menu_color = (0.537, 0.502, 0.706);

    self.menu["hud"]["title"]        = self create_text(self get_title(), self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 4), (self.y_offset + 1.75), self.color[4], 1, 10);
    // outline
    self.menu["hud"]["background"][0] = self create_shader("white", "TOP_LEFT", "TOPCENTER", self.x_offset, (self.y_offset - 1), 222, 34, self.current_menu_color, 0.6, 1);
    // top bar
    self.menu["hud"]["background"][1] = self create_shader("white", "TOP_LEFT", "TOPCENTER", (self.x_offset + 1), self.y_offset, 220, 32, self.color[1], 0.8, 2);
    // toggle box
    self.menu["hud"]["foreground"][0] = self create_shader("white", "TOP_LEFT", "TOPCENTER", (self.x_offset + 1), (self.y_offset + 16), 220, 16, self.color[1], 0.05, 3);
    // cursor - use these for flickershaders?
    self.menu["hud"]["foreground"][1] = self create_shader("white", "TOP_LEFT", "TOPCENTER", (self.x_offset + 1), (self.y_offset + 16), 214, 16, self.current_menu_color, 0.6, 4);
    // scrolling bar on the side
    //self.menu["hud"]["foreground"][2] = self create_shader("white", "TOP_RIGHT", "TOPCENTER", (self.x_offset + 221), (self.y_offset + 16), 4, 16, self.current_menu_color, 0.4, 4);

    self set_menu(menu);
    self set_procedure();
    self create_option();
}

close_menu()
{
    self set_procedure();
    self clear_option();
    self clear_all(self.menu["hud"]);
    self notify("exit_menu");
}

close_menu_if_open()
{
    if (self in_menu())
        self close_menu();
}

close_menu_game_over()
{
    self endon("disconnect");
    level waittill("game_ended");
    self thread close_menu_if_open();
}

create_title(title)
{
    // tolower or no?
    self.menu["hud"]["title"] set_text(isdefined(title) ? title : self get_title());
}

create_summary(summary)
{
    if (isdefined(self.menu["hud"]["summary"]) && !is_true(self.option_summary) || !isdefined(self.structure[self get_cursor()]["summary"]) && isdefined(self.menu["hud"]["summary"]))
        self.menu["hud"]["summary"] destroy_element();

    if (isdefined(self.structure[self get_cursor()]["summary"]) && is_true(self.option_summary))
    {
        if (!isdefined(self.menu["hud"]["summary"]))
            self.menu["hud"]["summary"] = self create_text(tolower(isdefined(summary) ? summary : self.structure[self get_cursor()]["summary"]), self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 4), (self.y_offset + 35), self.color[4], 1, 10);
        else
            self.menu["hud"]["summary"] set_text(tolower(isdefined(summary) ? summary : self.structure[self get_cursor()]["summary"]));
    }
}

create_option()
{
    self clear_option();
    self render_menu_options();

    if (!isdefined(self.structure) || !self.structure.size)
        self add_option("nothing to display..");

    if (!isdefined(self get_cursor()))
        self set_cursor(0);

    start = 0;
    if ((self get_cursor() > int(((self.option_limit - 1) / 2))) && (self get_cursor() < (self.structure.size - int(((self.option_limit + 1) / 2)))) && (self.structure.size > self.option_limit))
        start = (self get_cursor() - int((self.option_limit - 1) / 2));

    if ((self get_cursor() > (self.structure.size - (int(((self.option_limit + 1) / 2)) + 1))) && (self.structure.size > self.option_limit))
        start = (self.structure.size - self.option_limit);

    self create_title();
    if (is_true(self.option_summary))
        self create_summary();

    if (isdefined(self.structure) && self.structure.size)
    {
        limit = min(self.structure.size, self.option_limit);
        for(i = 0; i < limit; i++)
        {
            index      = (i + start);
            cursor     = (self get_cursor() == index);
            color[0] = cursor ? self.color[0] : self.color[4];
            color[1] = is_true(self.structure[index]["toggle"]) ? cursor ? self.color[0] : (1,1,1) : cursor ? self.color[2] : self.color[1];

            if (isdefined(self.structure[index]["function"]) && self.structure[index]["function"] == ::new_menu)
                self void();
                // self.menu["hud"]["submenu"][index] = self create_shader("ui_arrow_right", "TOP_RIGHT", "TOPCENTER", (self.x_offset + 212), (self.y_offset + ((i * self.option_spacing) + 22)), 4, 4, color[0], 1, 10);

            if (isdefined(self.structure[index]["toggle"]))
            {
                self.menu["hud"]["toggle"][index] = self create_shader("white", "TOP_LEFT", "TOPCENTER", (self.x_offset + 204), (self.y_offset + ((i * self.option_spacing) + 20)), 8, 8, color[1], .65, 10);
                // self.menu["hud"]["current_toggle_index"] = self.menu["hud"]["toggle"][index];
            }

            if (is_true(self.structure[index]["slider"]))
            {
                storage = (self get_menu() + "_" + index);
                self.slider[storage] = isdefined(self.structure[index]["array"]) ? 0 : self.structure[index]["start"];

                if (isdefined(self.structure[index]["array"]))
                {
                    if (cursor)
                    {
                        self.menu["hud"]["slider"][0] = [];
                        self.menu["hud"]["slider"][0][index] = self create_text(self.structure[index]["array"][ self.slider[storage] ], self.font, self.font_scale, "TOP_RIGHT", "TOPCENTER", (self.x_offset + 210), (self.y_offset + ((i * self.option_spacing) + 19)), color[0], 1, 10);
                    }
                }
                else
                {
                    if (cursor)
                    {
                        self.menu["hud"]["slider"][0] = [];
                        self.menu["hud"]["slider"][0][index] = self create_text(self.slider[storage], self.font, (self.font_scale), "CENTER", "TOPCENTER", (self.x_offset + 187), (self.y_offset + ((i * self.option_spacing) + 24)), self.color[4], 1, 10);
                    }

                    self.menu["hud"]["slider"][1][index] = self create_shader("white", "TOP_RIGHT", "TOPCENTER", (self.x_offset + 212), (self.y_offset + ((i * self.option_spacing) + 20)), 50, 8, cursor ? self.color[2] : self.color[1], 1, 8);
                    self.menu["hud"]["slider"][2][index] = self create_shader("white", "TOP_RIGHT", "TOPCENTER", (self.x_offset + 170), (self.y_offset + ((i * self.option_spacing) + 20)), 8, 8, cursor ? self.color[0] : self.color[3], 1, 9);
                }

                // idek what this does but Ok
                self set_slider(undefined, index);
            }

            if (is_true(self.structure[index]["category"]))
            {
                self.menu["hud"]["category"][0][index] = self create_text(tolower(self.structure[index]["text"]), self.font, self.font_scale, "CENTER", "TOPCENTER", (self.x_offset + 102), (self.y_offset + ((i * self.option_spacing) + 24)), self.color[0], 1, 10);
                self.menu["hud"]["category"][1][index] = self create_shader("white", "TOP_LEFT", "TOPCENTER", (self.x_offset + 4), (self.y_offset + ((i * self.option_spacing) + 24)), 30, 1, self.color[0], 1, 10);
                self.menu["hud"]["category"][2][index] = self create_shader("white", "TOP_RIGHT", "TOPCENTER", (self.x_offset + 212), (self.y_offset + ((i * self.option_spacing) + 24)), 30, 1, self.color[0], 1, 10);
            }
            else
            {
                menu = self get_menu();
                shader_option = self.shader_option[menu];
                if (is_true(shader_option))
                {
                    shader = isdefined(self.structure[index]["text"]) ? self.structure[index]["text"] : "white";
                    color  = isdefined(self.structure[index]["argument_1"]) ? self.structure[index]["argument_1"] : (1, 1, 1); // come back
                    width  = isdefined(self.structure[index]["argument_2"]) ? self.structure[index]["argument_2"] : 20;
                    height = isdefined(self.structure[index]["argument_3"]) ? self.structure[index]["argument_3"] : 20;
                    self.menu["hud"]["text"][index] = self create_shader(shader, "CENTER", "TOPCENTER", (self.x_offset + ((i * 24) - ((limit * 10) - 109))), (self.y_offset + 32), width, height, color, 1, 10);
                }
                else
                {
                    menu_text = (is_true(self.structure[index]["slider"]) ? self.structure[index]["text"]/*+":"*/ : self.structure[index]["text"]);
                    if (self get_menu() != "all players")
                        menu_text = tolower(menu_text);

                    self.menu["hud"]["text"][index] = self create_text(menu_text, self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", isdefined(self.structure[index]["toggle"]) ? (self.x_offset + 4) : (self.x_offset + 4), (self.y_offset + ((i * self.option_spacing) + 19)), color[0], 1, 10);
                }
            }
        }

        if (!isdefined(self.menu["hud"]["text"][self get_cursor()]))
            self set_cursor((self.structure.size - 1));
    }
    self update_resize();
}

update_scrolling(scrolling)
{
    cursor_index = self get_cursor();
    structure = self.structure[cursor_index];

    if (isdefined(structure) && is_true(structure["category"]))
    {
        self set_cursor((self get_cursor() + scrolling));
        return self update_scrolling(scrolling);
    }

    if ((self.structure.size > self.option_limit) || (self get_cursor() >= 0) || (self get_cursor() <= 0))
    {
        if ((self get_cursor() >= self.structure.size) || (self get_cursor() < 0))
            self set_cursor((self get_cursor() >= self.structure.size) ? 0 : (self.structure.size - 1));

        self create_option();
    }

    self update_resize();
}

update_resize()
{
    limit    = min(self.structure.size, self.option_limit);
    height   = int((limit * self.option_spacing));
    adjust   = (self.structure.size > self.option_limit) ? int(((112 / self.structure.size) * limit)) : height;

    if ((height - adjust) > 0)
        position = (self.structure.size - 1) / (height - adjust);
    else
        position = 0;

    if (is_true(self.shader_option[self get_menu()]))
    {
        self.menu["hud"]["foreground"][1].y = (self.y_offset + 46);
        self.menu["hud"]["foreground"][1].x = (self.menu["hud"]["text"][self get_cursor()].x - 10);

        if (!isdefined(self.menu["hud"]["arrow"][0]))
            self.menu["hud"]["arrow"][0] = self create_shader("ui_scrollbar_arrow_left", "TOP_LEFT", "TOPCENTER", (self.x_offset + 10), (self.y_offset + 29), 6, 6, self.color[4], 1, 10);

        if (!isdefined(self.menu["hud"]["arrow"][1]))
            self.menu["hud"]["arrow"][1] = self create_shader("ui_scrollbar_arrow_right", "TOP_RIGHT", "TOPCENTER", (self.x_offset + 211), (self.y_offset + 29), 6, 6, self.color[4], 1, 10);

        self.menu["hud"]["foreground"][2] destroy_element();
    }
    else
    {
        self.menu["hud"]["foreground"][1].y = (self.menu["hud"]["text"][self get_cursor()].y - 3);
        self.menu["hud"]["foreground"][1].x = (self.x_offset + 1);

        if (!isdefined(self.menu["hud"]["foreground"][2]))
            self.menu["hud"]["foreground"][2] = self create_shader("white", "TOP_RIGHT", "TOPCENTER", (self.x_offset + 221), (self.y_offset + 16), 4, 16, self.current_menu_color, 0.6, 4);

        if (isdefined(self.menu["hud"]["arrow"][0])) self.menu["hud"]["arrow"][0] destroy_element();
        if (isdefined(self.menu["hud"]["arrow"][1])) self.menu["hud"]["arrow"][1] destroy_element();
    }

    self.menu["hud"]["background"][0] set_shader(self.menu["hud"]["background"][0].shader, self.menu["hud"]["background"][0].width, is_true(self.shader_option[self get_menu()]) ? (isdefined(self.structure[self get_cursor()]["summary"]) && is_true(self.option_summary) ? 66 : 50) : (isdefined(self.structure[self get_cursor()]["summary"]) && is_true(self.option_summary) ? (height + 34) : (height + 18)));
    self.menu["hud"]["background"][1] set_shader(self.menu["hud"]["background"][1].shader, self.menu["hud"]["background"][1].width, is_true(self.shader_option[self get_menu()]) ? (isdefined(self.structure[self get_cursor()]["summary"]) && is_true(self.option_summary) ? 64 : 48) : (isdefined(self.structure[self get_cursor()]["summary"]) && is_true(self.option_summary) ? (height + 32) : (height + 16)));
    self.menu["hud"]["foreground"][0] set_shader(self.menu["hud"]["foreground"][0].shader, self.menu["hud"]["foreground"][0].width, is_true(self.shader_option[self get_menu()]) ? 32 : height);
    self.menu["hud"]["foreground"][1] set_shader(self.menu["hud"]["foreground"][1].shader, is_true(self.shader_option[self get_menu()]) ? 20 : 214, is_true(self.shader_option[self get_menu()]) ? 2 : 16);
    self.menu["hud"]["foreground"][2] set_shader(self.menu["hud"]["foreground"][2].shader, self.menu["hud"]["foreground"][2].width, adjust);

    if (isdefined(self.menu["hud"]["foreground"][2]))
    {
        self.menu["hud"]["foreground"][2].y = (self.y_offset + 16);
        if (self.structure.size > self.option_limit)
            self.menu["hud"]["foreground"][2].y += (self get_cursor() / position);
    }

    if (isdefined(self.menu["hud"]["summary"]))
        self.menu["hud"]["summary"].y = is_true(self.shader_option[self get_menu()]) ? (self.y_offset + 51) : (self.y_offset + ((limit * self.option_spacing) + 19));
}

update_menu(menu, cursor, force)
{
    if (isdefined(menu) && !isdefined(cursor) || !isdefined(menu) && isdefined(cursor))
        return;

    if (isdefined(menu) && isdefined(cursor))
    {
        foreach(player in level.players)
        {
            if (!isdefined(player) || !player in_menu())
                continue;

            if (player get_menu() == menu || self != player && player is_option(menu, cursor, self))
                if (isdefined(player.menu["hud"]["text"][cursor]) || player == self && player get_menu() == menu && isdefined(player.menu["hud"]["text"][cursor]) || self != player && player is_option(menu, cursor, self) || is_true(force))
                    player create_option();
        }
    }
    else
    {
        if (isdefined(self) && self in_menu())
            self create_option();
    }
}

is_valid_weapon(weapon)
{
    if (!isdefined (weapon))
        return false;

    weapon_class = getweaponclass(weapon);
    if (weapon_class == "weapon_sniper")
    {
        return true;
    }

    return false;
}

perstovector(pers)
{
    keys = StrTok(pers, ",");
    return (float(keys[0]),float(keys[1]),float(keys[2]));
}

list(key) 
{
    output = StrTok(key, ",");
    return output;
}

randomize(key)
{
    r = strtok(key, ", ");
    random = randomint(r.size);
    final = r[random];
    return final;
}

callback_playerdamage_stub(var_0, var_1, var_2, var_3, var_4, var_5, var_6, var_7, var_8, var_9, var_10, var_11) 
{
    if (isdefined(var_4) && var_4 == "MOD_FALLING")
        return;

    self [[level.damage_original]](var_0, var_1, var_2, var_3, var_4, var_5, var_6, var_7, var_8, var_9, var_10, var_11);
}

// gotta use a wrapper because scripts\engine\utility::istrue makes the game not load for some reason
is_true(variable)
{
    if (isdefined(variable) && variable)
    {
        return 1;
    }
    return 0;
}

// have to use this because ActionSlotButtonOnePressed etc does not exist!
button_monitor(button) 
{
    self endon("disconnect");

    self.button_pressed[button] = false;
    self NotifyOnPlayerCommand("button_pressed_" + button, button);

    while(1)
    {
        self waittill("button_pressed_" + button);
        self.button_pressed[button] = true;
        wait .01;
        self.button_pressed[button] = false;
    }
}

isButtonPressed(button)
{
    return self.button_pressed[button];
}

monitor_buttons() 
{
    if (isDefined(self.now_monitoring))
        return;

    self.now_monitoring = true;
    
    if (!isDefined(self.button_actions))
        self.button_actions = ["+melee", "+melee_zoom", "+melee_breath", "+stance", "+gostand", "weapnext", "+actionslot 1", "+actionslot 2", "+actionslot 3", "+actionslot 4", "+forward", "+back", "+moveleft", "+moveright"];
    if (!isDefined(self.button_pressed))
        self.button_pressed = [];
    
    for(a=0 ; a < self.button_actions.size ; a++)
        self thread button_monitor(self.button_actions[a]);
}

create_notify()
{
    foreach(value in StrTok("+actionslot 1,+actionslot 2,+actionslot 3,+actionslot 4,+frag,+smoke,+melee,+melee_zoom,+stance,+gostand,+switchseat,+usereload", ",")) 
    {
        self NotifyOnPlayerCommand(value, value);
    }
}

check_weapon_class()
{
    self endon("disconnect");
    level endon("game_ended");

    for(;;)
    {
        // self iprintln("^:" + self getCurrentWeapon() + " | " + getweaponclass(self getCurrentWeapon()));
        print(self getCurrentWeapon() + " | " + getweaponclass(self getCurrentWeapon()));
        wait 1;
    }
}

add_points(value)
{
    level._id_10DA7 = value;
}

can_upgrade_hook(param_00,param_01)
{
	return 1;
}

void() {}