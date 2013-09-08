//	@file Version: 2
//	@file Name: mission_Convoy.sqf
//	@file Author: JoSchaap / routes by Del1te - (original idea by Sanjo)
//	@file Created: 31/08/2013 18:19
//	@file Args: none

private ["_missionMarkerName","_missionType","_picture","_vehicleName","_hint","_waypoint","_routes","_veh1","_veh2","_veh3","_rn","_waypoints","_starts","_startdirs","_group","_vehicles","_marker","_failed","_startTime","_numWaypoints","_ammobox","_ammobox2","_createVehicle","_leader"];

#include "mainMissionDefines.sqf"

_missionMarkerName = "Convoy_Marker";
_missionType = "Convoy";
diag_log format["WASTELAND SERVER - Main Mission Started: %1", _missionType];
diag_log format["WASTELAND SERVER - Main Mission Waiting to run: %1", _missionType];
[mainMissionDelayTime] call createWaitCondition;
diag_log format["WASTELAND SERVER - Main Mission Resumed: %1", _missionType];

//pick the vehicles for the convoy (veh2 is the 'convoyed' vehicle
_veh1 = ["O_MRAP_02_gmg_F","B_MRAP_01_gmg_F","I_MRAP_03_gmg_F"] call BIS_fnc_selectRandom;
_veh2 = ["B_MRAP_01_F","O_MRAP_02_F","I_MRAP_03_F","B_Truck_01_Transport_F","I_G_Offroad_01_armed_F","C_SUV_01_F","C_Van_01_transport_F","I_G_Van_01_transport_F","C_Van_01_box_F","B_Truck_01_Covered_F"] call BIS_fnc_selectRandom;
_veh3 = ["B_MRAP_01_hmg_F","O_MRAP_02_hmg_F","I_MRAP_03_hmg_F"] call BIS_fnc_selectRandom;

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
			[11877.198,22464.334,16.133373],
			[11921.394,22530.055,17.224131],
			[11956.172,22594.484,18.018967]
		];
		// starting directions in which the vehicles are spawned on this route
		_startdirs = [
			210,
			210,
			210
		];
		// the routes
		_waypoints = [
			[11869.673,22208.621,18.313629],
			[11125.767,20896.094,131.5762],
			[12994.632,19462.133,33.778721],
			[12748.146,18834.535,29.596584],
			[11160.02,17270.051,57.112164],
			[9703.3369,16182.543,83.560249],
			[8348.6055,15781.597,108.55094],
			[6614.5122,15335.907,37.11795],
			[4709.3672,13381.538,48.192379]
		];
		// end of route one
	}; 
	case 2: {
		// route 2
		// starting positions for this route
		_starts = [
			[21676.07,19098.602,19.740389],
			[21706.025,19143.395,20.686287],
			[21733.701,19188.068,21.83143]
		];
		// starting directions in which the vehicles are spawned on this route
		_startdirs = [
			215,
			215,
			215
		];
		// the routes
		_waypoints = [
			[21651.148,18949.061,18.721802],
			[20927.098,18642.852,27.24435],
			[19996.465,18402.379,41.286507],
			[20469.039,17205.83,62.79401],
			[20332.428,16846.414,41.794998],
			[20768.957,16632.809,36.363457],
			[18278.49,14655.104,16.817299],
			[18335.752,13940.664,24.597376],
			[18311.52,13544.588,21.471191],
			[18257.242,13530.432,20.79612],
			[20485.871,10990.865,44.599953],
			[21824.99,7174.1509,14.066642]
		];
		// end of route two
	}; 
	case 3: {
		// route 3
		// starting positions for this route
		_starts = [
			[4358.6313,21123.746,254.40459],
			[4353.8003,21175.734,248.28143],
			[4352.7617,21228.533,247.36967]
		];
		// starting directions in which the vehicles are spawned on this route
		_startdirs = [
			157,
			157,
			157
		];
		// the routes
		_waypoints = [
			[4384.667,21031.82,262.16455],
			[6832.0098,19443.926,198.91882],
			[7139.0513,16877.182,152.38431],
			[6789.5913,16126.018,67.751434],
			[8190.9907,15869.275,108.909],
			[9230.667,14191.858,42.160519],
			[9883,12795.109,15.03497],
			[10779.979,10752.867,6.9041996],
			[9573.9238,8603.8203,21.783022]
		];
		// end of route three
	}; 
	default {
		// this shouldnt happen but just to be sure..
		diag_log format["WASTELAND SERVER - WARNING! %1 encountered an error selecting routes - defaulting to route 1", _missionType];
		// route 1
		// starting positions for this route
		_starts = [
			[11877.198,22464.334,16.133373],
			[11921.394,22530.055,17.224131],
			[11956.172,22594.484,18.018967]
		];
		// starting directions in which the vehicles are spawned on this route
		_startdirs = [
			210,
			210,
			210
		];
		// the routes
		_waypoints = [
			[11869.673,22208.621,18.313629],
			[11125.767,20896.094,131.5762],
			[12994.632,19462.133,33.778721],
			[12748.146,18834.535,29.596584],
			[11160.02,17270.051,57.112164],
			[9703.3369,16182.543,83.560249],
			[8348.6055,15781.597,108.55094],
			[6614.5122,15335.907,37.11795],
			[4709.3672,13381.538,48.192379]
		];
		// end of route one
	}; 
}; 

_group = createGroup civilian;

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
    
    _soldier = [_group, _position] call createRandomSoldier; 
    _soldier moveInDriver _vehicle;
    _soldier = [_group, _position] call createRandomSoldier; 
    _soldier moveInCargo [_vehicle, 0];
    _soldier = [_group, _position] call createRandomSoldier; 
    _soldier moveInCargo [_vehicle, 1];
    _soldier = [_group, _position] call createRandomSoldier; 
	// get a unit inside gunner seat on the armed vehicles
    if (_vehicle isKindOf _veh2) then {
        _soldier moveInCargo [_vehicle, 2];
    } else {
        _soldier moveInTurret [_vehicle, [0]];
    };
    _vehicle setVehicleLock "LOCKED";  // prevents players from getting into the vehicle while the AI are still owning it
	_vehicle spawn cleanVehicleWreck;  // courtesy of AgentREV sets cleanup on the mission vehicles once wrecked :)
    _vehicle
};

_vehicles = [];
_vehicles set [0, [_veh1, (_starts select 0), (_startdirs select 0), _group] call _createVehicle];
_vehicles set [1, [_veh2, (_starts select 1), (_startdirs select 1), _group] call _createVehicle];
_vehicles set [2, [_veh3, (_starts select 2), (_startdirs select 2), _group] call _createVehicle];

_leader = driver (_vehicles select 0);
_group selectLeader _leader;
_leader setRank "LIEUTENANT";

_group setCombatMode "GREEN"; // units will defend themselves
_group setBehaviour "SAFE"; // units feel safe until they spot an enemy or get into contact
_group setFormation "STAG COLUMN";
_group setSpeedMode "LIMITED";

{
    _waypoint = _group addWaypoint [_x, 0];
    _waypoint setWaypointType "MOVE";
    _waypoint setWaypointCompletionRadius 50;
    _waypoint setWaypointCombatMode "GREEN"; 
    _waypoint setWaypointBehaviour "SAFE"; // safe is the best behaviour to make AI follow roads, as soon as they spot an enemy or go into combat they WILL leave the road for cover though!
    _waypoint setWaypointFormation "STAG COLUMN";
    _waypoint setWaypointSpeed "LIMITED";
} forEach _waypoints;

_marker = createMarker [_missionMarkerName, position leader _group];
_marker setMarkerType "mil_destroy";
_marker setMarkerSize [1.25, 1.25];
_marker setMarkerColor "ColorRed";
_marker setMarkerText "Armed Convoy";

_picture = getText (configFile >> "CfgVehicles" >> _veh2 >> "picture");
_vehicleName = getText (configFile >> "cfgVehicles" >> _veh2 >> "displayName");
_hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Main Objective</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>A <t color='%4'>%3</t> transporting 2 weapon crates, is convoyed by two armored vehicles. Stop them!</t>", _missionType, _picture, _vehicleName, mainMissionColor, subTextColor];
[_hint] call hintBroadcast;

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
    clearMagazineCargoGlobal _ammobox;
    clearWeaponCargoGlobal _ammobox; 
    [_ammobox,"mission_USSpecial2"] call fn_refillbox;
    _ammobox2 = "Box_NATO_Wps_F" createVehicle getMarkerPos _marker;
    clearMagazineCargoGlobal _ammobox2;
    clearWeaponCargoGlobal _ammobox2; 
    [_ammobox2,"mission_USLaunchers2"] call fn_refillbox;
    _hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Objective Complete</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>The convoy has been stopped. The weapon crates and vehicles are yours to take.</t>", _missionType, _picture, _vehicleName, successMissionColor, subTextColor];
    [_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Main Mission Success: %1",_missionType];
};

deleteMarker _marker;
