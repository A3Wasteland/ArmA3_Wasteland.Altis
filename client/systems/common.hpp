/*
	@file Version: 1.0
	@file Name: common.hpp
	@file Author: [404] Deadbeat
	@file Created: 11/09/2012 04:23
	@file Args:
*/

#define CT_STATIC 0 
#define CT_BUTTON 1 
#define CT_EDIT 2 
#define CT_SLIDER 3 
#define CT_COMBO 4 
#define CT_LISTBOX 5 
#define CT_TOOLBOX 6 
#define CT_CHECKBOXES 7 
#define CT_PROGRESS 8 
#define CT_HTML 9 
#define CT_STATIC_SKEW 10 
#define CT_ACTIVETEXT 11 
#define CT_TREE 12 
#define CT_STRUCTURED_TEXT 13 
#define CT_CONTEXT_MENU 14 
#define CT_CONTROLS_GROUP 15 
#define CT_SHORTCUT_BUTTON 16 // Arma 2 - textured button 
#define CT_XKEYDESC 40 
#define CT_XBUTTON 41 
#define CT_XLISTBOX 42 
#define CT_XSLIDER 43 
#define CT_XCOMBO 44 
#define CT_ANIMATED_TEXTURE 45 
#define CT_CHECKBOX 77 
#define CT_OBJECT 80 
#define CT_OBJECT_ZOOM 81 
#define CT_OBJECT_CONTAINER 82 
#define CT_OBJECT_CONT_ANIM 83 
#define CT_LINEBREAK 98 
#define CT_USER 99 
#define CT_MAP 100 
#define CT_MAP_MAIN 101 
#define CT_List_N_Box 102 // Arma 2 - N columns list box 

// Static styles 
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
#define ST_MULTI 16 
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

// Slider styles 
#define SL_DIR 0x400 
#define SL_VERT 0 
#define SL_HORZ 0x400 
#define SL_TEXTURES 0x10 

// Listbox styles 
#define LB_TEXTURES 0x10 
#define LB_MULTI 0x20 

#define true 1
#define false 1

class w_RscText {

	idc = -1;
	type = CT_STATIC;
	style = ST_LEFT;
	colorBackground[] = { 1 , 1 , 1 , 0 };
	colorText[] = { 1 , 1 , 1 , 1 };
	font = "PuristaMedium";
	sizeEx = 0.025;
	h = 0.25;
	text = "";
};

class w_RscTextCenter : w_RscText
{
	style = ST_CENTER;
};

class w_RscStructuredText
{
	access = 0;
	type = 13;
	idc = -1;
	style = 0;
	colorText[] = { 1 , 1 , 1 , 1 };
	class Attributes
	{
		font = "PuristaMedium";
		//color = "#e0d8a6";
		align = "center";
		shadow = 0;
	};
	x = 0;
	y = 0;
	h = 0.035;
	w = 0.1;
	text = "";
	size = 0.03921;
	shadow = 2;
};

class w_RscStructuredTextLeft
{
	access = 0;
	type = 13;
	idc = -1;
	style = 0;
	colorText[] = { 1 , 1 , 1 , 1 };
	class Attributes
	{
		font = "PuristaMedium";
		//color = "#e0d8a6";
		align = "left";
		shadow = 0;
	};
	x = 0;
	y = 0;
	h = 0.035;
	w = 0.1;
	text = "";
	size = 0.03921;
	shadow = 2;
};

class w_RscBackground
{

    colorBackground[] = {0.14, 0.18, 0.13, 0.8};
    text              = "";
    type              = CT_STATIC;
    idc               = -1;
    style             = ST_LEFT;
    colorText[]       = {1, 1, 1, 1};
    font              = "PuristaMedium";
    sizeEx            = 0.04;
};

class w_RscEdit
{
    idc = -1;
    type = CT_EDIT;
    style = ST_LEFT;
    x = 0;
    y = 0;
    w = .2;
    h = .4;
    sizeEx = .02;
    font = "PuristaMedium";

    text = "";
    colorText[] = {1,1,1,1};

    autocomplete = false;
    colorSelection[] = {0,0,0,1};
};

class w_RscListBox
{
	idc = -1;
	type = CT_LISTBOX;
	style = ST_MULTI;
	w = 0.4;
	h = 0.4;
	rowHeight = 0;
	colorText[] = {1, 1, 1, 1};
	colorDisabled[] = {1, 1, 1, 0.25};
	colorScrollbar[] = {1, 0, 0, 0};
	colorSelect[] = {0, 0, 0, 1};
	colorSelect2[] = {0, 0, 0, 1};
	colorSelectBackground[] = {0.95, 0.95, 0.95, 1};
	colorSelectBackground2[] = {1, 1, 1, 0.5};
	colorBackground[] = {0, 0, 0, 0.3};
	soundSelect[] = {"\A3\ui_f\data\sound\RscListbox\soundSelect", 0.09, 1};
	autoScrollSpeed = -1;
	autoScrollDelay = 5;
	autoScrollRewind = 0;
	arrowEmpty = "#(argb,8,8,3)color(1,1,1,1)";
	arrowFull = "#(argb,8,8,3)color(1,1,1,1)";
	colorPicture[] = {1, 1, 1, 1};
	colorPictureSelected[] = {1, 1, 1, 1};
	colorPictudeDisabled[] = {1, 1, 1, 0.25};
	tooltipColorText[] = {1, 1, 1, 1};
	tooltipColorBox[] = {1, 1, 1, 1};
	tooltipColorShade[] = {0, 0, 0, 0.65};
	font = "PuristaMedium";
	sizeEx = 0.035;
	shadow = 0;
	colorShadow[] = {0, 0, 0, 0.5};
	period = 0.8;
	maxHistoryDelay = 1;
	colorPictureDisabled[] = {1, 1, 1, 1};

	class ListScrollBar
	{
		color[] = {1, 1, 1, 1};
		colorActive[] = {1, 1, 1, 1}; 
		colorDisabled[] = {1, 1, 1, 0.3}; 
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
	};
};

class w_RscList: w_RscListBox {};

class w_RscPicture 
{

	idc = -1; 
	type = CT_STATIC;
	style = ST_PICTURE;
	
	font = "PuristaMedium";
	sizeEx = 0.023;
	
	colorBackground[] = {};
	colorText[] = {};
	
	x = 0.0; y = 0.2;
	w = 0.2; h = 0.2;
	
	text = "";
	
}; 

class w_RscButtonBase {

	idc = -1;
	type = 16;
	style = 0;
	
	w = 0.183825;
	h = 0.104575;
	
	color[] = {0.95, 0.95, 0.95, 1};
	color2[] = {1, 1, 1, 0.4};
	colorBackground[] = {0.75, 0.75, 0.75, 0.8};
	colorbackground2[] = {1, 1, 1, 0.4};
	colorDisabled[] = {1, 1, 1, 0.25};
	
	periodFocus = 1.2;
	periodOver = 0.8;
	
	class HitZone {
	
		left = 0.004;
		top = 0.029;
		right = 0.004;
		bottom = 0.029;
		
	};
	
	class ShortcutPos {
	
		left = 0.004;
		top = 0.026;
		w = 0.0392157;
		h = 0.0522876;
		
	};
	
	class TextPos {
	
		left = 0.05;
		top = 0.025;
		right = 0.005;
		bottom = 0.025;
		
	};
	
	animTextureDefault = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\normal_ca.paa";
	animTextureNormal = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\normal_ca.paa";
	animTextureDisabled = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\normal_ca.paa";
	animTextureOver = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\over_ca.paa";
	animTextureFocused = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\focus_ca.paa";
	animTexturePressed = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\down_ca.paa";
	textureNoShortcut = "";
	
	period = 0.4;
	font = "PuristaMedium";
	size = 0.023;
	sizeEx = 0.023;
	text = "";
	
	soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter", 0.09, 1};
	soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush", 0.09, 1};
	soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick", 0.09, 1};
	soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape", 0.09, 1};

	action = "";
	
	class Attributes {
	
		font = "PuristaMedium";
		color = "#E5E5E5";
		align = "left";
		shadow = false;
		
	};
	
	class AttributesImage {
	
		font = "PuristaMedium";
		color = "#E5E5E5";
		align = "left";
		
	};
};

class w_RscButton
{
   access = 0;
    type = CT_BUTTON;
    text = "";
    colorText[] = {1,1,1,.9};
    colorDisabled[] = {0,0,0,1};
    colorBackground[] = {0.2,0.41,0.78,1}; // normal
	colorFocused[] = {0.14,0.25,0.49,1}; // pulse
    colorBackgroundActive[] = {0.25,0.51,0.96,1}; // hover
	colorBackgroundDisabled[] = {0.3,0.3,0.3,1};
    colorShadow[] = {0,0,0,1};
    colorBorder[] = {0,0,0,1};
	soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter", 0.09, 1};
	soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush", 0.09, 1};
	soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick", 0.09, 1};
	soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape", 0.09, 1};
  	animTextureDefault = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\normal_ca.paa";
	animTextureNormal = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\normal_ca.paa";
	animTextureDisabled = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\normal_ca.paa";
	animTextureOver = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\over_ca.paa";
	animTextureFocused = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\focus_ca.paa";
	animTexturePressed = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\down_ca.paa";
    style = 2;
    x = 0;
    y = 0;
    w = 0.055589;
    h = 0.039216;
    shadow = 0;
    font = "PuristaMedium";
    sizeEx = 0.04;
    offsetX = 0.003;
    offsetY = 0.003;
    offsetPressedX = 0.002;
    offsetPressedY = 0.002;
    borderSize = 0;
};

class w_RscCombo {

	idc = -1;
	type = 4;
	style = 0;
	x = "0.0 + 0.365";
	y = "0.0 + 0.038";
	w = 0.301000;
	h = 0.039216;
	font = "PuristaMedium";
	sizeEx = 0.025000;
	rowHeight = 0.025000;
	wholeHeight = "4 * 0.2";
	color[] = {1, 1, 1, 1};
	colorDisabled[] = {0,0,0,0.3};
	colorText[] = {0, 0, 0, 1};
	colorBackground[] = {1, 1, 1, 1};
	colorSelect[] = {1, 0, 0, 1};
	colorSelectBackground[] = {0.25,0.51,0.96,0.5};
	soundSelect[] = {"", 0.000000, 1};
	soundExpand[] = {"", 0.000000, 1};
	soundCollapse[] = {"", 0.000000, 1};
	maxHistoryDelay = 10;
	autoScrollSpeed = -1;
	autoScrollDelay = 5;
	autoScrollRewind = 0;
	colorScrollbar[] = {0.2, 0.2, 0.2, 1};

	period = 1;
	thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
	arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
	arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
	border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";

	class ComboScrollBar { 
		color[] = {1, 1, 1, 0.6}; 
		colorActive[] = {1, 1, 1, 1}; 
		colorDisabled[] = {1, 1, 1, 0.3}; 
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
	};	
};

class w_RscCheckBox
{
	idc = -1;
	type = CT_CHECKBOX;
	style = 0;
	checked = 0;
	w = "0.04 * (safezoneW min safezoneH)";
	h = "0.04 * (safezoneW min safezoneH)";
	color[] = {1, 1, 1, 0.7};
	colorFocused[] = {1, 1, 1, 1};
	colorHover[] = {1, 1, 1, 1};
	colorPressed[] = {1, 1, 1, 1};
	colorDisabled[] = {1, 1, 1, 0.2};
	colorBackground[] = {0, 0, 0, 0};
	colorBackgroundFocused[] = {0, 0, 0, 0};
	colorBackgroundHover[] = {0, 0, 0, 0};
	colorBackgroundPressed[] = {0, 0, 0, 0};
	colorBackgroundDisabled[] = {0, 0, 0, 0};
	textureChecked = "\A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_checked_ca.paa";
	textureUnchecked = "\A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_unchecked_ca.paa";
	textureFocusedChecked = "\A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_checked_ca.paa";
	textureFocusedUnchecked = "\A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_unchecked_ca.paa";
	textureHoverChecked = "\A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_checked_ca.paa";
	textureHoverUnchecked = "\A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_unchecked_ca.paa";
	texturePressedChecked = "\A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_checked_ca.paa";
	texturePressedUnchecked = "\A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_unchecked_ca.paa";
	textureDisabledChecked = "\A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_checked_ca.paa";
	textureDisabledUnchecked = "\A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_unchecked_ca.paa";
	tooltipColorText[] = {1, 1, 1, 1};
	tooltipColorBox[] = {1, 1, 1, 1};
	tooltipColorShade[] = {1, 1, 1, 1};
	soundEnter[] = {1, 1, 1, 1};
	soundPush[] = {1, 1, 1, 1};
	soundClick[] = {1, 1, 1, 1};
	soundEscape[] = {1, 1, 1, 1};
};
