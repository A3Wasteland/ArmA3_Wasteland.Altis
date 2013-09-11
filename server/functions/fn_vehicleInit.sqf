// ARMA3 function fn_vehicleInit v0.4 - by SPUn / lostvar & AgentRev
// Function to set custom init commands for units
// Call this from another scripts with syntax:
// [_unit, _customInit, _persistence] call fn_vehicleInit;
//
// IMPORTANT : Set "_persistence" to FALSE if you used to call "clearVehicleInit" right after "processInitCommands"
// 
// Make sure _customInit is in format (same format as setVehicleInit):
// "init command '1'; init command '2'"
// - Every init command MUST be ended in semicolon! (except the last one)
// - Keep it inside quotes, and if you need quotes in init commands, you MUST use ' or "" instead of "

private["_unit","_customInit","_persistence","_initChars","_strLen","_command","_varNameChars","_unitChars"];

_unit = _this select 0;
_customInit = _this select 1;
_persistence = if (count _this > 2) then { _this select 2 } else { true };

_initChars = toArray _customInit;
_strLen = count _initChars;
_command = [];

_varNameChars = toArray "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_";

_inlineStr1Quote = false;
_inlineStr2Quote = false;

for "_i" from 0 to (_strLen - 1) do
{
	// Single-quote (')
	if (!_inlineStr2Quote && {_initChars select _i == 39}) then {
		_inlineStr1Quote = !_inlineStr1Quote; // Invert bool
	};
	
	// Double-quote (")
	if (!_inlineStr1Quote && {_initChars select _i == 34}) then {
		_inlineStr2Quote = !_inlineStr2Quote; // Invert bool
	};
	
	// The following replaces "this" keywords by "_this"
	
	if (!_inlineStr1Quote && {!_inlineStr2Quote} // verifies that we're not in an inline string
		&& {_i+3 < _strLen} && {toLower toString [_initChars select _i, _initChars select (_i+1), _initChars select (_i+2), _initChars select (_i+3)] == "this"} // verifies if current and next chars make up the word "this"
		&& {_i-1 < 0 || {!((_initChars select (_i-1)) in _varNameChars)}} // verifies that previous char is not part of a variable name
		&& {_i+4 >= _strLen || {!((_initChars select (_i+4)) in _varNameChars)}}) // verifies that next char is not part of a variable name	
	then
	{		
		_unitChars = toArray "_this";
		
		{
			_command set [count _command, _x];
		} forEach _unitChars;
		
		_i = _i + 3;
	}
	else {
		_command set [count _command, _initChars select _i];
	};
};

if (isPlayer _unit) then 
{
	[[[_unit], compile format ["(_this select 0) call {%1}", toString _command]], "BIS_fnc_spawn", true, _persistence] call TPG_fnc_MP;
}
else
{
	[compile format ["(objectFromNetId '%1') call {%2}", netId _unit, toString _command], "BIS_fnc_spawn", true, _persistence] call TPG_fnc_MP;
};
