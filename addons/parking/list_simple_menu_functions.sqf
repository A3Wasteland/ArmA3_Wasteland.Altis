if (!isNil "list_simple_menu_functions_defined") exitWith {};
diag_log format["Loading list simple menu functions ... "];

#include "constants.h"
#include "macro.h"


list_simple_menu_header = 0;
list_simple_menu_list = 1;
list_simple_menu_submit = 2;
list_simple_menu_close = 3;

list_simple_menu_label_data = {
  private["_index"];
  _index = lbCurSel (list_simple_menu_list_idc);
  if (_index < 0) exitWith {nil};

  private["_data"];
  _data = (lbData [list_simple_menu_list_idc,_index]);
  if (undefined(_data)) exitWith {nil};
  _data
};

list_simple_menu_setup = {
  disableSerialization;
  ARGVX3(0,_title,"");
  ARGVX3(1,_x,0);
  ARGVX3(2,_y,0);
  ARGVX3(3,_w,0);
  ARGVX3(4,_h,0);

  if (!(createDialog "list_simple_menu")) exitWith {
    player groupChat format["ERROR: Could not create list simple menu dialog"];
  };

  private["_display"];
  _display = (uiNamespace getVariable 'LIST_SIMPLE_MENU');

  _list_simple_menu_header = _display displayCtrl list_simple_menu_header_idc;
  _list_simple_menu_background = _display displayCtrl list_simple_menu_background_idc;
  _list_simple_menu_select_button = _display displayCtrl list_simple_menu_submit_button_idc;
  _list_simple_menu_close_button = _display displayCtrl list_simple_menu_close_button_idc;
  _list_simple_menu_list = _display displayCtrl list_simple_menu_list_idc;

  private["_ysep","_sep","_header_title"];
  _ysep = 0.003;
  _sep = 0.01;
  _header_title = _title;

  private["_button_font_height","_font_family"];
  _button_font_height = MENU_TITLE_FONT_HEIGHT;
  _font_family = "PuristaMedium";

  //header
  private["_lhx","_lhy","_lhw","_lhh"];
  _lhx = _x;
  _lhy = _y;
  _lhw = _w;
  _lhh = 0.045;

  _list_simple_menu_header ctrlSetPosition [_lhx,_lhy,_lhw,_lhh];
  _list_simple_menu_header ctrlSetFontHeight _button_font_height;
  _list_simple_menu_header ctrlSetFont _font_family;
  _list_simple_menu_header ctrlSetText _header_title;
  _list_simple_menu_header ctrlCommit 0;


  //background
  private["_lbx","_lby","_lbw","_lbh"];
  _lbx = _lhx;
  _lby = _lhy + _lhh + _ysep;
  _lbw = _w;
  _lbh = _h - _lhh - _lhh - _ysep - _ysep;

  _list_simple_menu_background ctrlSetPosition [_lbx,_lby,_lbw,_lbh];
  _list_simple_menu_background ctrlSetBackgroundColor [0,0,0,0.65];
  _list_simple_menu_background ctrlCommit 0;

  //select button
  private["_lsx","_lsy","_lsw","_lsh"];
  _lsw = 0.20;
  _lsh = _lhh;
  _lsx = _lhx;
  _lsy = _lby + _lbh + _ysep;

  _list_simple_menu_select_button ctrlSetText "Submit";
  _list_simple_menu_select_button ctrlSetPosition [_lsx,_lsy,_lsw,_lsh];
  _list_simple_menu_select_button ctrlCommit 0;


  //close button
  private["_lcx","_lcy","_lcw","_lch"];
  _lcw = 0.14;
  _lch = _lhh;
  _lcx = _lhx + _lhw - _lcw;
  _lcy = _lhy + _h - _lch;

  _list_simple_menu_close_button ctrlSetText "Close";
  _list_simple_menu_close_button ctrlSetPosition [_lcx,_lcy,_lcw,_lch];
  buttonSetAction [(ctrlIDC _list_simple_menu_close_button),"closeDialog 0"];
  _list_simple_menu_close_button ctrlCommit 0;

  //list
  private["_llx","_lly","_llw","_llh"];
  _llx = _lbx + _sep ;
  _lly = _lby + _sep;
  _llw = _lhw - _sep * 2;
  _llh = _lbh - _sep * 2;

  _list_simple_menu_list ctrlSetText "";
  _list_simple_menu_list ctrlSetPosition [_llx,_lly,_llw,_llh];
  _list_simple_menu_list ctrlSetFontHeight _button_font_height - 0.0015;
  _list_simple_menu_list ctrlCommit 0;

  private["_controls"];

  _controls = [];
  _controls set [list_simple_menu_header,_list_simple_menu_header];
  _controls set [list_simple_menu_list,_list_simple_menu_list];
  _controls set [list_simple_menu_submit,_list_simple_menu_select_button];
  _controls set [list_simple_menu_close,_list_simple_menu_close_button];

  _controls
};




list_simple_menu_functions_defined = true;

diag_log format["Loading list simple menu functions complete"];