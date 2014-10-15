//	@file Version: 1.0
//	@file Name: leaveGroup.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19

_group = group player;
[_group getVariable ["currentTerritories", []], false, _group, false] call updateTerritoryMarkers;
[player] join grpNull;
