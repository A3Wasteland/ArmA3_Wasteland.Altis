/*********************************************************#
# @@ScriptName: setupCaptureTriggers.sqf
# @@Author: Nick 'Bewilderbeest' Ludlam <bewilder@recoil.org>, AgentRev
# @@Create Date: 2013-09-15 16:26:38
# @@Modify Date: 2013-09-15 22:35:19
# @@Function: Setup capture zone triggers
#*********************************************************/

if (!hasInterface) exitWith {};

{
	_trig = _x;
	_marker = _trig getVariable ["captureTriggerMarker", ""];

	if (_marker != "") then
	{
		_markerSize = markerSize _marker;
		_onEnter = format ["player setVariable ['TERRITORY_OCCUPATION', '%1', true]", _marker];
		_onExit = "player setVariable ['TERRITORY_OCCUPATION', '', true]; player setVariable ['TERRITORY_ACTIVITY', [], true]";

		_trig setTriggerArea [_markerSize select 0, _markerSize select 1, markerDir _marker, true];
		_trig setTriggerActivation ["ANY", "PRESENT", true];
		_trig setTriggerStatements ["(vehicle player) in thislist", _onEnter, _onExit];
	};
} forEach allMissionObjects "EmptyDetector";
