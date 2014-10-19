//	@file Name: deleteEmptyGroup.sqf
//	@file Author: AgentRev

private "_grp";
_grp = _this;

if (typeName _grp != "GROUP" || {!local _grp}) exitWith {};

if (count units _grp == 0) then { deleteGroup _grp };
