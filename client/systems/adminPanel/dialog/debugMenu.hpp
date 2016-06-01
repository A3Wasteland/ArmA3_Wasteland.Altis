// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
#define debugMenu_dialog 50002
#define debugMenu_option 50003

class DebugMenu
{
	idd = debugMenu_dialog;
	movingEnable=1;
	onLoad = "uiNamespace setVariable ['DebugMenu', _this select 0]";

	class controlsBackground {

		class DebugMenu_background:w_RscPicture
		{
			idc=-1;
			colorText[] = {1, 1, 1, 1};
			colorBackground[] = {0,0,0,0};
			text = "#(argb,8,8,3)color(0,0,0,0.6)";
			x=0.28;
			y=0.10;
			w=0.3505;
			h=0.70;
		};

		class TopBar: w_RscPicture
		{
			idc = -1;
			colorText[] = {1, 1, 1, 1};
			colorBackground[] = {0,0,0,0};
			text = "#(argb,8,8,3)color(0.45,0.005,0,1)";

			x=0.28;
			y=0.10;
			w=0.3505;
			h=0.05;
		};

		class DebugMenu_Title:w_RscText
		{
			idc=-1;
			text="Debug Menu";
			x=0.29;
			y=0.108;
			w=0.088;
			h=0.035;
		};
	};

	class controls {

		class DebugMenu_options:w_Rsclist
		{
			idc = debugMenu_option;
			x=0.30;
			y=0.18;
			w=0.31;
			h=0.49;
		};

		class DebugMenu_activate:w_RscButton
		{
			idc=-1;
			text="Select";
			onButtonClick = "[2] execVM 'client\systems\adminPanel\optionSelect.sqf'";
			x=0.345;
			y=0.70;
			w=0.22;
			h=0.071;
		};
	};
};

