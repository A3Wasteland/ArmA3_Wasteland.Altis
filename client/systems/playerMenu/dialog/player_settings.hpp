// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
#include "player_sys.sqf"

class playerSettings {

	idd = playersys_DIALOG;
	movingEnable = true;
	enableSimulation = true;
	onLoad = "[] execVM 'client\systems\playerMenu\item_list.sqf'";

	class controlsBackground {

		class MainBG : IGUIBack {
			idc = -1;
			colorText[] = {1, 1, 1, 1};
			colorBackground[] = {0,0,0,0.6};

			moving = true;
			x = 0.0; y = 0.1;
			w = .745; h = 0.65;
		};

		class TopBar: IGUIBack
		{
			idc = -1;
			colorText[] = {1, 1, 1, 1};
			colorBackground[] = {A3W_UICOLOR_R, A3W_UICOLOR_G, A3W_UICOLOR_B, 0.8};

			x = 0;
			y = 0.1;
			w = 0.745;
			h = 0.05;
		};

		class MainTitle : w_RscText {
			idc = -1;
			text = "Player Inventory";
			sizeEx = 0.04;
			shadow = 2;
			x = 0.260; y = 0.1;
			w = 0.3; h = 0.05;
		};

		class waterIcon : w_RscPicture {
			idc = -1;
			text = "client\icons\water.paa";
			x = 0.022; y = 0.2;
			w = 0.04 / (4/3); h = 0.04;
		};

		class foodIcon : w_RscPicture {
			idc = -1;
			text = "client\icons\food.paa";
			x = 0.022; y = 0.26;
			w = 0.04 / (4/3); h = 0.04;
		};

		class moneyIcon : w_RscPicture {
			idc = -1;
			text = "client\icons\money.paa";
			x = 0.022; y = 0.32;
			w = 0.04 / (4/3); h = 0.04;
		};

		class waterText : w_RscText {
			idc = water_text;
			text = "";
			sizeEx = 0.03;
			x = 0.06; y = 0.193;
			w = 0.3; h = 0.05;
		};

		class foodText : w_RscText {
			idc = food_text;
			sizeEx = 0.03;
			text = "";
			x = 0.06; y = 0.254;
			w = 0.3; h = 0.05;
		};

		class moneyText : w_RscText {
			idc = money_text;
			text = "";
			sizeEx = 0.03;
			x = 0.06; y = 0.313;
			w = 0.3; h = 0.05;
		};

		/*class distanceText : w_RscText {
			idc = view_range_text;
			text = "View range:";
			sizeEx = 0.025;
			x = 0.03; y = 0.40;
			w = 0.3; h = 0.02;
		};*/

		class uptimeText : w_RscText {
			idc = uptime_text;
			text = "";
			sizeEx = 0.030;
			x = 0.52; y = 0.69;
			w = 0.225; h = 0.03;
		};
	};

	class controls {

		class itemList : w_Rsclist {
			idc = item_list;
			x = 0.49; y = 0.185;
			w = 0.235; h = 0.325;
		};

		class DropButton : w_RscButton {
			idc = -1;
			text = "Drop";
			onButtonClick = "[1] execVM 'client\systems\playerMenu\itemfnc.sqf'";
			x = 0.610; y = 0.525;
			w = 0.116; h = 0.033 * safezoneH;
		};

		class UseButton : w_RscButton {
			idc = -1;
			text = "Use";
			onButtonClick = "[0] execVM 'client\systems\playerMenu\itemfnc.sqf'";
			x = 0.489; y = 0.525;
			w = 0.116; h = 0.033 * safezoneH;
		};

		class moneyInput: w_RscCombo {
			idc = money_value;
			x = 0.610; y = 0.618;
			w = .116; h = .030;
		};

		class DropcButton : w_RscButton {
			idc = -1;
			text = "Drop";
			onButtonClick = "[] execVM 'client\systems\playerMenu\dropMoney.sqf'";
			x = 0.489; y = 0.60;
			w = 0.116; h = 0.033 * safezoneH;
		};

		class CloseButton : w_RscButton {
			idc = close_button;
			text = "Close";
			onButtonClick = "[] execVM 'client\systems\playerMenu\closePlayerMenu.sqf'";
			x = 0.02; y = 0.66;
			w = 0.125; h = 0.033 * safezoneH;
		};

		class GroupsButton : w_RscButton {
			idc = groupButton;
			text = "Group Management";
			onButtonClick = "[] execVM 'client\systems\groups\loadGroupManagement.sqf'";
			x = 0.158; y = 0.66;
			w = 0.225; h = 0.033 * safezoneH;
		};

		/*class btnDistanceNear : w_RscButton {
			idc = -1;
			text = "Near";
			onButtonClick = "setViewDistance 1100;";
			x = 0.02; y = 0.43;
			w = 0.125; h = 0.033 * safezoneH;
		};

		class btnDistanceMedium : w_RscButton {
			idc = -1;
			text = "Medium";
			onButtonClick = "setViewDistance 2200;";
			x = 0.02; y = 0.5;
			w = 0.125; h = 0.033 * safezoneH;
		};

		class btnDistanceFar : w_RscButton {
			idc = -1;
			text = "Far";
			onButtonClick = "setViewDistance 3300;";
			x = 0.02; y = 0.57;
			w = 0.125; h = 0.033 * safezoneH;
		};

		class btnDistanceInsane : w_RscButton {
			text = "Insane";
			onButtonClick = "setViewDistance 5000;";
			x = 0.02; y = 0.60;
			w = 0.125; h = 0.033 * safezoneH;
		};*/

		class btnDistanceCHVD : w_RscButton {
			idc = -1;
			text = "Viewdist.";
			onButtonClick = "call CHVD_fnc_openDialog";
			x = 0.02; y = 0.57;
			w = 0.125; h = 0.033 * safezoneH;
		};

		class btnKillfeed : w_RscButton {
			idc = -1;
			text = "Killfeed";
			onButtonClick = "with missionNamespace do { [] call A3W_fnc_killFeedMenu }";
			x = 0.158; y = 0.57;
			w = 0.125; h = 0.033 * safezoneH;
		};
	};
};
