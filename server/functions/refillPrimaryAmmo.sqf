// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: refillPrimaryAmmo.sqf
//	@file Author: AgentRev
//	@file Created: 21/10/2013 19:30
//	@file Args:

#define MIN_MAGS 3
#define ROCKET_TIMEOUT 60 // seconds

if (!isServer) exitWith {};

params ["_unit"];

if (!local _unit || isPlayer _unit) exitWith {};

private _magType1 = "";
private _magType2 = "";
private ["_magCount", "_magTimeout2"];

while {alive _unit} do
{
	if (_magType1 == "") then
	{
		_magType1 = (primaryWeaponMagazine _unit) param [0,"",[""]];
	}
	else
	{
		_magCount = {_x == _magType1} count magazines _unit;

		if (_magCount < MIN_MAGS) then
		{
			_unit addMagazines [_magType1, MIN_MAGS - _magCount];
		};
	};

	if (_magType2 == "") then
	{
		_magType2 = (secondaryWeaponMagazine _unit) param [0,"",[""]];
	}
	else
	{
		_magCount = {_x == _magType2} count magazines _unit;

		if (_magCount == 0) then
		{
			if (isNil "_magTimeout2") then
			{
				_magTimeout2 = diag_tickTime;
			};

			if (!isNil "_magTimeout2" && {diag_tickTime - _magTimeout2 >= ROCKET_TIMEOUT}) then
			{
				_unit addMagazines [_magType2, MIN_MAGS];
			};
		};
	};

	sleep 3;
};
