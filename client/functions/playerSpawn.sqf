//	@file Version: 1.0
//	@file Name: playerSpawn.sqf
//	@file Author: [404] Deadbeat, AgentRev
//	@file Created: 20/11/2012 05:19
//	@file Args:

private ["_kickTeamKiller", "_kickTeamSwitcher", "_side"];

playerSpawning = true;

_kickTeamKiller = false;
_kickTeamSwitcher = false;

if (playerSide != INDEPENDENT) then
{
	if (!isNil "pvar_teamKillList") then
	{
		{
			if (_x select 0 == getPlayerUID player && {_x select 1 > 1}) exitWith
			{
				_kickTeamKiller = true;
			};
		} forEach pvar_teamKillList;
	};

	if (!isNil "pvar_teamSwitchList") then
	{
		{
			if (_x select 0 == getPlayerUID player && {_x select 1 != playerSide}) exitWith
			{
				_side = _x select 1;
				_kickTeamSwitcher = true;
			};
		} forEach pvar_teamSwitchList;
	};
};

//Teamkiller Kick
if (_kickTeamKiller) exitWith
{
	titleText [localize "STR_WL_Loading_Teamkiller", "black"];
	titleFadeOut 9999;
	[] spawn {sleep 20; endMission "LOSER";};
};

//Teamswitcher Kick
if (_kickTeamSwitcher) exitWith
{
	titleText [format[localize "STR_WL_Loading_Teamswitched", localize format ["STR_WL_Gen_Team%1_2", _side]], "black"];
	titleFadeOut 9999;
	[] spawn {sleep 20; endMission "LOSER";};
};

//Send player to debug zone to stop fake spawn locations.
player setPosATL [7837.37,7627.14,0.00230217];
player setDir 333.429;
//             

titleText ["Loading...", "BLACK OUT", 0.00001];

true spawn client_respawnDialog;

waitUntil {respawnDialogActive};

while {respawnDialogActive} do {
	titleText ["", "BLACK OUT", 0.00001];
};
sleep 0.1;
titleText ["", "BLACK IN", 0.00001];
playerSpawning = false;