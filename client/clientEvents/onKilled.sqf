// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: onKilled.sqf
//	@file Author: [404] Deadbeat, MercyfulFate, AgentRev
//	@file Created: 20/11/2012 05:19

_player = _this select 0;
_presumedKiller = effectiveCommander (_this select 1);
_killer = _player getVariable "FAR_killerPrimeSuspect";

if (isNil "_killer" && !isNil "FAR_findKiller") then { _killer = _player call FAR_findKiller };
if (isNil "_killer" || {isNull _killer}) then { _killer = _presumedKiller };
if (_killer == _player) then { _killer = objNull };

// GoT - create a R.I.P. marker (visible for the player only) to help locate it's body
createBodyMarker = 
{
	deleteMarkerLocal "deadMarker";
	_pos = getPos (vehicle player);
	_dMarker = createMarkerLocal ["deadMarker", _pos];
	_dMarker setMarkerShapeLocal "ICON";
	_dMarker setMarkerAlphaLocal 1;
	_dMarker setMarkerPosLocal _pos;
	_dMarker setMarkerTextLocal "R.I.P.";
	_dMarker setMarkerColorLocal "ColorBlue";
	_dMarker setMarkerTypeLocal "waypoint";
	_dMarker setMarkerSizeLocal [0.6,0.6];
	sleep 600;
	deleteMarkerLocal _dMarker;
};
[] spawn createBodyMarker;

[_player, _killer, _presumedKiller] spawn
{
	if (isServer) then
	{
		_this call server_PlayerDied;
	}
	else
	{
		PlayerCDeath = _this;
		publicVariableServer "PlayerCDeath";
	};
};

if (_player == player) then
{
	closeDialog 2001; // Close Gunstore
	closeDialog 2009; // Close Genstore
	closeDialog 5285; // Close Vehstore
	uiNamespace setVariable ["BIS_fnc_guiMessage_status", false]; // close message boxes

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
	//combatTimestamp = -1; // Reset abort timer
};

_player setVariable ["FAR_killerPrimeSuspect", nil];
_player setVariable ["FAR_killerVehicle", nil];
_player setVariable ["FAR_killerAmmo", nil];
_player setVariable ["FAR_killerSuspects", nil];

_player spawn
{
	_player = _this;

	_money = _player getVariable ["cmoney", 0];
	_player setVariable ["cmoney", 0, true];

	_items = [];
	{
		_id = _x select 0;
		_qty = _x select 1;
		_type = (_id call mf_inventory_get) select 4;

		_items pushBack [_id, _qty, _type];
		[_id, _qty] call mf_inventory_remove;
	} forEach call mf_inventory_all;

	pvar_dropPlayerItems = [_player, _money, _items];
	publicVariableServer "pvar_dropPlayerItems";
};

_player spawn fn_removeAllManagedActions;
removeAllActions _player;

// Same-side kills
if (_player == player && (playerSide == side group _killer) && (player != _killer) && (vehicle player != vehicle _killer)) then
{
	// Handle teamkills
	if (playerSide in [BLUFOR,OPFOR]) then
	{
		if (_killer isKindOf "CAManBase") then
		{
			pvar_PlayerTeamKiller = _killer;
		}
		else
		{
			pvar_PlayerTeamKiller = objNull;
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
