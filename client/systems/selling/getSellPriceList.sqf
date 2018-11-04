// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: getSellPriceList.sqf
//	@file Author: AgentRev

// Returns an array in the format:
// _x select 0 = Class
// _x select 1 = Quantity
// _x select 2 = Name
// _x select 3 = Value

#define GET_HALF_PRICE(PRICE) ((ceil (((PRICE) / 2) / 5)) * 5)

private ["_obj", "_sellValue", "_objItems", "_objMags", "_objWeapons", "_weaponArray", "_class", "_container", "_allStoreMagazines", "_allGunStoreFirearms", "_allStoreItems", "_weaponEntry", "_weaponClass", "_weaponQty", "_weaponCfg", "_weaponCfgModel", "_masterCfg", "_found", "_cfgItems", "_allObjItems", "_item", "_itemClass", "_itemQty", "_itemValue", "_itemQtyArr", "_cfgCategory", "_magFullAmmo", "_magFullPrice", "_magValue", "_itemName"];

_obj = _this;
if (isNull _obj) exitWith { [] };

_sellValue = 0;
//_objItems = [];

/*
_objItems = (getItemCargo _obj) call cargoToPairs;

_objMags = [];
{
	[_objMags, _x select 0, [_x select 1]] call fn_addToPairs;
} forEach magazinesAmmoCargo _obj;

_objWeapons = [];
{
	_weaponArray = _x call splitWeaponItems;
	[_objWeapons, _weaponArray select 0, 1] call fn_addToPairs;
	{ [_objItems, _x, 1] call fn_addToPairs } forEach (_weaponArray select 1);
	{ [_objMags, _x select 0, [_x select 1]] call fn_addToPairs } forEach (_weaponArray select 2);
} forEach weaponsItemsCargo _obj;
*/

// Add stuff contained in uniforms, vest, and backpacks inside the object to the main arrays
/*private _scanContainer =
{
	private "_x";
	if (isNil "_x") then { _x = _this };
	_x params ["_class", "_container"];

	// only add backpacks, since uniforms and vests already in _objItems via getItemCargo
	if (_class isKindOf "Bag_Base") then
	{
		[_objItems, _class, 1] call fn_addToPairs;
	};

	if (_objItems isEqualTo []) then 
	{
		_objItems = (getItemCargo _container) call cargoToPairs;
	}
	else
	{
		{
			[_objItems, _x select 0, _x select 1] call fn_addToPairs;
		} forEach ((getItemCargo _container) call cargoToPairs);
	};

	{
		[_objMags, _x select 0, [_x select 1]] call fn_addToPairs;
	} forEach magazinesAmmoCargo _container;

	{
		_weaponArray = _x call splitWeaponItems;
		[_objWeapons, _weaponArray select 0, 1] call fn_addToPairs;
		{ [_objItems, _x, 1] call fn_addToPairs } forEach (_weaponArray select 1);
		{ [_objMags, _x select 0, [_x select 1]] call fn_addToPairs } forEach (_weaponArray select 2);
	} forEach weaponsItemsCargo _container;

	_scanContainer forEach everyContainer _obj;
};

["", _obj] call _scanContainer;*/

(_obj call fn_containerCargoToPairs) params ["_objWeapons", "_objMags", "_objItems", "_objBackpacks"];

_allStoreMagazines = call allStoreMagazines;
_allGunStoreFirearms = call allGunStoreFirearms + call genItemArray;
_allStoreItems = call allRegularStoreItems + call allStoreGear;

// Find parent or children equivalents to weapons which aren't listed in the gunstore
{
	_weaponEntry = _x;
	_weaponClass = _weaponEntry select 0;
	_weaponQty = _weaponEntry select 1;

	_weaponCfg = configFile >> "CfgWeapons" >> _weaponClass;
	_weaponCfgModel = getText (_weaponCfg >> "model");
	_masterCfg = _weaponCfg;
	_found = false;

	// Parents
	while {!_found && isClass _masterCfg && {getText (_masterCfg >> "model") == _weaponCfgModel}} do
	{
		{
			if (_x select 1 == configName _masterCfg) exitWith
			{
				_found = true;
			};
		} forEach _allGunStoreFirearms;

		if (!_found) then
		{
			_masterCfg = inheritsFrom _masterCfg;
		};
	};

	// Children
	if (!_found) then
	{
		{
			_masterCfg = configFile >> "CfgWeapons" >> (_x select 1);

			if (configName inheritsFrom _masterCfg == _weaponClass) exitWith
			{
				_found = true;
			};
		} forEach _allGunStoreFirearms;
	};

	if (_masterCfg != _weaponCfg) then
	{
		_objWeapons set [_forEachIndex, [_weaponClass, 0]];

		if (_found) then
		{
			[_objWeapons, configName _masterCfg, _weaponQty] call fn_addToPairs;
		};
	};
} forEach (+_objWeapons);

// Combine all items in new array
_allObjItems = [];
_allObjItems append _objWeapons;
_allObjItems append _objMags;
_allObjItems append _objItems;
_allObjItems append _objBackpacks;

// Add value of each item to sell value, and acquire item display name
{
	_item = _x;
	_item params ["_itemClass", "_itemQty", ["_magsAmmo",[]]];
	_itemValue = 10;
	_sellValue = 0;

	if (_itemQty > 0 || count _magsAmmo > 0) then
	{
		_cfgCategory = switch (true) do
		{
			case (isClass (configFile >> "CfgWeapons" >> _itemClass)):   { "CfgWeapons" };
			case (isClass (configFile >> "CfgMagazines" >> _itemClass)): { "CfgMagazines" };
			case (isClass (configFile >> "CfgGlasses" >> _itemClass)):   { "CfgGlasses" };
			default                                                      { "CfgVehicles" };
		};

		if (_cfgCategory == "CfgMagazines") then
		{
			_magFullAmmo = getNumber (configFile >> "CfgMagazines" >> _itemClass >> "count");

			{
				if (_x select 1 == _itemClass) exitWith
				{
					_itemValue = _x select 2;
				};
			} forEach _allStoreMagazines;

			_sellValue = _sellValue + GET_HALF_PRICE(_itemValue * _itemQty); // full mags

			{
				_sellValue = _sellValue + GET_HALF_PRICE(_itemValue * (_x / _magFullAmmo)); // partial mags
			} forEach _magsAmmo;

			_item set [1, _itemQty + count _magsAmmo]; // readjust total count before displaying to user
		}
		else
		{
			{
				if (_x select 1 == _itemClass) exitWith
				{
					_itemValue = GET_HALF_PRICE((_x select 2) * _itemQty);
				};
			} forEach _allStoreItems;

			_sellValue = _sellValue + _itemValue;
		};

		_itemName = getText (configFile >> _cfgCategory >> _itemClass >> "displayName");

		_item set [2, _itemName];
		_item set [3, [_itemValue, _sellValue] select (_sellValue > 0)];
	};
} forEach _allObjItems;

{
	_x params ["_itemName", "_itemClass", "", "", "", "_sellValue"];
	_itemQty = [_obj getVariable _itemClass] param [0,0,[0]];
	if (_itemQty > 0) then
	{
		_allObjItems pushBack [_itemClass, _itemQty, _itemName, _sellValue];
	};
} forEach call customPlayerItems;

_allObjItems
