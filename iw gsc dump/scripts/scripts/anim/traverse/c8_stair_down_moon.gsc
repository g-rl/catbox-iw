/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\anim\traverse\c8_stair_down_moon.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 1
 * Decompile Time: 73 ms
 * Timestamp: 10\26\2023 11:59:22 PM
*******************************************************************/

//Function Number: 1
main()
{
	self endon("death");
	self endon("terminate_ai_threads");
	var_00 = %c8_grnd_org_traversals_moon_stair_down;
	var_01 = 0.2;
	self animmode("noclip");
	var_02 = self getspectatepoint();
	self orientmode("face angle",var_02.angles[1]);
	self aiclearanim(lib_0A1E::asm_getbodyknob(),var_01);
	self _meth_82E7("traverse_external",var_00,1,var_01,1);
	lib_0A1E::func_231F("c8","traverse_external");
	lib_0C6B::func_11701("c8","traverse_external");
}