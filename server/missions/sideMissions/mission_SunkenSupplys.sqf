// @file Version: 1.0
// @file Name: mission_SunkenSupplys.sqf
// @file Author: JoSchaap
//#include "setup.sqf"
#include "sideMissionDefines.sqf";
if(!isServer) exitwith {};
private ["_result","_missionMarkerName","_missionType","_startTime","_randomPos","_vehicleClass","_sbox","_picture","_vehicleName","_hint","_currTime","_playerPresent","_unitsAlive","_positions"];

//Mission Initialization.
_result = 0;
_missionMarkerName = "SunkenCache_Marker";
_missionType = "Sunken Supplies";
_startTime = floor(time);

diag_log format["WASTELAND SERVER - Side Mission Started: %1",_missionType];

//Pick a mission Location
_positions = [[20495.2,19679.1,-9.53674e-007],[28357.8,24426.6,0.000114441],[21995.3,6125.05,0.00022316],[11425.6,10471.2,0],[5091.69,9722.63,0],[2937.46,22280.3,0.000240326],[9298.15,23444.3,0.00319862]];
_randomPos = _positions call BIS_fnc_SelectRandom;

diag_log format["WASTELAND SERVER - Side Mission Waiting to run: %1",_missionType];
[sideMissionDelayTime] call createWaitCondition;
diag_log format["WASTELAND SERVER - Side Mission Resumed: %1",_missionType];

//mark the area
[_missionMarkerName,_randomPos,_missionType] call createClientMarker;

//setup the mission at that location
_sbox = createVehicle ["Box_NATO_Support_F",[(_randomPos select 0), (_randomPos select 1),0],[], 0, "NONE"];
[_sbox,"mission_Side_USSpecial"] call fn_refillbox;

//disable damage to the box, disable logistics untill the misison completes
_sbox addEventHandler ["HandleDamage", {false}];
_sbox setVariable ["R3F_LOG_disabled", true, true];

//announce the mission
_hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Side Objective</t><br/><t align='center' color='%2'>------------------------------</t><br/><t align='center' color='%3' size='1.25'>%1</t><br/><t align='center' color='%3'>Sunken supplies have been spotted in the ocean near the marker. You might need diving gear and an underwater weapon for this one!</t>", _missionType,  sideMissionColor, subTextColor];
[_hint] call hintBroadcast;

//spawn a group of AI divers
CivGrpS = createGroup civilian;
[CivGrpS,_randomPos] spawn createSmallDivers;

diag_log format["WASTELAND SERVER - Side Mission Waiting to be Finished: %1",_missionType];
_startTime = floor(time);

//wait until there is a result
waitUntil
{
    sleep 1; 
	_playerPresent = false;
	_currTime = floor(time);
    if(_currTime - _startTime >= sideMissionTimeout) then {_result = 1;};
    {if((isPlayer _x) AND (_x distance _sbox <= missionRadiusTrigger)) then {_playerPresent = true};}forEach playableUnits;
    _unitsAlive = ({alive _x} count units CivGrpS);
    (_result == 1) OR ((_playerPresent) AND (_unitsAlive < 1)) OR ((damage _sbox) == 1)
};

//handle the result
if(_result == 1) then
{
	//Mission Failed. delete everything, announce failure
    deleteVehicle _sbox;
	{if (vehicle _x != _x) then { deleteVehicle vehicle _x; }; deleteVehicle _x;}forEach units CivGrpS;
    deleteGroup CivGrpS;
    _hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Objective Failed</t><br/><t align='center' color='%2'>------------------------------</t><br/><t align='center' color='%2' size='1.25'>%1</t><br/><t align='center' color='%3'>FAIL! The sunken supplies disappeared!</t>", _missionType, failMissionColor, subTextColor];
	[_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Side Mission Failed: %1",_missionType];
} else {
	//Mission Complete.
	// check if the box is broken, if so delete it and the units (failsafe, shouldnt be needed anymore)
	if ((damage _sbox) == 1) then {
		    deleteVehicle _sbox;
			{if (vehicle _x != _x) then { deleteVehicle vehicle _x; }; deleteVehicle _x;}forEach units CivGrpS;
	};
	//unlock the box, remove godmode from the box
	_sbox addEventHandler ["HandleDamage", {false}];
	_sbox setVariable ["R3F_LOG_disabled", true, true];
	//cleanup the group
    deleteGroup CivGrpS;
	//anounce mission completion
    _hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Objective Complete</t><br/><t align='center' color='%2'>------------------------------</t><br/><t align='center' color='%3' size='1.25'>%1</t><br/><t align='center' color='%3'>The sunken supplies have been collected well done team</t>", _missionType, successMissionColor, subTextColor];
	[_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Side Mission Success: %1",_missionType];
};

//Reset Mission Spot.
//MissionSpawnMarkers select _randomIndex set[1, false];
[_missionMarkerName] call deleteClientMarker;