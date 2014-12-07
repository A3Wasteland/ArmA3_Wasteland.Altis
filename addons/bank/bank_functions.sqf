#include "macro.h"
#include "defines.h"

if (!undefined(bank_functions_defined)) exitWith {};
diag_log format["Loading bank functions ..."];

bank_get_value = {
	ARGVX4(0,_player,objNull,0);
  if (not([_player] call player_human)) exitWith {0};

	private ["_value"];
	_value = _player getVariable ["bmoney", 0];
	_value
};

bank_set_value = {
	ARGVX4(0,_player,objNull,0);
	ARGVX4(1,_value,0,0);

  if (not([_player] call player_human)) exitWith {};

	_player setVariable ["bmoney",_value, true];
};


bank_transaction = {
	ARGVX4(0,_player,objNull,0);
	ARGVX4(1,_value,0,0);

  if (not([_player] call player_human)) exitWith {0};

	private["_cvalue"];
	_cvalue = [_player] call bank_get_value;
	_cvalue = _cvalue + _value;
	[_player,_cvalue] call bank_set_value;
	_cvalue
};

diag_log format["Loading bank functions complete"];
bank_functions_defined = true;