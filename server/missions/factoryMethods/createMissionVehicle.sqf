// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: createMissionVehicle.sqf
//	@file Author: [404] Deadbeat, AgentRev
//	@file Created: 26/1/2013 15:19

if (!isServer) exitwith {};

private ["_class", "_pos", "_fuel", "_ammo", "_damage", "_special", "_veh"];

_class = _this select 0;
_pos = _this select 1;
_fuel = param [2, 1, [0]];
_ammo = param [3, 1, [0]];
_damage = param [4, 0, [0]];
_special = param [5, "None", [""]];

_veh = createVehicle [_class, _pos, [], 0, _special];

[_veh] call vehicleSetup;

_veh setPosATL [_pos select 0, _pos select 1, 0.5];
_veh setVelocity [0,0,0.01];

if (_fuel != 1) then { _veh setFuel _fuel };
if (_ammo != 1) then { _veh setVehicleAmmo _ammo };
_veh setDamage _damage;

_veh lock 2;
_veh setVariable ["R3F_LOG_disabled", true, true];

_veh
