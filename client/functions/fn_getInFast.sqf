// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_getInFast.sqf
//	@file Author: AgentRev

params [["_unit",objNull,[objNull]], ["_vehicle",objNull,[objNull]], ["_passengerOnly",true,[false]]];

if (!local _unit) exitWith
{
	private _preCheck = [_unit, _vehicle, _passengerOnly] call fn_canGetIn;
	if (_preCheck) then { _this remoteExecCall ["A3W_fnc_getInFast", _unit] }; // self-call function remotely
	_preCheck
};

if !(alive _vehicle && alive _unit && isNull objectParent _unit) exitWith { false };
if (locked _vehicle in ([[2],[2,3]] select isPlayer _unit)) exitWith { false };

private _seats = [];

{
	_x params ["_vUnit", "_role", "_cargo", "_path"];

	if (!alive _vUnit && (!_passengerOnly || _role != "driver")) then
	{
		switch (true) do
		{
			case (_role == "driver"):    { if (!lockedDriver _vehicle) then { _seats pushBack ["driver"] } };
			case (_cargo != -1):         { if !(_vehicle lockedCargo _cargo) then { _seats pushBackUnique ["cargo"] } };
			case !(_path isEqualTo []):  { if !(_vehicle lockedTurret _path) then { _seats pushBack [toLower _role, _path] } };
			default                      { _seats pushBack [toLower _role] };
		};
	};
} forEach fullCrew [_vehicle, "", true];

if (_seats isEqualTo []) exitWith { false };

private _seatsPriority = ["driver","gunner","turret","commander","cargo"]; // first seat available from right to left
if (!_passengerOnly) then { reverse _seatsPriority }; // left to right

_seats = [_seats, [], { _seatsPriority find (_x select 0) }, "DESCEND"] call BIS_fnc_sortBy;

private _seat = _seats select 0;
switch (_seat select 0) do
{
	case "commander":  { _unit moveInCommander _vehicle };
	case "turret":     { _unit moveInTurret [_vehicle, _seat select 1] };
	case "gunner":     { _unit moveInGunner _vehicle };
	case "driver":     { _unit moveInDriver _vehicle };
	default            { _unit moveInCargo _vehicle };
};

(vehicle _unit == _vehicle)
