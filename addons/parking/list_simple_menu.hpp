#include "constants.h"

class list_simple_menu {
  idd = list_simple_menu_menu_dialog_idd;
  movingEnable = true;
  controlsBackground[] = {list_simple_menu_background};
  objects[] = { };

  name = "LIST_SIMPLE_MENU";
  onUnload = "";
  onLoad="uiNamespace setVariable ['LIST_SIMPLE_MENU',_this select 0]";

  controls[] = {
    list_simple_menu_header,
    list_simple_menu_select_button,
    list_simple_menu_close_button,
    list_simple_menu_list
  };

  class list_simple_menu_header : gui_RscMenuTitle {
    idc = list_simple_menu_header_idc;
    x = -10; y = -10;
    w = 0.05; h = 0.05;
    style = ST_CENTER;
    font = "PuristaBold";
    SizeEX = 0.03;
    colorBackground[] = GUI_BCG_RGB;
    text = "list_simple";
    moving = 1;
  };

  class list_simple_menu_background : gui_RscBackground {
    idc = list_simple_menu_background_idc;
    x = -10; y = -10;
    w = 0.05; h = 0.05;
    moving = 1;
  };

  class list_simple_menu_select_button : gui_RscMenuButton {
    idc = list_simple_menu_submit_button_idc;
    x = -10; y = -10;
    w = 0.05; h = 0.05;
    font = "PuristaBold";
    SizeEX = 0.03;
    text = "Select";
  };

  class list_simple_menu_close_button : gui_RscMenuButton {
    idc = list_simple_menu_close_button_idc;
    x = -10; y = -10;
    w = 0.05; h = 0.05;
    font = "PuristaBold";
    SizeEX = 0.03;
    text = "Close";
    action = "closedialog 0;";
  };

  class list_simple_menu_list : gui_RscListBox {
    idc = list_simple_menu_list_idc;
    //x = -10; y = -10;
    //w = 0.05; h = 0.50;
    x = 0.15; y = 0.198;
    w = 0.53; h = 0.334;
    rowHeight = 0.065;
  };
};