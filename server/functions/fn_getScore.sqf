// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_getScore.sqf
//	@file Author: AgentRev

private ["_player", "_column", "_global", "_val", "_var"];

_player = _this select 0;
_column = _this select 1;
_global = param [2, true, [false]]; // if true (default) and extDB is enabled, returns all-time global score, otherwise returns score for current session
_val = 0;

if (!isNil "_player" && {isPlayer _player}) then
{
	_var = format ["A3W_playerScore_%1_%2", _column, getPlayerUID _player];
	_val = missionNamespace getVariable [_var, 0];

	if (_global) then
	{
		_val = _val + (missionNamespace getVariable [_var + "_global", 0]);
	};
};

_val
