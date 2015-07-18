// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: acceptGroupInvite.sqf
//	@file Author: [404] Deadbeat, AgentRev
//	@file Created: 20/11/2012 05:19

private ["_playerUID", "_senderUID", "_sender", "_newGroup"];

_playerUID = getPlayerUID player;

// Find the sender's UID
{
	if (_x select 1 == _playerUID) exitWith
	{
		_senderUID = _x select 0;
	};
} forEach currentInvites;

// Find the sender
if (!isNil "_senderUID") then
{
	{
		if (getPlayerUID _x == _senderUID) exitWith
		{
			_sender = _x;
			_newGroup = group _sender;
		};
	} forEach allPlayers;
};

if (!isNil "_sender" && {side _newGroup == playerSide}) then
{
	_oldGroup = group player;

	_oldTerritories = _oldGroup getVariable ["currentTerritories", []];
	_newTerritories = _newGroup getVariable ["currentTerritories", []];

	{ _newTerritories pushBack _x } forEach _oldTerritories;

	[player] join _newGroup;
	waitUntil {_newGroup = group player; _newGroup != _oldGroup};

	_newGroup setVariable ["currentTerritories", _newTerritories, true];

	if (_newGroup == group _sender) then
	{
		pvar_processGroupInvite = ["accept", _playerUID];
		publicVariableServer "pvar_processGroupInvite";
	};

	if (!isNull _oldGroup) then
	{
		_oldGroup setVariable ["currentTerritories", [], true];
	};

	pvar_convertTerritoryOwner = [_newTerritories, _newGroup];
	publicVariableServer "pvar_convertTerritoryOwner";

	[_newTerritories, false, _newGroup, true] call updateTerritoryMarkers;

	player globalChat "You have accepted the invite.";
	player setVariable ["currentGroupRestore", _newGroup, true];
	player setVariable ["currentGroupIsLeader", false, true];
}
else
{
	if (!isNil "_senderUID") then
	{
		pvar_processGroupInvite = ["decline", _senderUID, _playerUID];
		publicVariableServer "pvar_processGroupInvite";
	};

	player globalChat "The group no longer exists or the leader disconnected / changed sides";
};
