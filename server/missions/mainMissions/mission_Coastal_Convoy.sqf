//	@file Version: 2
//	@file Name: mission_Coastal_Convoy.sqf
//	@file Author: JoSchaap / routes by Del1te - (original idea by Sanjo)
//	@file Created: 02/09/2013 11:29
//	@file Args: none

if (!isServer) exitwith {};
#include "mainMissionDefines.sqf"

private ["_missionMarkerName","_missionType","_picture","_vehicleName","_vehicleName2","_vehicleName3","_hint","_waypoint","_routes","_veh1","_veh2","_veh3","_rn","_waypoints","_starts","_startdirs","_groupcc","_vehicles","_marker","_failed","_startTime","_numWaypoints","_ammobox","_ammobox2","_createVehicle","_leader"];

_missionMarkerName = "CoastalConvoy_Marker";
_missionType = "Coastal Patrol";
diag_log format["WASTELAND SERVER - Main Mission Started: %1", _missionType];
diag_log format["WASTELAND SERVER - Main Mission Waiting to run: %1", _missionType];
[A3W_mainMissionDelayTime] call createWaitCondition;
diag_log format["WASTELAND SERVER - Main Mission Resumed: %1", _missionType];

//pick the vehicles for the patrol (in hard difficulty also allows chance of mi48)
_veh1 = ["O_Boat_Armed_01_hmg_F","B_Boat_Armed_01_minigun_F","I_Boat_Armed_01_minigun_F"] call BIS_fnc_selectRandom;
if (A3W_missionsDifficulty == 1) then {
	_veh2 = ["O_Heli_Attack_02_black_F","O_Heli_Light_02_F","B_Heli_Transport_01_F","B_Heli_Light_01_armed_F","B_Heli_Transport_01_camo_F"] call BIS_fnc_selectRandom;
} else {
	_veh2 = ["O_Heli_Light_02_F","B_Heli_Transport_01_F","B_Heli_Light_01_armed_F","B_Heli_Transport_01_camo_F"] call BIS_fnc_selectRandom;
};
_veh3 = ["O_Boat_Armed_01_hmg_F","B_Boat_Armed_01_minigun_F","I_Boat_Armed_01_minigun_F"] call BIS_fnc_selectRandom;

// available routes to add a route. If you add more routes append ,4 to the array and so on
_routes = [1,2,3];

// pick one of the routes
_rn = _routes call BIS_fnc_selectRandom;

// set starts and waypoints depending on above (random) choice
switch (_rn) do 
{ 
	case 1: {
		// route 1
		// starting positions for this route
		_starts = 
		[
			[16194.079, 13621.103],
			[16583.400, 13583.451],
			[16206.625, 13648.875]
		];
		// starting directions in which the vehicles are spawned on this route
		_startdirs = 
		[
			359,
			359,
			359
		];
		// the routes
		_waypoints = 
		[
			[17255.846, 14220.847],
			[16287.781, 15038.060],
			[15964.704, 15659.114],
			[14754.604, 15592.636],
			[14193.306, 14947.681],
			[12637.459, 13935.034],
			[14043.634, 13585.378],
			[14117.663, 13219.207],
			[14595.131, 13119.306],
			[14262.767, 12693.379],
			[13157.443, 12962.416],
			[12703.839, 12870.178],
			[12660.362, 12474.210],
			[11239.827, 10491.392],
			[11394.038, 10276.672],
			[12017.429, 10885.565],
			[14493.782, 10806.185],
			[14573.792, 11238.051],
			[15078.532, 11640.620],
			[15865.064, 11533.115],
			[16378.567, 12070.508],
			[16267.877, 12449.075],
			[16258.439, 12888.987],
			[16596.111, 13251.186],
			[16362.284, 13632.865]
		];
		// end of route one
	}; 
	case 2: {
		// route 2
		// starting positions for this route
		_starts = 
		[
			[28843.705, 25692.504],
			[28332.609, 25711.500],
			[28795.695, 25635.248]
		];
		// starting directions in which the vehicles are spawned on this route
		_startdirs = 
		[
			188.5,
			186.4,
			188.5
		];
		// the routes
		_waypoints = 
		[
			[28503.828, 25038.117],
			[28047.289, 24302.654],
			[28677.008, 23975.385],
			[28066.318, 23327.387],
			[28399.662, 21286.789],
			[26326.570, 19243.736],
			[24502.633, 17348.754],
			[24585.064, 15150.700],
			[22630.736, 15105.453],
			[22685.791, 14300.365],
			[23739.311, 13826.058],
			[21759.576, 12477.538],
			[22606.908, 10942.187],
			[21674.514, 10156.140],
			[23312.535, 7629.2891]
		];
		// end of route two
	}; 
	case 3: {
		// route 3
		// starting positions for this route
		_starts = 
		[
			[1542.4482, 22594.959],
			[2324.2144, 22392.635],
			[1420.2397, 22516.305]
		];
		// starting directions in which the vehicles are spawned on this route
		_startdirs = 
		[
			181.4,
			165,
			181.4
		];
		// the routes
		_waypoints = 
		[
			[1565.3274, 22005.053],
			[2524.3030, 21745.582],
			[2637.9707, 20660.688],
			[2116.2466, 19999.037],
			[2759.2097, 18199.066],
			[2267.7351, 17707.943],
			[4023.3813, 16839.555],
			[3602.7334, 15615.604],
			[3685.7080, 14979.358],
			[2907.7515, 14430.448],
			[2886.1211, 13956.960],
			[3349.8691, 13952.924],
			[3314.3284, 13381.381],
			[2758.5051, 13396.754],
			[2755.2175, 12885.417]
		];
		// end of route three
	}; 
	default {
		// this shouldnt happen but just to be sure..
		diag_log format["WASTELAND SERVER - WARNING! %1 encountered an error selecting routes - defaulting to route 1", _missionType];
		// route 1
		// starting positions for this route
		_starts = 
		[
			[16194.079, 13621.103],
			[16583.400, 13583.451],
			[16206.625, 13648.875]
		];
		// starting directions in which the vehicles are spawned on this route
		_startdirs = [
			359,
			359,
			359
		];
		// the routes
		_waypoints = 
		[
			[17255.846, 14220.847],
			[16287.781, 15038.060],
			[15964.704, 15659.114],
			[14754.604, 15592.636],
			[14193.306, 14947.681],
			[12637.459, 13935.034],
			[14043.634, 13585.378],
			[14117.663, 13219.207],
			[14595.131, 13119.306],
			[14262.767, 12693.379],
			[13157.443, 12962.416],
			[12703.839, 12870.178],
			[12660.362, 12474.210],
			[11239.827, 10491.392],
			[11394.038, 10276.672],
			[12017.429, 10885.565],
			[14493.782, 10806.185],
			[14573.792, 11238.051],
			[15078.532, 11640.620],
			[15865.064, 11533.115],
			[16378.567, 12070.508],
			[16267.877, 12449.075],
			[16258.439, 12888.987],
			[16596.111, 13251.186],
			[16362.284, 13632.865]
		];
		// end of route one
	}; 
}; 

_groupcc = createGroup civilian;

_createVehicle = {
    private ["_type","_position","_direction","_groupcc","_vehicle","_soldier"];
    _type = _this select 0;
    _position = _this select 1;
    _direction = _this select 2;
    _groupcc = _this select 3;
    _vehicle = _type createVehicle _position;
	[_vehicle] call vehicleSetup;
    _vehicle setDir _direction;
    _groupcc addVehicle _vehicle;
	// add a driver/pilot/captain to the vehicle
	// the little-bird and Orca do not require gunners and should not have any passengers
    _soldier = [_groupcc, _position] call createRandomSoldierC; 
    _soldier moveInDriver _vehicle;
    if ((_vehicle isKindOf "B_Heli_Transport_01_camo_F") || (_vehicle isKindOf "B_Heli_Transport_01_F")) then {
		// these choppers have 2 turrets so we need 2 gunners :)
	   _soldier = [_groupcc, _position] call createRandomSoldierC; 
	   _soldier assignAsGunner _vehicle;
       _soldier moveInTurret [_vehicle, [1]];
  	   _soldier = [_groupcc, _position] call createRandomSoldierC; 
	   _soldier assignAsGunner _vehicle;
       _soldier moveInTurret [_vehicle, [2]];
    };
	if ((_vehicle isKindOf "B_Heli_Attack_01_F") || (_vehicle isKindOf "O_Heli_Attack_02_black_F") || (_vehicle isKindOf "O_Heli_Attack_02_F")) then {
		// these choppers need 1 gunner
	   _soldier = [_groupcc, _position] call createRandomSoldierC; 
	   _soldier assignAsGunner _vehicle;
       _soldier moveInTurret [_vehicle, [0]];
    };
	
	if ((_vehicle isKindOf _veh1) || (_vehicle isKindOf _veh3)) then {
		// the boats need a gunner (rear) and a commander (frontgunner) aside from a driver
	   if (A3W_missionsDifficulty == 1) then {  // frontgunner will be here if mission is running at hard dificulty
			_soldier = [_groupcc, _position] call createRandomSoldierC; 
			_soldier assignAsGunner _vehicle;
			_soldier moveInTurret [_vehicle, [0]]; //commanderseat - front funner
		};
	   _soldier = [_groupcc, _position] call createRandomSoldierC; 
	   _soldier assignAsGunner _vehicle;
       _soldier moveInTurret [_vehicle, [1]]; //rear gunner
    };
	// remove flares because it overpowers AI choppers
	if ("CMFlareLauncher" in getArray (configFile >> "CfgVehicles" >> _type >> "weapons")) then
	{
		{
			if (_x isKindOf "60Rnd_CMFlare_Chaff_Magazine") then
			{
				_vehicle removeMagazinesTurret [_x, [-1]];
			};
		} forEach (_vehicle magazinesTurret [-1]);
	};
    _vehicle setVehicleLock "LOCKED";  // prevents players from getting into the vehicle while the AI are still owning it
	_vehicle spawn cleanVehicleWreck;  // courtesy of AgentREV sets cleanup on the mission vehicles once wrecked :)
    _vehicle
};

_vehicles = [];
_vehicles set [0, [_veh1, (_starts select 0), (_startdirs select 0), _groupcc] call _createVehicle];
_vehicles set [1, [_veh2, (_starts select 1), (_startdirs select 1), _groupcc] call _createVehicle];
_vehicles set [2, [_veh3, (_starts select 2), (_startdirs select 2), _groupcc] call _createVehicle];

_leader = driver (_vehicles select 0);
_groupcc selectLeader _leader;
_leader setRank "LIEUTENANT";

_groupcc setCombatMode "GREEN"; // units will defend themselves
_groupcc setBehaviour "SAFE"; // units feel safe until they spot an enemy or get into contact
_groupcc setFormation "STAG COLUMN";
_groupcc setSpeedMode "LIMITED";

// behaviour on waypoints
{
    _waypoint = _groupcc addWaypoint [_x, 0];
    _waypoint setWaypointType "MOVE";
    _waypoint setWaypointCompletionRadius 50;
    _waypoint setWaypointCombatMode "GREEN"; 
    _waypoint setWaypointBehaviour "SAFE"; 
    _waypoint setWaypointFormation "STAG COLUMN";
    _waypoint setWaypointSpeed "LIMITED";
} forEach _waypoints;

// marker follows mission movement
_marker = createMarker [_missionMarkerName, position leader _groupcc];
_marker setMarkerType "mil_destroy";
_marker setMarkerSize [1.25, 1.25];
_marker setMarkerColor "ColorRed";
_marker setMarkerText "Coastal Patrol";

_picture = getText (configFile >> "CfgVehicles" >> _veh1 >> "picture");
_vehicleName = getText (configFile >> "cfgVehicles" >> _veh2 >> "displayName");
_vehicleName2 = getText (configFile >> "cfgVehicles" >> _veh1 >> "displayName");
_vehicleName3 = getText (configFile >> "cfgVehicles" >> _veh3 >> "displayName");

// Remove " (Camo)" from vehicle name when applicable
if ([_vehicleName2, (count toArray _vehicleName2) - 7] call BIS_fnc_trimString == " (Camo)") then
{
	_vehicleName2 = [_vehicleName2, 0, (count toArray _vehicleName2) - 8] call BIS_fnc_trimString;
};

_hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Main Objective</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>A <t color='%4'>%3</t> is patrolling the coasts with a <t color='%4'>%6</t> and a <t color='%4'>%7</t>.<br/>Intercept them and recover their cargo!</t>", _missionType, _picture, _vehicleName, mainMissionColor, subTextColor, _vehicleName2, _vehicleName3];
[_hint] call hintBroadcast;

diag_log format["WASTELAND SERVER - Main Mission Waiting to be Finished: %1", _missionType];

_failed = false;
_startTime = floor(time);
_numWaypoints = count waypoints _groupcc;
waitUntil
{
    private ["_unitsAlive"];
    
    sleep 10; 
    
    _marker setMarkerPos (position leader _groupcc);
    
    if ((floor time) - _startTime >= A3W_mainMissionTimeout) then { _failed = true };
    if (currentWaypoint _groupcc >= _numWaypoints) then { _failed = true }; // patrol finished its route
    _unitsAlive = { alive _x } count units _groupcc;
    
    _unitsAlive == 0 || _failed
};

if(_failed) then
{
    // Mission failed
    if not(isNil "_vehicle") then {deleteVehicle _vehicle;};
	{if (vehicle _x != _x) then { deleteVehicle vehicle _x; }; deleteVehicle _x;}forEach units _groupcc;
	{deleteVehicle _x;}forEach units _groupcc;
	deleteGroup _groupcc; 
    _hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Objective Failed</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>Objective failed, better luck next time.</t>", _missionType, _picture, _vehicleName, failMissionColor, subTextColor];
    [_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Main Mission Failed: %1",_missionType];
} else {
    // Mission complete
	// unlock the vehicles and enable R3F incase they manage to kill all AI without destroying the vehicles
	if (!isNil "_vehicles") then { 
		{
			_x setVehicleLock "UNLOCKED"; 
			_x setVariable ["R3F_LOG_disabled", false, true];
		}forEach _vehicles;
	};
	// give the rewards
	_ammobox = "Box_IND_WpsSpecial_F" createVehicle getMarkerPos _marker;
    [_ammobox,"mission_Main_A3snipers"] call fn_refillbox;
	_ammobox allowDamage false;
    _ammobox setVariable ["R3F_LOG_disabled", false, true];
	
    _ammobox2 = "Box_East_WpsSpecial_F" createVehicle getMarkerPos _marker;
    [_ammobox2,"mission_USLaunchers"] call fn_refillbox;
	_ammobox2 allowDamage false;
    _ammobox2 setVariable ["R3F_LOG_disabled", false, true];
	
	deleteGroup _groupcc; 
    _hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Objective Complete</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>The patrol has been stopped, the ammo crates are yours to take. Find them near the wreck!</t>", _missionType, _picture, _vehicleName, successMissionColor, subTextColor];
    [_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Main Mission Success: %1",_missionType];
};

deleteMarker _marker;
