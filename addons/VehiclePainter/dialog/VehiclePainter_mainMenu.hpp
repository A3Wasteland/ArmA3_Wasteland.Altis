// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
#define VehPaint_Menu_dialog 17000
#define VehPaint_Menu_option 17001

class VehPaint_Menu
{
	idd = VehPaint_Menu_dialog;
	movingEnable=1;
	onLoad = "uiNamespace setVariable ['VehPaint_Menu', _this select 0]";

	class controlsBackground {

		class VehPaint_Menu_background:w_RscPicture
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

		class VehPaint_Menu_Title:w_RscText
		{
			idc=-1;
			text="Vehicle Repaint Menu";
			x=0.30;
			y=0.098;
			w=0.31;
			h=0.035;
		};
		class VehPaint_Menu_Title2:w_RscText
		{
			idc=-1;
			text="$ 500 per paint job";
			x=0.30;
			y=0.116;
			w=0.31;
			h=0.035;
		};
	};

	class controls {

		class VehPaint_Menu_options:w_Rsclist
		{
			idc = VehPaint_Menu_option;
			x=0.30;
			y=0.18;
			w=0.31;
			h=0.49;
		};

		class VehPaint_Menu_activate:w_RscButton
		{
			idc=-1;
			text="Select";
			onButtonClick = "[0] execVM 'addons\VehiclePainter\VehiclePainter_optionSelect.sqf'";
			x=0.325;
			y=0.70;
			w=0.11;
			h=0.071;
		};
		
		class VehPaint_Menu_deactivate:w_RscButton
		{
			idc=-1;
			text="Close";
			onButtonClick = "closeDialog 0;";
			x=0.475;
			y=0.70;
			w=0.11;
			h=0.071;
		};

	};
};

