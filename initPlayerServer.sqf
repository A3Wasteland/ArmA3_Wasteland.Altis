// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: initPlayerServer.sqf
//	@file Author: AgentRev

if (canSuspend) exitWith {}; // called via BIS_fnc_execVM by A3\functions_f\initFunctions.sqf, must be suppressed because _player is sometimes null

params [["_player",objNull,[objNull]], ["_jip",true,[false]], ["_hasInterface",true,[false]]];

if (isNull _player) exitWith {};

_player setVariable ["A3W_joinTickTime", missionNamespace getVariable ["A3W_joinTickTime_" + getPlayerUID _player, diag_tickTime], true];

if (!isNil "currentTerritoryDetails" && _hasInterface) then
{
	[_player, _jip] call updateConnectingClients;
};
