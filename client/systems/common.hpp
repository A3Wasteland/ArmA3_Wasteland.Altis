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

class w_RscStructuredText
{
	access = 0;
	type = 13;
	idc = -1;
	style = 0;
	colorText[] = {0.8784,0.8471,0.651,1};
	class Attributes
	{
		font = "PuristaSemibold";
		color = "#e0d8a6";
		align = "center";
		shadow = 1;
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
    font              = "PuristaSemibold";
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
    font = "PuristaSemibold";

    text = "";
    colorText[] = {1,1,1,1};

    autocomplete = false;
    colorSelection[] = {0,0,0,1};
	colorActive[] = {0,0,0,1};
    colorDisabled[] = {0,0,0,0.3};
};

class w_RscListBox
{
	type = CT_LISTBOX;
    style = 69;
    idc = -1;
    text = "";
    w = 0.275;
    h = 0.04;
    colorSelect[] = {1, 1, 1, 1};
    colorText[] = {1, 1, 1, 1};
    colorBackground[] = {0,0,0,0};
    colorSelectBackground[] = {0.40, 0.43, 0.28, 0.5};
    colorScrollbar[] = {0.2, 0.2, 0.2, 1};
    arrowEmpty = "client\ui\ui_arrow_combo_ca.paa";
    arrowFull = "client\ui\ui_arrow_combo_active_ca.paa";
    wholeHeight = 0.45;
    rowHeight = 0.04;
    color[] = {0.7, 0.7, 0.7, 1};
    colorActive[] = {0,0,0,1};
    colorDisabled[] = {0,0,0,0.3};
    font = "PuristaMedium";
    sizeEx = 0.026;
    soundSelect[] = {"",0.1,1};
    soundExpand[] = {"",0.1,1};
    soundCollapse[] = {"",0.1,1};
    maxHistoryDelay = 1;
    autoScrollSpeed = -1;
    autoScrollDelay = 5;
    autoScrollRewind = 0;
	
    class ScrollBar
    {
		color[] = {1, 1, 1, 1};
        colorActive[] = {1, 1, 1, 1};
        colorDisabled[] = {1, 1, 1, 1};
        thumb = "client\ui\ui_scrollbar_thumb_ca.paa";
        arrowFull = "client\ui\ui_arrow_top_active_ca.paa";
        arrowEmpty = "client\ui\ui_arrow_top_ca.paa";
        border = "client\ui\ui_border_scroll_ca.paa";
    };
};

class w_Rsclist
{
        type = CT_LISTBOX;
        style = 69;
        idc = -1;
        text = "";
        w = 0.275;
        h = 0.04;
        colorSelect[] = {1, 1, 1, 1};
        colorText[] = {1, 1, 1, 1};
        colorBackground[] = {0,0,0,0};
        colorSelectBackground[] = {0.40, 0.43, 0.28, 0.5};
        colorScrollbar[] = {0.2, 0.2, 0.2, 1};
        arrowEmpty = "client\ui\ui_arrow_combo_ca.paa";
        arrowFull = "client\ui\ui_arrow_combo_active_ca.paa";
        wholeHeight = 0.45;
        rowHeight = 0.04;
        color[] = {0.7, 0.7, 0.7, 1};
        colorActive[] = {0,0,0,1};
        colorDisabled[] = {0,0,0,0.3};
        font = "PuristaSemibold";
        sizeEx = 0.023;
        soundSelect[] = {"",0.1,1};
        soundExpand[] = {"",0.1,1};
        soundCollapse[] = {"",0.1,1};
        maxHistoryDelay = 1;
        autoScrollSpeed = -1;
        autoScrollDelay = 5;
        autoScrollRewind = 0;

        class ScrollBar
        {
                color[] = {1, 1, 1, 1};
                colorActive[] = {1, 1, 1, 1};
                colorDisabled[] = {1, 1, 1, 1};
                thumb = "client\ui\ui_scrollbar_thumb_ca.paa";
                arrowFull = "client\ui\ui_arrow_top_active_ca.paa";
                arrowEmpty = "client\ui\ui_arrow_top_ca.paa";
                border = "client\ui\ui_border_scroll_ca.paa";
        };
};

class w_RscPicture 
{

	idc = -1; 
	type = CT_STATIC;
	style = ST_PICTURE;
	
	font = "PuristaSemibold";
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
	colorBackground[] = {1, 1, 1, 1};
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
	
	animTextureNormal = "client\ui\ui_button_normal_ca.paa";
	animTextureDisabled = "client\ui\ui_button_disabled_ca.paa";
	animTextureOver = "client\ui\ui_button_over_ca.paa";
	animTextureFocused = "client\ui\ui_button_focus_ca.paa";
	animTexturePressed = "client\ui\ui_button_down_ca.paa";
	animTextureDefault = "client\ui\ui_button_default_ca.paa";
	textureNoShortcut = "";
	
	period = 0.4;
	font = "PuristaMedium";
	size = 0.023;
	sizeEx = 0.024;
	text = "";
	
	soundEnter[] = {"\A3\ui_f\data\Sound\MOUSE2", 0.09, 1};
	soundPush[] = {"\A3\ui_f\data\Sound\NEW1", 0.09, 1};
	soundClick[] = {"\A3\ui_f\data\Sound\MOUSE3", 0.07, 1};
	soundEscape[] = {"\A3\ui_f\data\Sound\MOUSE1", 0.09, 1};
	
	action = "";
	
	class Attributes {
	
		font = "PuristaSemibold";
		color = "#E5E5E5";
		align = "left";
		shadow = "true";
		
	};
	
	class AttributesImage {
	
		font = "PuristaSemibold";
		color = "#E5E5E5";
		align = "left";
		
	};
};

class w_RscButton : w_RscButtonBase {

	w = 0.183825;
	h = 0.0522876;

	style = 2;

	color[] = {1, 1, 1, 1};
	color2[] = {1, 1, 1, 0.85};
	colorBackground[] = {1, 1, 1, 1};
	colorbackground2[] = {1, 1, 1, 0.85};
	colorDisabled[] = {1, 1, 1, 0.4};
	
	class HitZone {
	
		left = 0.002;
		top = 0.003;
		right = 0.002;
		bottom = 0.016;
		
	};
	
	class ShortcutPos {
	
		left = -0.006;
		top = -0.007;
		w = 0.0392157;
		h = 0.0522876;
		
	};
	
	class TextPos {
	
		left = 0.002;
		top = 0.014;
		right = 0.002;
		bottom = 0.005;
	};
	
	animTextureNormal = "client\ui\igui_button_normal_ca.paa";
	animTextureDisabled = "client\ui\igui_button_disabled_ca.paa";
	animTextureOver = "client\ui\igui_button_over_ca.paa";
	animTextureFocused = "client\ui\igui_button_focus_ca.paa";
	animTexturePressed = "client\ui\igui_button_down_ca.paa";
	animTextureDefault = "client\ui\igui_button_normal_ca.paa";
	animTextureNoShortcut = "client\ui\igui_button_normal_ca.paa";
	
	class Attributes {
	
		font = "PuristaSemibold";
		color = "#E5E5E5";
		align = "center";
		shadow = "true";
		
	};
};

class RscButton
{

    type                      = CT_BUTTON;
    idc                       = -1;
    style                     = ST_CENTER;
    colorText[]               = {1, 1, 1, 1};
    font                      = "";
    sizeEx                    = 0.025;
    soundPush[]               = {"", 0.2, 1};
    soundClick[]              = {"ui\ui_ok", 0.2, 1};
    soundEscape[]             = {"ui\ui_cc", 0.2, 1};
    default                   = false;
    text                      = "";
    action                    = "";
    colorActive[]             = {0, 0, 0, 0};
    colorDisabled[]           = {0, 0, 0, 0.1};
    colorBackground[]         = {0.8,0.8,0.8,0.3};
    colorBackgroundActive[]   = {0.7,0.7,0.7,1};
    colorBackgroundDisabled[] = {1,1,1,0.5};
    colorFocused[]            = {0.84,1,0.55,1};
    colorShadow[]             = {0, 0, 0, 0.1};
    colorBorder[]             = {1, 1, 1, 0.1};
    offsetX                   = 0;
    offsetY                   = 0;
    offsetPressedX            = 0;
    offsetPressedY            = 0;
    borderSize                = 0;
    soundEnter[]              = {"", 0.15, 1};

};

class w_RscCombo {

	idc = -1;
	type = 4;
	style = 0;
	x = "0.0 + 0.365";
	y = "0.0 + 0.038";
	w = 0.301000;
	h = 0.030000;
	font = "TahomaB";
	sizeEx = 0.025000;
	rowHeight = 0.025000;
	wholeHeight = "4 * 0.2";
	color[] = {1, 1, 1, 1};
	colorDisabled[] = {0,0,0,0.3};
	colorText[] = {0, 0, 0, 1};
	colorBackground[] = {1, 1, 1, 1};
	colorSelect[] = {1, 0, 0, 1};
	colorSelectBackground[] = {0, 1, 0, 1};
	soundSelect[] = {"", 0.000000, 1};
	soundExpand[] = {"", 0.000000, 1};
	soundCollapse[] = {"", 0.000000, 1};
	maxHistoryDelay = 10;
	autoScrollSpeed = -1;
	autoScrollDelay = 5;
	autoScrollRewind = 0;
	colorScrollbar[] = {0.950000, 0.950000, 0.950000, 1};

	period = 1;
	thumb = "client\ui\ui_scrollbar_thumb_ca.paa";
	arrowFull = "client\ui\ui_arrow_top_active_ca.paa";
	arrowEmpty = "client\ui\ui_arrow_top_ca.paa";
	border = "client\ui\ui_border_scroll_ca.paa";

		class ScrollBar
		{
			color[] = {1, 1, 1, 1};
			colorActive[] = {1, 1, 1, 1};
			//colorDisabled[] = {1, 1, 1, 1};
			thumb = "client\ui\ui_scrollbar_thumb_ca.paa";
			arrowFull = "client\ui\data\ui_arrow_top_active_ca.paa";
			arrowEmpty = "client\ui\data\ui_arrow_top_ca.paa";
			border = "client\ui\ui_border_scroll_ca.paa";
		};
	
};