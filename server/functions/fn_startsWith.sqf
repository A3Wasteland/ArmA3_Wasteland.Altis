//	@file Name: fn_startsWith.sqf
//	@file Author: AgentRev, Killzone_Kid

/*
	Parameters:
	_this select 0: String or Array - string(s) to search for
	_this select 1: String - string to check in
	_this select 2: Boolean - case sensitive search (optional, default: false)

	Returns: Boolean - test result
*/

private ["_needles", "_haystack", "_caseSensitive", "_found", "_testArray", "_testStr"];

_needles = [_this, 0, [], ["",[]]] call BIS_fnc_param;
_haystack = toArray ([_this, 1, "", [""]] call BIS_fnc_param);
_caseSensitive = [_this, 2, false, [false]] call BIS_fnc_param;

if (typeName _needles != "ARRAY") then
{
	_needles = [_needles];
};

_found = false;

{
	_testArray = +_haystack;
	_testArray resize count toArray _x;
	_testStr = toString _testArray;

	if (_x isEqualTo _testStr || (!_caseSensitive && _x == _testStr)) exitWith
	{
		_found = true;
	};
} forEach _needles;

_found
