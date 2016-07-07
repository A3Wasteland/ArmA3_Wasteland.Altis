// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_setName.sqf
//	@file Author: AgentRev

params [["_unit",objNull,[objNull]], ["_name","",["",[]]]];

if (isNull _unit) exitWith {};

_unit setName _name;
