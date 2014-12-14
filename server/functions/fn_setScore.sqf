// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_setScore.sqf
//	@file Author: micovery

private ["_player", "_column", "_value", "_var"];

_player = _this select 0;
_column = _this select 1;
_value = _this select 2;

if (isNil "_player" || {not(isPlayer _player)}) exitWith {};

_var = format ["A3W_playerScore_%1_%2", _column, getPlayerUID _player];
missionNamespace setVariable [_var, _value];
publicVariable _var;



