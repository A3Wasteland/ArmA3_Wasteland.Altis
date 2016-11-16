// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: mission_HostileJet.sqf
//	@file Author: JoSchaap, AgentRev
//  @file Edited by: CRE4MPIE

if (!isServer) exitwith {};
#include "sideMissionDefines.sqf"

private ["_vehicleClass", "_vehicle", "_createVehicle", "_vehicles", "_leader", "_speedMode", "_waypoint", "_vehicleName", "_numWaypoints", "_box1", "_box2"];

_setupVars =
{
	_missionType = "Hostile Jet";
	_locationsArray = nil; // locations are generated on the fly from towns
};

_setupObjects =
{
	_missionPos = markerPos (((call cityList) call BIS_fnc_selectRandom) select 0);

	_vehicleClass = if (missionDifficultyHard) then
	{
		["I_Plane_Fighter_03_AA_F", "I_Plane_Fighter_03_CAS_F", "B_Plane_CAS_01_F","O_Plane_CAS_02_F"] call BIS_fnc_selectRandom;
	}
	else
	{
		["I_Plane_Fighter_03_CAS_F","I_Plane_Fighter_03_AA_F"] call BIS_fnc_selectRandom;
	};

	_aiGroup = createGroup CIVILIAN;
	_createVehicle =
	{
		private ["_type", "_position", "_direction", "_vehicle", "_soldier"];

		_type = _this select 0;
		_position = _this select 1;
		_direction = _this select 2;
		
		_vehicle = createVehicle [_type, _position, [], 0, "FLY"];
		_vel = [velocity _vehicle, -(_direction)] call BIS_fnc_rotateVector2D;
		_vehicle setDir _direction;
		_vehicle setVelocity _vel; //added to make the vehicle fly
		_vehicle setVariable ["R3F_LOG_disabled", true, true];
		_aiGroup addVehicle _vehicle;
		
		// add the pilot
		_soldier = [_aiGroup, _position] call createRandomPilot;
		_soldier moveInDriver _vehicle;
		_vehicle
	};

	_vehicles = [];
	_vehicles set [0, [_vehicleClass,[1519.42,4970.67], 14, _aiGroup] call _createVehicle]; // static value update when porting to different maps
	
//	_vehicle set [0, [_vehicleClass,[1519.42,4970.67], 14, _aiGroup] call _createVehicle];

//	_leader = effectiveCommander _vehicle;
//	_aiGroup selectLeader _leader;

	_aiGroup setCombatMode "RED"; // Defensive behaviour
	_aiGroup setBehaviour "COMBAT";
	_aiGroup setFormation "STAG COLUMN";

//	_speedMode = if (missionDifficultyHard) then { "NORMAL" } else { "LIMITED" };

//	_aiGroup setSpeedMode _speedMode;

	// behaviour on waypoints
	{
		_waypoint = _aiGroup addWaypoint [markerPos (_x select 0), 0];
		_waypoint setWaypointType "SAD";
		_waypoint setWaypointCompletionRadius 50;
		_waypoint setWaypointCombatMode "RED";
		_waypoint setWaypointBehaviour "AWARE";
		_waypoint setWaypointFormation "STAG COLUMN";
		_waypoint setWaypointSpeed "NORMAL";
	} forEach ((call cityList) call BIS_fnc_arrayShuffle);

	_missionPos = getPosATL leader _aiGroup;

	_missionPicture = getText (configFile >> "CfgVehicles" >> _vehicleClass >> "picture");
	_vehicleName = getText (configFile >> "CfgVehicles" >> _vehicleClass >> "displayName");

	_missionHintText = format ["a <t color='%2'>%1</t> is patrolling the island. Intercept the pilot and recover his high value cargo! But be careful, he will target vehicles!.", _vehicleName, sideMissionColor];

	_numWaypoints = count waypoints _aiGroup;
};

_waitUntilMarkerPos = {getPosATL _leader};
_waitUntilExec = nil;
_waitUntilCondition = {currentWaypoint _aiGroup >= _numWaypoints};

_failedExec = nil;

// _vehicle is automatically deleted or unlocked in missionProcessor depending on the outcome

_successExec =
{
	// Mission completed
	_randomBox = ["mission_USLaunchers","mission_USSpecial","mission_Main_A3snipers","mission_TOP_Sniper","mission_TOP_Gear1","airdrop_DLC_Rifles","airdrop_DLC_LMGs","airdrop_Snipers"] call BIS_fnc_selectRandom;
_randomCase = ["Box_FIA_Support_F","Box_FIA_Wps_F","Box_FIA_Ammo_F","Box_NATO_WpsSpecial_F","Box_East_WpsSpecial_F","Box_NATO_Ammo_F","Box_East_Ammo_F"] call BIS_fnc_selectRandom;
	
	_box1 = createVehicle [_randomCase,_lastPos, [], 5, "None"];
	_box1 setDir random 360;
	[_box1, _randomBox] call fn_refillbox;
	// Mission completed

	_randomBox = ["mission_USLaunchers","mission_USSpecial","mission_Main_A3snipers","mission_TOP_Sniper","mission_TOP_Gear1","airdrop_DLC_Rifles","airdrop_DLC_LMGs","airdrop_Snipers"] call BIS_fnc_selectRandom;
_randomCase = ["Box_FIA_Support_F","Box_FIA_Wps_F","Box_FIA_Ammo_F","Box_NATO_WpsSpecial_F","Box_East_WpsSpecial_F","Box_NATO_Ammo_F","Box_East_Ammo_F"] call BIS_fnc_selectRandom;
	
	_box2 = createVehicle [_randomCase,_lastPos, [], 5, "None"];
	_box2 setDir random 360;
	[_box2, _randomBox] call fn_refillbox;

	{ _x setVariable ["R3F_LOG_disabled", false, true] } forEach [_box1,_box2];
	
	_vehicle setVariable ["R3F_LOG_disabled", false, true];



	_successHintMessage = "The sky is clear again, the enemy Jet was taken out! High Value Ammo crates have fallen near the wreck.";
};

_this call sideMissionProcessor;
