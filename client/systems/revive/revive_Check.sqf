/*
	File: revive_Check.sqf
	Orignal Author: Farooq
	Modified by Torndeco

	Description:
	Checks if Player Target is isUnconscious.
	Code is taken / based of FAAR Revive.
*/

private ["_target"];

_target = cursorTarget;
_return = false;

if( (isNil "_target") || (!alive player) || (!alive _target) || (player getVariable ["revive_isUnconscious", false]) || (!isPlayer _target) || ((_target distance player) > 2 )) then
{
	_return = false;
} else {
	_return = _target getVariable ["revive_isUnconscious", false];
_return