// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: preInit.sqf
//	@file Author: AgentRev

if (!hasInterface) exitWith {};

0 spawn
{
	waitUntil {!isNull player};
	[player, didJIP, hasInterface] remoteExecCall ["A3W_fnc_initPlayerServer", 2];
};

// skip Continue button if briefing = 0 in description.ext, courtesy of Killzone Kid
0 spawn
{
	_briefing = missionConfigFile >> "briefing";
	if (!isNumber _briefing || round getNumber _briefing > 0) exitWith {};

	waitUntil
	{
		if (!isNull findDisplay 53) exitWith
		{
			ctrlActivate (findDisplay 53 displayCtrl 1);
			findDisplay 53 closeDisplay 1;
			true
		};

		getClientStateNumber > 9
	};
};
