// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: oSave.sqf
//	@file Author: AgentRev, [GoT] JoSchaap

#include "functions.sqf"

A3W_saveableObjects = [];

// Add objectList & general store objects
{
	_idx = _forEachIndex;

	{
		_obj = _x;
		if (_idx > 0) then { _obj = _x select 1 };

		if (!(_obj isKindOf "ReammoBox_F") && {!(_obj call _isSaveable)}) then
		{
			A3W_saveableObjects pushBack _obj;
		};
	} forEach _x;
} forEach [objectList, call genObjectsArray];

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

while {true} do
{
	uiSleep _savingInterval;

	_objCount = 0;
	_currObjectIDs = +A3W_objectIDs;
	_newObjectIDs = [];

	{
		_obj = _x;

		if (_obj call fn_isObjectSaveable) then
		{
			_objCount = _objCount + 1;
			_objID = [_obj, _objCount] call fn_saveObject;

			if (!isNil "_objID") then 
			{
				_newObjectIDs pushBack _objID;
				if !(_objID in A3W_objectIDs) then { A3W_objectIDs pushBack _objID };
			};

			sleep 0.01;
		};
	} forEach allMissionObjects "All";

	diag_log format ["A3W - %1 baseparts and objects have been saved with %2", _objCount, call A3W_savingMethodName];

	if (_warchestMoneySavingOn) then
	{
		call fn_saveWarchestMoney;
	};

	_oldIDs = _currObjectIDs - _newObjectIDs;
	A3W_objectIDs = A3W_objectIDs - _oldIDs;

	[_oldIDs, _objCount] call fn_postObjectSave;

	uiSleep _savingInterval;

	// Vehicle saving
	if (_vehicleSaving) then
	{
		_vehCount = 0;
		_currVehicleIDs = +A3W_vehicleIDs;
		_newVehicleIDs = [];

		{
			_veh = _x;

			if (_veh call fn_isVehicleSaveable) then
			{
				_vehCount = _vehCount + 1;
				_vehID = [_veh, _vehCount] call fn_saveVehicle;

				if (!isNil "_vehID") then 
				{
					_newVehicleIDs pushBack _vehID;
					if !(_vehID in A3W_vehicleIDs) then { A3W_vehicleIDs pushBack _vehID };
				};

				sleep 0.01;
			};
		} forEach allMissionObjects "AllVehicles";

		diag_log format ["A3W - %1 vehicles have been saved with %2", _vehCount, call A3W_savingMethodName];

		_oldIDs = _currVehicleIDs - _newVehicleIDs;
		A3W_vehicleIDs = A3W_vehicleIDs - _oldIDs;

		[_oldIDs, _vehCount] call fn_postVehicleSave;
	};
};
