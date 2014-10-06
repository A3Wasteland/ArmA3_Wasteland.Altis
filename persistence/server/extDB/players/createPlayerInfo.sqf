_player = _this;

[format["replacePlayerInfo:%1:%2", getPlayerUID _player, name _player], 2] call extDB_async;

savedPlayerInfo = _player;
(owner _player) publicVariableClient "savedPlayerInfo";