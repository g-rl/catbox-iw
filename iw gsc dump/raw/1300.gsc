/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 1300.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 2
 * Decompile Time: 1 ms
 * Timestamp: 10/27/2023 12:23:16 AM
*******************************************************************/

//Function Number: 1
main()
{
	self setmodel("body_sdf_army_light_3_cpt3");
	self attach("head_sc_chaplain_default","",1);
	self.headmodel = "head_sc_chaplain_default";
	self.hatmodel = "head_sdf_kotch_helmet";
	self attach(self.hatmodel);
	self.var_A489 = "sdf_army_boost_pack_zerog";
	self attach(self.var_A489);
	self.var_1FEC = "generic_human";
	self.var_1FA8 = "soldier";
	self.voice = "setdef";
	self give_explosive_touch_on_revived("vestheavy");
	if(issentient(self))
	{
		self sethitlocdamagetable("locdmgtable/ai_lochit_dmgtable");
	}

	self glinton(#animtree);
}

//Function Number: 2
precache()
{
	precachemodel("body_sdf_army_light_3_cpt3");
	precachemodel("head_sc_chaplain_default");
	precachemodel("head_sdf_kotch_helmet");
	precachemodel("sdf_army_boost_pack_zerog");
}