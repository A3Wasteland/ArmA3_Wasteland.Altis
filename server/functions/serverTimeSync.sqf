//	@file Version: 1.0
//	@file Name: serverTimeSync.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19

if(!X_Server) exitWith {};
#include "setup.sqf"

_dateStamp = Date;
currentDate = _dateStamp;
publicVariable "currentDate";
private ["_startTime"];

#ifdef __A2NET__
_startTime = netTime;
#else
_startTime = time;
#endif

while{true} do
{	
	#ifdef __A2NET__
	if(netTime - _startTime > 900) then
	#else
	if(time - _startTime > 900) then  
	#endif
    {
    	_dateStamp = Date;
        _dateStamp set [4, _dateStamp select 4];
        setDate _dateStamp;
        currentDate = _dateStamp;
		publicVariable "currentDate";
		#ifdef __A2NET__
		_startTime = netTime;
		#else
		_startTime = time;    
		#endif	
    };
	sleep 10;
};