//	@file Name: setupPlayerDB.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

fn_deletePlayerSave = "persistence\server\default\players\deletePlayerSave.sqf" call mf_compile;
fn_loadAccount = "persistence\server\default\players\loadAccount.sqf" call mf_compile;


"savePlayerData" addPublicVariableEventHandler
{
	_array = _this select 1;

	_player = _array select  0;
	_player_uid = _array select 1;
	_player_lastgroupside = _array select 2;
	_player_lastplayerside = _array select 3;
	_player_bank = _array select 4;

	_data = _array select 5;


	if (!isNull _player && alive _player && _player getVariable ["FAR_isUnconscious", 0] == 0) then
	{
		[_player_uid call PDB_playerFileName, "PlayerInfo", "LastGroupSide", _player_lastgroupside] call PDB_write; // iniDB_write
		[_player_uid call PDB_playerFileName, "PlayerInfo", "LastPlayerSide", _player_lastplayerside] call PDB_write; // iniDB_write
		[_player_uid call PDB_playerFileName, "PlayerInfo", "BankMoney", _player_bank] call PDB_write; // iniDB_write

		{
			[_player_uid call PDB_playerFileName, "PlayerSave", _x select 0, _x select 1] call PDB_write; // iniDB_write
		} forEach _data;
	};

	if (!isNull _player && !alive _player) then
	{
		_player_uid call fn_deletePlayerSave;
	};
};

"requestPlayerData" addPublicVariableEventHandler
{
	_player = _this select 1;

	applyPlayerData = _player call fn_loadAccount;

	(owner _player) publicVariableClient "applyPlayerData";
};

"deletePlayerData" addPublicVariableEventHandler
{
	_player = _this select 1;
	(getPlayerUID _player) call fn_deletePlayerSave;
};