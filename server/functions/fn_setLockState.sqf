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
_veh setVariable ["R3F_LOG_disabled", _state > 1, true];
