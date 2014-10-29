// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: groupNotify.sqf
//	@file Author: AgentRev

private ["_type", "_sender", "_msg"];

_type = [_this, 0, "", [""]] call BIS_fnc_param;

switch (_type) do
{
	case "invite":
	{
		_sender = [_this, 1, objNull, [objNull]] call BIS_fnc_param;

		if (isPlayer _sender) then
		{
			if (isStreamFriendlyUIEnabled) then
			{
				_msg = "You have been invited<br/>to join a group";
			}
			else
			{
				_msg = ([name _sender] call fn_encodeText) + "<br/>sent you a group invite";
			};

			["GroupInvite", [_msg]] call BIS_fnc_showNotification;
		};
	};
};
