//	@file Name: playerSetupEnd.sqf
//	@file Author: [GoT] JoSchaap, AgentRev

private "_player";
_player = _this;

_player addRating 9999999;

thirstLevel = 100;
hungerLevel = 100;

[objNull, _player] call mf_player_actions_refresh;
[] execVM "client\functions\playerActions.sqf";

// Remove unrealistic blur effects
[] spawn
{
	waitUntil {!isNil "BIS_fnc_feedback_fatigueBlur"};
	ppEffectDestroy BIS_fnc_feedback_fatigueBlur;
	
	waitUntil {!isNil "BIS_fnc_feedback_damageBlur"};
	ppEffectDestroy BIS_fnc_feedback_damageBlur;
};

_player groupChat "Wasteland - Initialization Complete";
playerSetupComplete = true;
