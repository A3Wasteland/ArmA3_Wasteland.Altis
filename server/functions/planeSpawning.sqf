//	@file Version: 1.0
//	@file Name: planeSpawning.sqf
//	@file Author: AgentRev
//	@file Created: 21/09/2013 17:13
//	@file Args:

if (!isServer) exitWith {};

private ["_planeSpawns", "_counter"];

_planeSpawns = [];
{
	if (["planeSpawn_", _x] call fn_findString == 0) then
	{
		_planeSpawns set [count _planeSpawns, _x];
	};
} forEach allMapMarkers;

_counter = 0;
{
	if (random 1 < 0.5) then // 50% chance spawning
	{
		[getMarkerPos _x, markerDir _x] call planeCreation;
		_counter = _counter + 1;
	};
} forEach _planeSpawns;

diag_log format["WASTELAND SERVER - %1 Planes Spawned",_counter];
