// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2017 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_killFeedMenuCheckbox.sqf
//	@file Author: AgentRev

#include "killFeed_defines.hpp"

params ["_eventParams", "_var"]; //, "_idc2", "_min", "_max", "_default", "_precision"];
_eventParams params ["_uiCtrl", "_checked"];

_checked = (_checked > 0);

profileNamespace setVariable [_var, _checked];
with missionNamespace do { call fn_killFeedRefresh };
