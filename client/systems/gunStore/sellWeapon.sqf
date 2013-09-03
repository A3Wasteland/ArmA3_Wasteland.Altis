
//	@file Version: 1.0
//	@file Name: sellWeapon.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, AgentRev
//	@file Created: 20/11/2012 05:13
//	@file Args:

if (!isNil "storeSellingActive" && {typeName storeSellingActive == typeName true} && {storeSellingActive}) exitWith {};

//Initialize Values
private ["_primary", "_primaryType", "_sellValue", "_weaponMags", "_magazines", "_currMag", "_currMagAmmo", "_mag", "_magAmmo", "_magFullAmmo", "_magValue", "_magAdded", "_magsToSell", "_confirmMsg", "_wepItems", "_wepItem", "_itemName", "_itemValue", "_magQty"];

_primary = currentWeapon player;
if (_primary == "") exitWith { hint "You don't have a current weapon in your hand to sell!" };

if (isNil "storeSellingActive" || {typeName storeSellingActive != typeName {}}) then { storeSellingActive = true };

_primaryType = getNumber (configFile >> "CfgWeapons" >> _primary >> "type");
_sellValue = 50; // This is for weapons that aren't in the gunstore stock list.
_magsToSell = [];

{
	if (_x select 1 == _primary) exitWith
	{
		_sellValue = _x select 3;
	};
} forEach (call weaponsArray);

// if(isNil {_sellValue}) exitWith {hint "The store does not want this item."};

_weaponMags = getArray (configFile >> "CfgWeapons" >> _primary >> "magazines");
_magazines = magazinesAmmo player;
_currMag = currentMagazine player;

if (_currMag != "") then
{
	_currMag = _currMag call getBallMagazine;
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

	{
		_mag = _x select 0;
		_magAmmo = _x select 1;
		
		if (_mag call getBallMagazine == _currMag) then
		{
			_sellValue = _sellValue + ((ceil (((_magValue * (_magAmmo / _magFullAmmo)) / 2) / 5)) * 5);
			
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

_confirmMsg = "<t font='EtelkaMonospaceProBold'>1</t> x " + getText (configFile >> "CfgWeapons" >> _primary >> "displayName");

switch (_primaryType) do
{
	case 1: { _wepItems = primaryWeaponItems player };
	case 2: { _wepItems = handgunItems player };
	case 4: { _wepItems = secondaryWeaponItems player };
	default { _wepItems = [] };
};

// Attachments list
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
				_itemValue = (ceil (((_x select 2) / 2) / 5)) * 5;
			};
		} forEach (call accessoriesArray);
		
		_sellValue = _sellValue + _itemValue;
		_confirmMsg = _confirmMsg + "<br/><t font='EtelkaMonospaceProBold'>1</t> x " + _itemName;
	};	
} forEach _wepItems;

// Magazines list
{
	_mag = _x select 0;
	_magQty = _x select 1;
	
	_confirmMsg = _confirmMsg + "<br/>" + format ["<t font='EtelkaMonospaceProBold'>%1</t> x ", _magQty] + getText (configFile >> "CfgMagazines" >> _mag >> "displayName");
	
} forEach _magsToSell;

_confirmMsg = format ["You will obtain $%1 for:<br/><br/>", _sellValue] + _confirmMsg;

if (_currMag != "") then
{
	_confirmMsg = _confirmMsg + "<br/><br/>If you don't want to sell your ammo, simply remove the magazine from your weapon.";
};

if ([parseText _confirmMsg, "Confirm", "Sell", true] call BIS_fnc_guiMessage) then
{
	player removeWeapon _primary;
	{ player removeMagazines _x } forEach _weaponMags;

	player setVariable ["cmoney", (player getVariable ["cmoney", 0]) + _sellValue, true];
	hint format["You sold your gun for $%1", _sellValue];
};

if (isNil "storeSellingActive" || {typeName storeSellingActive != typeName {}}) then { storeSellingActive = false };
