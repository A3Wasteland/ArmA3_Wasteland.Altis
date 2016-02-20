// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: customKeys.sqf
//	@file Author: AgentRev

// Load custom keys from profile

private ["_varName", "_defKeys", "_customKeys", "_isValid"];

{
	_varName = _x select 0;
	_defKeys = _x select 1;
	_customKeys = profileNamespace getVariable _varName;

	// check that each variable read from profile is an array strictly containing between 1 to 10 numbers, otherwise use default values
	_isValid = !isNil "_customKeys" && {_customKeys isEqualType [] && {count _customKeys > 0 && count _customKeys <= 10 && {_customKeys isEqualTypeAll 0}}};

	missionNamespace setVariable [_varName, if (_isValid) then { _customKeys } else { _defKeys }];
}
forEach
[
	["A3W_customKeys_adminMenu", [22]], // 22 = U
	["A3W_customKeys_playerMenu", [41]], // 41 = Tilde (above Tab)
	["A3W_customKeys_playerNames", [199,219,220]], // 199 = Home, 219 = LWin, 220 = RWin
	["A3W_customKeys_earPlugs", [207]] // 207 = End
];
