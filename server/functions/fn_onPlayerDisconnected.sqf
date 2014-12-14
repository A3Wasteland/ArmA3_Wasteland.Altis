// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_onPlayerDisconnected.sqf
//	@file Author: AgentRev

private ["_id", "_uid", "_name", "_resend"];
_id = _this select 0;
_uid = _this select 1;
_name = _this select 2;

diag_log format ["Player disconnected: %1 (%2)", _name, _uid];

_resend = false;

// Clear player from group invites
{
	if (_uid in _x) then
	{
		currentInvites set [_forEachIndex, -1];
		_resend = true;
	};
} forEach currentInvites;

if (_resend) then
{
	currentInvites = currentInvites - [-1];
	publicVariable "currentInvites";
};
