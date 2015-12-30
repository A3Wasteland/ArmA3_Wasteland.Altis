// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: compileFuncs.sqf
//	@file Author: AgentRev
//	@file Created: 04/01/2014 02:51

private ["_assignCompileKey", "_assignChecksum", "_assignPacketKey", "_rscParams", "_payload", "_compileKey", "_checksum", "_packetKey"];

_assignCompileKey = param [0, "", [""]];
_assignChecksum = param [1, "", [""]];
_assignPacketKey = param [2, "", [""]];
_rscParams = param [3, [], [[]]];
_payload = param [4, 0, [{}]];

_compileKey = call compile (_assignCompileKey + "_compileKey");
_checksum = call compile (_assignChecksum + "_flagChecksum");
_packetKey = call compile (_assignPacketKey + "_mpPacketKey");

//if (isNil {missionNamespace getVariable _compileKey}) then
//{
	{
		_func = _x select 0;
		_assign = _x select 1;
		_path = _x select 2;

		_finalVal = compileFinal (_assign + (preprocessFile _path));

		missionNamespace setVariable [_func, _finalVal];

		// Kick back to lobby if assignment fails
		if (!isServer && {str (missionNamespace getVariable [_func, ""]) != str _finalVal}) then
		{
			uiNamespace setVariable ["BIS_fnc_guiMessage_status", false];
			_msgBox = ["The antihack failed to compile.<br/>Please restart the game."] spawn BIS_fnc_guiMessage;
			_time = diag_tickTime;
			waitUntil {scriptDone _msgBox || diag_tickTime - _time >= 5};
			endMission "LOSER";
			waitUntil {uiNamespace setVariable ["BIS_fnc_guiMessage_status", false]; closeDialog 0; false};
		};
	}
	forEach
	[
		["A3W_fnc_MPexec", _assignPacketKey, "server\functions\network\fn_MPexec.sqf"],
		["A3W_fnc_MP", _assignPacketKey, "server\functions\network\fn_MP.sqf"],
		//["TPG_fnc_MP", _assignPacketKey, "server\functions\network\fn_MP.sqf"],
		["A3W_fnc_flagHandler", _assignChecksum, "server\antihack\flagHandler.sqf"],
		["A3W_fnc_clientFlagHandler", _assignChecksum, "server\antihack\clientFlagHandler.sqf"],
		["A3W_fnc_chatBroadcast", _assignChecksum, "server\antihack\chatBroadcast.sqf"],
		["A3W_fnc_adminMenuLog", _assignChecksum, "server\antihack\adminMenuLog.sqf"],
		["A3W_fnc_logMemAnomaly", _assignChecksum, "server\antihack\logMemAnomaly.sqf"],
		["notifyAdminMenu", _assignChecksum, "server\antihack\notifyAdminMenu.sqf"]
	];

	if (isServer) then
	{
		[_checksum] execVM "server\antihack\serverSide.sqf";
	};

	if (!isDedicated) then
	{
		if (typeName _payload == "CODE") then
		{
			[_checksum, _rscParams] spawn _payload;
		}
		else
		{
			[_checksum, _rscParams] execVM "server\antihack\payload.sqf";
		};
	};

	missionNamespace setVariable [_compileKey, compileFinal "true"];
//};

_packetKey addPublicVariableEventHandler A3W_fnc_MPexec;

if (isServer) then
{
	A3W_network_compileFuncs = compileFinal "true";
	publicVariable "A3W_network_compileFuncs";
};
