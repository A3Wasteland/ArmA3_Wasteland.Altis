//	@file Name: fn_addToPairs.sqf
//	@file Author: AgentRev

// This function is a 10x faster replacement for BIS_fnc_addToPairs,
// with no key type restriction (can be anything except array and nil/null),
// and no length restriction on sub-arrays ([key, value, ...])

private ["_arr", "_key", "_val", "_added", "_keyType", "_valType", "_x0", "_x1", "_x1Type"];

_arr = _this select 0;
_key = _this select 1;
_val = _this select 2;

_added = false;
_keyType = typeName _key;

if (_keyType != "ARRAY") then
{
	_valType = typeName _val;

	{
		if (typeName _x == "ARRAY" && {count _x > 0}) then
		{
			_x0 = _x select 0;

			if (!isNil "_x0" && {typeName _x0 == _keyType && {_x0 == _key}}) then
			{
				_x1 = if (count _x > 1) then { _x select 1 } else { nil };

				if (!isNil "_x1") then
				{
					_x1Type = typeName _x1;

					if (_x1Type == "ARRAY") then
					{
						if (_valType == _x1Type) then
						{
							{ _x1 set [count _x1, _x] } forEach _val;
						}
						else
						{
							_x1 set [count _x1, _val];
						};
					}
					else
					{
						if (_valType == "SCALAR" && _x1Type == _valType) then
						{
							_x1 = _x1 + _val;
						}
						else
						{
							if (_valType == "ARRAY") then
							{
								_x1 = [_x1];
								{ _x1 set [count _x1, _x] } forEach _val;
							}
							else
							{
								_x1 = [_x1, _val];
							};
						};

						_x set [1, _x1];
					};
				}
				else
				{
					_x set [1, _val];
				};

				_added = true;
			};
		};

		if (_added) exitWith {};
	} forEach _arr;

	if (!_added) then
	{
		_arr set [count _arr, [_key, _val]];
		_added = true;
	};
};

_added
