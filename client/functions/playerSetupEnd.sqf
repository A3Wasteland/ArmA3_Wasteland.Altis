// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: playerSetupEnd.sqf
//	@file Author: [GoT] JoSchaap, AgentRev

private "_player";
_player = _this;

_player addRating 9999999;

thirstLevel = if (isNil "thirstLevel") then {100} else {thirstLevel};
hungerLevel = if (isNil "hungerLevel") then {100} else {hungerLevel};

[objNull, _player] call mf_player_actions_refresh;
[] execVM "client\functions\playerActions.sqf";

_player groupChat "Wasteland - Initialization Complete";
playerSetupComplete = true;
_player setVariable ["initComplete", true, true];

trackMe = [_player];
publicVariable "trackMe";
