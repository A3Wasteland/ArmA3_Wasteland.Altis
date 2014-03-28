//	@file Name: WastelandServClean.sqf

// Based off AgentRev's cleanup
// runs every X minutes to cleanup dead bodies and clutterred items arround them
// if you set Death-time to 15 minutes (900 sec), after killing you got 15-19 minutes (depending on the interval) to get the loot from your kill
// you can change the intervals below, be aware to use SECONDS :)

private ["_runInt", "_deathTime"];

// configure cleanup below this line

_runInt = 5*60;		// Interval to run the cleanup 
_deathTime = 15*60;	// Time a body has to have been dead before cleaning it up

// you should not change code below this line :)

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
	} forEach entities "All";
	
	diag_log format ["SERVER CLEANUP: Deleted %1 expired objects", _delQtyO];
	
	{
		if (count units _x == 0) then
		{
			deleteGroup _x;
		};
	} forEach allGroups;
};
