// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: s_setupPlayerDB.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

_playerFuncs = format ["persistence\server\players\%1", call A3W_savingMethodDir];

fn_deletePlayerSave = [_playerFuncs, "deletePlayerSave.sqf"] call mf_compile;
fn_loadAccount = [_playerFuncs, "loadAccount.sqf"] call mf_compile;
fn_saveAccount = [_playerFuncs, "saveAccount.sqf"] call mf_compile;
fn_getPlayerFlag = [_playerFuncs, "getPlayerFlag.sqf"] call mf_compile;
fn_updateStats = [_playerFuncs, "updateStats.sqf"] call mf_compile;
fn_logAntihack = [_playerFuncs, "logAntihack.sqf"] call mf_compile;
fn_logAdminMenu = [_playerFuncs, "logAdminMenu.sqf"] call mf_compile;
fn_logBankTransfer = [_playerFuncs, "logBankTransfer.sqf"] call mf_compile;
fn_kickPlayerIfFlagged = "persistence\server\players\fn_kickPlayerIfFlagged.sqf" call mf_compile;

A3W_fnc_checkPlayerFlag =
{
	params [["_player",objNull,[objNull]], ["_jip",true,[false]]];
	[0, getPlayerUID _player, name _player, _jip, owner _player] spawn fn_kickPlayerIfFlagged;
} call mf_compile;


A3W_fnc_savePlayerData =
{
	params [["_player",objNull,[objNull]], ["_info",[],[[]]], ["_data",[],[[]]]];

	if (!isPlayer _player) exitWith {};

	if (isRemoteExecuted && !(remoteExecutedOwner in [owner _player, clientOwner])) exitWith
	{
		["forged savePlayerData", [_player,_info,_data]] call A3W_fnc_remoteExecIntruder;
	};

	[_player, getPlayerUID _player, _info, _data] spawn
	{
		params ["_player", "_UID", "_info", "_data"];

		if (!isNull _player && alive _player && !(_player call A3W_fnc_isUnconscious)) then
		{
			_info append
			[
				["BankMoney", _player getVariable ["bmoney", 0]],
				["Bounty", _player getVariable ["bounty", 0]],
				["BountyKills", _player getVariable ["bountyKills", []]]
			];

			[_UID, _info, _data] call fn_saveAccount;
		};

		if (!isNull _player && !alive _player) then
		{
			_UID call fn_deletePlayerSave;
		};
	};
} call mf_compile;

A3W_fnc_requestPlayerData =
{
	params [["_player",objNull,[objNull]]];

	if (!isPlayer _player) exitWith {};

	if (isRemoteExecuted && !(remoteExecutedOwner in [owner _player, clientOwner])) exitWith
	{
		["forged requestPlayerData", _player] call A3W_fnc_remoteExecIntruder;
	};

	[_player, getPlayerUID _player] spawn
	{
		params ["_player", "_UID"];
		_data = [_UID, _player] call fn_loadAccount;

		[[_player, _UID, _data],
		{
			params ["_player", "_UID", "_data"];

			_pvarName = "pvar_applyPlayerData_" + _UID;

			missionNamespace setVariable [_pvarName, _data];
			(owner _player) publicVariableClient _pvarName;

			{
				_x params ["_var", "_val"];
				switch (_var) do
				{
					case "BankMoney":    { _player setVariable ["bmoney", _val, true] };
					case "Bounty":       { _player setVariable ["bounty", _val, true] };
					case "BountyKills":  { _player setVariable ["bountyKills", _val, true] };
				};
			} forEach _data;

			diag_log format ["pvar_requestPlayerData: %1", [owner _player, _player]];
		}] execFSM "call.fsm";
	};
} call mf_compile;

A3W_fnc_deletePlayerData =
{
	params [["_player",objNull,[objNull]]];

	if (!isPlayer _player) exitWith {};

	if (isRemoteExecuted && !(remoteExecutedOwner in [owner _player, clientOwner])) exitWith
	{
		["forged deletePlayerData", _player] call A3W_fnc_remoteExecIntruder;
	};

	(getPlayerUID _player) spawn fn_deletePlayerSave;
} call mf_compile;
