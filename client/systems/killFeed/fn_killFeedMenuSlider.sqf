// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2017 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_killFeedMenuSlider.sqf
//	@file Author: AgentRev

#include "killFeed_defines.hpp"

params ["_eventParams", "_var", "_idc2", "_min", "_max", "_default", "_precision"];
_eventParams params ["_uiCtrl", "_val"];

if (!isNil "_min" && {_val < _min}) then { _val = _min };
if (!isNil "_max" && {_val > _max}) then { _val = _max };

private _fixed = _val toFixed round _precision;
((ctrlParent _uiCtrl) displayCtrl _idc2) ctrlSetText _fixed;

profileNamespace setVariable [_var, [_val, parseNumber _fixed] select (_precision < 1)];
with missionNamespace do { call fn_killFeedRefresh };
