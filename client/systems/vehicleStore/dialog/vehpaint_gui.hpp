// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2019 A3Wasteland.com *
// ******************************************************************************************
#include "vehiclestoreDefines.hpp"

#define VehPaint_Button_textSize (0.04 * TEXT_SCALE)

class A3W_vehPaintMenu
{
	idd = A3W_vehPaintIDD;
	movingEnable = true;
	enableSimulation = true;
	onLoad = "uiNamespace setVariable ['A3W_vehPaintMenu', _this select 0]; [] call repaintVehicle";
	onUnload = "uiNamespace setVariable ['A3W_vehPaintMenu', nil]";

	#define VehPaint_MARGIN 0.02
	#define VehPaint_MARGIN_X (FeedMenu_MARGIN * X_SCALE)
	#define VehPaint_MARGIN_Y (FeedMenu_MARGIN * Y_SCALE)

	class ControlsBackground
	{
		#define VehPaint_MainBG_W (0.475 * SZ_SCALE)
		#define VehPaint_MainBG_H (0.65 * SZ_SCALE)
		#define VehPaint_MainBG_X CENTER(1, VehPaint_MainBG_W)
		#define VehPaint_MainBG_Y CENTER(1, VehPaint_MainBG_H)

		class MainBackground: IGUIBack
		{
			idc = -1;
			colorBackground[] = {0, 0, 0, 0.6};
			moving = true;

			x = VehPaint_MainBG_X;
			y = VehPaint_MainBG_Y;
			w = VehPaint_MainBG_W;
			h = VehPaint_MainBG_H;
		};

		class TopBar: IGUIBack
		{
			idc = -1;
			colorBackground[] = {A3W_UICOLOR_R, A3W_UICOLOR_G, A3W_UICOLOR_B, 0.8};

			#define VehPaint_TopBar_H (0.05 * SZ_SCALE)

			x = VehPaint_MainBG_X;
			y = VehPaint_MainBG_Y;
			w = VehPaint_MainBG_W;
			h = VehPaint_TopBar_H;
		};

		class DialogTitleText: w_RscTextCenter
		{
			idc = -1;
			text = "Pay 'n' Spray";
			sizeEx = 0.06 * TEXT_SCALE;

			x = VehPaint_MainBG_X;
			y = VehPaint_MainBG_Y;
			w = VehPaint_MainBG_W;
			h = VehPaint_TopBar_H;
		};


		class ItemSelectedPrice: w_RscStructuredTextLeft
		{
			idc = vehshop_veh_TEXT;
			size = 0.04 * TEXT_SCALE;

			x = VehPaint_MainBG_X + (0.02 * SZ_SCALE);
			y = VehPaint_MainBG_Y + (0.514 * SZ_SCALE);
			w = 0.4 * SZ_SCALE;
			h = 0.0689 * SZ_SCALE;
		};
	};

	class Controls
	{
		class ColorList: w_RscList
		{
			idc = vehshop_color_list;
			//onLBSelChanged = "[] execVM 'client\systems\vehicleStore\colorInfo.sqf'";
			font = "RobotoCondensed";
			sizeEx = 0.034 * TEXT_SCALE;
			rowHeight = 0.06 * TEXT_SCALE;

			#define VehPaint_ColorList_W (0.207 * SZ_SCALE)
			#define VehPaint_ColorList_H (0.4222 * SZ_SCALE)
			#define VehPaint_ColorList_X (VehPaint_MainBG_X + (0.02 * SZ_SCALE))
			#define VehPaint_ColorList_Y (VehPaint_MainBG_Y + (0.075 * SZ_SCALE))

			x = VehPaint_ColorList_X;
			y = VehPaint_ColorList_Y;
			w = VehPaint_ColorList_W;
			h = VehPaint_ColorList_H;
		};

		/*#define VehPaint_DefParts_Tooltip "Some vehicles have optional or randomized parts.\nUnticking ""Default parts"" will disable randomization\nand let you choose parts below.\nAll parts affect vehicle weight."

		class DefaultPartsChk: w_RscCheckBox
		{
			idc = vehshop_defparts_checkbox;
			tooltip = VehPaint_DefParts_Tooltip;

			#define VehPaint_DefPartsChk_W (0.03 * X_SCALE)
			#define VehPaint_DefPartsChk_H (0.03 * Y_SCALE)
			#define VehPaint_DefPartsChk_X (VehPaint_ColorList_X + VehPaint_ColorList_W + (0.02 * SZ_SCALE))
			#define VehPaint_DefPartsChk_Y VehPaint_ColorList_Y

			x = VehPaint_DefPartsChk_X;
			y = VehPaint_DefPartsChk_Y;
			w = VehPaint_DefPartsChk_W;
			h = VehPaint_DefPartsChk_H;
		};

		class DefaultPartsLabel: w_RscText
		{
			idc = -1;
			text = "Default parts";
			sizeEx = 0.04 * TEXT_SCALE;
			tooltip = VehPaint_DefParts_Tooltip;

			#define VehPaint_DefPartsLabel_W (0.12 * X_SCALE)
			#define VehPaint_DefPartsLabel_H (0.03 * Y_SCALE)
			#define VehPaint_DefPartsLabel_X (VehPaint_DefPartsChk_X + VehPaint_DefPartsChk_W) //+ (0.001 * X_SCALE))
			#define VehPaint_DefPartsLabel_Y ((VehPaint_DefPartsChk_Y + CENTER(VehPaint_DefPartsChk_H, VehPaint_DefPartsLabel_H)) - (0.0015 * Y_SCALE))

			x = VehPaint_DefPartsLabel_X;
			y = VehPaint_DefPartsLabel_Y;
			w = VehPaint_DefPartsLabel_W;
			h = VehPaint_DefPartsLabel_H;
		};*/

		class PartList: w_RscList
		{
			idc = vehshop_part_list;
			//onLBSelChanged = ""; // handled in repaintVehicle.sqf
			font = "RobotoCondensed";
			sizeEx = 0.034 * TEXT_SCALE;
			rowHeight = 0.05 * TEXT_SCALE;
			colorSelect[] = {1, 1, 1, 1}; // primary
			colorSelect2[] = {1, 1, 1, 1}; // blink
			colorSelectBackground[] = {0.75, 0.75, 0.75, 0.25}; // primary
			colorSelectBackground2[] = {0.75, 0.75, 0.75, 0.25}; // blink
			colorPictureSelected[] = {1, 1, 1, 1};

			#define VehPaint_PartList_MARGIN_Y (0.005 * Y_SCALE)
			#define VehPaint_PartList_W (0.207 * SZ_SCALE)
			#define VehPaint_PartList_H (0.4222 * SZ_SCALE)
			#define VehPaint_PartList_X (VehPaint_ColorList_X + VehPaint_ColorList_W + (0.02 * SZ_SCALE))
			#define VehPaint_PartList_Y VehPaint_ColorList_Y

			x = VehPaint_PartList_X;
			y = VehPaint_PartList_Y;
			w = VehPaint_PartList_W;
			h = VehPaint_PartList_H;
		};

		class BuyButton: w_RscButton
		{
			idc = vehshop_BuyButton_IDC;
			text = "Buy";
			sizeEx = VehPaint_Button_textSize;

			x = VehPaint_MainBG_X + (0.1227 * SZ_SCALE);
			y = VehPaint_MainBG_Y + (0.59 * SZ_SCALE);
			w = 0.096 * SZ_SCALE;
			h = 0.040 * SZ_SCALE;
		};

		class CancelButton: w_RscButton
		{
			idc = 2;
			action = "closeDialog 0";
			text = "Cancel";
			sizeEx = VehPaint_Button_textSize;

			x = VehPaint_MainBG_X + (0.0167 * SZ_SCALE);
			y = VehPaint_MainBG_Y + (0.59 * SZ_SCALE);
			w = 0.096 * SZ_SCALE;
			h = 0.040 * SZ_SCALE;
		};
	};
};
