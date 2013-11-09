//	@file Name: mission_SunkenSupplys.sqf

if (!isServer) exitwith {};
#include "sideMissionDefines.sqf"

private ["_result","_missionMarkerName","_missionType","_startTime","_randomPos","_vehicleClass","_sbox","_picture","_vehicleName","_hint","_currTime","_playerPresent","_unitsAlive","_positions"];

//Mission Initialization.
_result = 0;
_missionMarkerName = "SunkenCache_Marker";
_missionType = "Sunken Supplies";
_startTime = floor(time);

diag_log format["WASTELAND SERVER - Side Mission Started: %1",_missionType];

//Get Mission Location
_positions =
[
	[20495.2, 19679.1],
	[28357.8, 24426.6],
	[21995.3, 6125.05],
	[11425.6, 10471.2],
	[5091.69, 9722.63],
	[2937.46, 22280.3],
	[9298.15, 23444.3]
];
_randomPos = _positions call BIS_fnc_SelectRandom;

diag_log format["WASTELAND SERVER - Side Mission Waiting to run: %1",_missionType];
[A3W_sideMissionDelayTime] call createWaitCondition;
diag_log format["WASTELAND SERVER - Side Mission Resumed: %1",_missionType];

[_missionMarkerName,_randomPos,_missionType] call createClientMarker;

_sbox = createVehicle ["Box_NATO_Wps_F",[(_randomPos select 0), (_randomPos select 1),0],[], 0, "NONE"];
[_sbox,"mission_USSpecial"] call fn_refillbox;
_sbox allowDamage false;
_sbox setVariable ["R3F_LOG_disabled", true, true];

_hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Side Objective</t><br/><t align='center' color='%2'>------------------------------</t><br/><t align='center' color='%3' size='1.25'>%1</t><br/><t align='center' color='%3'>Sunken supplies have been spotted in the ocean near the marker, and are heavily guarded. Diving gear and an underwater weapon are recommended.</t>", _missionType,  sideMissionColor, subTextColor];
[_hint] call hintBroadcast;

_CivGrpS = createGroup civilian;
[_CivGrpS,_randomPos] spawn createSmallDivers;

diag_log format["WASTELAND SERVER - Side Mission Waiting to be Finished: %1",_missionType];
_startTime = floor(time);

waitUntil
{
    sleep 1; 
	_playerPresent = false;
    _currTime = floor(time);
    if(_currTime - _startTime >= A3W_sideMissionTimeout) then {_result = 1;};
    {if((isPlayer _x) AND (_x distance _sbox <= A3W_missionRadiusTrigger)) then {_playerPresent = true};}forEach playableUnits;
    _unitsAlive = ({alive _x} count units _CivGrpS);
    (_result == 1) OR ((_playerPresent) AND (_unitsAlive < 1)) OR ((damage _sbox) == 1)
};

_sbox setVariable ["R3F_LOG_disabled", false, true];

if(_result == 1) then
{
	//Mission Failed.
    deleteVehicle _sbox;
	{if (vehicle _x != _x) then { deleteVehicle vehicle _x; }; deleteVehicle _x;}forEach units _CivGrpS;
    deleteGroup _CivGrpS;
    _hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Objective Failed</t><br/><t align='center' color='%2'>------------------------------</t><br/><t align='center' color='%2' size='1.25'>%1</t><br/><t align='center' color='%3'>Objective failed, better luck next time.</t>", _missionType, failMissionColor, subTextColor];
	[_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Side Mission Failed: %1 - %2 enemy left - Player Present %3",_missionType, _unitsAlive, _playerPresent];
} else {
	//Mission Complete.
	// check if the vehicle is broken, if so delete it and the units
	deleteGroup _CivGrpS;
    _hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Objective Complete</t><br/><t align='center' color='%2'>------------------------------</t><br/><t align='center' color='%3' size='1.25'>%1</t><br/><t align='center' color='%3'>The sunken supplies have been collected, well done.</t>", _missionType, successMissionColor, subTextColor];
	[_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Side Mission Success: %1",_missionType];
};

//Reset Mission Spot.
//MissionSpawnMarkers select _randomIndex set[1, false];
[_missionMarkerName] call deleteClientMarker;
