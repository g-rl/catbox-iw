#include scripts\engine\utility;
#include scripts\cp\utility;
#include scripts\cp\cp_hud_util;
#include custom_scripts\func;
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

void() {}