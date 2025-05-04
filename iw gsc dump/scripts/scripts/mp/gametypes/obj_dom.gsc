/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\gametypes\obj_dom.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 19
 * Decompile Time: 1006 ms
 * Timestamp: 10/27/2023 12:12:56 AM
*******************************************************************/

//Function Number: 1
func_591D(param_00)
{
	var_01 = level.objectives[param_00];
	if(isdefined(var_01.target))
	{
		var_02[0] = getent(var_01.target,"targetname");
	}
	else
	{
		param_00[0] = spawn("script_model",var_02.origin);
		var_02[0].angles = var_01.angles;
	}

	level.flagcapturetime = scripts\mp\_utility::dvarfloatvalue("flagCaptureTime",10,0,30);
	var_03 = scripts\mp\_gameobjects::createuseobject("neutral",var_01,var_02,(0,0,100));
	var_03 scripts\mp\_gameobjects::allowuse("enemy");
	var_03 scripts\mp\_gameobjects::cancontestclaim(1);
	var_03 scripts\mp\_gameobjects::setusetime(level.flagcapturetime);
	var_03 scripts\mp\_gameobjects::setusetext(&"MP_SECURING_POSITION");
	var_04 = var_03 scripts\mp\_gameobjects::getlabel();
	var_03.label = var_04;
	var_03 scripts\mp\_gameobjects::setzonestatusicons(level.icondefend + var_04,level.iconneutral + var_04);
	var_03 scripts\mp\_gameobjects::setvisibleteam("any");
	var_03.onuse = ::dompoint_onuse;
	var_03.onbeginuse = ::dompoint_onusebegin;
	var_03.onuseupdate = ::dompoint_onuseupdate;
	var_03.onenduse = ::dompoint_onuseend;
	var_03.oncontested = ::dompoint_oncontested;
	var_03.onuncontested = ::dompoint_onuncontested;
	var_03.nousebar = 1;
	var_03.id = "domFlag";
	var_03.claimgracetime = level.flagcapturetime * 1000;
	var_03.firstcapture = 1;
	var_05 = var_02[0].origin + (0,0,32);
	var_06 = var_02[0].origin + (0,0,-32);
	var_07 = scripts\common\trace::create_contents(1,1,1,1,0,1,1);
	var_08 = [];
	var_09 = scripts\common\trace::ray_trace(var_05,var_06,var_08,var_07);
	var_0A = checkmapoffsets(var_03.label);
	var_03.baseeffectpos = var_09["position"] + var_0A;
	var_0B = vectortoangles(var_09["normal"]);
	var_0C = checkmapfxangles(var_03.label,var_0B);
	var_03.baseeffectforward = anglestoforward(var_0C);
	var_0D = spawn("script_model",var_03.baseeffectpos);
	var_0D setmodel("dom_flag_scriptable");
	var_0D.angles = function_02D7(var_03.baseeffectforward,var_0D.angles);
	var_03.physics_capsulecast = var_0D;
	var_03.vfxnamemod = "";
	if(var_03.trigger.fgetarg == 160)
	{
		var_03.vfxnamemod = "_160";
	}
	else if(var_03.trigger.fgetarg == 90)
	{
		var_03.vfxnamemod = "_90";
	}

	var_03 initializematchrecording();
	var_03 scripts\engine\utility::delaythread(1,::domflag_setneutral);
	return var_03;
}

//Function Number: 2
checkmapoffsets(param_00)
{
	var_01 = (0,0,0);
	if(level.mapname == "mp_quarry")
	{
		if(param_00 == "_c")
		{
			var_01 = var_01 + (0,0,7);
		}
	}

	if(level.mapname == "mp_divide")
	{
		if(param_00 == "_a")
		{
			var_01 = var_01 + (0,0,4.5);
		}
	}

	if(level.mapname == "mp_afghan")
	{
		if(param_00 == "_a")
		{
			var_01 = var_01 + (0,0,5);
		}

		if(param_00 == "_c")
		{
			var_01 = var_01 + (0,0,1);
		}
	}

	return var_01;
}

//Function Number: 3
checkmapfxangles(param_00,param_01)
{
	var_02 = param_01;
	if(level.mapname == "mp_quarry")
	{
		if(param_00 == "_c")
		{
			var_02 = (276.5,var_02[1],var_02[2]);
		}
	}

	if(level.mapname == "mp_divide")
	{
		if(param_00 == "_a")
		{
			var_02 = (273.5,var_02[1],var_02[2]);
		}
	}

	if(level.mapname == "mp_afghan")
	{
		if(param_00 == "_a")
		{
			var_02 = (273.5,200.5,var_02[2]);
		}

		if(param_00 == "_c")
		{
			var_02 = (273.5,var_02[1],var_02[2]);
		}
	}

	return var_02;
}

//Function Number: 4
initializematchrecording()
{
	if(isdefined(level.matchrecording_logevent))
	{
		self.logid = [[ level.matchrecording_generateid ]]();
		var_00 = "A";
		switch(self.label)
		{
			case "_a":
				var_00 = "A";
				break;

			case "_b":
				var_00 = "B";
				break;

			case "_c":
				var_00 = "C";
				break;

			default:
				break;
		}

		self.logeventflag = "FLAG_" + var_00;
	}

	if(scripts\mp\_analyticslog::analyticslogenabled())
	{
		self.analyticslogid = scripts\mp\_analyticslog::getuniqueobjectid();
		self.analyticslogtype = "dom_flag" + self.label;
	}
}

//Function Number: 5
domflag_setneutral(param_00)
{
	self notify("flag_neutral");
	scripts\mp\_gameobjects::setownerteam("neutral");
	scripts\mp\_gameobjects::setzonestatusicons(level.iconneutral + self.label);
	updateflagstate("idle",param_00);
	if(isdefined(level.matchrecording_logevent) && isdefined(self.logid) && isdefined(self.logeventflag))
	{
		[[ level.matchrecording_logevent ]](self.logid,undefined,self.logeventflag,self.visuals[0].origin[0],self.visuals[0].origin[1],gettime(),0);
	}

	scripts\mp\_analyticslog::logevent_gameobject(self.analyticslogtype,self.analyticslogid,self.visuals[0].origin,-1,"neutral");
}

//Function Number: 6
dompoint_setcaptured(param_00)
{
	scripts\mp\_gameobjects::setownerteam(param_00);
	scripts\mp\_gameobjects::setzonestatusicons(level.icondefend + self.label,level.iconcapture + self.label);
	self.neutralized = 0;
	updateflagstate(param_00,0);
	if(isdefined(level.matchrecording_logevent))
	{
		[[ level.matchrecording_logevent ]](self.logid,undefined,self.logeventflag,self.visuals[0].origin[0],self.visuals[0].origin[1],gettime(),scripts\engine\utility::ter_op(param_00 == "allies",1,2));
	}

	scripts\mp\_analyticslog::logevent_gameobject(self.analyticslogtype,self.analyticslogid,self.visuals[0].origin,-1,"captured_" + param_00);
}

//Function Number: 7
dompoint_onuse(param_00)
{
	var_01 = param_00.team;
	var_02 = scripts\mp\_gameobjects::getownerteam();
	self.capturetime = gettime();
	self.neutralized = 0;
	if(level.flagneutralization)
	{
		var_03 = scripts\mp\_gameobjects::getownerteam();
		if(var_03 == "neutral")
		{
			dompoint_setcaptured(var_01);
		}
		else
		{
			thread domflag_setneutral(1);
			scripts\mp\_utility::playsoundonplayers("mp_dom_flag_lost",var_03);
			level.lastcaptime = gettime();
			thread giveflagassistedcapturepoints(self.touchlist[var_01]);
			self.neutralized = 1;
		}
	}
	else
	{
		dompoint_setcaptured(var_01);
	}

	if(!self.neutralized)
	{
		var_04 = 3;
		if(self.label == "_a")
		{
			var_04 = 1;
		}
		else if(self.label == "_b")
		{
			var_04 = 2;
		}

		scripts\mp\_utility::setmlgannouncement(19,var_01,param_00 getentitynumber(),var_04);
		if(isdefined(level.onobjectivecomplete))
		{
			[[ level.onobjectivecomplete ]]("dompoint",self.label,param_00,var_01,var_02,self);
		}

		self.firstcapture = 0;
	}
}

//Function Number: 8
dompoint_onusebegin(param_00)
{
	var_01 = scripts\mp\_gameobjects::getownerteam();
	self.neutralizing = level.flagneutralization && var_01 != "neutral";
	if(!scripts\mp\_utility::istrue(self.neutralized))
	{
		self.didstatusnotify = 0;
	}

	var_02 = scripts\engine\utility::ter_op(level.flagneutralization,level.flagcapturetime * 0.5,level.flagcapturetime);
	scripts\mp\_gameobjects::setusetime(var_02);
	thread scripts\mp\_gameobjects::useobjectdecay(param_00.team);
	if(var_02 > 0)
	{
		self.prevownerteam = level.otherteam[param_00.team];
		updateflagcapturestate(param_00.team);
		scripts\mp\_gameobjects::setzonestatusicons(level.iconlosing + self.label,level.icontaking + self.label);
	}
}

//Function Number: 9
dompoint_onuseupdate(param_00,param_01,param_02,param_03)
{
	var_04 = scripts\mp\_gameobjects::getownerteam();
	if(param_01 > 0.05 && param_02 && !self.didstatusnotify)
	{
		if(var_04 == "neutral")
		{
			if(level.flagcapturetime > 0.05)
			{
				scripts\mp\_utility::statusdialog("securing" + self.label,param_00);
			}
		}
		else if(level.flagcapturetime > 0.05)
		{
			scripts\mp\_utility::statusdialog("losing" + self.label,var_04,1);
			scripts\mp\_utility::statusdialog("securing" + self.label,param_00);
		}

		self.didstatusnotify = 1;
	}
}

//Function Number: 10
dompoint_onuseend(param_00,param_01,param_02)
{
	if(isplayer(param_01))
	{
		param_01 setclientomnvar("ui_objective_state",0);
		param_01.ui_dom_securing = undefined;
	}

	var_03 = scripts\mp\_gameobjects::getownerteam();
	if(var_03 == "neutral")
	{
		scripts\mp\_gameobjects::setzonestatusicons(level.iconneutral + self.label);
		updateflagstate("idle",0);
	}
	else
	{
		scripts\mp\_gameobjects::setzonestatusicons(level.icondefend + self.label,level.iconcapture + self.label);
		updateflagstate(var_03,0);
	}

	if(!param_02)
	{
		self.neutralized = 0;
	}
}

//Function Number: 11
dompoint_oncontested()
{
	scripts\mp\_gameobjects::setzonestatusicons(level.iconcontested + self.label);
	updateflagstate("contested",0);
}

//Function Number: 12
dompoint_onuncontested(param_00)
{
	var_01 = scripts\mp\_gameobjects::getownerteam();
	if(param_00 == "none" || var_01 == "neutral")
	{
		scripts\mp\_gameobjects::setzonestatusicons(level.iconneutral + self.label);
		self.didstatusnotify = 0;
	}
	else
	{
		scripts\mp\_gameobjects::setzonestatusicons(level.icondefend + self.label,level.iconcapture + self.label);
	}

	var_02 = scripts\engine\utility::ter_op(var_01 == "neutral","idle",var_01);
	updateflagstate(var_02,0);
}

//Function Number: 13
setcrankedtimerdomflag(param_00)
{
	if(isdefined(level.supportcranked) && level.supportcranked && isdefined(param_00.cranked) && param_00.cranked)
	{
		param_00 scripts\mp\_utility::setcrankedplayerbombtimer("assist");
	}
}

//Function Number: 14
dompoint_setupflagmodels()
{
	game["flagmodels"] = [];
	game["flagmodels"]["neutral"] = "prop_flag_neutral";
	game["flagmodels"]["allies"] = scripts\mp\_teams::ismeleeing("allies");
	game["flagmodels"]["axis"] = scripts\mp\_teams::ismeleeing("axis");
}

//Function Number: 15
updateflagstate(param_00,param_01)
{
	self.physics_capsulecast setscriptablepartstate("flag",param_00 + self.vfxnamemod);
	if(!scripts\mp\_utility::istrue(param_01))
	{
		self.physics_capsulecast setscriptablepartstate("pulse","off");
	}
}

//Function Number: 16
updateflagcapturestate(param_00)
{
	self.physics_capsulecast setscriptablepartstate("pulse",param_00 + self.vfxnamemod);
}

//Function Number: 17
onplayerconnect()
{
	for(;;)
	{
		level waittill("connected",var_00);
		var_00._domflageffect = [];
		var_00._domflagpulseeffect = [];
		var_00 thread ondisconnect();
	}
}

//Function Number: 18
ondisconnect()
{
	self waittill("disconnect");
	foreach(var_01 in self._domflageffect)
	{
		if(isdefined(var_01))
		{
			var_01 delete();
		}
	}

	foreach(var_04 in self._domflagpulseeffect)
	{
		if(isdefined(var_04))
		{
			var_04 delete();
		}
	}
}

//Function Number: 19
giveflagassistedcapturepoints(param_00)
{
	level endon("game_ended");
	var_01 = getarraykeys(param_00);
	for(var_02 = 0;var_02 < var_01.size;var_02++)
	{
		var_03 = param_00[var_01[var_02]].player;
		if(!isdefined(var_03))
		{
			continue;
		}

		if(isdefined(var_03.triggerportableradarping))
		{
			var_03 = var_03.triggerportableradarping;
		}

		if(!isplayer(var_03))
		{
			continue;
		}

		var_03 thread scripts\mp\_awards::givemidmatchaward("mode_dom_neutralized");
		var_03 setclientomnvar("ui_objective_progress",0.01);
		var_03 setcrankedtimerdomflag(var_03);
		wait(0.05);
	}
}