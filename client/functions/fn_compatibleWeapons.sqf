// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2017 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_compatibleWeapons.sqf
//	@file Author: AgentRev

// This functions determines which weapon(s) could have been used by a unit or vehicle to fire a specific type of ammo.

params [["_unit",objNull,[objNull]], ["_ammo","",[""]]];

if (_ammo == "") exitWith { [] };

private "_vehicle";
private _weapons = [];

if (_unit isKindOf "Man") then
{
	_vehicle = objectParent _unit;

	if (!isNull _vehicle) then
	{
		private _crew = (fullCrew _vehicle) select {_x select 0 == _unit};

		if (_crew isEqualTo []) exitWith
		{
			_vehicle = objNull;
		};

		(_crew select 0) params ["", "_role", "_cargo", "_path"];

		if (_role == "driver") then { _path = [-1] };
		if (isManualFire _vehicle && effectiveCommander _vehicle == _unit) then { _path = [0] };

		if !(_path isEqualTo []) then
		{
			if (_cargo == -1) then // turret seat, unit uses turret weapons
			{
				_weapons = _vehicle weaponsTurret _path;
			}
			else // FFV (firing from vehicle) seat, unit uses own weapons
			{
				_vehicle = objNull;
			};
		};
	};

	if (isNull _vehicle) then
	{
		_weapons = [primaryWeapon _unit, secondaryWeapon _unit, handgunWeapon _unit] - [""];
	};
}
else
{
	_vehicle = _unit;
	{ _weapons append (_vehicle weaponsTurret _x) } forEach ([[-1]] + allTurrets _vehicle);
};

private _compatibleWeapons = [];
private ["_weapon", "_weaponCfg", "_mags", "_muzzles", "_magAmmo", "_magAmmoExpl"];

{
	_weapon = _x;
	_weaponCfg = configFile >> "CfgWeapons" >> _weapon;
	_mags = getArray (_weaponCfg >> "magazines");
	_muzzles = (getArray (_weaponCfg >> "muzzles")) - ["this"];

	{ _mags append getArray (_weaponCfg >> _x >> "magazines") } forEach _muzzles;

	{
		_magAmmo = getText (configFile >> "CfgMagazines" >> _x >> "ammo");
		_magAmmoExpl = getText (configFile >> "CfgAmmo" >> _magAmmo >> "explosion"); // Explosive projectile

		if (_magAmmo == _ammo || _magAmmoExpl == _ammo) exitWith
		{
			_compatibleWeapons pushBack _weapon;
		};
	} forEach _mags;
} forEach _weapons;

_compatibleWeapons
