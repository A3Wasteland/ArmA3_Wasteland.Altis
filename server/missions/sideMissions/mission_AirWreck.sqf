//	@file Version: 1.0
//	@file Name: mission_AirWreck.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy
//	@file Created: 08/12/2012 15:19
//	@file Args:

if (!isServer) exitwith {};
#include "sideMissionDefines.sqf";

private ["_result", "_missionMarkerName", "_missionType", "_startTime", "_returnData", "_randomPos", "_randomIndex", "_vehicleClass", "_box", "_box2", "_vehicle", "_picture", "_vehicleName", "_hint", "_currTime", "_playerPresent", "_unitsAlive"];

//Mission Initialization.
_result = 0;
_missionMarkerName = "AirWreck_Marker";
_missionType = "Aircraft Wreck";
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

//Vehicle Class, Posistion, Fuel, Ammo, Damage
_vehicle = ["O_Heli_Light_02_unarmed_F",[(_randomPos select 0) + 50, (_randomPos select 1) + 50,0],0,0,1,"NONE"] call createMissionVehicle;

_box = createVehicle ["Box_East_WpsSpecial_F",[(_randomPos select 0), (_randomPos select 1),0],[], 0, "NONE"];
[_box,"mission_USLaunchers"] call fn_refillbox;
_box allowDamage false;
_box setVariable ["R3F_LOG_disabled", true, true];

_box2 = createVehicle ["Box_NATO_WpsSpecial_F",[(_randomPos select 0), (_randomPos select 1) - 10,0],[], 0, "NONE"];
[_box2,"mission_USSpecial"] call fn_refillbox;
_box2 allowDamage false;
_box2 setVariable ["R3F_LOG_disabled", true, true];

_picture = getText (configFile >> "cfgVehicles" >> typeOf _vehicle >> "picture");
_vehicleName = getText (configFile >> "cfgVehicles" >> typeOf _vehicle >> "displayName");
_hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Side Objective</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>A helicopter has come down under enemy fire!</t>", _missionType, _picture, _vehicleName, sideMissionColor, subTextColor];
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
    {if((isPlayer _x) AND (_x distance _box <= missionRadiusTrigger)) then {_playerPresent = true};}forEach playableUnits;
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
    if (!isNil "_vehicle") then { deleteVehicle _vehicle };
    { deleteVehicle _x }forEach units _CivGrpM;
    deleteGroup _CivGrpM;
    _hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Objective Failed</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>Objective failed, better luck next time.</t>", _missionType, _picture, _vehicleName, failMissionColor, subTextColor];
	[_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Side Mission Failed: %1",_missionType];
} else {
	//Mission Complete.
    deleteVehicle _vehicle;
    deleteGroup _CivGrpM;
    _hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Objective Complete</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>The airwreck supplies have been collected, well done.</t>", _missionType, _picture, _vehicleName, successMissionColor, subTextColor];
	[_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Side Mission Success: %1",_missionType];
};

//Reset Mission Spot.
MissionSpawnMarkers select _randomIndex set[1, false];
[_missionMarkerName] call deleteClientMarker;
