// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: confirmSuicide.sqf
//	@file Author: AgentRev

if (!alive player) exitWith {};

if (["Are you sure you want to respawn?", "Confirm", true, true] call BIS_fnc_guiMessage) then
{
	player allowDamage true;

	if (damage player < 1) then // if check required to prevent "Killed" EH from getting triggered twice
	{
		player setVariable ["A3W_deathCause_local", ["bleedout"]];
		player setDamage 1;
	};
};
