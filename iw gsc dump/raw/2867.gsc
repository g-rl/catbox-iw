/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 2867.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 1
 * Decompile Time: 0 ms
 * Timestamp: 10/27/2023 12:24:21 AM
*******************************************************************/

//Function Number: 1
func_95F3()
{
	scripts\engine\utility::add_func_ref_MAYBE("setsaveddvar",::function_01C5);
	scripts\engine\utility::add_func_ref_MAYBE("useanimtree",::glinton);
	scripts\engine\utility::add_func_ref_MAYBE("setanim",::give_attacker_kill_rewards);
	scripts\engine\utility::add_func_ref_MAYBE("setanimknob",::setanimknob);
	scripts\engine\utility::add_func_ref_MAYBE("setflaggedanimknob",::give_left_powers);
	scripts\engine\utility::add_func_ref_MAYBE("setflaggedanimknobrestart",::_meth_82E7);
	scripts\engine\utility::add_func_ref_MAYBE("setanimlimited",::_meth_82AC);
	scripts\engine\utility::add_func_ref_MAYBE("setanimtime",::_meth_82B0);
	scripts\engine\utility::add_func_ref_MAYBE("getanimtime",::getscoreinfocategory);
	scripts\engine\utility::add_func_ref_MAYBE("getanimlength",::getanimlength);
	scripts\engine\utility::add_func_ref_MAYBE("clearanim",::aiclearanim);
	scripts\engine\utility::add_func_ref_MAYBE("kill",::_meth_81D0);
	scripts\engine\utility::add_func_ref_MAYBE("magicgrenade",::function_0135);
	scripts\engine\utility::add_func_ref_MAYBE("connectPaths",::connectpaths);
	scripts\engine\utility::add_func_ref_MAYBE("disconnectPaths",::disconnectpaths);
	scripts\engine\utility::add_func_ref_MAYBE("makeEntitySentient",::makeentitysentient);
	scripts\engine\utility::add_func_ref_MAYBE("laserForceOn",::_meth_81D6);
	scripts\engine\utility::add_func_ref_MAYBE("laserForceOff",::_meth_81D5);
	scripts\engine\utility::add_func_ref_MAYBE("badPlaceDelete",::badplace_delete);
	scripts\engine\utility::add_func_ref_MAYBE("badPlaceCylinder",::badplace_cylinder);
	scripts\engine\utility::add_func_ref_MAYBE("freeEntitySentient",::freeentitysentient);
	scripts\engine\utility::add_func_ref_MAYBE("stat_track_kill_func",::_meth_81D5);
	scripts\engine\utility::add_func_ref_MAYBE("laserForceOff",::_meth_81D5);
	scripts\engine\utility::add_func_ref_MAYBE("getspawner",::getspawner);
	level.var_5A5E = 1;
	level.var_2681 = 1;
	level.getnodefunction = ::function_00B3;
	level.getnodearrayfunction = ::function_00B4;
	level.var_179C = ::getnodeyawfromoffsettable;
	level._meth_8134 = ::function_00C8;
}