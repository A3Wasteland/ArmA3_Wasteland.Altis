// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: serverPlayerDied.sqf
//	@file Author: [404] Pulse, AgentRev
//	@file Created: 20/11/2012 05:19

if (!isServer) exitWith {};

private ["_unit", "_killer", "_presumedKiller", "_scoreColumn", "_scoreValue", "_backpack"];

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
if (vehicle _unit != _unit) then
{
	if (local _unit) then
	{
		_unit spawn fn_ejectCorpse;
	}
	else
	{
		pvar_ejectCorpse = _unit;
		(owner _unit) publicVariableClient "pvar_ejectCorpse";
	};
};

if !(["G_Diving", goggles _unit] call fn_startsWith) then { removeGoggles _unit };
