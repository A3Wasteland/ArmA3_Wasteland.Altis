#include "macro.h"

format_integer = {
	private["_value", "_nan", "_separator"];
	_nan = "NotANumber";
	_value = _this select 0;
	_separator = _this select 1;

	if (undefined(_value)) exitWith {_nan};
	if (typeName _value != "SCALAR") exitWith {_nan};

	if (_value == 0) exitWith {"0"};

	private["_string_value", "_digits", "_remainder", "_sign"];
	_string_value = "";
	_digits = 0;
	_sign = if (_value < 0) then {"-"} else {""};
	_value = abs(round(_value));
	while { _value >= 1 } do {
		_digits = _digits + 1;
		if ( _digits > 1 && ((_digits - 1) % 3) == 0) then {
			_string_value = _separator + _string_value;
		};
		_remainder = _value % 10;
		_string_value = str(_remainder) + _string_value;
		_value = floor(_value / 10);
	};

	_sign+_string_value
};

cameraDir = {
  ([(positionCameraToWorld [0,0,0]), (positionCameraToWorld [0,0,1])] call BIS_fnc_vectorDiff)
};

parse_number = {
	private ["_number"];
	_number = _this select 0;
	if (undefined(_number)) exitWith {0};
	if (typeName _number == "SCALAR") exitWith {_number};
	if (typeName _number != "STRING") exitWith {0};
	_number = parseNumber(_number);
	if (undefined(_number)) exitWith {0};
	if (typeName _number != "SCALAR") exitWith {0};
	_number
};

uid_to_player = {
  private["_uid"];
  _uid = _this select 0;
  if (isNil "_uid" || {typeName _uid != typeName "STRING" || {_uid == ""}}) exitWith {objNull};

  private["_result"];
  _result = objNull;

  {
    if ((getPlayerUID _x) == _uid) exitWith {
      _result = _x;
    };
  } forEach allUnits;

  (_result)
};

player_human = {
  ARGVX4(0,_player,objNull,false);
  (alive _player && {isPlayer _player})
};
