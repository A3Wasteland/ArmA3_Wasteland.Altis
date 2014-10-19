//	@file Name: fn_addScore.sqf
//	@file Author: AgentRev

private ["_player", "_column", "_score", "_var", "_val", "_grp", "_side"];

_player = _this select 0;
_column = _this select 1;
_score = _this select 2;

if (isPlayer _player) then
{
	_var = format ["A3W_playerScore_%1_%2", _column, getPlayerUID _player];
	_val = missionNamespace getVariable [_var, 0];

	missionNamespace setVariable [_var, _val + _score];
	publicVariable _var;

	if (isServer) then
	{
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
		_player addScore (([_player, "playerKills"] call fn_getScore) - score _player);
	};
};
