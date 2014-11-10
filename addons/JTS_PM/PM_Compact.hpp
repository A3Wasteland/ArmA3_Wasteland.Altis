#define JTS_CT_STATIC_PM			0
#define JTS_CT_EDIT_PM			2
#define JTS_CT_COMBO_PM			4

#define JTS_ST_LEFT_PM			0x00
#define JTS_ST_SINGLE_PM			0
#define JTS_ST_MULTI_PM			16
//#define ST_WITH_RECT			160
#define JTS_ST_NO_RECT_PM			0x200

#define JTS_FontM_PM			"PuristaMedium"

class JTS_GUI
{
	type = 0;
	idc = -1;
	style = 128;
	colorText[] = {1,1,1,1};
	font = JTS_FontM_PM;
	sizeEx = 0.04;
	shadow = 0;

	colorbackground[] = 
	{
		"(profilenamespace getvariable ['GUI_BCG_RGB_R',0])",
		"(profilenamespace getvariable ['GUI_BCG_RGB_G',1])",
		"(profilenamespace getvariable ['GUI_BCG_RGB_B',1])",
		"(profilenamespace getvariable ['GUI_BCG_RGB_A',0.8])"
	};
};

class JTS_RscButton
{
	idc = -1;
	type = 16;
	style = "0x02 + 0xC0";
	default = 0;
	shadow = 0;

	animTextureNormal = "#(argb,8,8,3)color(1,1,1,1)";
	animTextureDisabled = "#(argb,8,8,3)color(1,1,1,1)";
	animTextureOver = "#(argb,8,8,3)color(1,1,1,1)";
	animTextureFocused = "#(argb,8,8,3)color(1,1,1,1)";
	animTexturePressed = "#(argb,8,8,3)color(1,1,1,1)";
	animTextureDefault = "#(argb,8,8,3)color(1,1,1,1)";
	textureNoShortcut = "#(argb,8,8,3)color(0,0,0,0)";

	colorBackground[] = {0,0,0,0.8};
	colorBackgroundFocused[] = {1,1,1,1};
	colorBackground2[] = {0.75,0.75,0.75,1};
	color[] = {1,1,1,1};
	colorFocused[] = {0,0,0,1};
	color2[] = {0,0,0,1};
	colorText[] = {1,1,1,1};
	colorDisabled[] = {1,1,1,0.25};
	period = 1.2;
	periodFocus = 1.2;
	periodOver = 1.2;
	size = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";

	tooltipColorText[] = {1,1,1,1};
	tooltipColorBox[] = {1,1,1,1};
	tooltipColorShade[] = {0,0,0,0.65};

	soundEnter[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundEnter",0.09,1};
	soundPush[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundPush",0.09,1};
	soundClick[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundClick",0.09,1};
	soundEscape[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundEscape",0.09,1};

	w = 0.095 * SafeZoneW;
	h = 0.03 * SafeZoneH;

	class TextPos
	{
		left = "0.25 * (((safezoneW / safezoneH) min 1.2) / 40)";
		top = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) - (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)) / 2";
		right = 0.005;
		bottom = 0;
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

	class HitZone
	{
		left = 0;
		top = 0;
		right = 0;
		bottom = 0;
	};
};

class JTS_RscEdit
{
	access = 0;
	type = 2;

	colorBackground[] = {0,0,0,1};
	colorText[] = {0.95,0.95,0.95,1};
	colorDisabled[] = {0.95,0.95,0.95,1};

	colorSelection[] = 
	{
		"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.69])",
		"(profilenamespace getvariable ['GUI_BCG_RGB_G',0.75])",
		"(profilenamespace getvariable ['GUI_BCG_RGB_B',0.5])",
		1
	};

	autocomplete = "";
	text = "";
	size = 0.2;
	style = "0x00 + 0x40";
	font = "PuristaMedium";
	shadow = 2;
	sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	canModify = 1;

	tooltipColorText[] = {1,1,1,1};
	tooltipColorBox[] = {1,1,1,1};
	tooltipColorShade[] = {0,0,0,0.65};
};

class JTS_PMText
{
	type = JTS_CT_STATIC_PM;
	style = JTS_ST_LEFT_PM;
	colorText[] = {1,1,1,1};
	colorBackground[] = {0, 0, 0, 0};
	font = JTS_FontM_PM;
	sizeEx = 0.03;
};

class JTS_PMlite: JTS_PMText
{
	font = "PuristaLight";
	sizeEx = 0.035;
};

class JTS_RscCombo
{
	style = "0x10 + 0x200";
	access = ReadAndWrite;
	type = JTS_CT_COMBO_PM;
	shadow = 0;
	maxHistoryDelay = 1;
	wholeHeight = 0.44 * SafeZoneH;
	font = JTS_FontM_PM;
	sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";

	colorSelect[] = {0,0,0,1};
	colorText[] = {1,1,1,1};
	colorBackground[] = {0,0,0,1};
	colorScrollbar[] = {1,0,0,1};
	colorSelectBackground[] = {1,1,1,0.7};
	colorActive[] = {1,0,0,1};
	colorDisabled[] = {1,1,1,0.25};

	tooltipColorText[] = {1,1,1,1};
	tooltipColorBox[] = {1,1,1,1};
	tooltipColorShade[] = {0,0,0,0.65};

	soundSelect[] = {"\A3\ui_f\data\sound\RscCombo\soundSelect",0.1,1};
	soundExpand[] = {"\A3\ui_f\data\sound\RscCombo\soundExpand",0.1,1};
	soundCollapse[] = {"\A3\ui_f\data\sound\RscCombo\soundCollapse",0.1,1};

	arrowEmpty = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_ca.paa";
	arrowFull = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_active_ca.paa";

	class ComboScrollBar
	{
		color[] = {1,1,1,1};
		autoScrollEnabled = 1;
		colorActive[] = {1, 1, 1, 1};
		colorDisabled[] = {1, 1, 1, 0.3};
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
	};
};

class JTS_PM
{
	idd = -1;
	movingEnable = false;
	controlsBackground[] = {JTS_METRO,JTS_LINE};

	class JTS_METRO: JTS_PMText
	{
		idc = -1;
		moving = 1;
		colorBackground[] = {0, 0, 0, 0.75};
 		text = "";
 		x = 0.2 * SafeZoneW + SafeZoneX;
 		y = 0.2 * SafeZoneH + SafeZoneY;
 		w = 0.3 * SafeZoneW;
 		h = 0.6 * SafeZoneH;
	};

	class JTS_LINE: JTS_GUI
	{
		idc = -1;
		moving = 1;
		text = "Messenger";
		x = 0.2 * SafeZoneW + SafeZoneX;
		y = 0.168 * SafeZoneH + SafeZoneY;
		w = 0.3 * SafeZoneW;
		h = 0.03 * SafeZoneH;
	};

	controls[] = {JTS_DESCTEXT,JTS_INBOX,JTS_SEND,JTS_EDIT,JTS_STAT,JTS_EDIT_TITLE,JTS_INFOTEXT,JTS_TYPING,JTS_TXT1,JTS_TXT2,BUT1,BUT2,BUT3};


	class JTS_DESCTEXT: JTS_PMlite
	{
		idc = 00001;
		style = JTS_ST_SINGLE_PM + JTS_ST_MULTI_PM + JTS_ST_NO_RECT_PM;
		linespacing = 1;
		shadow = 1;
		text = "";
		x = 0.2 * SafeZoneW + SafeZoneX;
		y = 0.3 * SafeZoneH + SafeZoneY;
		w = 0.3 * SafeZoneW;
		h = 0.3 * SafeZoneH;
	};

	class JTS_INBOX: JTS_RscCombo
	{
		idc = 00002;
		onLBSelChanged = "ctrlsettext [00001, lbData [00002, lbCursel 00002]]";
		x = 0.21 * SafeZoneW + SafeZoneX;
		y = 0.25 * SafeZoneH + SafeZoneY;
		w = 0.18 * SafeZoneW;
		h = 0.03 * SafeZoneH;

	};

	class JTS_SEND: JTS_RscCombo
	{
		idc = 00003;
		wholeHeight = 0.2 * SafeZoneH;
		x = 0.395 * SafeZoneW + SafeZoneX;
		y = 0.61 * SafeZoneH + SafeZoneY;
		w = 0.095 * SafeZoneW;
		h = 0.03 * SafeZoneH;

	};

	class JTS_EDIT: JTS_RscEdit
	{
		idc = 00004;
		text = "";
		toolTip = "Enter your message here";
		x = 0.21 * SafeZoneW + SafeZoneX;
		y = 0.75 * SafeZoneH + SafeZoneY;
		w = 0.28 * SafeZoneW;
		h = 0.04 * SafeZoneH;
	};

	class JTS_STAT: JTS_RscCombo
	{
		idc = 00005;
		onLBSelChanged = "player setVariable ['JTS_PM_STAT',lbValue [00005, lbCursel 00005], true]";
		toolTip = "Enable or disable the receiving of personal messages";
		wholeHeight = 0.2 * SafeZoneH;
		x = 0.395 * SafeZoneW + SafeZoneX;
		y = 0.25 * SafeZoneH + SafeZoneY;
		w = 0.095 * SafeZoneW;
		h = 0.03 * SafeZoneH;

	};

	class JTS_EDIT_TITLE: JTS_RscEdit
	{
		idc = 00006;
		text = "";
		toolTip = "Enter the title of the message here. Maximum length of the title is 15 characters";
		x = 0.21 * SafeZoneW + SafeZoneX;
		y = 0.7 * SafeZoneH + SafeZoneY;
		w = 0.19 * SafeZoneW;
		h = 0.04 * SafeZoneH;
	};

	class JTS_INFOTEXT: JTS_PMlite
	{
		idc = 00007;
		text = "";
		colorText[] = {0,1,0,1};
		x = 0.21 * SafeZoneW + SafeZoneX;
		y = 0.65 * SafeZoneH + SafeZoneY;
		w = 0.28 * SafeZoneW;
		h = 0.032 * SafeZoneH;
	};

	class JTS_TYPING: JTS_RscEdit
	{
		idc = 00008;
		text = "";
		x = 0.4 * SafeZoneW + SafeZoneX;
		y = 0.7 * SafeZoneH + SafeZoneY;
		w = 0.09 * SafeZoneW;
		h = 0.04 * SafeZoneH;
	};

	class BUT1: JTS_RscButton
	{
		idc = 00009;
		text = "SEND";
		action = "[] spawn JTS_FNC_SEND";
		x = 0.2 * SafeZoneW + SafeZoneX;
		y = 0.805 * SafeZoneH + SafeZoneY;
	};

	class BUT2: JTS_RscButton
	{
		idc = 00010;
		text = "CLOSE";
		action = "Closedialog 0";
		x = 0.405 * SafeZoneW + SafeZoneX;
		y = 0.805 * SafeZoneH + SafeZoneY;
	};

	class BUT3: JTS_RscButton
	{
		idc = 00011;
		text = "REMOVE";
		action = "[] spawn JTS_FNC_PM_DELETE";
		x = 0.3025 * SafeZoneW + SafeZoneX;
		y = 0.805 * SafeZoneH + SafeZoneY;
	};

	class JTS_TXT1: JTS_PMText
	{
		idc = -1;
		text = "Inbox:";
		x = 0.21 * SafeZoneW + SafeZoneX;
		y = 0.21 * SafeZoneH + SafeZoneY;
		w = 0.25 * SafeZoneW;
		h = 0.032 * SafeZoneH;
	};

	class JTS_TXT2: JTS_PMText
	{
		idc = -1;
		text = "Send to:";
		x = 0.21 * SafeZoneW + SafeZoneX;
		y = 0.606 * SafeZoneH + SafeZoneY;
		w = 0.195 * SafeZoneW;
		h = 0.032 * SafeZoneH;
	};
};