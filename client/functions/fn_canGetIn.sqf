// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_canGetIn.sqf
//	@file Author: AgentRev

params [["_unit",objNull,[objNull]], ["_vehicle",objNull,[objNull]], ["_passengerOnly",false,[false]]];

if !(alive _vehicle && alive _unit && isNull objectParent _unit) exitWith { false };
if (locked _vehicle in ([[2],[2,3]] select isPlayer _unit)) exitWith { false };
if (alive effectiveCommander _vehicle && !([effectiveCommander _vehicle, _unit] call A3W_fnc_isFriendly)) exitWith { false };

scopeName "fn_canGetIn";
private _found = false;

{
	_x params ["_vUnit", "_role", "_cargo", "_path"];

	if (!alive _vUnit && (!_passengerOnly || _role != "driver")) then
	{
		if ((_role != "driver" || !lockedDriver _vehicle) &&
		    (_cargo == -1 || !(_vehicle lockedCargo _cargo)) &&
		    (_path isEqualTo [] || !(_vehicle lockedTurret _path))) then
		{
			_found = true;
			breakTo "fn_canGetIn";
		};
	};
} forEach fullCrew [_vehicle, "", true];

_found
