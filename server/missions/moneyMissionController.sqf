//	@file Version: 1.0
//	@file Name: moneyMissionController.sqf
//	@file Author: His_Shadow
//	@file Created: 07/09/2013 15:19

if (!isServer) exitWith {};

#include "moneyMissions\moneyMissionDefines.sqf";

private ["_MoneyMissions","_mission","_notPlayedMoneyMissions","_nextMissionIndex","_missionRunning","_hint"];

diag_log "WASTELAND SERVER - Started Money Mission State";

_MoneyMissions =
[
	["mission_MoneyShipment"],
	//["mission_MobMoney"],
	["mission_SunkenTreasure"]
];
//_MoneyMissions = [[mission_MoneyShipment, "mission_MoneyShipment"]];
_notPlayedMoneyMissions = +_MoneyMissions;

while {true} do
{
    //Select Mission
    _nextMissionIndex = floor random count _notPlayedMoneyMissions;
    _mission = _notPlayedMoneyMissions select _nextMissionIndex select 0;
    
    if (count _notPlayedMoneyMissions > 1) then {
        _notPlayedMoneyMissions set [_nextMissionIndex, -1];
        _notPlayedMoneyMissions = _notPlayedMoneyMissions - [-1];
    } else {
        _notPlayedMoneyMissions = +_MoneyMissions;
    };
    
	_missionRunning = execVM format ["server\missions\moneyMissions\%1.sqf", _mission];
	
    diag_log format["WASTELAND SERVER - Execute New Money Mission: %1",_mission];
    if (moneyMissionDelayTime < 60) then {
        _hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Money Objective</t><br/><t align='center' color='%2'>------------------------------</t><br/><t color='%3' size='1.0'>Starting in %1 seconds</t>", moneyMissionDelayTime, moneyMissionColor, subTextColor];
    } else {
        _hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Money Objective</t><br/><t align='center' color='%2'>------------------------------</t><br/><t color='%3' size='1.0'>Starting in %1 minutes</t>", moneyMissionDelayTime / 60, moneyMissionColor, subTextColor];
    };
	messageSystem = _hint;
	if (!isDedicated) then { call serverMessage };
	publicVariable "messageSystem";
	waitUntil{sleep 0.1; scriptDone _missionRunning};
    sleep 5; 
};
