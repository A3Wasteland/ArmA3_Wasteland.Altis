#include "genstoreDefines.sqf"

class genstored {

	idd = genstore_DIALOG;
	movingEnable = true;
	enableSimulation = true;
	onLoad = "[] execVM 'client\systems\generalStore\populateGenStore.sqf'";

	class controlsBackground {
		
		class MainBackground: w_RscPicture
		{
			idc = -1;
			text = "client\ui\ui_background_controlers_ca.paa";	
			x = 0.29375 * safezoneW + safezoneX;
			y = 0.15 * safezoneH + safezoneY;
			w = 0.553688 * safezoneW;
			h = 0.661111 * safezoneH;
		};
		
		class ItemSelectedPicture: w_RscPicture
		{
			idc = genstore_item_pic;
			text = "";

			x = 0.5325 * safezoneW + safezoneX;
			y = 0.250 * safezoneH + safezoneY;
			w = 0.030 * safezoneW;
			h = 0.055 * safezoneH;
		};

		class ItemSelectedInfo: w_RscStructuredText
		{
			idc = genstore_item_Info;
			text = "";

			x = 0.448438 * safezoneW + safezoneX;
			y = 0.412 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;
		};

		class ItemSelectedPrice: w_RscStructuredText
		{
			idc = genstore_item_TEXT;
			text = "";

			x = 0.448438 * safezoneW + safezoneX;
			y = 0.456 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;
		};

		class DialogTitleText: w_RscText
		{
			idc = -1;
			text = "Welcome at the General store!";

			x = 0.29375 * safezoneW + safezoneX;
			y = 0.225 * safezoneH + safezoneY;
			w = 0.4125 * safezoneW;
			h = 0.022 * safezoneH;
			tooltip = "You can purchase food, water, repairkits and fueltanks here..";
		};

		class DialogTitleText2: w_RscText
		{
			idc = -1;
			text = "Wasteland for ArmA 3"; //--- ToDo: Localize;
			x = 0.443281 * safezoneW + safezoneX;
			y = 0.72 * safezoneH + safezoneY;
			w = 0.128906 * safezoneW;
			h = 0.055 * safezoneH;
		};

		class PlayerMoneyText: w_RscText
		{
			idc = genstore_money;
			text = "Cash:";

			x = 0.613437 * safezoneW + safezoneX;
			y = 0.742 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.022 * safezoneH;
		};

		class CartTotalText: w_RscText
		{
			idc = genstore_total;
			text = "Total: $0";

			x = 0.592812 * safezoneW + safezoneX;
			y = 0.665 * safezoneH + safezoneY;
			w = 0.103125 * safezoneW;
			h = 0.022 * safezoneH;
		};
		
	};
	
	class controls {
		
		class SelectionList: w_RscListbox
		{
			idc = genstore_item_list;
			onLBSelChanged = "[] execvm 'client\systems\generalStore\itemInfo.sqf'";

			x = 0.304062 * safezoneW + safezoneX;
			y = 0.302 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.411 * safezoneH;
		};

		class CartList: w_RscListbox
		{
			idc = genstore_cart;
			onLBSelChanged = "[] execvm 'client\systems\generalStore\itemInfo.sqf'";

			x = 0.592812 * safezoneW + safezoneX;
			y = 0.302 * safezoneH + safezoneY;
			w = 0.103125 * safezoneW;
			h = 0.352 * safezoneH;
		};

		class StoreButton0: w_RscButton
		{	
			idc = genstore_iteminventory;

			text = "Items";
			onButtonClick = "[] execVM 'client\systems\generalStore\populateSwitch.sqf'";
			
			x = 0.304062 * safezoneW + safezoneX;
			y = 0.258 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.033 * safezoneH;
			tooltip = "Go to the Items-section"; //--- ToDo: Localize;
			sizeEx = 2 * GUI_GRID_H;
		};

		class AddToCart : w_RscButton {
			
			text = "Add";
			onButtonClick = "[] execVM 'client\systems\generalStore\addToCart.sqf'";
			
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.511 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.033 * safezoneH;
			sizeEx = 1 * GUI_GRID_H;
			tooltip = "Add the selected item to your shopping cart"; //--- ToDo: Localize;
		};

		class RemoveFromCart : w_RscButton {

			text = "Remove";
			onButtonClick = "[] execVM 'client\systems\generalStore\removeFromCart.sqf'";

			x = 0.448438 * safezoneW + safezoneX;
			y = 0.555 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.033 * safezoneH;
			sizeEx = 1 * GUI_GRID_H;
			tooltip = "Remove the selected item from your shopping cart"; //--- ToDo: Localize;
		};

		class CancelButton : w_RscButton {
			
			idc = -1;
			onButtonClick = "closeDialog 0;";

			text = "X"; //--- ToDo: Localize;
			x = 0.68381 * safezoneW + safezoneX;
			y = 0.225 * safezoneH + safezoneY;
			w = 0.0194688 * safezoneW;
			h = 0.033 * safezoneH;
			tooltip = "Exit the gunstore"; //--- ToDo: Localize;
			color[] = {0.95,0.1,0.1,1};
		};

		class SaleBuy : w_RscButton {
			
			idc = genstore_switch;

			text = "Sell Items";
			onButtonClick = "[] execVM 'client\systems\generalStore\switchMode.sqf'";

			x = 0.448438 * safezoneW + safezoneX;
			y = 0.643 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.033 * safezoneH;
			tooltip = "WARNING! This in inreversable!"; //--- ToDo: Localize;
			sizeEx = 1 * GUI_GRID_H;
		};

		class BuyToPlayer : w_RscButton {
			
			idc = genstore_buysell;

			text = "Buy";
			onButtonClick = "[0] execVM 'client\systems\generalStore\buysellSwitch.sqf'";

			x = 0.592812 * safezoneW + safezoneX;
			y = 0.690 * safezoneH + safezoneY;
			w = 0.103125 * safezoneW;
			h = 0.033 * safezoneH;
			tooltip = "Purchase the contents of your cart (if you have enough money and/or inventory space)"; //--- ToDo: Localize;
			sizeEx = 2 * GUI_GRID_H;
			color[] = {0.1,0.95,0.1,1};
		};
	};
};