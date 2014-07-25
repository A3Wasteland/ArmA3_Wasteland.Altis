//	@file Version: 1.0
//	@file Name: playerSelectChange.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19
//	@file Args:

#define groupManagementDialog 55510
#define groupManagementPlayerList 55511
#define groupManagementInviteButton 55514

disableSerialization;

private["_dialog","_playerListBox","_groupInvite","_target","_index","_playerData","_check","_unitCount"];

_dialog = findDisplay groupManagementDialog;
_playerListBox = _dialog displayCtrl groupManagementPlayerList;
_groupInvite = _dialog displayCtrl groupManagementInviteButton;

_index = lbCurSel _playerListBox;
_playerData = _playerListBox lbData _index;
_check = 0;
			
{if (str(_x) == _playerData) then {_target = _x;_check = 1;};}forEach playableUnits;
if (_check == 0) exitWith{};

_unitCount = count units group _target;

if(_unitCount == 1) then
{
    if(player == leader group player) then
    {
    	if(isStreamFriendlyUIEnabled) then {
			_groupInvite ctrlShow false; //streamfriendly users cannot create groups themselves only accept invites
		} else {
			_groupInvite ctrlShow true;
		};
    } else {
		_groupInvite ctrlShow false;   
    };		    
} else {
	_groupInvite ctrlShow false;	    
};