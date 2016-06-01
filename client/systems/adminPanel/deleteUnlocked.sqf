// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: deleteUnlocked.sqf
//	@file Author: LouD
//	@file Created: 15-08-2015

_confirmMsg = format ["This will delete all unlocked (had to be locked first) base objects within 15m. This happens with a small delay so the admin will not be kicked for MaxDeleteVehiclePerInterval. Carefull this can also delete NPC's and other stuff.<br/>"];
_confirmMsg = _confirmMsg + format ["<br/>Delete Objects (15m)?"];

if ([parseText _confirmMsg, "Confirm", "CONFIRM", true] call BIS_fnc_guiMessage) then
{
	{
		if (!(_x getVariable ["objectLocked",false]) && !(_x getVariable ["R3F_LOG_Disabled", false])) then 
		{
			deleteVehicle _x;
			sleep 0.25;
		};
	} forEach (nearestObjects [position player, ["thingX", "Building", "ReammoBox_F"], 15]);
	hint format["You have deleted all unlocked base objects within 15m of the area"];
};