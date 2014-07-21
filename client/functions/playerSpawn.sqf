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
	player allowDamage false;
	localize "STR_WL_Loading_Teamkiller";
	9999 cutText [_text, "BLACK"];
	titleText [_text, "BLACK"];
	[] spawn {sleep 20; player allowDamage true; endMission "LOSER"};
};

//Teamswitcher Kick
if (_kickTeamSwitcher) exitWith
{
	player allowDamage false;
	_text = format [localize "STR_WL_Loading_Teamswitched", localize format ["STR_WL_Gen_Team%1_2", _side]];
	9999 cutText [_text, "BLACK"];
	titleText [_text, "BLACK"];
	[] spawn {sleep 20; player allowDamage true; endMission "LOSER"};
};

// Only go through respawn dialog if no data from the player save system
if (isNil "playerData_alive" || !isNil "playerData_resetPos") then
{
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
};

playerData_alive = nil;
playerData_resetPos = nil;

9999 cutText ["", "BLACK IN"];

playerSpawning = false;
player setVariable ["playerSpawning", false, true];
