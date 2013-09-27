//	@file Version: 1.0
//	@file Name: staticHeliSpawning.sqf
//	@file Author: [404] Costlyy, AgentRev
//	@file Created: 20/12/2012 21:00
//	@file Description: Random static helis
//	@file Args:

if (!isServer) exitWith {};

private ["_countActual", "_heliSpawns", "_position", "_selectedMarker", "_markerName", "_marker", "_newPos", "_i", "_doSpawnWreck"];
_countActual = 0;

_heliSpawns = [];
{
	if (["heliSpawn_", _x] call fn_findString == 0) then
	{
		_heliSpawns set [count _heliSpawns, _x];
	};
} forEach allMapMarkers;

{
	_selectedMarker = _x;
	if (!(_selectedMarker in currentStaticHelis) && {random 1 < 0.50}) then // 50% chance spawning
    {
        _position = getMarkerPos _selectedMarker;
		[0, _position] call staticHeliCreation;
	    
		currentStaticHelis set [count currentStaticHelis, _selectedMarker];
	    
	    _countActual = _countActual + 1;
    };
} forEach _heliSpawns;

diag_log format["WASTELAND SERVER - %1 Static helis Spawned",_countActual];

/*
{diag_log format["Heli %1 = %2",_forEachIndex, _x];} forEach currentStaticHelis;
for "_i" from 1 to 24 do {
    _doSpawnWreck = true;
    
    { // Check if current iteration already exists as a live heli...
    	if (_i == _x) then {
			_doSpawnWreck = false;
        };
    } forEach currentStaticHelis;
    
    if (_doSpawnWreck) then {
    	_position = getMarkerPos format ["heliSpawn_%1", _i];
    	_newPos = [_position, 25, 50, 1, 0, 60 * (pi / 180), 0] call BIS_fnc_findSafePos;
		[1, _newPos] call staticHeliCreation;
        
    	_markerName = format["marker%1",_i];
		_marker = createMarker [_markerName, _newPos];
		_marker setMarkerType "dot";
		_marker setMarkerSize [1.25, 1.25];
		_marker setMarkerColor "ColorBlue";
    };
};
*/