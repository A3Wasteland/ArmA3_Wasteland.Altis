//	@file Version: 1.0
//	@file Name: refillPrimaryAmmo.sqf
//	@file Author: AgentRev
//	@file Created: 21/10/2013 19:30
//	@file Args:

if (!isServer) exitWith {};

private ["_unit", "_minMags", "_magType", "_magCount"];

_unit = _this;
_minMags = 3;

if (local _unit && !isPlayer _unit) then
{
	waitUntil
	{
		sleep 1;
		_magType = [primaryWeaponMagazine _unit, 0, "", [""]] call BIS_fnc_param;
		_magType != "" || !alive _unit
	};

	if (_magType != "") then
	{
		while {alive _unit} do
		{
			_magCount = {_x == _magType} count magazines _unit;
			
			if (_magCount < _minMags) then
			{
				_unit addMagazines [_magType, _minMags - _magCount];
			};
			
			sleep 3;
		};
	};
};
