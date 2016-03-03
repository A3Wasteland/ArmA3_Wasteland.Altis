// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: sellWeapon.sqf
//	@file Author: AgentRev
//	@file Created: 20/11/2013 05:13

#define DEFAULT_WEAPON_SELL_VALUE 50
#define DEFAULT_MAG_SELL_VALUE 10
#define DEFAULT_ITEM_SELL_VALUE 25

#include "sellIncludesStart.sqf";

if (currentWeapon player == "") exitWith
{
	playSound "FD_CP_Not_Clear_F";
	hint "You don't have a weapon in your hands to sell!";
};

storeSellingHandle = [] spawn
{
	_currWep = currentWeapon player;
	_currMag = currentMagazine player;
	_sellValue = DEFAULT_WEAPON_SELL_VALUE; // This is the default value for weapons that aren't listed in the store
	_itemsToSell = [];
	_currMags = [];

	{
		if (_x select 0 == _currWep) exitWith
		{
			_arr = _x call splitWeaponItems;
			_itemsToSell = _arr select 1;
			_currMags = _arr select 2;
		};
	} forEach weaponsItems player;

	// Calculating weapon sell value
	{
		if (_x select 1 == _currWep) exitWith
		{
			_sellValue = GET_HALF_PRICE(_x select 2);
		};
	} forEach (call allGunStoreFirearms);

	_magsToSell = [];

	{
		[_magsToSell, _x select 0, [_x select 1]] call fn_addToPairs;
	} forEach _currMags;

	// If a magazine is loaded in the weapon, add each identical magazine in the inventory to the list of magazines to sell
	_invMagsToRemove = [];
	if (_currMag != "") then
	{
		_currMag = _currMag call getBallMagazine;

		{
			_mag = _x select 0;
			_magAmmo = _x select 1;

			if (_mag call getBallMagazine == _currMag) then
			{
				[_magsToSell, _mag, [_magAmmo]] call fn_addToPairs;
				[_invMagsToRemove, _mag, 1] call fn_addToPairs;
			};
		} forEach magazinesAmmo player;
	};

	// Add weapon name to confirm message
	_confirmMsg = format ["1 x  %1", getText (configFile >> "CfgWeapons" >> _currWep >> "displayName")];

	// Add ammo-based price of magazines to total sell value, and their names to confirm message
	{
		_mag = _x select 0;
		_magAmmos = _x select 1;
		_magValue = DEFAULT_MAG_SELL_VALUE;

		_magCfg = configFile >> "CfgMagazines" >> _mag;
		_magName = getText (_magCfg >> "displayName");
		_magFullAmmo = getNumber (_magCfg >> "count");

		{
			if (_x select 1 == _currMag) exitWith
			{
				_magValue = _x select 2;
			};
		} forEach (call ammoArray);

		{
			_sellValue = _sellValue + GET_HALF_PRICE(_magValue * (_x / _magFullAmmo)); // Get selling price relative to ammo count
		} forEach _magAmmos;

		_confirmMsg = _confirmMsg + "<br/>" + str count _magAmmos + " x  " + _magName;

	} forEach _magsToSell;


	// Add weapon attachments to total sell value and their names to confirm message
	{
		if (_x != "") then
		{
			_wepItem = _x;
			_itemName = getText (configFile >> "CfgWeapons" >> _wepItem >> "displayName");
			_itemValue = DEFAULT_ITEM_SELL_VALUE;

			{
				if (_x select 1 == _wepItem) exitWith
				{
					_itemName = _x select 0;
					_itemValue = GET_HALF_PRICE(_x select 2);
				};
			} forEach (call accessoriesArray);

			_sellValue = _sellValue + _itemValue;
			_confirmMsg = _confirmMsg + "<br/>1 x  " + _itemName;
		};
	} forEach _itemsToSell;

	// Add total sell value to confirm message
	_confirmMsg = format ["You will obtain $%1 for:<br/><br/>", [_sellValue] call fn_numbersText] + _confirmMsg;

	// Add note about removing weapon mag if the player doesn't want to sell inventory mags
	if (_currMag != "") then
	{
		_confirmMsg = _confirmMsg + "<br/><br/>If you don't want to sell your ammo, simply remove the magazine from your weapon.";
	};

	// Display confirmation
	if ([parseText _confirmMsg, "Confirm", "Sell", true] call BIS_fnc_guiMessage) then
	{
		// Remove weapon if sale confirmed by player
		player removeWeapon _currWep;

		// Remove sold inventory magazines
		{
			for "_i" from 1 to (_x select 1) do
			{
				player removeMagazine (_x select 0);
			};
		} forEach _invMagsToRemove;

		player setVariable ["cmoney", (player getVariable ["cmoney", 0]) + _sellValue, true];
		hint format ["You sold your gun for $%1", [_sellValue] call fn_numbersText];
	};
};

#include "sellIncludesEnd.sqf";
