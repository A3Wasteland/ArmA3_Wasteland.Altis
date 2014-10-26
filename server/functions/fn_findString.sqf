// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_findString.sqf
//	@file Author: AgentRev

/*
	Parameters:
	_this select 0: String or Array - string(s) to search for
	_this select 1: String - string to check in
	_this select 2: Boolean - case sensitive search (optional, default: false)

	Returns: Number - first match position, -1 if not found
*/

private ["_needles", "_haystack", "_caseSensitive", "_found"];

_needles = [_this, 0, [], ["",[]]] call BIS_fnc_param;
_haystack = [_this, 1, "", [""]] call BIS_fnc_param;
_caseSensitive = [_this, 2, false, [false]] call BIS_fnc_param;

if (typeName _needles != "ARRAY") then
{
	_needles = [_needles];
};

if (!_caseSensitive) then
{
	_haystack = toLower _haystack;
};

_found = -1;

{
	_found = _haystack find (if (_caseSensitive) then { _x } else { toLower _x });
	if (_found != -1) exitWith {};
} forEach _needles;

_found
