// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: WastelandServClean.sqf
//	@file Author: AgentRev, Wiking, JoSchaap

// runs every X minutes to cleanup items dropped on death over the map
// you can change the intervals below, be aware to use SECONDS :)

if (!isServer) exitWith {};

// configure cleanup below this line

#define CLEANUP_INTERVAL (5*60) // Interval to run the cleanup
#define ITEM_CLEANUP_TIME (30*60) // Dropped player items cleanup time
#define DEBRIS_CLEANUP_TIME (10*60) // Vehicle crash crater/debris cleanup time (actual vehicle wreck cleanup is handled through description.ext parameters)
#define GROUP_CLEANUP_TIME (1*60) // How long a group must have been empty before deleting it

// Corpse cleanup is handled through description.ext parameters

_objCleanup =
{
	_obj = _this select 0;
	_isWreck = if (count _this > 1) then { _this select 1 } else { false };
	_processedDeath = _obj getVariable ["processedDeath", 0];
	_timeLimit = ITEM_CLEANUP_TIME;

	if (_isWreck) then
	{
		_timeLimit = DEBRIS_CLEANUP_TIME;

		if (_processedDeath == 0) then
		{
			_obj setVariable ["processedDeath", diag_tickTime];
		};
	};

	if (_processedDeath > 0 && diag_tickTime - _processedDeath >= _timeLimit) then
	{
		deleteVehicle _obj;
		_delQtyO = _delQtyO + 1;
	};

	sleep 0.01;
};

while {true} do
{
	uiSleep CLEANUP_INTERVAL;

	_delQtyO = 0;

	{ [_x] call _objCleanup } forEach entities "All";
	{ { [_x, true] call _objCleanup } forEach allMissionObjects _x } forEach ["CraterLong", "#destructioneffects"];

	diag_log format ["SERVER CLEANUP: Deleted %1 expired objects", _delQtyO];

	_delQtyG = 0;

	{
		_grp = _x;
		_processedDeath = _grp getVariable ["processedDeath", 0];

		if (count units _grp == 0) then
		{
			if (_processedDeath > 0) then
			{
				if (diag_tickTime - _processedDeath >= GROUP_CLEANUP_TIME) then
				{
					if (local _grp) then
					{
						deleteGroup _grp;
					}
					else
					{
						pvar_deleteEmptyGroup = _grp;
						publicVariable "pvar_deleteEmptyGroup";
					};

					_delQtyG = _delQtyG + 1;
				};
			}
			else
			{
				_grp setVariable ["processedDeath", diag_tickTime];
			};
		}
		else
		{
			if (_processedDeath != 0) then
			{
				_grp setVariable ["processedDeath", nil];
			};
		};

		sleep 0.01;
	} forEach allGroups;

	diag_log format ["SERVER CLEANUP: Deleted %1 empty groups", _delQtyG];
};
