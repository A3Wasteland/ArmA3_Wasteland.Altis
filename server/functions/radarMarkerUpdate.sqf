//	@file Version: 1.0
//	@file Name: radarMarkerUpdate.sqf
//	@file Author: [404] Costlyy
//	@file Created: 08/12/2012 15:19
//	@file Args: [int(key)]

if(!X_Server) exitWith {};

private["_uniqueID", "_radarStationPos", "_playerSide", "_markerState", "_enemyCount", "_friendlyCount", "_currSide", "_runLoop", "_stillAlive"];

_uniqueID = _this select 0;
_radarStationPos = _this select 1;
_playerSide = _this select 2;
_markerState = _this select 3;

_runLoop = true;
while {_runLoop} do {
	_stillAlive = false;

	// find state
    _enemyCount = 0;
    _friendlyCount = 0; 
 	{          
        _currSide = side _x; 
        
    	if ((isPlayer _x) AND (str(_currSide) == _playerSide) AND _x distance _radarStationPos < 350) then {
            _friendlyCount = _friendlyCount + 1;
        };
        if ((isPlayer _x) AND (str(_currSide) != _playerSide) AND _x distance _radarStationPos < 350) then {
        	_enemyCount = _enemyCount + 1;
        };                                   
    }forEach playableUnits;
    
    if(_friendlyCount == 0 AND _enemyCount == 0 ) then {
    	_markerState = 0; // default - nothing
    };
    if(_friendlyCount > 0) then {
    	_markerState = 1; // Friendly NO enemy
    };
    if(_enemyCount > 0) then {
    	_markerState = 2; // Enemy NO friendly
    };
    if(_enemyCount > 0 AND _friendlyCount > 0) then {
    	_markerState = 3; // Enemy AND friendly
    };

   	{
    	if(_x select 0 == _uniqueID) then {
        	_stillAlive = true;
            
            // delete current marker from server
            clientRadarMarkers set [_forEachIndex, "REMOVETHISCRAP"];
			clientRadarMarkers = clientRadarMarkers - ["REMOVETHISCRAP"]; 
              
            // put updated marker in with updated state
			clientRadarMarkers set [count clientRadarMarkers,[_uniqueID,_radarStationPos,_playerSide, _markerState]];
			publicVariable "clientRadarMarkers"; 
        };
    }forEach clientRadarMarkers;

	if (!_stillAlive) exitWith {_runLoop = false;};
    sleep 3;
};