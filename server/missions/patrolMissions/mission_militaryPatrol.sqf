// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: mission_mapPatrol.sqf
//	@file Author: JoSchaap, AgentRev, LouD

if (!isServer) exitwith {};
#include "patrolMissionDefines.sqf";

private ["_convoyVeh","_veh1","_veh2","_veh3","_veh4","_veh5","_veh6","_createVehicle1","_createVehicle2","_createVehicle3","_vehicles", "_leader", "_speedMode", "_waypoint", "_vehicleName", "_numWaypoints", "_cash", "_box1", "_box2", "_box3", "_randomBox1", "_randomBox2", "_randomBox3", "_Case1", "_Case2", "_Case3"];

_setupVars =
{
	_missionType = "Military Patrol";
	_locationsArray = nil; //PatrolConvoyPaths;
};

_setupObjects =
{
	private ["_starts", "_startDirs", "_waypoints"];
	call compile preprocessFileLineNumbers format ["mapConfig\convoys\%1.sqf", _missionLocation];

	// Pick the vehicles for the patrol. Only one set at the moment. Will add more later.
	_convoyVeh =
	[
		//NATO Patrols
		["B_MRAP_01_hmg_F", "B_MRAP_01_gmg_F", "B_APC_Wheeled_01_cannon_F", "B_APC_Wheeled_01_cannon_F", "B_MRAP_01_hmg_F", "B_MRAP_01_gmg_F"], // Light Patrol
		["B_MRAP_01_hmg_F", "B_MBT_01_cannon_F", "B_APC_Wheeled_01_cannon_F", "B_APC_Tracked_01_AA_F", "B_MBT_01_cannon_F", "B_MRAP_01_gmg_F"], // Medium Patrol
		["B_MBT_01_TUSK_F", "B_APC_Tracked_01_AA_F", "B_MBT_01_cannon_F", "B_MBT_01_cannon_F", "B_APC_Tracked_01_AA_F", "B_MBT_01_TUSK_F"], // Heavy Patrol
		["B_MBT_01_TUSK_F", "B_APC_Tracked_01_AA_F", "B_MBT_01_cannon_F", "B_APC_Tracked_01_AA_F", "B_APC_Tracked_01_AA_F", "B_MBT_01_TUSK_F"], // AA Patrol
		["B_APC_Tracked_01_CRV_F", "B_APC_Wheeled_01_cannon_F", "B_APC_Wheeled_01_cannon_F", "B_APC_Tracked_01_AA_F", "B_APC_Wheeled_01_cannon_F", "B_APC_Tracked_01_rcws_F"], // Route Clearance Patrol
		// ["B_MBT_01_TUSK_F", "B_APC_Tracked_01_AA_F", "B_MBT_01_TUSK_F", "B_MBT_01_arty_F", "B_APC_Tracked_01_AA_F", "B_MBT_01_TUSK_F"], // Arty Patrol

		//CSAT Patrols
		["O_MRAP_02_hmg_F", "O_MBT_02_cannon_F", "O_APC_Wheeled_02_rcws_F", "O_APC_Tracked_02_AA_F", "O_MBT_02_cannon_F", "O_MRAP_02_gmg_F"], //Medium Patrol

		//AAF Patrols
		["I_MRAP_03_gmg_F", "I_MBT_03_cannon_F", "I_APC_Wheeled_03_cannon_F", "I_APC_tracked_03_cannon_F", "I_MBT_03_cannon_F", "I_MRAP_03_hmg_F"] //Medium Patrol
	] call BIS_fnc_selectRandom;

	_veh1 = _convoyVeh select 0;
	_veh2 = _convoyVeh select 1;
	_veh3 = _convoyVeh select 2;
	_veh4 = _convoyVeh select 3;
	_veh5 = _convoyVeh select 4;
	_veh6 = _convoyVeh select 5;

	_createVehicle1 = {
		private ["_type","_position","_direction","_vehicle","_soldier"];

		_type = _this select 0;
		_position = _this select 1;
		_direction = _this select 2;

		_vehicle = createVehicle [_type, _position, [], 0, "None"];
		[_vehicle] call vehicleSetup;

		_vehicle setDir _direction;
		_aiGroup addVehicle _vehicle;

		_soldier = [_aiGroup, _position] call createRandomSoldier;
		_soldier moveInDriver _vehicle;
		_soldier = [_aiGroup, _position] call createRandomSoldier;
		_soldier moveInCommander _vehicle;
		_soldier = [_aiGroup, _position] call createRandomSoldier;
		_soldier moveInCargo [_vehicle, 0];
		_vehicle setVehicleLock "UNLOCKED";  // force vehicles to be unlocked
		_vehicle setVariable ["R3F_LOG_disabled", false, true]; // force vehicles to be unlocked
		_vehicle
	};

	_createVehicle2 = {
		private ["_type","_position","_direction","_vehicle","_soldier"];

		_type = _this select 0;
		_position = _this select 1;
		_direction = _this select 2;

		_vehicle = createVehicle [_type, _position, [], 0, "None"];
		[_vehicle] call vehicleSetup;

		_vehicle setDir _direction;
		_aiGroup addVehicle _vehicle;

		_soldier = [_aiGroup, _position] call createRandomSoldier;
		_soldier moveInDriver _vehicle;
		_soldier = [_aiGroup, _position] call createRandomSoldier;
		_soldier moveInCommander _vehicle;
		_soldier = [_aiGroup, _position] call createRandomSoldier;
		_soldier moveInGunner _vehicle;
		_vehicle setVehicleLock "UNLOCKED";  // force vehicles to be unlocked
		_vehicle setVariable ["R3F_LOG_disabled", false, true]; // force vehicles to be unlocked
		_vehicle
	};

		_createVehicle3 = {
		private ["_type","_position","_direction","_vehicle","_soldier"];

		_type = _this select 0;
		_position = _this select 1;
		_direction = _this select 2;

		_vehicle = createVehicle [_type, _position, [], 0, "None"];
		[_vehicle] call vehicleSetup;

		_vehicle setDir _direction;
		_aiGroup addVehicle _vehicle;

		_soldier = [_aiGroup, _position] call createRandomSoldier;
		_soldier moveInDriver _vehicle;
		_soldier = [_aiGroup, _position] call createRandomSoldier;
		_soldier moveInCargo [_vehicle, 0];
		_vehicle setVehicleLock "UNLOCKED";  // force vehicles to be unlocked
		_vehicle setVariable ["R3F_LOG_disabled", false, true]; // force vehicles to be unlocked
		_vehicle
	};

	_aiGroup = createGroup CIVILIAN;

	_vehicles =
	[
		[_veh1, _starts select 0, _startDirs select 0] call _createVehicle2,
		[_veh2, _starts select 1, _startDirs select 1] call _createVehicle2,
		[_veh3, _starts select 2, _startDirs select 2] call _createVehicle2,
		[_veh4, _starts select 3, _startDirs select 3] call _createVehicle2,
		[_veh5, _starts select 4, _startDirs select 4] call _createVehicle2,
		[_veh6, _starts select 5, _startDirs select 5] call _createVehicle2
	];

	_leader = effectiveCommander (_vehicles select 0);
	_aiGroup selectLeader _leader;
	_leader setRank "LIEUTENANT";

	_aiGroup setCombatMode "GREEN"; // units will defend themselves
	_aiGroup setBehaviour "SAFE"; // units feel safe until they spot an enemy or get into contact
	_aiGroup setFormation "STAG COLUMN";

	_speedMode = if (missionDifficultyHard) then { "NORMAL" } else { "LIMITED" };
	_aiGroup setSpeedMode _speedMode;

	{
		_waypoint = _aiGroup addWaypoint [_x, 0];
		_waypoint setWaypointType "MOVE";
		_waypoint setWaypointCompletionRadius 50;
		_waypoint setWaypointCombatMode "GREEN";
		_waypoint setWaypointBehaviour "SAFE"; // safe is the best behaviour to make AI follow roads, as soon as they spot an enemy or go into combat they WILL leave the road for cover though!
		_waypoint setWaypointFormation "FILE";
		_waypoint setWaypointSpeed _speedMode;
	} forEach _waypoints;

	_missionPos = getPosATL leader _aiGroup;

	_missionPicture = getText (configFile >> "CfgVehicles" >> _veh4 >> "picture");
	_vehicleName = getText (configFile >> "CfgVehicles" >> _veh2 >> "displayName");
	_vehicleName2 = getText (configFile >> "CfgVehicles" >> _veh4 >> "displayName");
	_vehicleName3 = getText (configFile >> "CfgVehicles" >> _veh5 >> "displayName");

	_missionHintText = format ["Um comboio contendo pelo menos uma <t color='%4'>%1</t>, <t color='%4'>%2</t> e <t color='%4'>%3</t> está patrulhando um local com alto valor! Pare-os e pegue a caixa de armas e um alto valor em dinheiro!", _vehicleName, _vehicleName2, _vehicleName3, patrolMissionColor];

	_numWaypoints = count waypoints _aiGroup;
};

_waitUntilMarkerPos = {getPosATL _leader};
_waitUntilExec = nil;
_waitUntilCondition = {currentWaypoint _aiGroup >= _numWaypoints};

_failedExec = nil;

// _vehicles are automatically deleted or unlocked in missionProcessor depending on the outcome

_successExec =
{
	// Mission completed

	for "_x" from 1 to 10 do
	{
		_cash = "Land_Money_F" createVehicle markerPos _marker;
		_cash setPos ((markerPos _marker) vectorAdd ([[2 + random 2,0,0], random 360] call BIS_fnc_rotateVector2D));
		_cash setDir random 360;
		_cash setVariable["cmoney",2500,true];
		_cash setVariable["owner","world",true];
	};

	//This works
	_box1 = "B_supplyCrate_F" createVehicle getMarkerPos _marker;
    [_box1,"Launchers_Tier_2"] call fn_refillbox;
	_box1 allowDamage false;

	_box2 = "Box_NATO_Wps_F" createVehicle getMarkerPos _marker;
    [_box2,"mission_USSpecial2"] call fn_refillbox;
	_box2 allowDamage false;

	_box3 = "Box_NATO_Support_F" createVehicle getMarkerPos _marker;
    [_box3,"airdrop_Snipers"] call fn_refillbox;
	_box3 allowDamage false;

	_box4 = "Box_NATO_Support_F" createVehicle getMarkerPos _marker;
    [_box4,"airdrop_Rifles"] call fn_refillbox;
	_box4 allowDamage false;

	_successHintMessage = "Comboio interceptado, dinheiro, suprimentos e veiculos são seus.";
};

_this call patrolMissionProcessor;
