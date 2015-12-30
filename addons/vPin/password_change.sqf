// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 	BadVolt 	*
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: password_change.sqf
//	@file Author: LouD (Original author: BadVolt)
//	@file Description: Changes password for and locks all vPins.

_object = cursorTarget;

OutputText = nil;

createDialog "AF_Keypad";

waitUntil {!(isNil "OutputText")};

_object setVariable ["password", OutputText, true];

if (OutputText=="")then 
{
	["PIN lock disabled.", 5] call mf_notify_client;	
}
else
{
	["You successfully changed the PIN", 5] call mf_notify_client;	
};	

pvar_manualVehicleSave = netId _object; 
publicVariableServer "pvar_manualVehicleSave";

OutputText = nil;