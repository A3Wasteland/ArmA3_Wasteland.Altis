//	@file Version: 1.0
//	@file Name: deleteClientMarker.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 26/1/2013 15:19

if(!isServer) exitwith {};

private["_markerName"];

_markerName = _this select 0;

//Remove marker from client marker array.
{
    if(_x select 0 == _markerName) then
    {
    	clientMissionMarkers set [_forEachIndex, "REMOVETHISCRAP"];
		clientMissionMarkers = clientMissionMarkers - ["REMOVETHISCRAP"];
        publicVariable "clientMissionMarkers";    
    };
}forEach clientMissionMarkers;