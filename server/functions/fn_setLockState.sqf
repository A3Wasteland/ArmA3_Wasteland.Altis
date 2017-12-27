// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_setLockState.sqf
//	@file Author: AgentRev

params [["_veh",objNull,[objNull,""]], ["_state",1,[0]]];

if (_veh isEqualType "") then { _veh = objectFromNetId _veh };

if (isNull _veh) exitWith {};
if (!local _veh) exitWith
{
	_this remoteExecCall ["A3W_fnc_setLockState", _veh];
};

_state = round _state max 1 min 3;
_veh lock _state;

// do not set ["R3F_LOG_disabled", true, true] on locked vehicles, so that their owner can still use R3F on them
if (_state < 2) then 
{
	_veh setVariable ["R3F_LOG_disabled", false, true];
};
