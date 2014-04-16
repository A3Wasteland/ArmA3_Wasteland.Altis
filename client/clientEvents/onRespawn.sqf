//	@file Version: 1.0
//	@file Name: onRespawn.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19
//	@file Args:

private ["_player", "_corpse", "_town", "_spawn", "_temp"];

playerSetupComplete = false;

_player = _this select 0;
_corpse = _this select 1;

_corpse removeAction playerMenuId;
{ _corpse removeAction _x } forEach aActionsIDs;
// The actions from mf_player_actions are removed in onKilled.

player call playerSetup;

[] execVM "client\clientEvents\onMouseWheel.sqf";

call playerSpawn;

if (isPlayer pvar_PlayerTeamKiller) then
{
	pDialogTeamkiller = pvar_PlayerTeamKiller;
	pvar_PlayerTeamKiller = objNull;

	[] execVM "client\functions\createTeamKillDialog.sqf";
};
