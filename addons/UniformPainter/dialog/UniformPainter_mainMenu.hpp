// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
#define Paint_Menu_dialog 17000
#define Paint_Menu_option 17001

class Paint_Menu
{
	idd = Paint_Menu_dialog;
	movingEnable=1;
	onLoad = "uiNamespace setVariable ['Paint_Menu', _this select 0]";

	class controlsBackground {

		class Paint_Menu_background: IGUIBack
		{
			idc=-1;
			colorText[] = {1, 1, 1, 1};
			colorBackground[] = {0, 0, 0, 0.6};
			x=0.28;
			y=0.10;
			w=0.3505;
			h=0.70;
		};

		class TopBar: IGUIBack
		{
			idc = -1;
			colorText[] = {1, 1, 1, 1};
			colorBackground[] = {A3W_UICOLOR_R, A3W_UICOLOR_G, A3W_UICOLOR_B, A3W_UIFILL};

			x=0.28;
			y=0.10;
			w=0.3505;
			h=0.05;
		};

		class Paint_Menu_Title:w_RscText
		{
			idc=-1;
			text="Paint Uniform Menu";
			x=0.30;
			y=0.098;
			w=0.31;
			h=0.035;
		};
		class Paint_Menu_Title2:w_RscText
		{
			idc=-1;
			text="$ 500 per paint job (Doesn't work on all uniforms)";
			x=0.30;
			y=0.116;
			w=0.31;
			h=0.035;
		};
	};

	class controls {

		class Paint_Menu_options:w_Rsclist
		{
			idc = Paint_Menu_option;
			x=0.30;
			y=0.18;
			w=0.31;
			h=0.49;
		};

		class Paint_Menu_activate:w_RscButton
		{
			idc=-1;
			text="Select";
			onButtonClick = "[0] execVM 'addons\UniformPainter\UniformPainter_optionSelect.sqf'";
			x=0.325;
			y=0.70;
			w=0.11;
			h=0.071;
		};
		
		class Paint_Menu_deactivate:w_RscButton
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

