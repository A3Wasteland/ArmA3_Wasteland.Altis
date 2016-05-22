// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: preInit.sqf
//	@file Author: AgentRev

if (!hasInterface) exitWith {};

[] spawn
{
	waitUntil {!isNull player};
	[player, didJIP, hasInterface] remoteExecCall ["A3W_fnc_initPlayerServer", 2];
};
