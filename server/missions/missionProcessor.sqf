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
_aiGroup = grpNull;
_aiGroup2 = grpNull;

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
_aiGroup setVariable ["A3W_missionMarkerName", _marker, true];

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
_oldAiCount = 0;

//Logic and Variables for AI Reinforcements///////////////////////////////////////////////
_reinforcementsCalled = false;
_startAiCount = 0;
_startAiCount = count units _aiGroup;
_reinforceChanceRoll = floor (random 99); //When processor gets called for a mission exe, what did fate say for reinforcements?
if (isNil "_minReinforceGroups") then { _minReinforceGroups = 1};
if (isNil "_maxReinforceGroups") then { _maxReinforceGroups = 1};
if (isNil "_reinforceChance") then { _reinforceChance = 0};
if (_minReinforceGroups > _maxReinforceGroups) then {_maxReinforceGroups = _minReinforceGroups};//Prevents errors later on if a typo is in mission config 
_reinforcementsToCall = 0; //initialize variable
_reinforcementsToCall = ceil (random _maxReinforceGroups); //Find random number of reinforcements to be sent, up to max
if (_minReinforceGroups > _reinforcementsToCall) then {_reinforcementsToCall = _minReinforceGroups}; //Make sure we call for at least the minimum number of groups
//End of reinforcement Block///////////////////////////////////////////////////////////////


if (isNil "_ignoreAiDeaths") then { _ignoreAiDeaths = false };

waitUntil
{
	uiSleep 1;

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

	_newAiCount = count units _aiGroup;

	if (_newAiCount < _oldAiCount) then
	{
		// some units were killed, mission expiry will be reset to 15 mins if it's currently lower than that
		_adjustTime = if (_missionTimeout < MISSION_TIMER_EXTENSION) then { MISSION_TIMER_EXTENSION - _missionTimeout } else { 0 };
		_startTime = _startTime max (diag_tickTime - ((MISSION_TIMER_EXTENSION - _adjustTime) max 0));
	};
	_oldAiCount = _newAiCount;

//// AI Reinforcement Section  //Apoc ////////////////////////////////////////////////////////////////////////////////////////////////////
	if (((_newAiCount < _startAiCount/2) && (!_reinforcementsCalled)) && !(MISSION_PROC_TYPE_NAME == "Bounty")) then
	{
		if (_reinforceChance > _reinforceChanceRoll) then 
		{
			for "_i" from 1 to _reinforcementsToCall step 1 do{
				nul = [_marker,4,true,false,1500,"random",true,200,150,8,0.5,50,true,false,false,true,_marker,false,"default",_aigroup,nil,1,false,200] execVM "addons\AI_Spawn\heliParadrop.sqf";
				diag_log format ["WASTELAND SERVER - %1 Mission%2 Reinforcements Called: %3.  %5 of %4 AI remaining", MISSION_PROC_TYPE_NAME, _controllerSuffix, _missionType, _startAiCount, _newAiCount];
				_reinforcementsCalled = True;
				sleep 30;
			};
			if ((floor random(100))>85) then 
			{
				_aiGroup2 = [_marker] execVM "server\missions\factoryMethods\createReinforceAttackHelicopter.sqf";
				diag_log format ["WASTELAND SERVER - %1 Mission%2 Attack Helo Called: %3.  %5 of %4 AI remaining", MISSION_PROC_TYPE_NAME, _controllerSuffix, _missionType, _startAiCount, _newAiCount];
			};
		};
	};
//// AI Reinforcement Section  //Apoc ////////////////////////////////////////////////////////////////////////////////////////////////////

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
	
	if (count units _aiGroup2 > 0) then
	{
		{ moveOut _x; deleteVehicle _x } forEach units _aiGroup2; //This group only exists if attack heli reinforcement is called upon
	};
	
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
		_vehicle setVariable ["A3W_missionVehicle", true, true];

		if (!isNil "fn_manualVehicleSave") then
		{
			_vehicle call fn_manualVehicleSave;
		};
	};

	if (!isNil "_vehicles" && {typeName _vehicles == "ARRAY"}) then
	{
		{
			if (!isNil "_x" && {typeName _x == "OBJECT"}) then
			{
				_x setVariable ["R3F_LOG_disabled", false, true];
				_x setVariable ["A3W_missionVehicle", true, true];

				if (!isNil "fn_manualVehicleSave") then
				{
					_x call fn_manualVehicleSave;
				};
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
	
	if (count units _aiGroup2 > 0) then
	{
		sleep 60; //delay to give heli a chance to track down the victors
		{ moveOut _x; deleteVehicle _x } forEach units _aiGroup2; //This group only exists if attack heli reinforcement is called upon
	};
};

deleteGroup _aiGroup;
deleteGroup _aiGroup2;
deleteMarker _marker;

if (!isNil "_locationsArray") then
{
	[_locationsArray, _missionLocation, false] call setLocationState;
};
