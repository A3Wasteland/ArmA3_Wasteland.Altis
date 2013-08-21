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
_positions = [[2580.06,6032.54,1.42215],[6654.43,4822.27,0.576691],[4286.94,2530.58,0.439018],[2073.06,1027.24,0.90735]];
_randomPos = _positions call BIS_fnc_SelectRandom;

diag_log format["WASTELAND SERVER - Main Mission Waiting to run: %1",_missionType];
[mainMissionDelayTime] call createWaitCondition;
diag_log format["WASTELAND SERVER - Main Mission Resumed: %1",_missionType];

[_missionMarkerName,_randomPos,_missionType] call createClientMarker;

CivGrpM = createGroup civilian;
_vehicleClass = ["O_Boat_Armed_01_hmg_F","B_Boat_Armed_01_minigun_F"] call BIS_fnc_selectRandom;

//Vehicle Class, Posistion, Fuel, Ammo, Damage
_vehicle = [_vehicleClass,_randomPos,0.05,1,0,"NONE"] call createMissionVehicle2;
_vehicle setVariable [call vChecksum, true, false];

_slbox = createVehicle ["Box_NATO_Support_F",[(_randomPos select 0), (_randomPos select 1),0],[], 0, "NONE"];
[_slbox,"mission_Main_A3snipers"] call fn_refillbox;
_slbox2 = createVehicle ["Box_East_Support_F",[(_randomPos select 0), (_randomPos select 1) - 10,0],[], 0, "NONE"];
[_slbox2,"mission_USSpecial2"] call fn_refillbox;

[CivGrpM,_randomPos] spawn createLargeDivers;

_picture = getText (configFile >> "cfgVehicles" >> typeOf _vehicle >> "picture");
_vehicleName = getText (configFile >> "cfgVehicles" >> typeOf _vehicle >> "displayName");
_hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Main Objective</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center' color='%5'>Some sunken treasureboxes with rare weapons have been spotted in the ocean near the marker.<img size='5' image='%2'/>However, a heavily armed expedition with a<t color='%4'> %3</t> is allready on site! <t color='%4'>You need diving gear and a underwater weapon for this one!</t> get it at a gunstore!</t>", _missionType, _picture, _vehicleName,  mainMissionColor, subTextColor];
messageSystem = _hint;
publicVariable "messageSystem";

diag_log format["WASTELAND SERVER - Main Mission Waiting to be Finished: %1",_missionType];

_startTime = floor(time);
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

_vehicle setVehicleLock "UNLOCKED";
_vehicle setVariable ["R3F_LOG_disabled", false, true];

if(_result == 1) then
{
	//Mission Failed.
	if not(isNil "_slbox") then {deleteVehicle _slbox;};
	if not(isNil "_slbox2") then {deleteVehicle _slbox2;};
	if not(isNil "_vehicle") then {deleteVehicle _vehicle;};
	{if (vehicle _x != _x) then { deleteVehicle vehicle _x; }; deleteVehicle _x;}forEach units CivGrpM;
	{deleteVehicle _x;}forEach units CivGrpM;
    deleteGroup CivGrpM;
    _hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Objective Failed</t><br/><t align='center' color='%2'>------------------------------</t><br/><t align='center' color='%2' size='1.25'>%1</t><br/><t align='center' color='%3'>FAIL! The sunken treasures have been taken away by the enemy!</t>", _missionType, failMissionColor, subTextColor];
	messageSystem = _hint;
    publicVariable "messageSystem";
    diag_log format["WASTELAND SERVER - Main Mission Failed: %1",_missionType];
} else {
	//Mission Complete.
    deleteGroup CivGrpM;
    _hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Objective Complete</t><br/><t align='center' color='%2'>------------------------------</t><br/><t align='center' color='%3' size='1.25'>%1</t><br/><t align='center' color='%3'>The sunken treasures are yours to take.</t> You might ass-well take their boat to transport it!</t>", _missionType, successMissionColor, subTextColor];
	messageSystem = _hint;
    publicVariable "messageSystem";
    diag_log format["WASTELAND SERVER - Main Mission Success: %1",_missionType];
};

//Reset Mission Spot.
//MissionSpawnMarkers select _randomIndex set[1, false];
[_missionMarkerName] call deleteClientMarker;