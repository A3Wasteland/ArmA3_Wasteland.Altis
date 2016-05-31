// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: updateTeamKiller.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19

if (_this < 2) exitWith
{
	call teamkillMessage;
};

pvar_teamSwitchUnlock = getPlayerUID player;
publicVariableServer "pvar_teamSwitchUnlock";

setPlayerRespawnTime 1e11;

if (damage player < 1) then // if check required to prevent "Killed" EH from getting triggered twice
{
	player setVariable ["A3W_deathCause_local", ["forcekill"]];
	player setDamage 1;
};

sleep 1;
9999 cutText ["", "BLACK", 3];
sleep 3;

uiNamespace setVariable ["BIS_fnc_guiMessage_status", false];
_msgBox = [localize "STR_WL_Punish_Teamkiller"] spawn BIS_fnc_guiMessage;
_time = diag_tickTime;

waitUntil {scriptDone _msgBox || diag_tickTime - _time >= 20};
endMission "LOSER";
waitUntil {uiNamespace setVariable ["BIS_fnc_guiMessage_status", false]; closeDialog 0; false};
