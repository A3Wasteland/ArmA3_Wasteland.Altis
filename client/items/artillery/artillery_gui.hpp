// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2018 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: artillery_gui.hpp

#include "artillery_defines.hpp"

class A3W_artilleryMenu
{
	idd = A3W_artilleryMenu_IDD;
	movingEnable = true;
	enableSimulation = true;
	onLoad = "call compile preprocessFileLineNumbers 'client\items\artillery\artilleryMenuLoad.sqf'";
	onUnload = "call compile preprocessFileLineNumbers 'client\items\artillery\artilleryMenuUnload.sqf'";

	#define ArtiMenu_MARGIN 0.02
	#define ArtiMenu_MARGIN_X (ArtiMenu_MARGIN * X_SCALE)
	#define ArtiMenu_MARGIN_Y (ArtiMenu_MARGIN * Y_SCALE)

	class ControlsBackground
	{
		class ArtiMenu_BG : IGUIBack
		{
			idc = -1;
			colorBackground[] = {0, 0, 0, 0.6};
			moving = true;

			#define ArtiMenu_BG_W (1.0 * X_SCALE)
			#define ArtiMenu_BG_H (0.8 * Y_SCALE)
			#define ArtiMenu_BG_X CENTER(1,ArtiMenu_BG_W)
			#define ArtiMenu_BG_Y CENTER(1,ArtiMenu_BG_H)

			w = ArtiMenu_BG_W;
			h = ArtiMenu_BG_H;
			x = ArtiMenu_BG_X;
			y = ArtiMenu_BG_Y;
		};

		class ArtiMenu_TopBar : IGUIBack
		{
			idc = -1;
			colorBackground[] = {A3W_UICOLOR_R, A3W_UICOLOR_G, A3W_UICOLOR_B, 0.8};

			#define ArtiMenu_TopBar_H (0.05 * Y_SCALE)

			w = ArtiMenu_BG_W;
			h = ArtiMenu_TopBar_H;
			x = ArtiMenu_BG_X;
			y = ArtiMenu_BG_Y;
		};

		class ArtiMenu_TopText : w_RscTextCenter
		{
			idc = -1;
			text = "Artillery Strike";
			sizeEx = 0.06 * TEXT_SCALE;

			w = ArtiMenu_BG_W;
			h = ArtiMenu_TopBar_H;
			x = ArtiMenu_BG_X;
			y = ArtiMenu_BG_Y;
		};
	};

	#define ArtiMenu_Main_W (ArtiMenu_BG_W - (ArtiMenu_MARGIN_X * 2))
	#define ArtiMenu_Main_H (0.5 * Y_SCALE)
	#define ArtiMenu_Main_X (ArtiMenu_BG_X + CENTER(ArtiMenu_BG_W,ArtiMenu_Main_W))
	#define ArtiMenu_Main_Y (ArtiMenu_BG_Y + ArtiMenu_TopBar_H + ArtiMenu_MARGIN_Y)

	#define ArtiMenu_Label_H (0.02 * Y_SCALE)
	#define ArtiMenu_Label_TEXTSIZE (0.04 * TEXT_SCALE)

	class Controls
	{
		/*class ArtiMenu_MapLabel : w_RscText
		{
			idc = -1;
			text = "Select target";
			sizeEx = ArtiMenu_Label_TEXTSIZE;

			#define ArtiMenu_MapLabel_W ArtiMenu_Main_W
			#define ArtiMenu_MapLabel_H ArtiMenu_Label_H
			#define ArtiMenu_MapLabel_X ArtiMenu_Main_X
			#define ArtiMenu_MapLabel_Y ArtiMenu_Main_Y

			w = ArtiMenu_MapLabel_W;
			h = ArtiMenu_MapLabel_H;
			x = ArtiMenu_MapLabel_X;
			y = ArtiMenu_MapLabel_Y;
		};*/

		#define ArtiMenu_Button_W (0.09 * X_SCALE)
		#define ArtiMenu_Button_H (0.033 * Y_SCALE)
		#define ArtiMenu_BottomButton_X ArtiMenu_Main_X
		#define ArtiMenu_BottomButton_Y (ArtiMenu_BG_Y + ArtiMenu_BG_H - ArtiMenu_MARGIN_Y - ArtiMenu_Button_H)

		class ArtiMenu_Map : w_RscMapControl
		{
			idc = A3W_artilleryMenu_Map_IDC;
			//scaleMax = 1.0;

			#define ArtiMenu_Map_W ArtiMenu_Main_W
			#define ArtiMenu_Map_H (ArtiMenu_BottomButton_Y - ArtiMenu_Main_Y - ArtiMenu_MARGIN_Y)
			#define ArtiMenu_Map_X ArtiMenu_Main_X
			#define ArtiMenu_Map_Y ArtiMenu_Main_Y

			w = ArtiMenu_Map_W;
			h = ArtiMenu_Map_H;
			x = ArtiMenu_Map_X;
			y = ArtiMenu_Map_Y;
		};

		class ArtiMenu_CloseButton : w_RscButton
		{
			idc = 2;
			text = "Cancel";
			//action = "closeDialog 0"; // not needed if idc = 2

			#define ArtiMenu_CloseButton_X ArtiMenu_BottomButton_X

			w = ArtiMenu_Button_W;
			h = ArtiMenu_Button_H;
			x = ArtiMenu_CloseButton_X;
			y = ArtiMenu_BottomButton_Y;
		};

		class ArtiMenu_ConfirmButton : w_RscButton
		{
			idc = A3W_artilleryMenu_ConfirmButton_IDC;
			text = "Confirm";
			action = "call compile preprocessFileLineNumbers 'client\items\artillery\artilleryConfirm.sqf'";

			// red
			colorBackground[] = {0.5, 0, 0, 1}; // normal
			colorFocused[] = {0.3, 0, 0, 1}; // pulse
			colorBackgroundActive[] = {0.8, 0, 0, 1}; // hover

			#define ArtiMenu_ConfirmButton_X (ArtiMenu_BottomButton_X + ArtiMenu_Main_W - ArtiMenu_Button_W)

			w = ArtiMenu_Button_W;
			h = ArtiMenu_Button_H;
			x = ArtiMenu_ConfirmButton_X;
			y = ArtiMenu_BottomButton_Y;
		};

		class ArtiMenu_MapLabel : w_RscStructuredText
		{
			idc = A3W_artilleryMenu_MapLabel_IDC;
			text = "Select target"; 
			size = ArtiMenu_Label_TEXTSIZE;

			#define ArtiMenu_MapLabel_W (ArtiMenu_ConfirmButton_X - (ArtiMenu_CloseButton_X + ArtiMenu_Button_W))
			#define ArtiMenu_MapLabel_H ArtiMenu_Button_H
			#define ArtiMenu_MapLabel_X (ArtiMenu_CloseButton_X + ArtiMenu_Button_W)
			#define ArtiMenu_MapLabel_Y ArtiMenu_BottomButton_Y

			w = ArtiMenu_MapLabel_W;
			h = ArtiMenu_MapLabel_H;
			x = ArtiMenu_MapLabel_X;
			y = ArtiMenu_MapLabel_Y;
		};
	};
};

