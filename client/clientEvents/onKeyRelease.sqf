//	@file Name: onKeyRelease.sqf
//	@file Author: AgentRev

private ["_key", "_handled"];

_key = _this select 1;
_handled = false;

// Left & Right Windows keys
if (_key in [219,220]) then
{
	showPlayerNames = false;
};

_handled
