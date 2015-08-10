// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
/*
	File: fn_sortAlphabetically.sqf
	Author: Karel Moricky
	Modified by: AgentRev

	Description:
	Sort an array of anything alphabetically

	Parameter(s):
		0: ARRAY of anything
		1: CODE returning STRING if array element "_x" is not a STRING (optional)

	Returns:
	ARRAY of anything
*/

#define CONTROL	((findDisplay 0) displayCtrl 1555)

private ["_array", "_objCode", "_isStr", "_i"];
_array = param [0, [], [[]]];
_objCode = param [1, {}, [{}]];

lbClear CONTROL;

{
	_isStr = (typeName _x == "STRING");
	_i = CONTROL lbAdd (if (_isStr) then { _x } else { call _objCode });
	CONTROL lbSetValue [_i, _forEachIndex];
} forEach _array;

lbSort CONTROL;
_output = [];

for "_i" from 0 to (lbSize CONTROL - 1) do
{
	_output pushBack (_array select (CONTROL lbValue _i));
};

lbClear CONTROL;
_output
