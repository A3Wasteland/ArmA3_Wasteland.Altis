// @file Version: 1.0
// @file Name: mission_ArmedDiversquad.sqf
// @file Author: JoSchaap
#include "setup.sqf"
#include "mainMissionDefines.sqf";

if(!isServer) exitwith {};
private ["_result","_missionMarkerName","_missionType","_startTime","_randomPos","_vehicleClass","_vehicle","_slbox","_slbox2","_picture","_vehicleName","_hint","_currTime","_playerPresent","_unitsAlive","_positions"];

//Mission Initialization.
_result = 0;
_missionMarkerName = "ArmedDiveSq_Marker";
_missionType = "Armed Diving Expedition";

_startTime = floor(time);
diag_log format["WASTELAND SERVER - Main Mission Started: %1",_missionType];

//Get Mission Location
_positions = [[25461.8,23708.4,0.00310612],[22051,12723.3,0.0845184],[13285.9,14049.9,0.00111198],[8445.31,7125.42,0.186203],[3634.34,17198.5,0],[6251.06,22687.6,0]];
_randomPos = _positions call BIS_fnc_SelectRandom;

diag_log format["WASTELAND SERVER - Main Mission Waiting to run: %1",_missionType];
[mainMissionDelayTime] call createWaitCondition;
diag_log format["WASTELAND SERVER - Main Mission Resumed: %1",_missionType];

// mark the location
[_missionMarkerName,_randomPos,_missionType] call createClientMarker;

// setup the mission
CivGrpM = createGroup civilian;
_vehicleClass = ["O_Boat_Armed_01_hmg_F","B_Boat_Armed_01_minigun_F"] call BIS_fnc_selectRandom;

//Create a vehicle
_vehicle = [_vehicleClass,_randomPos,0.05,1,0,"NONE"] call createMissionVehicle2;
_vehicle setVariable [call vChecksum, true, false];

// create the rewardboxes, disable damage and logisics untill the mission is over
_slbox = createVehicle ["Box_NATO_Support_F",[(_randomPos select 0), (_randomPos select 1),0],[], 0, "NONE"];
[_slbox,"mission_Main_A3snipers"] call fn_refillbox;
_slbox addEventHandler ["HandleDamage", {false}];
_slbox setVariable ["R3F_LOG_disabled", true, true];

_slbox2 = createVehicle ["Box_East_Support_F",[(_randomPos select 0), (_randomPos select 1) - 10,0],[], 0, "NONE"];
[_slbox2,"mission_USSpecial2"] call fn_refillbox;
_slbox2 addEventHandler ["HandleDamage", {false}];
_slbox2 setVariable ["R3F_LOG_disabled", true, true];

// spawn AI
[CivGrpM,_randomPos] spawn createLargeDivers;
// add vehicle to the AI group, drain the fuel to avoid AI from driving the boat
CivGrpM addVehicle _vehicle;
_vehicle setFuel 0;

// announce the mission
_picture = getText (configFile >> "cfgVehicles" >> typeOf _vehicle >> "picture");
_vehicleName = getText (configFile >> "cfgVehicles" >> typeOf _vehicle >> "displayName");
_hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Main Objective</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center' color='%5'>Some sunken treasureboxes with rare weapons have been spotted in the ocean near the marker.<img size='5' image='%2'/>However, a heavily armed expedition with a<t color='%4'> %3</t> is allready on site! <t color='%4'>You need diving gear and a underwater weapon for this one!</t> get it at a gunstore!</t>", _missionType, _picture, _vehicleName,  mainMissionColor, subTextColor];
[_hint] call hintBroadcast;

diag_log format["WASTELAND SERVER - Main Mission Waiting to be Finished: %1",_missionType];
_startTime = floor(time);

// wait until there is a result
waitUntil
{
    sleep 1; 
	_playerPresent = false;
	_currTime = floor(time);
    if(_currTime - _startTime >= mainMissionTimeout) then {_result = 1;};
    {if((isPlayer _x) AND (_x distance _slbox <= missionRadiusTrigger)) then {_playerPresent = true};}forEach playableUnits;
    _unitsAlive = ({alive _x} count units CivGrpM);
    (_result == 1) OR ((_playerPresent) AND (_unitsAlive < 1)) OR ((damage _slbox) == 1)
};

if(_result == 1) then
{
	//Mission Failed. bring out the mob and clean-up that mess
	if not(isNil "_slbox") then {deleteVehicle _slbox;};
	if not(isNil "_slbox2") then {deleteVehicle _slbox2;};
	if not(isNil "_vehicle") then {deleteVehicle _vehicle;};
	{if (vehicle _x != _x) then { deleteVehicle vehicle _x; }; deleteVehicle _x;}forEach units CivGrpM;
    deleteGroup CivGrpM;
	//announce this failure to the world
    _hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Objective Failed</t><br/><t align='center' color='%2'>------------------------------</t><br/><t align='center' color='%2' size='1.25'>%1</t><br/><t align='center' color='%3'>FAIL! The sunken treasures have been taken away by the enemy!</t>", _missionType, failMissionColor, subTextColor];
	[_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Main Mission Failed: %1",_missionType];
} else {
	//Mission Complete. unlock rewards, add some fuel to the boat
	if not(isNil "_vehicle") then {
		_vehicle setFuel 0.05;
		_vehicle setVehicleLock "UNLOCKED";
		_vehicle setVariable ["R3F_LOG_disabled", false, true];
	};
	_slbox addEventHandler ["HandleDamage", {true}];
	_slbox setVariable ["R3F_LOG_disabled", false, true];
	_slbox2 addEventHandler ["HandleDamage", {true}];
	_slbox2 setVariable ["R3F_LOG_disabled", false, true];
	// announce mission completion 
    _hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Objective Complete</t><br/><t align='center' color='%2'>------------------------------</t><br/><t align='center' color='%3' size='1.25'>%1</t><br/><t align='center' color='%3'>The sunken treasures are yours to take.</t> You might ass-well take their boat to transport it!</t>", _missionType, successMissionColor, subTextColor];
	[_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Main Mission Success: %1",_missionType];
	deleteGroup CivGrpM;
};

//Reset Mission Spot.
//MissionSpawnMarkers select _randomIndex set[1, false];
[_missionMarkerName] call deleteClientMarker;
