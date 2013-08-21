#include "setup.sqf"
#include "sideMissionDefines.sqf";

if(!isServer) exitwith {};

private ["_result","_missionMarkerName","_missionType","_startTime","_randomPos","_vehicleClass","_sbox","_picture","_vehicleName","_hint","_currTime","_playerPresent","_unitsAlive","_positions"];

//Mission Initialization.
_result = 0;
_missionMarkerName = "SunkenCache_Marker";
_missionType = "Sunken Supplies";
#ifdef __A2NET__
_startTime = floor(netTime);
#else
_startTime = floor(time);
#endif

diag_log format["WASTELAND SERVER - Side Mission Started: %1",_missionType];

//Get Mission Location
//_returnData = call createMissionLocation;
_positions = [[1457.11,4787.65,0.317751],[1741.52,4101.18,0.0999908],[1662.2,2735.27,1.21553],[4174.62,7310.75,0.218368]];
_randomPos = _positions call BIS_fnc_SelectRandom;
//_randomIndex = _returnData select 1;

diag_log format["WASTELAND SERVER - Side Mission Waiting to run: %1",_missionType];
[sideMissionDelayTime] call createWaitCondition;
diag_log format["WASTELAND SERVER - Side Mission Resumed: %1",_missionType];

[_missionMarkerName,_randomPos,_missionType] call createClientMarker;

/*
_marker = createMarkerLocal ["SunkenCache_Marker", _randomPos];
"SunkenCache_Marker" setMarkerShapeLocal "ICON";
"SunkenCache_Marker" setMarkerTypeLocal "mil_dot";
"SunkenCache_Marker" setMarkerColorLocal "ColorRed";
"SunkenCache_Marker" setMarkerSizeLocal [1,1];
"SunkenCache_Marker" setMarkerTextLocal "Sunken Supplies";
*/

_sbox = createVehicle ["Box_NATO_Support_F",[(_randomPos select 0), (_randomPos select 1),0],[], 0, "NONE"];
[_sbox,"mission_Side_USSpecial"] call fn_refillbox;

_hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Side Objective</t><br/><t align='center' color='%2'>------------------------------</t><br/><t align='center' color='%3' size='1.25'>%1</t><br/><t align='center' color='%3'>Sunken supplies have been spotted in the ocean near the marker. You might need diving gear and an underwater weapon for this one!</t>", _missionType,  sideMissionColor, subTextColor];
messageSystem = _hint;
publicVariable "messageSystem";

CivGrpS = createGroup civilian;
[CivGrpS,_randomPos] spawn createSmallDivers;

diag_log format["WASTELAND SERVER - Side Mission Waiting to be Finished: %1",_missionType];
#ifdef __A2NET__
_startTime = floor(netTime);
#else
_startTime = floor(time);
#endif
waitUntil
{
    sleep 1; 
	_playerPresent = false;
	#ifdef __A2NET__
	_currTime = floor(netTime);
	#else
    _currTime = floor(time);
	#endif
    if(_currTime - _startTime >= sideMissionTimeout) then {_result = 1;};
    {if((isPlayer _x) AND (_x distance _sbox <= missionRadiusTrigger)) then {_playerPresent = true};}forEach playableUnits;
    _unitsAlive = ({alive _x} count units CivGrpS);
    (_result == 1) OR ((_playerPresent) AND (_unitsAlive < 1)) OR ((damage _sbox) == 1)
};

if(_result == 1) then
{
	//Mission Failed.
    deleteVehicle _sbox;
	{if (vehicle _x != _x) then { deleteVehicle vehicle _x; }; deleteVehicle _x;}forEach units CivGrpS;
	{deleteVehicle _x;}forEach units CivGrpS;
    deleteGroup CivGrpS;
    _hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Objective Failed</t><br/><t align='center' color='%2'>------------------------------</t><br/><t align='center' color='%2' size='1.25'>%1</t><br/><t align='center' color='%3'>FAIL! The sunken supplies disapeared!</t>", _missionType, failMissionColor, subTextColor];
	messageSystem = _hint;
    publicVariable "messageSystem";
    diag_log format["WASTELAND SERVER - Side Mission Failed: %1",_missionType];
} else {
	//Mission Complete.
	// check if the vehicle is broken, if so delete it and the units
	if ((damage _sbox) == 1) then {
		    deleteVehicle _sbox;
		{deleteVehicle _x;}forEach units CivGrpS;
	};
    deleteGroup CivGrpS;
    _hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Objective Complete</t><br/><t align='center' color='%2'>------------------------------</t><br/><t align='center' color='%3' size='1.25'>%1</t><br/><t align='center' color='%3'>The sunken supplies have been collected well done team</t>", _missionType, successMissionColor, subTextColor];
	messageSystem = _hint;
    publicVariable "messageSystem";
    diag_log format["WASTELAND SERVER - Side Mission Success: %1",_missionType];
};

//Reset Mission Spot.
//MissionSpawnMarkers select _randomIndex set[1, false];
[_missionMarkerName] call deleteClientMarker;