// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: playerSpawn.sqf
//	@file Author: [404] Deadbeat, AgentRev
//	@file Created: 20/11/2012 05:19
//	@file Args:

playerSpawning = true;

//Teamkiller Kick
if (!isNil "pvar_teamKillList" && {playerSide in [BLUFOR,OPFOR]}) then
{
	if ([pvar_teamKillList, getPlayerUID player, 0] call fn_getFromPairs >= 2) exitWith
	{
		player allowDamage false;
		[player, "AinjPpneMstpSnonWrflDnon"] call switchMoveGlobal;
		9999 cutText ["", "BLACK", 0.01];
		0 fadeSound 0;

		uiNamespace setVariable ["BIS_fnc_guiMessage_status", false];
		_msgBox = [localize "STR_WL_Loading_Teamkiller"] spawn BIS_fnc_guiMessage;
		_time = diag_tickTime;

		waitUntil {scriptDone _msgBox || diag_tickTime - _time >= 20};
		endMission "LOSER";
		waitUntil {uiNamespace setVariable ["BIS_fnc_guiMessage_status", false]; closeDialog 0; false};
	};
};
//Teamswitcher Kick
if (!isNil "pvar_teamSwitchList" && playerSide in [BLUFOR,OPFOR]) then
{
	if ([pvar_teamSwitchList, getPlayerUID player, playerSide] call fn_getFromPairs != playerSide) exitWith
	{
		player allowDamage false;
		[player, "AinjPpneMstpSnonWrflDnon"] call switchMoveGlobal;
		9999 cutText ["", "BLACK", 0.01];
		0 fadeSound 0;

		uiNamespace setVariable ["BIS_fnc_guiMessage_status", false];
		_msgBox = [localize "STR_WL_Loading_Teamswitched"] spawn BIS_fnc_guiMessage;
		_time = diag_tickTime;

		waitUntil {scriptDone _msgBox || diag_tickTime - _time >= 20};
		endMission "LOSER";
		waitUntil {uiNamespace setVariable ["BIS_fnc_guiMessage_status", false]; closeDialog 0; false};
	};
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
