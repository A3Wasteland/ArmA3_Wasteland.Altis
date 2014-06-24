//	@file Version: 1.0
//	@file Name: getMoveWeapon.sqf
//	@file Author: AgentRev
//	@file Created: 16/11/2013 21:17

private ["_unit", "_noLauncher", "_weapon"];

if (typeName _this == "ARRAY") then
{
	_unit = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
	_noLauncher = [_this, 1, false, [false]] call BIS_fnc_param;
}
else
{
	_unit = _this;
	_noLauncher = false;
};

_weapon = switch (true) do
{
	case (currentWeapon _unit == primaryWeapon _unit):   { "rfl" };
	case (currentWeapon _unit == secondaryWeapon _unit): { "lnr" };
	case (currentWeapon _unit == handgunWeapon _unit):   { "pst" };
	default                                              { "non" };
};

if (_noLauncher && _weapon == "lnr") then
{
	_weapon = switch (true) do
	{
		case (secondaryWeapon _unit != ""): { "pst" };
		case (primaryWeapon _unit != ""):   { "rfl" };
		default                             { "non" };
	};
};

_weapon
