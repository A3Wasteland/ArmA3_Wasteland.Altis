// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_formatTimer.sqf
//	@file Author: AgentRev

private ["_remaining", "_mins", "_secs"];

_remaining = ceil _this;
_mins = floor (_remaining / 60);
_secs = _remaining - (_mins * 60);

format ["%1:%2%3", _mins, if (_secs < 10) then { "0" } else { "" }, _secs]
