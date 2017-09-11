// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2017 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_findTurretShooter.sqf
//	@file Author: AgentRev

// super kawaii compensation for Bohemia's raw sewage

params [["_target",objNull,[objNull]], ["_vehicle",objNull,[objNull]], ["_ammo","",[""]]];

private _offset = _vehicle worldToModelVisual (_target modelToWorldVisual [0,0,0]);
private _possibleShooters = [];
private _possiblePaths = [];
private ["_suspect", "_mags", "_path", "_magAmmo", "_magAmmoExpl"];

{
	_suspect = _x select 0;
	_path = if (isManualFire _vehicle && effectiveCommander _vehicle == _suspect) then {
		(fullCrew [_vehicle, "gunner", true]) param [0,[]] param [3,[0]]
	} else {
		_x select 3
	};

	_mags = _vehicle magazinesTurret _path;

	{
		_magAmmo = getText (configFile >> "CfgMagazines" >> _x >> "ammo");
		_magAmmoExpl = getText (configFile >> "CfgAmmo" >> _magAmmo >> "explosion"); // Explosive projectile

		if (_magAmmo == _ammo || _magAmmoExpl == _ammo) exitWith
		{
			_possibleShooters pushBack _suspect; // Turret kill with gunner still seated
			_possiblePaths pushBack _path;
		};
	} forEach _mags;
} forEach fullCrew [_vehicle, "", false];

private _shooter = objNull;

if (count _possibleShooters > 0) then
{
	if (isClass (configFile >> "CfgVehicles" >> typeOf _vehicle >> "Turrets" >> "RightDoorGun") && // is dual doorgun heli and a suspect used a door gun
	   {count (_possiblePaths arrayIntersect [[1],[2]]) > 0}) then
	{
		// check on which side of the vehicle the target is located, and award the kill to the matching gunner
		private _offsetX = _offset select 0;

		{
			_suspect = _x;
			_path = _possiblePaths select _forEachIndex;

			if ((_offsetX <= 0 && _path isEqualTo [1]) || (_offsetX > 0 && _path isEqualTo [2])) exitWith
			{
				_shooter = _suspect;
			};
		} forEach _possibleShooters;
	}
	else
	{
		_shooter = _possibleShooters select 0; // cannot get more precise info, so first suspect gets the kill
	};
};

_shooter
