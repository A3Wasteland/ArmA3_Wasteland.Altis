// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: convertTerritoryOwner.sqf
//	@file Author: AgentRev

private ["_newTerritories", "_newGroup", "_territory"];

_newTerritories = _this select 0;
_newGroup = _this select 1;

if (isNil "currentTerritoryDetails") exitWith {};

{
	_territory = _x;
	{
		if (_x select 0 == _territory) exitWith
		{
			_x set [2, _newGroup];
			_x set [3, 0]; // reset chrono
		};
	} forEach currentTerritoryDetails;
} forEach _newTerritories;
