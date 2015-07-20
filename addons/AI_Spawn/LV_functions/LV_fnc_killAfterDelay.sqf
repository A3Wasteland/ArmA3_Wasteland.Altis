//ARMA3Alpha function LV_fnc_killAfterDelay v0.1 - by SPUn / lostvar
//kills unit after random delay, used by LV_fnc_removeAC.sqf
private ["_unit","_delay"];

_unit = _this select 0;
_delay = _this select 1;

sleep random _delay;
_unit setDamage 1;