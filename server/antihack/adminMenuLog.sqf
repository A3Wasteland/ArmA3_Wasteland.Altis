// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
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

  private["_record"];
  _record = [
    ["name",_name],
    ["action",_action],
    ["value",_value]
  ];

	["AdminLog2" call PDB_adminLogFileName, _uid + ".records", (_record call sock_hash)] spawn stats_push;
};
