//	@file Version: 1
//	@file Name: mission_HostileHeliFormation.sqf
//	@file Author: JoSchaap
//  new one, no longer requires static routes, can use all helicopters now

if (!isServer) exitwith {};
#include "mainMissionDefines.sqf";

private ["_heli1","_heli2","_heli3","_missionMarkerName","_missionType","_picture","_vehicleName","_vehicleName2","_vehicleName3","_hint","_waypoint","_waypoints","_grouphf","_vehicles","_marker","_failed","_startTime","_numWaypoints","_ammobox","_ammobox2","_ammobox3","_createVehicle","_leader","_routepoints","_travels","_travelcount"];

_missionMarkerName = "HostileHelis_Marker";
_missionType = "Hostile Helicopters";

_travels = 20; 						// the ammount of towns the helicopter should visit before the mission ends
_travelcount = 0;
_waypoints = [];

diag_log format["WASTELAND SERVER - Main Mission Started: %1", _missionType];
diag_log format["WASTELAND SERVER - Main Mission Waiting to run: %1", _missionType];
[mainMissionDelayTime] call createWaitCondition;
diag_log format["WASTELAND SERVER - Main Mission Resumed: %1", _missionType];

// helicopters available for this mission (if missions set to diffucult also allows chance of mi48 helicopters)
// incase mission difficulty is set to easy (0) the choppers will also fly at half speed

if (A3W_missionsDifficulty == 1) then {
	_heli1 = ["O_Heli_Attack_02_black_F","O_Heli_Attack_02_F","O_Heli_Light_02_F","B_Heli_Transport_01_F","B_Heli_Light_01_armed_F","B_Heli_Transport_01_camo_F"] call BIS_fnc_selectRandom;
	_heli2 = ["O_Heli_Attack_02_black_F","O_Heli_Attack_02_F","O_Heli_Light_02_F","B_Heli_Transport_01_F","B_Heli_Light_01_armed_F","B_Heli_Transport_01_camo_F"] call BIS_fnc_selectRandom;
	_heli3 = ["O_Heli_Attack_02_black_F","O_Heli_Attack_02_F","O_Heli_Light_02_F","B_Heli_Transport_01_F","B_Heli_Light_01_armed_F","B_Heli_Transport_01_camo_F"] call BIS_fnc_selectRandom;
} else {
	_heli1 = ["O_Heli_Light_02_F","B_Heli_Transport_01_F","B_Heli_Light_01_armed_F","B_Heli_Transport_01_camo_F"] call BIS_fnc_selectRandom;
	_heli2 = ["O_Heli_Light_02_F","B_Heli_Transport_01_F","B_Heli_Light_01_armed_F","B_Heli_Transport_01_camo_F"] call BIS_fnc_selectRandom;
	_heli3 = ["O_Heli_Light_02_F","B_Heli_Transport_01_F","B_Heli_Light_01_armed_F","B_Heli_Transport_01_camo_F"] call BIS_fnc_selectRandom;
};

_grouphf = createGroup civilian;

_createVehicle = {
    private ["_type","_position","_direction","_grouphf","_vehicle","_soldier"];
    _type = _this select 0;
    _position = _this select 1;
    _direction = _this select 2;
    _grouphf = _this select 3;
    _vehicle = _type createVehicle _position;
	[_vehicle] call vehicleSetup;
    _vehicle setDir _direction;
    _grouphf addVehicle _vehicle;
    // create units
	// driver/pilot
    _soldier = [_grouphf, _position] call createRandomSoldier; 
    _soldier moveInDriver _vehicle;	
	// create additional gunners if needed
    if ((_vehicle isKindOf "B_Heli_Transport_01_camo_F") || (_vehicle isKindOf "B_Heli_Transport_01_F")) then {
		// these choppers have 2 turrets so we need 2 gunners :)
	   _soldier = [_grouphf, _position] call createRandomSoldier; 
	   _soldier assignAsGunner _vehicle;
       _soldier moveInTurret [_vehicle, [1]];
  	   _soldier = [_grouphf, _position] call createRandomSoldier; 
	   _soldier assignAsGunner _vehicle;
       _soldier moveInTurret [_vehicle, [2]];
    };
	if ((_vehicle isKindOf "B_Heli_Attack_01_F") || (_vehicle isKindOf "O_Heli_Attack_02_black_F") || (_vehicle isKindOf "O_Heli_Attack_02_F")) then {
		// these choppers need 1 gunner
	   _soldier = [_grouphf, _position] call createRandomSoldier; 
	   _soldier assignAsGunner _vehicle;
       _soldier moveInTurret [_vehicle, [0]];
    };
	
	// remove flares, as they are OP when controlled by AI
	if ("CMFlareLauncher" in getArray (configFile >> "CfgVehicles" >> _type >> "weapons")) then
	{
		{
			if (_x isKindOf "60Rnd_CMFlare_Chaff_Magazine") then
			{
				_vehicle removeMagazinesTurret [_x, [-1]];
			};
		} forEach (_vehicle magazinesTurret [-1]);
	};
	// lock the vehicle untill the mission is finished and initialize cleanup on it
    _vehicle setVehicleLock "LOCKED";
	_vehicle spawn cleanVehicleWreck;
    _vehicle
};

_vehicles = [];
_vehicles set [0, [_heli1, [8436.93, 25250.8], 13, _grouphf] call _createVehicle];  // static value update when porting to different maps
_vehicles set [1, [_heli2, [8458.97, 25134.8], 171, _grouphf] call _createVehicle];
_vehicles set [2, [_heli3, [8476.16, 25254.1], 222, _grouphf] call _createVehicle];

_leader = driver (_vehicles select 0);
_grouphf selectLeader _leader;
_leader setRank "LIEUTENANT";

_grouphf setCombatMode "WHITE";
_grouphf setBehaviour "AWARE";
_grouphf setFormation "STAG COLUMN";
if (A3W_missionsDifficulty == 1) then {
	_grouphf setSpeedMode "NORMAL";
} else {
	_grouphf setSpeedMode "LIMITED";
};

									// pick random townmarkers from the citylist and use their location as waypoints
while {_travelcount < _travels} do {
	_travelcount = (_travelcount + 1);
	_waypoints set [count _waypoints, getMarkerPos (((call citylist) call BIS_fnc_selectRandom) select 0)];
};

{
    _waypoint = _grouphf addWaypoint [_x, 0];
    _waypoint setWaypointType "MOVE";
    _waypoint setWaypointCompletionRadius 55;
    _waypoint setWaypointCombatMode "WHITE"; // Defensiv behaviour
    _waypoint setWaypointBehaviour "AWARE"; // Force convoy to normaly drive on the street.
    _waypoint setWaypointFormation "STAG COLUMN";
	if (A3W_missionsDifficulty == 1) then {
		_waypoint setWaypointSpeed "NORMAL";
	} else {
		_waypoint setWaypointSpeed "LIMITED";
	};
} forEach _waypoints;

_marker = createMarker [_missionMarkerName, position leader _grouphf];
_marker setMarkerType "mil_destroy";
_marker setMarkerSize [1.25, 1.25];
_marker setMarkerColor "ColorRed";
_marker setMarkerText "Hostile Helicopters";

_picture = getText (configFile >> "CfgVehicles" >> _heli1 >> "picture");
_vehicleName = getText (configFile >> "cfgVehicles" >> _heli1 >> "displayName");
_vehicleName2 = getText (configFile >> "cfgVehicles" >> _heli2 >> "displayName");
_vehicleName3 = getText (configFile >> "cfgVehicles" >> _heli3 >> "displayName");

// Remove " (Camo)" from vehicle name when applicable
if ([_vehicleName, (count toArray _vehicleName) - 7] call BIS_fnc_trimString == " (Camo)") then
{
	_vehicleName = [_vehicleName, 0, (count toArray _vehicleName) - 8] call BIS_fnc_trimString;
};

// Remove " (Camo)" from vehicle name when applicable
if ([_vehicleName2, (count toArray _vehicleName2) - 7] call BIS_fnc_trimString == " (Camo)") then
{
	_vehicleName2 = [_vehicleName2, 0, (count toArray _vehicleName2) - 8] call BIS_fnc_trimString;
};

// Remove " (Camo)" from vehicle name when applicable
if ([_vehicleName3, (count toArray _vehicleName3) - 7] call BIS_fnc_trimString == " (Camo)") then
{
	_vehicleName3 = [_vehicleName3, 0, (count toArray _vehicleName3) - 8] call BIS_fnc_trimString;
};

_hint = parseText format 
[
	"<t align='center' color='%4' shadow='2' size='1.75'>Main Objective</t><br/>" +
	"<t align='center' color='%4'>------------------------------</t><br/>" +
	"<t align='center' color='%5' size='1.25'>%1</t><br/>" +
	"<t align='center'><img size='5' image='%2'/></t><br/>" +
	"<t align='center' color='%5'>A formation of armed helicopters containing a <t color='%4'>%3</t>, a <t color='%4'>%6</t> and a <t color='%4'>%7</t> are patrolling the island. Destroy them and recover their cargo!</t>", 
	_missionType, _picture, _vehicleName, mainMissionColor, subTextColor, _vehicleName2, _vehicleName3
];
[_hint] call hintBroadcast;

diag_log format["WASTELAND SERVER - Main Mission Waiting to be Finished: %1", _missionType];

_failed = false;
_startTime = floor(time);
_numWaypoints = count waypoints _grouphf;
waitUntil
{
    private ["_unitsAlive"];
    
    sleep 10; 
    
    _marker setMarkerPos (position leader _grouphf);
    
    if ((floor time) - _startTime >= mainMissionTimeout) then { _failed = true };
    if (currentWaypoint _grouphf >= _numWaypoints) then { _failed = true }; // Convoy got successfully to the target location
    _unitsAlive = { alive _x } count units _grouphf;
    _unitsAlive == 0 || _failed
};

if(_failed) then
{
    // Mission failed
    if not(isNil "_vehicle") then {deleteVehicle _vehicle;};
	{if (vehicle _x != _x) then { deleteVehicle vehicle _x; }; deleteVehicle _x;}forEach units _grouphf;
	{deleteVehicle _x;}forEach units _grouphf;
	deleteGroup _grouphf; 
    _hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Objective Failed</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>The patrol ended, the enemy has survived and escaped with the ammo crates.</t>", _missionType, _picture, _vehicleName, failMissionColor, subTextColor];
    [_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Main Mission Failed: %1",_missionType];
} else {
	// Mission completed
	// unlock the vehicles incase the player cleared the mission without destroying them
	if (!isNil "_vehicles") then { 
		{
			_x setVehicleLock "UNLOCKED"; 
			_x setVariable ["R3F_LOG_disabled", false, true];
		}forEach _vehicles;
	};
	
	// give the rewards
    _ammobox = "Box_NATO_Wps_F" createVehicle getMarkerPos _marker;
    [_ammobox,"mission_USSpecial2"] call fn_refillbox;
	_ammobox allowDamage false;
	
    _ammobox2 = "Box_East_Wps_F" createVehicle getMarkerPos _marker;
    [_ammobox2,"mission_USLaunchers"] call fn_refillbox;
	_ammobox2 allowDamage false;
	
    _ammobox3 = "Box_NATO_WpsSpecial_F" createVehicle getMarkerPos _marker;
    [_ammobox3,"mission_USSpecial"] call fn_refillbox;
	_ammobox3 allowDamage false;
	
	deleteGroup _grouphf; 
    _hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Objective Complete</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>The sky is clear again, the enemy patrol was taken out! Ammo crates have fallen near the wreck.</t>", _missionType, _picture, _vehicleName, successMissionColor, subTextColor];
    [_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Main Mission Success: %1",_missionType];
};

deleteMarker _marker;
