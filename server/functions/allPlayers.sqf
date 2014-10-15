//	@file Name: allPlayers.sqf
//	@file Author: AgentRev

// This function was created because playableUnits does not include dead players awaiting respawn

#define ADD_IF_PLAYER { if (isPlayer _x) then { _players pushBack _x } }

private "_players";
_players = [];

ADD_IF_PLAYER forEach playableUnits;
ADD_IF_PLAYER forEach allDeadMen;

_players
