// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: onKilled.sqf
//	@file Author: [404] Deadbeat, MercyfulFate, AgentRev
//	@file Created: 20/11/2012 05:19

params ["_player", "_presumedKiller"];

_presumedKiller = effectiveCommander _presumedKiller;
_killer = _player getVariable "FAR_killerPrimeSuspect";

if (isNil "_killer" && !isNil "FAR_findKiller") then { _killer = _player call FAR_findKiller };
if (isNil "_killer" || {isNull _killer}) then { _killer = _presumedKiller };

_killer = effectiveCommander _killer;
_deathCause = _player getVariable ["A3W_deathCause_local", []];

if (_killer == _player) then
{
	if (_deathCause isEqualTo []) then
	{
		_deathCause = [["suicide","drown"] select (getOxygenRemaining _player <= 0 && (getPos _player) select 2 < 0), serverTime];
		_player setVariable ["A3W_deathCause_local", _deathCause];
	};

	_killer = objNull;
};

[_player, _killer, _presumedKiller, _deathCause] remoteExecCall ["A3W_fnc_serverPlayerDied", 2];
[0, _player, _killer, [_killer, _player] call A3W_fnc_isFriendly] call A3W_fnc_deathMessage;

if (_player == player) then
{
	(findDisplay 2001) closeDisplay 0; // Close Gunstore
	(findDisplay 2009) closeDisplay 0; // Close Genstore
	(findDisplay 5285) closeDisplay 0; // Close Vehstore
	(findDisplay 63211) closeDisplay 0; // Close ATM
	uiNamespace setVariable ["BIS_fnc_guiMessage_status", false]; // close message boxes
	closeDialog 0;

	// Load scoreboard in render scope
	["A3W_scoreboard", "onEachFrame",
	{
		call loadScoreboard;
		["A3W_scoreboard", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
	}] call BIS_fnc_addStackedEventHandler;

	if (!isNil "savePlayerHandle" && {typeName savePlayerHandle == "SCRIPT" && {!scriptDone savePlayerHandle}}) then
	{
		terminate savePlayerHandle;
	};

	playerData_infoPairs = nil;
	playerData_savePairs = nil;
	combatTimestamp = -1; // Reset abort timer
};

diag_log format ["KILLED by %1", if (isPlayer _killer) then { "player " + str [name _killer, getPlayerUID _killer] } else { _killer }];

_player setVariable ["FAR_killerPrimeSuspect", nil];
_player setVariable ["FAR_killerVehicle", nil];
_player setVariable ["FAR_killerAmmo", nil];
_player setVariable ["FAR_killerSuspects", nil];

_player spawn
{
	_player = _this;

	_money = _player getVariable ["cmoney", 0];
	_player setVariable ["cmoney", 0, true];

	_items = if (_player == player) then { true call mf_inventory_list } else { [] };

	pvar_dropPlayerItems = [_player, _money, _items];
	publicVariableServer "pvar_dropPlayerItems";

	if (_player == player) then
	{
		{ _x call mf_inventory_remove } forEach _items;
	};
};

_player spawn fn_removeAllManagedActions;
removeAllActions _player;

// Same-side kills
if (_player == player && (playerSide == side group _killer) && (player != _killer) && (vehicle player != vehicle _killer)) then
{
	// Handle teamkills
	if (playerSide in [BLUFOR,OPFOR]) then
	{
		if (_killer isKindOf "Man" && isPlayer _killer) then
		{
			pvar_PlayerTeamKiller = [_killer, getPlayerUID _killer, name _killer];
		}
		else
		{
			pvar_PlayerTeamKiller = [];
		};
	}
	else // Compensate negative score for indie-indie kills
	{
		if (isPlayer _killer) then
		{
			pvar_removeNegativeScore = _killer;
			publicVariableServer "pvar_removeNegativeScore";
		};
	};
};
