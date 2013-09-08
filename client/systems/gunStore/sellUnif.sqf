
//	@file Version: 1.0
//	@file Name: sellUniform.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, AgentRev
//	@file Created: 20/08/2013 00:29
//	@file Args:

if (!isNil "storeSellingActive" && {typeName storeSellingActive == typeName true} && {storeSellingActive}) exitWith {};

//Initialize Values
private ["_uniform", "_tempUniform", "_sellValue", "_allUniformItems", "_uniformItems", "_uniformMags", "_item", "_itemName", "_itemValue", "_itemsToSell", "_itemAdded", "_magazines", "_mag", "_magAmmo", "_magFullAmmo", "_magValue", "_confirmMsg"];

_uniform = uniform player;
if (_uniform == "") exitWith { hint "You don't have a uniform to sell!" };

if (isNil "storeSellingActive" || {typeName storeSellingActive != typeName {}}) then { storeSellingActive = true };

_sellValue = 25;

if ([["U_B_CombatUniform_mcam","U_O_CombatUniform_ocamo","U_I_CombatUniform"], _uniform] call fn_findString == -1) then
{
	switch (true) do
	{
		case (["GhillieSuit", _uniform] call fn_findString != -1): { _tempUniform = "U_I_GhillieSuit" };
		case (["Wetsuit", _uniform] call fn_findString != -1): { _tempUniform = "U_I_Wetsuit" };
		default { _tempUniform = _uniform };
	};
	
	systemChat _tempUniform;
	
	{
		if (_x select 1 == _tempUniform) then
		{
			_sellValue = (ceil (((_x select 2) / 2) / 5)) * 5;
		};
	} forEach (call accessoriesArray);
};

// if(isNil {_sellValue}) exitWith {hint "The store does not want this item."};

_allUniformItems = uniformItems player;
_uniformItems = + _allUniformItems;
_uniformMags = [];

{
	if (_x select 4 == "Uniform") then
	{
		_uniformItems = _uniformItems - [_x select 0];
		_uniformMags set [count _uniformMags, [_x select 0, _x select 1]];
	};
} forEach magazinesAmmoFull player;

{
	_item = _x;
	_itemValue = 10;
	
	{
		if (_x select 1 == _item) exitWith
		{
			_itemValue = (ceil (((_x select 2) / 2) / 5)) * 5;
		};
	} forEach (call allGunStoreItems);
	
	_sellValue = _sellValue + _itemValue;
	
} forEach _uniformItems;

{
	_mag = _x select 0;
	_magAmmo = _x select 1;
	_magFullAmmo = getNumber (configFile >> "CfgMagazines" >> _mag >> "count");
	_magValue = 10;
	
	{
		if (_x select 1 == _mag) exitWith
		{
			_magValue = (ceil ((((_x select 2) * (_magAmmo / _magFullAmmo)) / 2) / 5)) * 5;
		};
	} forEach (call ammoArray);
	
	_sellValue = _sellValue + _magValue;
	
} forEach _uniformMags;

_itemsToSell = [];

{
	_item = _x;
	_itemAdded = false;
	
	{
		if (_x select 0 == _item) exitWith
		{
			_itemsToSell set [_forEachIndex, [_x select 0, (_x select 1) + 1, _x select 2]];
			_itemAdded = true;
		};
	} forEach _itemsToSell;
	
	if (!_itemAdded) then
	{
		_itemName = getText (configFile >> "CfgWeapons" >> _item >> "displayName");
		if (_itemName == "") then { _itemName = getText (configFile >> "CfgMagazines" >> _item >> "displayName") };
		
		_itemsToSell set [count _itemsToSell, [_item, 1, _itemName]];
	};
} forEach _allUniformItems;

_confirmMsg = "<t font='EtelkaMonospaceProBold'>1</t> x " + getText (configFile >> "CfgWeapons" >> _uniform >> "displayName");

{
	_item = _x select 0;
	_itemQty = _x select 1;
	_itemName = _x select 2;
	
	_confirmMsg = _confirmMsg + "<br/>" + format ["<t font='EtelkaMonospaceProBold'>%1</t> x ", _itemQty] + _itemName;
	
} forEach _itemsToSell;

_confirmMsg = format ["You will obtain $%1 for:<br/><br/>", _sellValue] + _confirmMsg;

if ([parseText _confirmMsg, "Confirm", "Sell", true] call BIS_fnc_guiMessage) then
{
	removeUniform player;

	player setVariable ["cmoney", (player getVariable ["cmoney", 0]) + _sellValue, true];
	hint format["You sold your uniform for $%1", _sellValue];
};

if (isNil "storeSellingActive" || {typeName storeSellingActive != typeName {}}) then { storeSellingActive = false };
