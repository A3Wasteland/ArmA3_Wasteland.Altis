//	@file Name: fn_startsWith.sqf
//	@file Author: AgentRev, Killzone_Kid

/*
	Parameters:
	_this select 0: String or Array - string(s) to search for
	_this select 1: String - string to check in
	_this select 2: Boolean - case sensitive search (optional, default: false)

	Returns: Boolean - test result
*/

private ["_needles", "_haystack", "_caseSensitive", "_checkMatch", "_found", "_testArray"];

_needles = [_this, 0, [], ["",[]]] call BIS_fnc_param;
_haystack = toArray ([_this, 1, "", [""]] call BIS_fnc_param);
_caseSensitive = [_this, 2, false, [false]] call BIS_fnc_param;

if (typeName _needles == "STRING") then
{
	_needles = [_needles];
};

_checkMatch = if (_caseSensitive) then {
	{_this in [toString _testArray]}
} else {
	{_this == toString _testArray}
};

_found = false;

{
	_testArray = +_haystack;
	_testArray resize count toArray _x;

	if (_x call _checkMatch) exitWith
	{
		_found = true;
	};
} forEach _needles;

_found
