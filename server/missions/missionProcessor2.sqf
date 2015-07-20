// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: missionProcessor.sqf
//	@file Author: AgentRev

if (!isServer) exitwith {};

#define MISSION_LOCATION_COOLDOWN (10*60)
#define MISSION_TIMER_EXTENSION (15*60)

private ["_controllerSuffix", "_missionTimeout", "_availableLocations", "_missionLocation", "_leader", "_marker", "_failed", "_complete", "_startTime", "_oldAiCount", "_leaderTemp", "_newAiCount", "_adjustTime", "_lastPos", "_floorHeight", "_startAiCount", "_reinforcementsCalled", "_reinforceChanceRoll", "_reinforcementsToCall", "_aiGroup2"];

// Variables that can be defined in the mission script :
private ["_missionType", "_locationsArray", "_aiGroup", "_missionPos", "_missionPicture", "_missionHintText", "_successHintMessage", "_failedHintMessage", "_reinforceChance", "_minReinforceGroups","_maxReinforceGroups"];

_controllerSuffix = [_this, 0, "", [""]] call BIS_fnc_param;


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




waitUntil
{
	uiSleep 1;

	if (!isNil "_waitUntilMarkerPos") then { _marker setMarkerPos (call _waitUntilMarkerPos) };
	if (!isNil "_waitUntilExec") then { call _waitUntilExec };		//Nil

	_failed = ((!isNil "_waitUntilCondition" && {call _waitUntilCondition}) || diag_tickTime - _startTime >= _missionTimeout);
diag_log format ["A3WASTELAND SERVER - BOUNTY - _failed = %1",_failed];
	
	if (!isNil "_waitUntilSuccessCondition" && {call _waitUntilSuccessCondition}) then
	{
		_failed = false;
		_complete = true;
diag_log format ["A3WASTELAND SERVER - BOUNTY - _failed = %1, _complete = %2",_failed, _complete];		
	};

	(_failed || _complete)
};

if (_failed) then
{
	// Mission failed
	
	if (!isNil "_failedExec") then { call _failedExec };

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

	if (!isNil "_successExec") then { call _successExec };

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

deleteMarker _marker;

if (!isNil "_locationsArray") then
{
	[_locationsArray, _missionLocation, false] call setLocationState;
};
