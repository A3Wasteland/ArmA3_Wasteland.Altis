//	@file Name: adminMenuLog.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

private ["_name", "_uid", "_action", "_value", "_sentChecksum"];

_sentChecksum = [_this, 4, "", [""]] call BIS_fnc_param;

if (_sentChecksum == _flagChecksum) then {
	_name = [_this, 0, "", [""]] call BIS_fnc_param;
	_uid = [_this, 1, "", [""]] call BIS_fnc_param;
	_action = [_this, 2, "", [""]] call BIS_fnc_param;
	_value = [_this, 3, "", [0,"",[]]] call BIS_fnc_param;

	["AdminLog2" call PDB_objectFileName, _uid + ".records", [_name, _action, _value]] call stats_push;

};
