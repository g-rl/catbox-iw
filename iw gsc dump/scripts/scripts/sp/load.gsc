/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\sp\load.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 1
 * Decompile Time: 45 ms
 * Timestamp: 10/27/2023 12:24:41 AM
*******************************************************************/

//Function Number: 1
main()
{
	lib_0A2F::func_9789();
	scripts\sp\_utility::func_965C();
	lib_0B33::func_95F3();
	lib_0B2F::func_9752();
	scripts\sp\_gameskill::func_95F9();
	lib_0F18::func_956A();
	scripts\sp\_introscreen::func_9631();
	scripts/sp/starts::func_9766();
	if(scripts\sp\_utility::func_93A6())
	{
		scripts/sp/specialist_MAYBE::init();
	}

	scripts/sp/load_code::vehicle_getspeed();
	scripts/sp/load_code::vehicle_finishdamage();
	scripts/sp/load_code::_meth_83D5();
	scripts\engine\utility::init_trigger_flags();
	scripts\engine\utility::struct_class_init();
	scripts\sp\_colors::init_colors();
	lib_0B5F::func_96D7();
	scripts\sp\_mgturret::main();
	scripts\common\exploder::setupexploders();
	scripts/sp/pausemenu::main();
	scripts\sp\_art::main();
	scripts/sp/anim::init();
	scripts\common\fx::initfx();
	scripts\sp\_createfx::createfx();
	scripts\sp\_global_fx::main();
	scripts\sp\_detonategrenades::init();
	scripts\sp\_stinger::init();
	scripts\sp\_lights::init();
	scripts\engine\utility::func_D959();
	scripts\sp\_names::func_F9E6();
	scripts\sp\_audio::init_audio();
	scripts\sp\_trigger::func_9726();
	function_01C5("ufoHitsTriggers","0");
	scripts\sp\_hud::init();
	scripts/sp/vision::func_979C();
	scripts\sp\_endmission::main();
	lib_0E2B::func_C32F();
	lib_0E2D::func_112B5();
	lib_0E26::func_972B();
	lib_0E25::func_95C4();
	scripts\sp\_vehicle::func_979A();
	lib_0B29::init();
	lib_0E21::func_9527();
	lib_0E29::func_8829();
	lib_0B2A::func_66A1();
	scripts\sp\_coverwall::func_4761();
	precacheitem("frag_up1");
	precacheitem("frag_c6hug");
	lib_0E4B::func_D5E3();
	scripts/sp/starts::func_57C6();
	scripts\engine\utility::func_C953();
	scripts\sp\_autosave::main();
	anim.var_13086 = 0;
	scripts/sp/load_code::func_F7C2();
	scripts\sp\_introscreen::main();
	scripts\sp\_damagefeedback::init();
	scripts\sp\_friendlyfire::main();
	if(getdvarint("ai_iw7",0) == 1)
	{
		scripts/asm/asm::asm_globalinit();
		scripts/aitypes/bt_util::init();
	}

	scripts/sp/fakeactor_node_MAYBE::func_F97C();
	scripts/sp/load_code::func_51C4();
	scripts\anim\traverse\shared::func_F9C6();
	lib_0B04::func_94F9();
	scripts\sp\_intelligence::main();
	lib_0E44::func_952C();
	scripts\sp\_dooruse::func_95B6();
	lib_0E20::func_DE0F();
	lib_0E1F::func_6137();
	lib_0E1C::func_200A();
	lib_0E1E::func_5374();
	scripts\sp\_armoury::func_952F();
	scripts\sp\_utility::func_9674();
	if(isdefined(level._meth_83DF))
	{
		[[ level._meth_83DF ]]();
	}

	scripts/sp/load_code::func_B3CD();
	lib_0B77::main();
	scripts\sp\_utility::func_48C1();
	lib_0B34::func_95F7();
	scripts/sp/interaction_manager::func_9A2F();
	thread scripts/sp/geo_mover::func_409C();
	if(scripts\sp\_utility::func_93A6())
	{
		if(scripts/sp/specialist_MAYBE::func_2C8F())
		{
			scripts/sp/specialist_MAYBE::func_F2D2(1);
		}
		else
		{
			level.var_10964 thread scripts/sp/specialist_MAYBE::main();
		}
	}

	scripts/sp/load_code::func_E810();
	function_0305(scripts\sp\_utility::func_7F6E(level.script));
	var_00 = scripts\sp\_utility::func_7E2C(level.script);
	setomnvar("ui_client_settle_time",var_00);
	var_01 = scripts\sp\_utility::func_7F70(level.script);
	if(isdefined(var_01) && var_01 != "")
	{
		setomnvar("ui_transition_movie",var_01);
	}
	else
	{
		setomnvar("ui_transition_movie","none");
	}

	scripts/sp/analytics::main();
}