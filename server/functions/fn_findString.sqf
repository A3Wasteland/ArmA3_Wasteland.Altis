/*
	File: findString.sqf
	Author: Mika Hannola, modified by AgentRev
	
	Description:
	Find a string within a string.
	
	Parameter(s):
	_this select 0: <string> strings to be found
	_this select 1: <string> string to search from
	_this select 2 (Optional): <boolean> search is case sensitive (default: false)
	
	Search is case insensitive
	
	Returns:
	Number (true when string is found).
	
	How to use:
	_found = [["string"], "String", true] call fn_findString;
*/

private ["_find", "_string", "_caseSensitive", "_finds", "_findArray", "_findArrayCount", "_found", "_stringArray", "_findCount", "_stringCount", "_maxPos", "_i", "_x", "_forEachIndex", "_currentPos"];

_find = [_this, 0, [], ["",[]]] call BIS_fnc_param;
_string = [_this, 1, "", [""]] call BIS_fnc_param;
_caseSensitive = [_this, 2, false, [false]] call BIS_fnc_param;

if (!_caseSensitive) then
{
	_string = toLower _string;
};

if (typeName _find == typeName "") then
{
	_find = [_find];
};

_finds = [];
_findCountMin = 0;

{
	_findArray = if (_caseSensitive) then { toArray _x } else { toArray toLower _x };
	_findArrayCount = count _findArray;
	
	if (_findArrayCount > 0) then
	{
		if (_findArrayCount < _findCountMin || _findCountMin == 0) then 
		{
			_findCountMin = _findArrayCount;
		};
		
		_finds set [count _finds, _findArray];
	};
	
} forEach _find;

_found = -1;
_stringArray = toArray _string;
_stringCount = count _stringArray;
_maxPos = _stringCount - _findCountMin;

scopeName "main";
for "_i" from 0 to _maxPos do
{
	{
		_found = _i;
			
		{
			_currentPos = _i + _forEachIndex;
			
			if (_currentPos >= _stringCount || {_x != _stringArray select _currentPos}) exitWith
			{
				_found = -1;
			};
		} forEach _x;
		
		if (_found != -1) then { breakTo "main" };
			
	} forEach _finds;
};

_found
