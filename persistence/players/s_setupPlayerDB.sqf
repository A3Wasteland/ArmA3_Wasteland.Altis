// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: s_setupPlayerDB.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

fn_deletePlayerSave = "persistence\players\s_deletePlayerSave.sqf" call mf_compile;
fn_loadAccount = "persistence\players\s_loadAccount.sqf" call mf_compile;

"savePlayerData" addPublicVariableEventHandler
{
	_array = _this select 1;

	_UID = _array select 0;
	_info = _array select 1;
	_data = _array select 2;
	_player = _array select 3;

	if (!isNull _player && alive _player && _player getVariable ["FAR_isUnconscious", 0] == 0) then
	{
		{
			[_UID call PDB_playerFileName, "PlayerInfo", _x select 0, _x select 1] call PDB_write; // iniDB_write
		} forEach _info;

		{
			[_UID call PDB_playerFileName, "PlayerSave", _x select 0, _x select 1] call PDB_write; // iniDB_write
		} forEach _data;
	};

	if (!isNull _player && !alive _player) then
	{
		_UID call fn_deletePlayerSave;
	};
};

"requestPlayerData" addPublicVariableEventHandler
{
	_array = _this select 1;
	_player = _array select 0;
	_UID = _array select 1;
	_pNetId = _array select 2;

	if ((_UID call PDB_playerFileName) call PDB_exists) then // iniDB_exists
	{
		applyPlayerData = _UID call fn_loadAccount;
	}
	else
	{
		applyPlayerData = [];
	};

	(owner _player) publicVariableClient "applyPlayerData";

	diag_log format ["requestPlayerData: %1", [_player, owner _player, objectFromNetId _pNetId]];
};

"deletePlayerData" addPublicVariableEventHandler { (_this select 1) call fn_deletePlayerSave };
