// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: vLoad.sqf
//	@file Author: AgentRev, JoSchaap, Austerror

#include "functions.sqf"

private ["_maxLifetime", "_maxUnusedTime", "_worldDir", "_methodDir", "_vehCount", "_vehicles", "_exclVehicleIDs"];

_maxLifetime = ["A3W_vehicleLifetime", 0] call getPublicVar;
_maxUnusedTime = ["A3W_vehicleMaxUnusedTime", 0] call getPublicVar;

_worldDir = "persistence\server\world";
_methodDir = format ["%1\%2", _worldDir, call A3W_savingMethodDir];

_vehCount = 0;
_vehicles = call compile preprocessFileLineNumbers format ["%1\getVehicles.sqf", _methodDir];

_exclVehicleIDs = [];

{
	private ["_veh", "_hoursAlive", "_hoursUnused"];
	private (_x apply {_x select 0});

	{ (_x select 1) call compile format ["%1 = _this", _x select 0]	} forEach _x;

	if (isNil "_flying") then { _flying = 0 };
	if (isNil "_hoursAlive") then { _hoursAlive = 0 };
	if (isNil "_hoursUnused") then { _hoursUnused = 0 };

	private _valid = false;

	if (!isNil "_class" && !isNil "_pos" && {count _pos == 3 && (_maxLifetime <= 0 || _hoursAlive < _maxLifetime) && (_maxUnusedTime <= 0 || _hoursUnused < _maxUnusedTime)}) then
	{
		_vehCount = _vehCount + 1;
		_valid = true;

		call fn_restoreSavedVehicle;
	};

	if (!_valid && !isNil "_vehicleID") then
	{
		if (!isNil "_veh") then
		{
			_veh setVariable ["A3W_vehicleID", nil, true];
		};

		_exclVehicleIDs pushBack _vehicleID;
	};
} forEach _vehicles;

diag_log format ["A3Wasteland - world persistence loaded %1 vehicles from %2", _vehCount, call A3W_savingMethodName];

_exclVehicleIDs call fn_deleteVehicles;
