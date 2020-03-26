if (!isNil "va_misc_functions_loaded") exitWith {};
diag_log format["Loading vehicle misc functions ..."];

#include "macro.h"

//FIXME: some of these functions are repeated between addons, need to refactor, and put them in a shared place


A3W_fnc_unflip = {
  ARGVX3(0,_object,objNull);
  ARGVX3(1,_vector,[]);
  
  def(_pos);
  _object allowDamage false;
  _pos = getPos _object;
  _pos set [2, (_pos select 2) + 1.5];
  _object setPos _pos;
  _object setVectorUp _vector;
  [_object] spawn {
    sleep 1;
    ARGVX3(0,_object,objNull);
    _object allowDamage true;
  };
  
} call mf_compile;

A3W_fnc_lock  = {
  //diag_log format["%1 call A3W_fnc_lock", _this];
  ARGVX3(0,_left,objNull);
  ARGVX3(1,_right,0);
  _left lock _right;
  _left setVariable ["lockState", _right, true];
  
  def(_locked);
  _locked = (_right == 2 || {_right == 3});
  _left setVariable ["objectLocked", _locked, true];
  _left setVariable ["R3F_LOG_disabled",_locked, true];
} call mf_compile;

generic_picture_path = {
  ARGVX3(0,_id,"");
  ([_id, "picture"] call generic_config_text)
};

generic_display_name = {
  ARGVX3(0,_id,"");
  ([_id, "displayName"] call generic_config_text)
};

generic_display_name_variant = {
  params [["_class","",[""]], ["_variant","",[""]]];
  private _name = "";

  {
    if (_class == _x select 1 && (_variant == "" || {_variant in _x})) exitWith
    {
      _name = _x select 0;
    };
  } forEach (call allVehStoreVehicles + call staticGunsArray);

  if (_name == "") exitWith { [_class] call generic_display_name };
  _name
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

str_truncate = {
  ARGVX4(0,_str,"","...");
  ARGVX4(1,_max,0,"...");
  
 _str = if ((count _str) > _max) then { (_str select [0, _max - 3]) + "..."} else {_str};
 (_str)
};

va_misc_functions_loaded = true;

diag_log format["Loading vehicle misc functions complete"];


