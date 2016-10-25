// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: mission_geoCache.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, AgentRev, edit by CRE4MPIE
//	@file Created: 08/12/2012 15:19

if (!isServer) exitwith {};
#include "sideMissionDefines.sqf"

private ["_nbUnits","_box1"];

_setupVars =
{
	_missionType = "Geocache Location";
	_locationsArray = MissionSpawnMarkers;
	_nbUnits = if (missionDifficultyHard) then { AI_GROUP_LARGE } else { AI_GROUP_MEDIUM };
};


_setupObjects =
{
	_missionPos = markerPos _missionLocation;
	_boxPos = _missionPos vectorAdd ([[25 + random 20, 0, 0], random 360] call BIS_fnc_rotateVector2D);	
		//delete existing base parts and vehicles at location
	_baseToDelete = nearestObjects [_missionPos, ["All"], 25];
	{ deleteVehicle _x } forEach _baseToDelete; 

_randomBox = ["mission_Side_Geocache"] call BIS_fnc_selectRandom;
	_box1 = createVehicle ["B_supplyCrate_F", _boxPos, [], 5, "None"];
	_box1 setDir random 360;
	[_box1, _randomBox] call fn_refillbox;
	
	
	{ _x setVariable ["R3F_LOG_disabled", true, true] } forEach [_box1];

	_missionHintText = "an Abandoned GeoCache has been marked on the map - get there first and it's yours !";

};

_ignoreAiDeaths = true;
_waitUntilMarkerPos = nil;
_waitUntilExec = nil;
_waitUntilCondition = nil;
_waitUntilSuccessCondition = {{isPlayer _x && _x distance _boxPos < 5} count playableUnits > 0};


_failedExec =
{
	// Mission failed
	{ deleteVehicle _x } forEach [_box1];
};

_successExec =
{
	// Mission completed
	{ _x setVariable ["R3F_LOG_disabled", false, true] } forEach [_box1];

	_successHintMessage = "The GeoCache supplies have been claimed !";
};

_this call sideMissionProcessor;
