// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: respawn_dialog.hpp
//	@file Author: His_Shadow, AgentRev

#include "respawn_defines.hpp"

class RespawnSelectionDialog
{
	idd = respawn_dialog;
	movingEnable = true;
	enableSimulation = true;
	onLoad = "uiNamespace setVariable ['RespawnSelectionDialog', _this select 0]";

	class ControlsBackground
	{
		class RspnMainBG: IGUIBack
		{
			idc = -1;
			colorText[] = {1, 1, 1, 1};
			colorBackground[] = {1,1,1,0.09};
			moving = true;

			#define RspnMainBG_W ((0.809 * X_SCALE) min safezoneW)
			#define RspnMainBG_H ((0.620 * Y_SCALE) min safezoneH)
			#define RspnMainBG_X (CENTER(1, RspnMainBG_W) max safezoneX) // centered to screen
			#define RspnMainBG_Y (CENTER(1, RspnMainBG_H) max safezoneY) // centered to screen

			x = RspnMainBG_X;
			y = RspnMainBG_Y;
			w = RspnMainBG_W;
			h = RspnMainBG_H;
		};

		class RspnTopBar: IGUIBack
		{
			idc = -1;
			colorText[] = {1, 1, 1, 1};
			colorBackground[] = {A3W_UICOLOR_R, A3W_UICOLOR_G, A3W_UICOLOR_B, 0.8};

			// relative to RspnMainBG
			#define RspnTopBar_W RspnMainBG_W // match RspnMainBG width
			#define RspnTopBar_H (0.072 * Y_SCALE)
			#define RspnTopBar_X RspnMainBG_X // aligned to RspnMainBG
			#define RspnTopBar_Y RspnMainBG_Y // aligned to RspnMainBG

			x = RspnTopBar_X;
			y = RspnTopBar_Y;
			w = RspnTopBar_W;
			h = RspnTopBar_H;
		};

		class RspnMenuTitle: w_RscTextCenter
		{
			idc = -1;
			text = "Respawn Menu";
			sizeEx = 0.06 * TEXT_SCALE;

			// relative to RspnTopBar
			#define RspnMenuTitle_W (0.267 * X_SCALE)
			#define RspnMenuTitle_H (0.035 * Y_SCALE)
			#define RspnMenuTitle_X (RspnTopBar_X + CENTER(RspnTopBar_W, RspnMenuTitle_W)) // centered in RspnTopBar
			#define RspnMenuTitle_Y (RspnTopBar_Y + CENTER(RspnTopBar_H, RspnMenuTitle_H)) // centered in RspnTopBar

			x = RspnMenuTitle_X;
			y = RspnMenuTitle_Y;
			w = RspnMenuTitle_W;
			h = RspnMenuTitle_H;
		};

		class RspnStructText: w_RscStructuredText
		{
			idc = respawn_Content_Text;
			text = "";
			size = 0.04 * TEXT_SCALE;

			// relative to RspnTopBar
			#define RspnStructText_W (0.533 * X_SCALE)
			#define RspnStructText_H (0.060 * Y_SCALE)
			#define RspnStructText_X (RspnTopBar_X + CENTER(RspnTopBar_W, RspnStructText_W)) // centered to RspnTopBar
			#define RspnStructText_Y (RspnTopBar_Y + RspnTopBar_H + (0.008 * Y_SCALE)) // under RspnTopBar

			x = RspnStructText_X;
			y = RspnStructText_Y;
			w = RspnStructText_W;
			h = RspnStructText_H;
		};

		#define RspnButton_H (0.033 * Y_SCALE)

		// relative to RspnTopBar
		#define RspnRandomButton_Y (RspnTopBar_Y + RspnTopBar_H + (0.072 * Y_SCALE)) // under RspnTopBar

		#define RspnLine_W (RspnMainBG_W - (0.1 * X_SCALE))
		#define RspnLine_H (0.002 * SZ_SCALE_ABS) // (0.002 * Y_SCALE)
		#define RspnLine_X (RspnTopBar_X + CENTER(RspnTopBar_W, RspnLine_W)) // centered to RspnTopBar

		class RspnTopLine: w_RscPicture
		{
			idc = -1;
			text = "#(argb,8,8,3)color(1,1,1,1)";

			#define RspnTopLine_Y (RspnRandomButton_Y + RspnButton_H + (0.015 * Y_SCALE)) // under RspnRandomButton

			x = RspnLine_X;
			y = RspnTopLine_Y;
			w = RspnLine_W;
			h = RspnLine_H;
		};

		// above bottom of RspnMainBG
		#define RspnLobbyButton_Y ((RspnMainBG_Y + RspnMainBG_H) - (RspnButton_H + (0.040 * Y_SCALE)))

		class RspnBottomLine: w_RscPicture
		{
			idc = -1;
			text = "#(argb,8,8,3)color(1,1,1,1)";

			#define RspnBottomLine_Y (RspnLobbyButton_Y - (RspnLine_H + (0.015 * Y_SCALE))) // above RspnLobbyButton

			x = RspnLine_X;
			y = RspnBottomLine_Y;
			w = RspnLine_W;
			h = RspnLine_H;
		};

		class RspnMissionUptime: w_RscStructuredTextLeft
		{
			idc = respawn_MissionUptime_Text;
			text = "Mission Uptime: 00:00:00";
			size = 0.04 * TEXT_SCALE;

			#define RspnMissionUptime_W (0.23 * X_SCALE)
			#define RspnMissionUptime_H (0.025 * Y_SCALE)
			#define RspnMissionUptime_X ((RspnLine_X + RspnLine_W) - RspnMissionUptime_W) // aligned right to RspnBottomLine
			#define RspnMissionUptime_Y (RspnLobbyButton_Y + CENTER(RspnButton_H, RspnMissionUptime_H)) // centered to RspnLobbyButton

			x = RspnMissionUptime_X;
			y = RspnMissionUptime_Y;
			w = RspnMissionUptime_W;
			h = RspnMissionUptime_H;
		};
	};

	class RspnButton: w_RscButton
	{
		sizeEx = 0.04 * TEXT_SCALE;

		#define RspnButton_W (0.139 * X_SCALE)

		w = RspnButton_W;
		h = RspnButton_H;
	};

	class Controls
	{
		class RspnRandomButton: RspnButton
		{
			idc = respawn_Random_Button;
			onButtonClick = ""; // Action is now set dynamically in loadRespawnDialog.sqf using buttonSetAction
			text = "Random";

			// relative to RspnTopBar
			#define RspnRandomButton_X (RspnTopBar_X + CENTER(RspnTopBar_W, RspnButton_W)) // centered under RspnTopBar

			x = RspnRandomButton_X;
			y = RspnRandomButton_Y;
		};

		class RspnPreloadChk: w_RscCheckBox
		{
			idc = respawn_Preload_Checkbox;

			// left of RspnRandomButton
			#define RspnPreloadChk_W (0.026 * X_SCALE)
			#define RspnPreloadChk_H (0.026 * Y_SCALE)
			#define RspnPreloadChk_X RspnLine_X
			#define RspnPreloadChk_Y ((RspnRandomButton_Y + RspnButton_H) - RspnPreloadChk_H)

			x = RspnPreloadChk_X;
			y = RspnPreloadChk_Y;
			w = RspnPreloadChk_W;
			h = RspnPreloadChk_H;
		};

		class RspnPreloadChkText: w_RscText
		{
			idc = -1;
			text = "Preload";
			sizeEx = 0.036 * TEXT_SCALE;

			// right of RspnPreloadChk
			#define RspnPreloadChkText_W (0.08 * X_SCALE)
			#define RspnPreloadChkText_H (0.03 * Y_SCALE)
			#define RspnPreloadChkText_X (RspnPreloadChk_X + RspnPreloadChk_W + (0.001 * X_SCALE))
			#define RspnPreloadChkText_Y ((RspnPreloadChk_Y + CENTER(RspnPreloadChk_H, RspnPreloadChkText_H)) - (0.0015 * Y_SCALE))

			x = RspnPreloadChkText_X;
			y = RspnPreloadChkText_Y;
			w = RspnPreloadChkText_W;
			h = RspnPreloadChkText_H;
		};


		#define RspnLocType_X RspnLine_X
		#define RspnLocType_Y (RspnTopLine_Y + RspnLine_H + (0.015 * Y_SCALE))
		#define RspnLocType_W (0.225 * X_SCALE)
		#define RspnLocType_H (0.0225 * Y_SCALE)

		class RspnLocType: w_RscXListBox
		{
			idc = respawn_Locations_Type;

			x = RspnLocType_X;
			y = RspnLocType_Y;
			w = RspnLocType_W;
			h = RspnLocType_H;
		};

		#define RspnSpawnButton_W RspnLocType_W
		#define RspnSpawnButton_H (0.04 * Y_SCALE)
		#define RspnSpawnButton_X RspnLocType_X
		#define RspnSpawnButton_Y ((RspnBottomLine_Y - (0.015 * Y_SCALE)) - RspnSpawnButton_H)

		class RspnSpawnButton: RspnButton
		{
			idc = respawn_Spawn_Button;
			text = "Spawn"; // text alternates between "Loading..." and "Spawn" in loadRespawnDialog.sqf

			x = RspnSpawnButton_X;
			y = RspnSpawnButton_Y;
			w = RspnSpawnButton_W;
			h = RspnSpawnButton_H;
		};

		#define RspnLocList_X RspnLocType_X
		#define RspnLocList_Y (RspnLocType_Y + RspnLocType_H + (0.0075 * Y_SCALE))
		#define RspnLocList_W RspnLocType_W
		#define RspnLocList_H ((RspnSpawnButton_Y - RspnLocList_Y) - (0.0075 * Y_SCALE))

		class RspnLocList: w_RscList
		{
			idc = respawn_Locations_List;
			rowHeight = 0.0225 * Y_SCALE;

			x = RspnLocList_X;
			y = RspnLocList_Y;
			w = RspnLocList_W;
			h = RspnLocList_H;
		};

		#define RspnLocText_X (RspnLocList_X + RspnLocList_W + (0.0075 * X_SCALE))
		#define RspnLocText_W ((RspnLine_X + RspnLine_W) - RspnLocText_X)
		#define RspnLocText_H RspnSpawnButton_H
		#define RspnLocText_Y ((RspnBottomLine_Y - (0.015 * Y_SCALE)) - RspnLocText_H)

		class RspnLocText: w_RscStructuredTextLeft
		{
			idc = respawn_Locations_Text;
			size = 0.034 * TEXT_SCALE;
			colorBackground[] = {0, 0, 0, 0.3};
			shadow = 0;

			x = RspnLocText_X;
			y = RspnLocText_Y;
			w = RspnLocText_W;
			h = RspnLocText_H;
		};

		#define RspnLocMap_X RspnLocText_X
		#define RspnLocMap_Y RspnLocType_Y
		#define RspnLocMap_W RspnLocText_W
		#define RspnLocMap_H ((RspnLocText_Y - (0.0075 * Y_SCALE)) - RspnLocMap_Y)

		class RspnLocMap: w_RscMapControl
		{
			idc = respawn_Locations_Map;
			scaleMax = 3;

			x = RspnLocMap_X;
			y = RspnLocMap_Y;
			w = RspnLocMap_W;
			h = RspnLocMap_H;
		};


		#define RspnLobbyButton_X RspnLine_X

		class RspnLobbyButton: RspnButton
		{
			idc = -1;
			onButtonClick = "endMission 'LOSER'";
			text = "Lobby";

			x = RspnLobbyButton_X;
			y = RspnLobbyButton_Y;
		};

		#define RspnGroupButton_X (RspnLobbyButton_X + RspnButton_W + (0.015 * X_SCALE))
		//#define RspnGroupButton_W (0.075 * X_SCALE)

		class RspnGroupButton: RspnButton
		{
			idc = respawn_GroupMgmt_Button;
			text = "Group";
			onButtonClick = "[] execVM 'client\systems\groups\loadGroupManagement.sqf'";

			x = RspnGroupButton_X;
			y = RspnLobbyButton_Y;
			//w = RspnGroupButton_W;
		};

		#define RspnKillfeedButton_X (RspnGroupButton_X + RspnButton_W + (0.015 * X_SCALE))
		//#define RspnKillfeedButton_W (0.075 * X_SCALE)

		class RspnKillfeedButton: RspnButton
		{
			idc = -1;
			text = "Killfeed";
			onButtonClick = "with missionNamespace do { [] call A3W_fnc_killFeedMenu }";

			x = RspnKillfeedButton_X;
			y = RspnLobbyButton_Y;
			//w = RspnKillfeedButton_W;
		};
	};
};
