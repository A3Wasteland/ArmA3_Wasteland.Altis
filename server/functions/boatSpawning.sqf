// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.1
//	@file Name: boatSpawning.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, AgentRev
//	@file Created: 20/11/2012 05:19
//	@file Args:

if (!isServer) exitWith {};

private "_counter";
_counter = 0;

{
	if (["boatSpawn_", _x] call fn_startsWith) then
	{
		if (random 1 < 0.75) then // 75% chance spawning
		{
			[markerPos _x] call boatCreation;
			_counter = _counter + 1;
		};
	};
} forEach allMapMarkers;

diag_log format["WASTELAND SERVER - %1 Boats Spawned",_counter];
