// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: playUntil.sqf
//	@file Author: MercyfulFate
//  @file Description: Plays an animation and runs conditional checks for a certian duration
//      It displays the text returned from the conditional code using mf_notify_client
//	@file Args: [_length, _animation, _check, _args]
//      _length - the duration to execute for
//      _animation - the animation to play
//      _check - the condition code that is "continually" run. needs to return [_failed, _text];
//      _args - the arguments to pass into the code each execution step
//  @file Return: true if completed successfully, false as soon as the conditional check failed.
//
//  @file Note: The conditional code MUST return [_failed, _text]
//       _failed - true if a condition failed.
//       _text - the text to display

#define DURATION_STEP 0.1
#define DURATION_FAILED 5
//TODO: Fix the jerkiness (playMove vs switchMove)
private ["_length", "_animation", "_check", "_args"];
_length = _this select 0;
_animation = _this select 1;
_check = _this select 2;
_args = _this select 3;

private ["_complete", "_start", "_restartAnim", "_previousAnim"];
_complete = true;
_start = time;
_restartAnim = {player switchMove _animation};
_previousAnim = animationState player;
player switchMove _animation;
while {time < _start+_length} do {
	if (animationState player != _animation) then _restartAnim;
	private ["_failed", "_progress"];
	_progress = (time - _start)/_length;
	_result = ([_progress]+_args) call _check;
	_failed = _result select 0;
	_text = _result select 1;
	if (_text != "") then {
		if _failed then {
			[_text, DURATION_FAILED] call mf_notify_client;
		} else {
			[_text, DURATION_STEP] call mf_notify_client;
		};
	};
	if _failed exitWith {_complete = false};
	sleep DURATION_STEP;
};
player switchMove _previousAnim;
_complete;
