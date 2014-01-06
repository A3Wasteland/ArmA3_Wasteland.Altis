//	@file Version: 1.1
//	@file Name: sideMissionController.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap, Sanjo, AgentRev
//	@file Created: 08/12/2012 15:19

if (!isServer) exitWith {};
#include "sideMissions\sideMissionDefines.sqf"

private ["_SideMissions", "_SideMissionsOdds", "_missionType", "_nextMission", "_missionRunning", "_hint", "_missionOK"];
// private ["_mission", "_notPlayedSideMissions", "_nextMissionIndex"];

diag_log "WASTELAND SERVER - Started Side Mission State";

_SideMissions =
[			// increase the number behind the mission (weight) to increase the chance of the mission to be selected
	["mission_HostileHelicopter",0.5], 
	["mission_MiniConvoy", 1], 
	["mission_SunkenSupplys", 1],
	["mission_AirWreck", 1.5],
	["mission_WepCache", 1.5],
	["mission_Truck", 1]
]; 



_SideMissionsOdds = [];
{
	_SideMissionsOdds set [_forEachIndex, if (count _x > 1) then { _x select 1 } else { 1 }];
	
	// Attempt to compile every mission for early bug detection
	compile preprocessFileLineNumbers format ["server\missions\sideMissions\%1.sqf", _x select 0];
} forEach _SideMissions;

while {true} do
{
    _missionOK = false;
    while {!_missionOK} do
    {
        _missionOK = true;
        _nextMission = [_SideMissions, _SideMissionsOdds] call fn_selectRandomWeighted;
        _missionType = _nextMission select 0;
        if (mainMissionHeliPatrol AND (_MissionType == "mission_HostileHelicopter")) then 
        { 
            _missionOK = false;
            diag_log format["WASTELAND SERVER - Skipping Side Mission (main running): %1",_missionType];
        };
        if (mainMissionUW AND (_MissionType == "mission_SunkenSupplys")) then 
        {
            _missionOK = false;
            diag_log format["WASTELAND SERVER - Skipping Side Mission (main running): %1",_missionType];
        };
        if ( ( floor(time) < ( A3W_sideMissionDelayTime + 300 ) ) and (_MissionType == "mission_HostileHelicopter") ) then 
        { 
            _missionOK = false;
            diag_log format["WASTELAND SERVER - Skipping Side Mission (too early): %1",_missionType];
        };
    };

	
    if (_missionType == "mission_SunkenSupplys") then {
        sideMissionUW = true;
    } else {
        sideMissionUW = false;
    };
    
    if (_missionType == "mission_HostileHelicopter") then {
        sideMissionHeliPatrol = true;
    } else {
        sideMissionHeliPatrol = false;
    };
    
	_missionRunning = execVM format ["server\missions\sideMissions\%1.sqf", _missionType];
	
    diag_log format["WASTELAND SERVER - Execute New Side Mission: %1",_missionType];
    _hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Side Objective</t><br/><t align='center' color='%2'>------------------------------</t><br/><t color='%3' size='1.0'>Starting in %1 Minutes</t>", A3W_sideMissionDelayTime / 60, sideMissionColor, subTextColor];
	[_hint] call hintBroadcast;
	waitUntil{sleep 0.1; scriptDone _missionRunning};
    sleep 5;
};
