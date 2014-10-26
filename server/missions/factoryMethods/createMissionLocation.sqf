// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: createMissionLocation.sqf
//	@file Author: [404] Deadbeat, AgentRev
//	@file Created: 26/1/2013 15:19

if (!isServer) exitwith {};

private ["_validLocations", "_selectedMarker", "_markerIndex"];

_validLocations = [MissionSpawnMarkers, { !(_x select 1) }] call BIS_fnc_conditionalSelect;

_selectedMarker = (_validLocations call BIS_fnc_selectRandom) select 0;
_markerIndex = [MissionSpawnMarkers, _selectedMarker] call BIS_fnc_findInPairs;

(MissionSpawnMarkers select _markerIndex) set [1, true];

[markerPos _selectedMarker, _markerIndex]
