//	@file Version: 1.0
//	@file Name: removeNegativeScore.sqf
//	@file Author: AgentRev
//	@file Created: 16/06/2013 12:34

private ["_player", "_scoreVar"];
_player = _this;

if (isPlayer _player) then
{
	_player addScore 2;
	
	if (isServer) then
	{
		compensateNegativeScore = _player;
		publicVariable "compensateNegativeScore";
		
		_scoreVar = "addScore_" + (getPlayerUID _player);
		
		if (isNil _scoreVar) then
		{
			call compile format ["%1 = 0", _scoreVar];
		};
		
		call compile format ["%1 = %1 + 2", _scoreVar];
		publicVariable _scoreVar;
	};
};
