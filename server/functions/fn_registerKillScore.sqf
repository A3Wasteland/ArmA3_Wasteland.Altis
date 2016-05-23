// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_registerKillScore.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

params [["_unit",objNull,[objNull]], ["_killer",objNull,[objNull]], ["_presumedKiller",objNull,[objNull]], ["_isPlayerBypass",false,[false]]];

if !(_killer isKindOf "Man") then { _killer = effectiveCommander _killer };

if !(_unit getVariable ["A3W_killScoreRegistered", false]) then
{
	_unit setVariable ["A3W_killScoreRegistered", true];

	private "_killerGroup";

	// killer has died, let's check if he has respawned
	if (!alive _killer && !isPlayer _killer) then
	{
		private _killerData = _unit getVariable ["FAR_killerPrimeSuspectData", []];
		private _killerUID = _killerData param [0,"",[""]];
		_killerGroup = _killerData param [1,grpNull,[grpNull]];

		if !(_killerUID in ["","0"]) then
		{
			_killer = (allPlayers select { getPlayerUID _x isEqualTo _killerUID }) param [0, _killer];
		};

		_unit setVariable ["FAR_killerPrimeSuspectData", nil, true];
	};

	if (isPlayer _killer) then
	{
		private ["_enemyKill", "_scoreColumn", "_scoreValue"];

		if (isNil "_killerGroup") then { _killerGroup = group _killer };
		if (isNull _killerGroup) exitWith {}; // we have no idea on which team the killer was when the kill occured, abort!

		_enemyKill = !([_killerGroup, _unit] call A3W_fnc_isFriendly);

		if (isPlayer _unit || _isPlayerBypass) then
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
