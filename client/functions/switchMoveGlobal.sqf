//	@file Name: switchMoveGlobal.sqf
//	@file Author: AgentRev

private ["_unit", "_move"];
_unit = _this select 0;
_move = _this select 1;

if (isNil "_unit" || isNil "_move" || {typeName _unit != "OBJECT" || typeName _move != "STRING"}) exitWith {};

pvar_switchMoveGlobal = [_unit, _move];
publicVariable "pvar_switchMoveGlobal";

_unit switchMove _move;
