/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: aitype\ally_equipment_seeker.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 3
 * Decompile Time: 148 ms
 * Timestamp: 10\26\2023 11:58:12 PM
*******************************************************************/

//Function Number: 1
main()
{
	self.var_17DB = "ai//seeker_assets.csv";
	self.team = "allies";
	self.type = "human";
	self.unittype = "seeker";
	self.subclass = "regular";
	self.accuracy = 0.2;
	self.health = 200;
	self.objective_team = "";
	self.objective_state = 0;
	self.secondaryweapon = "";
	self.var_101B4 = "";
	self.behaviortreeasset = "seeker";
	self.var_1FA9 = "seeker";
	if(isai(self))
	{
		self _meth_82DC(50,0);
		self _meth_82DB(50,1024);
	}

	self.var_394 = "none";
	lib_0920::main();
}

//Function Number: 2
spawner()
{
	self _meth_833A("allies");
}

//Function Number: 3
precache()
{
	lib_0920::precache();
	scripts\aitypes\bt_util::init();
	lib_09FD::func_F10A();
	lib_03B0::func_DEE8();
	lib_0C54::func_2371();
}