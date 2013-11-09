//	@file Version: 1.1
//	@file Name: mainMissionController.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap, Sanjo, AgentRev
//	@file Created: 08/12/2012 15:19



if (!isServer) exitWith {};
#include "mainMissions\mainMissionDefines.sqf"
private ["_MainMissions", "_MainMissionsOdds", "_missionType", "_nextMission", "_missionRunning", "_hint", "_missionOK"];
// private ["_mission", "_notPlayedMainMissions", "_nextMissionIndex"];

diag_log "WASTELAND SERVER - Started Main Mission State";

_MainMissions =
[		// increase the number (weight) to increase the missions chance to be selected
	["mission_ArmedDiversquad", 1],
	["mission_Coastal_Convoy", 1], 
	["mission_Convoy", 1],
	["mission_HostileHeliFormation", 0.5],  
	["mission_APC", 1],
	["mission_MBT", 1],
	["mission_LightArmVeh", 1],
	["mission_ArmedHeli", 1],
	["mission_CivHeli", 1],
	["mission_Outpost", 1]
];

// _notPlayedMainMissions = +_MainMissions;

_MainMissionsOdds = [];
{
	_MainMissionsOdds set [_forEachIndex, if (count _x > 1) then { _x select 1 } else { 1 }];
	
	// Attempt to compile every mission for early bug detection
	compile preprocessFileLineNumbers format ["server\missions\mainMissions\%1.sqf", _x select 0];
} forEach _MainMissions;

while {true} do
{
    _missionOK = false;
    while {!_missionOK} do
    {
        _missionOK = true;
        _nextMission = [_MainMissions, _MainMissionsOdds] call fn_selectRandomWeighted;
        _missionType = _nextMission select 0;
        if (sideMissionHeliPatrol AND ((_MissionType == "mission_HostileHeliFormation") OR (_MissionType == "mission_Coastal_Convoy"))) then
        {
            _missionOK = false;
            diag_log format["WASTELAND SERVER - Skipping Main Mission (side running): %1",_missionType];
        };
        if (sideMissionUW AND (_MissionType == "mission_ArmedDiversquad")) then
        {
            _missionOK = false;
            diag_log format["WASTELAND SERVER - Skipping Main Mission (side running): %1",_missionType];
        };
        if ( ( floor(time) < ( A3W_mainMissionDelayTime + 300 ) ) and ((_MissionType == "mission_HostileHeliFormation") OR (_MissionType == "mission_Coastal_Convoy"))) then
        {
            _missionOK = false;
            diag_log format["WASTELAND SERVER - Skipping Main Mission (too early): %1",_missionType];
        };

    };

    if ( _missionType == "mission_ArmedDiversquad" ) then {
        mainMissionUW = true;
    } else {
        mainMissionUW = false;
    };
    
    if (_missionType == "mission_HostileHeliFormation" OR _missionType == "mission_Coastal_Convoy") then {
        mainMissionHeliPatrol = true;
    } else {
        mainMissionHeliPatrol = false;
    };
    
	_missionRunning = execVM format ["server\missions\mainMissions\%1.sqf", _missionType];
	
    diag_log format["WASTELAND SERVER - Execute New Main Mission: %1",_missionType];
    _hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Main Objective</t><br/><t align='center' color='%2'>------------------------------</t><br/><t color='%3' size='1.0'>Starting in %1 Minutes</t>", A3W_mainMissionDelayTime / 60, mainMissionColor, subTextColor];
	[_hint] call hintBroadcast;
	waitUntil{sleep 0.1; scriptDone _missionRunning};
    sleep 5; 
};
