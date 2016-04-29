// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_onPlayerConnected.sqf
//	@file Author: AgentRev

params ["_id", "_uid", "_name", "_owner", "_jip"];

diag_log format ["Player connected: %1 (%2)", _name, _uid];

_spawnTimestamps = missionNamespace getVariable ["A3W_spawnTimestamps_" + _uid, []];

if !(_spawnTimestamps isEqualTo []) then
{
	[_spawnTimestamps, diag_tickTime] remoteExec ["A3W_fnc_setSpawnTimestamps", _owner]; // do not whitelist
};
