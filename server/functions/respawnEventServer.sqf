// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: respawnEventServer.sqf
//	@file Author: AgentRev

private ["_unit", "_corpse", "_eventID"];
_unit = _this select 0;
_corpse = _this select 1;

_unit setVariable ["playerSpawning", true];
_unit setVariable ["A3W_killScoreRegistered", nil];
_unit setVariable ["A3W_deathCause_local", nil, true];
_unit setVariable ["A3W_deathCause_remote", nil, true];

_unit setVariable ["parked_vehicles", _corpse getVariable ["parked_vehicles", []]];

_eventID = _corpse getVariable "A3W_respawnEH";
if (!isNil "_eventID") then { _corpse removeEventHandler ["Respawn", _eventID] };
