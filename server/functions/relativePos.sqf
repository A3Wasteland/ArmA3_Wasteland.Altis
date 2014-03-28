//	@file Version: 1.0
//	@file Name: relativePos.sqf
//	@file Author: AgentRev
//	@file Created: 28/12/2013 17:44

private ["_unit", "_pos"];

_unit = _this select 0;
_pos = _this select 1;

[_unit call fn_getPos3D, [_pos, -(getDir _unit)] call BIS_fnc_rotateVector2D] call BIS_fnc_vectorAdd
