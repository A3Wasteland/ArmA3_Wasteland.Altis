// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_pairsToSQL.sqf
//	@file Author: AgentRev

#define FILTERED_CHARS [39,58] // single quote, colon

private ["_pairs", "_returnType", "_stringQuotes", "_returnArray", "_stringFormat", "_addSet", "_addRef", "_setValues", "_refValues", "_key", "_val", "_return"];
_pairs = _this select 0;
_returnType = if (count _this > 1) then { _this select 1 } else { 0 }; // 0 = return value format used for INSERT/UPDATE, 1 = return value format used for ON DUPLICATE KEY UPDATE, [0,1] = return both in an array
_stringQuotes = if (count _this > 2) then { _this select 2 } else { true }; // keep double-quotes around string values

_returnArray = (typeName _returnType == "ARRAY");

if (!_returnArray) then
{
	_returnType = [_returnType];
};

_stringFormat = if (_stringQuotes) then
{
	{ format ["'%1'", toString ((toArray str _val) - FILTERED_CHARS)] }
}
else
{
	{ format ["'%1'", toString ((toArray format ["%1", _val]) - FILTERED_CHARS)] }
};

_addSet = false;
_addRef = false;

{
	if (_x == 0) then { _addSet = true };
	if (_x == 1) then { _addRef = true };
} forEach _returnType;

_setValues = "";
_refValues = "";

{
	_key = _x select 0;

	if (_addSet) then
	{
		_val = _x select 1;

		if (typeName _val != "BOOL") then
		{
			_val = if (typeName _val == "SCALAR") then { _val call fn_numToStr } else _stringFormat;
		};

		_setValues = _setValues + format ["%1%2=%3", if (_setValues != "") then { "," } else { "" }, _key, _val];
	};
	if (_addRef) then
	{
		_refValues = _refValues + format ["%1%2=VALUES(%2)", if (_refValues != "") then { "," } else { "" }, _key];
	};
} forEach _pairs;

_return = [];

{
	if (_x == 0) then { _return set [_forEachIndex, _setValues] };
	if (_x == 1) then { _return set [_forEachIndex, _refValues] };
} forEach _returnType;

if (_returnArray) then { _return } else { _return select 0 }
