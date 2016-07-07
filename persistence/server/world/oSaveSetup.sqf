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

_vehicleSaving = ["A3W_vehicleSaving"] call isConfigOn;
_mineSaving = ["A3W_mineSaving"] call isConfigOn;
_savingInterval = (["A3W_serverSavingInterval", 60] call getPublicVar) / 3;

_worldDir = "persistence\server\world";
_methodDir = format ["%1\%2", _worldDir, call A3W_savingMethodDir];

fn_hasInventory = [_worldDir, "fn_hasInventory.sqf"] call mf_compile;
fn_saveWarchestMoney = [_methodDir, "saveWarchestMoney.sqf"] call mf_compile;
fn_saveTime = [_methodDir, "saveTime.sqf"] call mf_compile;

if (_objectSaving) then
{
	fn_isObjectSaveable = [_worldDir, "fn_isObjectSaveable.sqf"] call mf_compile;
	fn_getObjectProperties = [_worldDir, "fn_getObjectProperties.sqf"] call mf_compile;
	fn_manualObjectSave = [_worldDir, "fn_manualObjectSave.sqf"] call mf_compile;
	fn_manualObjectDelete = [_worldDir, "fn_manualObjectDelete.sqf"] call mf_compile;
	fn_saveObject = [_methodDir, "saveObject.sqf"] call mf_compile;
	fn_postObjectSave = [_methodDir, "postObjectSave.sqf"] call mf_compile;
};

if (_vehicleSaving) then
{
	fn_isVehicleSaveable = [_worldDir, "fn_isVehicleSaveable.sqf"] call mf_compile;
	fn_getVehicleProperties = [_worldDir, "fn_getVehicleProperties.sqf"] call mf_compile;
	fn_manualVehicleSave = [_worldDir, "fn_manualVehicleSave.sqf"] call mf_compile;
	fn_manualVehicleDelete = [_worldDir, "fn_manualVehicleDelete.sqf"] call mf_compile;
	fn_untrackSavedVehicle = [_worldDir, "fn_untrackSavedVehicle.sqf"] call mf_compile;
	fn_saveVehicle = [_methodDir, "saveVehicle.sqf"] call mf_compile;
	fn_postVehicleSave = [_methodDir, "postVehicleSave.sqf"] call mf_compile;
};

if (_mineSaving) then
{
	fn_isMineSaveable = [_worldDir, "fn_isMineSaveable.sqf"] call mf_compile;
	fn_getMineProperties = [_worldDir, "fn_getMineProperties.sqf"] call mf_compile;
	fn_manualMineSave = [_worldDir, "fn_manualMineSave.sqf"] call mf_compile;
	fn_manualMineDelete = [_worldDir, "fn_manualMineDelete.sqf"] call mf_compile;
	fn_saveMine = [_methodDir, "saveMine.sqf"] call mf_compile;
	fn_postMineSave = [_methodDir, "postMineSave.sqf"] call mf_compile;

	A3W_mineSaving_ammoClasses = [];
	A3W_mineSaving_vehicleClasses = [];

	{
		_ammoClass = toLower getText (_x >> "ammo");
		_vehClass = configName _x;

		_ammoCfg = configFile >> "CfgAmmo" >> _ammoClass;
		_ammoParentClass = _ammoClass;

		// this is needed because some identical user-placed vs script-placed mines have different ammo classes, but share the same vehicle class for createMine
		while {_ammoClass find _ammoParentClass == 0} do
		{
			A3W_mineSaving_ammoClasses pushBack _ammoParentClass;
			A3W_mineSaving_vehicleClasses pushBack _vehClass;

			_ammoCfg = inheritsFrom _ammoCfg;
			_ammoParentClass = toLower configName _ammoCfg;
		};
	} forEach ("configName _x isKindOf 'MineBase'" configClasses (configFile >> "CfgVehicles"));
};

if (_savingMethod == "iniDB") then
{
	_objFileName = "Objects" call PDB_objectFileName;
	_vehFileName = "Vehicles" call PDB_objectFileName;
	_mineFileName = "Mines" call PDB_objectFileName;

	// If file doesn't exist, create Info section at the top
	if !(_objFileName call PDB_exists) then
	{
		[_objFileName, "Info", "ObjCount", 0] call PDB_write;
	};

	if (_vehicleSaving && !(_vehFileName call PDB_exists)) then
	{
		[_vehFileName, "Info", "VehCount", 0] call PDB_write;
	};

	if (_mineSaving && !(_mineFileName call PDB_exists)) then
	{
		[_mineFileName, "Info", "MineCount", 0] call PDB_write;
	};
};

A3W_oSaveReady = compileFinal "true";
