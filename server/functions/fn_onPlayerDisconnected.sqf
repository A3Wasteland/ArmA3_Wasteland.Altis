//	@file Name: fn_onPlayerDisconnected.sqf
//	@file Author: AgentRev

_id = if (isNil "_id") then { _this select 0 } else { _id };
_uid = if (isNil "_uid") then { _this select 1 } else { _uid };
_name = if (isNil "_name") then { _this select 2 } else { _name };

// Clear player from group invites
{
	if (_uid in _x) then
	{
		currentInvites set [_forEachIndex, -1];
	};
} forEach currentInvites;

currentInvites = currentInvites - [-1];
publicVariable "currentInvites";
