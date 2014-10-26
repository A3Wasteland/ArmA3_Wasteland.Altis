// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_removeFromPairs.sqf
//	@file Author: AgentRev

scopeName "fn_removeFromPairs";
private ["_arr", "_key", "_removed", "_keyType", "_x0"];

_arr = _this select 0;
_key = _this select 1;

_removed = false;
_keyType = typeName _key;

if (_keyType != "ARRAY") then
{
	{
		if (typeName _x == "ARRAY") then
		{
			_x0 = _x select 0;

			if (!isNil "_x0" && {typeName _x0 == _keyType && {_x0 == _key}}) then
			{
				_arr deleteAt _forEachIndex;
				_removed = true;
				breakTo "fn_removeFromPairs";
			};
		};
	} forEach _arr;
};

_removed
