//	@file Version: 1.0
//	@file Name: setup.sqf
//	@file Author: AgentRev
//	@file Created: 07/06/2013 22:24

if (!isServer) exitWith {};

if (isNil "ahSetupDone") then
{
	private ["_packetKey", "_assignPacketKey", "_packetKeyArray", "_checksum", "_assignChecksum", "_checksumArray", "_scriptHandle"];
	
	_packetKey = call generateKey;
	
	_assignPacketKey = "";
	for "_x" from 0 to (floor random 50) do { _assignPacketKey = _assignPacketKey + " " };
	_assignPacketKey = _assignPacketKey + 'private "_mpPacketKey";';
	for "_x" from 0 to (floor random 50) do { _assignPacketKey = _assignPacketKey + " " };
	_assignPacketKey = _assignPacketKey + "call compile toString ";
	_packetKeyArray = "_mpPacketKey = ";
	{
		if (_forEachIndex > 0) then { _packetKeyArray = _packetKeyArray + "+" };
		_packetKeyArray = _packetKeyArray + format ['"%1"', toString [_x]];
	} forEach toArray _packetKey;
	_assignPacketKey = _assignPacketKey + (str toArray _packetKeyArray) + "; ";
	
	_checksum = call generateKey;
	
	_assignChecksum = "";
	for "_x" from 0 to (floor random 50) do { _assignChecksum = _assignChecksum + " " };
	_assignChecksum = _assignChecksum + 'private "_flagChecksum";';
	for "_x" from 0 to (floor random 50) do { _assignChecksum = _assignChecksum + " " };
	_assignChecksum = _assignChecksum + "call compile toString ";
	_checksumArray = "_flagChecksum = ";
	{
		if (_forEachIndex > 0) then { _checksumArray = _checksumArray + "+" };
		_checksumArray = _checksumArray + format ['"%1"', toString [_x]];
	} forEach toArray _checksum;
	_assignChecksum = _assignChecksum + (str toArray _checksumArray) + "; ";
	
	TPG_fnc_MPexec = compileFinal (_assignPacketKey + (preprocessFileLineNumbers "server\antihack\remote\fn_MPexec.sqf"));
	TPG_fnc_MP = compileFinal (_assignPacketKey + (preprocessFileLineNumbers "server\antihack\remote\fn_MP.sqf"));
	call compile (_assignPacketKey + (preprocessFileLineNumbers "server\antihack\remote\fn_initMultiplayer.sqf"));
	
	flagHandler = compileFinal (_assignChecksum + (preprocessFileLineNumbers "server\antihack\flagHandler.sqf"));
	
	_scriptHandle = [_packetKey, _assignPacketKey, _checksum, _assignChecksum] execVM "server\antihack\createUnit.sqf";
	waitUntil {scriptDone _scriptHandle};
	
	if (loadFile "antihack\serverSide.sqf" != "") then
	{
		[] spawn compile (_assignChecksum + (preprocessFileLineNumbers "antihack\serverSide.sqf"));
	};
	
	LystoAntiAntiHack = compileFinal "false";
	AntiAntiAntiAntiHack = compileFinal "false";
	
	ahSetupDone = compileFinal "true";
	diag_log "ANTI-HACK 0.8.0: Started.";
};
