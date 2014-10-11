//	@file Name: deletePlayerSave.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

_player_uid = _this;
[format["replacePlayerSave:%1:%2", call(A3W_extDB_PlayerSave_ServerID), _player_uid]] call extDB_Database_async;