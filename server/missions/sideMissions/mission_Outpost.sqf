// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: mission_VehicleCapture.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, JoSchaap, AgentRev
//	@file Created: 08/12/2012 15:19

if (!isServer) exitwith {};
#include "sideMissionDefines.sqf";

private ["_nbUnits", "_outpost", "_objects"];

_setupVars =
{
	_missionType = "Enemy Outpost";
	_locationsArray = MissionSpawnMarkers;
	_nbUnits = AI_GROUP_MEDIUM;
};

_setupObjects =
{
	_missionPos = markerPos _missionLocation;

	_outpost = (call compile preprocessFileLineNumbers "server\missions\outposts\outpostsList.sqf") call BIS_fnc_selectRandom;
	_objects = [_outpost, _missionPos, 0] call createOutpost;

	_aiGroup = createGroup CIVILIAN;
	[_aiGroup, _missionPos, _nbUnits, 5] call createCustomGroup;

	_missionHintText = format ["An armed <t color='%1'>outpost</t> containing weapon crates has been spotted near the marker. Go capture it!", sideMissionColor]
};

_waitUntilMarkerPos = nil;
_waitUntilExec = nil;
_waitUntilCondition = nil;

_failedExec =
{
	// Mission failed
	{ deleteVehicle _x } forEach _objects;
};

_successExec =
{
	// Mission complete
	{ _x setVariable ["R3F_LOG_disabled", false, true] } forEach _objects;
	[_locationsArray, _missionLocation, _objects] call setLocationObjects;

	_successHintMessage = "The outpost has been captured. Good work.";
};

_this call sideMissionProcessor;
