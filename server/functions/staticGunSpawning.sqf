//	@file Version: 1.0
//	@file Name: vehicleTestSpawn.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy
//	@file Created: 20/11/2012 05:19
//	@file Args:

if(!X_Server) exitWith {};

private ["_counter","_pos","_markerName","_marker","_hint","_newpos"];
_counter = 0;

for "_i" from 1 to 770 step 20 do
{
	_pos = getMarkerPos format ["Spawn_%1", _i];
    _newpos = [_pos, 25, 50, 1, 0, 60 * (pi / 180), 0] call BIS_fnc_findSafePos;
	[_newpos] call staticGunCreation;
    _counter = _counter + 1;
};

diag_log format["WASTELAND SERVER - %1 Static Guns Spawned",_counter];