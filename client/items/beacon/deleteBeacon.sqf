// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Version: 1.0
//@file Name: deleteBeacon.sqf
//@file Author: LouD/Apoc
//@file Description: Delete a Spawn Beacon

_MaxSpawnbeacons = ceil (["A3W_maxSpawnBeacons", 5] call getPublicVar);
#define MAX_BEACONS format ["You cannot deploy more then %1 spawnbeacons.", [_MaxSpawnbeacons]]
_confirmMsg = MAX_BEACONS + format ["<br/>Press delete to remove a random spawnbeacon."];

_beacons = []; 
{ 
	if (_x getVariable ["ownerUID",""] == getPlayerUID player) then 
	{ 
		_beacons pushBack _x; 
	}; 
} forEach pvar_spawn_beacons; 

// Display confirm message
if ([parseText _confirmMsg, "DELETE BEACON", "Delete", true] call BIS_fnc_guiMessage) then
{
	_oldBeacon = _beacons select 0;

	pvar_spawn_beacons = pvar_spawn_beacons - [_oldBeacon];
	publicVariable "pvar_spawn_beacons";
	pvar_manualObjectDelete = [netId _oldBeacon, _oldBeacon getVariable "A3W_objectID"];
	publicVariableServer "pvar_manualObjectDelete";
	deleteVehicle _oldBeacon;
};