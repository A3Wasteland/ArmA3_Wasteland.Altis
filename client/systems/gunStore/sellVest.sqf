//	@file Version: 1.0
//	@file Name: sellVest.sqf
//	@file Author: AgentRev
//	@file Created: 20/08/2013 00:29
//	@file Args:

if (!isNil "storeSellingHandle" && {typeName storeSellingHandle == "SCRIPT"} && {!scriptDone storeSellingHandle}) exitWith {hint "Please wait, your previous sale is being processed"};

if (vest player == "") then
{
	hint "You don't have a vest to sell!";
}
else
{
	storeSellingHandle = [] spawn
	{
		private ["_vest", "_tempVest", "_sellValue", "_allVestItems", "_vestItems", "_vestMags", "_item", "_itemName", "_itemValue", "_itemsToSell", "_itemAdded", "_magazines", "_mag", "_magAmmo", "_magFullAmmo", "_magValue", "_confirmMsg"];

		_vest = vest player;
		_sellValue = 25; // This is the default value for items that aren't listed in the store

		// This switch is to convert team-specific items to a common item in the store (example: U_O_Wetsuit and U_I_Wetsuit are represented by U_B_Wetsuit)
		switch (true) do
		{
			case (["Rebreather", _vest] call fn_findString != -1): { _tempVest = "V_RebreatherB" };
			default { _tempVest = _vest };
		};
		
		// Calculate vest sell value
		{
			if (_x select 1 == _tempVest) then
			{
				_sellValue = (ceil (((_x select 2) / 2) / 5)) * 5; // Ceil half the value to the nearest factor of 5
			};
		} forEach (call gearArray);
		
		_allVestItems = vestItems player;
		_vestItems = + _allVestItems;
		_vestMags = [];

		// Collect vest magazine types and ammo counts
		{
			if (_x select 4 == "Vest") then
			{
				_vestItems = _vestItems - [_x select 0];
				_vestMags set [count _vestMags, [_x select 0, _x select 1]];
			};
		} forEach magazinesAmmoFull player;

		// Add value of each non-mag vest item to sell value
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
			
		} forEach _vestItems;

		// Add value of each vest magazine to sell value, based on ammo count
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
			
		} forEach _vestMags;

		_itemsToSell = [];

		// Count items of same type, and acquire item display name
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
		} forEach _allVestItems;
		
		// Add total sell value to confirm message
		_confirmMsg = format ["You will obtain $%1 for:<br/><br/>", _sellValue];

		// Add uniform name to confirm message
		_confirmMsg = _confirmMsg + format ["<t font='EtelkaMonospaceProBold'>1</t> x %1", getText (configFile >> "CfgWeapons" >> _vest >> "displayName")];

		// Add item quantities and names to confirm message
		{
			_item = _x select 0;
			_itemQty = _x select 1;
			_itemName = _x select 2;
			
			_confirmMsg = _confirmMsg + format ["<br/><t font='EtelkaMonospaceProBold'>%1</t> x %2", _itemQty, _itemName];
			
		} forEach _itemsToSell;

		// Display confirmation
		if ([parseText _confirmMsg, "Confirm", "Sell", true] call BIS_fnc_guiMessage) then
		{
			// Remove vest if sale confirmed by player
			removeVest player;

			player setVariable ["cmoney", (player getVariable ["cmoney", 0]) + _sellValue, true];
			hint format ["You sold your vest for $%1", _sellValue];
		};
	};
	
	private "_storeSellingHandle";
	_storeSellingHandle = storeSellingHandle;
	waitUntil {scriptDone _storeSellingHandle};
	
	storeSellingHandle = nil;
};
