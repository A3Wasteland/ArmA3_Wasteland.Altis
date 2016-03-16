// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: checkHackedVehicles.sqf
//	@file Author: AgentRev
//	@file Created: 09/06/2013 16:29

if (!isServer) exitWith {};

private ["_array", "_client", "_key", "_hackedVehicles", "_owner", "_name"];

_client = _this select 0;
_key = _this select 1;
_hackedVehicles = [];

{
	if !((_x getVariable [call vChecksum, false]) isEqualTo true) then
	{
		_owner = [owner _x] call findClientPlayer;
		_name = if (isPlayer _owner) then { name _owner } else { "" };

		_hackedVehicles pushBack [netId _x, toArray _name];
	};
} forEach vehicles;

//[[[_hackedVehicles], compile format ["%1 = _this select 0", _key]], "BIS_fnc_spawn", _client, false] call A3W_fnc_MP;

missionNamespace setVariable [_key, _hackedVehicles];
(owner _client) publicVariableClient _key;
missionNamespace setVariable [_key, nil];
