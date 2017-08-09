// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: flagHandler.sqf
//	@file Author: AgentRev
//	@file Created: 04/06/2013 21:31

params [["_player",objNull,[objNull]], ["_hackType","",[""]], ["_hackValue",""], ["_sentChecksum","",[""]]];

if (!isPlayer _player) exitWith {};

private _playerName = name _player;
private _playerUID = getPlayerUID _player;

if (isRemoteExecuted && !(remoteExecutedOwner in [owner _player, clientOwner])) exitWith
{
	["forged evidence", [_playerName,_hackType,_hackValue]] call A3W_fnc_remoteExecIntruder;
};

if (_sentChecksum != _flagChecksum) exitWith {};

[_playerName, _playerUID, _hackType, _hackValue, _flagChecksum] spawn
{
	params ["_playerName", "_playerUID", "_hackType", "_hackValue", "_flagChecksum"];
	sleep 0.5;

	[format ["[ANTI-HACK] %1 was caught cheating (%2)", _playerName, _hackType], _playerUID, _flagChecksum] remoteExec ["A3W_fnc_chatBroadcast"];
	diag_log format ["ANTI-HACK: %1 (%2) was detected for [%3] with the value [%4]", _playerName, _playerUID, _hackType, _hackValue];

	if (!isNil "fn_logAntihack") then
	{
		[_playerUID, _playerName, _hackType, _hackValue] call fn_logAntihack;
	};
};
