// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: createMissionMarker.sqf
//	@file Author: AgentRev

private ["_text", "_pos", "_marker"];

_text = _this select 0;
_pos = _this select 1;

_marker = format ["mission_%1_%2", [_text] call fn_filterString, call A3W_fnc_generateKey];

_marker = createMarker [_marker, _pos];
_marker setMarkerType "mil_destroy";
_marker setMarkerSize [1.25, 1.25];
_marker setMarkerColor "ColorRed";
_marker setMarkerText _text;

_marker
