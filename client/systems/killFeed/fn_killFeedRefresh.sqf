// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2017 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_killFeedRefresh.sqf
//	@file Author: AgentRev

#include "killFeed_defines.hpp"

private _refreshThread = [missionNamespace getVariable "A3W_killFeed_refreshThread"] param [0,scriptNull,[scriptNull]];
if (!scriptDone _refreshThread) then { terminate _refreshThread };

with missionNamespace do
{
	A3W_killFeed_refreshThread = 0 spawn
	{
		disableSerialization;
		private _feedDisp = uiNamespace getVariable ["A3W_killFeed", displayNull];

		if (isNull _feedDisp) then
		{
			"A3W_killFeed" cutRsc ["A3W_killFeed","PLAIN"];
			_feedDisp = uiNamespace getVariable ["A3W_killFeed", displayNull];
		};

		private _maxKills = ([profileNamespace getVariable "A3W_killFeed_maxKills"] param [0,A3W_killFeed_maxKills_defaultVal,[A3W_killFeed_maxKills_defaultVal]]) max 0 min 100;
		private _fadeTime = ([profileNamespace getVariable "A3W_killFeed_fadeTime"] param [0,A3W_killFeed_fadeTime_defaultVal,[A3W_killFeed_fadeTime_defaultVal]]) max 0 min 600;
		private _showIcons = [profileNamespace getVariable "A3W_killFeed_showIcons"] param [0,A3W_killFeed_showIcons_defaultVal,[A3W_killFeed_showIcons_defaultVal]];
		private _offsetX = ([profileNamespace getVariable "A3W_killFeed_offsetX"] param [0,A3W_killFeed_offsetX_defaultVal,[A3W_killFeed_offsetX_defaultVal]]) max (-safeZoneWAbs/2) min (+safeZoneWAbs/2);
		private _offsetY = ([profileNamespace getVariable "A3W_killFeed_offsetY"] param [0,A3W_killFeed_offsetY_defaultVal,[A3W_killFeed_offsetY_defaultVal]]) max 0 min (+safeZoneH);
		private _opacity = ([profileNamespace getVariable "A3W_killFeed_opacity"] param [0,A3W_killFeed_opacity_defaultVal,[A3W_killFeed_opacity_defaultVal]]) max 0 min 1;

		private _killsArray = [missionNamespace getVariable "A3W_killFeed_killsArray"] param [0,[],[[]]];
		private _killsCount = count _killsArray;
		private _feedTextArr = [""]; // empty string adds one <br/> at the top to lower text away from screen edge

		for "_i" from ((_killsCount - _maxKills) max 0) to (_killsCount - 1) do
		{
			[] params (_killsArray select _i); // automagically assign all _killParams variables defined at the bottom of fn_killBroadcast.sqf

			if (diag_tickTime - _killTime <= _fadeTime) then
			{
				_feedTextArr pushBack ([_killMessage,_killMessageIcons] select _showIcons);
			};
		};

		private _feedText = _feedDisp displayCtrl A3W_killFeed_feedText_IDC;
		_feedText ctrlSetStructuredText parseText (_feedTextArr joinString "<br/>");
		_feedText ctrlSetPosition [safeZoneX + _offsetX, safeZoneY + _offsetY];
		_feedText ctrlSetFade (1 - _opacity);
		_feedText ctrlCommit 0;
	};
};
