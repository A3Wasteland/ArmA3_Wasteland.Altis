// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: teamSwitchLock.sqf
//	@file Author: AgentRev

private ["_uid", "_side"];
_uid = [_this, 0, "", [""]] call BIS_fnc_param;
_side = [_this, 1, sideUnknown, [sideUnknown]] call BIS_fnc_param;

if (_uid in ["","0"] || !(_side in [BLUFOR,OPFOR])) exitWith {};

[pvar_teamSwitchList, _uid, _side] call fn_setToPairs;
publicVariable "pvar_teamSwitchList";
