//	@file Version: 1.0
//	@file Name: sellCrateItems.sqf
//	@file Author: AgentRev
//	@file Created: 31/12/2013 22:12
//	@file Args:

if (!isNil "storeSellingHandle" && {typeName storeSellingHandle == "SCRIPT"} && {!scriptDone storeSellingHandle}) exitWith {hint "Please wait, your previous sale is being processed"};

_crate = missionNamespace getVariable ["R3F_LOG_joueur_deplace_objet", objNull];

if !(_crate isKindOf "ReammoBox_F") then
{
	hint "You aren't holding a valid crate!";
}
else
{
	storeSellingHandle = _crate spawn
	{
		private ["_getHalfPrice", "_cargoToPairs", "_crate", "_sellValue", "_crateItems", "_allStoreItems", "_item", "_itemClass", "_itemQty", "_itemValue", "_itemName", "_confirmMsg"];

		_getHalfPrice = 
		{
			((ceil ((_this / 2) / 5)) * 5) // Ceil half the value to the nearest multiple of 5
		};
		
		_cargoToPairs =
		{
			// Example: converts [["a","b","c"],[1,2,3]] to [["a",1],["b",2],["c",3]]
			private "_array";
			_array = [];
			
			if (count _this > 1) then
			{
				{
					_array set [count _array, [_x, (_this select 1) select _forEachIndex]];
				} forEach (_this select 0);
			};
			
			_array
		};
		
		_crate = _this;
		_sellValue = 0;
		
		// Get all the items into a single array		
		_crateItems = (getWeaponCargo _crate) call _cargoToPairs;
		[_crateItems, (getMagazineCargo _crate) call _cargoToPairs] call BIS_fnc_arrayPushStack;
		[_crateItems, (getItemCargo _crate) call _cargoToPairs] call BIS_fnc_arrayPushStack;
		
		if (count _crateItems == 0) exitWith
		{
			["This crate does not contain any valid items to sell.", "Error"] call BIS_fnc_guiMessage;
		};
		
		_allStoreItems = [call allRegularStoreItems, call ammoArray] call BIS_fnc_arrayPushStack;
		
		// Add value of each item to sell value, and acquire item display name
		{
			_item = _x;
			_itemClass = _x select 0;
			_itemQty = _x select 1;
			_itemValue = 10;
			
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
			_crateItems set [_forEachIndex, _item];
			
		} forEach _crateItems;
		
		// Add total sell value to confirm message
		_confirmMsg = format ["You will obtain $%1 for:<br/>", _sellValue];

		// Add item quantities and names to confirm message
		{
			_item = _x select 0;
			_itemQty = _x select 1;
			_itemName = _x select 2;
			
			_confirmMsg = _confirmMsg + format ["<br/><t font='EtelkaMonospaceProBold'>%1</t> x %2", _itemQty, _itemName];
			
		} forEach _crateItems;

		// Display confirmation
		if ([parseText _confirmMsg, "Confirm", "Sell", true] call BIS_fnc_guiMessage) then
		{
			clearMagazineCargoGlobal _crate;
			clearWeaponCargoGlobal _crate;
			clearItemCargoGlobal _crate;

			player setVariable ["cmoney", (player getVariable ["cmoney", 0]) + _sellValue, true];
			hint format ["You sold the crate items for $%1", _sellValue];
		};
	};
	
	if (typeName storeSellingHandle == "SCRIPT") then
	{
		private "_storeSellingHandle";
		_storeSellingHandle = storeSellingHandle;
		waitUntil {scriptDone _storeSellingHandle};
	};
	
	storeSellingHandle = nil;
};
