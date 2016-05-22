// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: unLock.sqf
//	@file Author: LouD
//	@file Created: 15-08-2015

_confirmMsg = format ["This will unlock all base objects within 15m<br/>"];
_confirmMsg = _confirmMsg + format ["<br/>Unlock Objects (15m)? "];

if ([parseText _confirmMsg, "Confirm", "CONFIRM", true] call BIS_fnc_guiMessage) then
{
	{
		if (_x getVariable ["objectLocked",false]) then
		{
			_x setVariable ["objectLocked", false, true];
		};
	} forEach (nearestObjects [position player, ["thingX", "Building", "ReammoBox_F"], 15]);
	hint format["You have unlocked all base objects within 15m of the area"];
};