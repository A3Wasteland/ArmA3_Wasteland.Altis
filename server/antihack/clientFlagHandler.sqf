//	@file Version: 1.0
//	@file Name: clientFlagHandler.sqf
//	@file Author: AgentRev
//	@file Created: 014/07/2013 13:56

if (isDedicated) exitWith {};

if (typeName _this == "ARRAY" && {count _this > 1}) then
{
	private ["_sentChecksum", "_playerUID"];
	_playerUID = [_this, 0, "", [""]] call BIS_fnc_param;
	_sentChecksum = [_this, 1, "", [""]] call BIS_fnc_param;

	if (_sentChecksum == _flagChecksum && {_playerUID == getPlayerUID player}) then
	{
		waitUntil {time > 0.1};

		0.01 fadeSound 0;
		999999 cutText ["", "BLACK", 0.01];

		setPlayerRespawnTime 1e10;
		player setDamage 1;
		disableUserInput true;

		sleep 3;

		// baibai hacker
		call compile preprocessFile "client\functions\quit.sqf";
	};
};
