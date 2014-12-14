// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_updatePlayerScore.sqf
//	@file Author: AgentRev

private ["_player", "_column", "_score"];

_player = _this select 0;
_column = _this select 1;
_score = _this select 2;

// only allow reviveCount to be updated via pvar_updatePlayerScore
if (_column == "reviveCount") then
{
	[_player, _column, _score] call fn_addScore;
};
