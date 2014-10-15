//	@file Name: WastelandServClean.sqf
//	@file Author: AgentRev, Wiking, JoSchaap

// runs every X minutes to cleanup items dropped on death over the map
// you can change the intervals below, be aware to use SECONDS :)

// configure cleanup below this line

#define CLEANUP_INTERVAL (5*60) // Interval to run the cleanup
#define ITEM_CLEANUP_TIME (15*60) // Dropped player items cleanup time
#define DEBRIS_CLEANUP_TIME (10*60) // Vehicle crash crater/debris cleanup time (actual vehicle wreck cleanup is handled through description.ext parameters)

// Corpse cleanup is handled through description.ext parameters


_cleanupCode =
{
	private ["_obj", "_isWreck", "_processedDeath", "_timeLimit"];
	_obj = _this select 0;
	_isWreck = if (count _this > 1) then { _this select 1 } else { false };

	_processedDeath = _obj getVariable ["processedDeath", 0];

	if (_isWreck) then
	{
		_timeLimit = DEBRIS_CLEANUP_TIME;

		if (_processedDeath == 0) then
		{
			_obj setVariable ["processedDeath", diag_tickTime];
		};
	}
	else
	{
		_timeLimit = ITEM_CLEANUP_TIME;
	};

	if (_processedDeath > 0 && diag_tickTime - _processedDeath >= ITEM_CLEANUP_TIME) then
	{
		deleteVehicle _x;
		_delQtyO = _delQtyO + 1;
	};

	sleep 0.01;
};

while { true } do
{
	sleep CLEANUP_INTERVAL;

	_delQtyO = 0;

	{ [_x] call _cleanupCode } forEach entities "All";
	{ { [_x, true] call _cleanupCode } forEach allMissionObjects _x } forEach ["CraterLong", "#destructioneffects"];

	diag_log format ["SERVER CLEANUP: Deleted %1 expired objects", _delQtyO];
};
