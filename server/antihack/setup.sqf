//	@file Version: 1.0
//	@file Name: setup.sqf
//	@file Author: AgentRev
//	@file Created: 07/06/2013 22:24

if (!isServer) exitWith {};

if (isNil "ahSetupDone") then
{
	private ["_packetKey", "_assignPacketKey", "_packetKeyArray", "_checksum", "_assignChecksum", "_checksumArray", "_networkCompile"];
	
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
	
	A3W_network_compileFuncs = compile ("['" + _assignChecksum + "','" + _assignPacketKey + "'] call compile preprocessFileLineNumbers 'server\antihack\compileFuncs.sqf'");
	_networkCompile = [] spawn A3W_network_compileFuncs;
	publicVariable "A3W_network_compileFuncs";
	waitUntil {sleep 0.1; scriptDone _networkCompile};
	
	"A3W_network_compileFuncs" addPublicVariableEventHandler { _this set [1, A3W_network_compileFuncs] };
	
	flagHandler = compileFinal (_assignChecksum + (preprocessFileLineNumbers "server\antihack\flagHandler.sqf"));
	[] spawn compile (_assignChecksum + (preprocessFileLineNumbers "server\antihack\serverSide.sqf"));
	
	LystoAntiAntiHack = compileFinal "false";
	AntiAntiAntiAntiHack = compileFinal "false";
	
	ahSetupDone = compileFinal "true";
	diag_log "ANTI-HACK 0.8.0: Started.";
};
