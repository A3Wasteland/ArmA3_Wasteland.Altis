// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: isAssignableBinocular.sqf
//	@file Author: AgentRev
//	@file Created: 22/08/2013 21:54

private ["_player", "_item", "_isAssignable"];

_player = _this select 0;
_item = _this select 1;
_isAssignable = true;

if ([_item, 4096] call isWeaponType &&
   {getNumber (configFile >> "CfgWeapons" >> _item >> "ItemInfo" >> "type") != 616}) then
{
	{
		if ([_x, 4096] call isWeaponType &&
		   {getNumber (configFile >> "CfgWeapons" >> _x >> "ItemInfo" >> "type") != 616}) exitWith
		{
			_isAssignable = false;
		};
	} forEach assignedItems _player;
}
else
{
	_isAssignable = false;
};

_isAssignable
