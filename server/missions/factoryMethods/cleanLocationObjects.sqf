// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: cleanLocationObjects.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

#define CLEANUP_RADIUS 50

private ["_locArray", "_locName", "_locPos"];

_locArray = [_this, 0, [], [[]]] call BIS_fnc_param;
_locName = [_this, 1, "", [""]] call BIS_fnc_param;
_locPos = [_this, 2, [], [[]]] call BIS_fnc_param;

if (_locPos isEqualTo [0,0,0]) exitWith {};

{
	if (_x select 0 == _locName) exitWith
	{
		_locObjects = [_x, 3, [], [[]]] call BIS_fnc_param;

		{
			if (_x distance _locPos <= CLEANUP_RADIUS && _x getVariable ["ownerUID", ""] == "") then
			{
				deleteVehicle _x;
			};
		} forEach _locObjects;

		_x set [3, []];
	};
} forEach _locArray;
