//	@file Version: 1.1
//	@file Name: mainMissionController.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap, Sanjo, AgentRev
//	@file Created: 08/12/2012 15:19

if (!isServer) exitWith {};
#include "mainMissions\mainMissionDefines.sqf";

private ["_MainMissions", "_MainMissionsOdds", "_missionType", "_nextMission", "_missionRunning", "_hint"];
// private ["_mission", "_notPlayedMainMissions", "_nextMissionIndex"];

diag_log "WASTELAND SERVER - Started Main Mission State";

_MainMissions =
[		// increase the number (weight) to increase the missions chance to be selected
	["mission_ArmedDiversquad", 0.25],
	["mission_Coastal_Convoy", 0.25], 
	["mission_Convoy", 1],
	["mission_HostileHeliFormation", 0.25],  
	["mission_APC", 0.75],
	["mission_MBT", 0.5],
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
    _nextMission = [_MainMissions, _MainMissionsOdds] call fn_selectRandomWeighted;
    _missionType = _nextMission select 0;
    
    /*	
		_nextMissionIndex = floor random count _notPlayedMainMissions;
		_mission = _notPlayedMainMissions select _nextMissionIndex select 0;
		_missionType = _notPlayedMainMissions select _nextMissionIndex select 1;
	
		if (count _notPlayedMainMissions > 1) then {
			_notPlayedMainMissions set [_nextMissionIndex, -1];
			_notPlayedMainMissions = _notPlayedMainMissions - [-1];
		} else {
			_notPlayedMainMissions = +_MainMissions;
		};
	*/
    
	_missionRunning = execVM format ["server\missions\mainMissions\%1.sqf", _missionType];
	
    diag_log format["WASTELAND SERVER - Execute New Main Mission: %1",_missionType];
    _hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Main Objective</t><br/><t align='center' color='%2'>------------------------------</t><br/><t color='%3' size='1.0'>Starting in %1 Minutes</t>", mainMissionDelayTime / 60, mainMissionColor, subTextColor];
	[_hint] call hintBroadcast;
	waitUntil{sleep 0.1; scriptDone _missionRunning};
    sleep 5; 
};
