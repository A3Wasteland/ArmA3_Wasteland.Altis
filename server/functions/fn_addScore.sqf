// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_addScore.sqf
//	@file Author: AgentRev

private ["_player", "_column", "_score", "_var", "_val", "_grp", "_side"];

_player = _this select 0;
_column = _this select 1;
_score = _this select 2;

if (!isServer) exitWith
{
	pvar_updatePlayerScore = [_player, _column, _score];
	publicVariableServer "pvar_updatePlayerScore";
};

if (isPlayer _player) then
{
	_var = format ["A3W_playerScore_%1_%2", _column, getPlayerUID _player];
	_val = missionNamespace getVariable [_var, 0];

	missionNamespace setVariable [_var, _val + _score];
	publicVariable _var;

	// add kills and deaths to team score
	if (_column == "playerKills" || _column == "deathCount") then
	{
		_grp = group _player;
		_side = side _grp;

		if (_side in [BLUFOR,OPFOR]) then
		{
			_var = format ["A3W_teamScore_%1_%2", _column, _side];
			_val = missionNamespace getVariable [_var, 0];

			missionNamespace setVariable [_var, _val + _score];
			publicVariable _var;
		}
		else
		{
			_var = format ["A3W_teamScore_%1", _column];
			_val = _grp getVariable [_var, 0];

			_grp setVariable [_var, _val + _score, true];
		};
	};

	// sync Steam scoreboard
	_player addScore ((([_player, "playerKills", false] call fn_getScore) - ([_player, "teamKills", false] call fn_getScore)) - score _player);

	if (!isNil "_column" && !isNil "_score" && !isNil "fn_updateStats") then
	{
		// Log Scores to DB
		[getPlayerUID _player, _column, _score] call fn_updateStats;
	};
};
