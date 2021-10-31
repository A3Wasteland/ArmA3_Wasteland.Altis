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

params [["_needles",[],["",[]]], ["_haystack","",[""]], ["_caseSensitive",false,[false]]];

if (_needles isEqualType "") exitWith
{
	if (_needles isEqualTo "") exitWith { false };

	if (_caseSensitive) then
	{
		_needles isEqualTo (_haystack select [0, count _needles])
	}
	else
	{
		_needles == (_haystack select [0, count _needles])
	}
};

if (_caseSensitive) then
{
	_needles findIf {_x isEqualTo (_haystack select [0, count _x])} != -1
}
else
{
	_needles findIf {_x == (_haystack select [0, count _x])} != -1
}
