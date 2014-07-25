//	@file Version: 1.0
//	@file Name: promotePlayer.sqf
//	@file Author: [501] His_Shadow
//	@file Created: 05/14/2013 01:54

#include "defines.hpp"

if(player != leader group player) exitWith {player globalChat format["you are not the leader and can't promote people"];};

#define groupManagementDialog 55510
#define groupManagementGroupList 55512

disableSerialization;

private["_dialog","_groupListBox","_playerListBox","_groupInvite","_target","_index","_playerData","_check","_unitCount","_isLeader","_side1","_side2","_dist","_do","_cont","_destPlayerUID","_msg"];

_dialog = findDisplay groupManagementDialog;
_groupListBox = _dialog displayCtrl groupManagementGroupList;

_index = lbCurSel _groupListBox;
_playerData = _groupListBox lbData _index;
_isLeader = false;
_check = 0;

//Check selected data is valid
{
	if (str(_x) == _playerData) then 
	{
		_target = _x;
		_check = 1;
	};
}forEach playableUnits;
diag_log "Promote to leader: Before the checks";

//Checks
_cont = 1;
if(_check == 0) then
{
	player globalChat "You must select someone to promote first.";
	_cont = 0;
};
if(_target == player) then 
{
	player globalChat "You can't promote yourself.";
	_cont = 0;
};

if(_cont == 1) then
{
	//setting up basic variables
	_side1 = side _target;
	_side2 = side _target;
	_dist = _target distance _target;
	_do = 1;
	//check to see how close to the enemy the target leader is
	{
		_side1 = side _x;
		_side2 = side _target;
		_dist = _x distance _target;
		_value = (_x in units group _target);

		if((_side1 != _side2) AND (_dist <=100)) then
		{
			_do = 0;
		};
	}forEach playableUnits;
		
	if(_do == 1) then
	{
		diag_log "Promote to leader: After the checks";
		[player] join grpNull;
		(group _target) selectLeader _target;
		[player] join (group _target);
		
		//notify the clients
		_destPlayerUID = getPlayerUID _target;
		_msg = "You have been promoted to group leader.";
		//if(X_Server) then {call serverRelayHandler};
		serverRelaySystem = [MESSAGE_BROADCAST_MSG_TO_PLAYER, MESSAGE_BROADCAST_MSG_TYPE_GCHAT, _destPlayerUID, _msg];
		publicVariable "serverRelaySystem";
		player globalChat format["You have promoted %1 to group leader",name _target];
	}
	else
	{
		player globalChat "This player is in combat. You can't make them leader.";
	};
};