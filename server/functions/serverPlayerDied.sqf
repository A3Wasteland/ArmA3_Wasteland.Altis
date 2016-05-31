// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: serverPlayerDied.sqf
//	@file Author: [404] Pulse, AgentRev
//	@file Created: 20/11/2012 05:19

if (!isServer) exitWith {};

params [["_unit",objNull,[objNull]], "", "", ["_deathCause",[],[[]]]]; // _unit, _killer, _presumedKiller, _deathCause

if (alive _unit) exitWith {};

_unit setVariable ["processedDeath", diag_tickTime];
_unit setVariable ["A3W_deathCause_local", _deathCause];

private _killer = (_this select [0,3]) call A3W_fnc_registerKillScore;

// Remove player save on death
if (isPlayer _unit && {["A3W_playerSaving"] call isConfigOn}) then
{
	(getPlayerUID _unit) call fn_deletePlayerSave;
};

private _backpack = unitBackpack _unit;

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
		_unit remoteExec ["fn_ejectCorpse", _unit];
	};
};

//if !(["G_Diving", goggles _unit] call fn_startsWith) then { removeGoggles _unit };
