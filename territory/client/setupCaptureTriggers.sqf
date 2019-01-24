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

_warningIcons = ["A3W_territoryWarningIcons"] call isConfigOn;

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

		if (_warningIcons) then
		{
			_warnMark = createMarkerLocal [_marker + "_warn", markerPos _marker];
			_warnMark setMarkerAlphaLocal 0;
			_warnMark setMarkerShapeLocal "ICON";
			_warnMark setMarkerTypeLocal "mil_warning";
			_warnMark setMarkerColorLocal "ColorOrange";
			_warnMark setMarkerSizeLocal [0.8, 0.8];

			_onEnter = format ["'%1' setMarkerAlphaLocal 1", _warnMark];
			_onExit = format ["'%1' setMarkerAlphaLocal 0", _warnMark];

			_warnTrig = createTrigger ["EmptyDetector", markerPos _marker, false];
			_warnTrig setTriggerArea [_markerSize select 0, _markerSize select 1, markerDir _marker, markerShape _marker == "RECTANGLE"];
			_warnTrig setTriggerActivation ["ANYPLAYER", "PRESENT", true];
			_warnTrig setTriggerStatements [format ["_ownerTeam = missionNamespace getVariable ['%1_team', sideUnknown]; _friendlyTerr = if (_ownerTeam isEqualType sideUnknown) then { _ownerTeam == playerSide } else { [_ownerTeam, player] call A3W_fnc_isFriendly }; _friendlyTerr && {thisList findIf {isPlayer _x && {!([_x, player] call A3W_fnc_isFriendly) && (_x modelToWorld [0,0,0]) select 2 <= 250}} != -1}", _marker], _onEnter, _onExit];
		};
	};
} forEach allMissionObjects "EmptyDetector";
