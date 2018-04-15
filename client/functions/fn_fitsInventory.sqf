// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_fitsInventory.sqf
//	@file Author: AgentRev

// This script is much more complicated than it should be, because canAddItemToXXX is not detecting free inventory space correctly in Arma 3 v1.34, another bug courtesy of BIS...

private ["_unit", "_item", "_allowedContainers", "_allSlots", "_wpSlotsInfo", "_magCfg", "_allowedSlots", "_uniformFree", "_vestFree", "_backpackFree", "_uniform", "_vest", "_backpack", "_containerClass", "_uniformCapacity", "_vestCapacity", "_backpackCapacity", "_itemSize", "_linkedItems", "_linkedItem"];

_unit = _this select 0;
_item = _this select 1;

if (count _this > 2) then { _allowedContainers = _this select 2 };

_allSlots = true;
_wpSlotsInfo = configFile >> "CfgWeapons" >> _item >> "WeaponSlotsInfo";
_magCfg = configFile >> "CfgMagazines" >> _item;

switch (true) do
{
	case (isClass _wpSlotsInfo):
	{
		if (isArray (_wpSlotsInfo >> "allowedSlots")) then
		{
			_allowedSlots = getArray (_wpSlotsInfo >> "allowedSlots");
			_allSlots = false;
		};
	};
	case (isClass _magCfg):
	{
		if (isArray (_magCfg >> "allowedSlots")) then
		{
			_allowedSlots = getArray (_magCfg >> "allowedSlots");
			_allSlots = false;
		};
	};
};

if (!isNil "_allowedContainers") then
{
	if (typeName _allowedContainers != "ARRAY") then
	{
		_allowedContainers = [_allowedContainers];
	};

	{
		if (typeName _x == "STRING") then
		{
			switch (toLower _x) do
			{
				case "uniform":  { _allowedContainers set [_forEachIndex, 801] };
				case "vest":     { _allowedContainers set [_forEachIndex, 701] };
				case "backpack": { _allowedContainers set [_forEachIndex, 901] };
			};
		};
	} forEach _allowedContainers;

	if (isNil "_allowedSlots") then
	{
		_allowedSlots = [];
	};

	{
		if !(_x in _allowedContainers) then
		{
			_allowedSlots = _allowedSlots - [_x];
		};
	} forEach (+_allowedSlots);

	if (_allSlots) then
	{
		{
			if !(_x in _allowedSlots) then
			{
				_allowedSlots set [count _allowedSlots, _x];
			};
		} forEach _allowedContainers;
	};
};

_uniformFree = 0;
_vestFree = 0;
_backpackFree = 0;

_uniform = uniform _unit;
_vest = vest _unit;
_backpack = backpack _unit;

if (_uniform != "" && (isNil "_allowedSlots" || {701 in _allowedSlots})) then
{
	_containerClass = getText (configFile >> "CfgWeapons" >> _uniform >> "ItemInfo" >> "containerClass");
	_uniformCapacity = getNumber (configFile >> "CfgVehicles" >> _containerClass >> "maximumLoad");
	_uniformFree = _uniformCapacity - ((loadUniform _unit) * _uniformCapacity);
};

if (_vest != "" && (isNil "_allowedSlots" || {801 in _allowedSlots})) then
{
	_containerClass = getText (configFile >> "CfgWeapons" >> _vest >> "ItemInfo" >> "containerClass");
	_vestCapacity = getNumber (configFile >> "CfgVehicles" >> _containerClass >> "maximumLoad");
	_vestFree = _vestCapacity - ((loadVest _unit) * _vestCapacity);
};

if (_backpack != "" && (isNil "_allowedSlots" || {901 in _allowedSlots})) then
{
	_backpackCapacity = getNumber (configFile >> "CfgVehicles" >> _backpack >> "maximumLoad");
	_backpackFree = _backpackCapacity - ((loadBackpack _unit) * _backpackCapacity);
};

_itemSize = getNumber (configFile >> "CfgWeapons" >> _item >> "ItemInfo" >> "mass"); // item
if (_itemSize == 0) then { _itemSize = getNumber (configFile >> "CfgMagazines" >> _item >> "mass") }; // magazine
if (_itemSize == 0) then { _itemSize = getNumber (_wpSlotsInfo >> "mass") }; // weapon

_linkedItems = configFile >> "CfgWeapons" >> _item >> "LinkedItems";

if (isClass _linkedItems) then
{
	for "_i" from 0 to (count _linkedItems - 1) do
	{
		_linkedItem = getText ((_linkedItems select _i) >> "item");
		_itemSize = _itemSize + getNumber (configFile >> "CfgWeapons" >> _linkedItem >> "ItemInfo" >> "mass");
	};
};

// Return boolean

(_itemSize > 0 && {_itemSize <= _uniformFree || _itemSize <= _vestFree || _itemSize <= _backpackFree})
