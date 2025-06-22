#include scripts\engine\utility;
#include scripts\cp\utility;
#include scripts\cp\cp_hud_util;
#include custom_scripts\catbox;
#include custom_scripts\util;
#include custom_scripts\func;

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
        // self.is_bind_menu = false;
        self add_menu("@catbox - " + self get_name());
        self add_option("my settings", undefined, ::new_menu, "settings");
        self add_option("weapon manager", undefined, ::new_menu, "weapons");
        self add_option("perks", undefined, ::new_menu, "perks");
        self add_option("zombie manager", undefined, ::new_menu, "zombies");
        self add_option("aimbot", undefined, ::new_menu, "aimbot");
        self add_option("teleports", undefined, ::new_menu, "teleports");
        self add_option("game stuff", undefined, ::new_menu, "game");
        self add_option("account manager", undefined, ::new_menu, "account");
        // self add_option("clients", undefined, ::new_menu, "all players");
        break;
    case "settings":
        // self.is_bind_menu = false;
        self add_menu("settings");
        self add_option("nac bind", undefined, ::new_menu, "nac bind");
        self add_increment("add points", increment_controls, ::add_points, self getrankedplayerdata("cp", "alienSession", "currency"), 100, 100000, 100);
        self add_toggle("auto prone", undefined, ::do_auto_prone, self.auto_prone);
        self add_toggle("auto reload", undefined, ::do_auto_reload, self.auto_reload);
        self add_toggle("exo movement", undefined, ::toggle_exo_movement, self.exo_movement);
        self add_toggle("fake elevators", undefined, ::toggle_elevators, self.elevators);
        self add_toggle("gesture bind", undefined, ::toggle_gesture_bind, self.gesture_bind);
        self add_toggle("completely hide ui", undefined, ::hide_ui, self.hide_ui);
        self add_toggle("third person", undefined, ::toggle_third_person, self.third_person);
        self add_toggle("freeze box", undefined, ::toggle_frozen_box, self.frozen_box);
        // if (getdvar("mapname") == "cp_zmb") self add_option("give sunglasses", undefined, ::launch_glasses_hook);
        self add_option("spawn bounce", undefined, ::spawn_bounce);
        self add_option("delete last bounce", undefined, ::delete_bounce);
        self add_option("fill consumables", undefined, ::fill_consumables);
        self add_option("unlink", undefined, ::unlink_player);
        break;
    case "weapons":
        // self.is_bind_menu = false;
        self add_menu("weapons");
        self add_toggle("take weapon on give", undefined, ::toggle_take_weapon, self.take_weapon);
        self add_toggle("infinite ammo", undefined, ::toggle_infinite_ammo, self.infinite_ammo);
        self add_toggle("infinite equipment", undefined, ::toggle_infinite_equipment, self.infinite_equipment);
        self add_option("drop weapon", undefined, ::drop_weapon);
        self add_option("take weapon", undefined, ::take_my_weapon);
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
        // self.is_bind_menu = false;
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
        // self.is_bind_menu = false;
        self add_menu("snipers");
        self add_option("tf-141 (irons)", undefined, ::g_weapon, "iw7_cheytacc_zm+loot0");
        self add_option("tf-141 (scoped)", undefined, ::g_weapon, "iw7_cheytacc_zm+cheytacscope_camo+loot0");
        self add_option("widowmaker", undefined, ::g_weapon, "iw7_cheytac_zmr");
        self add_option("trek-50", undefined, ::g_weapon, "iw7_ba50cal_zm");
        self add_option("dmr-1", undefined, ::g_weapon, "iw7_m1_zm");
        self add_option("dmr-1 (scoped)", undefined, ::g_weapon, "iw7_m1_zm+m1scope_camo");
        self add_option("ebr-800", undefined, ::g_weapon, "iw7_m8_zm");
        self add_option("kbs longbow", undefined, ::g_weapon, "iw7_kbs_zm+kbsscope_zm_camo+loot0");
        self add_option("kbs longbow (irons)", undefined, ::g_weapon, "iw7_kbs_zm+loot0");
        self add_option("proteus", undefined, ::g_weapon, "iw7_longshot_zm+longshotlscope_zm");
        break;
    case "smg":
        // self.is_bind_menu = false;
        self add_menu("smg");
        self add_option("erad", undefined, ::g_weapon, "iw7_erad_zm");
        self add_option("karma-45", undefined, ::g_weapon, "iw7_crb_zm");
        self add_option("ripper", undefined, ::g_weapon, "iw7_ripper_zm");
        self add_option("fhr-40", undefined, ::g_weapon, "iw7_fhr_zm");
        self add_option("ump-45", undefined, ::g_weapon, "iw7_ump45c_zm");
        self add_option("raijin-emx", undefined, ::g_weapon, "iw7_tacburst_zm+gltacburst");
        self add_option("trencher", undefined, ::g_weapon, "iw7_mp28_zm");
        self add_option("vpr", undefined, ::g_weapon, "iw7_crdb_zm");
        break;
    case "ar":
        // self.is_bind_menu = false;
        self add_menu("ar");
        self add_option("kbar-32", undefined, ::g_weapon, "iw7_ar57_zm");
        self add_option("r3k", undefined, ::g_weapon, "iw7_sdfar_zm");
        self add_option("volk", undefined, ::g_weapon, "iw7_ake_zm");
        self add_option("r-vn", undefined, ::g_weapon, "iw7_rvn_zm");
        self add_option("type-2", undefined, ::g_weapon, "iw7_fmg_zm+akimbofmg_zm");
        self add_option("x-eon", undefined, ::g_weapon, "iw7_vr_zm");
        self add_option("nv4", undefined, ::g_weapon, "iw7_m4_zm");
        self add_option("g-rail", undefined, ::g_weapon, "iw7_gauss_zm");
        break;
    case "shotguns":
        // self.is_bind_menu = false;
        self add_menu("shotguns");
        self add_option("rack-9", undefined, ::g_weapon, "iw7_spas_zmr");
        self add_option("s-ravage", undefined, ::g_weapon, "iw7_spasc_zm");
        self add_option("m.2187", undefined, ::g_weapon, "iw7_mod2187_zm");
        self add_option("reaver", undefined, ::g_weapon, "iw7_devastator_zm");
        self add_option("banshee", undefined, ::g_weapon, "iw7_sonic_zm");
        self add_option("banshee (^:2^7)", undefined, ::g_weapon, "iw7_sonic_zmr");
        self add_option("dcm-8", undefined, ::g_weapon, "iw7_sdfshotty_zm+sdfshottyscope_camo");
        break;
    case "pistols":
        // self.is_bind_menu = false;
        self add_menu("pistols");
        if (getdvar("mapname") == "cp_zmb") // spaceland specials
        {
            self add_option("face melter", undefined, ::g_weapon, "iw7_facemelter_zm");
            self add_option("head cutter", undefined, ::g_weapon, "iw7_headcutter_zm");
            self add_option("dischord", undefined, ::g_weapon, "iw7_dischord_zm");
            self add_option("nx 2.0", undefined, ::g_weapon, "iw7_spaceland_wmd");
            self add_option("shredder", undefined, ::g_weapon, "iw7_shredder_zm");
        }

        self add_option("g18", undefined, ::g_weapon, "iw7_g18_zm");
        self add_option("hornet", undefined, ::g_weapon, "iw7_g18c_zm");
        self add_option("hailstorm", undefined, ::g_weapon, "iw7_revolver_zm");
        self add_option("emc", undefined, ::g_weapon, "iw7_emc_zm");
        self add_option("oni", undefined, ::g_weapon, "iw7_nrg_zm");
        self add_option("stallion", undefined, ::g_weapon, "iw7_mag_zm");
        self add_option("udm", undefined, ::g_weapon, "iw7_udm45_zm+udm45scope");
        break;
    case "lmg":
        // self.is_bind_menu = false;
        self add_menu("lmg");
        self add_option("r.a.w", undefined, ::g_weapon, "iw7_sdflmg_zm");
        self add_option("mauler", undefined, ::g_weapon, "iw7_mauler_zm");
        self add_option("titan", undefined, ::g_weapon, "iw7_lmg03_zm");
        self add_option("atlas", undefined, ::g_weapon, "iw7_unsalmg_zm");
        self add_option("auger", undefined, ::g_weapon, "iw7_minilmg_zm");
        break;
    case "others":
        // self.is_bind_menu = false;
        self add_menu("others");
        self add_option("c4", undefined, ::g_weapon, "c4_zm");
        self add_option("fists", undefined, ::g_weapon, "iw7_fists_zm");
        self add_option("entangler", undefined, ::g_weapon, "iw7_entangler_zm");

        if (getdvar("mapname") == "cp_zmb")
        {
            self add_option("willard's dagger", undefined, ::g_weapon, "iw7_wylerdagger_zm");
            self add_option("forge freeze", undefined, ::g_weapon, "iw7_forgefreeze_zm+forgefreezealtfire");
        }
        self add_option("eraser", undefined, ::g_weapon, "iw7_atomizer_mp");
        self add_option("ballista em3", undefined, ::g_weapon, "iw7_penetrationrail_mp+penetrationrailscope");
        self add_option("steel dragon", undefined, ::g_weapon, "iw7_steeldragon_mp");
        self add_option("claw", undefined, ::g_weapon, "iw7_claw_mp");
        self add_option("gravity vortex gun", undefined, ::g_weapon, "iw7_blackholegun_mp+blackholegunscope");
        self add_option("howitzer", undefined, ::g_weapon, "iw7_glprox_zm");
        self add_option("p-law", undefined, ::g_weapon, "iw7_chargeshot_zm");
        self add_option("golden axe", undefined, ::g_weapon, "iw7_axe_zm_pap2");
        break;
    case "zombies":
        // self.is_bind_menu = false;
        self add_menu("zombies");
        self add_option("spawn zombies", undefined, ::new_menu, "spawn zombies");
        self add_option("teleport all zombies", undefined, ::teleport_zombies);
        self add_option("freeze all zombies", undefined, ::freeze_all_zombies);
        self add_toggle("zombies ignore you", undefined, ::zombies_ignore_me, self.ignoreme);
        self add_toggle("zombie outlines", undefined, ::outline_zombies, self.zombie_outline);
        self add_increment("outline color", increment_controls, ::set_outline_color, self.outline_color, 0, 5, 1, true, "outline");
        break;
    case "spawn zombies":
        // self.is_bind_menu = false;
        self add_menu("spawn zombies");
        map = level.map_name;

        for(i = 0; i < self.catbox["zombies"][map][0].size; i++) 
        {
            self add_option("spawn " + self.catbox["zombies"][map][1][i], undefined, ::spawn_zombie, self.catbox["zombies"][map][0][i]);
        }
        break;
    case "teleports":
        // self.is_bind_menu = false;
        self add_menu("teleports");
        map = level.map_name;

        for(i = 0; i < self.catbox["main teleports"][map][0].size; i++) 
        {
            self add_option(self.catbox["main teleports"][map][0][i], undefined, ::set_position, self.catbox["main teleports"][map][1][i], (0, self.catbox["main teleports"][map][2][i], 0));
        }
        
        if (isdefined(self.catbox["map setup teleports"][map][0])) 
        {
            self add_option("map setup teleports", undefined, ::new_menu, "map setup teleports");
        }

        if (isdefined(self.catbox["mystery wheel teleports"][map][0])) 
        {
            self add_option("mystery wheel teleports", undefined, ::new_menu, "mystery wheel teleports");
        }

        if (isdefined(self.catbox["main quest teleports"][map][0])) 
        {
            self add_option("main quest teleports", undefined, ::new_menu, "main quest teleports");
        }

        if (isdefined(self.catbox["extra teleports"][map][0])) 
        {
            self add_option("extra teleports", undefined, ::new_menu, "extra teleports");
        }
        break;
    case "map setup teleports":
        // self.is_bind_menu = false;
        self add_menu("map setup teleports");
        map = level.map_name;
        for(i = 0; i < self.catbox["map setup teleports"][map][0].size; i++) 
        {
            self add_option(self.catbox["map setup teleports"][map][0][i], undefined, ::set_position, self.catbox["map setup teleports"][map][1][i], (0, self.catbox["map setup teleports"][map][2][i], 0));
        }
        break;
    case "mystery wheel teleports":
        // self.is_bind_menu = false;
        self add_menu("mystery wheel teleports");
        map = level.map_name;
        for(i = 0; i < self.catbox["mystery wheel teleports"][map][0].size; i++) 
        {
            self add_option(self.catbox["mystery wheel teleports"][map][0][i], undefined, ::set_position, self.catbox["mystery wheel teleports"][map][1][i], (0, self.catbox["mystery wheel teleports"][map][2][i], 0));
        }
        break;
    case "main quest teleports":
        // self.is_bind_menu = false;
        self add_menu("main quest teleports");
        map = level.map_name;
        for(i = 0; i < self.catbox["main quest teleports"][map][0].size; i++) 
        {
            self add_option(self.catbox["main quest teleports"][map][0][i], undefined, ::set_position, self.catbox["main quest teleports"][map][1][i], (0, self.catbox["main quest teleports"][map][2][i], 0));
        }
        break;
    case "extra teleports":
        // self.is_bind_menu = false;
        self add_menu("extra teleports");
        map = level.map_name;
        for(i = 0; i < self.catbox["extra teleports"][map][0].size; i++) 
        {
            self add_option(self.catbox["extra teleports"][map][0][i], undefined, ::set_position, self.catbox["extra teleports"][map][1][i], (0, self.catbox["extra teleports"][map][2][i], 0));
        }
        break;
    case "aimbot":
        // self.is_bind_menu = false;
        self add_menu("aimbot");
        self add_toggle("toggle aimbot", undefined, ::toggle_aimbot, self.aimbot);
        self add_option("aimbot weapon", undefined, ::set_aimbot_weapon);
        self add_increment("aimbot range", increment_controls, ::set_aimbot_range, self.aimbot_range, 100, 4000, 100);
        self add_increment("aimbot delay", increment_controls, ::set_aimbot_delay, self.aimbot_delay, 0, 1, 0.1);
        break;
    case "game":
        // self.is_bind_menu = false;
        // add_increment(text, summary, function, start, minimum, maximum, increment, argument_1, argument_2, argument_3)
        self add_menu("game");
        self add_option("powerups", undefined, ::new_menu, "powerups");
        self add_toggle("toggle branding", undefined, ::toggle_branding, self.branding);
        self add_increment("timescale", increment_controls, ::set_timescale, getdvarfloat("timescale"), 0.25, 10, 0.25);
        self add_increment("gravity", increment_controls, ::set_gravity, getdvarint("g_gravity"), 100, 800, 25);
        self add_increment("bounces", increment_controls, ::set_bounces, getdvarint("bg_bounces"), 0, 1, 1);
        self add_increment("speed", increment_controls, ::set_speed, getdvarint("g_speed"), 50, 300, 5);
        self add_increment("full bright", increment_controls, ::set_full_bright, getdvarint("full_bright"), 0, 1, 1);
        self add_increment("jump height", increment_controls, ::set_jump_height, getdvarint("jump_height"), 40, 500, 5);
        self add_increment("weapon spread", increment_controls, ::set_weapon_spread, getdvarfloat("perk_weapSpreadMultiplier"), 0, 0.65, 0.05);
        self add_increment("reload time", increment_controls, ::set_reload_time, getdvarfloat("perk_weapReloadMultiplier"), 0.05, 1, 0.05);
        self add_increment("empty reload time", increment_controls, ::set_empty_reload_time, getdvarfloat("perk_weapReloadMultiplierEmpty"), 0.05, 1, 0.05);
        self add_increment("unlimited sprint", increment_controls, ::set_unlimited_sprint, getdvarint("player_sprintUnlimited"), 0, 1, 1);
        break;
    case "powerups":
        self add_menu("powerups");
        for(i = 0; i < self.catbox["powerups"][0].size; i++) 
        {
            self add_option("spawn " + self.catbox["powerups"][0][i], undefined, ::spawn_powerup, self.catbox["powerups"][1][i]);
        }
        break;
    case "account":
        // self.is_bind_menu = false;
        self add_menu("account");
        self add_option("derank myself", undefined, ::derank);
        self add_increment("change prestige", increment_controls, ::set_prestige, self getrankedplayerdata("cp", "progression", "playerLevel", "prestige"), 0, 20, 1);
        // self add_increment("change level", increment_controls, ::set_rank, self getrankedplayerdata("cp", "progression", "playerLevel", "xp"), 1, 999, 1);
        self add_option("max out all weapons", undefined, ::set_max_weapons);
        self add_option("complete all challenges", undefined, ::complete_challenges);
        self add_option("complete contracts", undefined, ::complete_active_contracts);
        self add_option("give soul keys", undefined, ::unlock_soul_keys);
        self add_toggle("temporary director's cut", undefined, ::temp_directors_cut, self.temp_directors_cut);
        break;
    case "nac bind":
        self.is_bind_menu = true;
        self add_menu("nac bind");
        self add_option("set first weapon", undefined, ::set_first_weapon);
        self add_option("set second weapon", undefined, ::set_second_weapon);
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
        /*
        if (is_true(self.is_bind_menu))
            self bind_index(menu, func);
        else
            self player_index(menu, self.select_player);
        */

        self player_index(menu, self.select_player);
        break;
    }
}

/*
bind_index(menu, func)
{
    self add_menu(menu);

    for(i = 0; i < 4; i++)
    {
        self add_option(va("%s -> %s", menu, "[{+actionslot" + i + "}]"), func, i);
    }
}
*/

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

// lets create the menu now
initial_precache()
{
    foreach(shader in list("ui_arrow_right,ui_scrollbar_arrow_right,ui_scrollbar_arrow_left"))
        precacheshader(shader);

    foreach(model in list("model"))
        precachemodel(shader);
}

initial_variable()
{
    // menu variables
    self.font            = "objective";
    self.font_scale      = 0.85;
    self.option_limit    = 10;
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

    // game variables

    // zombie list
    // spaceland
    self.catbox["zombies"]["cp_zmb"][0] = ["generic_zombie", "zombie_clown", "zombie_cop", "zombie_brute", "zombie_ghost", "the_hoff"];
    self.catbox["zombies"]["cp_zmb"][1] = ["normal zombie", "clown", "cop", "brute", "ghost", "david hasselhoff"];

    // rave in the redwoods
    self.catbox["zombies"]["cp_rave"][0] = ["generic_zombie", "lumberjack", "zombie_sasquatch", "slasher", "superslasher"];
    self.catbox["zombies"]["cp_rave"][1] = ["normal zombie", "lumberjack", "sasquatch", "slasher", "super slasher"];

    // shaolin shuffle
    self.catbox["zombies"]["cp_disco"][0] = ["generic_zombie", "karatemaster", "skater", "ratking", "pamgrier"];
    self.catbox["zombies"]["cp_disco"][1] = ["normal zombie", "karate zombie", "skater", "rat king", "pam grier"];

    // attack of the radioactive thing
    self.catbox["zombies"]["cp_town"][0] = ["generic_zombie", "crab_mini", "crab_brute", "crab_boss", "elvira"];
    self.catbox["zombies"]["cp_town"][1] = ["normal zombie", "crog", "crog brute", "crog boss", "elvira"];

    // beast from beyond
    self.catbox["zombies"]["cp_final"][0] = ["generic_zombie", "alien_goon", "alien_phantom", "alien_rhino", "dlc4_boss"];
    self.catbox["zombies"]["cp_final"][1] = ["normal zombie", "cryptid", "phantom", "rhino", "mephistopheles"];

    // teleport list
    
    // spaceland teleport names
    self.catbox["main teleports"]["cp_zmb"][0] = ["pap room", "spawn", "main portal", "afterlife arcade"];
    self.catbox["map setup teleports"]["cp_zmb"][0] = ["spawn power", "journey power", "kepler power", "polar peak power", "arcade power", "journey teleporter", "kepler teleporter", "polar peak teleporter", "arcade teleporter"];
    self.catbox["mystery wheel teleports"]["cp_zmb"][0] = ["journey 1", "journey 2", "journey 3", "astrocade", "polar peak", "kepler 1", "kepler 2", "kepler 3"];
    self.catbox["main quest teleports"]["cp_zmb"][0] = ["calculator 1", "calculator 2", "calculator 3", "boom box 1", "boom box 2", "boom box 3", "umbrella 1", "umbrella 2", "umbrella 3", "dj booth 1", "dj booth 2", "dj booth 3"];
    self.catbox["extra teleports"]["cp_zmb"][0] = ["n31l's head", "n31l auxiliary battery 1", "n31l auxiliary battery 2", "n31l auxiliary battery 3", "n31l auxiliary battery 4", "n31l auxiliary battery 5", "n31l auxiliary battery 6", "n31l floppy disk 1", "n31l floppy disk 2", "n31l floppy disk 3", "n31l floppy disk 4"];

    // spaceland teleport origins
    self.catbox["main teleports"]["cp_zmb"][1] = [(-10245, 740, -1630), (465, 3680, 0), (650, 970, 0), (-9885, -70, -1795)];
    self.catbox["map setup teleports"]["cp_zmb"][1] = [(1075, 3720, 0), (4695, 1250, 115), (-1365, -65, 380), (-695, -2795, 560), (2390, -1825, 115), (3640, 1165, 55), (-2150, -35, 225), (-1490, -2650, 360), (2285, -1615, 115)];
    self.catbox["mystery wheel teleports"]["cp_zmb"][1] = [(1470, 1045, 0), (4065, 2135, 55), (3690, 420, 55), (2575, -865, 240), (955, -2260, 440), (-1950, 1830, 365), (-1900, -530, 380), (-845, -1492, 360)];
    self.catbox["main quest teleports"]["cp_zmb"][1] = [(540, 1060, 0), (-2520, 805, 365), (2960, -850, 240), (595, 2125, -65), (-1415, -175, 380), (1375, -590, -195), (155, -505, 0), (-1890, -3040, 360), (3640, 2335, 115), (-1000, 1495, 225), (-2710, -2480, 360), (2926, 1305, 0)];
    self.catbox["extra teleports"]["cp_zmb"][1] = [(475, -265, 0), (-1800, -2825, 360), (-535, -3265, 390), (-757, -2415, 560), (-2775, 1565, 365), (-3045, 730, 365), (-1230, 1625, 225), (2425, -106, -196), (2495, -295, -196), (1920, -635, -196), (100, -1115, -252)];

    // spaceland teleport angles
    self.catbox["main teleports"]["cp_zmb"][2] = [90, -90, -90, -90];
    self.catbox["map setup teleports"]["cp_zmb"][2] = [-90, 0, -90, 90, 180, 0, -45, 20, -90];
    self.catbox["mystery wheel teleports"]["cp_zmb"][2] = [180, 90, 0, -90, 0, -45, -90, 0];
    self.catbox["main quest teleports"]["cp_zmb"][2] = [0, 0, 90, 45, 0, 90, 160, 90, -90, 0, -90, 0];
    self.catbox["extra teleports"]["cp_zmb"][2] = [-90, 180, -90, 0, 0, 0, 90, 50, 60, -100, 135];

    // rave teleport names
    self.catbox["main teleports"]["cp_rave"][0] = ["spawn", "pap room", "ritual circle", "main portal"];
    self.catbox["map setup teleports"]["cp_rave"][0] = ["spawn power", "mess hall power", "lake power", "mine power"];
    self.catbox["mystery wheel teleports"]["cp_rave"][0] = ["mess hall", "lake", "mines", "cabins"];
    self.catbox["main quest teleports"]["cp_rave"][0] = ["film reel 1", "film reel 2", "film reel 3", "dj booth"];
    self.catbox["extra teleports"]["cp_rave"][0] = ["vhs tape", "kevin mask", "rave mask", "worm mask"];

    // rave teleport origins
    self.catbox["main teleports"]["cp_rave"][1] = [(-750, 1085, 0), (-140, 1960, -90), (-1120, -490, 0), (-1585, -345, 0)];
    self.catbox["map setup teleports"]["cp_rave"][1] = [(465, 1075, 0), (2250, -825, 100), (-1775, -2375, 65), (-1075, 2300, -100)];
    self.catbox["mystery wheel teleports"]["cp_rave"][1] = [(2165, -1075, 100), (-1885, -2245, 65), (-1125, 2300, -100), (-2295, -205, 0)];
    self.catbox["main quest teleports"]["cp_rave"][1] = [(-150, 1925, -90), (-2285, -1480, 65), (-1075, 2345, -100), (-810, 160, 0)];
    self.catbox["extra teleports"]["cp_rave"][1] = [(1145, 280, 0), (-725, -240, 0), (-1345, -555, 0), (-280, -1260, 0)];

    // rave teleport angles
    self.catbox["main teleports"]["cp_rave"][2] = [180, 180, -90, 90];
    self.catbox["map setup teleports"]["cp_rave"][2] = [180, -90, 90, -90];
    self.catbox["mystery wheel teleports"]["cp_rave"][2] = [90, 45, -90, 0];
    self.catbox["main quest teleports"]["cp_rave"][2] = [90, 180, -90, -90];
    self.catbox["extra teleports"]["cp_rave"][2] = [0, 90, 90, 90];

    // disco teleport names
    self.catbox["main teleports"]["cp_disco"][0] = ["spawn", "pap room", "main portal"];
    self.catbox["map setup teleports"]["cp_disco"][0] = ["disco power", "roller rink power", "arcade power", "disco teleporter", "roller rink teleporter", "arcade teleporter"];
    self.catbox["mystery wheel teleports"]["cp_disco"][0] = ["arcade", "roller rink", "disco"];
    self.catbox["main quest teleports"]["cp_disco"][0] = ["mic stand", "boombox", "flyer", "dj booth"];
    self.catbox["extra teleports"]["cp_disco"][0] = ["pac-man part", "records", "guitar", "vip pass"];

    // disco teleport origins
    self.catbox["main teleports"]["cp_disco"][1] = [(580, 780, 0), (-275, 2525, -70), (-2000, -280, 0)];
    self.catbox["map setup teleports"]["cp_disco"][1] = [(1885, 685, 0), (85, -1190, 0), (-2400, -380, 0), (1785, 110, 0), (-240, -1650, 0), (-2455, -780, 0)];
    self.catbox["mystery wheel teleports"]["cp_disco"][1] = [(-2775, -835, 0), (-100, -1580, 0), (1885, 160, 0)];
    self.catbox["main quest teleports"]["cp_disco"][1] = [(-370, 630, 0), (195, -320, 0), (-2025, -745, 0), (-1720, -480, 0)];
    self.catbox["extra teleports"]["cp_disco"][1] = [(-2440, -190, 0), (-1140, -265, 0), (-1495, 920, 0), (-220, -2035, 0)];

    // disco teleport angles
    self.catbox["main teleports"]["cp_disco"][2] = [180, 180, -90];
    self.catbox["map setup teleports"]["cp_disco"][2] = [0, 0, 90, 180, 90, 90];
    self.catbox["mystery wheel teleports"]["cp_disco"][2] = [90, 180, 180];
    self.catbox["main quest teleports"]["cp_disco"][2] = [180, -90, 180, 90];
    self.catbox["extra teleports"]["cp_disco"][2] = [0, 180, -90, -90];

    // town teleport names
    self.catbox["main teleports"]["cp_town"][0] = ["spawn", "pap room", "main portal"];
    self.catbox["map setup teleports"]["cp_town"][0] = ["police power", "dance club power", "diner power", "bowling power", "police teleporter", "dance club teleporter", "diner teleporter", "bowling teleporter"];
    self.catbox["mystery wheel teleports"]["cp_town"][0] = ["diner", "dance club", "bowling", "alley"];
    self.catbox["main quest teleports"]["cp_town"][0] = ["pack parts 1", "pack parts 2", "pack parts 3", "dj booth"];
    self.catbox["extra teleports"]["cp_town"][0] = ["alien fuse", "gold record", "cassette", "flyer"];

    // town teleport origins
    self.catbox["main teleports"]["cp_town"][1] = [(-1385, 420, 0), (245, -490, -90), (-1830, 70, 0)];
    self.catbox["map setup teleports"]["cp_town"][1] = [(315, 740, 0), (2140, -1235, 0), (-1905, 1030, 0), (-2075, -1385, 0), (550, 1040, 0), (2375, -1700, 0), (-2265, 970, 0), (-2340, -1790, 0)];
    self.catbox["mystery wheel teleports"]["cp_town"][1] = [(-2100, 1310, 0), (2210, -1415, 0), (-2615, -1715, 0), (-540, 2425, 0)];
    self.catbox["main quest teleports"]["cp_town"][1] = [(1485, -440, 0), (1640, -1195, 0), (-2600, -1650, 0), (-1335, 0, 0)];
    self.catbox["extra teleports"]["cp_town"][1] = [(1515, -1440, 0), (-865, -275, 0), (705, 250, 0), (-1230, -880, 0)];

    // town teleport angles
    self.catbox["main teleports"]["cp_town"][2] = [90, -90, -90];
    self.catbox["map setup teleports"]["cp_town"][2] = [-90, 180, 90, 0, 90, 0, 0, -90];
    self.catbox["mystery wheel teleports"]["cp_town"][2] = [-90, 180, -90, 0];
    self.catbox["main quest teleports"]["cp_town"][2] = [0, 0, 90, -90];
    self.catbox["extra teleports"]["cp_town"][2] = [90, 180, -90, 0];

    // beast from beyond teleport names
    self.catbox["main teleports"]["cp_final"][0] = ["pap room","spawn","control room","theatre","afterlife arcade"];
    self.catbox["map setup teleports"]["cp_final"][0] = ["n31l's head","n31l","open theatre portal"];
    self.catbox["mystery wheel teleports"]["cp_final"][0] = ["spawn","water room","main room","hallway","storage room","theatre","outside"];
    self.catbox["extra teleports"]["cp_final"][0] = ["pap bridge part 1","pap bridge part 2","pap bridge part 3","pap bridge","mephistopheles arena"];

    // beast from beyond teleport origins
    self.catbox["main teleports"]["cp_final"][1] = [(5135,-5180,285),(-760,2920,90),(730,5065,90),(5515,-4515,-20),(2080,-4520,330)];
    self.catbox["map setup teleports"]["cp_final"][1] = [(-1210,5040,-70),(45,3840,25),(1920,3470,15)];
    self.catbox["mystery wheel teleports"]["cp_final"][1] = [(-90,2880,25),(-1215,4755,-205),(645,5710,60),(1510,4010,15),(1470,3565,-175),(5700,-4050,-70),(2185,6275,95)];
    self.catbox["main quest teleports"]["cp_final"][1] = [(0,0,0),(0,0,0)];
    self.catbox["extra teleports"]["cp_final"][1] = [(-855,5435,-70),(1755,3110,-290),(4990,-6835,50),(3465,6640,165),(-13300,-325,-105)];

    // beast from beyond teleport angles
    self.catbox["main teleports"]["cp_final"][2] = [90,20,-45,90,0];
    self.catbox["map setup teleports"]["cp_final"][2] = [-155,90,90];
    self.catbox["mystery wheel teleports"]["cp_final"][2] = [-90,-130,180,90,60,0,-50];
    self.catbox["main quest teleports"]["cp_final"][2] = [0,0];
    self.catbox["extra teleports"]["cp_final"][2] = [-55,60,-100,45,0];

    // powerup list
    self.catbox["powerups"][0] = ["nuke", "max ammo", "instakill", "double money", "carpenter", "pack-a-punch", "fire sale", "infinite ammo", "infinite grenades"];
    self.catbox["powerups"][1] = ["kill_50", "ammo_max", "instakill_30", "cash_2", "board_windows", "upgrade_weapons", "fire_30", "infinite_20", "grenade_30"];

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
                        // self sfx("entrance_sign_power_on_build");
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
                    self sfx("zmb_powerup_activate");

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
                            self sfx("zmb_powerup_activate");
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
                            self sfx("zmb_wheel_wpn_acquired");
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
                        self sfx("part_pickup");
                        if (is_true(self.structure[cursor]["slider"]))
                        {
                            if (is_true(self.structure[cursor]["is_array"]))
                                self thread execute_function(self.structure[cursor]["function"], isdefined(self.structure[cursor]["array"]) ? self.structure[cursor]["array"][self.slider[menu + "_" + cursor]] : self.slider[menu + "_" + cursor], self.structure[cursor]["argument_1"], self.structure[cursor]["argument_2"], self.structure[cursor]["argument_3"]);
                            else
                                self iprintlnbold("use the ^2slider controls^7, not the jump button!");
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
    option["is_increment"] = true;
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

    self.current_menu_color = (0.749, 0.251, 0.592);

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

            // new menu text
            if (isdefined(self.structure[index]["function"]) && self.structure[index]["function"] == ::new_menu)
                self.menu["hud"]["submenu"][index] = self create_text(">", self.font, 0.65, "TOP_RIGHT", "TOPCENTER", (self.x_offset + 212), (self.y_offset + ((i * self.option_spacing) + 20)), color[0], 1, 10);
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