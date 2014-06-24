//	@file Name: FAR_findKiller.sqf
//	@file Author: AgentRev

private ["_unit", "_vehicle", "_killer", "_suspects", "_suspectCount", "_driver", "_ammo", "_suspect", "_mags", "_magAmmo"];

_unit = _this;
_vehicle = _unit getVariable ["FAR_killerVehicle", objNull];

if (_vehicle == _unit) exitWith { objNull }; // Suicide
if (_vehicle isKindOf "CAManBase") exitWith { _vehicle }; // Killed by infantry

_killer = objNull;

// If killer is UAV, designate owner as killer
if (isUavConnected _vehicle) then
{
	_killer = (uavControl _vehicle) select 0;
};

if (isNull _killer) then
{
	_suspects = _unit getVariable ["FAR_killerSuspects", []];
	_suspectCount = count _suspects;

	if (_suspectCount == 0) exitWith {}; // Crushed by empty vehicle

	_driver = (_suspects select 0) select 0;

	if (_suspectCount == 1) exitWith { _killer = _driver }; // Killed by lone driver

	_ammo = _unit getVariable ["FAR_killerAmmo", ""];

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

if (_killer == _unit) exitWith { objNull }; // Indirect suicide

_killer
