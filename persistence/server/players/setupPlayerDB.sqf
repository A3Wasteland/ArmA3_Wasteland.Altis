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

"pvar_savePlayerData" addPublicVariableEventHandler
{
	(_this select 1) spawn
	{
		_UID = _this select 0;
		_info = _this select 1;
		_data = _this select 2;
		_player = _this select 3;

		if (!isNull _player && alive _player && _player getVariable ["FAR_isUnconscious", 0] == 0) then
		{
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
		_player = _this select 0;
		_UID = _this select 1;
		_pNetId = _this select 2;

		_pvarName = "pvar_applyPlayerData_" + _UID;

		missionNamespace setVariable [_pvarName, _UID call fn_loadAccount];
		(owner _player) publicVariableClient _pvarName;

		diag_log format ["pvar_requestPlayerData: %1", [owner _player, _player, objectFromNetId _pNetId]];
	};
};

"pvar_deletePlayerData" addPublicVariableEventHandler { (_this select 1) spawn fn_deletePlayerSave };
