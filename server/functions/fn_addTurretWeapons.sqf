// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_addTurretWeapons.sqf
//	@file Author: AgentRev

params [["_veh",objNull,[objNull]], ["_weapons",[],[[]]]];

if (!local _veh) exitWith {};

{ _veh addWeaponTurret _x } forEach _weapons;
