// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: markerLog.hpp

#define markerLogDialog 56500
#define markerLogList 56501

class MarkerLog
{
	idd = markerLogDialog;
	movingEnable = false;
	enableSimulation = true;
	onLoad = "execVM 'client\systems\adminPanel\markerLog.sqf'";

	class controlsBackground {

		class MainBackground: IGUIBack
		{
			idc = -1;
			colorText[] = {1, 1, 1, 1};
			colorBackground[] = {0,0,0,0.6};

			x = 0.1875 * (4/3) * SZ_SCALE_ABS + safezoneX;
			y = 0.15 * SZ_SCALE_ABS + safezoneY;
			w = 0.625 * (4/3) * SZ_SCALE_ABS;
			h = 0.661111 * SZ_SCALE_ABS;
		};

		class TopBar: IGUIBack
		{
			idc = -1;
			colorText[] = {1, 1, 1, 1};
			colorBackground[] = {A3W_UICOLOR_R, A3W_UICOLOR_G, A3W_UICOLOR_B, 0.8};

			x = 0.1875 * (4/3) * SZ_SCALE_ABS + safezoneX;
			y = 0.15 * SZ_SCALE_ABS + safezoneY;
			w = 0.625 * (4/3) * SZ_SCALE_ABS;
			h = 0.05 * SZ_SCALE_ABS;
		};

		class DialogTitleText: w_RscText
		{
			idc = -1;
			text = "Markers Log";
			font = "PuristaMedium";
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			x = 0.20 * (4/3) * SZ_SCALE_ABS + safezoneX;
			y = 0.155 * SZ_SCALE_ABS + safezoneY;
			w = 0.0844792 * (4/3) * SZ_SCALE_ABS;
			h = 0.0448148 * SZ_SCALE_ABS;
		};
	};

	class controls {

		class MarkerListBox: w_RscList
		{
			idc = markerLogList;
			x = 0.2 * (4/3) * SZ_SCALE_ABS + safezoneX;
			y = 0.225 * SZ_SCALE_ABS + safezoneY;
			w = 0.5925 * (4/3) * SZ_SCALE_ABS;
			h = 0.5 * SZ_SCALE_ABS;
		};

		class RefreshButton: w_RscButton
		{
			idc = -1;
			text = "Refresh";
			onButtonClick = "call compile preprocessFileLineNumbers 'client\systems\adminPanel\markerLog.sqf'";
			x = 0.2 * (4/3) * SZ_SCALE_ABS + safezoneX;
			y = 0.748 * SZ_SCALE_ABS + safezoneY;
			w = 0.05 * (4/3) * SZ_SCALE_ABS;
			h = 0.04 * SZ_SCALE_ABS;
		};
	};
};

