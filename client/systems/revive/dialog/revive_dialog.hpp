#define revive_dialog 3600
#define revive_dialog_text 3601
#define revive_dialog_button 3602

class ReviveDialog {
	idd = revive_dialog;
	movingEnable = false;
	enableSimulation = true;
	duration = 9999999;
	onLoad = "uiNamespace setVariable ['revivedialog', _this select 0]";

	class controlsBackground {

		class MainBackground: w_RscPicture
		{
			idc = -1;
			colorText[] = {1, 1, 1, 1};
			colorBackground[] = {0,0,0,0};
			text = "#(argb,8,8,3)color(1,1,1,0.09)";

			x = 0.381406 * safezoneW + safezoneX;
			y = 0.676 * safezoneH + safezoneY;
			w = 0.324844 * safezoneW;
			h = 0.099 * safezoneH;
		};

		class ReviveText: w_RscStructuredTextLeft
		{
			idc = revive_dialog_text;
			text = "You are bleeding out";

			x = 0.391719 * safezoneW + safezoneX;
			y = 0.687 * safezoneH + safezoneY;
			w = 0.2475 * safezoneW;
			h = 0.077 * safezoneH;
		};
	};

	class controls {

		class Button0: w_RscButton
		{
			idc = revive_dialog_button;
			text = "Suicide";
			onButtonClick = "(_this select 0) ctrlEnable false; execVM 'client\systems\revive\revive_Suicide.sqf'";

			x = 0.649531 * safezoneW + safezoneX;
			y = 0.731 * safezoneH + safezoneY;
			w = 0.0464063 * safezoneW;
			h = 0.033 * safezoneH;
		};
	};
};

