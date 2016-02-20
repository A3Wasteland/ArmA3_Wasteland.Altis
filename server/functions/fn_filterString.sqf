// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
/*
	Author: Karel Moricky

	Description:
	Removes characters from a string based on the list of allowed characters.

	Parameter(s):
	_this select 0: STRING - Filtered text
	_this select 1 (Optional): STRING - Filter (default: A-Z, a-z, 0-9 and "_")

	Returns:
	STRING
*/

private ["_text","_filter","_textArray","_filterArray"];
_text = param [0,"",[""]];
_filter = param [1,"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_",[""]];

_textArray = toarray _text;
_filterArray = toarray _filter;
{
	if !(_x in _filterArray) then {
		_textArray set [_foreachindex,-1];
	};
} foreach _textArray;
_textArray = _textArray - [-1];
tostring _textArray
