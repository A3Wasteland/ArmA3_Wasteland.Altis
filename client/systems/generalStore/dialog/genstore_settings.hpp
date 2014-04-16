#include "genstoreDefines.sqf"

class genstored {

	idd = genstore_DIALOG;
	movingEnable = true;
	enableSimulation = true;
	onLoad = "[0] execVM 'client\systems\generalStore\populateGenStore.sqf'";

	class controlsBackground {
		
		class MainBackground: w_RscPicture
		{
			idc = -1;
			colorText[] = {1, 1, 1, 1};
		    colorBackground[] = {0,0,0,0};
			text = "#(argb,8,8,3)color(0,0,0,0.6)";
			moving = true;
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

		class DialogTitleText: w_RscText
		{
			idc = -1;
			text = "General Store Menu";
			font = "PuristaMedium";
			sizeEx = "((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			x = 0.20 * safezoneW + safezoneX;
			y = 0.155 * safezoneH + safezoneY;
			w = 0.19 * safezoneW;
			h = 0.0448148 * safezoneH;
		};

		class PlayerMoneyText: w_RscText
		{
			idc = genstore_money;
			text = "Cash:";
			font = "PuristaMedium";
			sizeEx = "((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			x = 0.640 * safezoneW + safezoneX;
			y = 0.155 * safezoneH + safezoneY;
			w = 0.0844792 * safezoneW;
			h = 0.0448148 * safezoneH;
		};
		
		class ItemSelectedPrice: w_RscStructuredTextLeft
		{
			idc = genstore_item_TEXT;
			text = "";

			x = 0.299 * safezoneW + safezoneX;
			y = 0.664 * safezoneH + safezoneY;
			w = 0.0891667 * safezoneW;
			h = 0.068889 * safezoneH;
		};
		
		class SellSelectedPrice: w_RscStructuredTextLeft
		{
			idc = genstore_sell_TEXT;
			text = "";

			x = 0.517 * safezoneW + safezoneX;
			y = 0.664 * safezoneH + safezoneY;
			w = 0.0891667 * safezoneW;
			h = 0.068889 * safezoneH;
		};
	};
	
	class controls {
		
		class SelectionList: w_RscList
		{
			idc = genstore_item_list;
			onLBSelChanged = "[] execvm 'client\systems\generalStore\itemInfo.sqf'";
			font = "PuristaMedium";
			sizeEx = "((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			x = 0.3025 * safezoneW + safezoneX;
			y = 0.225 * safezoneH + safezoneY;
			w = 0.207 * safezoneW;
			h = 0.338222 * safezoneH;
		};
		
		class ItemDescription: w_RscStructuredTextLeft
		{
			idc = genstore_item_desc;
			text = "";
			sizeEx = 0.02;
			colorBackground[] = { 0, 0, 0, 0.1 };
			x = 0.3025 * safezoneW + safezoneX;
			y = 0.567 * safezoneH + safezoneY;
			w = 0.207 * safezoneW;
			h = 0.088 * safezoneH;
		};
		
		class SellList: w_RscList
		{
			idc = genstore_sell_list;
			onLBSelChanged = "[] execvm 'client\systems\generalStore\sellInfo.sqf'";
			font = "PuristaMedium";
			sizeEx = "((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			x = 0.520 * safezoneW + safezoneX;
			y = 0.225 * safezoneH + safezoneY;
			w = 0.207 * safezoneW;
			h = 0.422222 * safezoneH;
		};
		
		class SellWeapon: w_RscButton
		{
			idc = -1;
			onButtonClick = "[] execVM 'client\systems\selling\sellWeapon.sqf'";
			text = "Sell Weapon";

			x = 0.360 * safezoneW + safezoneX;
			y = 0.740 * safezoneH + safezoneY;
			w = 0.088 * safezoneW;
			h = 0.040 * safezoneH;
		};
		
		class SellUniform: w_RscButton
		{
			idc = -1;
			onButtonClick = "[] execVM 'client\systems\selling\sellUniform.sqf'";
			text = "Sell Uniform";
			x = 0.453 * safezoneW + safezoneX;
			y = 0.740 * safezoneH + safezoneY;
			w = 0.088 * safezoneW;
			h = 0.040 * safezoneH;
		};

        class SellVest: w_RscButton
		{
			idc = -1;
			onButtonClick = "[] execVM 'client\systems\selling\sellVest.sqf'";
			text = "Sell Vest";

			x = 0.546 * safezoneW + safezoneX;
			y = 0.740 * safezoneH + safezoneY;
			w = 0.088 * safezoneW;
			h = 0.040 * safezoneH;
		};
		
		class SellBackpack: w_RscButton
		{
			idc = -1;
			onButtonClick = "[] execVM 'client\systems\selling\sellBackpack.sqf'";
			text = "Sell Backpack";

			x = 0.639 * safezoneW + safezoneX;
			y = 0.740 * safezoneH + safezoneY;
			w = 0.088 * safezoneW;
			h = 0.040 * safezoneH;
		};

		class CancelButton : w_RscButton {
			
			idc = -1;
			text = "Cancel";
			onButtonClick = "closeDialog 0;";

			x = 0.20 * safezoneW + safezoneX;
			y = 0.740 * safezoneH + safezoneY;
			w = 0.088 * safezoneW;
			h = 0.040 * safezoneH;
		};
		
		class SellItem: w_RscButton
		{
			idc = genstore_sell;
			onButtonClick = "[0] execVM 'client\systems\generalStore\sellItems.sqf'";
			text = "Sell";

			x = 0.655 * safezoneW + safezoneX;
			y = 0.657 * safezoneH + safezoneY;
			w = 0.072 * safezoneW;
			h = 0.040 * safezoneH;
		};
		
		class BuyItem: w_RscButton
		{
			idc = -1;
			onButtonClick = "[0] execVM 'client\systems\generalStore\buyItems.sqf'";
			text = "Buy";

			x = 0.438 * safezoneW + safezoneX;
			y = 0.657 * safezoneH + safezoneY;
			w = 0.072 * safezoneW;
			h = 0.040 * safezoneH;
		};
		
		class StoreButton0: w_RscButton
		{
			idc = -1;
			onButtonClick = "[0] execVM 'client\systems\generalStore\populateGenStore.sqf'";
			text = "Headgear";

			x = 0.20 * safezoneW + safezoneX;
			y = 0.225 * safezoneH + safezoneY;
			w = 0.088 * safezoneW;
			h = 0.040 * safezoneH;
	
		};

		class StoreButton1: w_RscButton
		{
			idc = -1;
			onButtonClick = "[1] execVM 'client\systems\generalStore\populateGenStore.sqf'";
			text = "Uniforms";

			x = 0.20 * safezoneW + safezoneX;
			y = 0.275 * safezoneH + safezoneY;
			w = 0.088 * safezoneW;
			h = 0.040 * safezoneH;

		};
		
		class StoreButton2: w_RscButton
		{
			idc = -1;
			onButtonClick = "[2] execVM 'client\systems\generalStore\populateGenStore.sqf'";
			text = "Vests";

			x = 0.20 * safezoneW + safezoneX;
			y = 0.325 * safezoneH + safezoneY;
			w = 0.088 * safezoneW;
			h = 0.040 * safezoneH;
		};
		
		class StoreButton3: w_RscButton
		{
			idc = -1;
			onButtonClick = "[3] execVM 'client\systems\generalStore\populateGenStore.sqf'";
			text = "Backpacks";

			x = 0.20 * safezoneW + safezoneX;
			y = 0.375 * safezoneH + safezoneY;
			w = 0.088 * safezoneW;
			h = 0.040 * safezoneH;
		};
		
		class StoreButton4: w_RscButton
		{
			idc = -1;
			onButtonClick = "[4] execVM 'client\systems\generalStore\populateGenStore.sqf'";
			text = "Items";

			x = 0.20 * safezoneW + safezoneX;
			y = 0.425 * safezoneH + safezoneY;
			w = 0.088 * safezoneW;
			h = 0.040 * safezoneH;
		};
		
		class StoreButton5: w_RscButton
		{
			idc = -1;
			onButtonClick = "[5] execVM 'client\systems\generalStore\populateGenStore.sqf'";
			text = "Supplies";

			x = 0.20 * safezoneW + safezoneX;
			y = 0.475 * safezoneH + safezoneY;
			w = 0.088 * safezoneW;
			h = 0.040 * safezoneH;
		};

		class StoreButton6: w_RscButton
		{
			idc = -1;
			onButtonClick = "[6] execVM 'client\systems\generalStore\populateGenStore.sqf'";
			text = "Objects";

			x = 0.20 * safezoneW + safezoneX;
			y = 0.525 * safezoneH + safezoneY;
			w = 0.088 * safezoneW;
			h = 0.040 * safezoneH;
		};
	};
};

