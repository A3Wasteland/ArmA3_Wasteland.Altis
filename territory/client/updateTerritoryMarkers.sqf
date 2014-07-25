//	@file Name: updateTerritoryMarkers.sqf
//	@file Author: AgentRev

#define MARKER_BRUSH_OWNER "Solid"
#define MARKER_BRUSH_OTHER "DiagGrid"

private ["_territories", "_ownerCheck", "_isOwner", "_getTeamMarkerColor", "_marker", "_team", "_playerTeam"];

_territories = _this select 0;
_ownerCheck = [_this, 1, false, [false]] call BIS_fnc_param;
_team = [_this, 2, sideUnknown, [sideUnknown,grpNull]] call BIS_fnc_param;
_isOwner = [_this, 3, false, [false]] call BIS_fnc_param;

_getTeamMarkerColor = if (isNil "getTeamMarkerColor") then
{
	compile preprocessFileLineNumbers "territory\client\getTeamMarkerColor.sqf";
}
else
{
	getTeamMarkerColor
};

if (isNull player) then
{
	waitUntil {!isNull player};
};

{
	if (_ownerCheck) then
	{
		_marker = _x select 0;
		_team = _x select 1;
		_playerTeam = if (typeName _team == "GROUP") then { group player } else { playerSide };

		if (_team == _playerTeam) then
		{
			_marker setMarkerColorLocal ([_team, true] call _getTeamMarkerColor);
			_marker setMarkerBrushLocal MARKER_BRUSH_OWNER;
		}
		else
		{
			_marker setMarkerColorLocal ([_team, false] call _getTeamMarkerColor);
			_marker setMarkerBrushLocal MARKER_BRUSH_OTHER;
		};
	}
	else
	{
		_marker = _x;

		if (_isOwner) then
		{
			_marker setMarkerColorLocal ([_team, true] call _getTeamMarkerColor);
			_marker setMarkerBrushLocal MARKER_BRUSH_OWNER;
		}
		else
		{
			_marker setMarkerColorLocal ([_team, false] call _getTeamMarkerColor);
			_marker setMarkerBrushLocal MARKER_BRUSH_OTHER;
		};
	};
} forEach _territories;
