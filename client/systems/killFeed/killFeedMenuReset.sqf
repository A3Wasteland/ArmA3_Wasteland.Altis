// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2017 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: killFeedMenuReset.sqf
//	@file Author: AgentRev

#include "killFeed_defines.hpp"

if (["Reset all killfeed options to default?", "Confirm", true, true] call BIS_fnc_guiMessage) then
{
	profileNamespace setVariable ["A3W_killFeed_maxKills", nil];
	profileNamespace setVariable ["A3W_killFeed_showIcons", nil];
	profileNamespace setVariable ["A3W_killFeed_showChat", nil];
	profileNamespace setVariable ["A3W_killFeed_offsetX", nil];
	profileNamespace setVariable ["A3W_killFeed_offsetY", nil];
	profileNamespace setVariable ["A3W_killFeed_opacity", nil];
	profileNamespace setVariable ["A3W_killFeed_fadeTime", nil];

	//closeDialog 0;
	([uiNamespace getVariable "A3W_killFeedMenu"] param [0,displayNull,[displayNull]]) closeDisplay 0;

	addMissionEventHandler ["Draw3D",
	{
		if (isNull ([uiNamespace getVariable "A3W_killFeedMenu"] param [0,displayNull,[displayNull]])) then
		{
			with missionNamespace do { [] call A3W_fnc_killFeedMenu };
			removeMissionEventHandler ["Draw3D", _thisEventHandler];
		};
	}];
};
