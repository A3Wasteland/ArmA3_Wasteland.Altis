//	@file Name: teamSwitchUnlock.sqf
//	@file Author: AgentRev

private "_uid";
_uid = _this;

if (typeName _uid != "STRING" || {_uid in ["","0"]}) exitWith {};

[pvar_teamKillList, _uid] call fn_removeFromPairs;
publicVariable "pvar_teamKillList";
