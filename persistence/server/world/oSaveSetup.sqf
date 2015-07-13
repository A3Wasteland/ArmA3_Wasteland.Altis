// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: oSaveSetup.sqf
//	@file Author: AgentRev

#include "functions.sqf"

A3W_saveableObjects = [];

// Add objectList & general store objects
{
	_idx = _forEachIndex;

	{
		_obj = if (typeName _x == "ARRAY") then { _x select 1 } else { _x }; // get class if store config array

		if (!(_obj isKindOf "ReammoBox_F") && {!(_obj call _isSaveable)}) then
		{
			A3W_saveableObjects pushBack toLower _obj;
		};
	} forEach _x;
} forEach [objectList, essentialsList, call genObjectsArray];

_purchasedVehicleSaving = ["A3W_purchasedVehicleSaving"] call isConfigOn;
_missionVehicleSaving = ["A3W_missionVehicleSaving"] call isConfigOn;
_vehicleSaving = (_purchasedVehicleSaving || _missionVehicleSaving);
_savingInterval = (["A3W_serverSavingInterval", 60] call getPublicVar) / 2;

_worldDir = "persistence\server\world";
_methodDir = format ["%1\%2", _worldDir, call A3W_savingMethodDir];

fn_hasInventory = [_worldDir, "fn_hasInventory.sqf"] call mf_compile;
fn_isObjectSaveable = [_worldDir, "fn_isObjectSaveable.sqf"] call mf_compile;
fn_getObjectProperties = [_worldDir, "fn_getObjectProperties.sqf"] call mf_compile;
fn_manualObjectSave = [_worldDir, "fn_manualObjectSave.sqf"] call mf_compile;
fn_manualObjectDelete = [_worldDir, "fn_manualObjectDelete.sqf"] call mf_compile;
fn_saveObject = [_methodDir, "saveObject.sqf"] call mf_compile;
fn_postObjectSave = [_methodDir, "postObjectSave.sqf"] call mf_compile;
fn_saveWarchestMoney = [_methodDir, "saveWarchestMoney.sqf"] call mf_compile;
fn_saveTime = [_methodDir, "saveTime.sqf"] call mf_compile;

if (_vehicleSaving) then
{
	fn_isVehicleSaveable = [_worldDir, "fn_isVehicleSaveable.sqf"] call mf_compile;
	fn_getVehicleProperties = [_worldDir, "fn_getVehicleProperties.sqf"] call mf_compile;
	fn_manualVehicleSave = [_worldDir, "fn_manualVehicleSave.sqf"] call mf_compile;
	fn_manualVehicleDelete = [_worldDir, "fn_manualVehicleDelete.sqf"] call mf_compile;
	fn_saveVehicle = [_methodDir, "saveVehicle.sqf"] call mf_compile;
	fn_postVehicleSave = [_methodDir, "postVehicleSave.sqf"] call mf_compile;
};

if (_savingMethod == "iniDB") then
{
	_objFileName = "Objects" call PDB_objectFileName;
	_vehFileName = "Vehicles" call PDB_objectFileName;

	// If file doesn't exist, create Info section at the top
	if !(_objFileName call PDB_exists) then // iniDB_exists
	{
		[_objFileName, "Info", "ObjCount", 0] call PDB_write; // iniDB_write
	};

	// If file doesn't exist, create Info section at the top
	if (_vehicleSaving && !(_vehFileName call PDB_exists)) then // iniDB_exists
	{
		[_vehFileName, "Info", "VehCount", 0] call PDB_write; // iniDB_write
	};
};

A3W_oSaveReady = compileFinal "true";
