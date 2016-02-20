// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: adminMenuLog.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

private ["_name", "_uid", "_action", "_value", "_sentChecksum"];

_sentChecksum = param [4, "", [""]];

if (_sentChecksum == _flagChecksum) then
{
	_name = param [0, "", [""]];
	_uid = param [1, "", [""]];
	_action = param [2, "", [""]];
	_value = param [3, "", [0,"",[]]];

	if (!isNil "fn_logAdminMenu") then
	{
		[_uid, _name, _action, _value] call fn_logAdminMenu;
	};
};
