//	@file Version: 1.0
//	@file Name: getHitPoints.sqf
//	@file Author: AgentRev
//	@file Date modified: 03/10/2013 11:51

private ["_class", "_hitPoints", "_hitPointsFound", "_hitPointsCfg", "_nbHitPoints", "_cfgVehicle", "_i"];
_class = [_this, 0, "", [""]] call BIS_fnc_param;

_hitPoints = [];
_hitPointsFound = false;
_cfgVehicle = configFile >> "CfgVehicles" >> _class;

scopeName "main";

while {isClass _cfgVehicle} do
{
	_hitPointsCfg = _cfgVehicle >> "HitPoints";
	
	if (isClass _hitPointsCfg) then
	{
		_nbHitPoints = count _hitPointsCfg;
		
		for "_i" from 0 to (_nbHitPoints - 1) do
		{
			_hitPoints set [count _hitPoints, _hitPointsCfg select _i];
		};
		
		_hitPointsFound = true;
	}
	else
	{
		if (_hitPointsFound) then
		{
			breakTo "main";
		};
	};
	
	_cfgVehicle = inheritsFrom _cfgVehicle;
};

_hitPoints
