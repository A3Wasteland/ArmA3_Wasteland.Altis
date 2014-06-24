//	@file Name: switchMoveGlobal.sqf
//	@file Author: AgentRev

private ["_player", "_move"];
_player = _this select 0;
_move = _this select 1;

pvar_switchMoveGlobal = [_player, _move];
[] spawn { publicVariable "pvar_switchMoveGlobal" };

_player switchMove _move;
