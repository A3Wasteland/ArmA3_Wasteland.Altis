//	@file Version: 1.0
//	@file Name: onRespawn.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19
//	@file Args:

private ["_player", "_corpse"];

playerSetupComplete = false;

9999 cutText ["", "BLACK", 0.01];
9123 cutRsc ["RscEmpty", "PLAIN"];

_player = _this select 0;
_corpse = _this select 1;

_corpse setVariable ["newRespawnedUnit", _player, true];
_player setVariable ["playerSpawning", true, true];

_group = _player getVariable ["currentGroupRestore", grpNull];

if (!isNull _group && {group _player != _group}) then
{
	[_player] join _group;
	
	if (_player getVariable ["currentGroupIsLeader", false] && leader _group != _player) then
	{
		_group selectLeader _player;
	};
};

_respawnMarker = switch (playerSide) do
{
	case BLUFOR:      { "respawn_west" };
	case OPFOR:       { "respawn_east" };
	case INDEPENDENT: { "respawn_guerrila" };
	default           { "respawn_civilian" };
};

_respawnMarkers = [];
{
	if ([_respawnMarker, _x] call fn_startsWith) then
	{
		_respawnMarkers pushBack _x;
	};
} forEach allMapMarkers;

_respawnPos = markerPos (_respawnMarkers call BIS_fnc_selectRandom);

if !(_respawnPos isEqualTo [0,0,0]) then
{
	_player setPos _respawnPos;
};

_player call playerSetup;

//[] execVM "client\clientEvents\onMouseWheel.sqf";

call playerSpawn;

if (isPlayer pvar_PlayerTeamKiller) then
{
	pDialogTeamkiller = pvar_PlayerTeamKiller;
	pvar_PlayerTeamKiller = objNull;

	[] execVM "client\functions\createTeamKillDialog.sqf";
};
