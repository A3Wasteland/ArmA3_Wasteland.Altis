// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: teamKillUnlock.sqf
//	@file Author: AgentRev

private "_uid";
_uid = _this;

if (typeName _uid != "STRING" || {_uid in ["","0"]}) exitWith {};

[pvar_teamKillList, _uid] call fn_removeFromPairs;
publicVariable "pvar_teamKillList";
