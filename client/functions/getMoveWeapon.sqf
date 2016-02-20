// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: getMoveWeapon.sqf
//	@file Author: AgentRev
//	@file Created: 16/11/2013 21:17

private ["_unit", "_noLauncher", "_weapon"];

if (typeName _this == "ARRAY") then
{
	_unit = param [0, objNull, [objNull]];
	_noLauncher = param [1, false, [false]];
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
