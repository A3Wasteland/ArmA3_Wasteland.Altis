////////////////////////////////////////////////////////
//                                                    //
//                    2013 Arma 3                     //
//           	    Lynx of <G.I.D>                   //
//             - http://www.clan-gid.fr -             //
//                                                    //
//             Object Positioning System V1.31        //
////////////////////////////////////////////////////////

class LxObjectPositioningSystem {

	idd = 24350;
	name = "LxObjectPositioningSystemDlg";
	movingEnable = true;
	fadein=1;
	controlsBackground[] = {};
	objects[] = { };
	controls[] = {
		LxOPSText,
		LxOPSNorth,
		LxOPSSouth,
		LxOPSEast,
		LxOPSWest,
		LxOPSUp,
		LxOPSDown,
		LxOPSLeft,
		LxOPSRight,
		LxOPSPitchL,
		LxOPSPitchR,
		LxOPSBankL,
		LxOPSBankR,
		LxOPSText,
		LxOPSComboTranslate,
		LxOPSComboRotate,
		LxOPSComboFilter,
		LxOPSComboPosSys,
		LxOPSCheckBoxLock,
		LxOPSComboReset,
		LxOPSReset,
		LxOPSNew,
		LxOPSSupr,
		LxOPSComboCopy,
		LxOPSComboEnableSim,
		LxOPSCopy,
		LxOPSLog,
		LxOPSObjectList,
		LxOPSTextInfo};

	class LxOPSButton {
	
		idc = -1;
		type = 16;
		style = 0x00;
		
		default = 0;
		color[] = {1, 1, 1, 1};
		color2[] = {1, 1, 1, 0.4};
		colorBackground[] = {0.5, 0.5, 0.5, 1};
		colorbackground2[] = {1, 1, 1, 0.4};
		colorDisabled[] = {1, 1, 1, 0.25};
		periodFocus = 1.2;
		colorFocused[] = {1, 1, 1, 1};
		colorBackgroundFocused[] = {1, 1, 1, 1};
		periodOver = 0.8;
		borderSize = 0;
		
		class HitZone {
			left = 0.0;
			top = 0.0;
			right = 0.0;
			bottom = 0.0;
		};
		
		class ShortcutPos {
			left = 0;
			top = 0;
			w = 0;
			h = 0;
		};
	
		class TextPos {
			left = 0.02;
			top = 0.001;
			right = 0.005;
			bottom = 0.0;
		};

		animTextureNormal = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\normal_ca.paa";
		animTextureDisabled = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\normal_ca.paa";
		animTextureOver = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\over_ca.paa";
		animTextureFocused = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\focus_ca.paa";
		animTexturePressed = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\down_ca.paa";
		animTextureDefault = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\normal_ca.paa";
		textureNoShortcut = "#(argb,8,8,3)color(0,0,0,0)";
		
		period = 0.4;
		font = "PuristaMedium";
		size = 0.026;
		sizeEx = 0.026;

		soundEnter[] = {};
		soundPush[] = {};
		soundClick[] = {};
		soundEscape[] = {};
		action = "";
		text = "";
	
		class Attributes {
			font = "PuristaMedium";
			color = "#E5E5E5";
			align = "left";
			shadow = "true";
		};
	
		class AttributesImage {
			font = "PuristaMedium";
			color = "#E5E5E5";
			align = "left";
		};
	};
	
	class LxOPSCombo
	{
		idc = -1;
		type = 4;
		style = 0x00;

		colorSelect[] = {1, 1, 1, 1};
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0.8,0.8,0.8,1};
		colorSelectBackground[] = {0, 0, 0, 1};
		colorScrollbar[] = {0.1, 0.12, 0.1, 1};
		arrowEmpty = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_ca.paa";
		arrowFull = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_active_ca.paa";
		rowHeight = 0.06;
		wholeHeight = 0.45;
		color[] = {0, 0, 0, 0.6};
		colorActive[] = {0, 0, 0, 1};
		colorDisabled[] = {0, 0, 0, 0.3};
		font = "PuristaMedium";
		sizeEx = 0.025;
		soundSelect[] = {"\ca\ui\data\sound\new1", 0.09, 1};
		soundExpand[] = {"\ca\ui\data\sound\new1", 0.09, 1};
		soundCollapse[] = {"\ca\ui\data\sound\new1", 0.09, 1};
		maxHistoryDelay = 1.0;
	
		class ComboScrollBar {
			color[] = {1, 1, 1, 0.6};
			colorActive[] = {1, 1, 1, 1};
			colorDisabled[] = {1, 1, 1, 0.3};
			thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
			arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
			arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
			border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
		};
	};

	class LxOPSList
	{
		idc = -1;
		type = 5;
		style = 16;

		arrowEmpty = "#(argb,8,8,3)color(1,1,1,1)";
		arrowFull = "#(argb,8,8,3)color(1,1,1,1)";
		autoScrollDelay = 5;
		autoScrollRewind = 0;
		autoScrollSpeed = -1;
		color[] = {1,1,1,1};
		colorBackground[] = {0,0,0,0.3};
		colorDisabled[] = {1,1,1,0.25};
		colorScrollbar[] = {1,0,0,0};
		colorSelect2[] = {0,0,0,1};
		colorSelect[] = {0,0,0,1};
		colorSelectBackground2[] = {1,1,1,0.5};
		colorSelectBackground[] = {0.95,0.95,0.95,1};
		colorShadow[] = {0,0,0,0.5};
		colorText[] = {1,1,1,1};
		font = "PuristaMedium";
		h = 0.4;
		w = 0.4;
		maxHistoryDelay = 1;
		period = 1.2;
		rowHeight = 0;
		shadow = 0;
		//sizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
		sizeEx = 0.026;
		soundSelect[] = {"\A3\ui_f\data\sound\RscListbox\soundSelect",0.09,1};
		tooltipColorBox[] = {1,1,1,1};
		tooltipColorShade[] = {0,0,0,0.65};
		tooltipColorText[] = {1,1,1,1};
		class ListScrollBar
		{
			arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
			arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
			autoScrollDelay = 5;
			autoScrollEnabled = 1;
			autoScrollRewind = 0;
			autoScrollSpeed = -1;
			border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
			color[] = {1,1,1,0.6};
			colorActive[] = {1,1,1,1};
			colorDisabled[] = {1,1,1,0.3};
			height = 0;
			scrollSpeed = 0.06;
			thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
			shadow = 0;
		};
	};

	class LxOPSStructuredText {
		idc = 1201;
		type = 13;
		style = 0x00;
		colorText[]={0,0,0,1};
		colorBackground[] = {0, 0, 0, 0};
		x = 0.375;
		y = 0.24;
		w = 0.25;
		h = 0.06;
		size = 0.026;
		sizeEx = 0.026;
		text = "";
		lineSpacing = 4;
		class Attributes { 
			font = "PuristaMedium"; 
			color = "#FFFFFF"; 
			align = "center"; 
			valign = "middle"; 
			shadow = false; 
			shadowColor = "#ff0000"; 
			size = "1.5"; 
		}; 
	};
	
	class LxOPSCheckBox {
		idc = -1;
		type = 7;
		style = 0x00;
		checked_strings[] = {"Unlock"};
		strings[] = {"Lock"};
		color[] = {0,0,0,0};
		colorBackground[] = {0,0,1,1};
		colorDisable[] = {0.4,0.4,0.4,1};
		colorSelect[] = {0,0,0,1};
		colorSelectedBg[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.69])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.75])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.5])",1};
		colorText[] = {1,1,1,1};
		colorTextDisable[] = {0.7,0.2,0.2,1};
		colorTextSelect[] = {0.2,0.7,0.2,1};
		columns = 1;
		rows = 1;
		font = "PuristaMedium";
		sizeEx = 0.026;
		text = "";
	};
	
	class LxOPSNorth : LxOPSButton {
		x = 0.3425 * safezoneW + safezoneX;
		y = 0.094 * safezoneH + safezoneY;
		w = 0.0459375 * safezoneW;
		h = 0.042 * safezoneH;
		text = "North";
		action = "[0] call Lx_fnc_translateObject;";
	};
	
	class LxOPSSouth : LxOPSButton {
		x = 0.3425 * safezoneW + safezoneX;
		y = 0.15 * safezoneH + safezoneY;
		w = 0.0459375 * safezoneW;
		h = 0.042 * safezoneH;
		text = "South";
		action = "[1] call Lx_fnc_translateObject;";
	};
	
	class LxOPSEast : LxOPSButton {
		x = 0.395 * safezoneW + safezoneX;
		y = 0.094 * safezoneH + safezoneY;
		w = 0.0459375 * safezoneW;
		h = 0.042 * safezoneH;
		text = "East";
		action = "[2] call Lx_fnc_translateObject;";
	};
	
	class LxOPSWest : LxOPSButton {
		x = 0.395 * safezoneW + safezoneX;
		y = 0.15 * safezoneH + safezoneY;
		w = 0.0459375 * safezoneW;
		h = 0.042 * safezoneH;
		text = "West";
		action = "[3] call Lx_fnc_translateObject;";
	};

	class LxOPSUp : LxOPSButton {
		x = 0.4475 * safezoneW + safezoneX;
		y = 0.094 * safezoneH + safezoneY;
		w = 0.0459375 * safezoneW;
		h = 0.042 * safezoneH;
		text = "Up";
		action = "[4] call Lx_fnc_translateObject;";
	};
	
	class LxOPSDown : LxOPSButton {
		x = 0.4475 * safezoneW + safezoneX;
		y = 0.15 * safezoneH + safezoneY;
		w = 0.0459375 * safezoneW;
		h = 0.042 * safezoneH;
		text = "Down";
		action = "[5] call Lx_fnc_translateObject;";
	};
	
	class LxOPSLeft : LxOPSButton {
		x = 0.519688 * safezoneW + safezoneX;
		y = 0.15 * safezoneH + safezoneY;
		w = 0.0459375 * safezoneW;
		h = 0.042 * safezoneH;
		text = "Left";
		action = "[0] call Lx_fnc_rotateObject;";
	};
	
	class LxOPSRight : LxOPSButton {
		x = 0.519688 * safezoneW + safezoneX;
		y = 0.094 * safezoneH + safezoneY;
		w = 0.0459375 * safezoneW;
		h = 0.042 * safezoneH;
		text = "Right";
		action = "[1] call Lx_fnc_rotateObject;";
	};
	
	class LxOPSPitchL : LxOPSButton {
		x = 0.572188 * safezoneW + safezoneX;
		y = 0.15 * safezoneH + safezoneY;
		w = 0.0459375 * safezoneW;
		h = 0.042 * safezoneH;
		text = "Pitch L";
		action = "[2] call Lx_fnc_rotateObject;";
	};
	
	class LxOPSPitchR : LxOPSButton {
		x = 0.572188 * safezoneW + safezoneX;
		y = 0.094 * safezoneH + safezoneY;
		w = 0.0459375 * safezoneW;
		h = 0.042 * safezoneH;
		text = "Pitch R";
		action = "[3] call Lx_fnc_rotateObject;";
	};
	
	class LxOPSBankL : LxOPSButton {
		x = 0.624688 * safezoneW + safezoneX;
		y = 0.15 * safezoneH + safezoneY;
		w = 0.0459375 * safezoneW;
		h = 0.042 * safezoneH;
		text = "Bank L";
		action = "[4] call Lx_fnc_rotateObject;";
	};
	
	class LxOPSBankR : LxOPSButton {
		x = 0.624688 * safezoneW + safezoneX;
		y = 0.094 * safezoneH + safezoneY;
		w = 0.0459375 * safezoneW;
		h = 0.042 * safezoneH;
		text = "Bank R";
		action = "[5] call Lx_fnc_rotateObject;";
	};
	
	class LxOPSText : LxOPSStructuredText {
		idc = 24351;
		x = 0.3425 * safezoneW + safezoneX;
		y = 0.038 * safezoneH + safezoneY;
		w = 0.328125 * safezoneW;
		h = 0.042 * safezoneH;
	};
	
	class LxOPSComboTranslate : LxOPSCombo
	{
		idc = 24352;
		rowHeight = 0.03;
		wholeHeight = 6.5 * 0.03;
		x = 0.395 * safezoneW + safezoneX;
		y = 0.206 * safezoneH + safezoneY;
		w = 0.0459375 * safezoneW;
		h = 0.028 * safezoneH;
		onLBSelChanged = "";
	};
	
	class LxOPSComboRotate : LxOPSCombo
	{
		idc = 24353;
		rowHeight = 0.03;
		wholeHeight = 6.5 * 0.03;
		x = 0.572188 * safezoneW + safezoneX;
		y = 0.206 * safezoneH + safezoneY;
		w = 0.0459375 * safezoneW;
		h = 0.028 * safezoneH;
		onLBSelChanged = "";
	};
	
	class LxOPSComboFilter : LxOPSCombo
	{
		idc = 24354;
		rowHeight = 0.03;
		wholeHeight = 6.5 * 0.03;
		x = 0.795313 * safezoneW + safezoneX;
		y = 0.052 * safezoneH + safezoneY;
		w = 0.091875 * safezoneW;
		h = 0.028 * safezoneH;
		onLBSelChanged = "[] call lxFilterObject;";
	};



		y = 0.22 * safezoneH + safezoneY;
		w = 0.091875 * safezoneW;
		h = 0.042 * safezoneH;
	
	class LxOPSComboPosSys : LxOPSCombo
	{
		idc = 24359;
		rowHeight = 0.03;
		wholeHeight = 6.5 * 0.03;
		x = 0.696875 * safezoneW + safezoneX;
		y = 0.28 * safezoneH + safezoneY;
		
		
		w = 0.091875 * safezoneW;
		h = 0.028 * safezoneH;
		onLBSelChanged = "[] call lxChangeSysPos;";
	};

	
	
	class LxOPSComboReset : LxOPSCombo
	{
		idc = 24360;
		rowHeight = 0.03;
		wholeHeight = 6.5 * 0.03;
		x = 0.696875 * safezoneW  + safezoneX;
		y = 0.052 * safezoneH + safezoneY;
		w = 0.091875 * safezoneW;
		h = 0.028 * safezoneH;
	};

	class LxOPSReset : LxOPSButton {
		x = 0.696875 * safezoneW + safezoneX;
		y = 0.094 * safezoneH + safezoneY;
		w = 0.091875 * safezoneW;
		h = 0.042 * safezoneH;
		text = "Reset";
		action = "[] call Lx_fnc_ResetObject;";
	};
	
	class LxOPSCheckBoxLock : LxOPSCheckBox {
		idc = 24355;
		x = 0.460625 * safezoneW + safezoneX;
		y = 0.22 * safezoneH + safezoneY;
		w = 0.091875 * safezoneW;
		h = 0.042 * safezoneH;
		checked_strings[] = {"Unlock Object"};
		strings[] = {"Lock Object"};
		onCheckBoxesSelChanged = "[] call Lx_fnc_lockObject;";
	};

	class LxOPSNew : LxOPSButton {
		x = 0.696875 * safezoneW + safezoneX;
		y = 0.22 * safezoneH + safezoneY;
		w = 0.091875 * safezoneW;
		h = 0.042 * safezoneH;
		text = "New object";
		action = "[] call Lx_fnc_newObject;";
	};
	
	class LxOPSSupr : LxOPSButton {
		x = 0.696875 * safezoneW + safezoneX;
		y = 0.15 * safezoneH + safezoneY;
		w = 0.091875 * safezoneW;
		h = 0.042 * safezoneH;
		text = "Delete object";
		action = "[] call Lx_fnc_supprObject;";
	};
	
	class LxOPSComboCopy : LxOPSCombo
	{
		idc = 24361;
		rowHeight = 0.03;
		wholeHeight = 6.5 * 0.03;
		x = 0.224375 * safezoneW + safezoneX;
		y = 0.052 * safezoneH + safezoneY;
		w = 0.091875 * safezoneW;
		h = 0.028 * safezoneH;
		onLBSelChanged = "";
	};
	
	class LxOPSComboEnableSim : LxOPSCombo
	{
		idc = 24362;
		rowHeight = 0.03;
		wholeHeight = 6.5 * 0.03;
		x = 0.224375 * safezoneW + safezoneX;
		y = 0.092 * safezoneH + safezoneY;
		w = 0.091875 * safezoneW;
		h = 0.028 * safezoneH;
		onLBSelChanged = "[] call lx_setObjSim;";
	};
	
	class LxOPSCopy : LxOPSButton {
		x = 0.224375 * safezoneW + safezoneX;
		y = 0.14 * safezoneH + safezoneY;
		w = 0.091875 * safezoneW;
		h = 0.042 * safezoneH;
		text = "Copy object";
		action = "[0] call Lx_fnc_copyObject;";
	};
	
	class LxOPSLog : LxOPSButton {
		x = 0.224375 * safezoneW + safezoneX;
		y = 0.19 * safezoneH + safezoneY;
		w = 0.091875 * safezoneW;
		h = 0.042 * safezoneH;
		text = "Log object";
		action = "[1] call Lx_fnc_copyObject;";
	};
	
	class LxOPSObjectList : LxOPSList
	{
		idc = 24357;
		x = 0.795313 * safezoneW + safezoneX;
		y = 0.135 * safezoneH + safezoneY;
		w = 0.196875 * safezoneW;
		h = 0.71 * safezoneH;
		onLBSelChanged = "[] call Lx_fnc_changeObject;";
	};

	class LxOPSTextInfo : LxOPSStructuredText {
		idc = 24358;
		x = 0.00781247 * safezoneW + safezoneX;
		y = 0.472 * safezoneH + safezoneY;
		w = 0.5 * safezoneW;
		h = 0.336 * safezoneH;
	};


};