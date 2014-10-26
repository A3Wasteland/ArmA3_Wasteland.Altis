// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: setLocationObjects.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

private ["_locArray", "_locName", "_locObjects"];

_locArray = [_this, 0, [], [[]]] call BIS_fnc_param;
_locName = [_this, 1, "", [""]] call BIS_fnc_param;
_locObjects = [_this, 2, [], [[]]] call BIS_fnc_param;

{
	if (_x select 0 == _locName) exitWith
	{
		_x set [3, _locObjects];
	};
} forEach _locArray;
