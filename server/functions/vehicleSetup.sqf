//	@file Version: 1.0
//	@file Name: vehicleSetup.sqf
//	@file Author: AgentRev
//	@file Created: 15/06/2013 19:57

if (!isServer) exitWith {};

private ["_vehicle", "_toolkitFullRepair"];
_vehicle = _this select 0;
_toolkitFullRepair = [_this, 1, false, [false]] call BIS_fnc_param;

_vehicle setVariable [call vChecksum, true];
_vehicle disableTIEquipment true;

// if (_toolkitFullRepair) then { _vehicle spawn vehicleRepair };

clearMagazineCargoGlobal _vehicle;
clearWeaponCargoGlobal _vehicle;
clearItemCargoGlobal _vehicle;

_vehicle setVariable ["A3W_handleDamage", true, true];

{
	_vehicle setVariable ["A3W_hitPoint_" + getText (_x >> "name"), configName _x, true];
} forEach ((typeOf _vehicle) call getHitPoints);

_vehicle addEventHandler ["HandleDamage", vehicleHandleDamage];
