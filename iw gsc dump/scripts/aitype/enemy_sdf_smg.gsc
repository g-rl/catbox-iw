/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: aitype\enemy_sdf_smg.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 3
 * Decompile Time: 136 ms
 * Timestamp: 10\26\2023 11:58:17 PM
*******************************************************************/

//Function Number: 1
main()
{
	self.var_17DB = "";
	self.team = "axis";
	self.type = "human";
	self.unittype = "soldier";
	self.subclass = "regular";
	self.accuracy = 0.2;
	self.health = 150;
	self.objective_team = lib_0A2F::func_7BEB();
	self.objective_state = 1;
	self.secondaryweapon = "";
	self.var_101B4 = lib_0A2F::func_7BEC("pistol");
	self.behaviortreeasset = "enemy_combatant";
	self.var_1FA9 = "soldier";
	if(isai(self))
	{
		self _meth_82DC(256,0);
		self _meth_82DB(768,1024);
	}

	self.var_394 = lib_0A2F::func_7BEC("smg");
	var_00 = undefined;
	var_01 = ["character_sdf_army_ftl_1","character_sdf_army_light_1","character_sdf_army_heavy_4"];
	switch(scripts\code\character::get_random_character(3,var_00,var_01))
	{
		case 0:
			lib_04D6::main();
			break;

		case 1:
			lib_04FF::main();
			break;

		case 2:
			lib_04EE::main();
			break;
	}
}

//Function Number: 2
spawner()
{
	self _meth_833A("axis");
}

//Function Number: 3
precache()
{
	lib_04D6::precache();
	lib_04FF::precache();
	lib_04EE::precache();
	scripts\aitypes\bt_util::init();
	lib_09FD::soldier();
	lib_03AE::func_DEE8();
	lib_0C69::func_2371();
}