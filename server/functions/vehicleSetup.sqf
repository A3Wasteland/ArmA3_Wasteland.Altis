//	@file Version: 1.0
//	@file Name: vehicleSetup.sqf
//	@file Author: AgentRev
//	@file Created: 15/06/2013 19:57

if (!isServer) exitWith {};

private "_vehicle";
_vehicle = _this select 0;

_vehicle setVariable [call vChecksum, true];
_vehicle disableTIEquipment true;
_vehicle spawn vehicleRepair;

clearMagazineCargoGlobal _vehicle;
clearWeaponCargoGlobal _vehicle;
clearItemCargoGlobal _vehicle;
