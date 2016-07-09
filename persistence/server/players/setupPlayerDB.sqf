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

"pvar_savePlayerData" addPublicVariableEventHandler
{
	(_this select 1) spawn
	{
		params ["_UID", "_info", "_data", "_player"];

		if (!isNull _player && alive _player && !(_player call A3W_fnc_isUnconscious)) then
		{
			_info append
			[
				["BankMoney", _player getVariable ["bmoney", 0]],
				["Bounty", _player getVariable ["bounty", 0]],
				["BountyKills", _player getVariable ["bountyKills", 0]]
			];

			[_UID, _info, _data] call fn_saveAccount;
		};

		if (!isNull _player && !alive _player) then
		{
			_UID call fn_deletePlayerSave;
		};
	};
};

"pvar_requestPlayerData" addPublicVariableEventHandler
{
	(_this select 1) spawn
	{
		params ["_player", "_UID"];
		_data = [_UID, _player] call fn_loadAccount;

		[[_this, _data],
		{
			params ["_pVal", "_data"];
			_pVal params ["_player", "_UID", "_pNetId"];

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

			diag_log format ["pvar_requestPlayerData: %1", [owner _player, _player, objectFromNetId _pNetId]];
		}] execFSM "call.fsm";
	};
};

"pvar_deletePlayerData" addPublicVariableEventHandler
{
	_player = param [1, objNull, [objNull]];

	if (isPlayer _player) then
	{
		(getPlayerUID _player) spawn fn_deletePlayerSave;
	};
};
