// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: clientFlagHandler.sqf
//	@file Author: AgentRev
//	@file Created: 014/07/2013 13:56

if (isDedicated) exitWith {};

if (typeName _this == "ARRAY" && {count _this > 1}) then
{
	private ["_sentChecksum", "_playerUID"];
	_playerUID = param [0, "", [""]];
	_sentChecksum = param [1, "", [""]];

	if (_sentChecksum == _flagChecksum && {_playerUID == getPlayerUID player}) then
	{
		waitUntil {time > 0.1};

		disableUserInput true;
		setPlayerRespawnTime 1e11;

		if (damage player < 1) then // if check required to prevent "Killed" EH from getting triggered twice
		{
			player setVariable ["A3W_deathCause_local", ["forcekill"]];
			player setDamage 1;
		};

		1 fadeSound 0;
		sleep 1;

		0 fadeMusic 0;
		2 fadeMusic 1;
		playMusic "RadioAmbient1";

		1e11 cutText ["", "BLACK", 5];
		sleep 3;

		_dummyVar = "A3W_fnc_antihackLog_" + (random 1e11 toFixed 0);
		missionNamespace setVariable [_dummyVar, getPlayerUID player];
		publicVariableServer _dummyVar;

		sleep 1;
		call compile preprocessFile "client\functions\quit.sqf";
	};
};
