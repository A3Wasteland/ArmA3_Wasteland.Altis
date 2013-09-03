//	@file Version: 1.0
//	@file Name: createMissionVehicle.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 26/1/2013 15:19

if(!isServer) exitwith {};

private["_vehicleClass","_randomPos","_fuel","_ammo","_damage","_state","_veh"];

_vehicleClass = _this select 0;
_randomPos = _this select 1;
_fuel = _this select 2;
_ammo = _this select 3;
_damage = _this select 4;
_state = _this select 5;

_veh = createVehicle [_vehicleClass,_randomPos,[], 0, _state];
_veh setPosATL _randomPos;
_veh setVelocity [0,0,0];
_veh setFuel _fuel;
_veh setVehicleAmmo _ammo;
_veh setdamage _damage;

_veh setVehicleLock "LOCKED";
_veh setVariable [call vChecksum, true, false]; 
_veh setVariable ["R3F_LOG_disabled", true, true];

clearMagazineCargoGlobal _veh;
clearWeaponCargoGlobal _veh;

_veh spawn cleanVehicleWreck;

_veh
