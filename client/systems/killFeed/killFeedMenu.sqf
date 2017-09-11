// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2017 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: killFeedMenu.sqf
//	@file Author: AgentRev

#include "killFeed_defines.hpp"

private _feedMenuDisp = [uiNamespace getVariable "A3W_killFeedMenu"] param [0,displayNull,[displayNull]];

if (isNull _feedMenuDisp) then
{
	createDialog "A3W_killFeedMenu";
	_feedMenuDisp = [uiNamespace getVariable "A3W_killFeedMenu"] param [0,displayNull,[displayNull]];
};

with missionNamespace do 
{
	if (isNil "A3W_fnc_killFeedMenuCheckbox") then { A3W_fnc_killFeedMenuCheckbox = compile preprocessFileLineNumbers "client\systems\killFeed\fn_killFeedMenuCheckbox.sqf" };
	if (isNil "A3W_fnc_killFeedMenuSlider") then { A3W_fnc_killFeedMenuSlider = compile preprocessFileLineNumbers "client\systems\killFeed\fn_killFeedMenuSlider.sqf" };
	if (isNil "A3W_fnc_killFeedMenuEditbox") then { A3W_fnc_killFeedMenuEditbox = compile preprocessFileLineNumbers "client\systems\killFeed\fn_killFeedMenuEditbox.sqf" };
	if (isNil "A3W_fnc_killFeedMenuRefresh") then { A3W_fnc_killFeedMenuRefresh = compile preprocessFileLineNumbers "client\systems\killFeed\fn_killFeedMenuRefresh.sqf" };
};

{
	_x params ["_idc", "_event", "_fn", "_var", "_idc2", "_min", "_max", "_default", "_precision"];

	private _currVal = [profileNamespace getVariable _var] param [0,_default,[_default]];
	private _ctrl = _feedMenuDisp displayCtrl _idc;
	_ctrl ctrlRemoveAllEventHandlers _event;

	switch (_event) do
	{
		case "KeyDown":           { _ctrl ctrlSetText (_currVal toFixed round _precision) };
		case "CheckedChanged":    { _ctrl cbSetChecked _currVal };
		case "SliderPosChanged":
		{
			_ctrl sliderSetRange [if (_min isEqualType "") then { call compile _min } else { _min },
			                      if (_max isEqualType "") then { call compile _max } else { _max }];
			_ctrl sliderSetPosition _currVal;
		};
	};

	_ctrl ctrlSetEventHandler [_event, format ["with missionNamespace do { [_this, %1, %2, %3, %4, %5, %6] call %7 }", str _var, _idc2, _min, _max, _default, _precision, _fn]];
}
forEach
[
	[A3W_killFeedMenu_MaxKillsSlider_IDC, "SliderPosChanged", "A3W_fnc_killFeedMenuSlider", "A3W_killFeed_maxKills", A3W_killFeedMenu_MaxKillsEdit_IDC, 0, 20, A3W_killFeed_maxKills_defaultVal, 0],
	[A3W_killFeedMenu_MaxKillsEdit_IDC, "KeyDown", "A3W_fnc_killFeedMenuEditbox", "A3W_killFeed_maxKills", A3W_killFeedMenu_MaxKillsSlider_IDC, 0, 100, A3W_killFeed_maxKills_defaultVal, 0],

	[A3W_killFeedMenu_FadeTimeSlider_IDC, "SliderPosChanged", "A3W_fnc_killFeedMenuSlider", "A3W_killFeed_fadeTime", A3W_killFeedMenu_FadeTimeEdit_IDC, 0, 120, A3W_killFeed_fadeTime_defaultVal, 0],
	[A3W_killFeedMenu_FadeTimeEdit_IDC, "KeyDown", "A3W_fnc_killFeedMenuEditbox", "A3W_killFeed_fadeTime", A3W_killFeedMenu_FadeTimeSlider_IDC, 0, 600, A3W_killFeed_fadeTime_defaultVal, 0],

	[A3W_killFeedMenu_ShowIconsCheck_IDC, "CheckedChanged", "A3W_fnc_killFeedMenuCheckbox", "A3W_killFeed_showIcons", -1, "nil", "nil", A3W_killFeed_showIcons_defaultVal, 0],

	[A3W_killFeedMenu_ShowChatCheck_IDC, "CheckedChanged", "A3W_fnc_killFeedMenuCheckbox", "A3W_killFeed_showChat", -1, "nil", "nil", A3W_killFeed_showChat_defaultVal, 0],

	[A3W_killFeedMenu_OffsetXSlider_IDC, "SliderPosChanged", "A3W_fnc_killFeedMenuSlider", "A3W_killFeed_offsetX", A3W_killFeedMenu_OffsetXEdit_IDC, "-safeZoneWAbs/2", "+safeZoneWAbs/2", A3W_killFeed_offsetX_defaultVal, 3],
	[A3W_killFeedMenu_OffsetXEdit_IDC, "KeyDown", "A3W_fnc_killFeedMenuEditbox", "A3W_killFeed_offsetX", A3W_killFeedMenu_OffsetXSlider_IDC, "nil", "nil", A3W_killFeed_offsetX_defaultVal, 3],

	[A3W_killFeedMenu_OffsetYSlider_IDC, "SliderPosChanged", "A3W_fnc_killFeedMenuSlider", "A3W_killFeed_offsetY", A3W_killFeedMenu_OffsetYEdit_IDC, "0", "+safeZoneH", A3W_killFeed_offsetY_defaultVal, 3],
	[A3W_killFeedMenu_OffsetYEdit_IDC, "KeyDown", "A3W_fnc_killFeedMenuEditbox", "A3W_killFeed_offsetY", A3W_killFeedMenu_OffsetYSlider_IDC, "nil", "nil", A3W_killFeed_offsetY_defaultVal, 3],

	[A3W_killFeedMenu_OpacitySlider_IDC, "SliderPosChanged", "A3W_fnc_killFeedMenuSlider", "A3W_killFeed_opacity", A3W_killFeedMenu_OpacityEdit_IDC, 0, 1, A3W_killFeed_opacity_defaultVal, 2],
	[A3W_killFeedMenu_OpacityEdit_IDC, "KeyDown", "A3W_fnc_killFeedMenuEditbox", "A3W_killFeed_opacity", A3W_killFeedMenu_OpacitySlider_IDC, 0, 1, A3W_killFeed_opacity_defaultVal, 2]
];

private _logLimitList = _feedMenuDisp displayCtrl A3W_killFeedMenu_LogLimitList_IDC;
_logLimitList ctrlRemoveAllEventHandlers "LBSelChanged";
lbClear _logLimitList;
_logLimitList lbSetData [_logLimitList lbAdd "Show 50 last", "50"];
_logLimitList lbSetData [_logLimitList lbAdd "Show all", "-1"];
_logLimitList lbSetCurSel 0;
_logLimitList ctrlSetEventHandler ["LBSelChanged", "with missionNamespace do { call A3W_fnc_killFeedMenuRefresh }"];

with missionNamespace do { call A3W_fnc_killFeedMenuRefresh };
