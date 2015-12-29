// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_magazineAmmoCargo.sqf
//	@file Author: AgentRev

private ["_container", "_mags", "_mag", "_ammo", "_added", "_ammoArr"];
_container = _this;

if (isNull _container) exitWith {[]};

_mags = [];

{
	_mag = _x select 0;
	_ammo = _x select 1;

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
				_ammoArr = if (count _x > 2) then { _x select 2 } else { [] };
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

{
	if (isNil {_x select 1}) then
	{
		_x set [1, 0];
	};
} forEach _mags;

_mags