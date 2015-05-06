// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
/*********************************************************#
# @@ScriptName: toggle_spawn_permissions.sqf
# @@Author: Nick 'Bewilderbeest' Ludlam <bewilder@recoil.org>
# @@Create Date: 2013-09-11 15:11:52
# @@Modify Date: 2013-09-15 23:28:23
# @@Function: Swaps between group-only and team spawning allowed
#*********************************************************/

#include "mutex.sqf"
#define ANIM "AinvPknlMstpSlayWrflDnon_medic"
#define DURATION 5
#define ERR_CANCELLED "Changing spawn permissions cancelled"
#define ERR_TOO_FAR_AWAY "Changing spawn permissions failed as you moved too far away!"
#define ERR_SOMEONE_ELSE_TAKEN "Changing spawn permissions failed, as someone else finished packing it up before you!"
#define ERR_NO_GROUP "You must be in a group to enable group spawn restrictions"

private ["_beacon", "_error", "_hasFailed", "_success"];
_beacon = [] call mf_items_spawn_beacon_nearest;
_error = [_beacon] call mf_items_spawn_beacon_can_pack;
if (_error != "") exitWith {[_error, 5] call mf_notify_client};

_hasFailed = {
	private ["_progress", "_beacon", "_caller", "_failed", "_text"];
	_progress = _this select 0;
	_beacon = _this select 1;
	_text = "";
	_failed = true;
	switch (true) do {
		case (!alive player): {}; // player dead, no error msg needed
		case (vehicle player != player): {};
		case (isNull _beacon): {_text = ERR_SOMEONE_ELSE_TAKEN};
		case (player distance _beacon > 5): {_text = ERR_TOO_FAR_AWAY};
		case (doCancelAction): {doCancelAction = false; _text = ERR_CANCELLED};
		//case (count units group player < 2): {_text = ERR_NO_GROUP};
		default {
			_text = format["Spawn beacon is %1%2 updated", round(_progress*100), "%"];
			_failed = false;
		};
	};
	[_failed, _text];
};

_currentGroupOnlyState = _beacon getVariable ["groupOnly", false];

MUTEX_LOCK_OR_FAIL;
_success = true; //[DURATION, ANIM, _hasFailed, [_beacon]] call mf_util_playUntil;
MUTEX_UNLOCK;

if (_success) then {
	if (_currentGroupOnlyState) then {
		["The Spawn Beacon is now available to your whole team", 5] call mf_notify_client;
		_beacon setVariable ['groupOnly', false, true];
	} else {
		["The Spawn Beacon is now limited to your group", 5] call mf_notify_client;
		_beacon setVariable ['groupOnly', true, true];
	};
};

