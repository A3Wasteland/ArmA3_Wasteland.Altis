//	@file Version: 1.0
//	@file Name: promotePlayer.sqf
//	@file Author: [501] His_Shadow
//	@file Created: 05/14/2013 01:54

#include "defines.hpp"

if(player != leader group player) exitWith {player globalChat format["you are not the leader and can't promote people"];};

#define groupManagementDialog 55510
#define groupManagementGroupList 55512

disableSerialization;

private ["_dialog", "_groupListBox", "_target", "_index", "_playerData", "_allPlayers", "_inCombat", "_isIndie"];

_dialog = findDisplay groupManagementDialog;
_groupListBox = _dialog displayCtrl groupManagementGroupList;

_index = lbCurSel _groupListBox;
_playerData = _groupListBox lbData _index;

_allPlayers = call allPlayers;

//Check selected data is valid
{ if (getPlayerUID _x == _playerData) exitWith { _target = _x } } forEach _allPlayers;
//diag_log "Promote to leader: Before the checks";

//Checks
if (isNil "_target") exitWith { player globalChat "You must select someone to promote first." };

if (_target == player) exitWith { player globalChat "You can't promote yourself." };

_inCombat = false;
_isIndie = !((side group _target) in [BLUFOR,OPFOR]);

//check to see how close to the enemy the target leader is
{
	if (_x distance _target < 100 && (side group _x != side group _target || (_isIndie && group _x != group _target))) exitWith
	{
		_inCombat = true;
	};
} forEach _allPlayers;

if (!_inCombat) then
{
	(group player) selectLeader _target;
	["You have been promoted to group leader.", "titleTextMessage", _target] call TPG_fnc_MP;

	player globalChat format ["You have promoted %1 to group leader", name _target];
	player setVariable ["currentGroupIsLeader", false, true];
	_target setVariable ["currentGroupIsLeader", true, true];
}
else
{
	player globalChat "This player is in combat. You can't make it leader right now";
};
