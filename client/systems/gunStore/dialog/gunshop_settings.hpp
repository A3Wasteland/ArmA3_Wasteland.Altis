#include "gunstoreDefines.sqf"

class gunshopd {

	idd = gunshop_DIALOG;
	movingEnable = true;
	enableSimulation = true;
	onLoad = "[0] execVM 'client\systems\gunStore\populateGunStore.sqf'";

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
		class WeaponSelectedPicture: w_RscPicture
		{
			idc = gunshop_gun_pic;
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.302 * safezoneH + safezoneY;
			w = 0.061875 * safezoneW;
			h = 0.099 * safezoneH;
		};
		class ItemSelectedPicture: w_RscPicture
		{
			idc = gunshop_item_pic;
			x = 0.510312 * safezoneW + safezoneX;
			y = 0.302 * safezoneH + safezoneY;
			w = 0.061875 * safezoneW;
			h = 0.099 * safezoneH;
		};
		class ItemSelectedPrice: w_RscStructuredText
		{
			idc = gunshop_gun_TEXT;
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.456 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class ItemSelectedInfo: w_RscStructuredText
		{
			idc = gunshop_gun_Info;
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.412 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class PlayerMoneyText: w_RscText
		{
			idc = gunshop_money;
			text = "Cash:"; //--- ToDo: Localize;
			x = 0.613437 * safezoneW + safezoneX;
			y = 0.742 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class CartTotalText: w_RscText
		{
			idc = gunshop_total;
			text = "Total: $0"; //--- ToDo: Localize;
			x = 0.592812 * safezoneW + safezoneX;
			y = 0.665 * safezoneH + safezoneY;
			w = 0.103125 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class DialogTitleText: w_RscStructuredText
		{
			idc = 1100;
			text = "Welcome at the Gunstore. What will it be?"; //--- ToDo: Localize;
			x = 0.29375 * safezoneW + safezoneX;
			y = 0.225 * safezoneH + safezoneY;
			w = 0.4125 * safezoneW;
			h = 0.022 * safezoneH;
			colorText[] = {0,0,0,0};
			colorActive[] = {9,9,9,9};
			tooltip = "You can purchase Weapons, Ammo and accesoires here"; //--- ToDo: Localize;
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

	};
	
	class controls {
		
		class SelectionList: w_RscListbox
		{
			idc = gunshop_gun_list;
			onLBSelChanged = "[] execvm 'client\systems\gunStore\weaponInfo.sqf'";
			x = 0.304062 * safezoneW + safezoneX;
			y = 0.302 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.411 * safezoneH;
		};
		class CartList: w_RscListbox
		{
			idc = gunshop_cart;
			onLBSelChanged = "[] execvm 'client\systems\gunStore\weaponInfo.sqf'";
			x = 0.592812 * safezoneW + safezoneX;
			y = 0.302 * safezoneH + safezoneY;
			w = 0.103125 * safezoneW;
			h = 0.352 * safezoneH;
		};
		class CancelButton: w_RscButton
		{
			idc = -1;
			onButtonClick = "closeDialog 0;";
			text = "X"; //--- ToDo: Localize;
			x = 0.68381 * safezoneW + safezoneX;
			y = 0.225 * safezoneH + safezoneY;
			w = 0.0194688 * safezoneW;
			h = 0.033 * safezoneH;
			tooltip = "Exit the gunstore"; //--- ToDo: Localize;
		};
		class AddToCart: w_RscButton
		{
			idc = -1;
			onButtonClick = "[] execVM 'client\systems\gunStore\addToCart.sqf'";
			text = "ADD TO CART"; //--- ToDo: Localize;
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.511 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.033 * safezoneH;
			sizeEx = 1 * GUI_GRID_H;
			tooltip = "Add the selected item to your shopping cart"; //--- ToDo: Localize;
		};
		class RemoveFromCart: w_RscButton
		{
			idc = -1;
			onButtonClick = "[] execVM 'client\systems\gunStore\removeFromCart.sqf'";
			text = "REMOVE FROM CART"; //--- ToDo: Localize;
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.555 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.033 * safezoneH;
			sizeEx = 1 * GUI_GRID_H;
			tooltip = "Remove the selected item from your shopping cart"; //--- ToDo: Localize;
		};
		class BuyToCrate: w_RscButton
		{
			idc = -1;
			onButtonClick = "[] execVM 'client\systems\gunStore\sellUnif.sqf'";
			text = "sell uniform"; //--- ToDo: Localize;
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.599 * safezoneH + safezoneY;
			w = 0.0567187 * safezoneW;
			h = 0.033 * safezoneH;
			colorText[] = {9,1,1,1};
			colorBackground[] = {9,9,9,9};
			tooltip = "WARNING! This will also remove any items inside it!"; //--- ToDo: Localize;
			sizeEx = 1 * GUI_GRID_H;
		};
		class BuyToCrate2: w_RscButton
		{
			idc = -1;
			onButtonClick = "[] execVM 'client\systems\gunStore\sellVest.sqf'";
			text = "sell vest"; //--- ToDo: Localize;
			x = 0.515469 * safezoneW + safezoneX;
			y = 0.599 * safezoneH + safezoneY;
			w = 0.0567187 * safezoneW;
			h = 0.033 * safezoneH;
			tooltip = "WARNING! This will also remove any items inside it!"; //--- ToDo: Localize;
			sizeEx = 1 * GUI_GRID_H;
		};
		class BuySellEquipment: w_RscButton
		{
			idc = -1;
			onButtonClick = "[] execVM 'client\systems\gunStore\sellWeapon.sqf'";
			text = "sell current weapon"; //--- ToDo: Localize;
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.643 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.033 * safezoneH;
			tooltip = "WARNING! This in inreversable!"; //--- ToDo: Localize;
			sizeEx = 1 * GUI_GRID_H;
		};
		class BuyToPlayer: w_RscButton
		{
			idc = -1;
			onButtonClick = "[0] execVM 'client\systems\gunStore\buyGuns.sqf'";
			text = "PURCHASE"; //--- ToDo: Localize;
			x = 0.592812 * safezoneW + safezoneX;
			y = 0.690 * safezoneH + safezoneY;
			w = 0.103125 * safezoneW;
			h = 0.033 * safezoneH;
			colorText[] = {6,6,6,6};
			tooltip = "Purchase the contents of your cart (if you have enough money and/or inventory space)"; //--- ToDo: Localize;
			sizeEx = 2 * GUI_GRID_H;
		};
		class StoreButton0: w_RscButton
		{
			idc = -1;
			onButtonClick = "[0] execVM 'client\systems\gunStore\populateGunStore.sqf'";
			text = "WEAPONS"; //--- ToDo: Localize;
			x = 0.304062 * safezoneW + safezoneX;
			y = 0.258 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.033 * safezoneH;
			tooltip = "Go to the Weapons-section"; //--- ToDo: Localize;
			sizeEx = 2 * GUI_GRID_H;
		};
		class StoreButton1: w_RscButton
		{
			idc = -1;
			onButtonClick = "[1] execVM 'client\systems\gunStore\populateGunStore.sqf'";
			text = "AMMO"; //--- ToDo: Localize;
			x = 0.436438 * safezoneW + safezoneX;
			y = 0.258 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.033 * safezoneH;
			tooltip = "Go to the Ammunition-section"; //--- ToDo: Localize;
			sizeEx = 2 * GUI_GRID_H;
		};
		class StoreButton2: w_RscButton
		{
			idc = -1;
			onButtonClick = "[2] execVM 'client\systems\gunStore\populateGunStore.sqf'";
			text = "ITEMS"; //--- ToDo: Localize;
			x = 0.572187 * safezoneW + safezoneX;
			y = 0.258 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.033 * safezoneH;
			tooltip = "Go to the Equipment-section"; //--- ToDo: Localize;
			sizeEx = 2 * GUI_GRID_H;
		};

	};
};
