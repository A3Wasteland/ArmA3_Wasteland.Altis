// @file Version: 1.0
// @file Name: mission_ArmedDiversquad.sqf
// @file Author: JoSchaap 

if (!isServer) exitwith {};
#include "mainMissionDefines.sqf";

private ["_result","_missionMarkerName","_missionType","_startTime","_randomPos","_vehicleClass","_vehicle","_slbox","_slbox2","_picture","_vehicleName","_hint","_currTime","_playerPresent","_unitsAlive","_positions"];

//Mission Initialization.
_result = 0;
_missionMarkerName = "ArmedDiveSq_Marker";
_missionType = "Armed Diving Expedition";

_startTime = floor(time);

diag_log format["WASTELAND SERVER - Main Mission Started: %1",_missionType];

//Get Mission Location
_positions =
[
	[25461.8, 23708.4],
	[22051.0, 12723.3],
	[13285.9, 14049.9],
	[8445.31, 7125.42],
	[3634.34, 17198.5],
	[6251.06, 22687.6]
]; 
_randomPos = _positions call BIS_fnc_SelectRandom;

diag_log format["WASTELAND SERVER - Main Mission Waiting to run: %1",_missionType];
[mainMissionDelayTime] call createWaitCondition;
diag_log format["WASTELAND SERVER - Main Mission Resumed: %1",_missionType];

[_missionMarkerName,_randomPos,_missionType] call createClientMarker;

_CivGrpM = createGroup civilian;
_vehicleClass = ["B_Boat_Armed_01_minigun_F", "O_Boat_Armed_01_hmg_F", "I_Boat_Armed_01_minigun_F"] call BIS_fnc_selectRandom;

//Vehicle Class, Posistion, Fuel, Ammo, Damage
_vehicle = [_vehicleClass,_randomPos,0,1,0,"NONE"] call createMissionVehicle2;

_slbox = createVehicle ["Box_IND_WpsSpecial_F",[(_randomPos select 0), (_randomPos select 1),0],[], 0, "NONE"];
[_slbox,"mission_Main_A3snipers"] call fn_refillbox;
_slbox allowDamage false;
_slbox setVariable ["R3F_LOG_disabled", true, true];

_slbox2 = createVehicle ["Box_NATO_WpsSpecial_F",[(_randomPos select 0), (_randomPos select 1) - 10,0],[], 0, "NONE"];
[_slbox2,"mission_USSpecial2"] call fn_refillbox;
_slbox2 allowDamage false;
_slbox2 setVariable ["R3F_LOG_disabled", true, true];

[_CivGrpM,_randomPos] spawn createLargeDivers;

_picture = getText (configFile >> "cfgVehicles" >> typeOf _vehicle >> "picture");
_vehicleName = getText (configFile >> "cfgVehicles" >> typeOf _vehicle >> "displayName");
_hint = parseText format
[
	"<t align='center' color='%4' shadow='2' size='1.75'>Main Objective</t><br/>" +
	"<t align='center' color='%4'>------------------------------</t><br/>" +
	"<t align='center' color='%5' size='1.25'>%1</t><br/>" +
	"<t align='center'><img size='5' image='%2'/></t><br/>" +
	"<t align='center' color='%5'>An armed expedition is trying to recover sunken ammo crates near the marker.<br/>If you want to capture them, you will need diving gear and an underwater weapon.</t>",
	_missionType, _picture, _vehicleName,  mainMissionColor, subTextColor
];
[_hint] call hintBroadcast;

diag_log format["WASTELAND SERVER - Main Mission Waiting to be Finished: %1",_missionType];
_startTime = floor(time);

waitUntil
{
    sleep 1; 
	_playerPresent = false;
	_currTime = floor(time);
    if(_currTime - _startTime >= mainMissionTimeout) then {_result = 1;};
    {if((isPlayer _x) AND (_x distance _slbox <= missionRadiusTrigger)) then {_playerPresent = true};}forEach playableUnits;
    _unitsAlive = ({alive _x} count units _CivGrpM);
    (_result == 1) OR ((_playerPresent) AND (_unitsAlive < 1)) OR ((damage _slbox) == 1)
};

_vehicle setFuel 1;
_vehicle setVehicleLock "UNLOCKED";
_vehicle setVariable ["R3F_LOG_disabled", false, true];
_slbox setVariable ["R3F_LOG_disabled", false, true];
_slbox2 setVariable ["R3F_LOG_disabled", false, true];

if(_result == 1) then
{
	//Mission Failed.
	if not(isNil "_slbox") then {deleteVehicle _slbox;};
	if not(isNil "_slbox2") then {deleteVehicle _slbox2;};
	if not(isNil "_vehicle") then {deleteVehicle _vehicle;};
	{if (vehicle _x != _x) then { deleteVehicle vehicle _x; }; deleteVehicle _x;}forEach units _CivGrpM;
    deleteGroup _CivGrpM;
    _hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Objective Failed</t><br/><t align='center' color='%2'>------------------------------</t><br/><t align='center' color='%2' size='1.25'>%1</t><br/><t align='center' color='%3'>Objective failed, better luck next time.</t>", _missionType, failMissionColor, subTextColor];
	[_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Main Mission Failed: %1",_missionType];
} else {
	//Mission Complete.
    deleteGroup _CivGrpM;
    _hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Objective Complete</t><br/><t align='center' color='%2'>------------------------------</t><br/><t align='center' color='%3' size='1.25'>%1</t><br/><t align='center' color='%3'>The sunken crates have been captured, well done.</t>", _missionType, successMissionColor, subTextColor];
	[_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Main Mission Success: %1",_missionType];
};

//Reset Mission Spot.
//MissionSpawnMarkers select _randomIndex set[1, false];
[_missionMarkerName] call deleteClientMarker;
