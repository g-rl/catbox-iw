/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\anim\traverse\jump_up_80.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 1
 * Decompile Time: 72 ms
 * Timestamp: 10\26\2023 11:59:28 PM
*******************************************************************/

//Function Number: 1
main()
{
	self endon("killanimscript");
	self _meth_83C4("nogravity");
	self _meth_83C4("noclip");
	var_00 = self getspectatepoint();
	self orientmode("face angle",var_00.angles[1]);
	var_01 = var_00.var_126D4 - var_00.origin[2];
	thread scripts\anim\traverse\shared::func_11661(var_01 - 80);
	self aiclearanim(%root,0.2);
	self _meth_82EA("jump_up_80",level.var_58C7["jump_up_80"],1,0.2,1);
	scripts\anim\shared::donotetracks("jump_up_80");
}