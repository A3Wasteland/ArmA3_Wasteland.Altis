// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2017 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: oSaveOnce.sqf
//	@file Author: AgentRev, [GoT] JoSchaap

#include "defines.sqf"

private _forEachSleep = [0, 0.01] select (_savingInterval > 0);
private "_oldIDs";

SLEEP_REALTIME(_savingInterval);

if ((_timeSavingOn && !isNil "A3W_timeSavingInitDone") || (!_timeSavingOn && _weatherSavingOn)) then
{
	call fn_saveTime;
};

if (_warchestMoneySavingOn) then
{
	call fn_saveWarchestMoney;
};

// Object saving
if (_objectSavingOn) then
{
	private _objCount = 0;
	private _currObjectIDs = [];
	private _newObjectIDs = [];
	private ["_obj", "_objID"];

	_currObjectIDs append A3W_objectIDs;

	{
		_obj = _x;

		if (_obj call fn_isObjectSaveable && !(_obj getVariable ["A3W_skipAutoSave", false])) then
		{
			_objCount = _objCount + 1;
			_objID = [_obj, _objCount] call fn_saveObject;

			if (!isNil "_objID") then
			{
				_newObjectIDs pushBack _objID;
				A3W_objectIDs pushBackUnique _objID;
			};

			sleep _forEachSleep;
		};
	} forEach allMissionObjects "All";

	if (_isHC) then { "A3W_objectIDs" call _hcSaveProfileVar };

	diag_log format ["A3W - %1 baseparts and objects have been saved with %2", _objCount, call A3W_savingMethodName];

	_oldIDs = _currObjectIDs - _newObjectIDs;
	A3W_objectIDs = A3W_objectIDs - _oldIDs;

	[_oldIDs, _objCount] call fn_postObjectSave;

	if (_isHC) then { "A3W_objectIDs" call _hcSaveProfileVar };
};

SLEEP_REALTIME(_savingInterval);

// Vehicle saving
if (_vehicleSavingOn) then
{
	private _vehCount = 0;
	private _currVehicleIDs = [];
	private _newVehicleIDs = [];
	private ["_veh", "_vehID"];

	_currVehicleIDs append A3W_vehicleIDs;

	{
		_veh = _x;

		if (_veh call fn_isVehicleSaveable && !(_veh getVariable ["A3W_skipAutoSave", false])) then
		{
			_vehCount = _vehCount + 1;
			_vehID = [_veh, _vehCount] call fn_saveVehicle;

			if (!isNil "_vehID") then
			{
				_newVehicleIDs pushBack _vehID;
				A3W_vehicleIDs pushBackUnique _vehID;
			};

			sleep _forEachSleep;
		};
	} forEach allMissionObjects "AllVehicles";

	diag_log format ["A3W - %1 vehicles have been saved with %2", _vehCount, call A3W_savingMethodName];

	_oldIDs = _currVehicleIDs - _newVehicleIDs;
	A3W_vehicleIDs = A3W_vehicleIDs - _oldIDs;

	if (_isHC) then { "A3W_vehicleIDs" call _hcSaveProfileVar };

	[_oldIDs, _vehCount] call fn_postVehicleSave;
};

SLEEP_REALTIME(_savingInterval);

// Mine saving
if (_mineSavingOn) then
{
	private _mineCount = 0;
	private _currMineIDs = [];
	private _newMineIDs = [];
	private ["_dummy", "_mineID"];

	_currMineIDs append A3W_mineIDs;

	{
		if (_x getVariable ["A3W_stickyCharges_isDummy", false]) then
		{
			_dummy = _x;

			if (_dummy call fn_isMineSaveable) then
			{
				_mineCount = _mineCount + 1;
				_mineID = [_dummy, _mineCount] call fn_saveMine;

				if (!isNil "_mineID") then
				{
					_newMineIDs pushBack _mineID;
					A3W_mineIDs pushBackUnique _mineID;
				};

				sleep _forEachSleep;
			};
		};
	} forEach allMissionObjects STICKY_CHARGE_DUMMY_OBJ;

	diag_log format ["A3W - %1 mines have been saved with %2", _mineCount, call A3W_savingMethodName];

	_oldIDs = _currMineIDs - _newMineIDs;
	A3W_mineIDs = A3W_mineIDs - _oldIDs;

	if (_isHC) then { "A3W_mineIDs" call _hcSaveProfileVar };

	[_oldIDs, _mineCount] call fn_postMineSave;
};
