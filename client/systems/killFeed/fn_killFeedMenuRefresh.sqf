// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2017 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_killFeedMenuRefresh.sqf
//	@file Author: AgentRev

#include "killFeed_defines.hpp"

private _refreshThread = [missionNamespace getVariable "A3W_killFeed_menuRefreshThread"] param [0,scriptNull,[scriptNull]];
if (!scriptDone _refreshThread) then { terminate _refreshThread };

with missionNamespace do
{
	A3W_killFeed_menuRefreshThread = 0 spawn
	{
		disableSerialization;
		private _feedMenuDisp = [uiNamespace getVariable "A3W_killFeedMenu"] param [0,displayNull,[displayNull]];
		if (isNull _feedMenuDisp) exitWith {};

		private _logList = _feedMenuDisp displayCtrl A3W_killFeedMenu_LogList_IDC;
		private _logLimitList = _feedMenuDisp displayCtrl A3W_killFeedMenu_LogLimitList_IDC;
		private _limit = parseNumber (_logLimitList lbData lbCurSel _logLimitList);

		lbClear _logList;

		private _killsArray = [missionNamespace getVariable "A3W_killFeed_killsArray"] param [0,[],[[]]];
		private _killsCount = count _killsArray;
		if (_limit < 0) then { _limit = _killsCount };

		for "_i" from (_killsCount - 1) to ((_killsCount - _limit) max 0) step -1 do
		{
			[] params (_killsArray select _i); // automagically assign all _killParams variables defined at the bottom of fn_killBroadcast.sqf

			_idx = _logList lbAdd format ["[%1] %2", _killTimeStamp, _killMessageRaw]; // listbox does not support structured text :(

			switch (true) do
			{
				case (_killerUID isEqualTo getPlayerUID player && _killerUID != "");
				case (_victimUID isEqualTo getPlayerUID player && _victimUID != ""): { _logList lbSetColor [_idx, A3W_killFeed_selfColorArr] };
				case (_killerGroup == group player);
				case (_victimGroup == group player): { _logList lbSetColor [_idx, A3W_killFeed_groupColorArr] };
			};
		};
	};
};
