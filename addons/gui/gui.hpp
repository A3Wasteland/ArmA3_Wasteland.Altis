#define FontM 			                "PuristaMedium"
#define FontHTML 		                "PuristaMedium"
#define CT_STATIC                   0
#define CT_BUTTON                   1
#define CT_EDIT                     2
#define CT_SLIDER                   3
#define CT_COMBO                    4
#define CT_LISTBOX                  5
#define CT_TOOLBOX                  6
#define CT_CHECKBOXES               7
#define CT_PROGRESS                 8
#define CT_HTML                     9
#define CT_STATIC_SKEW             10
#define CT_ACTIVETEXT              11
#define CT_TREE                    12
#define CT_STRUCTURED_TEXT         13
#define CT_CONTEXT_MENU            14
#define CT_CONTROLS_GROUP          15
#define CT_SHORTCUT_BUTTON         16
#define CT_XKEYDESC                40
#define CT_XBUTTON                 41
#define CT_XLISTBOX                42
#define CT_XSLIDER                 43
#define CT_XCOMBO                  44
#define CT_ANIMATED_TEXTURE        45
#define CT_OBJECT                  80
#define CT_OBJECT_ZOOM             81
#define CT_OBJECT_CONTAINER        82
#define CT_OBJECT_CONT_ANIM        83
#define CT_LINEBREAK               98
#define CT_USER                    99
#define CT_MAP                    100
#define CT_MAP_MAIN               101
#define CT_LISTNBOX               102

#define ST_LEFT                     0
#define ST_RIGHT                    1
#define ST_CENTER                   2
#define ST_MULTI                   16
#define ST_PICTURE                 48
#define ST_FRAME                   64
#define ST_SHADOW                 256
#define ST_NO_RECT                512


// Respawn Dialog additions

#define FontM_R "PuristaMedium"
#define FontHTML_R "PuristaMedium"
#define Dlg_ROWS 36
#define Dlg_COLS 90
#define Dlg_CONTROLHGT ((100/Dlg_ROWS)/100)
#define Dlg_COLWIDTH ((100/Dlg_COLS)/100)
#define Dlg_TEXTHGT_MOD 0.8
#define Dlg_ROWSPACING_MOD 1.3
#define Dlg_ROWHGT (Dlg_CONTROLHGT*Dlg_ROWSPACING_MOD)
#define Dlg_TEXTHGT (Dlg_CONTROLHGT*Dlg_TEXTHGT_MOD)
#define Dlg_ICONWIDTH (Dlg_CONTROLHGT*4/5)
#define ST_POS 0x0F
#define ST_HPOS 0x03
#define ST_VPOS 0x0C
#define ST_LEFT 0x00
#define ST_RIGHT 0x01
#define ST_CENTER 0x02
#define ST_DOWN 0x04
#define ST_UP 0x08
#define ST_VCENTER 0x0c
#define ST_TYPE 0xF0
#define ST_SINGLE 0
#define ST_TITLE_BAR 32
#define ST_PICTURE 48
#define ST_FRAME 64
#define ST_BACKGROUND 80
#define ST_GROUP_BOX 96
#define ST_GROUP_BOX2 112
#define ST_HUD_BACKGROUND 128
#define ST_TILE_PICTURE 144
#define ST_WITH_RECT 160
#define ST_LINE 176
#define ST_SHADOW 0x100
#define ST_NO_RECT 0x200
#define ST_KEEP_ASPECT_RATIO 0x800
#define ST_TITLE ST_TITLE_BAR + ST_CENTER
#define SL_DIR 0x400
#define SL_VERT 0
#define SL_HORZ 0x400
#define SL_TEXTURES 0x10
#define LB_TEXTURES 0x10
#define LB_MULTI 0x20



class gui_RscText {
	type              = CT_STATIC;
	idc               = -1;
	style             = ST_LEFT;
	colorBackground[] = {0,0,0,0};
	colorText[]       = {1,1,1,1};
	font              = FontM;
	sizeEx            = 0.02;
	text              = "";
};

class gui_RscBgRahmen {
	type              = CT_STATIC;
	idc               = -1;
	style             = ST_FRAME;
	colorBackground[] = {1.0,1.0,1.0,0.75};
	colorText[]       = {1,1,1,1};
	font              = FontM;
	SizeEX            = 0.025;
	text              = "";
};

class gui_RscBackground {
	colorBackground[] = {0,0,0,0.75};
	text              = "";
	type              = CT_STATIC;
	idc               = -1;
	style             = ST_LEFT;
	colorText[]       = {1,1,1,1};
	font              = FontM;
	sizeEx            = 0.04;
};

class gui_RscPicture {
	type              = CT_STATIC;
	idc               =  -1;
	style             = ST_PICTURE;
	colorBackground[] = {0,0,0,0};
	colorText[]       = {1,1,1,1};
	font              = FontM;
	sizeEx            = 0.02;
	text              = "";
};

class gui_RscPictureKeepAspect: gui_RscPicture {
	style = "0x30 + 0x800";
};

class gui_RscBackgroundPicture {
	type              = CT_STATIC;
	idc               =  -1;
	style             = ST_PICTURE;
	colorBackground[] = {0,0,0,0};
	colorText[]       = {1,1,1,1};
	font              = FontM;
	sizeEx            = 0.02;
	text              = "dbg.pac";
};

class gui_RscButton {
	type                      = CT_BUTTON;
	idc                       = -1;
	style                     = ST_CENTER;
	colorText[]               = {1,1,1,1};
	font                      = FontHTML;
	sizeEx                    = 0.025;
	soundPush[]               = {"",0.2,1};
	soundClick[]              = {"",0.2,1};
	soundEscape[]             = {"",0.2,1};
	default                   = false;
	text                      = "";
	action                    = "";
	colorActive[]             = {0,0,0,0};
	colorDisabled[]           = {0,0,0,0.1};
	colorBackground[]         = {0.8,0.8,0.8,0.3};
	colorBackgroundActive[]   = {0.7,0.7,0.7,1};
	colorBackgroundDisabled[] = {1,1,1,0.5};
	colorFocused[]            = {0.84,1,0.55,1};
	colorShadow[]             = {0,0,0,0.1};
	colorBorder[]             = {1,1,1,0.1};
	offsetX                   = 0;
	offsetY                   = 0;
	offsetPressedX            = 0;
	offsetPressedY            = 0;
	borderSize                = 0;
	soundEnter[]              = {"",0.15,1};
};

class gui_RscMenuButton {
	type = CT_SHORTCUT_BUTTON;
	style = "0x02 + 0xC0";
	default = 0;
	shadow = 0;
	x = 0;
	y = 0;
	w = 0.095589;
	h = 0.039216;
	animTextureNormal = "#(argb,8,8,3)color(0,0,0,1)";
	animTextureDisabled = "#(argb,8,8,3)color(1,0,0,0.8)";
	animTextureOver = "#(argb,8,8,3)color(0,0,0,0.8)";
	animTextureFocused = "#(argb,8,8,3)color(0,0,0,1)";
	animTexturePressed = "#(argb,8,8,3)color(0,0,0,1)";
	animTextureDefault = "#(argb,8,8,3)color(0,0,0,1)";
	textureNoShortcut = "";

	colorBackground[] = {1,1,1,0.8};
	colorBackground2[] = {1,1,1,0.5};
	color[] = {1,1,1,1};
	color2[] = {1,1,1,1};
	colorText[] = {1,1,1,1};
	colorDisabled[] = {1,0,0,0.8};

	colorFocused[] = {1,1,1,1};
  colorBackgroundFocused[] = {0,0,0,0};

	period = 1.2;
	periodFocus = 1.2;
	periodOver = 1.2;
	size = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";

	class HitZone
	{
		left = 0.0;
		top = 0.0;
		right = 0.0;
		bottom = 0.0;
	};

	class TextPos
	{
		left = "0.25 * (((safezoneW / safezoneH) min 1.2) / 40)";
		top = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) - (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)) / 2";
		right = 0.005;
		bottom = 0.0;
	};
	class Attributes
	{
		font = "PuristaLight";
		color = "#E5E5E5";
		align = "left";
		shadow = "false";
	};
	class ShortcutPos
	{
		left = "(6.25 * (((safezoneW / safezoneH) min 1.2) / 40)) - 0.0225 - 0.005";
		top = 0.005;
		w = 0.0225;
		h = 0.03;
	};
	soundEnter[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundEnter",0.09,1};
	soundPush[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundPush",0.09,1};
	soundClick[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundClick",0.09,1};
	soundEscape[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundEscape",0.09,1};
};

class gui_RscMenuTitle {
	type = CT_STATIC;
	idc = -1;
	style = ST_CENTER;
	colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.69])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.75])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.5])","(profilenamespace getvariable ['GUI_BCG_RGB_A',0.8])"};
	colorText[] = {1,1,1,1};
	font = "PuristaMedium";
	sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	text = "";
	shadow = 1;
	colorShadow[] = {0,0,0,0.5};
	linespacing = 1;
};


class gui_RscDummy : gui_RscButton {
	x   = -1.0;
	y   = -1.0;
	idc = -1;
	w   = 0.01;
	h   = 0.01;
	default = true;
};

class gui_RscEdit {
	idc = -1;
	type = CT_EDIT;
	style = ST_LEFT;
	font = FontHTML;
	sizeEx = 0.02;
	colorText[] = {1,1,1,1};
	colorSelection[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.69])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.75])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.5])",1};
	colorDisabled[] = {1,0,0,0.3};
	autocomplete = false;
	text = "";
};

class gui_RscEditMulti : gui_RscEdit {
	style = ST_MULTI;
	sizeEx = 0.03;
	lineSpacing = 1;
	colorDisabled[] = {1,1,1,1};
};

class gui_RscLB_C {
	style                   = ST_LEFT;
	idc                     = -1;
	colorSelect[]           = {0,0,0,1.0};
	colorSelectBackground[] = {0.7,0.7,0.7,1};
	colorText[]             = {1,1,1,1};
	colorBackground[]       = {0.8,0.8,0.8,0.3};
	colorScrollbar[] 		= {Dlg_Color_White,1};
	colorDisabled[]			= {1,0,0,0.3};
	font                    = FontHTML;
	sizeEx                  = 0.025;
	rowHeight               = 0.04;
	period 					= 1.200000;
	maxHistoryDelay 		= 1.000000;
	autoScrollSpeed 		= -1;
	autoScrollDelay 		= 5;
	autoScrollRewind 		= 0;

	class ScrollBar {};
};

class gui_RscListBox {
	type = CT_LISTBOX;
	style = ST_MULTI;
	lineSpacing = 1;
	shadow = 0;


	colorText[] = {1,1,1,1};
	colorBackground[] = {0,0,0,0.15};

	colorSelect[] = {1,1,1,1};
	colorSelectBackground[] = {1,1,1,0.2};

	colorSelect2[] = {1,1,1,0.7};
  colorSelectBackground2[] = {1,1,1,0.4};

	colorScrollbar[] = {Dlg_Color_White,1};
	arrowEmpty = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_ca.paa";
	arrowFull = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_active_ca.paa";
	wholeHeight = 0;
	color[] = {1,1,1,1};
	colorActive[] = {1,0,0,1};
	colorDisabled[]	 = {1,0,0,0.3};
	font = "PuristaMedium";
	sizeEx = 0.030;
	rowHeight = 0.04;


  soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1};
  soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1};
  soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1};
  soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1};
  soundSelect[] = {"\A3\ui_f\data\sound\RscListbox\soundSelect",0.09,1};
  soundExpand[] = {"\A3\ui_f\data\sound\RscCombo\soundExpand",0.1,1};

	autoScrollSpeed = -1;
	autoScrollDelay = 5;
	autoScrollRewind = 0;
	maxHistoryDelay = 1;

  colorShadow[] = {0,0,0,0.5};


  period = 1.2;
  colorPicture[] = {1,1,1,1};
  colorPictureSelected[] = {1,1,1,1};
  colorPictureDisabled[] = {1,1,1,1};
  tooltipColorText[] = {1,1,1,1};
  tooltipColorBox[] = {1,1,1,1};
  tooltipColorShade[] = {0,0,0,0.65};

	class ScrollBar {
		color[] = {1,1,1,0.6};
		colorActive[] = {1,1,1,1};
		colorDisabled[] = {1,1,1,0.3};
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
	};

  class ListScrollBar: ScrollBar {
    color[] = {1,1,1,1};
    autoScrollEnabled = 1;
  };

};



class gui_RscListNBox : gui_RscListBox {
	type = CT_LISTNBOX;
	colorSelect[] = {1,1,1,1};
	colorText[] = {1,1,1,1};
	colorBackground[] = {0,0,0,0.15};
	colorSelectBackground[] = {0,0,0,0};
	drawSideArrows = 0;
	toolTip = "";
	idcLeft = 20010;
	idcRight = 20011;
};


class gui_RscCombo {
	type = CT_COMBO;
	style = ST_MULTI;
	lineSpacing = 1;
	shadow = 0;
	sizeEx = 0.030;
	rowHeight = 0.04;

	//colorSelect[] = {0,0,0,1.0};
	colorSelect[] = {1,1,1,1.0};
	colorText[] = {1,1,1,1};
	colorBackground[] = {0.8,0.8,0.8,0.3};
//	colorSelectBackground[] = {0.7,0.7,0.7,1};
	colorSelectBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.69])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.75])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.5])","(profilenamespace getvariable ['GUI_BCG_RGB_A',0.8])"};
	colorScrollbar[] = {Dlg_Color_White,1};
	arrowEmpty = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_ca.paa";
	arrowFull = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_active_ca.paa";
	wholeHeight = 0.45;
	color[] = {1,1,1,1};
	colorActive[] = {1,0,0,1};
	colorDisabled[]	 = {1,0,0,0.3};
	font = "PuristaMedium";


	soundEnter[] = {"\A3\ui_f\data\sound\onover",0.09,1};
	soundPush[] = {"\A3\ui_f\data\sound\new1",0.0,0};
	soundClick[] = {"\A3\ui_f\data\sound\onclick",0.07,1};
	soundEscape[] = {"\A3\ui_f\data\sound\onescape",0.09,1};
	soundSelect[] = {"\A3\ui_f\data\sound\new1",0.0,0};
	soundExpand[] = {"\A3\ui_f\data\sound\new1",0.0,0};
	soundCollapse[] = {"\A3\ui_f\data\sound\new1",0.0,0};
	autoScrollSpeed = -1;
	autoScrollDelay = 5;
	autoScrollRewind = 0;
	maxHistoryDelay = 1;

	class ScrollBar
	{
		color[] = {1,1,1,0.6};
		colorActive[] = {1,1,1,1};
		colorDisabled[] = {1,1,1,0.3};
		thumb = "\a3\ui_f\data\gui\cfg\Scrollbar\thumb_ca.paa";
		arrowEmpty = "\a3\ui_f\data\gui\cfg\Scrollbar\arrowempty_ca.paa";
		arrowFull = "\a3\ui_f\data\gui\cfg\Scrollbar\arrowfull_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
	};

  class ComboScrollBar
  {
    color[] = {1,1,1,0.6};
    colorActive[] = {1,1,1,1};
    colorDisabled[] = {1,1,1,0.3};
    shadow = 0;
    thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
    arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
    arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
    border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
  };
};

/*
class RscCombo: RscLB_C {
	type            = CT_COMBO;
	wholeHeight     = 0.3;
	soundSelect[]   = {"",0.15,1};
	soundExpand[]   = {"",0.15,1};
	soundCollapse[] = {"",0.15,1};
	arrowEmpty = "";
	arrowFull = "";
};
*/

class gui_RscSliderH {
	idc     = -1;
	access  = ReadandWrite;
	type    = CT_SLIDER;
	sizeEx  = 0.025;
	style   = 1024;

	color[] = {1,1,1,0.6};
	colorActive[] = {1,1,1,1};
	colorDisabled[] = {1,1,1,0.2};
	arrowEmpty = "\A3\ui_f\data\gui\cfg\slider\arrowEmpty_ca.paa";
	arrowFull = "\A3\ui_f\data\gui\cfg\slider\arrowFull_ca.paa";
	border = "\A3\ui_f\data\gui\cfg\slider\border_ca.paa";
	thumb = "\A3\ui_f\data\gui\cfg\slider\thumb_ca.paa";
};

class gui_RscSliderV {
	access  = ReadandWrite;
	type    = CT_SLIDER;
	idc     = -1;
	sizeEx  = 0.025;
	style   = 0;
	color[] = {0.2,0.2,0.2,1};
	colorActive[] = {1,1,1,1};
};

class gui_RscCheckBox {
	idc = -1;
	type = CT_CHECKBOXES;
	style = ST_CENTER;

	colorText[] = {1,1,1,1};
	color[] = {0,1,0,1};
	colorTextSelect[] = {0,0.8,0,1};
	colorSelectedBg[] = {1,1,1,0};
	colorSelect[] = {0,0,0,1};
	colorTextDisable[] = {0.4,0.4,0.4,1};
	colorDisable[] = {0.4,0.4,0.4,1};
	font = "PuristaMedium";
	SizeEX=0.025;
	rows = 1;
	columns = 1;
	strings[] = {""};
};