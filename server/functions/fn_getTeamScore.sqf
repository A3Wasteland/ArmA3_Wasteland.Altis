//	@file Name: fn_getTeamScore.sqf
//	@file Author: AgentRev

private ["_player", "_column", "_val", "_var"];

_team = [_this, 0, sideUnknown, [sideUnknown,grpNull]] call BIS_fnc_param;
_column = _this select 1;
_val = 0;


if !(_team isEqualTo sideUnknown || _team isEqualTo grpNull) then
{
	if (_column == "territoryCount") then
	{
		if (!isNil "A3W_currentTerritoryOwners") then
		{
			_val = {(_x select 1) isEqualTo _team} count A3W_currentTerritoryOwners;
		};
	}
	else
	{
		if (typeName _team == "GROUP") then
		{
			_var = format ["A3W_teamScore_%1", _column];
			_val = _team getVariable [_var, 0];
		}
		else
		{
			_var = format ["A3W_teamScore_%1_%2", _column, _team];
			_val = missionNamespace getVariable [_var, 0];
		};
	};
};

_val
