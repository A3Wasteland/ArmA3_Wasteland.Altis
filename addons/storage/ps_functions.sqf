if (!isNil "storage_functions_defined") exitWith {};
diag_log format["Loading storage functions ..."];

#include "macro.h"
#include "futura.h"

ps_marker_create = {
  if (!hasInterface) exitWith {""};
  ARGVX3(0,_name,"");
  ARGVX3(1,_location,[]);
  ARGVX3(2,_this,[]);

  ARGVX3(0,_shape,"");
  ARGVX3(1,_type,"");
  ARGVX3(2,_color,"");
  ARGVX3(3,_size,[]);
  ARGVX3(4,_text,"");

  private["_marker"];
  _marker = createMarkerLocal [_name,_location];
  _marker setMarkerShapeLocal _shape;
  _marker setMarkerTypeLocal _type;
  _marker setMarkerColorLocal _color;
  _marker setMarkerSizeLocal _size;
  //_marker setMarkerTextLocal _text;
  (_marker)
};

ps_get_all_cities = {
  if (isARRAY(ps_all_cities)) exitWith {ps_get_all_cities};
  ps_get_all_cities = (nearestLocations [[0,0,0],["NameCityCapital","NameCity","NameVillage"],1000000]);
  (ps_get_all_cities)
};


ps_setup_box = {
  params ["_box"];
  if (_box getVariable ["A3W_storageBoxSetupDone",false]) exitWith {};
  private _garage = param [1, nearestBuilding _box];

  if (local _box) then { _box allowDamage false };
  if (local _garage) then { _garage allowDamage false };
  _box setVariable ["R3F_LOG_disabled", true];
  _garage setVariable ["R3F_LOG_disabled", true];

  _box setVariable ["A3W_storageBoxSetupDone", true];
};

ps_create_boxes = {
  def(_town);
  def(_town_pos);
  def(_town_name);
  def(_garage);
  def(_box);
  def(_model);
  def(_pos);
  def(_name);
  def(_marker);
  init(_i,0);


  { call {
    _town = _x;
    _town_name =  text(_town);
    _town_pos = position _town;
    if (isARRAY(ps_cities_whitelist) && {count(ps_cities_whitelist) > 0 && {not(_town_name in ps_cities_whitelist)}}) exitWith {};

    _garage = (nearestObjects [_town_pos, ["Land_i_Garage_V2_F", "Land_Shed_06_F", "Land_Warehouse_03_F"], 300]) select 0;
    if (!isOBJECT(_garage)) exitWith {
      diag_log format["No storage in %1", _town_name];
    };

    _name = format["storage_box_%1", _i];
    _i = _i + 1;


    _pos = AGLtoASL (_garage modelToWorld [0,0,0]);
    /*if (_garage isKindOf "Land_Shed_06_F") then {
      _pos set [2,0];
    };*/

    _model = ps_box_models call BIS_fnc_selectRandom;

    _box = createVehicle [_model, ASLtoATL _pos, [], 1, ""];
    _pos = getPosASL _box;
    _pos set [2, (_pos select 2) - (getPos _box select 2)];
    _box setPosASL _pos;
    //_box setPos _pos;
    _box setVectorDirAndUp [vectorDir _garage, vectorUp _garage];
    _box setVariable ["is_storage", true, true];
    [_box, _garage] call ps_setup_box;

    diag_log format["Creating Storage at: %1 (%2)", _town_name, _pos];
  }} foreach (call ps_get_all_cities);
};

if (["A3W_savingMethod", "profile"] call getPublicVar != "sock") then
{
  p_saveStorage = {
    params ["", "_obj"];

    private _storage =
    [
      ["Weapons", (getWeaponCargo _obj) call cargoToPairs],
      ["Magazines", _obj call fn_magazineAmmoCargo],
      ["Items", (getItemCargo _obj) call cargoToPairs],
      ["Backpacks", (getBackpackCargo _obj) call cargoToPairs]
    ];

    player setVariable ["private_storage", _storage];
    if (!isNil "fn_savePlayerData") then { [] spawn fn_savePlayerData };

    _storage
  };

  p_recreateStorageBox = {
    params ["", "_class"];

    private _obj = _class createVehicleLocal [0,0,1000];

    if (isNull _obj) exitWith {
      diag_log format["WARNING: Could not create storage container of class '%1'", _class];
    };

    _obj hideObject true;
    clearWeaponCargo _obj;
    clearMagazineCargo _obj;
    clearItemCargo _obj;
    clearBackpackCargo _obj;
    _obj setVariable ["is_obj_box", true];

    {
      _x params ["_name", "_value"];

      switch (_name) do
      {
        case "Weapons": { { _obj addWeaponCargoGlobal _x } forEach _value };
        case "Magazines": { [_obj, _value] call processMagazineCargo };
        case "Items": { { _obj addItemCargoGlobal _x } forEach _value };
        case "Backpacks": { { _obj addBackpackCargoGlobal _x } forEach _value };
      };
    } forEach (player getVariable ["private_storage", []]);

    _obj
  };
};

ps_inventory_ui_mod = {
  ARGVX3(0,_box,objNull);

  disableSerialization;
  waitUntil {!(isNull (findDisplay IDD_FUTURAGEAR))};
  def(_display);
  _display = findDisplay IDD_FUTURAGEAR;


  def(_outside);
  _outside = [-1,-1,0.1,0.1];

  def(_filter);
  _filter = _display displayCtrl IDC_FG_GROUND_FILTER;

  def(_pos);
  def(_ground_tab);
  _ground_tab = _display displayCtrl IDC_FG_GROUND_TAB;
  _pos = (ctrlPosition _ground_tab);
  _ground_tab ctrlSetPosition _outside;
  _ground_tab ctrlCommit 0;

  def(_custom_text);
  _custom_text = _display ctrlCreate ["RscText", -1];
  _pos set [2, (ctrlPosition _filter) select 2];
  _custom_text ctrlSetPosition _pos;
  _custom_text ctrlSetText "Private Storage";
  _custom_text ctrlSetBackgroundColor [0,0,0,1];
  _custom_text ctrlSetTextColor [1,1,1,1];
  _custom_text ctrlSetActiveColor [1,1,1,1];
  _custom_text ctrlSetTooltip "This storage is visible to you only.<br />It's automatically saved in the database,<br />and can be accessed across maps.";
  _custom_text ctrlCommit 0;

  def(_chosen_tab);
  _chosen_tab = _display displayCtrl IDC_FG_CHOSEN_TAB;
  _chosen_tab ctrlSetPosition _outside;
  _chosen_tab ctrlCommit 0;


  waitUntil {
    isNull (findDisplay IDD_FUTURAGEAR)
  };


  [player, _box] call p_saveStorage;
  deleteVehicle _box;
};

ps_access = {
  private["_box"];
  _box = [player, ps_container_class] call p_recreateStorageBox;

  if (isNil "_box") exitWith {
    player commandChat "ERROR: Could not access private storage, please report this error to A3Armory.com.";
  };

  _box attachTo [player, [0,0,3]];


  player removeAllEventHandlers "InventoryOpened";
  player addEventHandler ["InventoryOpened", {
    if (((_this select 1) getVariable ["is_storage_box", false])) exitWith {
      true
    };
	false
  }];

  player action ["Gear",  _box];
  player removeAllEventHandlers "InventoryOpened";
  [_box] spawn ps_inventory_ui_mod;
};

ps_cameraDir = {
  ([(positionCameraToWorld [0,0,0]), (positionCameraToWorld [0,0,1])] call BIS_fnc_vectorDiff)
};

ps_is_object_storage = {
  ARGVX4(0,_obj,objNull,false);
  (_obj getVariable ["is_storage", false])
};

ps_is_player_near = {
  private["_objects"];
  _objects = nearestObjects [player, ["Land_PaperBox_open_full_F", "Land_Pallet_MilBoxes_F", "Land_PaperBox_open_empty_F", "Land_PaperBox_closed_F"], 2];
  if (isNil "_objects") exitWith {false};

  private["_found"];
  _found = false;
  {
    if ([_x] call ps_is_object_storage) exitWith {
	    _found = true;
	  };
  } forEach _objects ;

  (_found)
};

ps_actions = OR(ps_actions,[]);

ps_remove_actions = {
	if (count ps_actions == 0) exitWith {};

	{
		private["_action_id"];
		_action_id = _x;
		player removeAction _action_id;
	} forEach ps_actions;
	ps_actions = [];
};

ps_add_actions = {
	if (count ps_actions > 0) exitWith {};
	private["_player"];
	_player = _this select 0;

  private["_action_id", "_text"];
  _action_id = _player addAction ["<img image='addons\storage\icons\storage.paa'/> Access Storage", {call ps_access}];
  ps_actions = ps_actions + [_action_id];
};

ps_check_actions = {
  	private["_player"];
    _player = player;
    private["_vehicle", "_in_vehicle"];
    _vehicle = (vehicle _player);
    _in_vehicle = (_vehicle != _player);

    if (not(_in_vehicle || {not(alive _player) || {not(call ps_is_player_near)}})) exitWith {
      [_player] call ps_add_actions;
    };

   [_player] call ps_remove_actions;
};


ps_client_loop = {
  if (!hasInterface) exitWith {};

  while {true} do {
    call ps_check_actions;
    sleep 0.5;
  };
};


if (isServer) then
{
  diag_log "Setting up storage boxes ... ";
  [] call ps_create_boxes;
  ps_setup_boxes_complete = true;
  publicVariable "ps_setup_boxes_complete";
}
else
{
  diag_log "Waiting for storage boxes setup to complete ...";
  waitUntil {!isNil "ps_setup_boxes_complete"};
};

if (hasInterface) then
{
  waitUntil {!isNil "A3W_serverSetupComplete" && time > 0};
};

{
  _x call ps_setup_box;

  if (ps_markers_enabled) then
  {
    [format ["storage_box_%1", _forEachIndex + 1], getPosASL _x, ps_markers_properties] call ps_marker_create;
  };
} forEach ((allMissionObjects "All") select {_x getVariable ["is_storage",false]});

diag_log "Storage boxes setup complete";

[] spawn ps_client_loop;

storage_functions_defined = true;
diag_log "Loading storage functions complete";
