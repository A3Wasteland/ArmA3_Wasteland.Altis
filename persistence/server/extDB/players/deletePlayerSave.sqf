//	@file Name: deletePlayerSave.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

_player_uid = _this;
[format["deletePlayerSave:%1:%2", _player_uid]] call extDB_async;