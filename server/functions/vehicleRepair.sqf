// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: vehicleRepair.sqf
//	@file Author: AgentRev
//	@file Created: 15/06/2013 17:33

// "getDammage" and "damage" don't detect repairs done with the toolkit, so we have to check all vehicle parts with getHitPointDamage

private ["_vehicle", "_hitPtsCfg", "_hitPoints", "_previousDmg", "_currentDmg"];

_vehicle = _this;

_hitPtsCfg = configFile >> "CfgVehicles" >> typeOf _vehicle >> "HitPoints";
_hitPoints = [];

for "_i" from 0 to (count _hitPtsCfg - 1) do
{
	_hitPoints set [_i, configName (_hitPtsCfg select _i)];
};

_previousDmg = 0;

while { alive _vehicle } do
{
	_currentDmg = 0;

	{
		_currentDmg = _currentDmg + (_vehicle getHitPointDamage _x);
	} forEach _hitPoints;

	if (_currentDmg < _previousDmg - 0.01) then
	{
		_vehicle setDamage 0;
		if (_vehicle isKindOf "Boat_Armed_01_base_F") then { _vehicle setHitPointDamage ["HitTurret", 1] }; // disable front GMG on boats
	};

	_previousDmg = _currentDmg;
	sleep 5;
};
