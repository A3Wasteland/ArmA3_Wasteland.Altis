// ****************************************************************************************
// * This addon is licensed under the GNU Lesser GPL v3. Copyright © 2016 A3Wasteland.com *
// ****************************************************************************************
//	@file Name: magNameAllowed.sqf
//	@file Author: AgentRev

#include "defines.sqf"

// Action events don't contain the magazine classname, but we can compare the localized text to the displayNames of allowed classes

params ["_actionText"];
if (_actionText isEqualTo "") exitWith { false };

private _found = false;

{
	if (_actionText find _x != -1) exitWith
	{
		_found = true;
	};
} forEach A3W_stickyCharges_allowedMagNames;

_found
