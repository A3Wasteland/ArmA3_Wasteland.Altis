// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: groupNotify.sqf
//	@file Author: AgentRev

private ["_type", "_sender", "_msg"];

_type = param [0, "", [""]];

switch (_type) do
{
	case "invite":
	{
		_sender = param [1, objNull, [objNull]];

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
