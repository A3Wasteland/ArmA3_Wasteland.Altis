// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_addToPairs.sqf
//	@file Author: AgentRev

// This function is a 10x faster replacement for BIS_fnc_addToPairs,
// with no key type restriction (can be anything except nil/null),
// and no length restriction on sub-arrays ([key, value, ...])

params ["_arr", "_key", "_val"];

private _index = [_arr, _key] call fn_findInPairs;

if (_index isEqualTo -1) exitWith
{
	_arr pushBack [_key, _val]
};

private _pair = _arr select _index;
private _target = _pair select 1;

if (isNil "_target") exitWith
{
	_pair set [1, _val];
	_index
};

if (_target isEqualType []) exitWith
{
	if (_val isEqualType []) then
	{
		_target append _val;
	}
	else
	{
		_target pushBack _val;
	};

	_index
};

if ([_target,_val] isEqualTypeAll 0) then
{
	_target = _target + _val;
}
else
{
	_target = [_target];

	if (_val isEqualType []) then
	{
		_target append _val;
	}
	else
	{
		_target pushBack _val;
	};
};

_pair set [1, _target];
_index
