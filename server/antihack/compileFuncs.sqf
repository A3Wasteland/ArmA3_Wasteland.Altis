//	@file Version: 1.0
//	@file Name: compileFuncs.sqf
//	@file Author: AgentRev
//	@file Created: 04/01/2014 02:51

private ["_assignChecksum", "_assignPacketKey"];

_assignChecksum = [_this, 0, "", [""]] call BIS_fnc_param;
_assignPacketKey = [_this, 1, "", [""]] call BIS_fnc_param;

if (call compile (_assignChecksum + "isNil {missionNamespace getVariable _flagChecksum}")) then
{
	{
		_func = _x select 0;
		_assign = _x select 1;
		_path = _x select 2;

		_finalVal = compileFinal (_assign + (preprocessFileLineNumbers _path));

		missionNamespace setVariable [_func, _finalVal];

		// Kick back to lobby if assignment fails
		if (!isServer && {str (missionNamespace getVariable [_func, ""]) != str _finalVal}) then
		{
			uiNamespace setVariable ["BIS_fnc_guiMessage_status", false];
			_msgBox = ["The antihack failed to compile.<br/>Please restart the game."] spawn BIS_fnc_guiMessage;
			_time = diag_tickTime;
			waitUntil {scriptDone _msgBox || diag_tickTime - _time >= 5};
			waitUntil {closeDialog 0; !dialog};
			endMission "LOSER";
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
		["notifyAdminMenu", _assignChecksum, "server\antihack\notifyAdminMenu.sqf"]
	];

	if (isServer) then
	{
		[] spawn compile (_assignChecksum + (preprocessFileLineNumbers "server\antihack\serverSide.sqf"));
	};

	if (!isDedicated) then
	{
		[] spawn compile (_assignChecksum + (preprocessFileLineNumbers "server\antihack\payload.sqf"));
	};

	//call compile (_assignChecksum + "call compile format ['%1 = compileFinal str true', _flagChecksum]");
	call compile (_assignChecksum + "missionNamespace setVariable [_flagChecksum, compileFinal 'true']");
};

call compile (_assignPacketKey + "_mpPacketKey addPublicVariableEventHandler A3W_fnc_MPexec");
