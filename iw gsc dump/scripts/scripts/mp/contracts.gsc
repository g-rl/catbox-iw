/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\contracts.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 9
 * Decompile Time: 427 ms
 * Timestamp: 10/27/2023 12:22:34 AM
*******************************************************************/

//Function Number: 1
init()
{
	if(getdvarint("mission_team_contracts_enabled",0) == 0)
	{
		return;
	}

	var_00 = spawnstruct();
	level.contractglobals = var_00;
	scripts\mp\contractchallenges::registercontractchallenges();
	var_00.numchallenges = 0;
	var_01 = 0;
	for(;;)
	{
		var_02 = tablelookupbyrow("mp/contractChallenges.csv",var_01,0);
		if(!isdefined(var_02) || var_02 == "")
		{
			break;
		}

		var_00.numchallenges++;
		var_01++;
	}

	level thread onplayerconnect();
}

//Function Number: 2
contractsenabled()
{
	if(isai(self))
	{
		return 0;
	}

	if(!level.rankedmatch)
	{
		return 0;
	}

	if(!scripts\mp\utility::rankingenabled())
	{
		return 0;
	}

	if(getdvarint("mission_team_contracts_enabled",0) == 0)
	{
		return 0;
	}

	return 1;
}

//Function Number: 3
onplayerconnect()
{
	for(;;)
	{
		level waittill("connected",var_00);
		if(!var_00 contractsenabled())
		{
			continue;
		}

		var_00.contracts = [];
		var_01 = var_00 getchallengeids();
		foreach(var_04, var_03 in var_01)
		{
			var_00 givecontractchallenge(var_03,var_04);
		}
	}
}

//Function Number: 4
getchallengeids()
{
	var_00 = self getplayerdata("mp","contracts","challenges",0,"challengeID");
	var_01 = self getplayerdata("mp","contracts","challenges",1,"challengeID");
	return [var_00,var_01];
}

//Function Number: 5
givecontractchallenge(param_00,param_01)
{
	var_02 = lookupcontractchallengeref(param_00);
	if(!isdefined(var_02))
	{
		return undefined;
	}

	var_03 = spawnstruct();
	var_03.slot = param_01;
	var_03.ref = var_02;
	var_03.target = lookupcontractchallengetarget(param_00);
	var_03.team = lookupcontractchallengeteam(param_00);
	var_03.id = param_00;
	var_03.progress = self getplayerdata("mp","contracts","challenges",var_03.slot,"progress");
	var_04 = self getplayerdata("mp","activeMissionTeam");
	var_05 = var_03.team == var_04 || var_03.team == -1;
	var_03.completed = var_03.progress >= var_03.target;
	if(!var_03.completed && var_05)
	{
		self thread [[ level.contractchallenges[var_03.ref] ]](var_03);
		self.contracts[param_01] = var_03;
	}
}

//Function Number: 6
lookupcontractchallengeref(param_00)
{
	var_01 = tablelookup("mp/contractChallenges.csv",0,param_00,1);
	if(!isdefined(var_01) || var_01 == "")
	{
		return undefined;
	}

	return var_01;
}

//Function Number: 7
lookupcontractchallengetarget(param_00)
{
	var_01 = tablelookup("mp/contractChallenges.csv",0,param_00,3);
	if(!isdefined(var_01) || var_01 == "")
	{
		return undefined;
	}

	return int(var_01);
}

//Function Number: 8
lookupcontractchallengeteam(param_00)
{
	var_01 = tablelookup("mp/contractChallenges.csv",0,param_00,2);
	if(!isdefined(var_01) || var_01 == "")
	{
		return undefined;
	}

	return int(var_01);
}

//Function Number: 9
updatecontractprogress(param_00,param_01)
{
	if(!level.onlinegame)
	{
		return;
	}

	if(!isdefined(param_01))
	{
		param_01 = 1;
	}

	param_00.progress = param_00.progress + param_01;
	param_00.progress = int(min(param_00.progress,param_00.target));
	if(!param_00.completed)
	{
		param_00.completed = param_00.progress >= param_00.target;
		if(param_00.completed)
		{
			var_02 = scripts\engine\utility::ter_op(param_00.team == -1,"contract_complete_joint_ops","contract_complete_team_" + param_00.team);
			thread scripts\mp\hud_message::showsplash(var_02);
			self setplayerdata("mp","contracts","challenges",param_00.slot,"completed",1);
		}
	}

	self setplayerdata("mp","contracts","challenges",param_00.slot,"progress",param_00.progress);
}