// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_setupAntiExplode.sqf
//	@file Author: AgentRev

// Attempt at fixing the dreaded explosion bug when you get in heli/planes and when taking control of UAVs

if (isServer) exitWith {};

params ["_veh"];

if (_veh isEqualType "") then { _veh = objectFromNetId _veh };

if (_veh getVariable ["A3W_antiExplodeLocalEH", false]) exitWith {};

_veh setVariable ["A3W_antiExplodeLocalEH", true];
_veh addEventHandler ["Local", A3W_fnc_antiExplodeLocalEH];
