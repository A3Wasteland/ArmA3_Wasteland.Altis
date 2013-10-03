//	@file Version: 1.0
//	@file Name: sellWeapon.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy
//	@file Created: 20/11/2012 05:13
//	@file Args:

//Initialize Values
private["_primary","_magazine","_weapon_value","_magSell"];
_magSell = 0;
_weapon_value = nil;
_primary = currentWeapon player;
if(_primary == "") exitWith {hint "You don't have a current weapon in your hand to sell!";};

{
	if(_x in magazines player) then
    {
		_magazine = _x;
    };
} foreach (getArray (configFile >> "Cfgweapons" >> _primary >> "magazines"));

{if(_x select 1 == _primary) then {_weapon_value = _x select 3;};}forEach (call pistolArray);
{if(_x select 1 == _primary) then {_weapon_value = _x select 3;};}forEach (call rifleArray);
{if(_x select 1 == _primary) then {_weapon_value = _x select 3;};}forEach (call smgArray);
{if(_x select 1 == _primary) then {_weapon_value = _x select 3;};}forEach (call shotgunArray);
{if(_x select 1 == _primary) then {_weapon_value = _x select 3;};}forEach (call launcherArray);

if(isNil "_weapon_value") exitWith {hint "The store does not want this item."};

//_weapon_value = 25; // This is for weapons that aren't in the gunstore stock list. TODO fix the sell price.

player removeWeapon _primary;
player removeMagazines _magazine;

player setVariable [cmoney, (player getVariable [cmoney, 0]) + _weapon_value, true];
hint format["You sold your gun for $%1", _weapon_value];
