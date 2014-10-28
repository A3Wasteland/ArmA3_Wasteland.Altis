// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: findHackedVehicles.sqf
//	@file Author: AgentRev
//	@file Created: 09/06/2013 16:56

private ["_requestKey", "_hackedVehicles"];
_requestKey = call A3W_fnc_generateKey;

[[player, _requestKey], "A3W_fnc_checkHackedVehicles", false, false] call A3W_fnc_MP;

waitUntil {!isNil _requestKey};

_hackedVehicles = missionNamespace getVariable [_requestKey, []];
missionNamespace setVariable [_requestKey, nil];

{
	_hackedVehicles set [_forEachIndex, [objectFromNetId (_x select 0), toString (_x select 1)]];
} forEach _hackedVehicles;

_hackedVehicles
