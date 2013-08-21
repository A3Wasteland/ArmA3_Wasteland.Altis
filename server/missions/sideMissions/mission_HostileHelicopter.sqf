private ["_helipick","_missionMarkerName","_missionType","_picture","_vehicleName","_hint","_waypoint","_waypoints","_groupsm","_vehicles","_marker","_failed","_startTime","_numWaypoints","_ammobox","_createVehicle","_leader"];

#include "sideMissionDefines.sqf"

_missionMarkerName = "HostileHeli_Marker";
_missionType = "HostileHeli";

diag_log format["WASTELAND SERVER - Side Mission Started: %1", _missionType];

diag_log format["WASTELAND SERVER - Side Mission Waiting to run: %1", _missionType];
[sideMissionDelayTime] call createWaitCondition;
diag_log format["WASTELAND SERVER - Side Mission Resumed: %1", _missionType];

_helipick = ["O_Heli_Attack_02_black_F","O_Heli_Light_02_F","B_Heli_Transport_01_F","B_Heli_Light_01_armed_F"] call BIS_fnc_selectRandom;
_groupsm = createGroup civilian;

_createVehicle = {
    private ["_type","_position","_direction","_groupsm","_vehicle","_soldier"];
    
    _type = _this select 0;
    _position = _this select 1;
    _direction = _this select 2;
    _groupsm = _this select 3;
    
    _vehicle = _type createVehicle _position;
    _vehicle setDir _direction;
	_vehicle setVariable [call vChecksum, true, false];
    _groupsm addVehicle _vehicle;
    
    _soldier = [_groupsm, _position] call createRandomSoldier; 
    _soldier moveInDriver _vehicle;
    _soldier = [_groupsm, _position] call createRandomSoldier; 
    _soldier assignAsGunner _vehicle;
    _soldier moveInTurret [_vehicle, [0]];  

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
_vehicles set [0, [_helipick, [7108.42,5996.3,0.00166416], 284, _groupsm] call _createVehicle];

_leader = driver (_vehicles select 0);
_groupsm selectLeader _leader;
_leader setRank "LIEUTENANT";

_groupsm setCombatMode "WHITE";
_groupsm setBehaviour "AWARE";
_groupsm setFormation "STAG COLUMN";
_groupsm setSpeedMode "LIMITED";

_waypoints = [
    [7096.54,5961.44,0.0016098],
    [6421.47,5425.19,0.00143147],
    [4368.64,3818.18,0.00146484],
    [5027.28,5904.69,0.00134277],
    [2695.63,5802.37,0.00144649],
    [1955.14,3525.81,0.00142336],
    [2984.66,1869.46,0.00144958],
    [4601.99,5296.73,0.00160217],
    [4368.64,3818.18,0.00146484],
    [5027.28,5904.69,0.00134277],
    [2695.63,5802.37,0.00144649],
    [1955.14,3525.81,0.00142336],
    [2984.66,1869.46,0.00144958],
    [4601.99,5296.73,0.00160217],
    [1886.15,5728.88,0.00145006]
];
{
    _waypoint = _groupsm addWaypoint [_x, 0];
    _waypoint setWaypointType "MOVE";
    _waypoint setWaypointCompletionRadius 55;
    _waypoint setWaypointCombatMode "WHITE"; // Defensiv behaviour
    _waypoint setWaypointBehaviour "AWARE"; // Force convoy to normaly drive on the street.
    _waypoint setWaypointFormation "STAG COLUMN";
    _waypoint setWaypointSpeed "LIMITED";
} forEach _waypoints;

_marker = createMarker [_missionMarkerName, position leader _groupsm];
_marker setMarkerType "mil_destroy";
_marker setMarkerSize [1.25, 1.25];
_marker setMarkerColor "ColorRed";
_marker setMarkerText "Hostile Helicopter";

_picture = getText (configFile >> "CfgVehicles" >> _helipick >> "picture");
_vehicleName = getText (configFile >> "cfgVehicles" >> _helipick >> "displayName");
_hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>!! WARNING !!</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>An armed <t color='%4'>%3</t> is patrolling the island. Destroy it and steal the weaponcrate inside!</t>", _missionType, _picture, _vehicleName, sideMissionColor, subTextColor];
messageSystem = _hint;
if (!isDedicated) then { call serverMessage };
publicVariable "messageSystem";

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
    _hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>! NOTICE !</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>The patrol ended, the enemy has survived and escaped with the weaponcrate</t>", _missionType, _picture, _vehicleName, failMissionColor, subTextColor];
    messageSystem = _hint;
    if (!isDedicated) then { call serverMessage };
    publicVariable "messageSystem";
    diag_log format["WASTELAND SERVER - Side Mission Failed: %1",_missionType];
} else {
    // Mission complete
    if not(isNil "_vehicle") then {_vehicle setVehicleLock "UNLOCKED";};
    _ammobox = "Box_NATO_Wps_F" createVehicle getMarkerPos _marker;
    clearMagazineCargoGlobal _ammobox;
    clearWeaponCargoGlobal _ammobox; 
    [_ammobox,"mission_Side_USSpecial"] call fn_refillbox;
    _hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>PATROL IS DOWN</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>The sky is clear agian, the enemy patrol was taken out! The ammocrate seems to be intact near the wreck!</t>", _missionType, _picture, _vehicleName, successMissionColor, subTextColor];
    messageSystem = _hint;
    if (!isDedicated) then { call serverMessage };
    publicVariable "messageSystem";
    diag_log format["WASTELAND SERVER - Side Mission Success: %1",_missionType];
};

deleteMarker _marker;
