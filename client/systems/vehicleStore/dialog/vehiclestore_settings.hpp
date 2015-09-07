// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
#include "vehiclestoreDefines.hpp"

#define VehStoreButton_textSize (0.04 * TEXT_SCALE)

class vehshopd
{
	idd = vehshop_DIALOG;
	movingEnable = true;
	enableSimulation = true;
	onLoad = "[[0], populateVehicleStore] execFSM 'call.fsm'";

	class ControlsBackground
	{
		#define VehStoreMainBG_W (0.7333 * SZ_SCALE)
		#define VehStoreMainBG_H (0.65 * SZ_SCALE)
		#define VehStoreMainBG_X CENTER(1, VehStoreMainBG_W)
		#define VehStoreMainBG_Y CENTER(1, VehStoreMainBG_H)

		class MainBackground: IGUIBack
		{
			idc = -1;
			colorBackground[] = {0, 0, 0, 0.6};
			moving = true;

			x = VehStoreMainBG_X;
			y = VehStoreMainBG_Y;
			w = VehStoreMainBG_W;
			h = VehStoreMainBG_H;
		};

		class TopBar: IGUIBack
		{
			idc = -1;
			colorBackground[] = {A3W_UICOLOR_R, A3W_UICOLOR_G, A3W_UICOLOR_B, 0.8};

			#define VehStoreTopBar_H (0.05 * SZ_SCALE)

			x = VehStoreMainBG_X;
			y = VehStoreMainBG_Y;
			w = VehStoreMainBG_W;
			h = VehStoreTopBar_H;
		};

		class ItemSelectedPrice: w_RscStructuredTextLeft
		{
			idc = vehshop_veh_TEXT;
			size = 0.04 * TEXT_SCALE;

			x = VehStoreMainBG_X + (0.15 * SZ_SCALE);
			y = VehStoreMainBG_Y + (0.514 * SZ_SCALE);
			w = 0.119 * SZ_SCALE;
			h = 0.0689 * SZ_SCALE;
		};

		class DialogTitleText: w_RscTextCenter
		{
			idc = -1;
			text = "Vehicle Store";
			sizeEx = 0.06 * TEXT_SCALE;

			x = VehStoreMainBG_X;
			y = VehStoreMainBG_Y;
			w = VehStoreMainBG_W;
			h = VehStoreTopBar_H;
		};

		/*
		class PlayerMoneyText: w_RscText
		{
			idc = vehshop_money;
			text = "Cash:";
			sizeEx = 0.04 * TEXT_SCALE;

			x = VehStoreMainBG_X + (0.6033 * SZ_SCALE);
			y = VehStoreMainBG_Y + (0.005 * SZ_SCALE);
			w = 0.1126 * SZ_SCALE;
			h = 0.0448 * SZ_SCALE;
		};
		*/
	};

	class Controls
	{
		class SelectionList: w_RscList
		{
			idc = vehshop_veh_list;
			onLBSelChanged = "call vehicleInfo";
			sizeEx = 0.04 * TEXT_SCALE;
			rowHeight = 0.05 * TEXT_SCALE;

			x = VehStoreMainBG_X + (0.1533 * SZ_SCALE);
			y = VehStoreMainBG_Y + (0.075 * SZ_SCALE);
			w = 0.276 * SZ_SCALE;
			h = 0.4222 * SZ_SCALE;
		};

		class ColorList: w_RscList
		{
			idc = vehshop_color_list;
			onLBSelChanged = "[] execVM 'client\systems\vehicleStore\colorInfo.sqf'";
			sizeEx = 0.04 * TEXT_SCALE;
			rowHeight = 0.06 * TEXT_SCALE;

			x = VehStoreMainBG_X + (0.4433 * SZ_SCALE);
			y = VehStoreMainBG_Y + (0.075 * SZ_SCALE);
			w = 0.276 * SZ_SCALE;
			h = 0.4222 * SZ_SCALE;
		};

		class BuyVehicle: w_RscButton
		{
			idc = -1;
			action = "[0] execVM 'client\systems\vehicleStore\buyVehicles.sqf'";
			text = "Buy";
			sizeEx = VehStoreButton_textSize;

			x = VehStoreMainBG_X + (0.334 * SZ_SCALE);
			y = VehStoreMainBG_Y + (0.507 * SZ_SCALE);
			w = 0.096 * SZ_SCALE;
			h = 0.040 * SZ_SCALE;
		};

		class CancelButton: w_RscButton
		{
			idc = -1;
			action = "closeDialog 0";
			text = "Cancel";
			sizeEx = VehStoreButton_textSize;

			x = VehStoreMainBG_X + (0.0167 * SZ_SCALE);
			y = VehStoreMainBG_Y + (0.59 * SZ_SCALE);
			w = 0.096 * SZ_SCALE;
			h = 0.040 * SZ_SCALE;
		};

		class StoreButton0: w_RscButton
		{
			idc = vehshop_button0;
			action = "[0] call populateVehicleStore";
			text = "Land";
			sizeEx = VehStoreButton_textSize;

			x = VehStoreMainBG_X + (0.0167 * SZ_SCALE);
			y = VehStoreMainBG_Y + (0.075 * SZ_SCALE);
			w = 0.1173 * SZ_SCALE;
			h = 0.040 * SZ_SCALE;
		};

		class StoreButton1: w_RscButton
		{
			idc = vehshop_button1;
			action = "[1] call populateVehicleStore";
			text = "Armored";
			sizeEx = VehStoreButton_textSize;

			x = VehStoreMainBG_X + (0.0167 * SZ_SCALE);
			y = VehStoreMainBG_Y + (0.125 * SZ_SCALE);
			w = 0.1173 * SZ_SCALE;
			h = 0.040 * SZ_SCALE;
		};

		class StoreButton2: w_RscButton
		{
			idc = vehshop_button2;
			action = "[2] call populateVehicleStore";
			text = "Tanks";
			sizeEx = VehStoreButton_textSize;

			x = VehStoreMainBG_X + (0.0167 * SZ_SCALE);
			y = VehStoreMainBG_Y + (0.175 * SZ_SCALE);
			w = 0.1173 * SZ_SCALE;
			h = 0.040 * SZ_SCALE;
		};

		class StoreButton3: w_RscButton
		{
			idc = vehshop_button3;
			action = "[3] call populateVehicleStore";
			text = "Helicopters";
			sizeEx = VehStoreButton_textSize;

			x = VehStoreMainBG_X + (0.0167 * SZ_SCALE);
			y = VehStoreMainBG_Y + (0.225 * SZ_SCALE);
			w = 0.1173 * SZ_SCALE;
			h = 0.040 * SZ_SCALE;
		};

		class StoreButton4: w_RscButton
		{
			idc = vehshop_button4;
			action = "[4] call populateVehicleStore";
			text = "Planes";
			sizeEx = VehStoreButton_textSize;

			x = VehStoreMainBG_X + (0.0167 * SZ_SCALE);
			y = VehStoreMainBG_Y + (0.275 * SZ_SCALE);
			w = 0.1173 * SZ_SCALE;
			h = 0.040 * SZ_SCALE;
		};

		class StoreButton5: w_RscButton
		{
			idc = vehshop_button5;
			action = "[5] call populateVehicleStore";
			text = "Boats";
			sizeEx = VehStoreButton_textSize;

			x = VehStoreMainBG_X + (0.0167 * SZ_SCALE);
			y = VehStoreMainBG_Y + (0.325 * SZ_SCALE);
			w = 0.1173 * SZ_SCALE;
			h = 0.040 * SZ_SCALE;
		};

		// Submarines transferred in Boats
		/*
		class StoreButton6: w_RscButton
		{
			idc = vehshop_button6;
			action = "[6] call populateVehicleStore";
			text = "Submarines";
			sizeEx = VehStoreButton_textSize;

			x = VehStoreMainBG_X + (0.0167 * SZ_SCALE);
			y = VehStoreMainBG_Y + (0.375 * SZ_SCALE);
			w = 0.1173 * SZ_SCALE;
			h = 0.040 * SZ_SCALE;
		};
		*/
	};
};

