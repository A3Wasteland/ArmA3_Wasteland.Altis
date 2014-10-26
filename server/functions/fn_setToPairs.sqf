// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_setToPairs.sqf
//	@file Author: AgentRev

// This function is a 3x faster replacement for BIS_fnc_setToPairs,
// with no key type restriction (can be anything except array and nil/null),
// and no length restriction on sub-arrays ([key, value, ...])

scopeName "fn_setToPairs";
private ["_arr", "_key", "_val", "_added", "_keyType", "_valType", "_x0"];

_arr = _this select 0;
_key = _this select 1;
_val = _this select 2;

_added = false;
_keyType = typeName _key;

if (_keyType != "ARRAY") then
{
	_valType = typeName _val;

	{
		if (typeName _x == "ARRAY") then
		{
			_x0 = _x select 0;

			if (!isNil "_x0" && {typeName _x0 == _keyType && {_x0 == _key}}) then
			{
				_x set [1, _val];
				_added = true;
				breakTo "fn_setToPairs";
			};
		};
	} forEach _arr;

	if (!_added) then
	{
		_arr pushBack [_key, _val];
		_added = true;
	};
};

_added
