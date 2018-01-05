// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_untrackSavedVehicle.sqf
//	@file Author: AgentRev

params [["_vehID","",["",objNull]]];
if (_vehID isEqualType objNull) then { _vehID = _vehID getVariable ["A3W_vehicleID", ""] };

if (!isNil "A3W_hcObjSaving_unit" && {!isNull A3W_hcObjSaving_unit && !local A3W_hcObjSaving_unit}) then
{
	_vehID remoteExecCall ["fn_untrackSavedVehicle", A3W_hcObjSaving_unit];
};

if (isNil "A3W_vehicleIDs") exitWith {};
A3W_vehicleIDs deleteAt (A3W_vehicleIDs find _vehID);
