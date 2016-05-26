// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: updateTerritoryMarkers.sqf
//	@file Author: AgentRev

#define MARKER_BRUSH_OWNER "Solid"
#define MARKER_BRUSH_OTHER "DiagGrid"

if (isNull player) exitWith
{
	private _thread = _this spawn
	{
		waitUntil {!isNull player};
		_this call A3W_fnc_updateTerritoryMarkers;
	};

	if (canSuspend) then { waitUntil {scriptDone _thread} };
	_thread
};

params [["_territories",[],[[]]], ["_ownerCheck",false,[false]], ["_team",sideUnknown,[sideUnknown,grpNull]], ["_isOwner",false,[false]]];

if (_team isEqualType grpNull && {(side _team) in [BLUFOR,OPFOR]}) then
{
	_team = side _team;
};

{
	if (_ownerCheck) then
	{
		_x params ["_marker", "_team"];

		if (_team in [playerSide, group player]) then
		{
			_marker setMarkerColorLocal ([_team, true] call A3W_fnc_getTeamMarkerColor);
			_marker setMarkerBrushLocal MARKER_BRUSH_OWNER;
		}
		else
		{
			_marker setMarkerColorLocal ([_team, false] call A3W_fnc_getTeamMarkerColor);
			_marker setMarkerBrushLocal MARKER_BRUSH_OTHER;
		};
	}
	else
	{
		_x params ["_marker"];

		if (_isOwner) then
		{
			_marker setMarkerColorLocal ([_team, true] call A3W_fnc_getTeamMarkerColor);
			_marker setMarkerBrushLocal MARKER_BRUSH_OWNER;
		}
		else
		{
			_marker setMarkerColorLocal ([_team, false] call A3W_fnc_getTeamMarkerColor);
			_marker setMarkerBrushLocal MARKER_BRUSH_OTHER;
		};
	};
} forEach _territories;
