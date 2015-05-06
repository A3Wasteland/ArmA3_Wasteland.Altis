// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
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
		_onExit =
		("
			if (player getVariable ['TERRITORY_OCCUPATION', ''] == '" + _marker + "') then
			{
				player setVariable ['TERRITORY_OCCUPATION', '', true];
				player setVariable ['TERRITORY_ACTIVITY', []];
			};
		");

		_trig setTriggerArea [_markerSize select 0, _markerSize select 1, markerDir _marker, markerShape _marker == "RECTANGLE"];
		_trig setTriggerActivation ["ANY", "PRESENT", true];
		_trig setTriggerStatements ["(vehicle player) in thislist && (player call fn_getPos3D) select 2 <= 250", _onEnter, _onExit];
	};
} forEach allMissionObjects "EmptyDetector";
