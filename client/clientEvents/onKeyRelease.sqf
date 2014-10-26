// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: onKeyRelease.sqf
//	@file Author: AgentRev

private ["_key", "_shift", "_ctrl", "_alt", "_handled"];

_key = _this select 1;
_shift = _this select 2;
_ctrl = _this select 3;
_alt = _this select 4;

_handled = false;

/*
// Left & Right Windows keys
if (_key in [219,220]) then
{
	showPlayerNames = false;
};
*/

// Scoreboard
if (_key in actionKeys "NetworkStats") then
{
	if (alive player) then
	{
		9123 cutRsc ["RscEmpty", "PLAIN"];
	};

	_handled = true;
};

_handled
