//	@file Version: 1.0
//	@file Name: sellCrateItems.sqf
//	@file Author: AgentRev
//	@file Created: 31/12/2013 22:12
//	@file Args:

#define PRICE_DEBUGGING false

if (!isNil "storeSellingHandle" && {typeName storeSellingHandle == "SCRIPT"} && {!scriptDone storeSellingHandle}) exitWith {hint "Please wait, your previous sale is being processed"};

_params = [_this, 3, [], [[]]] call BIS_fnc_param;
_storeSellBox = [_params, 0, false, [false]] call BIS_fnc_param;
_forceSell = [_params, 1, false, [false]] call BIS_fnc_param;

_crate = if (_storeSellBox) then
{
	[_this, 0, objNull, [objNull]] call BIS_fnc_param
}
else
{
	missionNamespace getVariable ["R3F_LOG_joueur_deplace_objet", objNull]
};

/*if !(_crate isKindOf "ReammoBox_F") then
{
	hint "You aren't holding a valid crate!";
}
else
{*/
	storeSellingHandle = [_crate, _forceSell] spawn
	{
		private ["_getHalfPrice", "_crate", "_forceSell", "_sellValue", "_crateItems", "_crateMags", "_crateWeapons", "_weaponArray", "_class", "_container", "_allStoreMagazines", "_allRegularStoreItems", "_allStoreItems", "_weaponEntry", "_weaponCfg", "_parentCfg", "_found", "_cfgItems", "_allCrateItems", "_item", "_itemClass", "_itemQty", "_itemValue", "_itemQtyArr", "_cfgCategory", "_magFullAmmo", "_magFullPrice", "_magValue", "_itemName", "_objectName", "_confirmMsg", "_clearing"];

		_getHalfPrice =
		{
			((ceil ((_this / 2) / 5)) * 5) // Ceil half the value to the nearest multiple of 5
		};

		_crate = _this select 0;
		_forceSell = _this select 1;
		_sellValue = 0;

		// Get all the items

		_crateItems = (getItemCargo _crate) call cargoToPairs;

		_crateMags = [];
		{
			[_crateMags, _x select 0, [_x select 1]] call fn_addToPairs;
		} forEach magazinesAmmoCargo _crate;

		_crateWeapons = [];
		{
			_weaponArray = _x call splitWeaponItems;
			[_crateWeapons, _weaponArray select 0, 1] call fn_addToPairs;
			{ [_crateItems, _x, 1] call fn_addToPairs } forEach (_weaponArray select 1);
			{ [_crateMags, _x select 0, [_x select 1]] call fn_addToPairs } forEach (_weaponArray select 2);
		} forEach weaponsItemsCargo _crate;

		// Add stuff contained in uniforms, vest, and backpacks inside the object to the main arrays
		{
			_class = _x select 0;
			_container = _x select 1;

			[_crateItems, _class, 1] call fn_addToPairs;

			{
				[_crateItems, _x select 0, _x select 1] call fn_addToPairs;
			} forEach ((getItemCargo _container) call cargoToPairs);

			{
				[_crateMags, _x select 0, [_x select 1]] call fn_addToPairs;
			} forEach magazinesAmmoCargo _container;

			{
				_weaponArray = _x call splitWeaponItems;
				[_crateWeapons, _weaponArray select 0, 1] call fn_addToPairs;
				{ [_crateItems, _x, 1] call fn_addToPairs } forEach (_weaponArray select 1);
				{ [_crateMags, _x select 0, [_x select 1]] call fn_addToPairs } forEach (_weaponArray select 2);
			} forEach weaponsItemsCargo _container;
		} forEach everyContainer _crate;

		_allStoreMagazines = call allStoreMagazines;
		_allRegularStoreItems = call allRegularStoreItems;
		_allStoreItems = _allRegularStoreItems + call allStoreGear;

		// Find parent equivalents to weapons which aren't listed in the gunstore
		{
			_weaponEntry = _x;
			_weaponCfg = configFile >> "CfgWeapons" >> (_weaponEntry select 0);
			_parentCfg = _weaponCfg;
			_found = false;

			while {!_found && isClass _parentCfg && {getText (_weaponCfg >> "model") == getText (_parentCfg >> "model")}} do
			{
				{
					if (_x select 1 == configName _parentCfg) exitWith
					{
						_found = true;
					};
				} forEach _allRegularStoreItems;

				if (!_found) then
				{
					_parentCfg = inheritsFrom _parentCfg;
				};
			};

			if (_parentCfg != _weaponCfg) then
			{
				_crateWeapons set [_forEachIndex, [_weaponEntry select 0, 0]];

				if (_found) then
				{
					[_crateWeapons, configName _parentCfg, _weaponEntry select 1] call fn_addToPairs;
				};
			};
		} forEach (+_crateWeapons);

		// Combine all items in new array
		_allCrateItems = [];
		[_allCrateItems, _crateWeapons] call BIS_fnc_arrayPushStack;
		[_allCrateItems, _crateMags] call BIS_fnc_arrayPushStack;
		[_allCrateItems, _crateItems] call BIS_fnc_arrayPushStack;

		if (count _allCrateItems == 0) exitWith
		{
			if (!_forceSell) then
			{
				playSound "FD_CP_Not_Clear_F";
				["This object does not contain valid items to sell.", "Error"] call BIS_fnc_guiMessage;
			};
		};

		// Add value of each item to sell value, and acquire item display name
		{
			_item = _x;
			_itemClass = _x select 0;
			_itemQty = _x select 1;
			_itemQtyArr = nil;
			_itemValue = 10;

			if (typeName _itemQty == "ARRAY") then
			{
				_itemQtyArr = _itemQty;
				_itemQty = count _itemQty;
			};

			if (_itemQty > 0) then
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

					{
						_magValue = (_itemValue * (_x / _magFullAmmo)) call _getHalfPrice; // Get selling price relative to ammo count
						_sellValue = _sellValue + _magValue;
					} forEach _itemQtyArr;

					_item set [1, _itemQty];
				}
				else
				{
					{
						if (_x select 1 == _itemClass) exitWith
						{
							_itemValue = ((_x select 2) * _itemQty) call _getHalfPrice;
						};
					} forEach _allStoreItems;

					_sellValue = _sellValue + _itemValue;
				};

				_itemName = getText (configFile >> _cfgCategory >> _itemClass >> "displayName");

				_item set [2, _itemName];
				if (PRICE_DEBUGGING) then { _item set [3, _itemValue] };
				_allCrateItems set [_forEachIndex, _item];
			};
		} forEach _allCrateItems;

		_objectName = getText (configFile >> "CfgVehicles" >> typeOf _crate >> "displayName");

		if (_forceSell) then
		{
			clearBackpackCargoGlobal _crate;
			clearMagazineCargoGlobal _crate;
			clearWeaponCargoGlobal _crate;
			clearItemCargoGlobal _crate;

			player setVariable ["cmoney", (player getVariable ["cmoney", 0]) + _sellValue, true];
			hint format [format ['The inventory of "%1" was sold for $%2', _objectName, _sellValue]];
			playSound "FD_Finish_F";
		}
		else
		{
			// Add total sell value to confirm message
			_confirmMsg = format ["You will obtain $%1 for:<br/>", _sellValue];

			// Add item quantities and names to confirm message
			{
				_item = _x select 0;
				_itemQty = _x select 1;

				if (_itemQty > 0 && {count _x > 2}) then
				{
					_itemName = _x select 2;

					_confirmMsg = _confirmMsg + format ["<br/><t font='EtelkaMonospaceProBold'>%1</t> x %2%3", _itemQty, _itemName, if (PRICE_DEBUGGING) then { format [" ($%1)", _x select 3] } else { "" }];
				};

			} forEach _allCrateItems;

			// Display confirmation
			if ([parseText _confirmMsg, "Confirm", "Sell", true] call BIS_fnc_guiMessage) then
			{
				// Have to spawn clearing commands due to mysterious crash-to-desktop...
				_clearing = _crate spawn
				{
					clearBackpackCargoGlobal _this;
					clearMagazineCargoGlobal _this;
					clearWeaponCargoGlobal _this;
					clearItemCargoGlobal _this;
				};

				waitUntil {scriptDone _clearing};

				player setVariable ["cmoney", (player getVariable ["cmoney", 0]) + _sellValue, true];
				hint format ['You sold the inventory of "%1" for $%2', _objectName, _sellValue];
				playSound "FD_Finish_F";
			};
		};
	};

	if (typeName storeSellingHandle == "SCRIPT") then
	{
		private "_storeSellingHandle";
		_storeSellingHandle = storeSellingHandle;
		waitUntil {scriptDone _storeSellingHandle};
	};

	storeSellingHandle = nil;
//};
