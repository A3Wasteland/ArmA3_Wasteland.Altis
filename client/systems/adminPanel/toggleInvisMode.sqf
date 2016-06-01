// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: toggleInvisMode.sqf
//	@file Author: macchky
//	@file Created: 2015/4/7 9:35

if (isDedicated) exitWith {};

if ((getPlayerUID player) call isAdmin) then
{
	private ["_curPlayerInvisState","_player","_isAdminInvisible"];
	//_curPlayerInvisState = player getVariable ["isAdminInvisible", false];

	_player = player;

	// If variable is not set ,set default value.
	_isAdminInvisible = missionNamespace getVariable ["pvar_isAdminInvisible",[_player, false]];
	missionNamespace setVariable ["pvar_isAdminInvisible", _isAdminInvisible];
	_curPlayerInvisState = pvar_isAdminInvisible select 1;

// Go hiding
	if (!_curPlayerInvisState) then
	{
		//[[player, true], "A3W_fnc_invisible", false, true] call A3W_fnc_MP;
		//player setVariable ["isAdminInvisible", true, true];
		_curPlayerInvisState = true;
		pvar_isAdminInvisible = [_player, _curPlayerInvisState];
		publicVariable "pvar_isAdminInvisible";
		hint "You are now invisible";
		if (!isNil "notifyAdminMenu") then { ["Invisibility", "On"] call notifyAdminMenu };
	}
	else
	{
		//[[player, false], "A3W_fnc_invisible", false, true] call A3W_fnc_MP;
		//player setVariable ["isAdminInvisible", false, true];
		_curPlayerInvisState = false;
		pvar_isAdminInvisible = [_player, _curPlayerInvisState];
		publicVariable "pvar_isAdminInvisible";
		hint "You are no longer invisible";
		if (!isNil "notifyAdminMenu") then { ["Invisibility", "Off"] call notifyAdminMenu };
	};
}