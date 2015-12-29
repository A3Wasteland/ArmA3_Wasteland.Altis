#include "constants.h"
#include "macro.h"
#include "dikcodes.h"

if (not(undefined(cctv_functions_defined))) exitWith {};
diag_log format["Loading cctv functions ..."];


cctv_camera_data_get = {
  ARGVX3(0,_index,0);
  ARGVX3(1,_cameras,[]);
  if (_index < 0 || _index > (count(_cameras) -1)) exitWith {[]};

  (_cameras select _index)
};


cctv_camera_view_last = objNull;
cctv_camera_view_index = -1;
cctv_camera_view_next = {
  //player groupChat format["cctv_camera_view_next %1",_this];
  ARGV2(0,_player);
  ARGV2(1,_cameras);

  if (typeName _player != "OBJECT") exitWith {};

  private["_camera_index"];
  _camera_index = cctv_camera_view_index + 1;


  private["_source"];
  _source = [_camera_index,_cameras] call cctv_camera_data_get;
  if (!isOBJECT(_source) || {isNull _source}) exitWith {};

  private["_camera_name", "_camera_owner_type"];
  _camera_name = _source getVariable ["camera_name", nil];
  if (!isSTRING(_camera_name) || {_camera_name == ""}) exitWith {};

   _camera_owner_type = _source getVariable ["camera_owner_type", nil];
   if (!isSTRING(_camera_owner_type) || {_camera_owner_type == ""}) exitWith {};


  if (not(isNull cctv_camera_view_last)) then {
    cctv_camera_view_last cameraeffect ["terminate","back"];
    camDestroy cctv_camera_view_last;
  };

  private["_rendertarget"];
  _rendertarget = "cctv_render0";

  //create the camera,and point it forward
  private["_camera"];
  _camera = "camera" camCreate position cameraon;
  _camera attachTo [_source,[0,-0.5,1]];
  _camera camPrepareTarget (_source modelToWorld [0,-5,1]);
  _camera camPrepareFov 0.7;
  _camera camPrepareFocus [-1,-1];
  _camera camCommitPrepared 0;
  _camera cameraeffect ["internal","back",_rendertarget];

  cctv_camera_view_last = _camera;

  //update the screen with the camera view

  private["_screen"];
  _screen = call laptop_flat_menu_screen_control;
  if (not(sunOrMoon > 0)) then {
    _rendertarget setPiPEffect [1];
  };
  _screen ctrlsettext format ["#(argb,512,512,1)r2t(%1,1.0)",_rendertarget];
  _screen ctrlsettextcolor [1,1,1,1];
  _screen ctrlcommit 0;

  //set the camera name on the screen
  [format["%1: %2", (toUpper _camera_owner_type), _camera_name]] call laptop_flat_menu_update_text_tl;

  //update the next cell index
  if (_camera_index >= (count(_cameras) -1)) then {
    _camera_index = -1;
  };
  cctv_camera_view_index = _camera_index;
  //player groupChat format["cctv_camera_view_index = %1",cctv_camera_view_index];
};



cctv_security_laptop_event_handler = {
  //player groupChat format["cctv_security_laptop_event_handler %1",_this];
  ARGV2(0,_event);
  ARGV2(1,_this);
  ARGV2(0,_player);
  ARGV2(1,_cameras);

  private["_event_type"];
  _event_type = _event select laptop_flat_event_type;
  switch _event_type do {
    case LAPTOP_EVENT_ON: {
      [_player,_cameras] call cctv_camera_view_next;
    };
    case LAPTOP_EVENT_KEY: {
      private["_key"];
      _key = _event select laptop_flat_envent_data;
      switch _key do {
        case DIK_SPACE: {
          [_player,_cameras] call cctv_camera_view_next;
        };
      };
    };
    case LAPTOP_EVENT_BUTTON: {
      private["_button"];
      _button = _event select laptop_flat_envent_data;
      switch _button do {
        case LAPTOP_EVENT_BUTTON_MOUSE_PAD: {
          [_player,_cameras] call cctv_camera_view_next;
        };
      };
    };
  };
};


cctv_cameras = OR(cctv_cameras,[]);

cctv_get_group_uids = {
  ARGVX4(0,_player,objNull,[]);

  private["_group_uids"];
  _group_uids = [getPlayerUID _player];
  {if (true) then {
    private["_member"];
    _member = _x;
    if (!isOBJECT(_member)  || {isNull _member}) exitWith {};

    private["_member_uid"];
    _member_uid = getPlayerUID _member;
    if (!isSTRING(_member_uid) || {_member_uid == ""}) exitWith {};

    _group_uids pushBack _member_uid;
  };} forEach (units (group _player));

  (_group_uids)
};

cctv_get_accessible_cameras = {
  ARGVX3(0,_player,objNull);
  if (!isARRAY(cctv_cameras) || {count(cctv_cameras) == 0}) then {[]};

  private["_uid", "_side", "_group_uids"];
  _uid = getPlayerUID _player;
  _side = str(side _player);
  _group_uids = [_player] call cctv_get_group_uids;

  //make a list with the UIDs for the group members


  //player groupChat format["_uid = %1, _side = %2, _group_uids = %3", _uid, _side, _group_uids];

  //get the list of cameras that are accessible to this player
  private["_cameras"];
  _cameras = [];
  {if (true) then {
    private["_camera"];
    _camera = _x;
    if (!isOBJECT(_camera) || {isNull _camera}) exitWith {};

    private["_distance"];
    _distance = _player distance _camera;
    if (cctv_max_distance > 0 && {_distance > cctv_max_distance}) exitWith {};

    private["_owner_type"];
    _owner_type = _camera getVariable ["camera_owner_type", nil];
    if (!isSTRING(_owner_type)) exitWith {};

    private["_owner_value"];
    _owner_value = _camera getVariable ["camera_owner_value", nil];
    if (!isSTRING(_owner_value) || {_owner_value == ""}) exitWith {};

	  //player groupChat format["_owner_type = %1, _owner_value = %2", _owner_type, _owner_value];

    if (!((_owner_type == "player" && {_owner_value == _uid}) ||{
          (_owner_type == "side" && {_owner_value == _side}) ||{
          (_owner_type == "group" && {_owner_value in _group_uids})}})) exitWith {};

    _cameras pushBack _camera;
  };} forEach cctv_cameras;

  (_cameras)
};

cctv_security_laptop_menu = {
  ARGV2(0,_player);

  if (typeName _player != "OBJECT") exitWith {};

  private["_cameras"];
  _cameras = [_player] call cctv_get_accessible_cameras;
  //player groupChat format["_cameras = %1", _cameras];

  if (count(_cameras) == 0) exitWith {
    player groupChat format["There are no CCTV cameras currently accessible."];
  };

  private["_handler"];
  _handler = [[_player, _cameras],"cctv_security_laptop_event_handler"];
  [_handler,_handler,_handler] call laptop_flat_menu_setup;
  player groupChat format["Use space key on the laptop keyboard,to cycle between the CCTV cameras."];
};


#define MUTEX_UNLOCK mutexScriptInProgress = false; doCancelAction = false

cctv_get_cameras_by_type = {
  ARGVX4(0,_player,objNull,[]);
  ARGVX4(1,_type,"",[]);

  private["_uid", "_side", "_group_uids"];
  _uid = getPlayerUID _player;
  _side = str(side _player);
  _group_uids = [_player] call cctv_get_group_uids;

  cctv_cameras = OR(cctv_cameras,[]);

  private["_result"];
  _result = [];
  {if (true) then {
    private["_camera"];
    _camera = _x;
    if (!isOBJECT(_camera) || {isNull _camera}) exitWith {};

    private["_ctype", "_cvalue"];
    _ctype = _camera getVariable "camera_owner_type";
    _cvalue = _camera getVariable "camera_owner_value";
    if (!isSTRING(_ctype) || {_ctype == ""}) exitWith {};
    if (!isSTRING(_cvalue) || {_cvalue == ""}) exitWith {};
    if (_type != _ctype) exitWith {};

    if ((_type == "group" && {_cvalue in _group_uids}) || {
        (_type == "side" && {_cvalue == _side}) || {
        (_type == "player" && {_cvalue == _uid})}}) exitWith {
      _result pushBack _camera;
    };
  };} forEach cctv_cameras;

  (_result)
};

cctv_enforce_limits = {
  ARGVX3(0,_player,objNull);
  ARGVX3(1,_owner_type,"");

  cctv_cameras = OR(cctv_cameras,[]);

  private["_old_cameras", "_count"];
  _old_cameras = [_player,_owner_type] call cctv_get_cameras_by_type;
  _count = count(_old_cameras);

  if(!((_owner_type == "player" && {_count >= cctv_max_deployed_player_cameras}) || {
       (_owner_type == "group" && {_count >= cctv_max_deployed_group_cameras}) || {
       (_owner_type == "side" && {_count >= cctv_max_deployed_side_cameras})}})) exitWith {};


  if (_owner_type == "player") then {
    player groupChat format["You already have %1 personal CCTV camera(s) deployed.", _count];
  }
  else {
    player groupChat format["There are already %1 %2 CCTV camera(s) deployed.", _count, toUpper _owner_type];
  };

  private["_camera_to_delete"];
  _camera_to_delete = _old_cameras select 0;
  player groupChat format["Camera ""%1"" was deleted.", (_camera_to_delete getVariable "camera_name")];
  deleteVehicle _camera_to_delete;
  cctv_cameras = cctv_cameras - [objNull];
};


cctv_camera_use = {
  //this is needed in order for the mf_inventory_drop call to work (since it's nested inside USE)
  MUTEX_UNLOCK ;

  private["_item_type"];
  _item_type = _this;

  private["_player", "_uid"];
  _player = player;
  _uid = getPlayerUID _player;

  private["_closesttown", "_town_name", "_town_pos"];
  _closesttown = (nearestLocations [_player,["NameCityCapital","NameCity","NameVillage"],10000]) select 0;
  _town_name = text _closesttown;
  _town_pos = position _closesttown;


  private["_cctv_id", "_cctv_name", "_rand"];
  _rand = ceil(random 10000);
  _camera_name = format["%1 (%2)", _town_name, _rand];

  cctv_menu_result = nil;
  [_player, _camera_name] call cctv_menu_dialog;
  waitUntil {!dialog || {!isNil "cctv_menu_result"}};

  if (isNil "cctv_menu_result") exitWith {false};

  //player groupChat format["cctv_menu_result = %1", cctv_menu_result];

  private["_access_control"];
  _camera_name = cctv_menu_result select cctv_menu_result_camera_name;
  _access_control = cctv_menu_result select cctv_menu_result_ac;

  private["_owner_type"];
  _owner_type = _access_control select cctv_menu_result_ac_type;
  _owner_value = _access_control select cctv_menu_result_ac_value;

  private["_camera"];
  _camera = _item_type call mf_inventory_drop;

  if (isNil "_camera" || {typeName _camera != typeName objNull || {isNull _camera}}) exitWith {false};

  _camera setVariable ["a3w_cctv_camera", true, true];
  _camera setVariable ["camera_name", _camera_name, true];
  _camera setVariable ["camera_owner_type", _owner_type, true];
  _camera setVariable ["camera_owner_value", _owner_value, true];
  _camera setVariable ["R3F_LOG_disabled", false, true]; // Added for locking and saving.

  [_player, _owner_type] call cctv_enforce_limits;
  cctv_cameras pushBack _camera;
  publicVariable "cctv_cameras";

  false
};

cctv_base_use = {
  [player] call cctv_security_laptop_menu;
  false
};



cctv_functions_defined = true;

diag_log format["Loading cctv functions complete"];