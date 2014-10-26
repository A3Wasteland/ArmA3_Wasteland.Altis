// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: declineGroupInvite.sqf
//	@file Author: [404] Deadbeat, AgentRev
//	@file Created: 20/11/2012 05:19

private ["_playerUID", "_senderUID"];

_playerUID = getPlayerUID player;

// Find the sender's UID
{
	if (_x select 1 == _playerUID) exitWith
	{
		_senderUID = _x select 0;
	};
} forEach currentInvites;

if (!isNil "_senderUID") then
{
	pvar_processGroupInvite = ["decline", _senderUID, _playerUID];
	publicVariableServer "pvar_processGroupInvite";

	player globalChat "You have declined the invite.";
};
