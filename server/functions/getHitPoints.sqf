// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: getHitPoints.sqf
//	@file Author: AgentRev
//	@file Created: 03/10/2013 11:51

private ["_class", "_hitPoints", "_cfgVehicle", "_hitPointsCfg", "_i", "_hitPoint"];
_class = _this;

if (typeName _class == "OBJECT") then
{
	_class = typeOf _class;
};

_hitPoints = [];
_cfgVehicle = configFile >> "CfgVehicles" >> _class;

while {isClass _cfgVehicle} do
{
	_hitPointsCfg = _cfgVehicle >> "HitPoints";

	if (isClass _hitPointsCfg) then
	{
		for "_i" from 0 to (count _hitPointsCfg - 1) do
		{
			_hitPoint = _hitPointsCfg select _i;

			if ({configName _hitPoint == configName _x} count _hitPoints == 0) then
			{
				_hitPoints pushBack _hitPoint;
			};
		};
	};

	_cfgVehicle = inheritsFrom _cfgVehicle;
};

_hitPoints
