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

	// Disable side chat for indies
	if (playerSide == INDEPENDENT) then
	{
		1 enableChannel false;
	};
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

// Workaround for broken disableChannels, see https://feedback.bistudio.com/T117205
{
	_x params [["_chan",-1,[0]], ["_noText","false",[""]], ["_noVoice","false",[""]]];

	_noText = [false,true] select ((["false","true"] find toLower _noText) max 0);
	_noVoice = [false,true] select ((["false","true"] find toLower _noVoice) max 0);

	_chan enableChannel [!_noText, !_noVoice];

} forEach getArray (missionConfigFile >> "disableChannels");

2 enableChannel false; // force disable command channel
