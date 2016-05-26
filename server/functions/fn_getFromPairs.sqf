// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_getFromPairs.sqf
//	@file Author: AgentRev

// This function is a 2x faster replacement for BIS_fnc_getFromPairs,
// with no key type restriction (can be anything except nil/null),
// and no length restriction on sub-arrays ([key, value, ...])

params ["_arr", "_key", "_default"];

private _index = [_arr, _key] call fn_findInPairs;
private "_result";

if (_index != -1) then
{
	_result = (_arr select _index) select 1;
};

if (isNil "_result") then
{
	if (isNil "_default") then [{nil},{_default}]
}
else { _result }
