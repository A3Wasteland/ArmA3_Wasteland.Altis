//	@file Version: 1.0
//	@file Name: getCurrentBinoculars.sqf
//	@file Author: AgentRev
//	@file Created: 10/10/2013 23:31

private ["_player", "_binoculars"];

_player = _this;
_binoculars = "";

{
	if ([_x, 4096] call isWeaponType &&
	   {getNumber (configFile >> "CfgWeapons" >> _x >> "ItemInfo" >> "type") != 616}) exitWith
	{
		_binoculars = _x;
	};
} forEach assignedItems _player;

_binoculars
