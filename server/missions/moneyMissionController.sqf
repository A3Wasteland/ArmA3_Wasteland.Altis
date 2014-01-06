//	@file Version: 1.0
//	@file Name: moneyMissionController.sqf
//	@file Author: His_Shadow
//	@file Created: 07/09/2013 15:19

if (!isServer) exitWith {};

#include "moneyMissions\moneyMissionDefines.sqf";

private ["_MoneyMissions", "_MoneyMissionsOdds", "_mission", "_nextMission", "_missionRunning", "_hint"];

diag_log "WASTELAND SERVER - Started Money Mission State";

_MoneyMissions = 
[
	["mission_MoneyShipment", 1],
	["mission_SunkenTreasure", 1]
//  	["mission_MobMoney", 1]

];

_MoneyMissionsOdds = [];
{
	_MoneyMissionsOdds set [_forEachIndex, if (count _x > 1) then { _x select 1 } else { 1 }];
	
	//Attempt to compile every mission for early bug detection
	compile preprocessFileLineNumbers format ["server\missions\moneyMissions\%1.sqf", _x select 0];
} forEach _MoneyMissions;

while {true} do
{
	_nextMission = [_MoneyMissions, _MoneyMissionsOdds] call fn_selectRandomWeighted;
	_mission = _nextMission select 0;

	_missionRunning = execVM format ["server\missions\moneyMissions\%1.sqf", _mission];

	diag_log format["WASTELAND SERVER - Execute New Money Mission: %1", _mission];

	_hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Money Objective</t><br/><t align='center' color='%2'>------------------------------</t><br/><t color='%3' size='1.0'>Starting in %1 minutes</t>", moneyMissionDelayTime / 60, moneyMissionColor, subTextColor];
	[_hint] call hintBroadcast;
	
	waitUntil{sleep 0.1; scriptDone _missionRunning};
    sleep 5; 
};
