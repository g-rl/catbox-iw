#include scripts\engine\utility;
#include scripts\cp\utility;
#include scripts\cp\cp_hud_util;
#include custom_scripts\func;
#include custom_scripts\util;
#include custom_scripts\menu;

/*
    start date: 4/14/25
*/

main()
{
    // lets set dvars here just in case

    level.is_debug = false;
    level.starttime = gettime();
    level.killcam = false; // for now


    setdvar("sv_cheats", 1);
    setdvar("player_sprintUnlimited", 1);
    setdvar("timescale", 1);
    setdvar("g_speed", 190);
    setdvar("g_gravity", 785);
    setdvar("bg_bounces", 1);
    setomnvar("allow_server_pause", 1); // allow pausing with multiple clients
    setdvar("director_cut", 1);
    setdvar("ui_killcam_weapontype", 0);
    setdvar("ui_killcam_weaponicon", "");
    setdvar("ui_killcam_weaponname", "");
    setdvar("ui_killcam_weaponvariantid", 0);
    setdvar("ui_killcam_weaponmk2", 0);
    setdvar("sv_cheats", 1);
    setdvar("scr_killcam_posttime", 3);
    setdvar("zombie_archtype", "Zombie");
    // replacefunc(scripts\cp\agents\gametype_zombie::enemykilled, ::zombiekilled);
}

init()
{
    // dont load unless its zombies so we can still use mp scripts
    if (!is_zombies_mode())
    {
        print("^1GAMETYPE IS NOT ZOMBIES - WILL NOT LOAD");
        return;
    }

    // enable debugging & map restart
    if (is_true(level.is_debug) && getdvarint("is_debug") != 1)
    {
        setdvar("is_debug", 1);
        setdvar("developer_script", 1);
        map_restart(1);
        print("ENABLING DEVELOPER SCRIPT / RESTARTING");
    }

    level thread on_player_connect();
    level thread itr_weapons();
    level thread pause_wave_progression();

    level.is_recording = false;
    level.damage_original = level.callbackplayerdamage;
    level.callbackplayerdamage = ::callback_playerdamage_stub; // just for no fall damage
}

on_player_connect() 
{
    level endon("game_ended");

    for(;;) 
    {
        level waittill("connected", player);
        
        get_map_name();
        player thread on_event();
    }
}

on_event()
{
    self endon("disconnect");
    level endon("game_ended");

    self.catbox = [];

    for(;;) 
    {
        event_name = self scripts\engine\utility::waittill_any_return("spawned_player", "player_downed", "death");

        switch(event_name)
        {
        case "spawned_player":

            // safety first
            if (!scripts\engine\utility::flag("introscreen_over"))
            {
                scripts\engine\utility::flag_wait("introscreen_over");
            }

            // fix threads not going through on initial restart
            if (getdvarint("is_debug") == 1 && getdvarint("init_debug") != 1) 
            {
                setdvar("init_debug", 1);
                self iprintlnbold("^:debug enabled - restarting in a sec");
                wait 1.5;
                map_restart(1);
                continue; // prolly dont need this tbh
            }

            executecommand("luireload"); // temp fix for killer info not loading
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
            // self thread check_weapon_class();
            self thread no_clip();
            self thread demi_god();
            self thread bounce_loop();
            self thread self_revive_loop();
            self thread save_pos_bind();
            self thread load_pos_bind();
            self thread nac_bind();
            self thread add_points(5000);
            self thread set_rank(999);
            self thread set_max_bank();
            self thread intro();

            // actually have no clue what these do and they probably dont matter lol

            self _meth_800C(true);
            self _meth_8009(true);
            self _meth_80D6();
            self _meth_84DD(true);
            
            // setup starting class - base this by map soon
            self.weapon_list = list("frag_grenade_zm,iw7_knife_zm,iw7_spas_zmr+loot0,iw7_cheytacc_zm+cheytacscope_camo"); // equipment to primary

            // set default melee weapon
            self.starting_melee = "iw7_knife_zm";
            self.default_starting_melee_weapon = self.starting_melee;
            self.currentmeleeweapon = self.starting_melee;

            // give the starting class
            self takeallweapons();
            self thread set_starter_perks();
            foreach(weapon in self.weapon_list)
            {
                self g_weapon(weapon);
            }

            wait 3; // wait a lil to prevent errors
            self thread set_zombie_health(); // make all zombies 1 shot
            self thread scripts\cp\zombies\direct_boss_fight::open_sesame();
            wait 6;
            self takeweapon("iw7_fists_zm"); // some maps give this as a third weapon lmfao
            break;
        case "death":
        case "player_downed":
        default:
            self thread close_menu_if_open();
            break;
        }
    }
}

persistence_setup()
{
    self.take_weapon = true;
    self.weapon_one = "none";
    self.weapon_two = "none";
    self.aimbot_range = 500;
    self.aimbot_delay = 0;
    self.outline_color = 2;

    self unipers("bouncecount", "0");

    for(i=1; i<8; i++)
    {
        self unipers("bouncepos" + i, "0");
    }
}