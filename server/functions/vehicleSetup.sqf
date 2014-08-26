//	@file Version: 1.0
//	@file Name: vehicleSetup.sqf
//	@file Author: AgentRev
//	@file Created: 15/06/2013 19:57

if (!isServer) exitWith {};

private ["_vehicle", "_toolkitFullRepair"];
_vehicle = _this select 0;
// _toolkitFullRepair = [_this, 1, false, [false]] call BIS_fnc_param;

_vehicle setVariable [call vChecksum, true];

if !(_vehicle isKindOf "UAV_02_base_F") then
{
	_vehicle disableTIEquipment true;
};

// if (_toolkitFullRepair) then { _vehicle spawn vehicleRepair };

clearMagazineCargoGlobal _vehicle;
clearWeaponCargoGlobal _vehicle;
clearItemCargoGlobal _vehicle;

if (_vehicle isKindOf "AllVehicles") then
{
	clearBackpackCargoGlobal _vehicle;
};

{
	_vehicle setVariable ["A3W_hitPoint_" + getText (_x >> "name"), configName _x, true];
} forEach ((typeOf _vehicle) call getHitPoints);

_vehicle setVariable ["A3W_handleDamageHP", true, true];

_vehicle addEventHandler ["HandleDamage", vehicleHandleDamage];

_setRideInfo =
{
	_vehicle = _this select 0;
	_unit = _this select 2;

	_unit setVariable ["lastVehicleRidden", netId _vehicle, true];
	_unit setVariable ["lastVehicleOwner", owner _vehicle == owner _unit, true];
};

_vehicle addEventHandler ["GetIn", _setRideInfo];
_vehicle addEventHandler ["GetOut", _setRideInfo];

// Wreck cleanup
_vehicle addEventHandler ["Killed", { (_this select 0) setVariable ["processedDeath", diag_tickTime] }];

// Lower SUV center of mass to prevent rollovers
if (_vehicle isKindOf "SUV_01_base_F") then
{
	_centerOfMass = getCenterOfMass _vehicle;
	_centerOfMass set [2, -0.657];
	_vehicle setCenterOfMass _centerOfMass;
};
