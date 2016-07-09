// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: oSave.sqf
//	@file Author: AgentRev, [GoT] JoSchaap

params ["_objectSavingOn", "_vehicleSavingOn", "_mineSavingOn"];

#include "oSaveSetup.sqf"

_isHC = !isNil "A3W_hcObjSaving_isClient";

// the profileNamespace A3W_objectIDs and A3W_vehicleIDs thing is if the HC crashes and is restarted during the server session, then the ID arrays can be restored

if (_isHC) then
{
	if (isNil "A3W_objectIDs") then { A3W_objectIDs = [] };
	if (isNil "A3W_vehicleIDs") then { A3W_vehicleIDs = [] };
	if (isNil "A3W_mineIDs") then { A3W_mineIDs = [] };

	if (!isNil "A3W_hcObjSaving_mergeIDs") then
	{
		_objVar = "A3W_objectIDs" call _hcProfileVarName;
		_objIDs = if (!isNil "_objVar") then { profileNamespace getVariable [_objVar, []] } else { [] };
		{ A3W_objectIDs pushBackUnique _x } forEach _objIDs;
		"A3W_objectIDs" call _hcSaveProfileVar;

		_vehVar = "A3W_vehicleIDs" call _hcProfileVarName;
		_vehIDs = if (!isNil "_vehVar") then { profileNamespace getVariable [_vehVar, []] } else { [] };
		{ A3W_vehicleIDs pushBackUnique _x } forEach _vehIDs;
		"A3W_vehicleIDs" call _hcSaveProfileVar;

		_mineVar = "A3W_mineIDs" call _hcProfileVarName;
		_mineIDs = if (!isNil "_mineVar") then { profileNamespace getVariable [_mineVar, []] } else { [] };
		{ A3W_mineIDs pushBackUnique _x } forEach _mineIDs;
		"A3W_mineIDs" call _hcSaveProfileVar;
	};
};

while {true} do
{
	uiSleep _savingInterval;

	_objCount = 0;
	_currObjectIDs = [];
	_currObjectIDs append A3W_objectIDs;
	_newObjectIDs = [];

	if (_objectSavingOn) then
	{
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

				sleep 0.01;
			};
		} forEach allMissionObjects "All";

		if (_isHC) then { "A3W_objectIDs" call _hcSaveProfileVar };

		diag_log format ["A3W - %1 baseparts and objects have been saved with %2", _objCount, call A3W_savingMethodName];
	};

	if (_warchestMoneySavingOn) then
	{
		call fn_saveWarchestMoney;
	};

	if ((_timeSavingOn && !isNil "A3W_timeSavingInitDone") || (!_timeSavingOn && _weatherSavingOn)) then
	{
		call fn_saveTime;
	};

	_oldIDs = _currObjectIDs - _newObjectIDs;
	A3W_objectIDs = A3W_objectIDs - _oldIDs;

	[_oldIDs, _objCount] call fn_postObjectSave;

	if (_isHC) then { "A3W_objectIDs" call _hcSaveProfileVar };

	uiSleep _savingInterval;

	// Vehicle saving
	if (_vehicleSavingOn) then
	{
		_vehCount = 0;
		_currVehicleIDs = [];
		_currVehicleIDs append A3W_vehicleIDs;
		_newVehicleIDs = [];

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

				sleep 0.01;
			};
		} forEach allMissionObjects "AllVehicles";

		diag_log format ["A3W - %1 vehicles have been saved with %2", _vehCount, call A3W_savingMethodName];

		_oldIDs = _currVehicleIDs - _newVehicleIDs;
		A3W_vehicleIDs = A3W_vehicleIDs - _oldIDs;

		if (_isHC) then { "A3W_vehicleIDs" call _hcSaveProfileVar };

		[_oldIDs, _vehCount] call fn_postVehicleSave;
	};

	uiSleep _savingInterval;

	// Mine saving
	if (_mineSavingOn) then
	{
		_mineCount = 0;
		_currMineIDs = [];
		_currMineIDs append A3W_mineIDs;
		_newMineIDs = [];

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

					sleep 0.01;
				};
			};
		} forEach allMissionObjects STICKY_CHARGE_DUMMY_OBJ;

		diag_log format ["A3W - %1 mines have been saved with %2", _mineCount, call A3W_savingMethodName];

		_oldIDs = _currMineIDs - _newMineIDs;
		A3W_mineIDs = A3W_mineIDs - _oldIDs;

		if (_isHC) then { "A3W_mineIDs" call _hcSaveProfileVar };

		[_oldIDs, _mineCount] call fn_postMineSave;
	};
};
