/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: aitype\ally_mdf_ar_male.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 3
 * Decompile Time: 141 ms
 * Timestamp: 10\26\2023 11:58:13 PM
*******************************************************************/

//Function Number: 1
main()
{
	self.var_17DB = "";
	self.team = "allies";
	self.type = "human";
	self.unittype = "soldier";
	self.subclass = "MDF";
	self.accuracy = 0.2;
	self.health = 150;
	self.objective_team = lib_0A2F::func_7BEB();
	self.objective_state = 1;
	self.secondaryweapon = "";
	self.var_101B4 = "";
	self.behaviortreeasset = "enemy_combatant";
	self.var_1FA9 = "soldier";
	if(isai(self))
	{
		self _meth_82DC(256,0);
		self _meth_82DB(768,1024);
	}

	self.var_394 = lib_0A2F::func_7BEC("rifle");
	lib_08C2::main();
}

//Function Number: 2
spawner()
{
	self _meth_833A("allies");
}

//Function Number: 3
precache()
{
	lib_08C2::precache();
	scripts\aitypes\bt_util::init();
	lib_09FD::soldier();
	lib_03AE::func_DEE8();
	lib_0C69::func_2371();
}