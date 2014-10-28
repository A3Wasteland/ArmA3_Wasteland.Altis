// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
/*********************************************************#
# @@ScriptName: createCaptureTriggers.sqf
# @@Author: Nick 'Bewilderbeest' Ludlam <bewilder@recoil.org>, AgentRev, Lodac, wiking (top-territory mod)
# @@Create Date: 2013-09-15 16:26:38
# @@Modify Date: 2013-09-15 22:35:19
# @@Function: Creates server-side capture zone triggers
#*********************************************************/
_currentGroup = floor (random 5);
current_territorygrp_rnd = _currentGroup;
publicvariable "current_territorygrp_rnd";
_territoryGroup = format ["Territory_%1",_currentgroup];
_flagGroup = format ["Flag_%1",_currentgroup];
if (!isServer) exitWith {};

{
	_marker = _x;
	if ([_flagGroup, _marker] call fn_startsWith) then
	{
		diag_log format ["Creating Flag for '%1'", _marker];
	}
	else
	{
		if (["Flag_", _marker] call fn_startsWith) then
		{
			deleteMarker _marker;
		};
	};
	if ([_territoryGroup, _marker] call fn_startsWith) then
	{	
		if ({_x select 0 == _marker} count (["config_territory_markers", []] call getPublicVar) > 0) then
		{
			diag_log format ["Creating territory capture trigger for '%1'", _marker];
			_trig = createTrigger ["EmptyDetector", markerPos _marker];
			_trig setVariable ["captureTriggerMarker", _marker, true];
		}
		else
		{
			diag_log format ["WARNING: No config_territory_markers definition for marker '%1'. Deleting it!", _marker];
			deleteMarker _marker;
		};
	}
	else
	{
		if (["TERRITORY_", _marker] call fn_startsWith) then
		{
			deleteMarker _marker;
		};
	};
} forEach allMapMarkers;
