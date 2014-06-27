//	@file Name: WastelandServClean.sqf

// Based off AgentRev's cleanup
// runs every X minutes to cleanup items dropped on death over the map
// if you set Death-time to 15 minutes (900 sec), after killing you got 15-19 minutes (depending on the interval) to get the loot from your kill
// you can change the intervals below, be aware to use SECONDS :)

private ["_runInt", "_deathTime"];

// configure cleanup below this line

_runInt = 5*60;		// Interval to run the cleanup 
_deathTime = 30*60;	// Time an item has to have been dropped before cleaning it up

// corpse cleanup is managed by the "corpseRemoval" options in description.ext

while { true } do
{
	sleep _runInt;
	
	_delQtyO = 0;
	
	{
		if (diag_tickTime - (_x getVariable ["processedDeath", diag_tickTime]) >= _deathTime) then
		{
			deleteVehicle _x;
			_delQtyO = _delQtyO + 1;
		};
		sleep 0.01;
	} forEach entities "Thing";
	
	diag_log format ["SERVER CLEANUP: Deleted %1 expired objects", _delQtyO];
	
	_doNotDelete = [];
	
	{
		_team = _x select 2;
		
		if !(_team in _doNotDelete) then
		{
			[_doNotDelete, _team] call BIS_fnc_arrayPush;
		};
	} forEach currentTerritoryDetails;
	
	{
		if (count units _x == 0 && {!(_x in _doNotDelete)}) then
		{
			deleteGroup _x;
		};
	} forEach allGroups;
};
