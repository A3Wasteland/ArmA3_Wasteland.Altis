//	@file Version: 1
//	@file Name: mission_HostileHelicopter.sqf
//	@file Author: JoSchaap
//  new one, no longer requires static routes, can use all helicopters now

if (!isServer) exitwith {};
#include "sideMissionDefines.sqf"

private ["_helipick","_missionMarkerName","_missionType","_picture","_vehicleName","_hint","_waypoint","_waypoints","_groupsm","_vehicles","_marker","_failed","_startTime","_numWaypoints","_ammobox","_createVehicle","_leader","_routepoints","_travels","_travelcount"];

_missionMarkerName = "HostileHeli_Marker";
_missionType = "Hostile Helicopter";

_travels = 20; 						// the ammount of towns the helicopter should visit before the mission ends
_travelcount = 0;
_waypoints = [];

diag_log format["WASTELAND SERVER - Side Mission Started: %1", _missionType];
diag_log format["WASTELAND SERVER - Side Mission Waiting to run: %1", _missionType];
[A3W_sideMissionDelayTime] call createWaitCondition;
diag_log format["WASTELAND SERVER - Side Mission Resumed: %1", _missionType];

// helicopters available for this mission (if mission is in hard difficulty also chance on a mi48)
// if mission set to easy, helicopter will fly at half speed
if (A3W_missionsDifficulty == 1) then {
	_helipick = ["O_Heli_Attack_02_black_F","O_Heli_Attack_02_F","O_Heli_Light_02_F","B_Heli_Transport_01_F","B_Heli_Light_01_armed_F","B_Heli_Transport_01_camo_F"] call BIS_fnc_selectRandom;
} else {
	_helipick = ["O_Heli_Light_02_F","B_Heli_Transport_01_F","B_Heli_Light_01_armed_F","B_Heli_Transport_01_camo_F"] call BIS_fnc_selectRandom;
};
_groupsm = createGroup civilian;

_createVehicle = {
    private ["_type","_position","_direction","_groupsm","_vehicle","_soldier"];
    _type = _this select 0;
    _position = _this select 1;
    _direction = _this select 2;
    _groupsm = _this select 3;
    _vehicle = _type createVehicle _position;
	[_vehicle] call vehicleSetup;
    _vehicle setDir _direction;
    _groupsm addVehicle _vehicle;
    // create units
	// driver/pilot
    _soldier = [_groupsm, _position] call createRandomSoldier; 
    _soldier moveInDriver _vehicle;	
	// create additional gunners if needed
    if ((_vehicle isKindOf "B_Heli_Transport_01_camo_F") || (_vehicle isKindOf "B_Heli_Transport_01_F")) then {
		// these choppers have 2 turrets so we need 2 gunners :)
	   _soldier = [_groupsm, _position] call createRandomSoldier; 
	   _soldier assignAsGunner _vehicle;
       _soldier moveInTurret [_vehicle, [1]];
  	   _soldier = [_groupsm, _position] call createRandomSoldier; 
	   _soldier assignAsGunner _vehicle;
       _soldier moveInTurret [_vehicle, [2]];
    };
	if ((_vehicle isKindOf "B_Heli_Attack_01_F") || (_vehicle isKindOf "O_Heli_Attack_02_black_F") || (_vehicle isKindOf "O_Heli_Attack_02_F")) then {
		// these choppers need 1 gunner
	   _soldier = [_groupsm, _position] call createRandomSoldier; 
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
_vehicles set [0, [_helipick, [2387.74, 9336.96], 349, _groupsm] call _createVehicle];  // static value update when porting to different maps

_leader = driver (_vehicles select 0);
_groupsm selectLeader _leader;
_leader setRank "LIEUTENANT";

_groupsm setCombatMode "WHITE";
_groupsm setBehaviour "AWARE";
_groupsm setFormation "STAG COLUMN";
if (A3W_missionsDifficulty == 1) then {
	_groupsm setSpeedMode "NORMAL";
} else {
	_groupsm setSpeedMode "LIMITED";
};

									// pick random townmarkers from the citylist and use their location as waypoints
while {_travelcount < _travels} do {
	_travelcount = (_travelcount + 1);
	_waypoints set [count _waypoints, getMarkerPos (((call citylist) call BIS_fnc_selectRandom) select 0)];
};

{
    _waypoint = _groupsm addWaypoint [_x, 0];
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

_marker = createMarker [_missionMarkerName, position leader _groupsm];
_marker setMarkerType "mil_destroy";
_marker setMarkerSize [1.25, 1.25];
_marker setMarkerColor "ColorRed";
_marker setMarkerText "Hostile Helicopter";

_picture = getText (configFile >> "CfgVehicles" >> _helipick >> "picture");
_vehicleName = getText (configFile >> "cfgVehicles" >> _helipick >> "displayName");

// Remove " (Camo)" from vehicle name when applicable
if ([_vehicleName, (count toArray _vehicleName) - 7] call BIS_fnc_trimString == " (Camo)") then
{
	_vehicleName = [_vehicleName, 0, (count toArray _vehicleName) - 8] call BIS_fnc_trimString;
};

_hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Main Objective</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>An armed <t color='%4'>%3</t> is patrolling the island. Intercept it and recover its cargo!</t>", _missionType, _picture, _vehicleName, sideMissionColor, subTextColor];
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
    
    if ((floor time) - _startTime >= A3W_sideMissionTimeout) then { _failed = true };
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
    _hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Objective Failed</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>The patrol ended, the enemy has survived and escaped with the ammo crates.</t>", _missionType, _picture, _vehicleName, failMissionColor, subTextColor];
    [_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Side Mission Failed: %1 ",_missionType];
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
    [_ammobox,"mission_USSpecial"] call fn_refillbox;
	_ammobox allowDamage false;
    _ammobox setVariable ["R3F_LOG_disabled", false, true];
	
	deleteGroup _groupsm;
    _hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Objective Complete</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>The sky is clear again, the enemy patrol was taken out! Ammo crates have fallen near the wreck.</t>", _missionType, _picture, _vehicleName, successMissionColor, subTextColor];
    [_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Side Mission Success: %1",_missionType];
};

deleteMarker _marker;
