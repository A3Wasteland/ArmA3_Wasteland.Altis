//	@file Version: 1.0
//	@file Name: firstSpawn.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 28/12/2013 19:42

client_firstSpawn = true;
[] execVM "client\functions\welcomeMessage.sqf";

player addEventHandler ["Take",
{
	_vehicle = _this select 1;
	
	if (_vehicle isKindOf "Car" && {!(_vehicle getVariable ["itemTakenFromVehicle", false])}) then
	{
		_vehicle setVariable ["itemTakenFromVehicle", true, true];
	};
}];
 
_startTime = floor time;
_result = 0;

waitUntil
{ 
	_currTime = floor time;
	
	if (_currTime - _startTime >= 180) then 
	{
		_result = 1;    
	};
	
	(_result == 1)
};

if (playerSide in [west, east]) then
{
	if ({_x select 0 == getPlayerUID player} count pvar_teamSwitchList == 0) then
	{
		pvar_teamSwitchList set [count pvar_teamSwitchList, [getPlayerUID player, playerSide]];
		publicVariable "pvar_teamSwitchList";
		
		_side = "";
		
		if (playerSide == BLUFOR) then
		{
			_side = "BLUFOR"; 
		};
   
		if (playerSide == OPFOR) then
		{
			_side = "OPFOR"; 
		};
		
		titleText [format["You have been locked to %1",_side],"PLAIN",0];
	};
};
