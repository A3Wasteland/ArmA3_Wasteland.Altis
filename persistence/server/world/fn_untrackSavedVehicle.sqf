// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_untrackSavedVehicle.sqf
//	@file Author: AgentRev

if (!isNil "A3W_hcObjSaving_unit" && {!isNull A3W_hcObjSaving_unit && !local A3W_hcObjSaving_unit}) exitWith
{
	_this remoteExecCall ["fn_untrackSavedVehicle", A3W_hcObjSaving_unit];
};

params ["_veh"];

if (_veh isEqualType "") then { _veh = objectFromNetId _veh };
_vehID = _veh getVariable "A3W_vehicleID";

if (isNil "_vehID" || isNil "A3W_vehicleIDs") exitWith {};

A3W_vehicleIDs deleteAt (A3W_vehicleIDs find _vehID);
