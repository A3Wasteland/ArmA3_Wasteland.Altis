// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: missionController.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

private ["_controllerNum", "_tempController", "_controllerSuffix", "_missionsFolder", "_missionDelay", "_availableMissions", "_missionsList", "_nextMission", "_readyMissions"];

_controllerNum = param [0, 1, [0]];
_tempController = param [1, false, [false]];
_controllerSuffix = "";

if (_controllerNum > 1) then
{
	_controllerSuffix = format [" %1", _controllerNum];
};

diag_log format ["WASTELAND SERVER - Started %1 Mission%2 Controller", MISSION_CTRL_TYPE_NAME, _controllerSuffix];

_missionsFolder = MISSION_CTRL_FOLDER;
[MISSION_CTRL_PVAR_LIST, MISSION_CTRL_FOLDER] call attemptCompileMissions;

_missionDelay = MISSION_CTRL_DELAY;

while {true} do
{
	_nextMission = nil;

	while {isNil "_nextMission"} do
	{
		_availableMissions = [MISSION_CTRL_PVAR_LIST, { !(_x select 2) }] call BIS_fnc_conditionalSelect;
		// _availableMissions = MISSION_CTRL_PVAR_LIST; // If you want to allow multiple missions of the same type running along, uncomment this line and comment the one above

		//Enforce limit of total water missions
		_readyMissions = missionNamespace getVariable ["A3W_ready_missions",[]];
		if(["A3W_waterMissionLimit", 100] call getPublicVar <= {_x in missionType_water} count _readyMissions) then{
			_availableMissions = _availableMissions select {!(_x select 0 in missionType_water)};
		};

		if (count _availableMissions > 0) then
		{
			_missionsList = _availableMissions call generateMissionWeights;
			_nextMission = _missionsList call fn_selectRandomWeighted;
		}
		else
		{
			uiSleep 60;
		};
	};

	//Add to list of missions ready to be spawned
	_readyMissions = missionNamespace getVariable ["A3W_ready_missions",[]];
	_readyMissions pushBack _nextMission;
	missionNamespace setVariable ["A3W_ready_missions", _readyMissions];

	[MISSION_CTRL_PVAR_LIST, _nextMission, true] call setMissionState;

	diag_log format ["WASTELAND SERVER - %1 Mission%2 waiting to run: %3", MISSION_CTRL_TYPE_NAME, _controllerSuffix, _nextMission];

	[
		parseText format
		[
			"<t color='%1' shadow='2' size='1.75'>%2 Objective%3</t><br/>" +
			"<t color='%1'>------------------------------</t><br/>" +
			"<t color='%4' size='1.0'>Starting in %5 minutes</t>",
			MISSION_CTRL_COLOR_DEFINE,
			MISSION_CTRL_TYPE_NAME,
			_controllerSuffix,
			subTextColor,
			_missionDelay / 60
		]
	] call hintBroadcast;

	uiSleep _missionDelay;

	// these should be defined in the mission script
	private ["_setupVars", "_setupObjects", "_waitUntilMarkerPos", "_waitUntilExec", "_waitUntilCondition", "_waitUntilSuccessCondition", "_ignoreAiDeaths", "_failedExec", "_successExec"];

	[_controllerSuffix] call compile preprocessFileLineNumbers format ["server\missions\%1\%2.sqf", MISSION_CTRL_FOLDER, _nextMission];

	//Remove from list of missions ready to be spawned
	_readyMissions = missionNamespace getVariable ["A3W_ready_missions",[]];
	missionNamespace setVariable ["A3W_ready_missions", _readyMissions - [_nextMission]];

	[MISSION_CTRL_PVAR_LIST, _nextMission, false] call setMissionState;

	if (_tempController) exitWith {};
	uiSleep 5;
};