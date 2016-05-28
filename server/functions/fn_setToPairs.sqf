// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_setToPairs.sqf
//	@file Author: AgentRev

// This function is a 3x faster replacement for BIS_fnc_setToPairs,
// with no key type restriction (can be anything except nil/null),
// and no length restriction on sub-arrays ([key, value, ...])

params ["_arr", "_key", "_val"];

private _index = [_arr, _key] call fn_findInPairs;

if (_index isEqualTo -1) then
{
	_arr pushBack [_key, _val];
}
else
{
	(_arr select _index) set [1, _val];
};

true
