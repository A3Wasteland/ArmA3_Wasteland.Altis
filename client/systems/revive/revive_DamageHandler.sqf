/*
	File: revive_DamageHandler.sqf
	Orignal Author: Farooq
	Modified by Torndeco

	Description:
	Override Player DamageHandler to make player unconcious.
	Code is taken / based of FAAR Revive.

	TODO:
	Add + test higher cutoff for Damage values, so lethal non-head shots will kill players straight away.
*/

private ["_unit", "_hitpart", "_damage", "_killer", "_amountOfDamage", "_isUnconscious"];

_unit = _this select 0;
_hitpart = _this select 1;
_damage = _this select 2;
_killer = _this select 3;

_isUnconscious = _unit getVariable["revive_isUnconscious", false];

if ((alive _unit) && (_damage >= 1) && (!_isUnconscious) && (_hitpart != "head")) then
{
	_unit allowDamage false;

	[_unit, _killer] spawn revive_Unconscious;
	_damage = 0;
};

_damage