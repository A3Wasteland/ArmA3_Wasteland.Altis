//	@file Name: switchMoveGlobal.sqf
//	@file Author: AgentRev

private ["_player", "_move"];
_player = _this select 0;
_move = _this select 1;

switchMoveGlobal_var = [_player, _move];
publicVariable "switchMoveGlobal_var";

_player switchMove _move;
