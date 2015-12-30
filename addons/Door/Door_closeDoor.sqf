// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: Door_lockDoor.sqf
//	@file Author: LouD / Cael817 for original script
//	@file Description: Door script

private ["_doors"];
_doors = (nearestObjects [player, ["Land_Canal_Wall_10m_F"], 10]);

if (!isNil "_doors") then
{
	{ [[netId _x, false], "A3W_fnc_hideObjectGlobal", _x] call A3W_fnc_MP } forEach _doors;
	hint "Your door is closed";
}
else 
{
	hint "No locked door found";
};