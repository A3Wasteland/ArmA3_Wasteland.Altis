#include "macro.h"
#include "defines.h"

if (!undefined(cash_functions_defined)) exitWith {};
diag_log format["Loading cash functions ..."];


cash_get_value = {
	ARGVX4(0,_player,objNull,0);
	if (not([_player] call player_human)) exitWith {0};

	private ["_value"];
	_value = _player getVariable ["cmoney", 0];
	_value
};

cash_set_value = {
	ARGVX4(0,_player,objNull,0);
	ARGVX4(1,_value,0,0);

	if (not([_player] call player_human)) exitWith {0};


	(_player setVariable ["cmoney",_value, true])
};

cash_transaction = {
	ARGVX4(0,_player,objNull,0);
	ARGVX4(1,_value,0,0);

	if (not([_player] call player_human)) exitWith {0};

	private["_cvalue"];
	_cvalue = [_player] call cash_get_value;
	_cvalue = _cvalue + _value;
	[_player,_cvalue] call cash_set_value;
	_cvalue
};

diag_log format["Loading cash functions complete"];


cash_functions_defined = true;