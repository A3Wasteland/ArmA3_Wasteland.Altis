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

if (["A3W_combatAbortDelay", 0] call getPublicVar > 0) then
{
	player addEventHandler ["FiredNear", { combatTimestamp = diag_tickTime }];
	player addEventHandler ["HitPart",
	{
		_source = (_this select 0) select 1;
		if (!isNull _source && {_source != player}) then {
			combatTimestamp = diag_tickTime;
		};
	}];
};

_startTime = diag_tickTime;
waitUntil {sleep 1; diag_tickTime - _startTime >= 180};

if (playerSide in [BLUFOR,OPFOR]) then
{
	if ({_x select 0 == getPlayerUID player} count pvar_teamSwitchList == 0) then
	{
		pvar_teamSwitchList set [count pvar_teamSwitchList, [getPlayerUID player, playerSide]];
		publicVariable "pvar_teamSwitchList";
		
		_side = switch (playerSide) do
		{
			case BLUFOR: { "BLUFOR" };
			case OPFOR:  { "OPFOR" };
			default      { "" };
		};
		
		titleText [format["You have been locked to %1",_side],"PLAIN",0];
	};
};
