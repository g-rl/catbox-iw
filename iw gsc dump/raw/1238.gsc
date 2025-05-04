/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 1238.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 2
 * Decompile Time: 1 ms
 * Timestamp: 10/27/2023 12:23:15 AM
*******************************************************************/

//Function Number: 1
main()
{
	self setmodel("body_sdf_army_ftl_1");
	scripts\code\character::attachhead("alias_heads_sdf_army_bloody",lib_09C2::main());
	self.hatmodel = "head_sdf_army_ftl_1";
	self attach(self.hatmodel);
	self.var_1FEC = "generic_human";
	self.var_1FA8 = "soldier";
	self.voice = "setdef";
	self give_explosive_touch_on_revived("vestlight");
	if(issentient(self))
	{
		self sethitlocdamagetable("locdmgtable/ai_lochit_dmgtable");
	}

	self.var_8E1A = level.var_7649["iw7/prop/vfx_sdf_army_ftl_helmet_split"];
	if(issentient(self))
	{
		self _meth_849A();
		var_00 = [];
		var_00["helmet"] = spawnstruct();
		var_00["helmet"].var_B4B8 = 9999;
		var_00["helmet"].partnerheli = [];
		var_00["helmet"].partnerheli["helmet"] = spawnstruct();
		var_00["helmet"].partnerheli["helmet"].maxhealth = 50;
		var_00["helmet"].partnerheli["helmet"].hitloc = "helmet";
		var_00["helmet"].partnerheli["helmet"].var_4D6F = "j_helmet";
		self _meth_849B("helmet",9999,"helmet",50,"helmet","j_helmet");
		self.var_4D5D = var_00;
	}

	self glinton(#animtree);
}

//Function Number: 2
precache()
{
	precachemodel("body_sdf_army_ftl_1");
	scripts\code\character::precachemodelarray(lib_09C2::main());
	precachemodel("head_sdf_army_ftl_1");
	level.var_7649["iw7/prop/vfx_sdf_army_ftl_helmet_split"] = loadfx("vfx/iw7/prop/vfx_sdf_army_ftl_helmet_split.vfx");
}