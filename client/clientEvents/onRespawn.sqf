//	@file Version: 1.0
//	@file Name: onRespawn.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19
//	@file Args:

private ["_player", "_corpse", "_town", "_spawn", "_temp"];

playerSetupComplete = false;
9999 cutText ["", "BLACK", 0.01];

_player = _this select 0;
_corpse = _this select 1;

_player setVariable ["playerSpawning", true, true];

//_corpse removeAction playerMenuId;
{ _corpse removeAction _x } forEach aActionsIDs;
// The actions from mf_player_actions are removed in onKilled.

_group = _player getVariable ["currentGroupRestore", grpNull];

if (!isNull _group && {group _player != _group}) then
{
	[_player] join _group;
	
	if (_player getVariable ["currentGroupIsLeader", false] && leader _group != _player) then
	{
		_group selectLeader _player;
	};
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
