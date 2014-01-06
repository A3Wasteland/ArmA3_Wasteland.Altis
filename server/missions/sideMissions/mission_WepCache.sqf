//	@file Version: 1.0
//	@file Name: mission_WepCache.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy
//	@file Created: 08/12/2012 15:19
//	@file Args:

if (!isServer) exitwith {};
#include "sideMissionDefines.sqf"

private ["_result", "_missionMarkerName", "_missionType", "_startTime", "_returnData", "_randomPos", "_randomIndex", "_vehicleClass", "_box", "_box2", "_picture", "_vehicleName", "_hint", "_currTime", "_playerPresent", "_unitsAlive"];

//Mission Initialization.
_result = 0;
_missionMarkerName = "WeaponCache_Marker";
_missionType = "Weapon Cache";
_startTime = floor(time);

diag_log format["WASTELAND SERVER - Side Mission Started: %1",_missionType];

//Get Mission Location
_returnData = call createMissionLocation;
_randomPos = _returnData select 0;
_randomIndex = _returnData select 1;

diag_log format["WASTELAND SERVER - Side Mission Waiting to run: %1",_missionType];
[A3W_sideMissionDelayTime] call createWaitCondition;
diag_log format["WASTELAND SERVER - Side Mission Resumed: %1",_missionType];

[_missionMarkerName,_randomPos,_missionType] call createClientMarker;

_box = createVehicle ["Box_East_Wps_F",[(_randomPos select 0), (_randomPos select 1),0],[], 0, "NONE"];
[_box,"mission_USLaunchers"] call fn_refillbox;
_box allowDamage false;
_box setVariable ["R3F_LOG_disabled", true, true];

_box2 = createVehicle ["Box_NATO_Wps_F",[(_randomPos select 0), (_randomPos select 1) - 10,0],[], 0, "NONE"];
[_box2,"mission_USSpecial"] call fn_refillbox;
_box2 allowDamage false;
_box2 setVariable ["R3F_LOG_disabled", true, true];

_hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Side Objective</t><br/><t align='center' color='%2'>------------------------------</t><br/><t align='center' color='%3' size='1.25'>%1</t><br/><t align='center' color='%3'>A weapon cache has been spotted near the marker.</t>", _missionType,  sideMissionColor, subTextColor];
[_hint] call hintBroadcast;

_CivGrpM = createGroup civilian;
[_CivGrpM,_randomPos] spawn createMidGroup;

diag_log format["WASTELAND SERVER - Side Mission Waiting to be Finished: %1",_missionType];
_startTime = floor(time);

waitUntil
{
    sleep 1; 
	_playerPresent = false;
	_currTime = floor(time);
    if(_currTime - _startTime >= A3W_sideMissionTimeout) then {_result = 1;};
    {if((isPlayer _x) AND (_x distance _box <= A3W_missionRadiusTrigger)) then {_playerPresent = true};}forEach playableUnits;
    _unitsAlive = ({alive _x} count units _CivGrpM);
    (_result == 1) OR ((_playerPresent) AND (_unitsAlive < 1)) OR ((damage _box) == 1)
};

_box setVariable ["R3F_LOG_disabled", false, true];
_box2 setVariable ["R3F_LOG_disabled", false, true];

if(_result == 1) then
{
	//Mission Failed.
    if (!isNil "_box") then { deleteVehicle _box };
    if (!isNil "_box2") then { deleteVehicle _box2 };
    { deleteVehicle _x }forEach units _CivGrpM;
    deleteGroup _CivGrpM;
    _hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Objective Failed</t><br/><t align='center' color='%2'>------------------------------</t><br/><t align='center' color='%2' size='1.25'>%1</t><br/><t align='center' color='%3'>Objective failed, better luck next time.</t>", _missionType, failMissionColor, subTextColor];
	[_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Side Mission Failed: %1 - %2 enemy left - Player Present %3",_missionType, _unitsAlive, _playerPresent];
} else {
	//Mission Complete.
    deleteGroup _CivGrpM;
    _hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Objective Complete</t><br/><t align='center' color='%2'>------------------------------</t><br/><t align='center' color='%3' size='1.25'>%1</t><br/><t align='center' color='%3'>The weapon cache has been captured, well done.</t>", _missionType, successMissionColor, subTextColor];
	[_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Side Mission Success: %1",_missionType];
};

//Reset Mission Spot.
MissionSpawnMarkers select _randomIndex set[1, false];
[_missionMarkerName] call deleteClientMarker;
