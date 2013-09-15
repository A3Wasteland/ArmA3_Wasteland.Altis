//	@file Version: 1.0
//	@file Name: createWaitCondition.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 26/1/2013 15:19

if(!isServer) exitwith {};

private["_delayTime","_startTime","_running","_currTime"];

_delayTime = _this select 0;
_startTime = floor(time);
_running = true;

while {_running} do
{ 
    _currTime = floor(time);
    if(_currTime - _startTime >= _delayTime) then {_running = false;};
    sleep 1;
};