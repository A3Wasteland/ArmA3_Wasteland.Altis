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
	localize "STR_WL_Loading_Teamkiller";
	9999 cutText [_text, "BLACK"];
	titleText [_text, "BLACK"];
	[] spawn {sleep 20; endMission "LOSER"};
};

//Teamswitcher Kick
if (_kickTeamSwitcher) exitWith
{
	_text = format [localize "STR_WL_Loading_Teamswitched", localize format ["STR_WL_Gen_Team%1_2", _side]];
	9999 cutText [_text, "BLACK"];
	titleText [_text, "BLACK"];
	[] spawn {sleep 20; endMission "LOSER"};
};

// Only go through respawn dialog if no data from the player save system
if (isNil "playerData_alive") then
{
	//Send player to debug zone to stop fake spawn locations.
	player setPosATL [7837.37,7627.14,0.00230217];
	[player, "AmovPknlMstpSnonWnonDnon"] call switchMoveGlobal;

	9999 cutText ["Loading...", "BLACK", 0.01];

	true spawn client_respawnDialog;

	waitUntil {respawnDialogActive};
	9999 cutText ["", "BLACK", 0.01];
	waitUntil {!respawnDialogActive};

	if (["A3W_playerSaving"] call isConfigOn) then
	{
		[] spawn fn_savePlayerData;
	};
}
else
{
	playerData_alive = nil;
};

9999 cutText ["", "BLACK IN"];

playerSpawning = false;
