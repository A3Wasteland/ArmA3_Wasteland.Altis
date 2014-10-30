// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: createUnit.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

private ["_assignChecksum", "_assignPacketKey", "_init"];

_assignChecksum = [_this, 0, "", [""]] call BIS_fnc_param;
_assignPacketKey = [_this, 1, "", [""]] call BIS_fnc_param;

_init = "[this, ['" + _assignChecksum + "', '" + _assignPacketKey + "']] call compile preprocessFileLineNumbers 'server\antihack\manageUnit.sqf'";

"C_man_w_worker_F" createUnit [[0,0,0], createGroup sideLogic, _init];
