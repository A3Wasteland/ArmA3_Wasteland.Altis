//	@file Version: 1.0
//	@file Name: removeNegativeScore.sqf
//	@file Author: AgentRev
//	@file Created: 16/06/2013 12:34

private ["_player", "_scoreVar", "_scoreVal"];
_player = _this;

if (isPlayer _player) then
{
	_player addScore 2;
	
	/*
	if (isServer) then
	{
		compensateNegativeScore = _player;
		publicVariable "compensateNegativeScore";
		
		_scoreVar = "addScore_" + getPlayerUID _player;
		
		if (isNil _scoreVar) then
		{
			missionNamespace setVariable [_scoreVar, 0];
		};
		
		_scoreVal = missionNamespace getVariable [_scoreVar, 0];
		missionNamespace setVariable [_scoreVar, _scoreVal + 2];
		publicVariable _scoreVar;
	};
	*/
};
