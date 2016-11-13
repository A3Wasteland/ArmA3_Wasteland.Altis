// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: unLock.sqf
//	@file Author: LouD
//	@file Created: 15-08-2015

#define RADIUS 30
_objects = nearestObjects [position player, ["thingX", "Building", "ReammoBox_F"], RADIUS]; 
_unlockedObjects = {typeName _x == "OBJECT" && {!(_x getVariable ["objectLocked",false])}} count _objects;

_confirmMsg = format ["This will lock %1 base objects within %2m.<br/>(Doesn't always return true amount of objects)<br/>", _unlockedObjects, RADIUS];
_confirmMsg = _confirmMsg + format ["<br/>Unlock Objects?"];

if ([parseText _confirmMsg, "Confirm", "CONFIRM", true] call BIS_fnc_guiMessage) then
{
	{
		if !(_x getVariable ["objectLocked",false]) then
		{
			_x setVariable ["objectLocked", true, true];
			_x setVariable ["ownerUID", getPlayerUID player, true];

			pvar_manualObjectSave = netId _x;
			publicVariableServer "pvar_manualObjectSave";
		};
	} forEach _objects;
	hint format["You have locked all base objects within %1m of the area", RADIUS];
};