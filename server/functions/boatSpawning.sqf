//	@file Version: 1.1
//	@file Name: boatSpawning.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, AgentRev
//	@file Created: 20/11/2012 05:19
//	@file Args:

if (!isServer) exitWith {};

private ["_boatSpawns", "_counter"];

_boatSpawns = [];
{
	if (["boatSpawn_", _x] call fn_findString == 0) then
	{
		_boatSpawns set [count _boatSpawns, _x];
	};
} forEach allMapMarkers;

_counter = 0;
{
	if (random 1 < 0.75) then // 75% chance spawning
	{
		[getMarkerPos _x] call boatCreation;
		_counter = _counter + 1;
	};
} forEach _boatSpawns;

diag_log format["WASTELAND SERVER - %1 Boats Spawned",_counter];
