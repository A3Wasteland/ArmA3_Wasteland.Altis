//	@file Version: 1.0
//	@file Name: fn_fitsInventory.sqf
//	@file Author: AgentRev
//	@file Created: 05/05/2013 00:22
//	@file Args: _player, _item

private ["_player", "_item", "_uniformFree", "_vestFree", "_backpackFree", "_uniform", "_vest", "_backpack", "_containerClass", "_uniformCapacity", "_vestCapacity", "_backpackCapacity", "_itemSize"];

_player = _this select 0;
_item = _this select 1;

_uniformFree = 0;
_vestFree = 0;
_backpackFree = 0;

_uniform = uniform _player;
_vest = vest _player;
_backpack = backpack _player;

if (_uniform != "") then
{
	_containerClass = getText (configFile >> "CfgWeapons" >> _uniform >> "ItemInfo" >> "containerClass");
	_uniformCapacity = getNumber (configFile >> "CfgVehicles" >> _containerClass >> "maximumLoad");
	_uniformFree = _uniformCapacity - loadUniform _player;
};

if (_vest != "") then
{
	_containerClass = getText (configFile >> "CfgWeapons" >> _vest >> "ItemInfo" >> "containerClass");
	_vestCapacity = getNumber (configFile >> "CfgVehicles" >> _containerClass >> "maximumLoad");
	_vestFree = _vestCapacity - loadVest _player;
};

if (_backpack != "") then
{
	_backpackCapacity = getNumber (configFile >> "CfgVehicles" >> _backpack >> "maximumLoad");
	_backpackFree = _backpackCapacity - loadBackpack _player;
};

_itemSize = getNumber (configFile >> "CfgWeapons" >> _item >> "ItemInfo" >> "mass");
if (_itemSize == 0) then { _itemSize = getNumber (configFile >> "CfgMagazines" >> _item >> "mass") };
if (_itemSize == 0) then { _itemSize = getNumber (configFile >> "CfgWeapons" >> _item >> "WeaponSlotsInfo" >> "mass") };

// Return boolean

(_itemSize > 0 && {_itemSize <= _uniformFree || _itemSize <= _vestFree || _itemSize <= _backpackFree})