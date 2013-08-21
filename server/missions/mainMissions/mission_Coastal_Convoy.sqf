private ["_missionMarkerName","_missionType","_picture","_vehicleName","_hint","_waypoint","_waypoints","_group","_vehicles","_marker","_failed","_startTime","_numWaypoints","_ammobox","_createVehicle","_leader","_randomboat","_randomheli"];

#include "mainMissionDefines.sqf"

_missionMarkerName = "Coastal_Marker";
_missionType = "Coastal Patrol";

diag_log format["WASTELAND SERVER - Main Mission Started: %1", _missionType];

diag_log format["WASTELAND SERVER - Main Mission Waiting to run: %1", _missionType];
[mainMissionDelayTime] call createWaitCondition;
diag_log format["WASTELAND SERVER - Main Mission Resumed: %1", _missionType];

_group = createGroup civilian;
_randomboat = ["O_Boat_Armed_01_hmg_F","B_Boat_Armed_01_minigun_F","I_Boat_Armed_01_minigun_F"] call BIS_fnc_selectRandom;
_randomheli = ["O_Heli_Attack_02_black_F","O_Heli_Light_02_F","B_Heli_Transport_01_F","B_Heli_Light_01_armed_F","B_Heli_Transport_01_camo_F"] call BIS_fnc_selectRandom;

_createVehicle = {
    private ["_type","_position","_direction","_group","_vehicle","_soldier"];
    
    _type = _this select 0;
    _position = _this select 1;
    _direction = _this select 2;
    _group = _this select 3;
    
    _vehicle = _type createVehicle _position;
    _vehicle setDir _direction;
    clearMagazineCargoGlobal _vehicle;
    clearWeaponCargoGlobal _vehicle;
	_vehicle setVariable [call vChecksum, true, false];
    _group addVehicle _vehicle;
    
    _soldier = [_group, _position] call createRandomSoldierC; 
    _soldier moveInDriver _vehicle;
    _soldier = [_group, _position] call createRandomSoldierC;
    _soldier assignAsGunner _vehicle;
    _soldier moveInTurret [_vehicle, [0]];
	if ((_vehicle isKindOf "O_Boat_Armed_01_hmg_F") || (_vehicle isKindOf "B_Boat_Armed_01_minigun_F") || (_vehicle isKindOf "I_Boat_Armed_01_minigun_F") || (_vehicle isKindOf "B_Heli_Transport_01_F") || (_vehicle isKindOf "B_Heli_Transport_01_camo_F")) then 
	{
		_soldier = [_group, _position] call createRandomSoldierC; 
		_soldier assignAsGunner _vehicle;
		_soldier moveInTurret [_vehicle, [1]];
	};
	
	if ("CMFlareLauncher" in getArray (configFile >> "CfgVehicles" >> _type >> "weapons")) then
	{
		{
			if (_x isKindOf "60Rnd_CMFlare_Chaff_Magazine") then
			{
				_vehicle removeMagazinesTurret [_x, [-1]];
			};
		} forEach (_vehicle magazinesTurret [-1]);
	};
	_vehicle setVehicleLock "LOCKED";
	_vehicle spawn cleanVehicleWreck;
	_vehicle
};

_vehicles = [];
_vehicles set [0, [_randomheli, [1877.32, 6284.56, 0.00134969], 9, _group] call _createVehicle];
_vehicles set [1, [_randomboat, [1865.25, 6341.89,10.1567], 0, _group] call _createVehicle]; 

_leader = driver (_vehicles select 0);
_group selectLeader _leader;
_leader setRank "LIEUTENANT";

_group setCombatMode "GREEN";
_group setBehaviour "SAFE";
_group setFormation "STAG COLUMN";
_group setSpeedMode "LIMITED";

_waypoints = [
    [2250.82,6064.3,28.4179],
[2804.93,6071.54,3.62798],
[2684.82,6138.92,13.8506],
[3065.95,6404.91,0.866714],
[3041.59,6755.19,1.56158],
[3176.56,7161.56,2.71589],
[3497.27,7523.13,1.81625],
[3476.66,7684.33,2.27143],
[4121.47,7565.09,5.80972],
[4425.56,7133.18,1.90534],
[5371.25,6682.26,3.8577],
[5526.17,6420.82,0.235718],
[5809.52,6183.14,0.972698],
[6422.83,5533.41,0.0882069],
[5809.52,6183.14,0.972698],
[5526.17,6420.82,0.235718],
[5371.25,6682.26,3.8577],
[4425.56,7133.18,1.90534],
[4121.47,7565.09,5.80972],
[3476.66,7684.33,2.27143],
[3497.27,7523.13,1.81625],
[3176.56,7161.56,2.71589],
[3041.59,6755.19,1.56158],
[3065.95,6404.91,0.866714],
[2684.82,6138.92,13.8506],
[2804.93,6071.54,3.62798],
[2250.82,6064.3,28.4179],
[2804.93,6071.54,3.62798],
[2684.82,6138.92,13.8506],
[3065.95,6404.91,0.866714],
[3041.59,6755.19,1.56158],
[3176.56,7161.56,2.71589],
[3497.27,7523.13,1.81625],
[3476.66,7684.33,2.27143],
[4121.47,7565.09,5.80972],
[4425.56,7133.18,1.90534],
[5371.25,6682.26,3.8577],
[5526.17,6420.82,0.235718],
[5809.52,6183.14,0.972698],
[6422.83,5533.41,0.0882069],
[5809.52,6183.14,0.972698],
[5526.17,6420.82,0.235718],
[5371.25,6682.26,3.8577],
[4425.56,7133.18,1.90534],
[4121.47,7565.09,5.80972],
[3476.66,7684.33,2.27143],
[3497.27,7523.13,1.81625],
[3176.56,7161.56,2.71589],
[3041.59,6755.19,1.56158],
[3065.95,6404.91,0.866714],
[2684.82,6138.92,13.8506],
[2804.93,6071.54,3.62798],
[2250.82,6064.3,28.4179]
];
{
    _waypoint = _group addWaypoint [_x, 0];
    _waypoint setWaypointType "MOVE";
    _waypoint setWaypointCompletionRadius 75;
    _waypoint setWaypointCombatMode "GREEN"; // Defensiv behaviour
    _waypoint setWaypointBehaviour "SAFE"; // Force convoy to normaly drive on the street.
    _waypoint setWaypointFormation "STAG COLUMN";
    _waypoint setWaypointSpeed "LIMITED";
} forEach _waypoints;

_marker = createMarker [_missionMarkerName, position leader _group];
_marker setMarkerType "mil_destroy";
_marker setMarkerSize [1.25, 1.25];
_marker setMarkerColor "ColorRed";
_marker setMarkerText "Coastal Patrol";

_picture = getText (configFile >> "CfgVehicles" >> _randomboat >> "picture");
_vehicleName = getText (configFile >> "cfgVehicles" >> _randomboat >> "displayName");
_hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Main Objective</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>A <t color='%4'>%3</t> transporting 2 weapon crates, is patroling the coast with air-support. Stop them!</t>", _missionType, _picture, _vehicleName, mainMissionColor, subTextColor];
messageSystem = _hint;
if (!isDedicated) then { call serverMessage };
publicVariable "messageSystem";

diag_log format["WASTELAND SERVER - Main Mission Waiting to be Finished: %1", _missionType];

_failed = false;
_startTime = floor(time);
_numWaypoints = count waypoints _group;
waitUntil
{
    private ["_unitsAlive"];
    
    sleep 10; 
    
    _marker setMarkerPos (position leader _group);
    
    if ((floor time) - _startTime >= mainMissionTimeout) then { _failed = true };
    if (currentWaypoint _group >= _numWaypoints) then { _failed = true }; // Convoy got successfully to the target location
    _unitsAlive = { alive _x } count units _group;
    
    _unitsAlive == 0 || _failed
};

if(_failed) then
{
    // Mission failed
    if not(isNil "_vehicle") then {deleteVehicle _vehicle;};
	{if (vehicle _x != _x) then { deleteVehicle vehicle _x; }; deleteVehicle _x;}forEach units _group;
	{deleteVehicle _x;}forEach units _group;
	deleteGroup _group; 
    _hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Objective Failed</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>Objective failed, better luck next time</t>", _missionType, _picture, _vehicleName, failMissionColor, subTextColor];
    messageSystem = _hint;
    if (!isDedicated) then { call serverMessage };
    publicVariable "messageSystem";
    diag_log format["WASTELAND SERVER - Main Mission Failed: %1",_missionType];
} else {
	if not(isNil "_vehicle") then 
	{
		if ((damage _vehicle) == 1) then {
			deleteVehicle _vehicle;
			{deleteVehicle _x;}forEach units _group;
		};
	};
	if (!isNil "_vehicle") then { _vehicle setVehicleLock "UNLOCKED"; };
	if (!isNil "_vehicle") then { _vehicle setVariable ["R3F_LOG_disabled", false, true]; };
    // Mission complete
	_ammobox = "Box_NATO_Wps_F" createVehicle getMarkerPos _marker;
    clearMagazineCargoGlobal _ammobox;
    clearWeaponCargoGlobal _ammobox; 
    [_ammobox,"mission_Main_A3snipers"] call fn_refillbox;
    _ammobox2 = "Box_NATO_Wps_F" createVehicle getMarkerPos _marker;
    clearMagazineCargoGlobal _ammobox2;
    clearWeaponCargoGlobal _ammobox2; 
    [_ammobox2,"mission_USLaunchers2"] call fn_refillbox;
    deleteGroup _group;
    _hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Objective Complete</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>The patrol has been stopped. The weapon crates and vehicles are yours to take. O.M.G.! did they just sink!?</t>", _missionType, _picture, _vehicleName, successMissionColor, subTextColor];
    messageSystem = _hint;
    if (!isDedicated) then { call serverMessage };
    publicVariable "messageSystem";
    diag_log format["WASTELAND SERVER - Main Mission Success: %1",_missionType];
};

deleteMarker _marker;
