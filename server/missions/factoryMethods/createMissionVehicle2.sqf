//	@file Version: 1.0
//	@file Name: createMissionVehicle.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 26/1/2013 15:19

if(!isServer) exitwith {};

private["_veh2icleClass","_randomPos","_fuel","_ammo","_damage","_state","_veh2"];

_veh2icleClass = _this select 0;
_randomPos = _this select 1;
_fuel = _this select 2;
_ammo = _this select 3;
_damage = _this select 4;
_state = _this select 5;

_veh2 = createVehicle [_veh2icleClass,_randomPos,[], 0, _state];
_veh2 setFuel _fuel;
_veh2 setVehicleAmmo _ammo;
_veh2 setdamage _damage;

_veh2 setVehicleLock "UNLOCKED";
_veh2 setVariable [call vChecksum, true, false]; 
_veh2 setVariable ["R3F_LOG_disabled", false, true];

clearMagazineCargoGlobal _veh2;
//clearWeaponCargoGlobal _veh2;

_veh2 spawn cleanVehicleWreck;

_veh2
