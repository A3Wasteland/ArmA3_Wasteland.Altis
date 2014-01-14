/*
	File: revive_RevivePlayer.sqf
	Orignal Author: Farooq
	Modified by Torndeco

	Description:
	Code is taken / based of FAAR Revive.
*/

private ["_target"];
_target = _this select 0;

if (alive _target) then
{
	player playMove "AinvPknlMstpSlayWrflDnon_medic";
	_target setVariable ["revive_isUnconscious", false, true];
	sleep 6;
};