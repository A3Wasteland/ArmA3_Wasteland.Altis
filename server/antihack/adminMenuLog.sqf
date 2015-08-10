// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: adminMenuLog.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

private ["_name", "_uid", "_action", "_value", "_sentChecksum"];

_sentChecksum = param [4, "", [""]];

if (_sentChecksum == _flagChecksum) then {
	_name = param [0, "", [""]];
	_uid = param [1, "", [""]];
	_action = param [2, "", [""]];
	_value = param [3, "", [0,"",[]]];

	private["_record"];
	_record = [
		["name",_name],
		["action",_action],
		["value",_value]
	];
  
	["AdminLog2" call PDB_adminLogFileName, _uid + ".records", (_record call sock_hash)] spawn stats_push;
};
