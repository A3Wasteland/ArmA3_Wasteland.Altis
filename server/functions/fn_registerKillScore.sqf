// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_registerKillScore.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

params [["_unit",objNull,[objNull]], ["_killer",objNull,[objNull]], ["_presumedKiller",objNull,[objNull]], ["_victimDisconnect",false,[false]]];

diag_log format ["A3W_fnc_registerKillScore: %1, registered: %2, isPlayer: %3, killerDead: %4, killerGroup: %5", _this, _unit getVariable ["A3W_killScoreRegistered", false], isPlayer _unit, !alive _killer && !isPlayer _killer, group _killer];

if !(_killer isKindOf "Man") then { _killer = effectiveCommander _killer };

if !(_unit getVariable ["A3W_killScoreRegistered", false]) then
{
	_unit setVariable ["A3W_killScoreRegistered", true];

	private _isPlayer = (isPlayer _unit || _victimDisconnect);
	private _killerMatch = (_killer == [_unit getVariable "FAR_killerUnit"] param [0,objNull,[objNull]] || _victimDisconnect);
	private _killerGroup = grpNull;
	private _friendlyFire = false;

	if (_killerMatch) then
	{
		_friendlyFire = [_unit getVariable "FAR_killerFriendly"] param [0,false,[false]];

		// killer has died, let's check if he has respawned
		if (!alive _killer && !isPlayer _killer) then
		{
			private _killerUID = [_unit getVariable "FAR_killerUID"] param [0,"",[""]];

			if !(_killerUID in ["","0"]) then
			{
				_killer = (allPlayers select {getPlayerUID _x isEqualTo _killerUID}) param [0, _killer];
			};
		};
	}
	else
	{
		_killerGroup = group _killer;
		_friendlyFire = [_killerGroup, _unit] call A3W_fnc_isFriendly;
	};

	if (_isPlayer) then
	{
		if (isPlayer _unit) then // false if alive on disconnect
		{
			[_unit, "deathCount", 1] call fn_addScore;
		}
		else
		{
			[_unit, true] call A3W_fnc_killBroadcast; // disconnected while injured, broadcast bleedout message, death score added in HandleDisconnect
		};
	};

	if (isPlayer _killer) then
	{
		if (!_killerMatch && isNull _killerGroup) exitWith {}; // we have no idea on which team the killer was when the kill occured, abort!

		private ["_scoreColumn", "_scoreValue"];

		if (_isPlayer) then
		{
			_scoreColumn = ["playerKills","teamKills"] select _friendlyFire;
			_scoreValue = 1;
		}
		else
		{
			_scoreColumn = "aiKills";
			_scoreValue = [1,0] select _friendlyFire;
		};

		[_killer, _scoreColumn, _scoreValue] call fn_addScore;

		if (isPlayer _presumedKiller && _presumedKiller != _unit) then // cancel score for presumed killer designated by game engine
		{
			[_presumedKiller, "playerKills", 0] call fn_addScore; // sync Steam score
		};
	};
};

_killer
