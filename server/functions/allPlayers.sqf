//	@file Name: allPlayers.sqf
//	@file Author: AgentRev

// This function was created because playableUnits does not include dead players awaiting respawn

private ["_players", "_forCode"];

_players = [];
_forCode =
{
	if (isPlayer _x) then
	{
		_players set [count _players, _x];
	};
};

_forCode forEach playableUnits;
_forCode forEach allDeadMen;

_players
