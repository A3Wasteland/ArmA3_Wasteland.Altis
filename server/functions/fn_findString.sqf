//	@file Name: fn_findString.sqf
//	@file Author: AgentRev, Killzone_Kid

/*
	Parameters:
	_this select 0: String or Array - string(s) to search for
	_this select 1: String - string to check in
	_this select 2: Boolean - case sensitive search (optional, default: false)

	Returns: Number - first match position, -1 if not found
*/

private ["_needles", "_haystack", "_caseSensitive", "_hayLen", "_found", "_testArray", "_i", "_testStr"];

_needles = [_this, 0, [], ["",[]]] call BIS_fnc_param;
_haystack = toArray ([_this, 1, "", [""]] call BIS_fnc_param);
_caseSensitive = [_this, 2, false, [false]] call BIS_fnc_param;

if (typeName _needles != "ARRAY") then
{
	_needles = [_needles];
};

_hayLen = count _haystack;
_found = -1;
scopeName "fn_findString";

{
	_needleLen = count toArray _x;
	_testArray = +_haystack;
	_testArray resize _needleLen;

	for "_i" from _needleLen to _hayLen do
	{
		_testStr = toString _testArray;

		if (_x isEqualTo _testStr || (!_caseSensitive && _x == _testStr)) then
		{
			_found = _i - _needleLen;
			breakTo "fn_findString";
		};

		_testArray set [_needleLen, _haystack select _i];
		_testArray set [0, -1];
		_testArray = _testArray - [-1];
	};
} forEach _needles;

_found
