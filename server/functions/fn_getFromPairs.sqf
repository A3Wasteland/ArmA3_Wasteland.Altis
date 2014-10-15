//	@file Name: fn_getFromPairs.sqf
//	@file Author: AgentRev

// This function is a 2x faster replacement for BIS_fnc_getFromPairs,
// with no key type restriction (can be anything except array and nil/null),
// and no length restriction on sub-arrays ([key, value, ...])

private ["_arr", "_key", "_default", "_keyType", "_x0", "_x1"];

_arr = _this select 0;
_key = _this select 1;
_default = if (count _this > 2) then { _this select 2 } else { nil };

_keyType = typeName _key;

if (_keyType != "ARRAY") then
{
	{
		if (typeName _x == "ARRAY" && {count _x > 1}) then
		{
			_x0 = _x select 0;

			if (!isNil "_x0" && {typeName _x0 == _keyType && {_x0 == _key}}) then
			{
				_x1 = _x select 1;
			};
		};
	} forEach _arr;
};

if (isNil "_x1") then
{
	if (isNil "_default") then { nil } else { _default }
}
else
{
	_x1
}
