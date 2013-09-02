//	@file Version: 1.1
//	@file Name: sideMissionController.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap, Sanjo, AgentRev
//	@file Created: 08/12/2012 15:19

#include "setup.sqf"
#include "sideMissions\sideMissionDefines.sqf";

if (!isServer) exitWith {};

private ["_SideMissions", "_SideMissionsOdds", "_missionType", "_nextMission", "_missionRunning", "_hint"];
// private ["_mission", "_notPlayedSideMissions", "_nextMissionIndex"];

diag_log format["WASTELAND SERVER - Started Side Mission State"];

_SideMissions =
[
	["mission_HostileHelicopter", 19],  //weight of 19 for debugging purposes
	["mission_MiniConvoy", 1], 
	// ["mission_SunkenSupplies", 1],
	["mission_AirWreck", 1],
	["mission_WepCache", 1],
	["mission_Truck", 1]
]; 

// _notPlayedSideMissions = +_SideMissions;

_SideMissionsOdds = [];
{
	_SideMissionsOdds set [_forEachIndex, if (count _x > 1) then { _x select 1 } else { 1 }];
} forEach _SideMissions;

while {true} do
{
	_nextMission = [_SideMissions, _SideMissionsOdds] call fn_selectRandomWeighted;
    _missionType = _nextMission select 0;
	
	/*
		_nextMissionIndex = floor random count _notPlayedSideMissions;
		_mission = _notPlayedSideMissions select _nextMissionIndex select 0;
		_missionType = _notPlayedSideMissions select _nextMissionIndex select 1;
		
		if (count _notPlayedSideMissions > 1) then {
			_notPlayedSideMissions set [_nextMissionIndex, -1];
			_notPlayedSideMissions = _notPlayedSideMissions - [-1];
		} else {
			_notPlayedSideMissions = +_SideMissions;
		};
	*/
    
	_missionRunning = execVM format ["server\missions\sideMissions\%1.sqf", _missionType];
	
    diag_log format["WASTELAND SERVER - Execute New Side Mission: %1",_missionType];
    _hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Side Objective</t><br/><t align='center' color='%2'>------------------------------</t><br/><t color='%3' size='1.0'>Starting in %1 Minutes</t>", sideMissionDelayTime / 60, sideMissionColor, subTextColor];
	[_hint] call hintBroadcast;
	waitUntil{sleep 0.1; scriptDone _missionRunning};
    sleep 5;
};
