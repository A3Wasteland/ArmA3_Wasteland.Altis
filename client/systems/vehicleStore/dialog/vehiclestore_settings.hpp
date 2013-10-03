#include "vehiclestoreDefines.hpp"

class vehshopd {

	idd = vehshop_DIALOG;
	movingEnable = true;
	enableSimulation = true;
	onLoad = "[0] execVM 'client\systems\vehicleStore\populateVehicleStore.sqf'";

	class controlsBackground {
		
		class MainBackground: w_RscPicture
		{
			idc = -1;
			colorText[] = {1, 1, 1, 1};
			colorBackground[] = {0,0,0,0};
			text = "#(argb,8,8,3)color(0,0,0,0.6)";

			x = 0.1875 * safezoneW + safezoneX;
			y = 0.15 * safezoneH + safezoneY;
			w = 0.55 * safezoneW;
			h = 0.65 * safezoneH;
		};

		class TopBar: w_RscPicture
		{
			idc = -1;
			colorText[] = {1, 1, 1, 1};
			colorBackground[] = {0,0,0,0};
			text = "#(argb,8,8,3)color(0.25,0.51,0.96,0.8)";

			x = 0.1875 * safezoneW + safezoneX;
			y = 0.15 * safezoneH + safezoneY;
			w = 0.55 * safezoneW;
			h = 0.05 * safezoneH;
		};

		class ItemSelectedPrice: w_RscStructuredTextLeft
		{
			idc = vehshop_veh_TEXT;
			text = "";

			x = 0.299 * safezoneW + safezoneX;
			y = 0.664 * safezoneH + safezoneY;
			w = 0.0891667 * safezoneW;
			h = 0.068889 * safezoneH;
		};

		class DialogTitleText: w_RscText
		{
			idc = -1;
			text = "Vehicle Store Menu";

			sizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			x = 0.20 * safezoneW + safezoneX;
			y = 0.155 * safezoneH + safezoneY;
			w = 0.19 * safezoneW;
			h = 0.0448148 * safezoneH;
		};

		class PlayerMoneyText: w_RscText
		{
			idc = vehshop_money;
			text = "Cash:";
			font = "PuristaMedium";
			sizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			x = 0.640 * safezoneW + safezoneX;
			y = 0.155 * safezoneH + safezoneY;
			w = 0.0844792 * safezoneW;
			h = 0.0448148 * safezoneH;
		};
	};
	
	class controls {
		
		class SelectionList: w_RscList
		{
			idc = vehshop_veh_list;
			onLBSelChanged = "[] execvm 'client\systems\vehicleStore\vehicleInfo.sqf'";
			font = "PuristaMedium";
			sizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			x = 0.3025 * safezoneW + safezoneX;
			y = 0.225 * safezoneH + safezoneY;
			w = 0.207 * safezoneW;
			h = 0.422222 * safezoneH;
		};
		
		class ColorList: w_RscList
		{
			idc = vehshop_color_list;
			onLBSelChanged = "[] execvm 'client\systems\vehicleStore\colorInfo.sqf'";
			font = "PuristaMedium";
			sizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			x = 0.520 * safezoneW + safezoneX;
			y = 0.225 * safezoneH + safezoneY;
			w = 0.207 * safezoneW;
			h = 0.422222 * safezoneH;
		};

		class BuVehicle: w_RscButton
		{
			idc = -1;
			onButtonClick = "[0] execVM 'client\systems\vehicleStore\buyVehicles.sqf'";
			text = "Buy";

			x = 0.438 * safezoneW + safezoneX;
			y = 0.657 * safezoneH + safezoneY;
			w = 0.072 * safezoneW;
			h = 0.040 * safezoneH;
		};

		class CancelButton: w_RscButton
		{
			idc = -1;
			onButtonClick = "closeDialog 0;";
			text = "Cancel";

			x = 0.20 * safezoneW + safezoneX;
			y = 0.740 * safezoneH + safezoneY;
			w = 0.088 * safezoneW;
			h = 0.040 * safezoneH;
		};

		class StoreButton0: w_RscButton
		{
			idc = vehshop_button0;
			onButtonClick = "[0] execVM 'client\systems\vehicleStore\populateVehicleStore.sqf'";
			text = "Land";

			x = 0.20 * safezoneW + safezoneX;
			y = 0.225 * safezoneH + safezoneY;
			w = 0.088 * safezoneW;
			h = 0.040 * safezoneH;	
		};

		class StoreButton1: w_RscButton
		{
			idc = vehshop_button1;
			onButtonClick = "[1] execVM 'client\systems\vehicleStore\populateVehicleStore.sqf'";
			text = "Armored";

			x = 0.20 * safezoneW + safezoneX;
			y = 0.275 * safezoneH + safezoneY;
			w = 0.088 * safezoneW;
			h = 0.040 * safezoneH;
		};
		
		class StoreButton2: w_RscButton
		{
			idc = vehshop_button2;
			onButtonClick = "[2] execVM 'client\systems\vehicleStore\populateVehicleStore.sqf'";
			text = "Tanks";

			x = 0.20 * safezoneW + safezoneX;
			y = 0.325 * safezoneH + safezoneY;
			w = 0.088 * safezoneW;
			h = 0.040 * safezoneH;
		};
		
		class StoreButton3: w_RscButton
		{
			idc = vehshop_button3;
			onButtonClick = "[3] execVM 'client\systems\vehicleStore\populateVehicleStore.sqf'";
			text = "Helicopters";

			x = 0.20 * safezoneW + safezoneX;
			y = 0.375 * safezoneH + safezoneY;
			w = 0.088 * safezoneW;
			h = 0.040 * safezoneH;
		};
		
		class StoreButton4: w_RscButton
		{
			idc = vehshop_button4;
			onButtonClick = "[4] execVM 'client\systems\vehicleStore\populateVehicleStore.sqf'";
			text = "Jets";

			x = 0.20 * safezoneW + safezoneX;
			y = 0.425 * safezoneH + safezoneY;
			w = 0.088 * safezoneW;
			h = 0.040 * safezoneH;
		};
		
		class StoreButton5: w_RscButton
		{
			idc = vehshop_button5;
			onButtonClick = "[5] execVM 'client\systems\vehicleStore\populateVehicleStore.sqf'";
			text = "Boats";

			x = 0.20 * safezoneW + safezoneX;
			y = 0.475 * safezoneH + safezoneY;
			w = 0.088 * safezoneW;
			h = 0.040 * safezoneH;
		};

		class StoreButton6: w_RscButton
		{
			idc = vehshop_button6;
			onButtonClick = "[6] execVM 'client\systems\vehicleStore\populateVehicleStore.sqf'";
			text = "Submarines";

			x = 0.20 * safezoneW + safezoneX;
			y = 0.525 * safezoneH + safezoneY;
			w = 0.088 * safezoneW;
			h = 0.040 * safezoneH;
		};
	};
};

