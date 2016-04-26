// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_updateSpawnTimestamp.sqf
//	@file Author: AgentRev

params [["_player",objNull,[objNull]], ["_location","",["",objNull]]];

if (!isPlayer _player || _location in ["",objNull]) exitWith {};

_pvar = "A3W_spawnTimestamps_" + getPlayerUID _player;
_spawnTimestamps = missionNamespace getVariable [_pvar, []];

[_spawnTimestamps, _location, diag_tickTime] call fn_setToPairs;

missionNamespace setVariable [_pvar, _spawnTimestamps];
