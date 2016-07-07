// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_deleteEmptyGroup.sqf
//	@file Author: AgentRev

params [["_grp",grpNull,[grpNull]]];

if (isNull _grp || {count units _grp > 0}) exitWith {};

if (local _grp) then
{
	deleteGroup _grp;
}
else
{
	_grp remoteExecCall ["deleteGroup", groupOwner _grp];
};
