// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: FAR_findKiller.sqf
//	@file Author: AgentRev

private ["_target", "_targetSide", "_vehicle", "_killer", "_ammo", "_vehicleKiller", "_suspects", "_suspectCount", "_firstCrew", "_firstCrewSide", "_driver", "_offset", "_possibleKillers", "_suspect", "_mags", "_magAmmo", "_magAmmoExpl", "_offsetX"];

_target = _this;
_targetSide = side group _target;
_vehicle = _target getVariable ["FAR_killerVehicle", objNull];

//systemChat format ["FAR_findKiller %1", [typeOf _target, name _target, typeOf _vehicle]];
//diag_log format ["FAR_findKiller %1", [typeOf _target, name _target, typeOf _vehicle]];

if (_vehicle == _target) exitWith { objNull }; // Suicide
if (_vehicle isKindOf "CAManBase") exitWith { _vehicle }; // Killed by infantry

_killer = objNull;

// If killer is UAV, designate owner as killer
if (isUavConnected _vehicle) then
{
	_killer = (uavControl _vehicle) select 0;
};

_ammo = _target getVariable ["FAR_killerAmmo", ""];

// Chain-reaction tracking
if (_ammo == "") then
{
	_vehicleKiller = _vehicle getVariable ["FAR_killerVehicle", objNull];

	if (!isNull _vehicleKiller) then
	{
		_killer = _vehicleKiller;
	};
};

if (isNull _killer) then
{
	_suspects = _target getVariable ["FAR_killerSuspects", []];
	_suspectCount = count _suspects;

	if (_suspectCount == 0) exitWith {}; // Crushed by empty vehicle

	_firstCrew = (_suspects select 0) select 0;
	_firstCrewSide = side group _firstCrew;
	_driver = driver _vehicle;
	_offset = _vehicle worldToModelVisual (_target modelToWorldVisual [0,0,0]);

	_ammo = _target getVariable ["FAR_killerAmmo", ""];

	if (_ammo == "") then
	{
		if (!isNull _driver) then { _killer = _driver }; // Roadkill with driver still seated
	}
	else
	{
		_possibleKillers = [];

		{
			_suspect = _x select 0;
			_mags = _x select 1;
			_path = _x select 2;

			{
				_magAmmo = getText (configFile >> "CfgMagazines" >> _x >> "ammo");
				_magAmmoExpl = getText (configFile >> "CfgAmmo" >> _magAmmo >> "explosion"); // Explosive projectile

				if (_magAmmo == _ammo || _magAmmoExpl == _ammo) then
				{
					_possibleKillers pushBack [_suspect, _path]; // Turret kill with gunner still seated
				};
			} forEach _mags;
		} forEach _suspects;

		if (count _possibleKillers > 0) then
		{
			if (isClass (configFile >> "CfgVehicles" >> typeOf _vehicle >> "Turrets" >> "RightDoorGun")) then // is dual doorgun heli
			{
				// check on which side of the vehicle the target is located, and award the kill to the matching gunner
				_offsetX = _offset select 0;

				{
					_suspect = _x select 0;
					_path = _x select 1;

					if ((_offsetX <= 0 && _path isEqualTo [1]) || (_offsetX > 0 && _path isEqualTo [2])) exitWith
					{
						_killer = _suspect;
					};
				} forEach _possibleKillers;
			}
			else
			{
				_killer = _possibleKillers select 0; // cannot get more precise info, so first suspect gets the kill
			};
		};
	};

	// if roadkill but driver bailed out or turret kill but gunner bailed out, and the first crewmember is an enemy, award him the kill, otherwise nobody is blamed
	if (isNull _killer) then
	{
		if (_targetSide == sideUnknown || _firstCrewSide getFriend _targetSide < 0.6 || (!(_targetSide in [BLUFOR,OPFOR]) && _firstCrewSide == _targetSide)) then
		{
			_killer = _firstCrew;
		};
	};
};

//systemChat format ["%1's killer: %2", [typeOf _target, name _target], [_killer, typeOf _killer, assignedVehicleRole _killer]];
//diag_log format ["%1's killer: %2", [typeOf _target, name _target], [_killer, typeOf _killer, assignedVehicleRole _killer]];

if (_killer == _target) exitWith { objNull }; // Indirect suicide

_killer
