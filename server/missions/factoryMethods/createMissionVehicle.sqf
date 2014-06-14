//	@file Version: 1.0
//	@file Name: createMissionVehicle.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 26/1/2013 15:19

if (!isServer) exitwith {};

private["_vehicleClass","_randomPos","_fuel","_ammo","_damage","_state","_veh"];

_vehicleClass = _this select 0;
_randomPos = _this select 1;
_fuel = _this select 2;
_ammo = _this select 3;
_damage = _this select 4;
_state = _this select 5;

_veh = createVehicle [_vehicleClass,_randomPos,[], 0, _state];

_veh setDamage _damage; // setDamage must always be called before vehicleSetup

[_veh] call vehicleSetup;

_veh setPosATL [_randomPos select 0, _randomPos select 1, 0.05];
_veh setVelocity [0,0,0.01];
_veh setFuel _fuel;
_veh setVehicleAmmo _ammo;

_veh setVehicleLock "LOCKED";
_veh setVariable ["R3F_LOG_disabled", true, true];

// _veh spawn cleanVehicleWreck;

_veh
