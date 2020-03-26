if (!isNil "parking_interact_functions") exitWith {};
diag_log format["Loading parking interact functions ..."];

#include "constants.h"
#include "macro.h"


pp_interact_select_vehicle = {
  ARGVX3(0,_vehicle_id,"");
  if (_vehicle_id == "") exitWith {nil};

  pp_interact_selected_vehicle = _vehicle_id;
  closeDialog 0;
  _vehicle_id
};

pp_interact_park_vehicle_wait = {
  //player groupChat format["interact_select_vehicle_wait %1",_this];
  disableSerialization;
  ARGVX3(0,_title,"");
  ARGVX3(1,_vehicle_list,[]);

  pp_interact_selected_vehicle = nil;

  def(_controls);
  def(_list);
  def(_submit);

  _controls = [toUpper(_title),0.14,0.14,0.55,0.45] call list_simple_menu_setup;
  if (!isARRAY(_controls)) exitWith {
    player groupChat format["ERROR: Could not setup dialog for parking vehicles"];
    nil
  };

  _list = _controls select list_simple_menu_list;
  _submit = _controls select list_simple_menu_submit;

  _submit ctrlSetText "Select";

  buttonSetAction [(ctrlIDC _submit),'[([] call list_simple_menu_label_data)] call pp_interact_select_vehicle;'];

  _submit ctrlCommit 0;

  interact_selected_vehicle = nil;

  {if(true) then {
    init(_vehicle_data,_x);

    def(_vehicle_id);
    def(_class);
    private _vehicle_tag = "";
    private _variant = "";

    if (isOBJECT(_vehicle_data) && {alive _vehicle_data}) then {
      init(_vehicle,_vehicle_data);
      _vehicle_id = netId _vehicle;
      _vehicle_tag = [_vehicle] call va_get_tag;
      _class = typeOf _vehicle;
      _variant = _vehicle getVariable ["A3W_vehicleVariant", ""];
    }
    else { if (isARRAY(_vehicle_data)) then {
      _vehicle_id = _vehicle_data select 0;
      _vehicle_tag = _vehicle_id;
      _vehicle_data = _vehicle_data select 1;
      _class = [_vehicle_data, "Class"] call fn_getFromPairs;
      _variant = [[_vehicle_data, "Variables", []] call fn_getFromPairs, "A3W_vehicleVariant", ""] call fn_getFromPairs;
    };};

    if (isNil "_class") exitWith {};

    def(_picture);
    def(_name);

    if (_variant != "") then { _variant = "variant_" + _variant };

    _name = [_class, _variant] call generic_display_name_variant;
    _picture = [_class] call generic_picture_path;

    def(_index);
    _index = _list lbAdd format["%1 [#%2]",_name, _vehicle_tag];
    _list lbSetData [_index, _vehicle_id];
    _list lbSetPicture [_index, _picture];
  };} forEach _vehicle_list;

  _list lbSetCurSel 0;
  waitUntil {(not(isNil "pp_interact_selected_vehicle") || {not(ctrlShown _list)})};

  OR(pp_interact_selected_vehicle,nil);
};

diag_log format["Loading parking interact functions complete"];
parking_interact_functions_defined = true;