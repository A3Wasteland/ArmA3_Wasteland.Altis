//	@file Version: 1.0
//	@file Name: init.sqf
//	@file Author: AgentRev
//	@file Created: 14/09/2013 19:36

private ["_vehicleManager", "_lastPos"];
_vehicleManager = compile preprocessFileLineNumbers "client\systems\fpsFix\vehicleManager.sqf";

_lastPos = [0,0,0];

while {true} do
{
	if (_lastPos distance player > 100) then
	{
		call _vehicleManager;
		_lastPos = getPos player;
		sleep 5;
	};
};
