// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: cleanLocationObjects.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

#define CLEANUP_RADIUS 50

private ["_locArray", "_locName", "_locPos"];

_locArray = param [0, [], [[]]];
_locName = param [1, "", [""]];
_locPos = param [2, [], [[]]];

if (_locPos isEqualTo [0,0,0]) exitWith {};

{
	if (_x select 0 == _locName) exitWith
	{
		_locObjects = _x param [3, [], [[]]];

		{
			if (_x distance _locPos <= CLEANUP_RADIUS && _x getVariable ["ownerUID", ""] == "") then
			{
				deleteVehicle _x;
			};
		} forEach _locObjects;

		_x set [3, []];
	};
} forEach _locArray;
