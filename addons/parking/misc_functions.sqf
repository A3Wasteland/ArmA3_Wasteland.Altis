if (!isNil "parking_misc_functions_defined") exitWith {};
diag_log format["Loading parking misc functions"];

#include "macro.h"

generic_picture_path = {
  ARGVX3(0,_id,"");
  ([_id, "picture"] call generic_config_text)
};

generic_display_name = {
  ARGVX3(0,_id,"");
  ([_id, "displayName"] call generic_config_text)
};

generic_icon_path = {
  ARGVX3(0,_id,"");
  ([_id, "icon"] call generic_config_text)
};

generic_config_text = {
  ARGVX3(0,_id,"");
  ARGVX3(1,_field,"");

  if (_id == "" || {_field == ""}) exitWith {""};

  if (isClass(configFile >> "CfgWeapons" >> _id)) exitWith {
    (getText(configFile >> "CfgWeapons" >> _id >> _field))
  };

  if (isClass(configFile >> "CfgVehicles" >> _id)) exitWith {
    (getText(configFile >> "CfgVehicles" >> _id >> _field))
  };

  if (isClass(configFile >> "CfgMagazines" >> _id)) exitWith {
    (getText(configFile >> "CfgMagazines" >> _id >> _field))
  };

  if (isClass(configFile >> "CfgAmmos" >> _id)) exitWith {
    (getText(configFile >> "CfgAmmos" >> _id >> _field))
  };

  if (isClass(configFile >> "CfgGlasses" >> _id)) exitWith {
    (getText(configFile >> "CfgGlasses" >> _id >> _field))
  };

  ""
};

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


diag_log format["Loading parking misc functions complete"];
parking_misc_functions_defined = true;