// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: mission_WepCache.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, AgentRev
//	@file Created: 08/12/2012 15:19

if (!isServer) exitwith {};
#include "sideMissionDefines.sqf"

private ["_nbUnits", "_box1", "_box2"];

_setupVars =
{
	_missionType = "Aircraft Wreck";
	_locationsArray = [ForestMissionMarkers, MissionSpawnMarkers] select (ForestMissionMarkers isEqualTo []);
	_nbUnits = if (missionDifficultyHard) then { AI_GROUP_LARGE } else { AI_GROUP_MEDIUM };
};

_setupObjects =
{
	_missionPos = markerPos _missionLocation;

	_box1 = createVehicle ["Box_NATO_Wps_F", _missionPos, [], 5, "None"];
	_box1 setDir random 360;
	[_box1, "mission_USSpecial"] call fn_refillbox;

	_box2 = createVehicle ["Box_East_Wps_F", _missionPos, [], 5, "None"];
	_box2 setDir random 360;
	[_box2, "mission_USLaunchers"] call fn_refillbox;

	{ _x setVariable ["R3F_LOG_disabled", true, true] } forEach [_box1, _box2];

	_aiGroup = createGroup CIVILIAN;
	[_aiGroup, _missionPos, _nbUnits] call createCustomGroup;

	_missionHintText = "A weapon cache has been spotted near the marker.";
};

_waitUntilMarkerPos = nil;
_waitUntilExec = nil;
_waitUntilCondition = nil;

_failedExec =
{
	// Mission failed
	{ deleteVehicle _x } forEach [_box1, _box2];
};

_successExec =
{
	// Mission completed
	{ _x setVariable ["R3F_LOG_disabled", false, true] } forEach [_box1, _box2];

	_successHintMessage = "The airwreck supplies have been collected, well done.";
};

_this call sideMissionProcessor;
