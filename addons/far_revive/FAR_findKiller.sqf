// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: FAR_findKiller.sqf
//	@file Author: AgentRev

private ["_target", "_vehicle", "_killer", "_ammo", "_vehicleKiller", "_suspects", "_suspectCount", "_driver", "_suspect", "_mags", "_magAmmo"];

_target = _this;
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

	_driver = (_suspects select 0) select 0;

	if (_suspectCount == 1) exitWith { _killer = _driver }; // Killed by lone driver

	_ammo = _target getVariable ["FAR_killerAmmo", ""];

	if (_ammo == "") exitWith { _killer = _driver }; // Roadkilled by driver

	{
		_suspect = _x select 0;
		_mags = _x select 1;

		{
			_magAmmo = getText (configFile >> "CfgMagazines" >> _x >> "ammo");

			if (_magAmmo == _ammo || {getText (configFile >> "CfgAmmo" >> _magAmmo >> "explosion") == _ammo}) exitWith // check Explosions
			{
				_killer = _suspect; // Killed by turret gunner
			};
		} forEach _mags;

		if (!isNull _killer) exitWith {};
	} forEach _suspects;
};

//systemChat format ["%1's killer: %2", [typeOf _target, name _target], typeOf _killer];
//diag_log format ["%1's killer: %2", [typeOf _target, name _target], typeOf _killer];

if (_killer == _target) exitWith { objNull }; // Indirect suicide

_killer
