// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: precompile.sqf
//	@file Author: AgentRev

private ["_worldDir", "_methodDir"];
_worldDir = "persistence\server\world";
_methodDir = format ["%1\%2", _worldDir, call A3W_savingMethodDir];

fn_setTickTime = [_worldDir, "fn_setTickTime.sqf"] call mf_compile;
fn_secureSetVar = [_worldDir, "fn_secureSetVar.sqf"] call mf_compile;
fn_secureDelObj = [_worldDir, "fn_secureDelObj.sqf"] call mf_compile;

fn_getVehicleVars = [_methodDir, "getVehicleVars.sqf"] call mf_compile;
fn_preprocessSavedData = [_worldDir, "fn_preprocessSavedData.sqf"] call mf_compile;
fn_restoreSavedVehicle = [_worldDir, "fn_restoreSavedVehicle.sqf"] call mf_compile;

if (_objectSavingOn) then { fn_deleteObjects = [_methodDir, "deleteObjects.sqf"] call mf_compile };

if (_vehicleSavingOn) then
{
	fn_deleteVehicles = [_methodDir, "deleteVehicles.sqf"] call mf_compile;
	fn_getVehicleVars = [_methodDir, "getVehicleVars.sqf"] call mf_compile;
	fn_preprocessSavedData = [_worldDir, "fn_preprocessSavedData.sqf"] call mf_compile;
	fn_restoreSavedVehicle = [_worldDir, "fn_restoreSavedVehicle.sqf"] call mf_compile;
};

if (_mineSavingOn) then { fn_deleteMines = [_methodDir, "deleteMines.sqf"] call mf_compile };
