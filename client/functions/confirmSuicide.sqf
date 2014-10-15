//	@file Name: confirmSuicide.sqf
//	@file Author: AgentRev

if (!alive player) exitWith {};

if (["Are you sure you want to suicide?", "Confirm", "Yes", true] call BIS_fnc_guiMessage) then
{
	player allowDamage true;
	player setDamage 1;
};
