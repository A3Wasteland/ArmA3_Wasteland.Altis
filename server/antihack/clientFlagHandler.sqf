
//	@file Version: 1.0
//	@file Name: clientFlagHandler.sqf
//	@file Author: AgentRev
//	@file Created: 014/07/2013 13:56

if (isDedicated) exitWith {};

if (typeName _this == "ARRAY" && {count _this > 1}) then
{
	private ["_sentChecksum", "_playerUID"];
	_playerUID = _this select 0;
	_sentChecksum = _this select 1;

	if (typeName _sentChecksum == typeName "" && {_sentChecksum == _flagChecksum} && {typeName _playerUID == typeName ""} && {getPlayerUID player == _playerUID}) then
	{
		waitUntil {time > 0.1};
		
		endMission "LOSER";
		
		for "_i" from 0 to 99 do
		{
			(findDisplay _i) closeDisplay 0;
		};
	};
};
