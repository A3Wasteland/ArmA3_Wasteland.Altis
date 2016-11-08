// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: mission_HostileJet.sqf
//	@file Author: JoSchaap, AgentRev, LouD

if (!isServer) exitwith {};
#include "hostileairMissionDefines.sqf";

private ["_planeChoices", "_convoyVeh", "_veh1", "_createVehicle", "_vehicles", "_leader", "_speedMode", "_waypoint", "_vehicleName", "_numWaypoints", "_cash", "_boxes1","_boxes2","_boxes3","_boxes4","_boxes5","_boxes6", "_box1", "_box2", "_box3", "_box4", "_box5", "_box6", "_currBox1", "_currBox2", "_currBox3", "_currBox4", "_currBox5", "_currBox6"];

_setupVars =
{
	_missionType = "Gunship";
	_locationsArray = nil; // locations are generated on the fly from towns
};

_setupObjects =
{
	_missionPos = markerPos (((call cityList) call BIS_fnc_selectRandom) select 0);

	_planeChoices =
	[
		["B_T_VTOL_01_armed_F"]
	];

	_convoyVeh = _planeChoices call BIS_fnc_selectRandom;

	_veh1 = _convoyVeh select 0;

	_createVehicle =
	{
		private ["_type","_position","_direction","_vehicle","_soldier"];

		_type = _this select 0;
		_position = _this select 1;
		_direction = _this select 2;


		_vehicle = createVehicle [_type, _position, [], 0, "FLY"]; // Added to make it fly
		_vehicle setVariable ["R3F_LOG_disabled", true, true];
		_vel = [velocity _vehicle, -(_direction)] call BIS_fnc_rotateVector2D; // Added to make it fly
		_vehicle setDir _direction;
		_vehicle setVelocity _vel; // Added to make it fly
		_vehicle setVariable [call vChecksum, true, false];
		_aiGroup addVehicle _vehicle;

		// add pilot
		_soldier = [_aiGroup, _position] call createRandomPilot;
		_soldier moveInDriver _vehicle;
		_soldier = [_aiGroup, _position] call createRandomPilot;
		_soldier moveInTurret [_vehicle, [0]];
		_soldier = [_aiGroup, _position] call createRandomPilot;
		_soldier moveInTurret [_vehicle, [1]];
		_soldier = [_aiGroup, _position] call createRandomPilot;
		_soldier moveInTurret [_vehicle, [2]];
		// lock the vehicle untill the mission is finished and initialize cleanup on it


		[_vehicle, _aiGroup] spawn checkMissionVehicleLock;
		_vehicle
	};

	_aiGroup = createGroup CIVILIAN;

	_vehicles = [];
	_vehicles set [0, [_veh1,[14321.6,15857.7,0], 14, _aiGroup] call _createVehicle]; // static value update when porting to different maps

	_leader = effectiveCommander (_vehicles select 0);
	_aiGroup selectLeader _leader;
	_leader setRank "LIEUTENANT";

	_aiGroup setCombatMode "RED";
	_aiGroup setBehaviour "COMBAT";
	_aiGroup setFormation "STAG COLUMN";

	_speedMode = if (missionDifficultyHard) then { "NORMAL" } else { "LIMITED" };

	// behaviour on waypoints
	{
		_waypoint = _aiGroup addWaypoint [markerPos (_x select 0), 0];
		_waypoint setWaypointType "MOVE";
		_waypoint setWaypointCompletionRadius 55;
		_waypoint setWaypointCombatMode "RED";
		_waypoint setWaypointBehaviour "COMBAT";
		_waypoint setWaypointFormation "STAG COLUMN";
		_waypoint setWaypointSpeed _speedMode;
	} forEach ((call cityList) call BIS_fnc_arrayShuffle);

	_missionPos = getPosATL leader _aiGroup;

	_missionPicture = getText (configFile >> "CfgVehicles" >> _veh1 >> "picture");
	_vehicleName = getText (configFile >> "CfgVehicles" >> _veh1 >> "displayName");
	_missionHintText = format ["An armed <t color='%2'>%1</t> is patrolling the island. Shoot it down and kill the pilot to recover the money and weapons!", _vehicleName, hostileairMissionColor];

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

	//Money
	for "_i" from 1 to 10 do
	{
		_cash = createVehicle ["Land_Money_F", _lastPos, [], 5, "None"];
		_cash setPos ([_lastPos, [[2 + random 3,0,0], random 360] call BIS_fnc_rotateVector2D] call BIS_fnc_vectorAdd);
		_cash setDir random 360;
		_cash setVariable ["cmoney", 5000, true];
		_cash setVariable ["owner", "world", true];
	};
	
	_Boxes1 = ["mission_Uniform","mission_DLCRifles","mission_DLCLMGs","mission_HVLaunchers","mission_ApexRifles"];
	_currBox1 = _Boxes1 call BIS_fnc_selectRandom;
	_box1 = createVehicle ["mission_DLCRifles", _lastPos, [], 2, "None"];
	_box1 setDir random 360;
	[_box1, _randomBox] call fn_refillbox;
	_box1 allowDamage false;
	
	_Boxes2 = ["mission_Uniform","mission_DLCRifles","mission_DLCLMGs","mission_HVLaunchers","mission_ApexRifles"];
	_currBox2 = _Boxes2 call BIS_fnc_selectRandom;
	_box2 = createVehicle ["mission_DLCLMGs", _lastPos, [], 2, "None"];
	_box2 setDir random 360;
	[_box2, _randomBox2] call fn_refillbox;
	_box2 allowDamage false;
	
	_Boxes3 = ["mission_Uniform","mission_DLCRifles","mission_DLCLMGs","mission_HVLaunchers","mission_ApexRifles"];
	_currBox3 = _Boxes3 call BIS_fnc_selectRandom;
	_box3 = createVehicle ["mission_HVLaunchers", _lastPos, [], 2, "None"];
	_box3 setDir random 360;
	[_box3, _randomBox3] call fn_refillbox;
	_box3 allowDamage false;
	
	/*_Boxes4 = ["mission_Uniform","mission_DLCRifles","mission_DLCLMGs","mission_HVLaunchers","mission_ApexRifles"];
	_currBox4 = _Boxes4 call BIS_fnc_selectRandom;
	_box4 = createVehicle [_currBox4, _lastPos, [], 2, "None"];
	_box4 setDir random 360;
	_box4 allowDamage false;
	
	_Boxes5 = ["mission_Uniform","mission_DLCRifles","mission_DLCLMGs","mission_HVLaunchers","mission_ApexRifles"];
	_currBox5 = _Boxes5 call BIS_fnc_selectRandom;
	_box5 = createVehicle [_currBox5, _lastPos, [], 2, "None"];
	_box5 setDir random 360;
	_box5 allowDamage false;
	
	_Boxes6 = ["mission_Uniform","mission_DLCRifles","mission_DLCLMGs","mission_HVLaunchers","mission_ApexRifles"];
	_currBox6 = _Boxes6 call BIS_fnc_selectRandom;
	_box6 = createVehicle [_currBox6, _lastPos, [], 2, "None"];
	_box6 setDir random 360;
	_box6 allowDamage false; */
	

	{ _x setVariable ["R3F_LOG_disabled", false, true] } forEach [_box1, _box2];

	_successHintMessage = "The sky is clear again, the enemy Gunship was taken out! Ammo crates and LOTS of money have fallen near the pilot.";
};

_this call hostileairMissionProcessor;
