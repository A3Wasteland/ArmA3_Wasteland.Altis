// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2017 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_killFeedMenuEditbox.sqf
//	@file Author: AgentRev

#include "killFeed_defines.hpp"

params ["_eventParams", "_var", "_idc2", "_min", "_max", "_default", "_precision"];
_eventParams params ["_uiCtrl"]; //, "_key", "_shift", "_ctrl", "_alt"];

private _val = parseNumber ctrlText _uiCtrl;

if (!isNil "_min" && {_val < _min}) then { _val = _min };
if (!isNil "_max" && {_val > _max}) then { _val = _max };

((ctrlParent _uiCtrl) displayCtrl _idc2) sliderSetPosition _val;

profileNamespace setVariable [_var, _val];
with missionNamespace do { call fn_killFeedRefresh };
