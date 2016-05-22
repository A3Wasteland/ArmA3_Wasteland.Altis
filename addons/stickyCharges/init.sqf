// ****************************************************************************************
// * This addon is licensed under the GNU Lesser GPL v3. Copyright © 2016 A3Wasteland.com *
// ****************************************************************************************
//	@file Name: init.sqf
//	@file Author: AgentRev

/*
	Sticky Charges addon v1.04 by AgentRev

	This addon can freely be integrated in any mission/mod outside of A3Wasteland, without the need to ask for permission, as long as LICENSE.txt remains in the addon folder.

	WARNING: This script uses inGameUISetEventHandler, which may cause conflicts with other scripts relying on that command, see bottom of file for more info

	If needed, BattleEye whitelist:
	 - createvehicle.txt: !="Sign_Sphere10cm_F"
	 - publicvariable.txt: !="pvar_A3W_stickyCharges_vecDirUp"
	 - setvariable.txt: !"^A3W_stickyCharges_"

	and blacklist:
	 - publicvariable.txt: 5 "^A3W_stickyCharges_"
*/

#include "defines.sqf" // adjust settings in there as needed!

#define STICKY_CHARGE_ADDON_PATH "addons\stickyCharges" // mission folder path where this script is placed
#define STICKY_CHARGE_COMPILE(FILENAME) compileFinal preprocessFileLineNumbers (STICKY_CHARGE_ADDON_PATH + "\" + FILENAME)

if (isServer) then
{
	A3W_fnc_stickyCharges_disconnectCleanup = STICKY_CHARGE_COMPILE("disconnectCleanup.sqf");

	if (!isNil "A3W_stickyCharges_disconnectCleanup_ID") then { removeMissionEventHandler ["PlayerDisconnected", A3W_stickyCharges_disconnectCleanup_ID] };
	A3W_stickyCharges_disconnectCleanup_ID = addMissionEventHandler ["PlayerDisconnected", A3W_fnc_stickyCharges_disconnectCleanup];

	// Temp fix for https://forums.bistudio.com/topic/190773-mission-event-handlers-playerconnected-and-playerdisconnected-do-not-work/
	["A3W_stickyCharges_oPD_fix", "onPlayerDisconnected", {}] call BIS_fnc_addStackedEventHandler;
	["A3W_stickyCharges_oPD_fix", "onPlayerDisconnected"] call BIS_fnc_removeStackedEventHandler;

	if (!isNil "A3W_stickyCharges_dummyCleanup") then { terminate A3W_stickyCharges_dummyCleanup };
	A3W_stickyCharges_dummyCleanup = execVM (STICKY_CHARGE_ADDON_PATH + "\dummyCleanup.sqf");
};

"pvar_A3W_stickyCharges_vecDirUp" addPublicVariableEventHandler STICKY_CHARGE_COMPILE("pvarVecDirUp.sqf");

if (!isNil "A3W_stickyCharges_initVecDirUp") then { terminate A3W_stickyCharges_initVecDirUp };
A3W_stickyCharges_initVecDirUp = execVM (STICKY_CHARGE_ADDON_PATH + "\initVecDirUp.sqf");

if (!hasInterface) exitWith {};

if (!isNil "A3W_stickyCharges_drawSurfaceIcon_ID") then { removeMissionEventHandler ["Draw3D", A3W_stickyCharges_drawSurfaceIcon_ID] };

A3W_stickyCharges_surfaceIcon = getText (configFile >> "CfgInGameUI" >> "Cursor" >> "explosive");
A3W_stickyCharges_allowedMagNames = [];

{
	_magName = getText (configFile >> "CfgMagazines" >> _x >> "displayName");

	if (_magName != "") then
	{
		A3W_stickyCharges_allowedMagNames pushBackUnique _magName;
	};
} forEach STICKY_CHARGE_ALLOWED_TYPES;

A3W_fnc_stickyCharges_magNameAllowed = STICKY_CHARGE_COMPILE("magNameAllowed.sqf");
A3W_fnc_stickyCharges_toggleSurfaceIcon = STICKY_CHARGE_COMPILE("toggleSurfaceIcon.sqf");
A3W_fnc_stickyCharges_actionIntersect = STICKY_CHARGE_COMPILE("actionIntersect.sqf");
A3W_fnc_stickyCharges_actionEvent = STICKY_CHARGE_COMPILE("actionEvent.sqf");
A3W_fnc_stickyCharges_actionSelect = STICKY_CHARGE_COMPILE("actionSelect.sqf");
A3W_fnc_stickyCharges_targetAllowed = STICKY_CHARGE_COMPILE("targetAllowed.sqf");
A3W_fnc_stickyCharges_drawSurfaceIcon = STICKY_CHARGE_COMPILE("drawSurfaceIcon.sqf");
A3W_fnc_stickyCharges_firedEvent = STICKY_CHARGE_COMPILE("firedEvent.sqf");
A3W_fnc_stickyCharges_keyDown = STICKY_CHARGE_COMPILE("keyDown.sqf");
A3W_fnc_stickyCharges_mouseButtonDown = STICKY_CHARGE_COMPILE("mouseButtonDown.sqf");

with uiNamespace do
{
	waitUntil {!isNull findDisplay 46};

	if (findDisplay 46 == uiNamespace getVariable ["A3W_stickyCharges_oldDisplay", displayNull]) then // editor shenanigans, display is not reset on restart
	{
		if (!isNil "A3W_stickyCharges_keyDown_ID") then { (findDisplay 46) displayRemoveEventHandler ["KeyDown", A3W_stickyCharges_keyDown_ID] };
		if (!isNil "A3W_stickyCharges_mouseButtonDown_ID") then { (findDisplay 46) displayRemoveEventHandler ["MouseButtonDown", A3W_stickyCharges_mouseButtonDown_ID] };
	};

	A3W_stickyCharges_keyDown_ID = (findDisplay 46) displayAddEventHandler ["KeyDown", missionNamespace getVariable "A3W_fnc_stickyCharges_keyDown"];
	A3W_stickyCharges_mouseButtonDown_ID = (findDisplay 46) displayAddEventHandler ["MouseButtonDown", missionNamespace getVariable "A3W_fnc_stickyCharges_mouseButtonDown"];
	A3W_stickyCharges_oldDisplay = findDisplay 46;
};

waitUntil {!isNull player};

// Fired event
_eventID = player getVariable "A3W_stickyCharges_firedEvent_ID";
if (!isNil "_eventID") then { player removeEventHandler ["Fired", _eventID] };

_eventID = player addEventHandler ["Fired", A3W_fnc_stickyCharges_firedEvent];
player setVariable ["A3W_stickyCharges_firedEvent_ID", _eventID];

inGameUISetEventHandler ["Action", "_this call A3W_fnc_stickyCharges_actionEvent"];
inGameUISetEventHandler ["PrevAction", "_this call A3W_fnc_stickyCharges_actionSelect"];
inGameUISetEventHandler ["NextAction", "_this call A3W_fnc_stickyCharges_actionSelect"];

// since inGameUI events are not stackable (yet), if you need to combine those with other functions, use || like this: "(_this call A3W_fnc_stickyCharges_actionEvent) || (_this call someOtherFunction)"
// of course, "someOtherFunction" must return a boolean; "true" blocks the action and "false" lets it pass.
