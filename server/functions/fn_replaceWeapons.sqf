// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: fn_replaceWeapons.sqf
//	@file Author: AgentRev
//	@file Created: 06/07/2013 23:02
//	@file Args: container (Object), oldWeaponName (String), newWeaponName (String)

if (!isServer) exitWith {};

private ["_container", "_oldWeaponName", "_newWeaponName", "_weaponCargo", "_weapons", "_quantities", "_wepIndex"];

_container = _this select 0;
_oldWeaponName = _this select 1;
_newWeaponName = _this select 2;

_weaponCargo = getWeaponCargo _container;
_weapons = _weaponCargo select 0;
_quantities = _weaponCargo select 1;

_wepIndex = _weapons find _oldWeaponName;

if (_wepIndex != -1) then
{
	if (_newWeaponName == "") then
	{
		_weapons = [_weapons, _wepIndex] call BIS_fnc_removeIndex;
		_quantities = [_quantities, _wepIndex] call BIS_fnc_removeIndex;
	}
	else
	{
		_weapons set [_wepIndex, _newWeaponName];
	};

	clearWeaponCargoGlobal _container;

	{
		_container addWeaponCargoGlobal [_x, _quantities select _forEachIndex];
	} forEach _weapons;
};
