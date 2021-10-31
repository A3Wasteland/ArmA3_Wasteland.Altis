// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_findInPairs.sqf
//	@file Author: AgentRev

// This function is a 2x faster replacement for BIS_fnc_findInPairs,
// with no key type restriction (can be anything except nil/null),
// and no length restriction on sub-arrays ([key, value, ...])

params ["_arr", "_key"];

private "_x0";
private _equalsKey = [{_x0 isEqualType _key && {_x0 == _key}}, {_x0 isEqualTo _key}] select (_key isEqualTypeAny [0,[],false]);

_arr findIf {_x isEqualType [] && {_x0 = _x select 0; !isNil "_x0" && _equalsKey}}
