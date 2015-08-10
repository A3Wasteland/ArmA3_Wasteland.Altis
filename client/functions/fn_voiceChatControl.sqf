// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_voiceChatControl.sqf
//	@file Author: AgentRev

#define SWITCH_DIRECT if (currentChannel == 0 && !((getPlayerUID player) call isAdmin)) then { setCurrentChannel 5 }

private "_waitSpeak";
_waitSpeak = _this select 0;

if (["A3W_disableGlobalVoice"] call isConfigOn) then
{
	if (_waitSpeak) then
	{
		["A3W_voiceChatControl", "onEachFrame",
		{
			if (!isNull findDisplay 55) then
			{
				SWITCH_DIRECT;
				["A3W_voiceChatControl", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
			};
		}] call BIS_fnc_addStackedEventHandler;
	}
	else
	{
		if (!isNull findDisplay 55) then
		{
			SWITCH_DIRECT;
		};
	};
};
