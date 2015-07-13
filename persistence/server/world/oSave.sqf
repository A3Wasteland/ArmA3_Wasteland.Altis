// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: oSave.sqf
//	@file Author: AgentRev, [GoT] JoSchaap

#include "oSaveSetup.sqf"

_isHC = !isNil "A3W_hcObjSaving_isClient";

// the profileNamespace A3W_objectIDs and A3W_vehicleIDs thing is if the HC crashes and is restarted during the server session, then the ID arrays can be restored

if (_isHC) then
{
	if (isNil "A3W_objectIDs") then { A3W_objectIDs = [] };
	if (isNil "A3W_vehicleIDs") then { A3W_vehicleIDs = [] };

	if (!isNil "A3W_hcObjSaving_mergeIDs") then
	{
		_objVar = "A3W_objectIDs" call _hcProfileVarName;
		_objIDs = if (!isNil "_objVar") then { profileNamespace getVariable [_objVar, []] } else { [] };

		{ if !(_x in A3W_objectIDs) then { A3W_objectIDs pushBack _x } } forEach _objIDs;

		"A3W_objectIDs" call _hcSaveProfileVar;

		_vehVar = "A3W_vehicleIDs" call _hcProfileVarName;
		_vehIDs = if (!isNil "_vehVar") then { profileNamespace getVariable [_vehVar, []] } else { [] };

		{ if !(_x in A3W_vehicleIDs) then { A3W_vehicleIDs pushBack _x } } forEach _vehIDs;

		"A3W_vehicleIDs" call _hcSaveProfileVar;
	};
};

while {true} do
{
	uiSleep _savingInterval;

	_objCount = 0;
	_currObjectIDs = [];
	_currObjectIDs append A3W_objectIDs;
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

	if (_isHC) then { "A3W_objectIDs" call _hcSaveProfileVar };

	diag_log format ["A3W - %1 baseparts and objects have been saved with %2", _objCount, call A3W_savingMethodName];

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
	if (_vehicleSaving) then
	{
		_vehCount = 0;
		_currVehicleIDs = [];
		_currVehicleIDs append A3W_vehicleIDs;
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

		if (_isHC) then { "A3W_vehicleIDs" call _hcSaveProfileVar };

		[_oldIDs, _vehCount] call fn_postVehicleSave;
	};
};
