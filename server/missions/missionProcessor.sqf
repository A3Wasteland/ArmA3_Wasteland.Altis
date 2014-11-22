// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: missionProcessor.sqf
//	@file Author: AgentRev

if (!isServer) exitwith {};

#define MISSION_LOCATION_COOLDOWN (10*60)

private ["_controllerSuffix", "_missionTimeout", "_availableLocations", "_missionLocation", "_leader", "_marker", "_failed", "_complete", "_startTime", "_leaderTemp", "_lastPos", "_floorHeight"];

// Variables that can be defined in the mission script :
private ["_missionType", "_locationsArray", "_aiGroup", "_missionPos", "_missionPicture", "_missionHintText", "_successHintMessage", "_failedHintMessage"];

_controllerSuffix = [_this, 0, "", [""]] call BIS_fnc_param;
_aiGroup = grpNull;

if (!isNil "_setupVars") then { call _setupVars };

diag_log format ["WASTELAND SERVER - %1 Mission%2 started: %3", MISSION_PROC_TYPE_NAME, _controllerSuffix, _missionType];

_missionTimeout = MISSION_PROC_TIMEOUT;

if (!isNil "_locationsArray") then
{
	while {true} do
	{
		_availableLocations = [_locationsArray, { !(_x select 1) && diag_tickTime - ([_x, 2, -1e11] call BIS_fnc_param) >= MISSION_LOCATION_COOLDOWN}] call BIS_fnc_conditionalSelect;

		if (count _availableLocations > 0) exitWith {};
		uiSleep 60;
	};

	_missionLocation = (_availableLocations call BIS_fnc_selectRandom) select 0;
	[_locationsArray, _missionLocation, true] call setLocationState;
	[_locationsArray, _missionLocation, markerPos _missionLocation] call cleanLocationObjects; // doesn't matter if _missionLocation is not a marker, the function will know
};

if (!isNil "_setupObjects") then { call _setupObjects };

_leader = leader _aiGroup;
_marker = [_missionType, _missionPos] call createMissionMarker;

if (isNil "_missionPicture") then { _missionPicture = "" };

[
	format ["%1 Objective", MISSION_PROC_TYPE_NAME],
	_missionType,
	_missionPicture,
	_missionHintText,
	MISSION_PROC_COLOR_DEFINE
]
call missionHint;

diag_log format ["WASTELAND SERVER - %1 Mission%2 waiting to be finished: %3", MISSION_PROC_TYPE_NAME, _controllerSuffix, _missionType];

_failed = false;
_complete = false;
_startTime = diag_tickTime;

if (isNil "_ignoreAiDeaths") then { _ignoreAiDeaths = false };

waitUntil
{
	sleep 1;

	_leaderTemp = leader _aiGroup;

	// Force immediate leader change if current one is dead
	if (!alive _leaderTemp) then
	{
		{
			if (alive _x) exitWith
			{
				_aiGroup selectLeader _x;
				_leaderTemp = _x;
			};
		} forEach units _aiGroup;
	};

	if (!isNull _leaderTemp) then { _leader = _leaderTemp }; // Update current leader

	if (!isNil "_waitUntilMarkerPos") then { _marker setMarkerPos (call _waitUntilMarkerPos) };
	if (!isNil "_waitUntilExec") then { call _waitUntilExec };

	_failed = ((!isNil "_waitUntilCondition" && {call _waitUntilCondition}) || diag_tickTime - _startTime >= _missionTimeout);

	if (!isNil "_waitUntilSuccessCondition" && {call _waitUntilSuccessCondition}) then
	{
		_failed = false;
		_complete = true;
	};

	(_failed || _complete || (!_ignoreAiDeaths && {alive _x} count units _aiGroup == 0))
};

if (_failed) then
{
	// Mission failed

	{ moveOut _x; deleteVehicle _x } forEach units _aiGroup;

	if (!isNil "_failedExec") then { call _failedExec };

	if (!isNil "_vehicle" && {typeName _vehicle == "OBJECT"}) then
	{
		deleteVehicle _vehicle;
	};

	if (!isNil "_vehicles" && {typeName _vehicles == "ARRAY"}) then
	{
		{
			if (!isNil "_x" && {typeName _x == "OBJECT"}) then
			{
				deleteVehicle _x;
			};
		} forEach _vehicles;
	};

	[
		"Objective Failed",
		_missionType,
		_missionPicture,
		if (!isNil "_failedHintMessage") then { _failedHintMessage } else { "Better luck next time!" },
		failMissionColor
	]
	call missionHint;

	diag_log format ["WASTELAND SERVER - %1 Mission%2 failed: %3", MISSION_PROC_TYPE_NAME, _controllerSuffix, _missionType];
}
else
{
	// Mission completed

	if (isNull _leader) then
	{
		_lastPos = markerPos _marker;
	}
	else
	{
		_lastPos = _leader call fn_getPos3D;
		_floorHeight = (getPos _leader) select 2;
		_lastPos set [2, (_lastPos select 2) - _floorHeight];
	};

	if (!isNil "_successExec") then { call _successExec };

	if (!isNil "_vehicle" && {typeName _vehicle == "OBJECT"}) then
	{
		_vehicle setVariable ["R3F_LOG_disabled", false, true];
		_vehicle setVariable ["A3W_missionVehicle", true];
	};

	if (!isNil "_vehicles" && {typeName _vehicles == "ARRAY"}) then
	{
		{
			if (!isNil "_x" && {typeName _x == "OBJECT"}) then
			{
				_x setVariable ["R3F_LOG_disabled", false, true];
				_x setVariable ["A3W_missionVehicle", true];
			};
		} forEach _vehicles;
	};

	[
		"Objective Complete",
		_missionType,
		_missionPicture,
		_successHintMessage,
		successMissionColor
	]
	call missionHint;

	diag_log format ["WASTELAND SERVER - %1 Mission%2 complete: %3", MISSION_PROC_TYPE_NAME, _controllerSuffix, _missionType];
};

deleteGroup _aiGroup;
deleteMarker _marker;

if (!isNil "_locationsArray") then
{
	[_locationsArray, _missionLocation, false] call setLocationState;
};
