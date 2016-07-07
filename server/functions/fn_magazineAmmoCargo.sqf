// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_magazineAmmoCargo.sqf
//	@file Author: AgentRev

params ["_container"];

if (isNull _container) exitWith { [] };

private _mags = [];
private ["_added", "_ammoArr"];

{
	_x params ["_mag", "_ammo"];

	if (_ammo == getNumber (configFile >> "CfgMagazines" >> _mag >> "count")) then
	{
		// Full mags
		[_mags, _mag, 1] call fn_addToPairs;
	}
	else
	{
		// Partial mags
		_added = false;

		{
			if (_x select 0 == _mag) exitWith
			{
				_ammoArr = _x param [2,[]];
				_ammoArr pushBack _ammo;
				_x set [2, _ammoArr];

				_added = true;
			};
		} forEach _mags;

		if (!_added) then
		{
			_mags pushBack [_mag, 0, [_ammo]];
		};
	};
} forEach magazinesAmmoCargo _container;

_mags // [[class, fullCount(, [partialAmmo, ...])], ...]
