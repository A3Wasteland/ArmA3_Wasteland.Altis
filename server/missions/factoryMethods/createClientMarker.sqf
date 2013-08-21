//	@file Version: 1.0
//	@file Name: createClientMarker.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 26/1/2013 15:19

if(!isServer) exitwith {};

private["_markerName","_randomPos","_markerText"];

_markerName = _this select 0;
_randomPos = _this select 1;
_markerText = _this select 2;

clientMissionMarkers set [count clientMissionMarkers,[_markerName,_randomPos,_markerText]];
publicVariable "clientMissionMarkers";

if (!isDedicated) then
{
  [] spawn updateMissionsMarkers;
}; 