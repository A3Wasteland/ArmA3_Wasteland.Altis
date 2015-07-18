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

_needles = param [0, [], ["",[]]];
_haystack = param [1, "", [""]];
_caseSensitive = param [2, false, [false]];

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
