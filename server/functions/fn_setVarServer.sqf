// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2017 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_setVarServer.sqf
//	@file Author: AgentRev

params [["_obj",objNull,[objNull]], ["_pairs",[],[[]]], ["_mode",1,[0]]];

// _mode: 0 = server local, 1 = client local + server local, 2 = client local + server global

if (isNull _obj || (!isServer && !local _obj) || (isServer && isRemoteExecuted && !(remoteExecutedOwner in [owner _obj, clientOwner]))) exitWith {};

if (!isServer) then
{
	_this remoteExecCall ["A3W_fnc_setVarServer", 2];
};

if (!isServer && _mode == 0) exitWith {};

private _global = (isServer && _mode == 2);

{
	_x params ["_var","_val"];
	_obj setVariable [_var, if (isNil "_val") then { nil } else { _val }, _global];
} forEach _pairs;
