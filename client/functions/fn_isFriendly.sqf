// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_isFriendly.sqf
//	@file Author: AgentRev

params ["_unit1", "_unit2"];
private ["_group1", "_group2", "_side1", "_side2"];

_group1 = if (_unit1 isEqualType grpNull) then { _unit1 } else { group _unit1 };
_group2 = if (_unit2 isEqualType grpNull) then { _unit2 } else { group _unit2 };
_side1 = side _group1;
_side2 = side _group2;

(_side1 == _side2 && {_side1 in [BLUFOR,OPFOR] || _group1 == _group2})
