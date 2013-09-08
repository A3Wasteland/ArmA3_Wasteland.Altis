//	@file Version: 2
//	@file Name: mission_MiniConvoy.sqf
//	@file Author: JoSchaap / routes by Del1te - (original idea by Sanjo)
//	@file Created: 1/09/2013 14:19
//	@file Args: none

private ["_missionMarkerName","_missionType","_picture","_vehicleName","_hint","_waypoint","_routes","_veh1","_veh2","_veh3","_rn","_waypoints","_starts","_startdirs","_groupsm","_vehicles","_marker","_failed","_startTime","_numWaypoints","_ammobox","_createVehicle","_leader"];

#include "sideMissionDefines.sqf"

_missionMarkerName = "MiniConvoy_Marker";
_missionType = "Truck Convoy";
diag_log format["WASTELAND SERVER - Side Mission Started: %1", _missionType];
diag_log format["WASTELAND SERVER - Side Mission Waiting to run: %1", _missionType];
[sideMissionDelayTime] call createWaitCondition;
diag_log format["WASTELAND SERVER - Side Mission Resumed: %1", _missionType];

//pick the vehicles for the convoy (veh2 is the 'convoyed' vehicle
_veh1 = ["B_Quadbike_01_F","C_Offroad_01_F","I_G_Offroad_01_F","I_G_Offroad_01_armed_F","C_SUV_01_F","O_Quadbike_01_F","C_Offroad_01_F","I_Quadbike_01_F","C_Quadbike_01_F"] call BIS_fnc_selectRandom;
_veh2 = ["O_Truck_02_covered_F","C_Offroad_01_F","I_Truck_02_Fuel_F","O_Truck_02_Fuel_F","I_Truck_02_medical_F","O_Truck_02_medical_F","C_Van_01_Fuel_F","I_G_Van_01_Fuel_F","I_Truck_02_covered_F","O_Truck_02_transport_F","I_Truck_02_transport_F"] call BIS_fnc_selectRandom;
_veh3 = ["B_Quadbike_01_F","C_Offroad_01_F","I_G_Offroad_01_F","I_G_Offroad_01_armed_F","C_SUV_01_F","O_Quadbike_01_F","C_Offroad_01_F","I_Quadbike_01_F","C_Quadbike_01_F"] call BIS_fnc_selectRandom;

// available routes to add a route. If you add more routes append ,4 to the array and so on
_routes = [1,2,3];

// pick one of the routes
_rn = _routes select (floor(random(count _routes)));

// set starts and waypoints depending on above (random) choice
switch (_rn) do 
{ 
	case 1: {
		// route 1
		// starting positions for this route
		_starts = [
			[4684.3921,13337.07,53.194202],
			[4663.5249,13305.79,56.101654],
			[4643.0615,13272.709,58.082726]
		];
		// starting directions in which the vehicles are spawned on this route
		_startdirs = [
			33,
			33,
			33
		];
		// the routes
		_waypoints = [			
			[4709.3672,13381.538,48.192379],
			[6614.5122,15335.907,37.11795],
			[8348.6055,15781.597,108.55094],
			[9703.3369,16182.543,83.560249],
			[11160.02,17270.051,57.112164],
			[12748.146,18834.535,29.596584],
			[12994.632,19462.133,33.778721],
			[11125.767,20896.094,131.5762],
			[11869.673,22208.621,18.313629]
		];
		// end of route one
	}; 
	case 2: {
		// route 2
		// starting positions for this route
		_starts = [
			[21825.268,7122.4512,13.778839],
			[21821.42,7062.1821,13.807821],
			[21812.445,6990.3716,15.660007]
		];
		// starting directions in which the vehicles are spawned on this route
		_startdirs = [
			10,
			10,
			10
		];
		// the routes
		_waypoints = [
			[21824.99,7174.1509,14.066642],
			[20485.871,10990.865,44.599953],
			[18257.242,13530.432,20.79612],
			[18311.52,13544.588,21.471191],
			[18335.752,13940.664,24.597376],
			[18278.49,14655.104,16.817299],
			[20768.957,16632.809,36.363457],
			[20332.428,16846.414,41.794998],
			[20469.039,17205.83,62.79401],
			[19996.465,18402.379,41.286507],
			[20927.098,18642.852,27.24435],
			[21651.148,18949.061,18.721802]
		];
		// end of route two
	}; 
	case 3: {
		// route 3
		// starting positions for this route
		_starts = [
			[9540.4004,8544.2471,23.508436],
			[9523.541,8505.0156,24.700886],
			[9502.9043,8470.8223,25.610661]
		];
		// starting directions in which the vehicles are spawned on this route
		_startdirs = [
			35,
			35,
			35
		];
		// the routes
		_waypoints = [
			[9573.9238,8603.8203,21.783022],
			[10779.979,10752.867,6.9041996],
			[9883,12795.109,15.03497],
			[9230.667,14191.858,42.160519],
			[8190.9907,15869.275,108.909],
			[6789.5913,16126.018,67.751434],
			[7139.0513,16877.182,152.38431],
			[6832.0098,19443.926,198.91882],
			[4384.667,21031.82,262.16455]
		];
		// end of route three
	}; 
	default {
		// this shouldnt happen but just to be sure..
		diag_log format["WASTELAND SERVER - WARNING! %1 encountered an error selecting routes - defaulting to route 1", _missionType];
		// route 1
		// starting positions for this route
		_starts = [
			[4684.3921,13337.07,53.194202],
			[4663.5249,13305.79,56.101654],
			[4643.0615,13272.709,58.082726]
		];
		// starting directions in which the vehicles are spawned on this route
		_startdirs = [
			33,
			33,
			33
		];
		// the routes
		_waypoints = [			
			[4709.3672,13381.538,48.192379],
			[6614.5122,15335.907,37.11795],
			[8348.6055,15781.597,108.55094],
			[9703.3369,16182.543,83.560249],
			[11160.02,17270.051,57.112164],
			[12748.146,18834.535,29.596584],
			[12994.632,19462.133,33.778721],
			[11125.767,20896.094,131.5762],
			[11869.673,22208.621,18.313629]
		];
		// end of route one
	}; 
}; 

_groupsm = createGroup civilian;

_createVehicle = {
    private ["_type","_position","_direction","_vehicle","_soldier"];
    
    _type = _this select 0;
    _position = _this select 1;
    _direction = _this select 2;
    _groupsm = _this select 3;
    
    _vehicle = _type createVehicle _position;
    _vehicle setDir _direction;
    clearMagazineCargoGlobal _vehicle;
    clearWeaponCargoGlobal _vehicle;
	_vehicle setVariable [call vChecksum, true, false];
    _groupsm addVehicle _vehicle;
    
    _soldier = [_groupsm, _position] call createRandomSoldier; 
    _soldier moveInDriver _vehicle;
    _soldier = [_groupsm, _position] call createRandomSoldier; 
    _soldier moveInCargo [_vehicle, 0];
    _vehicle setVehicleLock "LOCKED";  // prevents players from getting into the vehicle while the AI are still owning it
	_vehicle spawn cleanVehicleWreck;  // courtesy of AgentREV sets cleanup on the mission vehicles once wrecked :)
    _vehicle
};

_vehicles = [];
_vehicles set [0, [_veh1, (_starts select 0), (_startdirs select 0), _groupsm] call _createVehicle];
_vehicles set [1, [_veh2, (_starts select 1), (_startdirs select 1), _groupsm] call _createVehicle];
_vehicles set [2, [_veh3, (_starts select 2), (_startdirs select 2), _groupsm] call _createVehicle];

_leader = driver (_vehicles select 0);
_groupsm selectLeader _leader;
_leader setRank "LIEUTENANT";

_groupsm setCombatMode "GREEN"; // units will defend themselves
_groupsm setBehaviour "SAFE"; // units feel safe until they spot an enemy or get into contact
_groupsm setFormation "STAG COLUMN";
_groupsm setSpeedMode "LIMITED";

{
    _waypoint = _groupsm addWaypoint [_x, 0];
    _waypoint setWaypointType "MOVE";
    _waypoint setWaypointCompletionRadius 50;
    _waypoint setWaypointCombatMode "GREEN"; 
    _waypoint setWaypointBehaviour "SAFE"; // safe is the best behaviour to make AI follow roads, as soon as they spot an enemy or go into combat they WILL leave the road for cover though!
    _waypoint setWaypointFormation "STAG COLUMN";
    _waypoint setWaypointSpeed "LIMITED";
} forEach _waypoints;

_marker = createMarker [_missionMarkerName, position leader _groupsm];
_marker setMarkerType "mil_destroy";
_marker setMarkerSize [1.25, 1.25];
_marker setMarkerColor "ColorRed";
_marker setMarkerText "Truck Convoy";

_picture = getText (configFile >> "CfgVehicles" >> _veh2 >> "picture");
_vehicleName = getText (configFile >> "cfgVehicles" >> _veh2 >> "displayName");
_hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Side Objective</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>A <t color='%4'>%3</t> transporting a crate of GL weapons and ammo is on route!. Stop the convoy to takeover the goods!</t>", _missionType, _picture, _vehicleName, sideMissionColor, subTextColor];
[_hint] call hintBroadcast;

diag_log format["WASTELAND SERVER - Side Mission Waiting to be Finished: %1", _missionType];

_failed = false;
_startTime = floor(time);
_numWaypoints = count waypoints _groupsm;
waitUntil
{
    private ["_unitsAlive"];
    
    sleep 10; 
    
    _marker setMarkerPos (position leader _groupsm);
    
    if ((floor time) - _startTime >= sideMissionTimeout) then { _failed = true };
    if (currentWaypoint _groupsm >= _numWaypoints) then { _failed = true }; // Convoy got successfully to the target location
    _unitsAlive = { alive _x } count units _groupsm;
    
    _unitsAlive == 0 || _failed
};

if(_failed) then
{
    // Mission failed
    if not(isNil "_vehicle") then {deleteVehicle _vehicle;};
	{if (vehicle _x != _x) then { deleteVehicle vehicle _x; }; deleteVehicle _x;}forEach units _groupsm;
	{deleteVehicle _x;}forEach units _groupsm;
	deleteGroup _groupsm; 
    _hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Objective Failed</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>Objective failed, better luck next time</t>", _missionType, _picture, _vehicleName, failMissionColor, subTextColor];
    [_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Side Mission Failed: %1",_missionType];
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
    clearMagazineCargoGlobal _ammobox;
    clearWeaponCargoGlobal _ammobox; 
    [_ammobox,"mission_USSpecial2"] call fn_refillbox;
    _hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Objective Complete</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>The convoy has been stopped. The weapon crate and vehicles are yours to take.</t>", _missionType, _picture, _vehicleName, successMissionColor, subTextColor];
    [_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Side Mission Success: %1",_missionType];
};

deleteMarker _marker;
