//	@file Name: cargoToPairs.sqf
//	@file Author: AgentRev

// Converts an array of items and quantities obtained from a get____Cargo command into an array of key-value pairs

private "_array";
_array = [];

if (count _this > 1) then
{
	{
		_array set [count _array, [_x, (_this select 1) select _forEachIndex]];
	} forEach (_this select 0);
};

_array
