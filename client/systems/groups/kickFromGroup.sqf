// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: kickFromGroup.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19

#define groupManagementDialog 55510
#define groupManagementGroupList 55512

disableSerialization;

private["_dialog","_playerListBox","_groupInvite","_target","_index","_playerData","_check","_group"];

_dialog = findDisplay groupManagementDialog;
_groupListBox = _dialog displayCtrl groupManagementGroupList;

_index = lbCurSel _groupListBox;
_playerData = _groupListBox lbData _index;

//Check selected data is valid
{ if (getPlayerUID _x == _playerData) exitWith { _target = _x } } forEach (call fn_allPlayers);

//Checks
if (isNil "_target") exitWith {player globalChat "you must select someone to kick first"};
if (_target == player) exitWith {player globalChat "you can't kick yourself"};

_group = group _target;
pvar_updateTerritoryMarkers = [_target, [_group getVariable ["currentTerritories", []], false, _group, false]];
publicVariable "pvar_updateTerritoryMarkers";
[_target] join grpNull;

_target setVariable ["currentGroupRestore", grpNull, true];
_target setVariable ["currentGroupIsLeader", false, true];

player globalChat format["you have kicked %1 from the group",name _target];
