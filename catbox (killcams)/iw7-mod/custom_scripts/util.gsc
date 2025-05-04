#include scripts\engine\utility;
#include scripts\cp\utility;
#include scripts\cp\cp_hud_util;
#include custom_scripts\func;
#include custom_scripts\menu;
#include custom_scripts\catbox;


// utility stuff here

callback_playerdamage_stub(var_0, var_1, var_2, var_3, var_4, var_5, var_6, var_7, var_8, var_9, var_10, var_11) 
{
    if (isdefined(var_4) && var_4 == "MOD_FALLING")
        return;

    self [[level.damage_original]](var_0, var_1, var_2, var_3, var_4, var_5, var_6, var_7, var_8, var_9, var_10, var_11);
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

// gotta use a wrapper because scripts\engine\utility::istrue makes the game not load for some reason
is_true(variable)
{
    if (isdefined(variable) && variable)
    {
        return true;
    }

    return false;
}

actually_alive() // errors lol
{
    return isalive(self) && !toggle(self.lastStand);
}

toggle(variable) 
{
    return isdefined(variable) && variable;
}

get_players()
{
    return level.players;
}

get_zombies()
{
    return scripts\cp\cp_agent_utils::getaliveagentsofteam("axis");
}

get_map_name()
{
    level.map_name = getDvar("mapname");
}

is_map(map)
{
    return getdvar("map_name") == map;
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
    if (isdefined(self.now_monitoring))
        return;

    self.now_monitoring = true;
    
    if (!isdefined(self.button_actions))
        self.button_actions = ["+sprint", "+melee", "+melee_zoom", "+melee_breath", "+stance", "+gostand", "weapnext", "+actionslot 1", "+actionslot 2", "+actionslot 3", "+actionslot 4", "+forward", "+back", "+moveleft", "+moveright"];
    if (!isdefined(self.button_pressed))
        self.button_pressed = [];
    
    for(a=0 ; a < self.button_actions.size ; a++)
        self thread button_monitor(self.button_actions[a]);
}

create_notify()
{
    foreach(value in StrTok("+sprint,+actionslot 1,+actionslot 2,+actionslot 3,+actionslot 4,+frag,+smoke,+melee,+melee_zoom,+stance,+gostand,+switchseat,+usereload", ",")) 
    {
        self NotifyOnPlayerCommand(value, value);
    }
}

can_upgrade_hook(param_00,param_01)
{
	return 1;
}

bullet_trace() 
{
    point = bullettrace(self geteye(), self geteye() + anglestoforward(self getplayerangles()) * 1000000, 0, self)["position"];
    return point;
}

set_position(origin, angles)
{
    self setorigin(origin);
    self setplayerangles(angles);
}

sfx(sound)
{
    self playsoundtoplayer(sound, self);
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

hook_true()
{
    return true;
}

hook_false()
{
    return false;
}

zombiekilled( einflictor, attacker, iDamage, sMeansOfDeath, sWeapon, var_5, var_6, psoffsettime, deathtimeoffset )
{
    if(level.is_recording)
        return;

    thread _id_5853();
    
    self.deathtime = gettime();
    killcamentity = _id_7F32(attacker, einflictor, sWeapon);
    killcamentitystarttime = killcamentity.birthtime;

    attacker childthread setup_weapon_image(sWeapon);
    attacker childthread get_weapon_ismk2(sWeapon);
    attacker childthread setup_weapon_display(sWeapon);

    thread recordfinalkillcam( 5, self, attacker, attacker getentitynumber(), attacker, killcamentity getentitynumber(), killcamentitystarttime, false, sWeapon, deathtimeoffset, psoffsettime, sMeansOfDeath );
}

recordfinalkillcam( var_0, var_1, var_2, var_3, var_4, var_5, var_6, var_7, var_8, var_9, var_10, var_11 )
{
    if ( level.teambased && isdefined( var_2.team ) )
    {
        level.finalkillcam_delay[var_2.team] = var_0;
        level.finalkillcam_victim[var_2.team] = var_1;
        level.finalkillcam_attacker[var_2.team] = var_2;
        level.finalkillcam_attackernum[var_2.team] = var_3;
        level._id_6C64[var_2.team] = var_4;
        level.finalkillcam_killcamentityindex[var_2.team] = var_5;
        level.finalkillcam_killcamentitystarttime[var_2.team] = var_6;
        level.finalkillcam_killcamentitystickstovictim[var_2.team] = var_7;
        level.finalkillcam_sweapon[var_2.team] = var_8;
        level.finalkillcam_deathtimeoffset[var_2.team] = var_9;
        level.finalkillcam_psoffsettime[var_2.team] = var_10;
        level.finalkillcam_timerecorded[var_2.team] = getsecondspassed();
        level.finalkillcam_timegameended[var_2.team] = getsecondspassed();
        level.finalkillcam_smeansofdeath[var_2.team] = var_11;
        level.finalkillcam_attackers[var_2.team] = var_1.attackers;
        level.finalkillcam_attackerdata[var_2.team] = var_1.attackerdata;
        level.finalkillcam_attackerperks[var_2.team] = [];
        level.finalkillcam_killstreakvariantinfo[var_2.team] = var_1.killsteakvariantattackerinfo;

        if ( isdefined( var_4 ) && isagent( var_4 ) )
        {
            level._id_6C65[var_2.team] = var_4.agent_type;
            level._id_6C66[var_2.team] = var_4.lastspawntime;
        }
        else
        {
            level._id_6C65[var_2.team] = undefined;
            level._id_6C66[var_2.team] = undefined;
        }
    }
    else if ( !level.teambased )
    {
        level.finalkillcam_delay[var_2.guid] = var_0;
        level.finalkillcam_victim[var_2.guid] = var_1;
        level.finalkillcam_attacker[var_2.guid] = var_2;
        level.finalkillcam_attackernum[var_2.guid] = var_3;
        level._id_6C64[var_2.guid] = var_4;
        level.finalkillcam_killcamentityindex[var_2.guid] = var_5;
        level.finalkillcam_killcamentitystarttime[var_2.guid] = var_6;
        level.finalkillcam_killcamentitystickstovictim[var_2.guid] = var_7;
        level.finalkillcam_sweapon[var_2.guid] = var_8;
        level.finalkillcam_deathtimeoffset[var_2.guid] = var_9;
        level.finalkillcam_psoffsettime[var_2.guid] = var_10;
        level.finalkillcam_timerecorded[var_2.guid] = getsecondspassed();
        level.finalkillcam_timegameended[var_2.guid] = getsecondspassed();
        level.finalkillcam_smeansofdeath[var_2.guid] = var_11;
        level.finalkillcam_attackers[var_2.guid] = var_1.attackers;
        level.finalkillcam_attackerdata[var_2.guid] = var_1.attackerdata;
        level.finalkillcam_attackerperks[var_2.guid] = var_2.pers["loadoutPerks"];
        level.finalkillcam_killstreakvariantinfo[var_2.guid] = var_1.killsteakvariantattackerinfo;

        if ( isdefined( var_4 ) && isagent( var_4 ) )
        {
            level._id_6C65[var_2.guid] = var_4.agent_type;
            level._id_6C66[var_2.guid] = var_4.lastspawntime;
        }
        else
        {
            level._id_6C65[var_2.guid] = undefined;
            level._id_6C66[var_2.guid] = undefined;
        }
    }

    level.finalkillcam_delay["none"] = var_0;
    level.finalkillcam_victim["none"] = var_1;
    level.finalkillcam_attacker["none"] = var_2;
    level.finalkillcam_attackernum["none"] = var_3;
    level._id_6C64["none"] = var_4;
    level.finalkillcam_killcamentityindex["none"] = var_5;
    level.finalkillcam_killcamentitystarttime["none"] = var_6;
    level.finalkillcam_killcamentitystickstovictim["none"] = var_7;
    level.finalkillcam_sweapon["none"] = var_8;
    level.finalkillcam_deathtimeoffset["none"] = var_9;
    level.finalkillcam_psoffsettime["none"] = var_10;
    level.finalkillcam_timerecorded["none"] = getsecondspassed();
    level.finalkillcam_timegameended["none"] = getsecondspassed();
    level.finalkillcam_timegameended["none"] = getsecondspassed();
    level.finalkillcam_smeansofdeath["none"] = var_11;
    level.finalkillcam_attackers["none"] = var_1.attackers;
    level.finalkillcam_attackerdata["none"] = var_1.attackerdata;
    level.finalkillcam_attackerperks["none"] = var_2.pers["loadoutPerks"];
    level.finalkillcam_killstreakvariantinfo["none"] = var_1.killsteakvariantattackerinfo;

    if ( isdefined( var_4 ) && isagent( var_4 ) )
    {
        level._id_6C65["none"] = var_4.agent_type;
        level._id_6C66["none"] = var_4.lastspawntime;
    }
    else
    {
        level._id_6C65["none"] = undefined;
        level._id_6C66["none"] = undefined;
    }

    level.is_recording = true;
    wait 4.5;
    executecommand("luireload"); // temp fix for killer info not loading
    level notify( "round_end_finished" );
}

gettimepassed()
{
    if ( !isdefined( level.starttime ) || !isdefined( level._id_561F ) )
        return 0;

    if ( level._id_1191F )
        return level._id_1191E - level.starttime - level._id_561F;
    else
        return gettime() - level.starttime - level._id_561F;
}

getsecondspassed()
{
    return gettimepassed() / 1000;
}

_id_7F32( var_0, var_1, var_2 )
{
    if ( !isdefined( var_0 ) || !isdefined( var_1 ) || var_0 == var_1 && !isagent( var_0 ) )
        return undefined;

    if ( var_1.israllytrap )
        return var_1.killcament;

    switch ( var_2 )
    {
        case "hashima_missiles_mp":
        case "sentry_shock_grenade_mp":
        case "jackal_fast_cannon_mp":
        case "sentry_shock_missile_mp":
        case "bombproj_mp":
        case "sentry_shock_mp":
        case "heli_pilot_turret_mp":
        case "iw7_c8landing_mp":
        case "super_trophy_mp":
        case "micro_turret_gun_mp":
        case "bouncingbetty_mp":
        case "player_trophy_system_mp":
        case "trophy_mp":
        case "power_exploding_drone_mp":
        case "trip_mine_mp":
        case "bomb_site_mp":
            return scripts\engine\utility::ter_op( isdefined( var_1.killcament ), var_1.killcament, var_1 );
        case "remote_tank_projectile_mp":
        case "jackal_turret_mp":
        case "hind_missile_mp":
        case "hind_bomb_mp":
        case "aamissile_projectile_mp":
        case "jackal_cannon_mp":
            if ( isdefined( var_1.vehicle_fired_from ) && isdefined( var_1.vehicle_fired_from.killcament ) )
                return var_1.vehicle_fired_from.killcament;
            else if ( isdefined( var_1.vehicle_fired_from ) )
                return var_1.vehicle_fired_from;

            break;
        case "iw7_minigun_c8_mp":
        case "iw7_chargeshot_c8_mp":
        case "iw7_c8offhandshield_mp":
            if ( isdefined( var_0 ) && isdefined( var_0._id_4BE1 ) && var_0._id_4BE1 == "MANUAL" )
                return undefined;

            break;
        case "ball_drone_projectile_mp":
        case "ball_drone_gun_mp":
            if ( isplayer( var_0 ) && isdefined( var_0.balldrone ) && isdefined( var_0.balldrone.turret ) && isdefined( var_0.balldrone.turret.killcament ) )
                return var_0.balldrone.turret.killcament;

            break;
        case "shockproj_mp":
            if ( isdefined( var_0._id_B7AA.killcament ) )
                return var_0._id_B7AA.killcament;

            break;
        case "artillery_mp":
        case "none":
            if ( isdefined( var_1.targetname ) && var_1.targetname == "care_package" || isdefined( var_1.killcament ) && ( var_1.classname == "script_brushmodel" || var_1.classname == "trigger_multiple" || var_1.classname == "script_model" ) )
                return var_1.killcament;

            break;
        case "switch_blade_child_mp":
        case "drone_hive_projectile_mp":
            if ( isdefined( var_0.extraeffectkillcam ) )
                return var_0.extraeffectkillcam;
            else
                return undefined;
        case "remote_turret_mp":
        case "ugv_turret_mp":
        case "remotemissile_projectile_mp":
        case "osprey_player_minigun_mp":
        case "minijackal_assault_mp":
        case "minijackal_strike_mp":
        case "venomproj_mp":
            return undefined;
    }

    if ( scripts\engine\utility::isdestructibleweapon( var_2 ))
    {
        if ( isdefined( var_1.killcament ) && !var_0 _id_24ED() )
            return var_1.killcament;
        else
            return undefined;
    }

    return var_1;
}

_id_24ED()
{
    if ( !isdefined( self ) )
        return 0;

    if ( isdefined( level.ac130player ) && self == level.ac130player )
        return 1;

    if ( isdefined( level.chopper ) && isdefined( level.chopper.gunner ) && self == level.chopper.gunner )
        return 1;

    if ( isdefined( level.reminder_reaction_pointat ) && isdefined( level.reminder_reaction_pointat.owner ) && self == level.reminder_reaction_pointat.owner )
        return 1;

    if ( isdefined( self.using_remote_turret ) && self.using_remote_turret )
        return 1;

    if ( isdefined( self.using_remote_tank ) && self.using_remote_tank )
        return 1;
    else if ( isdefined( self.using_remote_a10 ) )
        return 1;

    return 0;
}

_id_5853()
{   
    level waittill( "round_end_finished" );
    level.showingfinalkillcam = 1;
    var_0 = "none";

    if ( isdefined( level.finalkillcam_winner ) )
        var_0 = level.finalkillcam_winner;

    var_1 = level.finalkillcam_delay[var_0];
    var_2 = level.finalkillcam_victim[var_0];
    var_3 = level.finalkillcam_attacker[var_0];
    var_4 = level.finalkillcam_attackernum[var_0];
    var_5 = level._id_6C64[var_0];
    var_6 = level._id_6C65[var_0];
    var_7 = level._id_6C66[var_0];
    var_8 = level.finalkillcam_killcamentityindex[var_0];
    var_9 = level.finalkillcam_killcamentitystarttime[var_0];
    var_10 = level.finalkillcam_killcamentitystickstovictim[var_0];
    var_11 = level.finalkillcam_sweapon[var_0];
    var_12 = level._id_6C62[var_0];
    var_13 = level.finalkillcam_psoffsettime[var_0];
    var_14 = level.finalkillcam_timerecorded[var_0];
    var_15 = level.finalkillcam_timegameended[var_0];
    var_16 = level.finalkillcam_smeansofdeath[var_0];
    var_17 = level.finalkillcam_attackers[var_0];
    var_18 = level.finalkillcam_attackerdata[var_0];
    var_19 = level.finalkillcam_attackerperks[var_0];
    var_20 = level.finalkillcam_killstreakvariantinfo[var_0];

    if ( !isdefined( var_2 ) || !isdefined( var_3 ) )
    {
        level.showingfinalkillcam = 0;
        level notify( "final_killcam_done" );
        return;
    }

    var_21 = 20;
    var_22 = var_15 - var_14;

    if ( var_22 > var_21 )
    {
        level.showingfinalkillcam = 0;
        level notify( "final_killcam_done" );
        return;
    }

    var_24 = spawnstruct();
    var_24.agent_type = var_6;
    var_24.lastspawntime = var_7;
    var_25 = ( gettime() - var_2.deathtime ) / 1000;
    print(var_25);

    foreach ( var_27 in level.players )
    {
        var_27 visionsetnakedforplayer( "", 0 );
        var_27.killcamentitylookat = var_2 getentitynumber();
        var_27 thread killcam( var_5, var_24, var_4, var_8, var_9, var_2 getentitynumber(), var_10, var_11, var_25, var_13, 0, 12, var_3, var_2, var_16, var_19, var_20 );
    }

    wait( 0.15 + level._id_B4A7 );

    while ( anyplayersinkillcam() )
        wait 0.05;

    level notify( "final_killcam_done" );
    level.showingfinalkillcam = 0;
    level.is_recording = false;
}

anyplayersinkillcam()
{
    foreach ( var_1 in level.players )
    {
        if ( isdefined( var_1.killcam ) )
            return 1;
    }

    return 0;
}

killcam( var_0, var_1, var_2, var_3, var_4, var_5, var_6, var_7, var_8, var_9, var_10, var_11, var_12, var_13, var_14, var_15, var_16 )
{
    self endon( "disconnect" );
    self endon( "spawned" );
    level endon( "game_ended" );

    killcamstarttime = gettime();
    if ( level.showingfinalkillcam )
    {
        setglobalsoundcontext( "atmosphere", "killcam", 0.1 );

        foreach ( var_18 in level.players )
        {
            self playlocalsound( "final_killcam_in" );
            self _meth_82C2( "killcam", "mix" );
        }
    }

    if ( var_2 < 0 || !isdefined( var_12 ) )
        return;

    level._id_C23C++;
    var_20 = 0.05 * ( level._id_C23C - 1 );
    level._id_B4A7 = var_20;

    if ( level._id_C23C > 1 )
        wait( var_20 );

    wait 0.05;
    level._id_C23C--;

    if ( getdvar( "scr_killcam_time" ) == "" )
    {
        if ( var_7 == "artillery_mp" || var_7 == "stealth_bomb_mp" || var_7 == "warhawk_mortar_mp" )
            var_21 = ( gettime() - var_4 ) / 1000 - var_8 - 0.1;
        else if ( var_7 == "remote_mortar_missile_mp" )
            var_21 = 6.5;
        else if ( level.showingfinalkillcam )
            var_21 = 4.0 + level._id_B4A7 - var_20;
        else if ( var_7 == "apache_minigun_mp" )
            var_21 = 3.0;
        else if ( var_7 == "javelin_mp" )
            var_21 = 8;
        else if ( var_7 == "iw7_niagara_mp" )
            var_21 = 5.0;
        else if ( issubstr( var_7, "remotemissile_" ) )
            var_21 = 5;
        else if ( isdefined( var_0.sentrytype ) && var_0.sentrytype == "multiturret" )
            var_21 = 2.0;
        else if ( !var_10 || var_10 > 5.0 )
            var_21 = 5.0;
        else if ( var_7 == "frag_grenade_mp" || var_7 == "frag_grenade_short_mp" || var_7 == "semtex_mp" || var_7 == "semtexproj_mp" || var_7 == "mortar_shell__mp" || var_7 == "cluster_grenade_mp" )
            var_21 = 4.25;
        else
            var_21 = 2.5;
    }
    else
        var_21 = getdvarfloat( "scr_killcam_time" );

    if ( isdefined( var_11 ) )
    {
        if ( var_21 > var_11 )
            var_21 = var_11;

        if ( var_21 < 0.05 )
            var_21 = 0.05;
    }

    if ( getdvar( "scr_killcam_posttime" ) == "" )
    {
        if ( isdefined( var_0 ) && var_0 == var_12 )
            var_22 = 3.5;
        else
            var_22 = 2;
    }
    else
    {
        var_22 = getdvarfloat( "scr_killcam_posttime" );

        if ( var_22 < 0.05 )
            var_22 = 0.05;
    }

    if ( var_2 < 0 || !isdefined( var_12 ) )
        return;

    var_23 = _id_127CF( var_0, var_1, var_12, var_13, var_3, var_21, var_22, var_8, var_11 );

    if ( !isdefined( var_23 ) )
        return;

    if ( level.showingfinalkillcam )
        self setclientomnvar( "post_game_state", 3 );

    var_24 = getdvarint( "scr_player_forcerespawn" );

    if ( var_10 && !level.gameended || isdefined( self ) && isdefined( self.battlebuddy ) && !level.gameended || var_24 == 0 && !level.gameended )
        self setclientomnvar( "ui_killcam_text", "skip" );
    else if ( !level.gameended )
        self setclientomnvar( "ui_killcam_text", "respawn" );
    else
        self setclientomnvar( "ui_killcam_text", "none" );

    self notify( "begin_killcam", gettime() );
    scripts\cp\utility::updatesessionstate( "spectator" );
    self.spectatekillcam = 1;

    if ( isagent( var_12 ) || isagent( var_0 ) )
    {
        var_2 = var_13 getentitynumber();
        var_9 = var_9 - 25;
    }

    self.forcespectatorclient = var_12 getentitynumber();
    self.killcamentity = -1;

    thread _id_F76B( var_3, var_23.killcamoffset, var_4, var_5, var_6 );


    self.archivetime = 4.5 + 5;
    self._id_A63E = var_23._id_A63E;
    self.psoffsettime = var_9;
    self allowspectateteam( "allies", 1 );
    self allowspectateteam( "axis", 1 );
    self allowspectateteam( "freelook", 1 );
    self allowspectateteam( "none", 1 );

    if ( level.multiteambased )
    {
        foreach ( var_28 in level.teamnamelist )
            self allowspectateteam( var_28, 1 );
    }

    thread _id_6315();
    wait 0.05;

    if ( !isdefined( self ) )
        return;

    if ( self.archivetime < var_23.killcamoffset )
    {
        var_30 = var_23.killcamoffset - self.archivetime;

        if ( game["truncated_killcams"] < 32 )
            game["truncated_killcams"]++;
    }

    var_23._id_37F1 = self.archivetime - 0.05;
    var_23._id_A63E = var_23._id_37F1 + 1;
    self._id_A63E = var_23._id_A63E;

    if ( var_23._id_37F1 <= 0 )
    {
        scripts\cp\utility::updatesessionstate( "dead" );
        clearkillcamstate();
        self notify( "killcam_ended" );
        return;
    }

    thread _id_5854( var_23, self.killcamentity, var_12, var_13, var_14 );

    self.killcam = 1;

    if ( isdefined( self.battlebuddy ) && !level.gameended )
        self._id_28CD = gettime();

    thread _id_10855();

    // if ( !level.showingfinalkillcam )
    //     thread _id_13715( var_10 );
    // else
        self notify( "showing_final_killcam" );

    thread _id_635D();
    waittillkillcamover();
    thread _id_A639( 1 );

    scripts\cp\cp_globallogic::spawnplayer();
}

clearkillcamstate()
{
    self.forcespectatorclient = -1;
    self.killcamentity = -1;
    self.archivetime = 0;
    self.psoffsettime = 0;
    self.spectatekillcam = 0;
}

_id_635D()
{
    self endon( "disconnect" );
    self endon( "killcam_ended" );

    while(true)
    {
        wait 0.05;
    }

    self notify( "abort_killcam" );
}

clearlootweaponomnvars()
{
    self setclientomnvar( "ui_killcam_killedby_loot_variant_id", -1 );
    self setclientomnvar( "ui_killcam_killedby_weapon_rarity", -1 );
}

clearkillcamkilledbyitemomnvars()
{
    self setclientomnvar( "ui_killcam_killedby_item_type", -1 );
    self setclientomnvar( "ui_killcam_killedby_item_id", -1 );
}

get_weapon_ismk2( sWeapon )
{
    setdvar("ui_killcam_weaponmk2", scripts\cp\utility::ismark2weapon( scripts\cp\utility::get_weapon_variant_id( self, sWeapon ) ));
}

setup_weapon_image( sWeapon )
{
    weaponicon = "white";
    rootname = scripts\cp\utility::getweaponrootname( sWeapon );
    variant_id = scripts\cp\utility::get_weapon_variant_id( self, sWeapon );
    variant_ref = lookupvariantref( rootname, variant_id );
    
    if(variant_id == -1)
        setdvar("ui_killcam_weaponvariantid", 0);
    else if(getdvar("ui_killcam_weaponmk2"))
        setdvar("ui_killcam_weaponvariantid", 4);
    else
        setdvar("ui_killcam_weaponvariantid", variant_id);

    if(variant_id > 0)
        weaponicon = tablelookup( "mp/loot/weapon/" + rootname + ".csv", 1, variant_ref, 11 );
    else
        weaponicon = tablelookup( "mp/statsTable.csv", 3, rootname, 6 );
    
    setdvar("ui_killcam_weaponicon", weaponicon);
}

setup_weapon_display( sWeapon )
{
    weaponname = "MISSING";
    rootname = scripts\cp\utility::getweaponrootname( sWeapon );
    variant_id = getdvarint("ui_killcam_weaponvariantid");
    variant_ref = lookupvariantref( rootname, variant_id );

    if(variant_id > 0)
        weaponname = tablelookup( "mp/loot/weapon/" + rootname + ".csv", 1, variant_ref, 10 );
    else
        weaponname = tablelookup( "mp/statsTable.csv", 3, rootname, 3 );
    
    setdvar("ui_killcam_weaponname", weaponname);
}

lookupvariantref( var_0, var_1 )
{
    var_2 = "mp/loot/weapon/" + var_0 + ".csv";
    var_3 = tablelookup( var_2, 0, var_1, 1 );
    return var_3;
}

_id_A639( var_0 )
{
    if ( level.showingfinalkillcam )
        setomnvarforallclients( "post_game_state", 1 );

    self.killcam = undefined;
    var_1 = level.showingfinalkillcam;

    if ( !var_1 )
        setcinematiccamerastyle( "unknown", -1, -1 );

    if ( !level.gameended )
        self notify("yar");
        //scripts\mp\utility::clearlowermessage( "kc_info" );

    //thread scripts\mp\spectating::setspectatepermissions();
    self notify( "killcam_ended" );

    scripts\cp\utility::updatesessionstate( "dead" );
    clearkillcamstate();
}

setcinematiccamerastyle( var_0, var_1, var_2 )
{
    self setclientomnvar( "cam_scene_name", var_0 );
    self setclientomnvar( "cam_scene_lead", var_1 );
    self setclientomnvar( "cam_scene_support", var_2 );
}

_id_127CF( var_0, var_1, var_2, var_3, var_4, var_5, var_6, var_7, var_8 )
{
    var_9 = var_5 + var_6;

    if ( isdefined( var_8 ) && var_9 > var_8 )
    {

        if ( var_8 - var_5 >= 1 )
            var_6 = var_8 - var_5;
        else
        {
            var_6 = 1;
            var_5 = var_8 - 1;
        }

        var_9 = var_5 + var_6;
    }

    var_10 = var_5 + var_7;

    if ( isdefined( var_1 ) && isdefined( var_1.lastspawntime ) )
        var_11 = var_1.lastspawntime;
    else
    {
        var_11 = var_2.lastspawntime;

        if ( isdefined( var_2.deathtime ) )
        {
            if ( gettime() - var_2.deathtime < var_6 * 1000.0 )
            {
                var_6 = 1.0;
                var_6 = var_6 - 0.05;
                var_9 = var_5 + var_6;
            }
        }
    }

    var_12 = ( gettime() - var_11 ) / 1000.0;
    if ( var_10 > var_12 && var_12 > var_7 )
    {
        var_13 = var_12 - var_7;

        if ( var_5 > var_13 )
        {
            var_5 = var_13;
            var_9 = var_5 + var_6;
            var_10 = var_5 + var_7;
        }
    }

    var_14 = spawnstruct();
    var_14._id_37F1 = var_5;
    var_14._id_D6F8 = var_6;
    var_14._id_A63E = var_9;
    var_14.killcamoffset = var_10;
    return var_14;
}

_id_10855()
{
    self endon( "disconnect" );
    self endon( "killcam_ended" );
    self waittill( "spawned" );
    thread _id_A639( 0 );
}

_id_6315()
{
    self endon( "disconnect" );
    self endon( "killcam_ended" );
    level waittill( "game_ended" );
    thread _id_A639( 1 );
}

waittillkillcamover()
{
    self endon( "abort_killcam" );

    wait( self.archivetime - 2.25 );

    if ( level.showingfinalkillcam )
    {
        setglobalsoundcontext( "atmosphere", "", 0.5 );
        self playlocalsound( "final_killcam_out" );
    }
}

_id_F8A0( var_0, var_1 )
{
    self endon( "disconnect" );

    if ( !isdefined( self._id_6AB3 ) )
        self._id_6AB3 = 0.0;

    if ( isdefined( var_1 ) )
        wait( var_1 );

    self notify( "setUIPostGameFade" );
    self endon( "setUIPostGameFade" );

    if ( self._id_6AB3 < var_0 )
        self._id_6AB3 = clamp( self._id_6AB3 + 0.5 * abs( self._id_6AB3 - var_0 ), 0.0, 1.0 );
    else
        self._id_6AB3 = clamp( self._id_6AB3 - 0.5 * abs( self._id_6AB3 - var_0 ), 0.0, 1.0 );

    self setclientomnvar( "ui_post_game_fade", self._id_6AB3 );
    wait 0.1;
    self._id_6AB3 = var_0;
    self setclientomnvar( "ui_post_game_fade", self._id_6AB3 );
}

_id_5854( var_0, var_1, var_2, var_3, var_4 )
{
    self endon( "killcam_ended" );
    
    wait self.archivetime - 5.65;

    soundsettimescalefactor( "music_lr", 0 );
    soundsettimescalefactor( "music_lsrs", 0 );
    soundsettimescalefactor( "voice_air_3d", 0 );
    soundsettimescalefactor( "voice_radio_3d", 0 );
    soundsettimescalefactor( "voice_radio_2d", 0 );
    soundsettimescalefactor( "voice_narration_2d", 0 );
    soundsettimescalefactor( "voice_special_2d", 0 );
    soundsettimescalefactor( "voice_bchatter_1_3d", 0 );
    soundsettimescalefactor( "plr_ui_ingame_unres_2d", 0 );
    soundsettimescalefactor( "weap_plr_fire_1_2d", 0.25 );
    soundsettimescalefactor( "weap_plr_fire_2_2d", 0.25 );
    soundsettimescalefactor( "weap_plr_fire_3_2d", 0.25 );
    soundsettimescalefactor( "weap_plr_fire_4_2d", 0.25 );
    soundsettimescalefactor( "weap_plr_fire_overlap_2d", 0.25 );
    soundsettimescalefactor( "weap_plr_fire_lfe_2d", 0 );
    soundsettimescalefactor( "weap_plr_fire_alt_1_2d", 0.25 );
    soundsettimescalefactor( "weap_plr_fire_alt_2_2d", 0.25 );
    soundsettimescalefactor( "weap_plr_fire_alt_3_2d", 0.25 );
    soundsettimescalefactor( "weap_plr_fire_alt_4_2d", 0.25 );
    soundsettimescalefactor( "reload_plr_res_2d", 0.3 );
    soundsettimescalefactor( "reload_plr_unres_2d", 0.3 );
    soundsettimescalefactor( "hurt_nofilter_2d", 0.15 );
    soundsettimescalefactor( "scn_fx_unres_3d", 0.15 );
    soundsettimescalefactor( "scn_lfe_unres_2d", 0 );
    soundsettimescalefactor( "scn_lfe_unres_3d", 0 );
    soundsettimescalefactor( "scn_fx_unres_2d", 0.15 );
    soundsettimescalefactor( "spear_refl_close_unres_3d_lim", 0.15 );
    soundsettimescalefactor( "spear_refl_unres_3d_lim", 0.15 );
    soundsettimescalefactor( "weap_npc_main_3d", 0.25 );
    soundsettimescalefactor( "weap_npc_mech_3d", 0.25 );
    soundsettimescalefactor( "weap_npc_mid_3d", 0.25 );
    soundsettimescalefactor( "weap_npc_lfe_3d", 0 );
    soundsettimescalefactor( "weap_npc_dist_3d", 0.25 );
    soundsettimescalefactor( "weap_npc_lo_3d", 0.25 );
    soundsettimescalefactor( "melee_npc_3d", 0.25 );
    soundsettimescalefactor( "melee_plr_2d", 0.25 );
    soundsettimescalefactor( "special_hi_unres_1_3d", 0.15 );
    soundsettimescalefactor( "special_lo_unres_1_2d", 0 );
    soundsettimescalefactor( "bulletflesh_npc_1_unres_3d_lim", 0.15 );
    soundsettimescalefactor( "bulletflesh_npc_2_unres_3d_lim", 0.15 );
    soundsettimescalefactor( "bulletflesh_1_unres_3d_lim", 0.15 );
    soundsettimescalefactor( "bulletflesh_2_unres_3d_lim", 0.15 );
    soundsettimescalefactor( "foley_plr_mvmt_unres_2d_lim", 0.2 );
    soundsettimescalefactor( "scn_fx_unres_2d_lim", 0.2 );
    soundsettimescalefactor( "menu_1_2d_lim", 0 );
    soundsettimescalefactor( "equip_use_unres_3d", 0.15 );
    soundsettimescalefactor( "shock1_nofilter_3d", 0.15 );
    soundsettimescalefactor( "explo_1_3d", 0.15 );
    soundsettimescalefactor( "explo_2_3d", 0.15 );
    soundsettimescalefactor( "explo_3_3d", 0.15 );
    soundsettimescalefactor( "explo_4_3d", 0.15 );
    soundsettimescalefactor( "explo_5_3d", 0.15 );
    soundsettimescalefactor( "explo_lfe_3d", 0.15 );
    soundsettimescalefactor( "vehicle_air_loops_3d_lim", 0.15 );
    soundsettimescalefactor( "projectile_loop_close", 0.15 );
    soundsettimescalefactor( "projectile_loop_mid", 0.15 );
    soundsettimescalefactor( "projectile_loop_dist", 0.15 );
    setslowmotion( 1.0, 0.25, 1 );
    wait( 1.5 );
    setslowmotion( 0.25, 1, 1 );
    resetsoundtimescalefactor();
    level._id_58D8 = undefined;
}

resetsoundtimescalefactor()
{
    soundsettimescalefactor( "music_lr", 0 );
    soundsettimescalefactor( "music_lsrs", 0 );
    soundsettimescalefactor( "weap_plr_fire_1_2d", 0 );
    soundsettimescalefactor( "weap_plr_fire_2_2d", 0 );
    soundsettimescalefactor( "weap_plr_fire_3_2d", 0 );
    soundsettimescalefactor( "weap_plr_fire_4_2d", 0 );
    soundsettimescalefactor( "weap_plr_fire_overlap_2d", 0 );
    soundsettimescalefactor( "weap_plr_fire_lfe_2d", 0 );
    soundsettimescalefactor( "weap_plr_fire_alt_1_2d", 0 );
    soundsettimescalefactor( "weap_plr_fire_alt_2_2d", 0 );
    soundsettimescalefactor( "weap_plr_fire_alt_3_2d", 0 );
    soundsettimescalefactor( "weap_plr_fire_alt_4_2d", 0 );
    soundsettimescalefactor( "scn_fx_unres_3d", 0 );
    soundsettimescalefactor( "scn_fx_unres_2d", 0 );
    soundsettimescalefactor( "spear_refl_close_unres_3d_lim", 0 );
    soundsettimescalefactor( "spear_refl_unres_3d_lim", 0 );
    soundsettimescalefactor( "weap_npc_main_3d", 0 );
    soundsettimescalefactor( "weap_npc_mech_3d", 0 );
    soundsettimescalefactor( "weap_npc_mid_3d", 0 );
    soundsettimescalefactor( "weap_npc_lfe_3d", 0 );
    soundsettimescalefactor( "weap_npc_dist_3d", 0 );
    soundsettimescalefactor( "weap_npc_lo_3d", 0 );
    soundsettimescalefactor( "melee_npc_3d", 0 );
    soundsettimescalefactor( "melee_plr_2d", 0 );
    soundsettimescalefactor( "special_hi_unres_1_3d", 0 );
    soundsettimescalefactor( "special_lo_unres_1_2d", 0 );
    soundsettimescalefactor( "bulletflesh_npc_1_unres_3d_lim", 0 );
    soundsettimescalefactor( "bulletflesh_npc_2_unres_3d_lim", 0 );
    soundsettimescalefactor( "bulletflesh_1_unres_3d_lim", 0 );
    soundsettimescalefactor( "bulletflesh_2_unres_3d_lim", 0 );
    soundsettimescalefactor( "foley_plr_mvmt_unres_2d_lim", 0 );
    soundsettimescalefactor( "scn_fx_unres_2d_lim", 0 );
    soundsettimescalefactor( "menu_1_2d_lim", 0 );
    soundsettimescalefactor( "equip_use_unres_3d", 0 );
    soundsettimescalefactor( "explo_1_3d", 0 );
    soundsettimescalefactor( "explo_2_3d", 0 );
    soundsettimescalefactor( "explo_3_3d", 0 );
    soundsettimescalefactor( "explo_4_3d", 0 );
    soundsettimescalefactor( "explo_5_3d", 0 );
    soundsettimescalefactor( "explo_lfe_3d", 0 );
    soundsettimescalefactor( "vehicle_air_loops_3d_lim", 0 );
    soundsettimescalefactor( "projectile_loop_close", 0 );
    soundsettimescalefactor( "projectile_loop_mid", 0 );
    soundsettimescalefactor( "projectile_loop_dist", 0 );
}

_id_F76B( var_0, var_1, var_2, var_3, var_4 )
{
    self endon( "disconnect" );
    self endon( "killcam_ended" );
    var_5 = gettime() - var_1 * 1000;

    if ( var_2 > var_5 )
    {
        wait 0.05;
        var_1 = self.archivetime;
        var_5 = gettime() - var_1 * 1000;

        if ( var_2 > var_5 )
            wait( ( var_2 - var_5 ) / 1000 );
    }

    self.killcamentity = var_0;

    if ( isdefined( var_3 ) )
        self.killcamentitylookat = var_3;

    if ( isdefined( var_4 ) )
        self _meth_85C4( var_4 );
}

get_perk_machine_cost()
{
    return 0;
}

create_killcam_timer( time )
{
    var_12 = self scripts\cp\utility::createfontstring( "default", 1 );
    var_12.hidewheninmenu = 1;
    var_12.archived = 1;
    var_12.sort = 666;
    var_12.alpha = 1;
    var_12.color = (1, 1, 1);
    var_12.foreground = 1;

    var_12 scripts\cp\utility::setpoint( "CENTER", "CENTER", 86, -70 );
    var_12 set_text("");
    var_12 settimer( time );
}

void() {}