// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
#define vPin_Menu_dialog 17000
#define vPin_Menu_option 17001

class vPin_Menu
{
	idd = vPin_Menu_dialog;
	movingEnable=1;
	onLoad = "uiNamespace setVariable ['vPin_Menu', _this select 0]";

	class controlsBackground {

		class vPin_Menu_background:w_RscPicture
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
			text = "#(argb,8,8,3)color(0.546,0.59,0.363,0.4)";

			x=0.28;
			y=0.10;
			w=0.3505;
			h=0.05;
		};

		class vPin_Menu_Title:w_RscText
		{
			idc=-1;
			text="Vehicle Pinlock Menu";
			x=0.29;
			y=0.108;
			w=0.088;
			h=0.035;
		};
	};

	class controls {

		class vPin_Menu_options:w_Rsclist
		{
			idc = vPin_Menu_option;
			x=0.30;
			y=0.18;
			w=0.31;
			h=0.49;
		};

		class vPin_Menu_activate:w_RscButton
		{
			idc=-1;
			text="Select";
			onButtonClick = "[1] execVM 'addons\vPin\vPin_optionSelect.sqf'";
			x=0.345;
			y=0.70;
			w=0.22;
			h=0.071;
		};
	};
};

