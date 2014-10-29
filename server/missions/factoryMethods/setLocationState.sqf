// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: setLocationState.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

private ["_locArray", "_locName", "_locState"];

_locArray = [_this, 0, [], [[]]] call BIS_fnc_param;
_locName = [_this, 1, "", [""]] call BIS_fnc_param;
_locState = [_this, 2, false, [false]] call BIS_fnc_param;

{
	if (_x select 0 == _locName) exitWith
	{
		_x set [1, _locState];
		_x set [2, diag_tickTime];
	};
} forEach _locArray;
