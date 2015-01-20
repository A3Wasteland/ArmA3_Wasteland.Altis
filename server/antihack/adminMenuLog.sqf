// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: adminMenuLog.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

private ["_name", "_uid", "_action", "_value", "_sentChecksum"];

_sentChecksum = [_this, 4, "", [""]] call BIS_fnc_param;

if (_sentChecksum == _flagChecksum) then
{
	_name = [_this, 0, "", [""]] call BIS_fnc_param;
	_uid = [_this, 1, "", [""]] call BIS_fnc_param;
	_action = [_this, 2, "", [""]] call BIS_fnc_param;
	_value = [_this, 3, "", [0,"",[]]] call BIS_fnc_param;

	if (!isNil "fn_logAdminMenu") then
	{
		[_uid, _name, _action, _value] call fn_logAdminMenu;
	};
};
