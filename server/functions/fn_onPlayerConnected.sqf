// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_onPlayerConnected.sqf
//	@file Author: AgentRev

params ["_id", "_uid", "_name", "_jip", "_owner"];

diag_log format ["Player connected: %1 (%2)", _name, _uid];
if (_uid isEqualTo "") exitWith {};

missionNamespace setVariable ["A3W_joinTickTime_" + _uid, diag_tickTime];
[diag_tickTime, { A3W_serverTickTimeDiff = _this - diag_tickTime }] remoteExecCall ["call", _owner];

private _spawnTimestamps = missionNamespace getVariable ["A3W_spawnTimestamps_" + _uid, []];

if !(_spawnTimestamps isEqualTo []) then
{
	[_spawnTimestamps, diag_tickTime] remoteExec ["A3W_fnc_setSpawnTimestamps", _owner]; // do not whitelist
};

private _artiUseVar = "A3W_artilleryLastUse_" + _uid;
private _artiLastUse = missionNamespace getVariable _artiUseVar;
if (!isNil "_artiLastUse") then { _owner publicVariableClient _artiUseVar };
