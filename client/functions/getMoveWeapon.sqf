//	@file Version: 1.0
//	@file Name: getMoveWeapon.sqf
//	@file Author: AgentRev
//	@file Created: 16/11/2013 21:17

private ["_unit", "_weapon"];
_unit = _this;
_weapon = "non";

switch (true) do
{
	case (currentWeapon _unit == primaryWeapon _unit):   { _weapon = "rfl" };
	case (currentWeapon _unit == secondaryWeapon _unit): { _weapon = "lnr" };
	case (currentWeapon _unit == handgunWeapon _unit):   { _weapon = "pst" };
};

_weapon
