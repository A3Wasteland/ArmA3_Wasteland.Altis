// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: getCapacity.sqf
//	@file Author: AgentRev
//	@file Created: 12/10/2013 22:45
//	@file Args:

private ["_item", "_capacity", "_containerClass"];
_item = _this select 0;

if (_item isKindOf "Bag_Base") then
{
	_capacity = getNumber (configFile >> "CfgVehicles" >> _item >> "maximumLoad");
}
else
{
	_containerClass = getText (configFile >> "CfgWeapons" >> _item >> "ItemInfo" >> "containerClass");
	_capacity = getNumber (configFile >> "CfgVehicles" >> _containerClass >> "maximumLoad");
};

_capacity
