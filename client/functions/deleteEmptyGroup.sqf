// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: deleteEmptyGroup.sqf
//	@file Author: AgentRev

private "_grp";
_grp = _this;

if (typeName _grp != "GROUP" || {!local _grp}) exitWith {};

if (count units _grp == 0) then { deleteGroup _grp };
