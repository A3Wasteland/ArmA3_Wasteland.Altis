// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_setName.sqf
//	@file Author: AgentRev

private ["_unit", "_name"];

_unit = param [0, objNull, [objNull]];
_name = param [1, "", ["",[]]];

if (!isNull _unit) then
{
	_unit setName _name;
};
