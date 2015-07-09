// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: setup.sqf
//	@file Author: AgentRev
//	@file Created: 07/06/2013 22:24

if (!isServer) exitWith {};

if (isNil "A3W_network_compileFuncs") then
{
	private ["_compileKey", "_assignCompileKey", "_packetKey", "_assignPacketKey", "_packetKeyArray", "_checksum", "_assignChecksum", "_checksumArray", "_rscList", "_rscParams", "_rscCfg", "_payload", "_externPayload"];

	_compileKey = call A3W_fnc_generateKey;

	_assignCompileKey = "";
	for "_x" from 0 to (floor random 50) do { _assignCompileKey = _assignCompileKey + " " };
	_assignCompileKey = _assignCompileKey + 'private "_compileKey";';
	for "_x" from 0 to (floor random 50) do { _assignCompileKey = _assignCompileKey + " " };
	for "_x" from 0 to (floor random 5) do { _assignCompileKey = _assignCompileKey + str floor random 10 + '=" private ""_compileKey""; call compile toString [' + str floor random 100 + '];";' };
	_assignCompileKey = _assignCompileKey + "call compile toString ";
	_compileKeyArray = "_compileKey = ";
	{
		if (_forEachIndex > 0) then { _compileKeyArray = _compileKeyArray + "+" };
		_compileKeyArray = _compileKeyArray + format ['"%1"', toString [_x]];
	} forEach toArray _compileKey;
	_assignCompileKey = _assignCompileKey + (str toArray _compileKeyArray) + "; ";

	_packetKey = call A3W_fnc_generateKey;

	_assignPacketKey = "";
	for "_x" from 0 to (floor random 50) do { _assignPacketKey = _assignPacketKey + " " };
	_assignPacketKey = _assignPacketKey + 'private "_mpPacketKey";';
	for "_x" from 0 to (floor random 50) do { _assignPacketKey = _assignPacketKey + " " };
	for "_x" from 0 to (floor random 5) do { _assignPacketKey = _assignPacketKey + str floor random 10 + '=" private ""_packetKey""; call compile toString [' + str floor random 100 + '];";' };
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
	for "_x" from 0 to (floor random 5) do { _assignChecksum = _assignChecksum + str floor random 10 + '=" private ""_checksum""; call compile toString [' + str floor random 100 + '];";' };
	_assignChecksum = _assignChecksum + "call compile toString ";
	_checksumArray = "_flagChecksum = ";
	{
		if (_forEachIndex > 0) then { _checksumArray = _checksumArray + "+" };
		_checksumArray = _checksumArray + format ['"%1"', toString [_x]];
	} forEach toArray _checksum;
	_assignChecksum = _assignChecksum + (str toArray _checksumArray) + "; ";

	_rscList = ["RscDisplayAVTerminal", "RscDisplayCommonHint", "RscDisplayCommonMessage", "RscDisplayCommonMessagePause", "RscDisplayConfigureAction", "RscDisplayConfigureControllers", "RscDisplayControlSchemes", "RscDisplayCustomizeController", "RscDisplayDebriefing", "RscDisplayDiary", "RscDisplayFieldManual", "RscDisplayGameOptions", "RscDisplayGetReady", "RscDisplayInsertMarker", "RscDisplayInterrupt", "RscDisplayInventory", "RscDisplayJoystickSchemes", "RscDisplayLoading", "RscDisplayLoadMission", "RscDisplayMainMap", "RscDisplayMicSensitivityOptions", "RscDisplayOptions", "RscDisplayOptionsAudio", "RscDisplayOptionsLayout", "RscDisplayOptionsVideo", "RscDisplayStart", "RscDisplayVehicleMsgBox", "RscDisplayVoiceChat"];
	_rscParams = [];

	{
		_rscCfg = configFile >> _x;

		if (isClass _rscCfg) then
		{
			_rscParams pushBack [_x, toArray getText (_rscCfg >> "onLoad"), toArray getText (_rscCfg >> "onUnload")];
		};
	} forEach _rscList;

	_payload = 0;
	_externPayload = preprocessFile (externalConfigFolder + "\antihack\payload.sqf");

	if (_externPayload == "") then
	{
		diag_log "ANTI-HACK: External payload unavailable, using internal payload";
	}
	else
	{
		diag_log "ANTI-HACK: Using external payload";
		_payload = compile _externPayload;
	};

	[_assignCompileKey, _assignChecksum, _assignPacketKey, str _rscParams, _payload] call compile preprocessFileLineNumbers "server\antihack\createUnit.sqf";
	waitUntil {!isNil {missionNamespace getVariable _compileKey}};

	diag_log "ANTI-HACK: Started.";
};
