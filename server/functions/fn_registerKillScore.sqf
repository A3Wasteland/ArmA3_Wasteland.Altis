// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_registerKillScore.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

params [["_unit",objNull,[objNull]], ["_killer",objNull,[objNull]], ["_presumedKiller",objNull,[objNull]]];

if !(_killer isKindOf "Man") then { _killer = effectiveCommander _killer };

if !(_unit getVariable ["A3W_killScoreRegistered", false]) then
{
	_unit setVariable ["A3W_killScoreRegistered", true];

	if (isPlayer _killer) then
	{
		private ["_enemyKill", "_scoreColumn", "_scoreValue"];
		_enemyKill = !([_killer, _unit] call A3W_fnc_isFriendly);

		if (isPlayer _unit) then
		{
			_scoreColumn = ["teamKills","playerKills"] select _enemyKill;
			_scoreValue = 1;
		}
		else
		{
			_scoreColumn = "aiKills";
			_scoreValue = [0,1] select _enemyKill;
		};

		[_killer, _scoreColumn, _scoreValue] call fn_addScore;

		if (isPlayer _presumedKiller && _presumedKiller != _unit) then
		{
			[_presumedKiller, "playerKills", 0] call fn_addScore; // sync Steam score
		};
	};
};

_killer
