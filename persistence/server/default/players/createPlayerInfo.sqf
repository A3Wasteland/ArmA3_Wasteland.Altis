_player = _this;
_player_uid = getPlayerUID _player;

[_player_uid call PDB_playerFileName, "PlayerInfo", "UID", _player_uid] call PDB_write; // iniDB_write
[_player_uid call PDB_playerFileName, "PlayerInfo", "Name", name _player] call PDB_write; // iniDB_write

savedPlayerInfo = _player;
(owner _player) publicVariableClient "savedPlayerInfo";