// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: processGroupInvite.sqf
//	@file Author: AgentRev

private ["_type", "_sender", "_receiver", "_invite", "_senderUID", "_receiverUID"];

_type = [_this, 0, "", [""]] call BIS_fnc_param;

switch (_type) do
{
	case "send":
	{
		_sender = [_this, 1, objNull, [objNull]] call BIS_fnc_param;
		_receiver = [_this, 2, objNull, [objNull]] call BIS_fnc_param;

		if (isPlayer _sender && isPlayer _receiver && {count units _receiver == 1}) then
		{
			_invite = [getPlayerUID _sender, getPlayerUID _receiver];

			// Clear any previous identical invite
			{
				if (_x isEqualTo _invite) then
				{
					currentInvites set [_forEachIndex, -1];
				};
			} forEach currentInvites;

			currentInvites = currentInvites - [-1];
			currentInvites pushBack _invite;
			publicVariable "currentInvites";

			pvar_groupNotify = ["invite", _sender];
			(owner _receiver) publicVariableClient "pvar_groupNotify";
		};
	};
	case "accept":
	{
		_receiverUID = [_this, 1, "", [""]] call BIS_fnc_param;

		// Clear any invites sent from or to him
		{
			if (_receiverUID in _x) then
			{
				currentInvites set [_forEachIndex, -1];
			};
		} forEach currentInvites;

		currentInvites = currentInvites - [-1];
		publicVariable "currentInvites";
	};
	case "decline":
	{
		_senderUID = [_this, 1, "", [""]] call BIS_fnc_param;
		_receiverUID = [_this, 2, "", [""]] call BIS_fnc_param;
		_invite = [_senderUID, _receiverUID];

		// Clear the first matching invite
		{
			if (_x isEqualTo _invite) exitWith
			{
				currentInvites set [_forEachIndex, -1];
			};
		} forEach currentInvites;

		currentInvites = currentInvites - [-1];
		publicVariable "currentInvites";
	};
};
