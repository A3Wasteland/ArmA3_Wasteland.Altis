// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: hideDisabledTerritories.sqf
//	@file Author: AgentRev, wiking (top-territory mod)

if (isServer) exitWith {};

//uses global variable current_territorygrp_rnd created by createCaptureTriggers.sqf
_territoryGroup = format ["Territory_%1",current_territorygrp_rnd];
_flagGroup = format ["Flag_%1",current_territorygrp_rnd];

{
	_marker = _x;

	if (["TERRITORY_", _marker] call fn_startsWith) then
	{
		if ({_x select 0 == _marker} count (["config_territory_markers", []] call getPublicVar) == 0) then
		{
			deleteMarkerLocal _marker;
		};
	};
	//markername starts with territory but not with current territory grp
	if ((["TERRITORY_", _marker] call fn_startsWith) && !([_territoryGroup, _marker] call fn_startsWith)) then
	{
			deleteMarkerLocal _marker;	
	};
	//markername starts with Flag_ but not with current random territory grp
	if ((["Flag_", _marker] call fn_startsWith) && !([_flagGroup, _marker] call fn_startsWith)) then
	{
			deleteMarkerLocal _marker;	
	};
	
	
} forEach allMapMarkers;
