// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: serverPlayerDied.sqf
//	@file Author: [404] Pulse, AgentRev
//	@file Created: 20/11/2012 05:19

if (!isServer) exitWith {};

private ["_unit", "_killer", "_presumedKiller", "_backpack"];

_unit = _this select 0;
_unit setVariable ["processedDeath", diag_tickTime];

// Remove player save on death
if (isPlayer _unit && {["A3W_playerSaving"] call isConfigOn}) then
{
	(getPlayerUID _unit) call fn_deletePlayerSave;
};

_killer = if (count _this > 1) then { _this select 1 } else { objNull };
_presumedKiller = if (count _this > 2) then { _this select 2 } else { objNull };

if !(_killer isKindOf "Man") then { _killer = effectiveCommander _killer };

// Score handling
if (isPlayer _killer) then
{
	_playerSide = side group _unit;
	_killerSide = side group _killer;
	_indyIndyKill = (_playerSide == _killerSide) && !(_playerSide in [BLUFOR,OPFOR]) && (group _unit != group _killer);

	_scoreColumn = if (isPlayer _unit) then { "playerKills" } else { "aiKills" };
	_scoreValue = if (_killerSide getFriend _playerSide < 0.6 || _indyIndyKill || (!isPlayer _unit && _playerSide == CIVILIAN)) then { 1 } else { -1 };

	[_killer, _scoreColumn, _scoreValue] call fn_addScore;

	if (isPlayer _presumedKiller && _presumedKiller != _unit) then
	{
		[_presumedKiller, "playerKills", 0] call fn_addScore; // sync Steam score
	};
};

if (isPlayer _unit) then
{
	[_unit, "deathCount", 1] call fn_addScore;
};

_backpack = unitBackpack _unit;

if (!isNull _backpack) then
{
	_backpack setVariable ["processedDeath", diag_tickTime];
};

// Eject corpse from vehicle once stopped
if (!isPlayer _unit && vehicle _unit != _unit) then
{
	_unit spawn
	{
		private "_veh";

		waitUntil
		{
			sleep 0.1;
			_veh = vehicle _this;
			(isTouchingGround _veh || (getPos _veh) select 2 < 5) && {vectorMagnitude velocity _veh < 5}
		};

		if (_veh != _this) then
		{
			_this setPos getPosATL _this; // ejects dead bodies
		};
	};
};

/*
{
	if (owner _x == owner _unit && {!isNil {_x getVariable "mf_item_id"}}) then
	{
		_x setVariable ["processedDeath", diag_tickTime]; // make separate PV event
	};
} forEach (_unit nearEntities ["All", 25]);
*/

if !(["G_Diving", goggles _unit] call fn_startsWith) then { removeGoggles _unit };
