// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: hideDisabledTerritories.sqf
//	@file Author: AgentRev

if (isServer) exitWith {};

{
	_marker = _x;

	if (["TERRITORY_", _marker] call fn_startsWith) then
	{
		if ({_x select 0 == _marker} count (["config_territory_markers", []] call getPublicVar) == 0) then
		{
			deleteMarkerLocal _marker;
		};
	};
} forEach allMapMarkers;
