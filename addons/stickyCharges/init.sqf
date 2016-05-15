// ****************************************************************************************
// * This addon is licensed under the GNU Lesser GPL v3. Copyright © 2016 A3Wasteland.com *
// ****************************************************************************************
//	@file Name: init.sqf
//	@file Author: AgentRev

// Sticky Charges addon v1.01 by AgentRev

// This addon can freely be integrated in any mission/mod outside of A3Wasteland, without the need to ask for permission, as long as LICENSE.txt is included in the addon folder.

// WARNING: This script uses inGameUISetEventHandler, which may cause conflicts with other scripts relying on that command, see bottom of file for more info

// If needed, BattleEye whitelist:
//	- setvariable.txt: !"^A3W_stickyCharges_"
//	- createvehicle.txt: !="Sign_Sphere10cm_F"

#include "defines.sqf" // adjust settings in there as needed!

#define STICKY_CHARGE_ADDON_ROOT "addons\stickyCharges" // mission folder path where this script is placed
#define STICKY_CHARGE_COMPILE compile // compile or compileFinal

if (isServer) then
{
	if (!isNil "A3W_stickyCharges_dummyCleanup") then { terminate A3W_stickyCharges_dummyCleanup };
	A3W_stickyCharges_dummyCleanup = execVM (STICKY_CHARGE_ADDON_ROOT + "\dummyCleanup.sqf");

	A3W_fnc_stickyCharges_disconnectCleanup = STICKY_CHARGE_COMPILE preprocessFileLineNumbers (STICKY_CHARGE_ADDON_ROOT + "\disconnectCleanup.sqf");
	["A3W_stickyCharges_disconnectCleanup", "onPlayerDisconnected", { _uid spawn A3W_fnc_stickyCharges_disconnectCleanup }] call BIS_fnc_addStackedEventHandler;
};

if (!hasInterface) exitWith {};


A3W_stickyCharges_surfaceIcon = getText (configfile >> "CfgInGameUI" >> "Cursor" >> "explosive");

A3W_fnc_stickyCharges_magNameAllowed = STICKY_CHARGE_COMPILE preprocessFileLineNumbers (STICKY_CHARGE_ADDON_ROOT + "\magNameAllowed.sqf");
A3W_fnc_stickyCharges_toggleSurfaceIcon = STICKY_CHARGE_COMPILE preprocessFileLineNumbers (STICKY_CHARGE_ADDON_ROOT + "\toggleSurfaceIcon.sqf");
A3W_fnc_stickyCharges_actionIntersect = STICKY_CHARGE_COMPILE preprocessFileLineNumbers (STICKY_CHARGE_ADDON_ROOT + "\actionIntersect.sqf");
A3W_fnc_stickyCharges_actionEvent = STICKY_CHARGE_COMPILE preprocessFileLineNumbers (STICKY_CHARGE_ADDON_ROOT + "\actionEvent.sqf");
A3W_fnc_stickyCharges_actionSelect = STICKY_CHARGE_COMPILE preprocessFileLineNumbers (STICKY_CHARGE_ADDON_ROOT + "\actionSelect.sqf");
A3W_fnc_stickyCharges_targetAllowed = STICKY_CHARGE_COMPILE preprocessFileLineNumbers (STICKY_CHARGE_ADDON_ROOT + "\targetAllowed.sqf");
A3W_fnc_stickyCharges_drawSurfaceIcon = STICKY_CHARGE_COMPILE preprocessFileLineNumbers (STICKY_CHARGE_ADDON_ROOT + "\drawSurfaceIcon.sqf");
A3W_fnc_stickyCharges_firedEvent = STICKY_CHARGE_COMPILE preprocessFileLineNumbers (STICKY_CHARGE_ADDON_ROOT + "\firedEvent.sqf");
A3W_fnc_stickyCharges_keyDown = STICKY_CHARGE_COMPILE preprocessFileLineNumbers (STICKY_CHARGE_ADDON_ROOT + "\keyDown.sqf");
A3W_fnc_stickyCharges_mouseButtonDown = STICKY_CHARGE_COMPILE preprocessFileLineNumbers (STICKY_CHARGE_ADDON_ROOT + "\mouseButtonDown.sqf");
A3W_fnc_stickyCharges_killedCleanup = STICKY_CHARGE_COMPILE preprocessFileLineNumbers (STICKY_CHARGE_ADDON_ROOT + "\killedCleanup.sqf");


if (!isNil "A3W_stickyCharges_drawSurfaceIcon_eventID") then { removeMissionEventHandler ["Draw3D", A3W_stickyCharges_drawSurfaceIcon_eventID] };
A3W_stickyCharges_drawSurfaceIcon_eventID = addMissionEventHandler ["Draw3D", A3W_fnc_stickyCharges_drawSurfaceIcon];


with uiNamespace do
{
	waitUntil {!isNull findDisplay 46};

	if (findDisplay 46 == uiNamespace getVariable ["A3W_stickyCharges_oldDisplay", displayNull]) then // editor shenanigans, display is not reset on restart
	{
		if (!isNil "A3W_stickyCharges_keyDown_eventID") then { (findDisplay 46) displayRemoveEventHandler ["KeyDown", A3W_stickyCharges_keyDown_eventID] };
		if (!isNil "A3W_stickyCharges_mouseButtonDown_eventID") then { (findDisplay 46) displayRemoveEventHandler ["MouseButtonDown", A3W_stickyCharges_mouseButtonDown_eventID] };
	};

	A3W_stickyCharges_keyDown_eventID = (findDisplay 46) displayAddEventHandler ["KeyDown", missionNamespace getVariable "A3W_fnc_stickyCharges_keyDown"];
	A3W_stickyCharges_mouseButtonDown_eventID = (findDisplay 46) displayAddEventHandler ["MouseButtonDown", missionNamespace getVariable "A3W_fnc_stickyCharges_mouseButtonDown"];
	A3W_stickyCharges_oldDisplay = findDisplay 46;
};


waitUntil {!isNull player};

// Fired event
_eventID = player getVariable "A3W_stickyCharges_fired_eventID";
if (!isNil "_eventID") then { player removeEventHandler ["Fired", _eventID] };

_eventID = player addEventHandler ["Fired", A3W_fnc_stickyCharges_firedEvent];
player setVariable ["A3W_stickyCharges_fired_eventID", _eventID];

// Killed event
_eventID = player getVariable "A3W_stickyCharges_killedCleanup_eventID";
if (!isNil "_eventID") then { player removeEventHandler ["Killed", _eventID] };

_eventID = player addEventHandler ["Killed", A3W_fnc_stickyCharges_killedCleanup];
player setVariable ["A3W_stickyCharges_killedCleanup_eventID", _eventID];


inGameUISetEventHandler ["Action", "_this call A3W_fnc_stickyCharges_actionEvent"];
inGameUISetEventHandler ["PrevAction", "_this call A3W_fnc_stickyCharges_actionSelect"];
inGameUISetEventHandler ["NextAction", "_this call A3W_fnc_stickyCharges_actionSelect"];

// since inGameUI events are not stackable (yet), if you need to combine those with other functions, use || like this: "(_this call A3W_fnc_stickyCharges_actionEvent) || (_this call someOtherFunction)"
// of course, "someOtherFunction" must return a boolean; "true" blocks the action and "false" lets it pass.
