// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_onPlayerDisconnected.sqf
//	@file Author: AgentRev

_id = if (isNil "_id") then { _this select 0 } else { _id };
_uid = if (isNil "_uid") then { _this select 1 } else { _uid };
_name = if (isNil "_name") then { _this select 2 } else { _name };

diag_log format ["Player disconnected: %1 (%2)", _name, _uid];

// Clear player from group invites
{
	if (_uid in _x) then
	{
		currentInvites set [_forEachIndex, -1];
	};
} forEach currentInvites;

currentInvites = currentInvites - [-1];
publicVariable "currentInvites";
