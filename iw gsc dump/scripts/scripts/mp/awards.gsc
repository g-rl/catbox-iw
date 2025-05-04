/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\awards.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 20
 * Decompile Time: 1048 ms
 * Timestamp: 10/27/2023 12:14:29 AM
*******************************************************************/

//Function Number: 1
init()
{
	initawards();
	level thread onplayerconnect();
	level.givemidmatchawardfunc = ::givemidmatchaward;
}

//Function Number: 2
onplayerconnect()
{
	for(;;)
	{
		level waittill("connected",var_00);
		var_00 thread onplayerspawned();
		var_00 thread initaarawardlist();
		var_00.awardqueue = [];
	}
}

//Function Number: 3
onplayerspawned()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("spawned_player");
		self.awardsthislife = [];
	}
}

//Function Number: 4
initawards()
{
	initmidmatchawards();
}

//Function Number: 5
initbaseaward(param_00,param_01)
{
	level.awards[param_00] = spawnstruct();
	level.awards[param_00].type = param_01;
	var_02 = tablelookup("mp/awardtable.csv",1,param_00,10);
	if(isdefined(var_02) && var_02 != "")
	{
		level.awards[param_00].xpscoreevent = var_02;
	}

	var_03 = tablelookup("mp/awardtable.csv",1,param_00,11);
	if(isdefined(var_03) && var_03 != "")
	{
		level.awards[param_00].gamescoreevent = var_03;
	}

	var_04 = tablelookup("mp/awardtable.csv",1,param_00,3);
	if(isdefined(var_04) && var_04 != "")
	{
		level.awards[param_00].category = var_04;
	}

	var_05 = tablelookup("mp/awardtable.csv",1,param_00,7);
	if(isdefined(var_05) && var_05 != "")
	{
		var_06 = randomfloat(1);
		level.awards[param_00].aarpriority = float(var_05) + var_06;
	}
}

//Function Number: 6
initbasemidmatchaward(param_00,param_01)
{
	initbaseaward(param_00,param_01);
}

//Function Number: 7
initmidmatchaward(param_00)
{
	initbasemidmatchaward(param_00,"midmatch");
}

//Function Number: 8
initmidmatchawards()
{
	var_00 = 0;
	for(;;)
	{
		var_01 = tablelookupbyrow("mp/awardtable.csv",var_00,1);
		if(!isdefined(var_01) || var_01 == "")
		{
			break;
		}

		var_02 = tablelookupbyrow("mp/awardtable.csv",var_00,9);
		if(isdefined(var_02) && var_02 != "")
		{
			initmidmatchaward(var_01);
		}

		level.awards[var_01].id = var_00;
		var_00++;
	}
}

//Function Number: 9
incplayerrecord(param_00)
{
	var_01 = self getplayerdata("common","awards",param_00);
	self setplayerdata("common","awards",param_00,var_01 + 1);
}

//Function Number: 10
giveaward(param_00,param_01,param_02)
{
	if(!isdefined(level.awards[param_00]))
	{
		return;
	}

	if(!function_02D9("mp","Awards",param_00))
	{
		return;
	}

	incplayerrecord(param_00);
	addawardtoaarlist(param_00);
	var_03 = level.awards[param_00].xpscoreevent;
	if(isdefined(var_03))
	{
		if(isdefined(param_02))
		{
			var_04 = param_02;
		}
		else
		{
			var_04 = scripts\mp\rank::getscoreinfovalue(var_04);
		}

		scripts\mp\rank::giverankxp(var_03,var_04);
	}

	var_05 = level.awards[param_00].gamescoreevent;
	if(isdefined(var_05))
	{
		scripts\mp\utility::giveunifiedpoints(var_05,undefined,param_01,undefined,undefined,1);
	}

	scripts\mp\utility::bufferednotify("earned_award_buffered",param_00);
	if(isdefined(self.awardsthislife[param_00]))
	{
		self.awardsthislife[param_00]++;
	}
	else
	{
		self.awardsthislife[param_00] = 1;
	}

	scripts\mp\matchdata::func_AF97(param_00);
	scripts\mp\missions::func_D98F(param_00);
}

//Function Number: 11
queuemidmatchaward(param_00)
{
	self.awardqueue[self.awardqueue.size] = param_00;
	thread flushmidmatchawardqueuewhenable();
}

//Function Number: 12
flushmidmatchawardqueue()
{
	foreach(var_01 in self.awardqueue)
	{
		givemidmatchaward(var_01);
	}

	self.awardqueue = [];
}

//Function Number: 13
flushmidmatchawardqueuewhenable()
{
	self endon("disconnect");
	self notify("flushMidMatchAwardQueueWhenAble()");
	self endon("flushMidMatchAwardQueueWhenAble()");
	for(;;)
	{
		if(!shouldqueuemidmatchaward())
		{
			break;
		}

		scripts\engine\utility::waitframe();
	}

	thread flushmidmatchawardqueue();
}

//Function Number: 14
shouldqueuemidmatchaward(param_00)
{
	if(level.gameended)
	{
		return 0;
	}

	if(!scripts\mp\utility::isreallyalive(self))
	{
		if(!scripts\mp\utility::istrue(param_00) || scripts\mp\utility::isinkillcam())
		{
			if(!scripts\mp\utility::isusingremote())
			{
				return 1;
			}
		}
	}

	return 0;
}

//Function Number: 15
func_B8E6(param_00)
{
	if(!isdefined(param_00) || !isdefined(level.awards) || !isdefined(level.awards[param_00]))
	{
		return;
	}

	if(!isdefined(self.var_1097C) || !isdefined(self.var_D8B1))
	{
		self.var_1097C = 0;
		self.var_D8B1 = 0;
	}

	var_01 = level.awards[param_00].id;
	if(var_01 > 255)
	{
		scripts\engine\utility::error("awardID can\'t be larger than 255! Must increased bit size for award id stored in ui_spectating_award_event_bitfield");
	}

	var_02 = self.var_D8B1;
	var_03 = 8 * self.var_1097C % 4;
	var_04 = ~255 << var_03;
	var_02 = var_02 & var_04;
	var_05 = var_01 << var_03;
	var_02 = var_02 | var_05;
	self setclientomnvar("ui_spectating_award_event_bitfield",var_02);
	self setclientomnvar("ui_spectating_award_event_index",self.var_1097C);
	self.var_D8B1 = var_02;
	self.var_1097C++;
	if(self.var_1097C > 99)
	{
		self.var_1097C = 0;
	}
}

//Function Number: 16
givemidmatchaward(param_00,param_01,param_02,param_03)
{
	if(!isplayer(self))
	{
		return;
	}

	if(getdvarint("com_codcasterEnabled",0) == 1)
	{
		foreach(var_05 in level.players)
		{
			if(var_05 ismlgspectator())
			{
				var_06 = var_05 getspectatingplayer();
				if(isdefined(var_06))
				{
					var_07 = var_06 getentitynumber();
					var_08 = self getentitynumber();
					if(var_07 == var_08)
					{
						var_05 func_B8E6(param_00);
					}
				}
			}
		}
	}

	if(isai(self))
	{
		return;
	}

	if(shouldqueuemidmatchaward(param_03))
	{
		queuemidmatchaward(param_00);
		return;
	}

	scripts\mp\analyticslog::logevent_awardgained(param_00);
	giveaward(param_00,param_01,param_02);
}

//Function Number: 17
addawardtoaarlist(param_00)
{
	if(!isdefined(self.aarawards))
	{
		self.aarawards = [];
		self.aarawardcount = 0;
		for(var_01 = 0;var_01 < 10;var_01++)
		{
			var_02 = spawnstruct();
			self.aarawards[var_01] = var_02;
			var_02.ref = "none";
			var_02.var_C1 = 0;
		}
	}

	foreach(var_01, var_04 in self.aarawards)
	{
		if(var_04.ref == param_00)
		{
			var_04.var_C1++;
			self setplayerdata("common","round","awards",var_01,"value",var_04.var_C1);
			return;
		}
	}

	var_05 = level.awards[param_00].aarpriority;
	for(var_06 = 0;var_06 < self.aarawards.size;var_06++)
	{
		var_04 = self.aarawards[var_06];
		if(var_04.ref == "none")
		{
			break;
		}

		var_07 = level.awards[var_04.ref].aarpriority;
		if(var_05 > var_07)
		{
			break;
		}
	}

	if(var_06 >= self.aarawards.size)
	{
		return;
	}

	for(var_08 = self.aarawards.size - 2;var_08 >= var_06;var_08--)
	{
		var_09 = var_08 + 1;
		self.aarawards[var_09] = self.aarawards[var_08];
		var_04 = self.aarawards[var_09];
		if(var_04.ref != "none")
		{
			self setplayerdata("common","round","awards",var_09,"award",var_04.ref);
			self setplayerdata("common","round","awards",var_09,"value",var_04.var_C1);
		}
	}

	var_04 = spawnstruct();
	self.aarawards[var_06] = var_04;
	var_04.ref = param_00;
	var_04.var_C1 = 1;
	self setplayerdata("common","round","awards",var_06,"award",var_04.ref);
	self setplayerdata("common","round","awards",var_06,"value",var_04.var_C1);
	if(self.aarawardcount < 10)
	{
		self.aarawardcount++;
		self setplayerdata("common","round","awardCount",self.aarawardcount);
	}

	if(scripts\mp\utility::istrue(self.savedaarawards))
	{
		saveaarawards();
	}
}

//Function Number: 18
initaarawardlist()
{
	self.aarawards = self.pers["aarAwards"];
	self.aarawardcount = self.pers["aarAwardCount"];
	thread saveaarawardsonroundswitch();
	if(isdefined(self.aarawards))
	{
		return;
	}

	self setplayerdata("common","round","awardCount",0);
	for(var_00 = 0;var_00 < 10;var_00++)
	{
		self setplayerdata("common","round","awards",var_00,"award","none");
		self setplayerdata("common","round","awards",var_00,"value",0);
	}
}

//Function Number: 19
saveaarawardsonroundswitch()
{
	self endon("disconnect");
	level waittill("game_ended");
	saveaarawards();
}

//Function Number: 20
saveaarawards()
{
	self.pers["aarAwards"] = self.aarawards;
	self.pers["aarAwardCount"] = self.aarawardcount;
	self.savedaarawards = 1;
}