#define TitleBarH 0.07 * SafeZoneH
#define EXPL_VERSION Version 2.02
#define EXPL_TITLE Config Explorer by HeliJunkie

// Control types
#define CT_STATIC           0
#define CT_BUTTON           1
#define CT_EDIT             2
#define CT_SLIDER           3
#define CT_COMBO            4
#define CT_LISTBOX          5
#define CT_TOOLBOX          6
#define CT_CHECKBOXES       7
#define CT_PROGRESS         8
#define CT_HTML             9
#define CT_STATIC_SKEW      10
#define CT_ACTIVETEXT       11
#define CT_TREE             12
#define CT_STRUCTURED_TEXT  13
#define CT_CONTEXT_MENU     14
#define CT_CONTROLS_GROUP   15
#define CT_SHORTCUTBUTTON   16
#define CT_XKEYDESC         40
#define CT_XBUTTON          41
#define CT_XLISTBOX         42
#define CT_XSLIDER          43
#define CT_XCOMBO           44
#define CT_ANIMATED_TEXTURE 45
#define CT_OBJECT           80
#define CT_OBJECT_ZOOM      81
#define CT_OBJECT_CONTAINER 82
#define CT_OBJECT_CONT_ANIM 83
#define CT_LINEBREAK        98
#define CT_USER             99
#define CT_MAP              100
#define CT_MAP_MAIN         101
#define CT_LISTNBOX         102

// Static styles
#define ST_POS            0x0F
#define ST_HPOS           0x03
#define ST_VPOS           0x0C
#define ST_LEFT           0x00
#define ST_RIGHT          0x01
#define ST_CENTER         0x02
#define ST_DOWN           0x04
#define ST_UP             0x08
#define ST_VCENTER        0x0c

#define ST_TYPE           0xF0
#define ST_SINGLE         0
#define ST_MULTI          16
#define ST_TITLE_BAR      32
#define ST_PICTURE        48
#define ST_FRAME          64
#define ST_BACKGROUND     80
#define ST_GROUP_BOX      96
#define ST_GROUP_BOX2     112
#define ST_HUD_BACKGROUND 128
#define ST_TILE_PICTURE   144
#define ST_WITH_RECT      160
#define ST_LINE           176

#define ST_SHADOW         0x100
#define ST_NO_RECT        0x200
#define ST_KEEP_ASPECT_RATIO  0x800

#define ST_TITLE          ST_TITLE_BAR + ST_CENTER

// Color defines
// #define CA_UI_HUD_Green				{0.600,0.8392,0.4706,1.0}
// #define CA_IGUI_GreenDark			{0.659,0.863,0.549,1}
// #define CA_IGUI_Green				{0.6000,0.8392,0.4706,1.0}
// #define CA_IGUI_Green_Transparent	{0.6000,0.8392,0.4706,0.75}
// #define CA_IGUI_Red					{0.706,0.0745,0.0196,1}
// #define CA_IGUI_Orange				{0.863,0.584,0.0,1}
// #define CA_IGUI_Blue				{0.196,0.592,0.706, 1}
// #define CA_IGUI_Grey				{0.606,0.606,0.606,1}
// #define CA_IGUI_Background			{0.1882,0.2588,0.1490,0.76}
// #define CA_IGUI_DarkGreen			{0.424,0.651,0.247, 1}
// #define Color_White					{0.95, 0.95, 0.95, 1}
// #define Color_Black					{0.023529, 0, 0.0313725, 1}
// #define Color_Gray					{1, 1, 1, 0.5}
// #define Color_Orange				{1, 0.537, 0, 1}

// #define Color_OA_Text				{0.8784, 0.8471, 0.651, 1}


// Text Size
#define TextSize_small 		SafeZoneH * 0.016
#define TextSize_normal 	SafeZoneH * 0.018
#define TextSize_big        SafeZoneH * 0.022
#define TextSize_title 		SafeZoneH * 0.040



// main dialog definiton
class HJ_ConfigExplorer
	{ 
	idd = 19000; 
	enableSimulation = 0;
	movingEnable = 0;
	//onLoad = "_this call c_proving_ground_HJ_fnc_InitDialog;";
	onUnLoad = "_this call c_proving_ground_HJ_fnc_EndDialog;";
	
	controlsBackground[] = 
	{ 
		BackGround,
		TitleBar
	}; 
	objects[] = { }; 
	controls[] = {
		tCurrentPathText,
		tCurrentPathValue,
		tConfigText,
		cConfigValue,
		frmClasses,
		lbClasses,
		frmValues,
		lbValues,
		sbtnDumpClasses,
		sbtnUp,
		frmOrder,
		lbOrder,
		sbtnCopyClip,
		eCode,
		tVersion,
		sbtnClose
	};
	
	// external class references
	#include "defs_base_control.cpp"

	class RSC_HJ_ShortcutButton: RscIGUIShortcutButton 
	{
		w = 0.1 * SafeZoneW;
		h = 0.05 * SafeZoneW;
		size = TextSize_normal;
		sizeEx = TextSize_normal;
		class TextPos: TextPos
		{
			top = ((0.05 * SafeZoneW) - TextSize_normal) / 4);
			//top = 0.004;
		}
	};



	//****************************************
	//*** Background Controls
	//****************************************
	
	class BackGround:RscBackground
	{
		style = ST_HUD_BACKGROUND;
		
		x = SafeZoneX;
		y = SafeZoneY; 
		w = SafeZoneW;
		h = SafeZoneH;
		
		colorBackground[] = {0.05, 0.05, 0.05, 0.95};
	};
	
	
	class TitleBar:RscTitle
	{
		style = ST_TITLE;
		x = SafeZoneX + 0.01;
		y = SafeZoneY + 0.01; 
		w = SafeZoneW - 0.02;
		h = TitleBarH - 0.01;
		sizeEx = TextSize_title;
		
		text = EXPL_TITLE;
	};
	
	
	//****************************************
	//*** Controls
	//****************************************
	
	class tCurrentPathText:RscText 
	{
		idc = -1;
		style = ST_FRAME;
		x = ((0.01 * SafeZoneW) + SafeZoneX);
		y = ((0.08 * SafeZoneH) + SafeZoneY);
		w = (0.74 * SafeZoneW);
		h = (2.5 * TextSize_normal);
		sizeEx = TextSize_normal;
		
		text = "Current Config Path";
		// colorText[] = Color_OA_Text;
	};
	
	class tCurrentPathValue:RscText 
	{
		idc = 101;
		style = ST_LEFT;
		x = ((0.01 * SafeZoneW) + SafeZoneX);
		y = ((0.10 * SafeZoneH) + SafeZoneY);
		w = (0.74 * SafeZoneW);
		sizeEx = TextSize_normal;
		
		text = "Current Config Path";
	};
	
	class tConfigText:RscText 
	{
		idc = -1;
		style = ST_RIGHT;
		x = ((0.76 * SafeZoneW) + SafeZoneX);
		y = ((0.10 * SafeZoneH) + SafeZoneY);
		w = (0.08 * SafeZoneW);
		sizeEx = TextSize_normal;
		
		text = "Config:";
	};
	
	class cConfigValue:RscCombo 
	{
		idc = 103;
		x = ((0.85 * SafeZoneW) + SafeZoneX);
		y = ((0.10 * SafeZoneH) + SafeZoneY);
		w = (0.13 * SafeZoneW);
		sizeEx = TextSize_normal;
		onLBSelChanged = "_this call c_proving_ground_HJ_fnc_onConfigChange";
	};
	
	class frmClasses:RscText
	{
		idc = -1;
		type = CT_STATIC;
		style =  ST_FRAME;
		x = ((0.01 * SafeZoneW) + SafeZoneX);
		y = ((0.14 * SafeZoneH) + SafeZoneY);
		w = (0.28 * SafeZoneW);
		h = (0.47 * SafeZoneH);
		sizeEx = TextSize_normal;
		
		text = "Classes";
	};
	
	class lbClasses:RscIGUIListBox 
	{
		idc = 110;
		x = ((0.01 * SafeZoneW) + SafeZoneX);
		y = ((0.14 * SafeZoneH) + SafeZoneY) + TextSize_normal;
		w = (0.28 * SafeZoneW);
		h = (0.46 * SafeZoneH) - (TextSize_normal / 2);
		sizeEx = TextSize_normal;
		
		rowHeight = TextSize_normal;
		
		onLBDblClick = "_this call c_proving_ground_HJ_fnc_onDoubleClickClass;";
	};
	
	class frmValues:RscText
	{
		idc = -1;
		type = CT_STATIC;
		style =  ST_FRAME;
		x = ((0.31 * SafeZoneW) + SafeZoneX);
		y = ((0.14 * SafeZoneH) + SafeZoneY);
		w = (0.68 * SafeZoneW);
		h = (0.47 * SafeZoneH);
		sizeEx = TextSize_normal;
		
		text = "Values";
	};
	
	class lbValues:RscIGUIListBox 
	{
		idc = 111;
		x = ((0.31 * SafeZoneW) + SafeZoneX);
		y = ((0.14 * SafeZoneH) + SafeZoneY) + TextSize_normal;
		w = (0.68 * SafeZoneW);
		h = (0.46 * SafeZoneH) - (TextSize_normal / 2);
		sizeEx = TextSize_normal;
		
		rowHeight = TextSize_normal;
	};

	class sbtnDumpClasses:RSC_HJ_ShortcutButton 
	{
		idc = 119;
		x = ((0.09 * SafeZoneW) + SafeZoneX);
		y = ((0.61 * SafeZoneH) + SafeZoneY);
		
		text = "dump";
		tooltip = "dump all classnames to edit box";
		
		onButtonClick = "_this call c_proving_ground_HJ_fnc_onButtonClick_dump;";
	};

	class sbtnUp:RSC_HJ_ShortcutButton 
	{
		idc = 120;
		x = ((0.19 * SafeZoneW) + SafeZoneX);
		y = ((0.61 * SafeZoneH) + SafeZoneY);
		
		text = "up";
		tooltip = "move to parent class";
		
		onButtonClick = "_this call c_proving_ground_HJ_fnc_onButtonClick_up;";
	};
	
	class frmOrder:RscText
	{
		idc = -1;
		type = CT_STATIC;
		style =  ST_FRAME;
		x = ((0.01 * SafeZoneW) + SafeZoneX);
		y = ((0.65 * SafeZoneH) + SafeZoneY);
		w = (0.28 * SafeZoneW);
		h = (0.25 * SafeZoneH);
		text = "Parents";
		sizeEx = TextSize_normal;
		// colorText[] = Color_OA_Text;
	};
	
	class lbOrder:RscIGUIListBox 
	{
		idc = 112;
		x = ((0.01 * SafeZoneW) + SafeZoneX);
		y = ((0.65 * SafeZoneH) + SafeZoneY) + TextSize_normal;
		w = (0.28 * SafeZoneW);
		h = (0.25 * SafeZoneH) - TextSize_normal;
		sizeEx = TextSize_normal;		

		rowHeight = TextSize_normal;
	};
	
	class eCode:RscEdit 
	{
		idc = 113;
		style = ST_MULTI;
		x = ((0.31 * SafeZoneW) + SafeZoneX);
		y = ((0.65 * SafeZoneH) + SafeZoneY);
		w = (0.68 * SafeZoneW);
		h = (0.25 * SafeZoneH);
		sizeEx = TextSize_small;
		
		font = "LucidaConsoleB";
		linespacing = 2;
		autocomplete = "general";
	};
	
	class sbtnCopyClip:RSC_HJ_ShortcutButton
	{
		x = ((0.31 * SafeZoneW) + SafeZoneX);
		y = ((0.905 * SafeZoneH) + SafeZoneY);
	
		text = "-> Clipboard";
		tooltip = "copy all text to clipboard";
		
		action = "copyToClipboard ctrlText 113;";
	}
	
	class tVersion:RscText 
	{
		style = ST_RIGHT;
		x = ((0.70 * SafeZoneW) + SafeZoneX);
		y = ((0.95 * SafeZoneH) + SafeZoneY);
		w = (0.19 * SafeZoneW);
		sizeEx = TextSize_small;
		
		text = EXPL_VERSION;
	};
	
	class sbtnClose:RSC_HJ_ShortcutButton 
	{
		x = ((0.90 * SafeZoneW) + SafeZoneX);
		y = ((0.95 * SafeZoneH) + SafeZoneY);
	
		text = "close";
		action = "closeDialog 0";
		
		tooltip = "close explorer";
	};
};