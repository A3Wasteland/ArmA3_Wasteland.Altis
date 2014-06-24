//	@file Name: s_setupPlayerDB.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

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
			[_UID call PDB_databaseNameCompiler, "PlayerInfo", _x select 0, _x select 1] call iniDB_write;
		} forEach _info;

		{
			[_UID call PDB_databaseNameCompiler, "PlayerSave", _x select 0, _x select 1] call iniDB_write;
		} forEach _data;
	};

	if (!isNull _player && !alive _player) then
	{
		(_UID call PDB_databaseNameCompiler) call iniDB_delete;
	};
};

"requestPlayerData" addPublicVariableEventHandler
{
	_player = _this select 1;
	_UID = getPlayerUID _player;

	if ((_UID call PDB_databaseNameCompiler) call iniDB_exists) then
	{
		applyPlayerData = _UID call fn_loadAccount;
	}
	else
	{
		applyPlayerData = [];
	};

	(owner _player) publicVariableClient "applyPlayerData";
};

"deletePlayerData" addPublicVariableEventHandler
{
	_player = _this select 1;
	((getPlayerUID _player) call PDB_databaseNameCompiler) call iniDB_delete;
};
