//	@file Version: 1.0
//	@file Name: fn_fitsInventory.sqf
//	@file Author: AgentRev
//	@file Created: 05/05/2013 00:22
//	@file Args: _player, _item

private ["_player", "_item", "_allowedContainers", "_allowedSlots", "_allSlots", "_uniformFree", "_vestFree", "_backpackFree", "_uniform", "_vest", "_backpack", "_containerClass", "_uniformCapacity", "_vestCapacity", "_backpackCapacity", "_itemSize"];

_player = _this select 0;
_item = _this select 1;

if (count _this > 2) then { _allowedContainers = _this select 2 };


if (isClass (configFile >> "CfgWeapons" >> _item >> "WeaponSlotsInfo")) then
{
	if (isArray (configFile >> "CfgWeapons" >> _item >> "WeaponSlotsInfo" >> "allowedSlots")) then
	{
		_allowedSlots = getArray (configFile >> "CfgWeapons" >> _item >> "WeaponSlotsInfo" >> "allowedSlots");
		_allSlots = false;
	}
	else
	{
		_allSlots = true;
	};

	if (!isClass (configFile >> "CfgWeapons" >> _item >> "ItemInfo") && {_allSlots || {901 in _allowedSlots}}) then
	{
		_allowedSlots = [901];
	};
};

if (!isNil "_allowedContainers") then
{
	if (typeName _allowedContainers != typeName []) then
	{
		_allowedContainers = [_allowedContainers];
	};
	
	{
		if (typeName _x == typeName "") then
		{
			switch (toLower _x) do
			{
				case "uniform":
				{
					_x = 701;
					_allowedContainers set [_forEachIndex, _x];
				};
				case "vest":
				{
					_x = 801;
					_allowedContainers set [_forEachIndex, _x];
				};
				case "backpack":
				{
					_x = 901;
					_allowedContainers set [_forEachIndex, _x];
				};
			};
		};
	} forEach _allowedContainers;
	
	if (isNil "_allowedSlots") then
	{
		_allowedSlots = [];
	};
	
	{
		if (!(_x in _allowedContainers)) then
		{
			_allowedSlots = _allowedSlots - [_x];
		};
	} forEach _allowedSlots;
	
	if (_allSlots) then
	{
		{
			if (!(_x in _allowedSlots)) then
			{
				_allowedSlots set [count _allowedSlots, _x];
			};
		} forEach _allowedContainers;
	};
};

_uniformFree = 0;
_vestFree = 0;
_backpackFree = 0;

_uniform = uniform _player;
_vest = vest _player;
_backpack = backpack _player;

if (_uniform != "" && {isNil "_allowedSlots" || {701 in _allowedSlots}}) then
{
	_containerClass = getText (configFile >> "CfgWeapons" >> _uniform >> "ItemInfo" >> "containerClass");
	_uniformCapacity = getNumber (configFile >> "CfgVehicles" >> _containerClass >> "maximumLoad");
	_uniformFree = _uniformCapacity - ((loadUniform _player) * _uniformCapacity);
};

if (_vest != "" && {isNil "_allowedSlots" || {801 in _allowedSlots}}) then
{
	_containerClass = getText (configFile >> "CfgWeapons" >> _vest >> "ItemInfo" >> "containerClass");
	_vestCapacity = getNumber (configFile >> "CfgVehicles" >> _containerClass >> "maximumLoad");
	_vestFree = _vestCapacity - ((loadVest _player) * _vestCapacity);
};

if (_backpack != "" && {isNil "_allowedSlots" || {901 in _allowedSlots}}) then
{
	_backpackCapacity = getNumber (configFile >> "CfgVehicles" >> _backpack >> "maximumLoad");
	_backpackFree = _backpackCapacity - ((loadBackpack _player) * _backpackCapacity);
};

_itemSize = getNumber (configFile >> "CfgWeapons" >> _item >> "ItemInfo" >> "mass");
if (_itemSize == 0) then { _itemSize = getNumber (configFile >> "CfgMagazines" >> _item >> "mass") };
if (_itemSize == 0) then { _itemSize = getNumber (configFile >> "CfgWeapons" >> _item >> "WeaponSlotsInfo" >> "mass") };

if (isClass (configFile >> "CfgWeapons" >> _item >> "LinkedItems")) then
{
	private ["_cfgItems", "_cfgItem"];
	_cfgItems = configFile >> "CfgWeapons" >> _item >> "LinkedItems";
	
	for "_i" from 0 to (count _cfgItems - 1) do
	{
		_cfgItem = getText ((_cfgItems select _i) >> "item");
		_itemSize = _itemSize + getNumber (configFile >> "CfgWeapons" >> _cfgItem >> "ItemInfo" >> "mass");	
	};
};

// Return boolean

(_itemSize > 0 && {_itemSize <= _uniformFree || _itemSize <= _vestFree || _itemSize <= _backpackFree})
