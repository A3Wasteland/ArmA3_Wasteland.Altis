//	@file Version: 1.0
//	@file Name: promotePlayer.sqf
//	@file Author: [501] His_Shadow
//	@file Created: 05/14/2013 01:54

#include "defines.hpp"

if(player != leader group player) exitWith {player globalChat format["you are not the leader and can't promote people"];};

#define groupManagementDialog 55510
#define groupManagementGroupList 55512

disableSerialization;

private["_dialog","_groupListBox","_playerListBox","_groupInvite","_target","_index","_playerData","_check","_unitCount","_isLeader","_side1","_side2","_dist","_inCombat","_cont","_destPlayerUID","_msg"];

_dialog = findDisplay groupManagementDialog;
_groupListBox = _dialog displayCtrl groupManagementGroupList;

_index = lbCurSel _groupListBox;
_playerData = _groupListBox lbData _index;

//Check selected data is valid
{ if (getPlayerUID _x == _playerData) exitWith { _target = _x } } forEach playableUnits;
//diag_log "Promote to leader: Before the checks";

//Checks
if (isNil "_target") exitWith { player globalChat "You must select someone to promote first." };

if (_target == player) exitWith { player globalChat "You can't promote yourself." };


//check to see how close to the enemy the target leader is
{
	if (_dist < 100 && (side _x != side _target || group _x != group _target)) exitWith
	{
		_inCombat = true;
	};
}forEach playableUnits;

if (!_inCombat) then
{
	//diag_log "Promote to leader: After the checks";
	promoteToGroupLeader = _target;
	publicVariable "promoteToGroupLeader";
	
	//notify the clients
	//if(X_Server) then {call serverRelayHandler};
	//serverRelaySystem = [MESSAGE_BROADCAST_MSG_TO_PLAYER, MESSAGE_BROADCAST_MSG_TYPE_GCHAT, getPlayerUID _target, "You have been promoted to group leader."];
	//publicVariable "serverRelaySystem";
	player globalChat format ["You have promoted %1 to group leader", name _target];
	//player setVariable ["currentGroupIsLeader", false, true];
	//_target setVariable ["currentGroupIsLeader", true, true];
}
else
{
	player globalChat "This player is in combat. You can't make it leader right now";
};
