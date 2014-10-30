// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
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
_haystack = [_this, 1, "", [""]] call BIS_fnc_param;
_caseSensitive = [_this, 2, false, [false]] call BIS_fnc_param;

if (typeName _needles != "ARRAY") then
{
	_needles = [_needles];
};

_found = false;

if (_caseSensitive) then
{
	{
		if (_x != "" && _x isEqualTo (_haystack select [0, count _x])) exitWith
		{
			_found = true;
		};
	} forEach _needles;
}
else
{
	{
		if (_x != "" && _x == (_haystack select [0, count _x])) exitWith
		{
			_found = true;
		};
	} forEach _needles;
};

_found
