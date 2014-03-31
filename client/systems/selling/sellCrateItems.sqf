//	@file Version: 1.0
//	@file Name: sellCrateItems.sqf
//	@file Author: AgentRev
//	@file Created: 31/12/2013 22:12
//	@file Args:

#define PRICE_DEBUGGING false

if (!isNil "storeSellingHandle" && {typeName storeSellingHandle == "SCRIPT"} && {!scriptDone storeSellingHandle}) exitWith {hint "Please wait, your previous sale is being processed"};

_crate = missionNamespace getVariable ["R3F_LOG_joueur_deplace_objet", objNull];

/*if !(_crate isKindOf "ReammoBox_F") then
{
	hint "You aren't holding a valid crate!";
}
else
{*/
	storeSellingHandle = _crate spawn
	{
		private ["_getHalfPrice", "_crate", "_sellValue", "_crateItems", "_allStoreItems", "_weaponEntry", "_weaponCfg", "_parentCfg", "_found", "_cfgItems", "_allCrateItems", "_item", "_itemClass", "_itemQty", "_itemValue", "_itemName", "_confirmMsg"];

		_getHalfPrice = 
		{
			((ceil ((_this / 2) / 5)) * 5) // Ceil half the value to the nearest multiple of 5
		};
		
		_crate = _this;
		_sellValue = 0;
		
		// Get all the items
		_crateWeapons = (getWeaponCargo _crate) call cargoToPairs;
		_crateMags = (getMagazineCargo _crate) call cargoToPairs;
		_crateItems = (getItemCargo _crate) call cargoToPairs;
		
		_allStoreItems = [call allRegularStoreItems, call ammoArray] call BIS_fnc_arrayPushStack;
		
		// Find parent equivalents to weapons which aren't listed in the gunstore, and add possible attachments to crate items array
		{
			_weaponEntry = _x;
			_weaponCfg = configFile >> "CfgWeapons" >> (_weaponEntry select 0);
			_parentCfg = _weaponCfg;
			_found = false;
			
			while {!_found && {isClass _parentCfg} && {getText (_weaponCfg >> "model") == getText (_parentCfg >> "model")}} do
			{
				{
					if (_x select 1 == configName _parentCfg) exitWith
					{
						_found = true;
					};
				} forEach _allStoreItems;
				
				if (!_found) then
				{
					_parentCfg = inheritsFrom _parentCfg;
				};
			};
			
			if (_found && {isClass (_weaponCfg >> "LinkedItems")}) then
			{
				_cfgItems = _weaponCfg >> "LinkedItems";
				
				for "_i" from 0 to (count _cfgItems - 1) do
				{
					[_crateItems, getText ((_cfgItems select _i) >> "item"), 1] call BIS_fnc_addToPairs;
				};
			};
			
			if (_parentCfg != _weaponCfg) then
			{
				_crateWeapons set [_forEachIndex, [_weaponEntry select 0, 0]]; // I wanted to use BIS_fnc_removeFromPairs but is not implemented yet :(
				
				if (_found) then
				{
					[_crateWeapons, configName _parentCfg, _weaponEntry select 1] call BIS_fnc_addToPairs;
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
			playSound "FD_CP_Not_Clear_F";
			["This object does not contain valid items to sell.", "Error"] call BIS_fnc_guiMessage;
		};
		
		// Add value of each item to sell value, and acquire item display name
		{
			_item = _x;
			_itemClass = _x select 0;
			_itemQty = _x select 1;
			_itemValue = 10;
			
			if (_itemQty > 0) then
			{
				{
					if (_x select 1 == _itemClass) exitWith
					{
						_itemValue = ((_x select 2) * _itemQty) call _getHalfPrice;
					};
				} forEach _allStoreItems;
				
				_sellValue = _sellValue + _itemValue;
				
				if (isClass (configFile >> "CfgWeapons" >> _itemClass)) then
				{
					_itemName = getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName");
				}
				else
				{
					_itemName = getText (configFile >> "CfgMagazines" >> _itemClass >> "displayName");
				};
				
				_item set [2, _itemName];
				if (PRICE_DEBUGGING) then { _item set [3, _itemValue] };
				_allCrateItems set [_forEachIndex, _item];
			};
		} forEach _allCrateItems;
		
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
			clearMagazineCargoGlobal _crate;
			clearWeaponCargoGlobal _crate;
			clearItemCargoGlobal _crate;

			player setVariable ["cmoney", (player getVariable ["cmoney", 0]) + _sellValue, true];
			hint format ["You sold the contents for $%1", _sellValue];
			playSound "FD_Finish_F";
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
