// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: mission_HostileHelicopter.sqf
//	@file Author: JoSchaap, AgentRev

if (!isServer) exitwith {};
//#include "sideMissionDefines.sqf"

private ["_vehicleClass", "_vehicle", "_createVehicle", "_vehicles", "_leader", "_speedMode", "_waypoint", "_vehicleName", "_numWaypoints", "_box1", "_box2", "_callLocation", "_callLocationPos","_heliDirection","_heliDistance", "_flyHeight","_heliTypes"];

_heliDirection = random 360;
_heliDistance = 1000 + (random 2000);
_flyHeight = 100 + (random 300);

_callLocation = _this select 0;  //parameter passed from the missionProcessor which called for help, set as ai location when reinforcement was called
_callLocationPos = getMarkerPos _callLocation;
_callLocationPos = [(_callLocationPos select 0), (_callLocationPos select 1), _flyHeight]; //Change position of call to have proper heli height, goes into waypoints

_startPos = [(_callLocationPos select 0) + (sin _heliDirection) * _heliDistance, (_callLocationPos select 1) + (cos _heliDirection) * _heliDistance, _flyHeight];

//Use Random Weighting for Attack Heli type to reduce the likelihood of a Blackfoot or Kaj tearing up players
_heliTypes =[
	["B_Heli_Attack_01_F", .25],
	["O_Heli_Attack_02_black_F", .25],
	["B_Heli_Light_01_armed_F", 1],
	["O_Heli_Light_02_F", 1],
	["I_Heli_light_03_F", 1]
];

_vehicleClass =  (_heliTypes call generateMissionWeights) call fn_selectRandomWeighted;

_createVehicle =
{
	private ["_type", "_position", "_direction", "_vehicle", "_soldier"];

	_type = _this select 0;
	_position = _this select 1;
	_direction = _this select 2;

	_vehicle = createVehicle [_type, _position, [], 0, "FLY"];
	_vehicle setVariable ["R3F_LOG_disabled", true, true];
	[_vehicle] call vehicleSetup;

	_vehicle setDir _direction;
	_aiGroup2 addVehicle _vehicle;

	// add a driver/pilot/captain to the vehicle
	// the little bird, orca, and hellcat do not require gunners and should not have any passengers
	_soldier = [_aiGroup2, _position] call createRandomSoldierC;
	_soldier moveInDriver _vehicle;

	switch (true) do
	{
		case (_type isKindOf "Heli_Transport_01_base_F"):
		{
			// these choppers have 2 turrets so we need 2 gunners
			_soldier = [_aiGroup2, _position] call createRandomSoldierC;
			_soldier moveInTurret [_vehicle, [1]];

			_soldier = [_aiGroup2, _position] call createRandomSoldierC;
			_soldier moveInTurret [_vehicle, [2]];
		};

		case (_type isKindOf "Heli_Attack_01_base_F" || _type isKindOf "Heli_Attack_02_base_F"):
		{
			// these choppers need 1 gunner
			_soldier = [_aiGroup2, _position] call createRandomSoldierC;
			_soldier moveInGunner _vehicle;
		};
	};

	// remove flares because it overpowers AI choppers
	if (_type isKindOf "Air") then
	{
		{
			if (["CMFlare", _x] call fn_findString != -1) then
			{
				_vehicle removeMagazinesTurret [_x, [-1]];
			};
		} forEach getArray (configFile >> "CfgVehicles" >> _type >> "magazines");
	};

	[_vehicle, _aiGroup2] spawn checkMissionVehicleLock;
	_vehicle
};

_aiGroup2 = createGroup CIVILIAN;

_vehicle = [_vehicleClass, _startPos, 0] call _createVehicle;

_leader = effectiveCommander _vehicle;
_aiGroup2 selectLeader _leader;

_aiGroup2 setCombatMode "WHITE"; // Defensive behaviour
_aiGroup2 setBehaviour "AWARE";
_aiGroup2 setFormation "STAG COLUMN";

_speedMode = "FULL"; //speed them up to get there 

_aiGroup2 setSpeedMode _speedMode;

// behaviour on waypoints

//Waypoint 1 - Get to Trouble Location
	_waypoint = _aiGroup2 addWaypoint [_callLocationPos,0,1];
	_waypoint setWaypointType "MOVE";
	_waypoint setWaypointCompletionRadius 50;
	_waypoint setWaypointCombatMode "RED";
	_waypoint setWaypointBehaviour "COMBAT";
	_waypoint setWaypointFormation "STAG COLUMN";
	_waypoint setWaypointSpeed _speedMode;
	
//Waypoint 2 - Take Care of Business
	_waypoint2 = _aiGroup2 addWaypoint [_callLocationPos,0,2];
	_waypoint2 setWaypointType "SAD";
	_waypoint2 setWaypointCombatMode "RED";
	_waypoint2 setWaypointBehaviour "COMBAT";
	
[_callLocationPos] spawn {
	private["_targetPos"];
	_targetPos = _this select 0;
	_smoke1 = "SmokeShellRed" createVehicle _targetPos;
};	

_aiGroup2 //Returns the group to the calling processor to allow for it to be deleted
