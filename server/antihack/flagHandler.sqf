
//	@file Version: 1.0
//	@file Name: flagHandler.sqf
//	@file Author: AgentRev
//	@file Created: 04/06/2013 21:31

if (typeName _this == "ARRAY" && {count _this > 4}) then
{
	private ["_sentChecksum"];
	_sentChecksum = _this select 4;

	if (_sentChecksum == _flagChecksum) then
	{
		private ["_playerName", "_playerID", "_hackType", "_hackValue"];
		
		_playerName = _this select 0;
		_playerID = _this select 1;
		_hackType = _this select 2;
		_hackValue = _this select 3;
		
		// Bug #8396 - serverCommand doesn't work for ARMA 3 as of 2013-05-16
		// serverCommand format ["#exec ban %1", _playerID]; 	 	
		// serverCommand format ["#kick %1", _playerID];
		
		sleep 0.5;
		
		[[format ["[ANTI-HACK] %1 is using cheating scripts. (%2)", _playerName, _hackType], _playerID, _flagChecksum], "chatBroadcast", true, false] call TPG_fnc_MP;
		diag_log format ["ANTI-HACK 0.8.0: %1 (%2) was detected for [%3] with the value [%4]", _playerName, _playerID, _hackType, _hackValue];
	};
};
