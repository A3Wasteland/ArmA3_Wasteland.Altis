#include "constants.h"
#include "macro.h"
#include "dikcodes.h"

if (not(undefined(laptop_flat_menu_functions))) exitWith {};

diag_log format["Loading laptop flat menu functions ..."];

laptop_flat_event_type = 0;
laptop_flat_envent_data = 1;

laptop_flat_key_event_cb = [];
laptop_flat_on_event_cb = [];
laptop_flat_off_event_cb = [];

laptop_flat_data_cb_args = 0;
laptop_flat_data_cb_name = 1;

laptop_flat_activate_key = {
  //player groupChat format["laptop_flat_activate_key %1",_this];
  disableSerialization;
  ARGV2(0,_type);
  ARGV2(1,_value);
  [[_type,_value],laptop_flat_key_event_cb] call laptop_flat_invoke_event_callback;
};


laptop_flat_invoke_event_callback = {
  disableSerialization;
  ARGV2(0,_event);
  ARGV2(1,_callback)

  if (isNil "_callback" || {typeName _callback != "ARRAY" || {count(_callback) < 2}}) exitWith {};

  private["_args","_name"];
  _args = _callback select laptop_flat_data_cb_args;
  _name = _callback select laptop_flat_data_cb_name;

  if (typeName "_name" != "STRING") exitWith {};

  private["_method"];
  _method = missionNamespace getVariable [_name,{}];
  [_event,_args] call _method;
};

laptop_flat_menu_screen_control = {
  private["_display"];
  _display = (uiNamespace getVariable 'LAPTOP_FLAT_MENU');
  (_display displayCtrl laptop_flat_menu_screen_idc)
};



laptop_flat_menu_update_text_tl = {
  disableSerialization;
  ARGV2(0,_text);
  private["_display"];
  _display = (uiNamespace getVariable 'LAPTOP_FLAT_MENU');

  _laptop_flat_menu_screen_text_tl = _display displayCtrl laptop_flat_menu_screen_text_tl_idc;
  _laptop_flat_menu_screen_text_tl ctrlSetText _text;
  _laptop_flat_menu_screen_text_tl ctrlCommit 0;
};

laptop_flat_menu_setup = {_this spawn {
  disableSerialization;
  ARGV2(0,_key_event_cb);
  ARGV2(1,_on_event_cb);
  ARGV2(2,_off_event_cb);

  laptop_flat_key_event_cb = _key_event_cb;
  laptop_flat_on_event_cb = _on_event_cb;
  laptop_flat_off_event_cb = _off_event_cb;

  if (!(createDialog "laptop_flat_menu")) exitWith {
    player groupChat format["ERROR: Could not create lock panel menu dialog"];
  };

  private["_display"];
  _display = (uiNamespace getVariable 'LAPTOP_FLAT_MENU');

  _laptop_flat_menu_background = _display displayCtrl laptop_flat_menu_background_idc;
  _laptop_flat_menu_screen = _display displayCtrl laptop_flat_menu_screen_idc;
  _laptop_flat_menu_button_mouse = _display displayCtrl laptop_flat_menu_button_mouse_idc;
  _laptop_flat_menu_button_space = _display displayCtrl laptop_flat_menu_button_space_idc;
  _laptop_flat_menu_screen_text_tl = _display displayCtrl laptop_flat_menu_screen_text_tl_idc;



  private["_x","_y","_w","_h"];
  _w = 1;
  _h = 1;
  _x = 0.5 - (_w /2);
  _y = 0.5 - (_h /2);

  _laptop_flat_menu_background ctrlSetPosition [_x,_y,_w,_h];
  _laptop_flat_menu_background ctrlSetText "addons\cctv\images\laptop_flat.paa";
  _laptop_flat_menu_background ctrlCommit 0;


  private["_bspx","_bspy","_bspw","_bsph"];
  _bspw = _w * 0.126;
  _bsph = _h * 0.025;
  _bspx = _x + _bspw * 2.85;
  _bspy = _y + _bsph * 30.2;


  _laptop_flat_menu_button_space ctrlSetText "";
  _laptop_flat_menu_button_space ctrlSetPosition [_bspx,_bspy,_bspw,_bsph];
  _laptop_flat_menu_button_space ctrlSetBackgroundColor  [0,0,0,0];
  _laptop_flat_menu_button_space ctrlCommit 0;
  //_laptop_flat_menu_button_space ctrlEnable false;
  buttonSetAction [(ctrlIDC _laptop_flat_menu_button_space),'[LAPTOP_EVENT_KEY,DIK_SPACE] call laptop_flat_activate_key;'];


  private["_bxsep","_bysep"];
  _bxsep = _bsph;
  _bysep = _bsph;

  private["_bmsx","_bmsy","_bmsw","_bmsh"];
  _bmsw = _bspw;
  _bmsh = _bsph * 4;
  _bmsx = _bspx + _bxsep * 0.5;
  _bmsy = _bspy + _bysep * 2.5;

  _laptop_flat_menu_button_mouse ctrlSetText "";
  _laptop_flat_menu_button_mouse ctrlSetPosition [_bmsx,_bmsy,_bmsw,_bmsh];
  _laptop_flat_menu_button_mouse ctrlSetBackgroundColor  [0,0,0,0];
  _laptop_flat_menu_button_mouse ctrlCommit 0;
  //_laptop_flat_menu_button_mouse ctrlEnable false;
  buttonSetAction [(ctrlIDC _laptop_flat_menu_button_mouse),'[LAPTOP_EVENT_BUTTON,LAPTOP_EVENT_BUTTON_MOUSE_PAD] call laptop_flat_activate_key;'];


  private["_lsx","_lsy","_lsw","_lsh"];
  _lsw = _bspw * 4.1;
  _lsh = _bsph * 15.7;
  _lsx = _bspx - _bspw * 0.97;
  _lsy = _bspy - _bsph * 27.9;


  _laptop_flat_menu_screen ctrlSetPosition [_lsx,_lsy,_lsw,_lsh];
  //_laptop_flat_menu_screen ctrlSetTextColor  [0,0,0,0.15];
  _laptop_flat_menu_screen ctrlSetText "#(argb,8,8,3)color(1,0,0,1)";
  _laptop_flat_menu_screen ctrlCommit 0;


  private["_lstx","_lsty","_lstw","_lsth"];
  _lstw = _bspw * 3.5;
  _lsth = _bsph * 1.5;
  _lstx = _bspx - _bspw * 0.97;
  _lsty = _bspy - _bsph * 27.9;

  _laptop_flat_menu_screen_text_tl ctrlSetPosition [_lstx,_lsty,_lstw,_lsth];
  _laptop_flat_menu_screen_text_tl ctrlSetBackgroundColor [0,0,0,0.6];
  _laptop_flat_menu_screen_text_tl ctrlSetFontHeight 0.03;
  _laptop_flat_menu_screen_text_tl ctrlSetFont "PuristaMedium";
  _laptop_flat_menu_screen_text_tl ctrlSetTextColor  [1,1,1,1];
  _laptop_flat_menu_screen_text_tl ctrlSetText "";
  _laptop_flat_menu_screen_text_tl ctrlCommit 0;


  [[LAPTOP_EVENT_ON],laptop_flat_on_event_cb] call laptop_flat_invoke_event_callback;
  waitUntil {not(ctrlShown _laptop_flat_menu_background)};
  [[LAPTOP_EVENT_OFF],laptop_flat_off_event_cb] call laptop_flat_invoke_event_callback;
};};


laptop_flat_menu_functions = true;

diag_log format["Loading laptop flat menu functions complete"];