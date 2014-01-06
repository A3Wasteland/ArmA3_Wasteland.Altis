//	@file Version: 1.1
//	@file Name: moneyMissionController.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap, Sanjo, AgentRev
//	@file Created: 08/12/2012 15:19

if (!isServer) exitWith {};
#include "moneyMissions\moneyMissionDefines.sqf"

private ["_moneyMissions", "_moneyMissionsOdds", "_missionType", "_nextMission", "_missionRunning", "_hint", "_missionOK"];
// private ["_mission", "_notPlayedmoneyMissions", "_nextMissionIndex"];

diag_log "WASTELAND SERVER - Started money Mission State";

_moneyMissions =
[			// increase the number behind the mission (weight) to increase the chance of the mission to be selected
	["mission_MoneyShipment", 1],
	["mission_SunkenTreasure", 1]
//  	["mission_MobMoney", 1]
]; 



_moneyMissionsOdds = [];
{
	_moneyMissionsOdds set [_forEachIndex, if (count _x > 1) then { _x select 1 } else { 1 }];
	
	// Attempt to compile every mission for early bug detection
	compile preprocessFileLineNumbers format ["server\missions\moneyMissions\%1.sqf", _x select 0];
} forEach _moneyMissions;

while {true} do
{
    _missionOK = false;
    while {!_missionOK} do
    {
        _missionOK = true;
        _nextMission = [_moneyMissions, _moneyMissionsOdds] call fn_selectRandomWeighted;
        _missionType = _nextMission select 0;
        if (mainMissionHeliPatrol AND (_MissionType == "mission_HostileHelicopter")) then 
        { 
            _missionOK = false;
            diag_log format["WASTELAND SERVER - Skipping money Mission (main running): %1",_missionType];
        };
        if (mainMissionUW AND (_MissionType == "mission_SunkenSupplys")) then 
        {
            _missionOK = false;
            diag_log format["WASTELAND SERVER - Skipping money Mission (main running): %1",_missionType];
        };
        if ( ( floor(time) < ( A3W_moneyMissionDelayTime + 300 ) ) and (_MissionType == "mission_HostileHelicopter") ) then 
        { 
            _missionOK = false;
            diag_log format["WASTELAND SERVER - Skipping money Mission (too early): %1",_missionType];
        };
    };

	
    if (_missionType == "mission_SunkenTreasure") then {
        moneyMissionUW = true;
    } else {
        moneyMissionUW = false;
    };
    
    
	_missionRunning = execVM format ["server\missions\moneyMissions\%1.sqf", _missionType];
	
    diag_log format["WASTELAND SERVER - Execute New money Mission: %1",_missionType];
    _hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>money Objective</t><br/><t align='center' color='%2'>------------------------------</t><br/><t color='%3' size='1.0'>Starting in %1 Minutes</t>", A3W_moneyMissionDelayTime / 60, moneyMissionColor, subTextColor];
	[_hint] call hintBroadcast;
	waitUntil{sleep 0.1; scriptDone _missionRunning};
    sleep 5;
};
