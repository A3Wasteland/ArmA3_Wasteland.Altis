// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: postVehicleSave.sqf
//	@file Author: AgentRev

private "_oldVehicleIDs";
_oldVehicleIDs = _this select 0;

_oldVehicleIDs call fn_deleteVehicles;
