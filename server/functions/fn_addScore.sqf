// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_addScore.sqf
//	@file Author: AgentRev

params [["_player",objNull,[objNull,""]], ["_column","",[""]], ["_score",0,[0]], ["_group",grpNull,grpNull]];

if (_column isEqualTo "") exitWith {};

private ["_isUnit", "_uid", "_var", "_val", "_side"];

if (!isServer) exitWith
{
	pvar_updatePlayerScore = _this;
	publicVariableServer "pvar_updatePlayerScore";
};

_isUnit = _player isEqualType objNull;

if ((_isUnit && {isPlayer _player}) || {!_isUnit && !(_player in ["","0"])}) then
{
	_uid = if (_isUnit) then { getPlayerUID _player } else { _player };

	_var = format ["A3W_playerScore_%1_%2", _column, _uid];
	_val = missionNamespace getVariable [_var, 0];

	missionNamespace setVariable [_var, _val + _score];
	publicVariable _var;

	// add kills and deaths to team score
	if (_column == "playerKills" || _column == "deathCount") then
	{
		if (_isUnit) then { _group = group _player };
		_side = side _group;

		if (_side in [BLUFOR,OPFOR]) then
		{
			_var = format ["A3W_teamScore_%1_%2", _column, _side];
			_val = missionNamespace getVariable [_var, 0];

			missionNamespace setVariable [_var, _val + _score];
			publicVariable _var;
		}
		else
		{
			if (!isNull _group) then
			{
				_var = format ["A3W_teamScore_%1", _column];
				_val = _group getVariable [_var, 0];

				_group setVariable [_var, _val + _score, true];
			};
		};
	};

	// sync Steam scoreboard
	if (_isUnit) then
	{
		_player addScore ((([_player, "playerKills", false] call fn_getScore) - ([_player, "teamKills", false] call fn_getScore)) - score _player);
	};

	if (_score != 0 && !isNil "fn_updateStats") then
	{
		// Log Scores to DB
		[_uid, _column, _score] call fn_updateStats;
	};
};
