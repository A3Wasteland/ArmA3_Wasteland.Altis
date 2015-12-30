// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright � 2014 	BadVolt 	*
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: password_enter.sqf
//	@file Author: LouD (Original author: BadVolt)
//	@file Description: Entering password and opens vPin

_object = cursorTarget;

OutputText = nil;

createDialog "AF_Keypad";

waitUntil {!(isNil "OutputText")};

if (OutputText == _object getVariable ["password", ""]) then 
{
	execVM "addons\vPin\vPin_ownerMenu.sqf";	
}
else
{
	["Wrong PIN!", 5] call mf_notify_client;	
};

OutputText = nil;