//	@file Version: 1.0
//	@file Name: mission_APC.sqf
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
_missionMarkerName = "APC_Marker";
_noSquads = 2;
_vehicleClass = ["B_APC_Wheeled_01_cannon_F", "B_APC_Tracked_01_rcws_F", "O_APC_Wheeled_02_rcws_F", "O_APC_Tracked_02_cannon_F", "I_APC_Wheeled_03_cannon_F"] call BIS_fnc_selectRandom;

if (_vehicleClass isKindOf "Tank_F") then
{
	_missionType = "Infantry Fighting Vehicle";
}
else
{
	_missionType = "Armored Personnel Carrier";
};

_missionRunning = [_noSquads, _missionMarkerName, _missionType, _vehicleClass, _randomPos] spawn mission_WithVehicle;
waitUntil{sleep 0.1; scriptDone _missionRunning};
//Reset Mission Spot.
MissionSpawnMarkers select _randomIndex set[1, false];
[_missionMarkerName] call deleteClientMarker;

