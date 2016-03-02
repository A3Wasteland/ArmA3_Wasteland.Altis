// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
#define DURATION_STEP 1
#define DURATION_FAILED 5
//TODO: Fix the jerkiness (playMove vs switchMove)
private ["_length", "_animation", "_check", "_args", "_success", "_failure", "_complete", "_start", "_previousAnim"];

if a3w_actions_mutex exitWith {
	["You're already doing something!", DURATION_FAILED] call a3w_actions_notify;
};
a3w_actions_mutex = true;

_length = _this select 0;
_animation = _this select 1;
_check = _this select 2;
_args = _this select 3;

_complete = true;
_start = time;
_previousAnim = animationState player;
[player, _animation] call switchMoveGlobal;
_failed = false;

createDialog "ActionGUI";
disableSerialization;
_display = findDisplay 10101;
_display displayAddEventHandler ["KeyDown", "_this select 1 == 1;"];
_progressbar =  _display displayCtrl 10101;
_struct_text = _display displayCtrl 10102;
waitUntil {
	private ["_progress", "_result", "_text"];
	if (animationState player != _animation) then { [player, _animation] call switchMoveGlobal };
	if not a3w_actions_mutex then {
		_failed = true;
		["Action Cancelled", DURATION_FAILED] call a3w_actions_notify;
	} else {
		_progress = (time - _start)/_length;
		_progressbar progressSetPosition _progress;
		_result = ([_progress]+_args) call _check;
		_break = _result select 0;
		_text = _result select 1;
		if _break then {
			[_text, DURATION_FAILED] call a3w_actions_notify;
			_failed = true;
		} else {
			_struct_text ctrlSetStructuredText parseText _text;
		};
	};
	_start +_length < time or _failed;
};
[player, _previousAnim] call switchMoveGlobal;
_display closeDisplay 0;
a3w_actions_mutex = false;
not _failed;
