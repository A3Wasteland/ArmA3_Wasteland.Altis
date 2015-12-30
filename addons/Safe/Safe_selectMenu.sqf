// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: Safe_selectMenu.sqf
//	@file Author: LouD / Cael817 for original script
//	@file Description: Safe script

#define PLAYER_CONDITION "(vehicle player == player && {!isNull cursorTarget})"
#define ITEM_CONDITION "{cursortarget iskindof 'Box_NATO_AmmoVeh_F'} && {(player distance cursortarget) < 5}"
#define OBJECT_CONDITION "{cursorTarget getVariable ['objectLocked', false]}"
#define HACKING_CONDITION "{'ToolKit' in (items player)} && {cursorTarget getVariable ['ownerUID',''] != getPlayerUID player}"

Safe_open = 
{
	private ["_unit","_uid,", "_owner"];

	_unit = _this select 0;
	_uid = getPlayerUID _unit;
	_owner = cursorTarget getvariable "ownerUID";

	if (!isNull (uiNamespace getVariable ["Safe_Menu", displayNull]) && !(player call A3W_fnc_isUnconscious)) exitWith {};

	switch (true) do
	{
		case (_uid == _owner || _uid != _owner):
		{
			execVM "addons\Safe\password_enter.sqf";
			hint "Welcome";
		};
		case (isNil _uid || isNull _uid):
		{
			hint "You need to lock the object first!";
		};
		default
		{
		hint "An unknown error occurred. This could be because your safe is not locked."
		};

	};
};

Safe_Actions = 
{
	{ [player, _x] call fn_addManagedAction } forEach
	[
		["<t color='#FFE496'><img image='client\icons\keypad.paa'/> Open Safe</t>", Safe_open, [cursorTarget], -97, false, false, "", PLAYER_CONDITION + " && " + ITEM_CONDITION + " && " + OBJECT_CONDITION],
		["<t color='#FFE496'><img image='client\icons\take.paa'/> Hack Safe</t>", "addons\Safe\Safe_hack.sqf", [cursorTarget], -97, false, false, "", PLAYER_CONDITION + " && " + ITEM_CONDITION + " && " + OBJECT_CONDITION + " && " + HACKING_CONDITION]
	];
};

SafeScriptInitialized = true;