// ****************************************************************************************
// * This addon is licensed under the GNU Lesser GPL v3. Copyright © 2016 A3Wasteland.com *
// ****************************************************************************************
//	@file Name: magNameAllowed.sqf
//	@file Author: AgentRev

#include "defines.sqf"

// Action events don't contain the magazine classname, but we can compare the localized text to the displayNames of allowed classes

params ["_actionText"];

if (_actionText == "") exitWith { false };

private "_magName";
private _found = false;

{
	_magName = getText (configFile >> "CfgMagazines" >> _x >> "displayName");

	if (_magName != "" && _actionText find _magName != -1) exitWith
	{
		_found = true;
	};
} forEach STICKY_CHARGE_ALLOWED_TYPES;

_found
