//	@file Version: 1.0
//	@file Name: createUnit.sqf
//	@file Author: AgentRev
//	@file Created: 03/07/2013 20:49

if (!isServer) exitWith {};

private ["_packetKey", "_assignPacketKey", "_checksum", "_assignChecksum", "_varPayload", "_fastVarPayload", "_serverRules", "_init"];
_packetKey = _this select 0;
_assignPacketKey = _this select 1;
_checksum = _this select 2;
_assignChecksum = _this select 3;

_varPayload = preprocessFile "antihack\varPayload.sqf";
_fastVarPayload = preprocessFile "antihack\fastVarPayload.sqf";

_init = "[this, '" + _packetKey + "', '" + _assignPacketKey + "', '" + _checksum + "', '" + _assignChecksum + "', '" + _varPayload + "', '" + _fastVarPayload + "'] execVM 'server\antihack\manageUnit.sqf'";

"O_Soldier_F" createUnit [[0,0,0], createGroup civilian, _init, 0.5, "CORPORAL"];
