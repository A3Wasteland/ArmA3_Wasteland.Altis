//	@file Version: 1.0
//	@file Name: kickFromGroup.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19

#define groupManagementDialog 55510
#define groupManagementGroupList 55512

disableSerialization;

private["_dialog","_playerListBox","_groupInvite","_target","_index","_playerData","_check","_unitCount"];

_dialog = findDisplay groupManagementDialog;
_groupListBox = _dialog displayCtrl groupManagementGroupList;

_index = lbCurSel _groupListBox;
_playerData = _groupListBox lbData _index;
_check = 0;

//Check selected data is valid            			
{if (str(_x) == _playerData) then {_target = _x;_check = 1;};}forEach playableUnits;

//Checks
if(_target == player) exitWith {player globalChat "you can't kick yourself";};
if (_check == 0) exitWith {player globalChat "you must select someone to kick first";};

[_target] join grpNull;

player globalChat format["you have kicked %1 from the group",name _target];