// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: createMissionVehicle2.sqf
//	@file Author: [404] Deadbeat, AgentRev
//	@file Created: 26/1/2013 15:19

if (!isServer) exitwith {};

private ["_class2", "_pos", "_fuel", "_ammo", "_damage", "_special", "_veh2"];

_class2 = _this select 0;
_pos = _this select 1;
_fuel = [_this, 2, 1, [0]] call BIS_fnc_param;
_ammo = [_this, 3, 1, [0]] call BIS_fnc_param;
_ammo = [_this, 3, 1, [0]] call BIS_fnc_param;
_damage = [_this, 4, 0, [0]] call BIS_fnc_param;
_special = [_this, 5, "None", [""]] call BIS_fnc_param;

_veh2 = createVehicle [_class2, _pos, [], 0, _special];

[_veh2] call vehicleSetup;

if (_fuel != 1) then { _veh2 setFuel _fuel };
if (_ammo != 1) then { _veh2 setVehicleAmmo _ammo };
_veh2 setDamage _damage;

_veh2
