//	@file Version: 1.0
//	@file Name: setup.sqf
//	@file Author: AgentRev
//	@file Created: 07/06/2013 22:24

if (!isServer) exitWith {};

if (isNil "ahSetupDone") then
{
	private ["_packetKey", "_assignPacketKey", "_packetKeyArray", "_checksum", "_assignChecksum", "_checksumArray", "_networkCompile"];
	
	_packetKey = call A3W_fnc_generateKey;
	
	_assignPacketKey = "";
	for "_x" from 0 to (floor random 50) do { _assignPacketKey = _assignPacketKey + " " };
	_assignPacketKey = _assignPacketKey + 'private "_mpPacketKey";';
	for "_x" from 0 to (floor random 50) do { _assignPacketKey = _assignPacketKey + " " };
	for "_x" from 0 to (floor random 5) do { _assignPacketKey = _assignPacketKey + str floor random 10 + '=" private ""_packetKey""; call compile toString [' + str floor random 100 + ']; #linc 1 ""mpmissions\' + missionName + '""";' };
	_assignPacketKey = _assignPacketKey + "call compile toString ";
	_packetKeyArray = "_mpPacketKey = ";
	{
		if (_forEachIndex > 0) then { _packetKeyArray = _packetKeyArray + "+" };
		_packetKeyArray = _packetKeyArray + format ['"%1"', toString [_x]];
	} forEach toArray _packetKey;
	_assignPacketKey = _assignPacketKey + (str toArray _packetKeyArray) + "; ";
	
	_checksum = call A3W_fnc_generateKey;
	
	_assignChecksum = "";
	for "_x" from 0 to (floor random 50) do { _assignChecksum = _assignChecksum + " " };
	_assignChecksum = _assignChecksum + 'private "_flagChecksum";';
	for "_x" from 0 to (floor random 50) do { _assignChecksum = _assignChecksum + " " };
	for "_x" from 0 to (floor random 5) do { _assignChecksum = _assignChecksum + str floor random 10 + '=" private ""_checksum""; call compile toString [' + str floor random 100 + ']; #linc 1 ""mpmissions\' + missionName + '""";' };
	_assignChecksum = _assignChecksum + "call compile toString ";
	_checksumArray = "_flagChecksum = ";
	{
		if (_forEachIndex > 0) then { _checksumArray = _checksumArray + "+" };
		_checksumArray = _checksumArray + format ['"%1"', toString [_x]];
	} forEach toArray _checksum;
	_assignChecksum = _assignChecksum + (str toArray _checksumArray) + "; ";
	
	_networkFuncs = "['" + _assignChecksum + "','" + _assignPacketKey + "'] execVM 'server\antihack\compileFuncs.sqf'";
	A3W_network_compileFuncs = compileFinal _networkFuncs;
	_networkCompile = call A3W_network_compileFuncs;
	publicVariable "A3W_network_compileFuncs";
	waitUntil {sleep 0.1; scriptDone _networkCompile};
	
	LystoAntiAntiHack = compileFinal "false";
	AntiAntiAntiAntiHack = compileFinal "false";
	
	ahSetupDone = compileFinal "true";
	diag_log "ANTI-HACK: Started.";
};
