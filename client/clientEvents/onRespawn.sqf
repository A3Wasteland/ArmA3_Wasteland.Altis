// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: onRespawn.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19
//	@file Args:

params ["_player", "_corpse"];

playerSetupComplete = false;
playerSpawning = true;

9999 cutText ["", "BLACK", 0.01];
9123 cutRsc ["RscEmpty", "PLAIN"];

_corpse setVariable ["newRespawnedUnit", _player, true];
_player setVariable ["playerSpawning", true, true];
_player setVariable ["A3W_oldCorpse", _corpse];

_this remoteExec ["A3W_fnc_playerRespawnServer", 2];

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
	private "_waterPos";
	if (surfaceIsWater _respawnPos) then
	{
		_top = +_respawnPos;
		_top set [2, (_top select 2) + 1000];
		_buildings = (lineIntersectsSurfaces [_top, _respawnPos, objNull, objNull, true, -1, "GEOM", "NONE"]) select {(_x select 2) isKindOf "Land_Pier_Box_F"};

		if !(_buildings isEqualTo []) then
		{
			_waterPos = _buildings select 0 select 0;
		};
	};
	if (isNil "_waterPos") then { _player setPos _respawnPos } else { _player setPosASL _waterPos };
};

_player call playerSetup;

//[] execVM "client\clientEvents\onMouseWheel.sqf";

call playerSpawn;

if !(pvar_PlayerTeamKiller isEqualTo []) then
{
	pDialogTeamkiller = pvar_PlayerTeamKiller;
	pvar_PlayerTeamKiller = [];

	[] execVM "client\functions\createTeamKillDialog.sqf";
};
