//	@file Version: 1.0
//	@file Name: createWaitCondition.sqf
//	@file Author: [404] Deadbeat, AgentRev
//	@file Created: 26/1/2013 15:19

if (!isServer) exitwith {};

private ["_delayTime", "_startTime"];

_delayTime = _this select 0;
_startTime = diag_tickTime;

waitUntil
{
	sleep 5;
    (diag_tickTime - _startTime >= _delayTime)
};
