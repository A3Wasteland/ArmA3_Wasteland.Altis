//	@file Name: worldMissionController.sqf

if (!isServer) exitWith {};

//waitUntil{sleep 1; staticGunSpawningComplete};
diag_log "WASTELAND SERVER - Started Mission State";

//Main Mission Array
_MMarray = [];

worldMissionRunning = false;
_startTime = floor(time);
_result = 0;

while {true} do
{
    _currTime = floor(time);
	if(_currTime - _startTime >= 2400) then {_result = 1;};
    
    if(_result == 1) then
    {
    	worldMissionRunning = false;    
    };
    
	if(!worldMissionRunning) then
    {
        sleep 120;
        _mission = _MMarray select (random (count _MMarray - 1));
        execVM format ["server\missions\otherMissions\%1.sqf",_mission];
		worldMissionRunning = true;
        diag_log format["WASTELAND SERVER - Execute New Mission"];
		_startTime = floor(time);
        _result = 0;
    } else {
    	sleep 1;  
    };    
};
