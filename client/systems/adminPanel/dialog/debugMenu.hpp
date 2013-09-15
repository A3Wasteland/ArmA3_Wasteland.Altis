#define debugMenu_dialog 50002
#define debugMenu_option 50003

class DebugMenu
{
	idd = debugMenu_dialog;
	movingEnable=1;
	onLoad = "uiNamespace setVariable ['DebugMenu', _this select 0]";

	class controlsBackground {

		class DebugMenu_Title:w_RscText
		{
			idc=-1;
			text="Menu";
			x=0.35;
			y=0.14;
			w=0.088;
			h=0.035;
		};

		class DebugMenu_background:w_RscBackground
		{
			idc=-1;
			x=0.28;
			y=0.10;
			w=0.42;
			h=0.74;
		};
	};

	class controls {

		class DebugMenu_options:w_Rsclist
		{
			idc = debugMenu_option;
			x=0.35;
			y=0.21;
			w=0.31;
			h=0.49;
		};

		class DebugMenu_activate:w_RscButton
		{
			idc=-1;
			text="Select";
			onButtonClick = "[3] execVM 'client\systems\adminPanel\optionSelect.sqf'";
			x=0.40;
			y=0.74;
			w=0.22;
			h=0.071;
		};
	};
};