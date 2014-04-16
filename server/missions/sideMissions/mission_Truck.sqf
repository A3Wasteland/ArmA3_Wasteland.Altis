//	@file Version: 1.0
//	@file Name: mission_Truck.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, AgentRev
//	@file Created: 08/12/2012 15:19
//	@file Args:

if (!isServer) exitwith {};
#include "sideMissionDefines.sqf";

private ["_result", "_missionMarkerName", "_missionType", "_startTime", "_returnData", "_randomPos", "_randomIndex", "_vehicleClass", "_vehicle", "_picture", "_vehicleName", "_hint", "_currTime", "_playerPresent"];

//Mission Initialization.
_result = 0;
_missionMarkerName = "Truck_Marker";
_missionType = "Supply Truck";
_startTime = floor(time);

diag_log format["WASTELAND SERVER - Side Mission Started: %1",_missionType];

//Get Mission Location
_returnData = call createMissionLocation;
_randomPos = _returnData select 0;
_randomIndex = _returnData select 1;

diag_log format["WASTELAND SERVER - Side Mission Waiting to run: %1",_missionType];
[sideMissionDelayTime] call createWaitCondition;
diag_log format["WASTELAND SERVER - Side Mission Resumed: %1",_missionType];

[_missionMarkerName,_randomPos,_missionType] call createClientMarker;

_vehicleClass =
[
	"B_Truck_01_covered_F",
	"B_Truck_01_fuel_F",
	"B_Truck_01_medical_F",
	"B_Truck_01_Repair_F",
	"O_Truck_03_covered_F",
	"O_Truck_03_fuel_F",
	"O_Truck_03_medical_F",
	"O_Truck_03_repair_F",
	"I_Truck_02_covered_F",
	"I_Truck_02_fuel_F",
	"I_Truck_02_medical_F",
	"I_Truck_02_box_F"
] call BIS_fnc_selectRandom;

//Vehicle Class, Posistion, Fuel, Ammo, Damage
_vehicle = [_vehicleClass,_randomPos,1,1,0,"NONE"] call createMissionVehicle;

_vehicle call fn_refilltruck;

_picture = getText (configFile >> "cfgVehicles" >> typeOf _vehicle >> "picture");
_vehicleName = getText (configFile >> "cfgVehicles" >> typeOf _vehicle >> "displayName");

// Remove " (Covered)" from vehicle name when applicable
if ([_vehicleName, (count toArray _vehicleName) - 10] call BIS_fnc_trimString == " (Covered)") then
{
	_vehicleName = [_vehicleName, 0, (count toArray _vehicleName) - 11] call BIS_fnc_trimString;
};

_hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Side Objective</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>A <t color='%4'>%3</t> has been immobilized, go get it for your team.</t>", _missionType, _picture, _vehicleName, sideMissionColor, subTextColor];
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
	
    if(_currTime - _startTime >= sideMissionTimeout) then {_result = 1;};
    {if((isPlayer _x) AND (_x distance _vehicle <= missionRadiusTrigger)) then {_playerPresent = true};}forEach playableUnits;
    _unitsAlive = ({alive _x} count units _CivGrpM);
	(_result == 1) OR ((_playerPresent) AND (_unitsAlive < 1)) OR ((damage _vehicle) == 1)
};

_vehicle setVehicleLock "UNLOCKED";
_vehicle disableTIEquipment true;
_vehicle setVariable ["R3F_LOG_disabled", false, true];

if(_result == 1) then
{
	//Mission Failed.
    if (!isNil "_vehicle") then { deleteVehicle _vehicle };
	{ deleteVehicle _x }forEach units _CivGrpM;
    deleteGroup _CivGrpM;
    _hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Objective Failed</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>Objective failed, better luck next time.</t>", _missionType, _picture, _vehicleName, failMissionColor, subTextColor];
	[_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Side Mission Failed: %1",_missionType];
} else {
	//Mission Complete.
	deleteGroup _CivGrpM;
    _hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Objective Complete</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>The truck has been captured, well done.</t>", _missionType, _picture, _vehicleName, successMissionColor, subTextColor];
	[_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Side Mission Success: %1",_missionType];
};

//Reset Mission Spot.
MissionSpawnMarkers select _randomIndex set[1, false];
[_missionMarkerName] call deleteClientMarker;
