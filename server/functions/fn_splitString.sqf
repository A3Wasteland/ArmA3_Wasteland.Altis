// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
/*
	File: fn_splitString.sqf
	Author: Karel Moricky
	Modified by AgentRev to not remove empty strings (e.g. expected behavior of any split function)

	Description:
	Split spring according to given separators

	Parameter(s):
		1: STRING - affected string
		2: STRING - one or more separators

	Returns:
	ARRAY of STRINGs
*/
private["_string","_separator","_stringArray","_separatorArray","_resultArray","_localArray"];

_string = param [0,"",[""]];
_separator = param [1,"",[""]];

_stringArray = toarray _string;
_separatorArray = toarray _separator;

_resultArray = [];
_localArray = [];
{
	if (_x in _separatorArray) then {
		_resultArray pushBack tostring _localArray;
		_localArray = [];
	} else {
		_localArray pushBack _x;
	};
} foreach _stringArray;

_resultArray pushBack toString _localArray;
// _resultArray = _resultArray - [""];
_resultArray
