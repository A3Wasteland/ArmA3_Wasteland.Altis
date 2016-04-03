// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_canGetIn.sqf
//	@file Author: AgentRev

params [["_unit",objNull,[objNull]], ["_vehicle",objNull,[objNull]], ["_passengerOnly",false,[false]]];

if !(alive _vehicle && alive _unit && isNull objectParent _unit) exitWith { false };
if (locked _vehicle in ([[2],[2,3]] select isPlayer _unit)) exitWith { false };
if (alive effectiveCommander _vehicle && !([effectiveCommander _vehicle, _unit] call A3W_fnc_isFriendly)) exitWith { false };

private _found = false;

{
	_x params ["_vUnit", "_role"];

	if (!alive _vUnit && (!_passengerOnly || _role != "driver")) exitWith
	{
		_found = true;
	};
} forEach fullCrew [_vehicle, "", true];

_found
