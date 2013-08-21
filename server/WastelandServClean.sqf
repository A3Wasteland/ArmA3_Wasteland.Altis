// Based off AgentREV's cleanup
// runs every X minutes to cleanup dead bodies and clutterred items arround them
// if you set Death-time to 15 minutes (900 sec), after killing you got 15-19 minutes (depending on the interval) to get the loot from your kill
// you can change the intervals below, be aware to use SECONDS :)

private ["_delQtyP","_delQtyO","_runInt","_deathTime","_itemDistance"];

// configure cleanup below this line

_runInt = 300;		// Interval to run the cleanup (default: 300 = 5 minutes)
_deathTime = 600;	// Time a body has to have been dead before cleaning it up (default: 900 = 10 minutes)
_itemDistance = 20;	// the radius around the body (mtr) in which items will be searched for removal

// you should not change code below this line :)

while { true } do
{
	sleep _runInt;
	
	_delQtyP = 0;  // reset bodycount
	_delQtyO = 0;  // reset clutter count
	
	{
		if (local _x && {time - (_x getVariable ["processedDeath", time]) > _deathTime}) then
		{
			{
				deleteVehicle _x;
				_delQtyO = _delQtyO + 1;
			} forEach (nearestobjects [_x, ["Land_Sack_F", "Land_Basket_F", "Land_Bucket_F", "Land_Suitcase_F", "Land_CanisterFuel_F"], _itemDistance] );
			
			deleteVehicle _x;
			_delQtyP = _delQtyP + 1;
		};
	} forEach allDead;
	
	diag_log format ["SERVER CLEANUP: Deleted %1 bodies and removed %2 cluttered items", _delQtyP, _delQtyO];
	{
		if (count units _x == 0) then
		{
			deleteGroup _x;
		};
	} forEach allGroups;
};