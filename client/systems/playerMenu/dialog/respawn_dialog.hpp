#define respawn_dialog 3400
#define respawn_Content_Text 3401
#define respawn_MissionUptime_Text 3402
#define respawn_Town_Button0 3403
#define respawn_Town_Button1 3404
#define respawn_Town_Button2 3405
#define respawn_Town_Button3 3406
#define respawn_Town_Button4 3407
#define respawn_PlayersInTown_Text0 3408
#define respawn_PlayersInTown_Text1 3409
#define respawn_PlayersInTown_Text2 3410
#define respawn_PlayersInTown_Text3 3411
#define respawn_PlayersInTown_Text4 3412
#define respawn_Random_Button 3413
#define respawn_LoadTowns_Button 3414
#define respawn_LoadBeacons_Button 3415
#define respawn_Preload_Checkbox 3416


class RespawnSelectionDialog
{
	idd = respawn_dialog;
	movingEnable = false;
	enableSimulation = true;
	onLoad = "uiNamespace setVariable ['RespawnSelectionDialog', _this select 0]";

	class ControlsBackground
	{
		class RspnMainBG: w_RscPicture
		{
			idc = -1;
			colorText[] = {1, 1, 1, 1};
			colorBackground[] = {0,0,0,0};
			text = "#(argb,8,8,3)color(1,1,1,0.09)";

			#define RspnMainBG_W ((0.809 * X_SCALE) min safezoneW)
			#define RspnMainBG_H ((0.620 * Y_SCALE) min safezoneH)
			#define RspnMainBG_X (CENTER(1, RspnMainBG_W) max safezoneX) // centered to screen
			#define RspnMainBG_Y (CENTER(1, RspnMainBG_H) max safezoneY) // centered to screen

			x = RspnMainBG_X;
			y = RspnMainBG_Y;
			w = RspnMainBG_W;
			h = RspnMainBG_H;
		};

		class RspnTopBar: w_RscPicture
		{
			idc = -1;
			colorText[] = {1, 1, 1, 1};
			colorBackground[] = {0,0,0,0};
			text = "#(argb,8,8,3)color(0.25,0.51,0.96,0.8)";

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

		class RspnMenuTitle: w_RscText
		{
			idc = -1;
			text = "Respawn Menu";
			sizeEx = 0.06 * TEXT_SCALE;
			style = 2; // ST_CENTER

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

		#define RspnLine_X (RspnTopBar_X + CENTER(RspnTopBar_W, RspnLine_W)) // centered to RspnTopBar
		#define RspnLine_W (RspnMainBG_W - (0.2 * X_SCALE))
		#define RspnLine_H (0.002 * SZ_SCALE_ABS) // (0.002 * Y_SCALE)

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

		// relative to RspnTopLine
		#define RspnLoadButton_Y (RspnTopLine_Y + RspnLine_H + (0.015 * Y_SCALE))

		class RspnMiddleLine: w_RscPicture
		{
			idc = -1;
			text = "#(argb,8,8,3)color(1,1,1,1)";

			#define RspnMiddleLine_Y (RspnLoadButton_Y + RspnButton_H + (0.015 * Y_SCALE)) // under RspnTownsButton

			x = RspnLine_X;
			y = RspnMiddleLine_Y;
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

			#define RspnMissionUptime_W (0.213 * X_SCALE)
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
		size = 0.04 * TEXT_SCALE;

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
			#define RspnPreloadChkText_W (0.06 * X_SCALE)
			#define RspnPreloadChkText_H (0.03 * Y_SCALE)
			#define RspnPreloadChkText_X (RspnPreloadChk_X + RspnPreloadChk_W + (0.001 * X_SCALE))
			#define RspnPreloadChkText_Y ((RspnPreloadChk_Y + CENTER(RspnPreloadChk_H, RspnPreloadChkText_H)) - (0.0015 * Y_SCALE))

			x = RspnPreloadChkText_X;
			y = RspnPreloadChkText_Y;
			w = RspnPreloadChkText_W;
			h = RspnPreloadChkText_H;
		};

		// relative to RspnTopLine
		#define RspnLoadButton_X (RspnLine_X + (RspnLine_W / 2))
		#define RspnLoadButton_X_spacer (0.015 * Y_SCALE)

		class RspnTownsButton: RspnButton
		{
			idc = respawn_LoadTowns_Button;
			onButtonClick = "[0] execVM 'client\functions\switchButtonNames.sqf'";
			text = "Towns";

			x = RspnLoadButton_X - (RspnLoadButton_X_spacer + RspnButton_W);
			y = RspnLoadButton_Y;
		};

		class RspnBeaconsButton: RspnButton
		{
			idc = respawn_LoadBeacons_Button;
			onButtonClick = "[1] execVM 'client\functions\switchButtonNames.sqf'";
			text = "Beacons";

			x = RspnLoadButton_X + RspnLoadButton_X_spacer;
			y = RspnLoadButton_Y;
		};

		// relative to RspnMiddleLine
		#define RspnLocButton_X (RspnLine_X + (0.01 * X_SCALE))
		#define RspnLocButton_Y (RspnMiddleLine_Y + RspnLine_H + (0.0225 * Y_SCALE))
		#define RspnLocButton_Y_offset (RspnButton_H + (0.015 * Y_SCALE))

		#define Create_RspnLocButton(RspnLocButton_NUM) \
		class RspnLocButton##RspnLocButton_NUM : RspnButton \
		{ \
			idc = respawn_Town_Button0 + RspnLocButton_NUM; \
			x = RspnLocButton_X; \
			y = RspnLocButton_Y + (RspnLocButton_Y_offset * RspnLocButton_NUM); \
		};

		Create_RspnLocButton(0)
		Create_RspnLocButton(1)
		Create_RspnLocButton(2)
		Create_RspnLocButton(3)
		Create_RspnLocButton(4)

		/*
		class RspnLocButton0: RspnButton
		{
			idc = respawn_Town_Button0;
			onButtonClick = ""; // Action is now set dynamically in loadRespawnDialog.sqf using buttonSetAction
			text = "";

			x = RspnLocButton_X;
			y = RspnLocButton_Y + (RspnLocButton_Y_offset * 0);
		};

		class RspnLocButton1: RspnButton
		{
			idc = respawn_Town_Button1;
			onButtonClick = ""; // Action is now set dynamically in loadRespawnDialog.sqf using buttonSetAction
			text = "";

			x = RspnLocButton_X;
			y = RspnLocButton_Y + (RspnLocButton_Y_offset * 1);
		};

		class RspnLocButton2: RspnButton
		{
			idc = respawn_Town_Button2;
			onButtonClick = ""; // Action is now set dynamically in loadRespawnDialog.sqf using buttonSetAction
			text = "";

			x = RspnLocButton_X;
			y = RspnLocButton_Y + (RspnLocButton_Y_offset * 2);
		};

		class RspnLocButton3: RspnButton
		{
			idc = respawn_Town_Button3;
			onButtonClick = ""; // Action is now set dynamically in loadRespawnDialog.sqf using buttonSetAction
			text = "";

			x = RspnLocButton_X;
			y = RspnLocButton_Y + (RspnLocButton_Y_offset * 3);
		};

		class RspnLocButton4: RspnButton
		{
			idc = respawn_Town_Button4;
			onButtonClick = ""; // Action is now set dynamically in loadRespawnDialog.sqf using buttonSetAction
			text = "";

			x = RspnLocButton_X;
			y = RspnLocButton_Y + (RspnLocButton_Y_offset * 4);
		};
		*/

		#define RspnLocPlayers_X (RspnLocButton_X + RspnButton_W + (0.008 * X_SCALE))
		#define RspnLocPlayers_Y (RspnLocButton_Y + (0.003 * Y_SCALE))
		#define RspnLocPlayers_W ((RspnLine_X + RspnLine_W) - RspnLocPlayers_X)
		#define RspnLocPlayers_H (0.04 * Y_SCALE)

		#define Create_RspnLocPlayers(RspnLocPlayers_NUM) \
		class RspnLocPlayers##RspnLocPlayers_NUM: w_RscStructuredTextLeft \
		{ \
			idc = respawn_PlayersInTown_Text0 + RspnLocPlayers_NUM; \
			size = 0.026 * TEXT_SCALE; \
			x = RspnLocPlayers_X; \
			y = RspnLocPlayers_Y + (RspnLocButton_Y_offset * RspnLocPlayers_NUM); \
			w = RspnLocPlayers_W; \
			h = RspnLocPlayers_H; \
		};

		Create_RspnLocPlayers(0)
		Create_RspnLocPlayers(1)
		Create_RspnLocPlayers(2)
		Create_RspnLocPlayers(3)
		Create_RspnLocPlayers(4)

		/*
		class RspnLocPlayers0: w_RspnLocPlayers
		{
			idc = respawn_PlayersInTown_Text0;
			y = RspnLocPlayers_Y + (RspnLocButton_Y_offset * 0);
		};

		class RspnLocPlayers1: w_RspnLocPlayers
		{
			idc = respawn_PlayersInTown_Text1;
			y = RspnLocPlayers_Y + (RspnLocButton_Y_offset * 1);
		};

		class RspnLocPlayers2: w_RspnLocPlayers
		{
			idc = respawn_PlayersInTown_Text2;
			y = RspnLocPlayers_Y + (RspnLocButton_Y_offset * 2);
		};

		class RspnLocPlayers3: w_RspnLocPlayers
		{
			idc = respawn_PlayersInTown_Text3;
			y = RspnLocPlayers_Y + (RspnLocButton_Y_offset * 3);
		};

		class RspnLocPlayers4: w_RspnLocPlayers
		{
			idc = respawn_PlayersInTown_Text4;
			y = RspnLocPlayers_Y + (RspnLocButton_Y_offset * 4);
		};
		*/

		class RspnLobbyButton: RspnButton
		{
			idc = -1;
			onButtonClick = "endMission 'LOSER'";
			text = "Lobby";

			x = RspnLine_X;
			y = RspnLobbyButton_Y;
		};
	};
};