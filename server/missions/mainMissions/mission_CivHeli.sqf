//	@file Version: 1.0
//	@file Name: mission_CivHeli.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, AgentRev
//	@file Created: 08/12/2012 15:19
//	@file Args:

if(!isServer) exitwith {};
#include "mainMissionDefines.sqf"

private ["_missionMarkerName","_missionType","_vehicleClass","_missionRunning","_noSquads","_randomPos","_randomIndex"];

//Get Mission Location
_returnData = call createMissionLocation;
_randomPos = _returnData select 0;
_randomIndex = _returnData select 1;

//Mission Initialization.
_missionMarkerName = "CivHeli_Marker";
_missionType = "Civilian Helicopter";
_noSquads = 2;
_vehicleClass = ["B_Heli_Light_01_F", "I_Heli_Transport_02_F", "O_Heli_Light_02_unarmed_F"] call BIS_fnc_selectRandom;


_missionRunning = [_noSquads, _missionMarkerName, _missionType, _vehicleClass, _randomPos] spawn mission_WithVehicle;
waitUntil{sleep 0.1; scriptDone _missionRunning};
//Reset Mission Spot.
MissionSpawnMarkers select _randomIndex set[1, false];
[_missionMarkerName] call deleteClientMarker;

