//	@file Version: 1.0
//	@file Name: sellWeapon.sqf
//	@file Author: AgentRev
//	@file Created: 20/11/2013 05:13
//	@file Args:

if (!isNil "storeSellingHandle" && {typeName storeSellingHandle == "SCRIPT"} && {!scriptDone storeSellingHandle}) exitWith {hint "Please wait, your previous sale is being processed"};

if (currentWeapon player == "") then
{
	hint "You currently don't have a weapon in your hands to sell!";
}
else
{
	storeSellingHandle = [] spawn
	{
		private ["_primary", "_muzzle", "_sellValue", "_getHalfPrice", "_weaponMags", "_magazines", "_currMag", "_currMagAmmo", "_mag", "_magAmmo", "_magFullAmmo", "_magValue", "_magAdded", "_magsToSell", "_confirmMsg", "_wepItems", "_wepItem", "_itemName", "_itemValue", "_magQty"];

		_primary = currentWeapon player;
		_muzzle = currentMuzzle player;
		_sellValue = 50; // This is the default value for items that aren't listed in the store
		_magsToSell = [];
		
		_getHalfPrice = 
		{
			((ceil ((_this / 2) / 5)) * 5) // Ceil half the value to the nearest multiple of 5
		};
		
		// Calculating weapon sell value
		{
			if (_x select 1 == _primary) exitWith
			{
				_sellValue = (_x select 2) call _getHalfPrice;
			};
		} forEach (call allGunStoreFirearms);

		_weaponMags = if (_primary != _muzzle) then {
			getArray (configFile >> "CfgWeapons" >> _primary >> _muzzle >> "magazines")
		} else {
			getArray (configFile >> "CfgWeapons" >> _primary >> "magazines")
		};
		_magazines = magazinesAmmo player;
		_currMag = currentMagazine player;
		
		if (isNil "_currMag") then { _currMag = "" };

		// If a magazine is loaded in the weapon, add its value to sell value based on ammo count, and add value of each identical magazine in inventory to sell value, also based on ammo count
		// TODO: Add value of magazine loaded in other muzzle if present (e.g. grenade in grenade launcher)
		if (_currMag != "") then
		{
			_currMagAmmo = player ammo _primary;
			
			_magazines set [count _magazines, [_currMag, _currMagAmmo]];
			
			_magFullAmmo = getNumber (configFile >> "CfgMagazines" >> _currMag >> "count");
			_magValue = 10;
			
			{
				if (_x select 1 == _currMag) exitWith
				{
					_magValue = _x select 2;
				};
			} forEach (call ammoArray);
			
			_currMag = _currMag call getBallMagazine;

			{
				_mag = _x select 0;
				_magAmmo = _x select 1;
				
				if (_mag call getBallMagazine == _currMag) then
				{
					_sellValue = _sellValue + ((_magValue * (_magAmmo / _magFullAmmo)) call _getHalfPrice); // Get selling price relative to ammo count
					
					_magAdded = false;
					
					{
						if (_x select 0 == _mag) exitWith
						{
							_magsToSell set [_forEachIndex, [_x select 0, (_x select 1) + 1]];
							_magAdded = true;
						};
					} forEach _magsToSell;
					
					if (!_magAdded) then
					{
						_magsToSell set [count _magsToSell, [_mag, 1]];
					};
				};
			} forEach _magazines;
		};

		// Add total sell value to confirm message
		_confirmMsg = format ["You will obtain $%1 for:<br/><br/>", _sellValue];
		
		// Add weapon name to confirm message
		_confirmMsg = _confirmMsg + format ["<t font='EtelkaMonospaceProBold'>1</t> x %1", getText (configFile >> "CfgWeapons" >> _primary >> "displayName")];

		switch (true) do
		{
			case ([_primary, 1] call isWeaponType): { _wepItems = primaryWeaponItems player };
			case ([_primary, 2] call isWeaponType): { _wepItems = handgunItems player };
			case ([_primary, 4] call isWeaponType): { _wepItems = secondaryWeaponItems player };
			default                                 { _wepItems = [] };
		};

		// Add weapon attachment names to confirm message
		{
			if (_x != "") then
			{
				_wepItem = _x;
				_itemName = getText (configFile >> "CfgWeapons" >> _wepItem >> "displayName");
				_itemValue = 25;
				
				{
					if (_x select 1 == _wepItem) exitWith
					{
						_itemName = _x select 0;
						_itemValue = (_x select 2) call _getHalfPrice;
					};
				} forEach (call accessoriesArray);
				
				_sellValue = _sellValue + _itemValue;
				_confirmMsg = _confirmMsg + "<br/><t font='EtelkaMonospaceProBold'>1</t> x " + _itemName;
			};	
		} forEach _wepItems;

		// Add magazine quantities and names to confirm message
		{
			_mag = _x select 0;
			_magQty = _x select 1;
			
			_confirmMsg = _confirmMsg + format ["<br/><t font='EtelkaMonospaceProBold'>%1</t> x ", _magQty] + getText (configFile >> "CfgMagazines" >> _mag >> "displayName");
			
		} forEach _magsToSell;

		// Add note about removing weapon mag if the player doesn't want to sell inventory mags
		if (_currMag != "") then
		{
			_confirmMsg = _confirmMsg + "<br/><br/>If you don't want to sell your ammo, simply remove the magazine from your weapon.";
		};

		// Display confirmation
		if ([parseText _confirmMsg, "Confirm", "Sell", true] call BIS_fnc_guiMessage) then
		{
			// Remove weapon if sale confirmed by player
			player removeWeapon _primary;
			
			// Remove magazines identical to loaded mag from inventory
			{
				if (_x call getBallMagazine == _currMag) then
				{
					player removeMagazines _x;
				};
			} forEach _weaponMags;

			player setVariable ["cmoney", (player getVariable ["cmoney", 0]) + _sellValue, true];
			hint format ["You sold your gun for $%1", _sellValue];
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
