// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: score_gui.hpp
//	@file Author: AgentRev

#include "score_defines.hpp"

class ScoreGUI : IGUIBack
{
	idd = scoreGUI_idd;
	name = "ScoreGUI";
	fadeIn = 0;
	fadeOut = 0;
	duration = 1e11;
	movingEnabled = false;
	onLoad = "uiNamespace setVariable ['ScoreGUI', _this select 0]";
	controlsBackground[] = {};

	#define Score_EXT_MARGIN 0.025
	#define Score_EXT_MARGIN_X (Score_EXT_MARGIN * X_SCALE)
	#define Score_EXT_MARGIN_Y (Score_EXT_MARGIN * Y_SCALE)

	#define PListBG_H (0.38 * Y_SCALE)
	#define PRespawnTimerBG_H (0.033 * Y_SCALE)
	#define TListBG_H (0.23 * Y_SCALE)

	#define ScoreGUI_FullHeight (PListBG_H + (Score_EXT_MARGIN_Y / 2) + PRespawnTimerBG_H + (Score_EXT_MARGIN_Y / 2) + TListBG_H)

	class Controls
	{
		// PLAYER SCORES ///////////////////////////////////////////////

		class PListBG : IGUIBack
		{
			idc = -1;
			colorBackground[] = {0, 0, 0, 0.4};

			#define PListBG_W ((0.825 * X_SCALE) - (Score_EXT_MARGIN_X / 2))
			#define PListBG_X (0.5 - (PListBG_W / 2)) //(PListBG_W + (Score_EXT_MARGIN_X / 2))) // center left + margin
			#define PListBG_Y (0.5 - (ScoreGUI_FullHeight / 2)) // middle of screen //(SZ_TOP + Score_EXT_MARGIN_Y)

			x = PListBG_X;
			y = PListBG_Y;
			w = PListBG_W;
			h = PListBG_H;
		};

		class PListTopBG : IGUIBack
		{
			idc = -1;
			colorBackground[] = {A3W_UICOLOR_R, A3W_UICOLOR_G, A3W_UICOLOR_B, 0.8};

			#define PListTopBG_H (0.05 * Y_SCALE)

			x = PListBG_X;
			y = PListBG_Y;
			w = PListBG_W;
			h = PListTopBG_H;
		};

		class PListTopText : w_RscTextCenter
		{
			idc = -1;
			text = "Players";
			sizeEx = 0.06 * TEXT_SCALE;

			#define PListTopText_Y (PListBG_Y + CENTER(PListTopBG_H, PListTopBG_H))

			x = PListBG_X;
			y = PListTopText_Y;
			w = PListBG_W;
			h = PListTopBG_H;
		};

		// LIST

		#define PListHeadText_H (0.025 * Y_SCALE)
		#define PListEntryText_H (0.025 * Y_SCALE)

		#define PListHead_Y (PListBG_Y + PListTopBG_H + (0.0075 * X_SCALE))
		#define PListHead_W (0.09 * X_SCALE)
		#define PListHead_H PListHeadText_H
		#define PListHead_textSize (0.034 * TEXT_SCALE)

		#define PListEntry_W PListBG_W
		#define PListEntry_H (0.025 * Y_SCALE)
		#define PListEntry_X PListBG_X
		#define PListEntry_Y (PListBG_Y + PListTopBG_H + (0.035 * Y_SCALE))
		#define PListEntry_Y_offset (PListEntry_H + (0.005 * Y_SCALE))
		#define PListEntry_textSize (0.036 * TEXT_SCALE)

		// HEADER

		#define PListHead_Name_W (0.35 * X_SCALE)
		#define PListHead_Name_X (PListEntry_X + (0.0525 * X_SCALE))

		class PListHead_Name : w_RscStructuredTextLeft
		{
			idc = -1;
			text = "<t underline='true' shadow='0'>Name</t>";
			size = PListHead_textSize;

			x = PListHead_Name_X;
			y = PListHead_Y;
			w = PListHead_Name_W;
			h = PListHead_H;
		};

		#define PListHead_PKills_W PListHead_W
		#define PListHead_PKills_X (PListEntry_X + (0.4 * X_SCALE))

		class PListHead_PKills : w_RscStructuredText
		{
			idc = -1;
			text = "<t underline='true' shadow='0'>P. kills</t>"; // Alt + 255
			size = PListHead_textSize;

			x = PListHead_PKills_X;
			y = PListHead_Y;
			w = PListHead_PKills_W;
			h = PListHead_H;
		};

		#define PListHead_AIKills_W PListHead_W
		#define PListHead_AIKills_X (PListEntry_X + (0.475 * X_SCALE))

		class PListHead_AIKills : w_RscStructuredText
		{
			idc = -1;
			text = "<t underline='true' shadow='0'>AI kills</t>"; // Alt + 255
			size = PListHead_textSize;

			x = PListHead_AIKills_X;
			y = PListHead_Y;
			w = PListHead_AIKills_W;
			h = PListHead_H;
		};

		#define PListHead_Deaths_W PListHead_W
		#define PListHead_Deaths_X (PListEntry_X + (0.55 * X_SCALE))

		class PListHead_Deaths : w_RscStructuredText
		{
			idc = -1;
			text = "<t underline='true' shadow='0'>Deaths</t>";
			size = PListHead_textSize;

			x = PListHead_Deaths_X;
			y = PListHead_Y;
			w = PListHead_Deaths_W;
			h = PListHead_H;
		};

		#define PListHead_Revives_W PListHead_W
		#define PListHead_Revives_X (PListEntry_X + (0.625 * X_SCALE))

		class PListHead_Revives : w_RscStructuredText
		{
			idc = -1;
			text = "<t underline='true' shadow='0'>Revives</t>";
			size = PListHead_textSize;

			x = PListHead_Revives_X;
			y = PListHead_Y;
			w = PListHead_Revives_W;
			h = PListHead_H;
		};

		#define PListHead_Captures_W PListHead_W
		#define PListHead_Captures_X (PListEntry_X + (0.7 * X_SCALE))

		class PListHead_Captures : w_RscStructuredText
		{
			idc = -1;
			text = "<t underline='true' shadow='0'>Captures</t>";
			size = PListHead_textSize;

			x = PListHead_Captures_X;
			y = PListHead_Y;
			w = PListHead_Captures_W;
			h = PListHead_H;
		};

		// ENTRY TEMPLATE

		#define PListEntry_Rank_W (0.03 * X_SCALE)
		#define PListEntry_Rank_H PListEntryText_H

		#define PListEntry_Name_W PListHead_Name_W
		#define PListEntry_Name_H PListEntryText_H
		#define PListEntry_Name_Y (CENTER(PListEntry_H, PListEntry_Name_H) - (0.001 * Y_SCALE))

		#define PListEntryText2_H PListEntry_Name_H
		#define PListEntryText2_Y PListEntry_Name_Y

		#define PListEntry_TColor_W (0.01 * X_SCALE)
		#define PListEntry_PKills_W (0.06 * X_SCALE)
		#define PListEntry_AIKills_W (0.06 * X_SCALE)
		#define PListEntry_Deaths_W (0.06 * X_SCALE)
		#define PListEntry_Revives_W (0.06 * X_SCALE)
		#define PListEntry_Captures_W (0.06 * X_SCALE)

		#define TListEntryControls_X safezoneX

		#define Create_PListEntry(PListEntry_NUM) \
		class PListEntry##PListEntry_NUM : RscControlsGroup_NoScroll \
		{ \
			idc = scoreGUI_PListEntry(PListEntry_NUM); \
			x = TListEntryControls_X; \
			y = PListEntry_Y + (PListEntry_Y_offset * PListEntry_NUM); \
			w = safezoneW; \
			h = PListEntry_H; \
			class Controls \
			{ \
				class PListEntry##PListEntry_NUM##_BG : IGUIBack \
				{ \
					idc = scoreGUI_PListEntry_BG(PListEntry_NUM); \
					colorBackground[] = {0, 0, 0, 0}; \
					x = PListEntry_X - TListEntryControls_X; \
					y = 0; \
					w = PListEntry_W; \
					h = PListEntry_H; \
				}; \
				class PListEntry##PListEntry_NUM##_TColor : IGUIBack \
				{ \
					idc = scoreGUI_PListEntry_TColor(PListEntry_NUM); \
					colorBackground[] = {0, 0, 0, 0}; \
					x = PListEntry_X - TListEntryControls_X; \
					y = 0; \
					w = PListEntry_TColor_W; \
					h = PListEntry_H; \
				}; \
				class PListEntry##PListEntry_NUM##_Rank : w_RscTextCenter \
				{ \
					idc = scoreGUI_PListEntry_Rank(PListEntry_NUM); \
					text = __EVAL(PListEntry_NUM + 1); \
					sizeEx = PListEntry_textSize; \
					shadow = 2; \
					x = (PListEntry_X + (0.0175 * X_SCALE)) - TListEntryControls_X; \
					y = CENTER(PListEntry_H, PListEntry_Rank_H) - (0.001 * Y_SCALE); \
					w = PListEntry_Rank_W; \
					h = PListEntry_Rank_H; \
				}; \
				class PListEntry##PListEntry_NUM##_Name : w_RscText \
				{ \
					idc = scoreGUI_PListEntry_Name(PListEntry_NUM); \
					text = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"; \
					sizeEx = PListEntry_textSize; \
					x = PListHead_Name_X - TListEntryControls_X; \
					y = PListEntry_Name_Y; \
					w = PListEntry_Name_W; \
					h = PListEntry_Name_H; \
				}; \
				class PListEntry##PListEntry_NUM##_PKills : w_RscTextCenter \
				{ \
					idc = scoreGUI_PListEntry_PKills(PListEntry_NUM); \
					text = "57"; \
					sizeEx = PListEntry_textSize; \
					x = (PListHead_PKills_X + CENTER(PListHead_PKills_W, PListEntry_PKills_W)) - TListEntryControls_X; \
					y = PListEntryText2_Y; \
					w = PListEntry_PKills_W; \
					h = PListEntryText2_H; \
				}; \
				class PListEntry##PListEntry_NUM##_AIKills : w_RscTextCenter \
				{ \
					idc = scoreGUI_PListEntry_AIKills(PListEntry_NUM); \
					text = "57"; \
					sizeEx = PListEntry_textSize; \
					x = (PListHead_AIKills_X + CENTER(PListHead_AIKills_W, PListEntry_AIKills_W)) - TListEntryControls_X; \
					y = PListEntryText2_Y; \
					w = PListEntry_AIKills_W; \
					h = PListEntryText2_H; \
				}; \
				class PListEntry##PListEntry_NUM##_Deaths : w_RscTextCenter \
				{ \
					idc = scoreGUI_PListEntry_Deaths(PListEntry_NUM); \
					text = "32"; \
					sizeEx = PListEntry_textSize; \
					x = (PListHead_Deaths_X + CENTER(PListHead_Deaths_W, PListEntry_Deaths_W)) - TListEntryControls_X; \
					y = PListEntryText2_Y; \
					w = PListEntry_Deaths_W; \
					h = PListEntryText2_H; \
				}; \
				class PListEntry##PListEntry_NUM##_Revives : w_RscTextCenter \
				{ \
					idc = scoreGUI_PListEntry_Revives(PListEntry_NUM); \
					text = "15"; \
					sizeEx = PListEntry_textSize; \
					x = (PListHead_Revives_X + CENTER(PListHead_Revives_W, PListEntry_Revives_W)) - TListEntryControls_X; \
					y = PListEntryText2_Y; \
					w = PListEntry_Revives_W; \
					h = PListEntryText2_H; \
				}; \
				class PListEntry##PListEntry_NUM##_Captures : w_RscTextCenter \
				{ \
					idc = scoreGUI_PListEntry_Captures(PListEntry_NUM); \
					text = "117"; \
					sizeEx = PListEntry_textSize; \
					x = (PListHead_Captures_X + CENTER(PListHead_Captures_W, PListEntry_Captures_W)) - TListEntryControls_X; \
					y = PListEntryText2_Y; \
					w = PListEntry_Captures_W; \
					h = PListEntryText2_H; \
				}; \
			}; \
		};

		Create_PListEntry(0)
		Create_PListEntry(1)
		Create_PListEntry(2)
		Create_PListEntry(3)
		Create_PListEntry(4)
		Create_PListEntry(5)
		Create_PListEntry(6)
		Create_PListEntry(7)
		Create_PListEntry(8)
		Create_PListEntry(9)

		// RESPAWN TIMER //////////////////////////////////////////////////////////////////////////////////////////////

		// Based on RscRespawnCounter from "\A3\ui_f\config.cpp"

		#define PRespawnTimerControls_X safezoneX

		#define PRespawnTimerBG_W (0.286 * X_SCALE)
		#define PRespawnTimerBG_X (0.5 - (PRespawnTimerBG_W / 2))
		#define PRespawnTimerBG_Y (PListBG_Y + PListBG_H + (Score_EXT_MARGIN_Y / 2))

		class PRespawnTimer : RscControlsGroup_NoScroll
		{
			idc = scoreGUI_PRespawnTimer;
			x = PRespawnTimerControls_X;
			y = PRespawnTimerBG_Y;
			w = safezoneW;
			h = PRespawnTimerBG_H;

			class Controls
			{
				class PRespawnTimerBG1 : IGUIBack
				{
					idc = -1;
					colorBackground[] = {"profileNamespace getVariable ['IGUI_BCG_RGB_R',0]", "profileNamespace getVariable ['IGUI_BCG_RGB_G',1]", "profileNamespace getVariable ['IGUI_BCG_RGB_B',1]", "profileNamespace getVariable ['IGUI_BCG_RGB_A',0.8]"};

					x = PRespawnTimerBG_X - PRespawnTimerControls_X;
					y = 0;
					w = PRespawnTimerBG_W;
					h = PRespawnTimerBG_H;
				};

				class PRespawnTimerBG2 : IGUIBack
				{
					idc = -1;
					colorBackground[] = {0, 0, 0, 0.5};

					x = PRespawnTimerBG_X - PRespawnTimerControls_X;
					y = 0;
					w = PRespawnTimerBG_W;
					h = PRespawnTimerBG_H;
				};

				class PRespawnTimerText : w_RscText
				{
					idc = scoreGUI_PRespawnTimerText;
					text = "00:00.000";
					sizeEx = 0.068 * TEXT_SCALE;
					shadow = 1;
					colorShadow[] = {0, 0, 0, 0.5};

					x = (PRespawnTimerBG_X + (0.066 * X_SCALE)) - PRespawnTimerControls_X;
					y = (-0.0022 * Y_SCALE);
					w = 0.154 * X_SCALE;
					h = 0.033 * Y_SCALE;
				};
			};
		};

		// TEAM STUFF //////////////////////////////////////////////////////////////////////////////////////////////

		class TListBG : IGUIBack
		{
			idc = -1;
			colorBackground[] = {0, 0, 0, 0.3};

			#define TListBG_W ((0.825 * X_SCALE) - (Score_EXT_MARGIN_X / 2))
			#define TListBG_X (0.5 - (TListBG_W / 2)) //(TListBG_W + (Score_EXT_MARGIN_X / 2))) // center left + margin
			#define TListBG_Y (PRespawnTimerBG_Y + PRespawnTimerBG_H + (Score_EXT_MARGIN_X / 2)) // (0.5 - (TListBG_H / 2)) // middle of screen

			x = TListBG_X;
			y = TListBG_Y;
			w = TListBG_W;
			h = TListBG_H;
		};

		class TListTopBG : IGUIBack
		{
			idc = -1;
			colorBackground[] = {A3W_UICOLOR_R, A3W_UICOLOR_G, A3W_UICOLOR_B, 0.8};

			#define TListTopBG_H (0.05 * Y_SCALE)

			x = TListBG_X;
			y = TListBG_Y;
			w = TListBG_W;
			h = TListTopBG_H;
		};

		class TListTopText : w_RscTextCenter
		{
			idc = -1;
			text = "Teams";
			sizeEx = 0.06 * TEXT_SCALE;

			#define TListTopText_Y (TListBG_Y + CENTER(TListTopBG_H, TListTopBG_H))

			x = TListBG_X;
			y = TListTopText_Y;
			w = TListBG_W;
			h = TListTopBG_H;
		};

		// LIST //

		#define TListHeadText_H (0.025 * Y_SCALE)
		#define TListEntryText_H (0.025 * Y_SCALE)

		#define TListHead_Y (TListBG_Y + TListTopBG_H + (0.0075 * X_SCALE))
		#define TListHead_W (0.09 * X_SCALE)
		#define TListHead_H TListHeadText_H
		#define TListHead_textSize (0.034 * TEXT_SCALE)

		#define TListHead_Name_W (0.37 * X_SCALE)
		#define TListHead_Name_X (TListEntry_X + (0.05 * X_SCALE))

		#define TListEntry_W TListBG_W
		#define TListEntry_H (0.025 * Y_SCALE)
		#define TListEntry_X TListBG_X
		#define TListEntry_Y (TListBG_Y + TListTopBG_H + (0.035 * Y_SCALE))
		#define TListEntry_Y_offset (TListEntry_H + (0.005 * Y_SCALE))
		#define TListEntry_textSize (0.036 * TEXT_SCALE)

		// HEADER

		class TListHead_Name : w_RscStructuredTextLeft
		{
			idc = -1;
			text = "<t underline='true' shadow='0'>Name</t>";
			size = TListHead_textSize;

			x = TListHead_Name_X;
			y = TListHead_Y;
			w = TListHead_Name_W;
			h = TListHead_H;
		};

		#define TListHead_PKills_W TListHead_W
		#define TListHead_PKills_X (TListEntry_X + (0.55 * X_SCALE))

		class TListHead_PKills : w_RscStructuredText
		{
			idc = -1;
			text = "<t underline='true' shadow='0'>P. kills</t>"; // Alt + 255
			size = TListHead_textSize;

			x = TListHead_PKills_X;
			y = TListHead_Y;
			w = TListHead_PKills_W;
			h = TListHead_H;
		};

		#define TListHead_Deaths_W TListHead_W
		#define TListHead_Deaths_X (TListEntry_X + (0.625 * X_SCALE))

		class TListHead_Deaths : w_RscStructuredText
		{
			idc = -1;
			text = "<t underline='true' shadow='0'>Deaths</t>";
			size = TListHead_textSize;

			x = TListHead_Deaths_X;
			y = TListHead_Y;
			w = TListHead_Deaths_W;
			h = TListHead_H;
		};

		#define TListHead_Territories_W TListHead_W
		#define TListHead_Territories_X (TListEntry_X + (0.7 * X_SCALE))

		class TListHead_Territories : w_RscStructuredText
		{
			idc = -1;
			text = "<t underline='true' shadow='0'>Territories</t>";
			size = TListHead_textSize;

			x = TListHead_Territories_X;
			y = TListHead_Y;
			w = TListHead_Territories_W;
			h = TListHead_H;
		};

		// ENTRY TEMPLATE

		#define TListEntry_Rank_W (0.03 * X_SCALE)
		#define TListEntry_Rank_H TListEntryText_H

		#define TListEntry_Name_W TListHead_Name_W
		#define TListEntry_Name_H TListEntryText_H
		#define TListEntry_Name_Y (CENTER(TListEntry_H, TListEntry_Name_H) - (0.001 * Y_SCALE))

		#define TListEntryText2_H TListEntry_Name_H
		#define TListEntryText2_Y TListEntry_Name_Y

		#define TListEntry_TColor_W (0.01 * X_SCALE)
		#define TListEntry_PKills_W (0.04 * X_SCALE)
		#define TListEntry_Deaths_W (0.04 * X_SCALE)
		#define TListEntry_Territories_W (0.04 * X_SCALE)

		#define TListEntryControls_X safezoneX

		#define Create_TListEntry(TListEntry_NUM) \
		class TListEntry##TListEntry_NUM : RscControlsGroup_NoScroll \
		{ \
			idc = scoreGUI_TListEntry(TListEntry_NUM); \
			x = TListEntryControls_X; \
			y = TListEntry_Y + (TListEntry_Y_offset * TListEntry_NUM); \
			w = safezoneW; \
			h = TListEntry_H; \
			class Controls \
			{ \
				class TListEntry##TListEntry_NUM##_BG : IGUIBack \
				{ \
					idc = scoreGUI_TListEntry_BG(TListEntry_NUM); \
					colorBackground[] = {scoreGUI_Entry_BGColor_Default}; \
					x = TListEntry_X - TListEntryControls_X; \
					y = 0; \
					w = TListEntry_W; \
					h = TListEntry_H; \
				}; \
				class TListEntry##TListEntry_NUM##_TColor : IGUIBack \
				{ \
					idc = scoreGUI_TListEntry_TColor(TListEntry_NUM); \
					colorBackground[] = {0, 0, 0, 0}; \
					x = TListEntry_X - TListEntryControls_X; \
					y = 0; \
					w = TListEntry_TColor_W; \
					h = TListEntry_H; \
				}; \
				class TListEntry##TListEntry_NUM##_Rank : w_RscTextCenter \
				{ \
					idc = scoreGUI_TListEntry_Rank(TListEntry_NUM); \
					text = __EVAL(TListEntry_NUM + 1); \
					sizeEx = TListEntry_textSize; \
					shadow = 2; \
					x = (TListEntry_X + (0.0175 * X_SCALE)) - TListEntryControls_X; \
					y = CENTER(TListEntry_H, TListEntry_Rank_H) - (0.001 * Y_SCALE); \
					w = TListEntry_Rank_W; \
					h = TListEntry_Rank_H; \
				}; \
				class TListEntry##TListEntry_NUM##_Name : w_RscText \
				{ \
					idc = scoreGUI_TListEntry_Name(TListEntry_NUM); \
					text = "MANBEARPIGMANBEARPIGMANBEARPIGMANBEARPIGMANBEARPIGMANBEARPIG"; \
					sizeEx = TListEntry_textSize; \
					x = TListHead_Name_X - TListEntryControls_X; \
					y = TListEntry_Name_Y; \
					w = TListEntry_Name_W; \
					h = TListEntry_Name_H; \
				}; \
				class TListEntry##TListEntry_NUM##_Kills : w_RscTextCenter \
				{ \
					idc = scoreGUI_TListEntry_PKills(TListEntry_NUM); \
					text = "57"; \
					sizeEx = TListEntry_textSize; \
					x = (TListHead_PKills_X + CENTER(TListHead_PKills_W, TListEntry_PKills_W)) - TListEntryControls_X; \
					y = TListEntryText2_Y; \
					w = TListEntry_PKills_W; \
					h = TListEntryText2_H; \
				}; \
				class TListEntry##TListEntry_NUM##_Deaths : w_RscTextCenter \
				{ \
					idc = scoreGUI_TListEntry_Deaths(TListEntry_NUM); \
					text = "32"; \
					sizeEx = TListEntry_textSize; \
					x = (TListHead_Deaths_X + CENTER(TListHead_Deaths_W, TListEntry_Deaths_W)) - TListEntryControls_X; \
					y = TListEntryText2_Y; \
					w = TListEntry_Deaths_W; \
					h = TListEntryText2_H; \
				}; \
				class TListEntry##TListEntry_NUM##_Territories : w_RscTextCenter \
				{ \
					idc = scoreGUI_TListEntry_Territories(TListEntry_NUM); \
					text = "117"; \
					sizeEx = TListEntry_textSize; \
					x = (TListHead_Territories_X + CENTER(TListHead_Territories_W, TListEntry_Territories_W)) - TListEntryControls_X; \
					y = TListEntryText2_Y; \
					w = TListEntry_Territories_W; \
					h = TListEntryText2_H; \
				}; \
			}; \
		};

		Create_TListEntry(0)
		Create_TListEntry(1)
		Create_TListEntry(2)
		Create_TListEntry(3)
		Create_TListEntry(4)


		// BOUNTY STUFF //////////////////////////////////////////////////////////////////////////////////////////////

		/*class BountyBG : IGUIBack
		{
			idc = -1;
			colorBackground[] = {0, 0, 0, 0.3};

			#define BountyBG_W ((0.825 * X_SCALE) - (Score_EXT_MARGIN_X / 2))
			#define BountyBG_X (0.5 - (BountyBG_W / 2))
			#define BountyBG_Y (TListBG_Y + TListBG_H + Score_EXT_MARGIN_Y)
			#define BountyBG_H ((SZ_BOTTOM - Score_EXT_MARGIN_Y) - BountyBG_Y)

			x = BountyBG_X;
			y = BountyBG_Y;
			w = BountyBG_W;
			h = BountyBG_H;
		};

		class BountyTopBG : IGUIBack
		{
			idc = -1;
			colorBackground[] = {0, 0.5, 0, 0.8};

			#define BountyTopBG_H (0.05 * Y_SCALE)

			x = BountyBG_X;
			y = BountyBG_Y;
			w = BountyBG_W;
			h = BountyTopBG_H;
		};

		class BountyTopText : w_RscTextCenter
		{
			idc = -1;
			text = "Bounty";
			sizeEx = 0.06 * TEXT_SCALE;

			#define BountyTopText_Y (BountyBG_Y + CENTER(BountyTopBG_H, BountyTopBG_H))

			x = BountyBG_X;
			y = BountyTopText_Y;
			w = BountyBG_W;
			h = BountyTopBG_H;
		};
		*/

		// TEAM SCORES /////////////////////////////////////////////////

		/*class TListBG : IGUIBack
		{
			idc = -1;

			#define TListBG_W PListBG_W
			#define TListBG_H ((PListBG_H / 2) - (Score_EXT_MARGIN_X / 2))
			#define TListBG_X (PListBG_X + Score_EXT_MARGIN_X) // center right + margin
			#define TListBG_Y PListBG_Y // center top

			x = TListBG_X;
			y = TListBG_Y;
			w = TListBG_W;
			h = TListBG_H;
		};

		class TListTopBG : IGUIBack
		{
			idc = -1;

			#define TListTopBG_H (0.1 * Y_SCALE)

			x = TListBG_X;
			y = TListBG_Y;
			w = TListBG_W;
			h = TListTopBG_H;
		};

		class TListTopText : IGUIBack
		{
			idc = -1;
			"Teams"

			#define TListTopText_H (0.05 * Y_SCALE)
			#define TListTopText_Y (TListBG_Y + CENTER(TListTopBG_H, TListTopText_H))

			x = TListBG_X;
			y = TListTopText_Y;
			w = TListBG_W;
			h = TListTopText_H;
		};

		// LIST //

		#define TListHeadText_H (0.03 * Y_SCALE)
		#define TListEntryText_H TListHeadText_H

		#define TListEntry_W TListBG_W
		#define TListEntry_H (0.05 * Y_SCALE)
		#define TListEntry_X TListBG_X
		#define TListEntry_Y (TListBG_Y + TListBG_H)
		#define TListEntry_Y_offset TListEntry_H

		#define TListHead_Y (TListBG_Y + TListBG_H + 0.01)
		#define TListHead_H TListHeadText_H

		#define TListHead_Name_W (0.3 * X_SCALE)
		#define TListHead_Name_X (TListEntry_X + (0.07 * X_SCALE))

		// HEADER

		class TListHead_Name : w_RscText
		{
			idc = -1;
			text = "Name";

			x = TListHead_Name_X;
			y = TListHead_Y;
			w = TListHead_Name_W;
			h = TListHead_H;
		};

		#define TListHead_PKills_W (0.02 * X_SCALE)
		#define TListHead_PKills_X (TListEntry_X + (0.42 * X_SCALE))

		class TListHead_PKills : w_RscTextCenter
		{
			idc = -1;
			text = "Kills";

			x = TListHead_PKills_X;
			y = TListHead_Y;
			w = TListHead_PKills_W;
			h = TListHead_H;
		};

		#define TListHead_Deaths_W (0.02 * X_SCALE)
		#define TListHead_Deaths_X (TListEntry_X + (0.43 * X_SCALE))

		class TListHead_Deaths : w_RscTextCenter
		{
			idc = -1;
			text = "Deaths";

			x = TListHead_Deaths_X;
			y = TListHead_Y;
			w = TListHead_Deaths_W;
			h = TListHead_H;
		};

		#define TListHead_Territories_W (0.02 * X_SCALE)
		#define TListHead_Territories_X (TListEntry_X + (0.44 * X_SCALE))

		class TListHead_Territories : w_RscTextCenter
		{
			idc = -1;
			text = "Territories";

			x = TListHead_Territories_X;
			y = TListHead_Y;
			w = TListHead_Territories_W;
			h = TListHead_H;
		};

		// ENTRY 1

		class TListEntry1 : IGUIBack
		{
			idc = -1;

			#define TListTopBG_H (0.1 * Y_SCALE)

			x = TListEntry_X;
			y = TListEntry_Y + (TListEntry_Y_offset * 1);
			w = TListEntry_W;
			h = TListEntry_H;
		};

		#define TListEntry_Rank_W (0.02 * X_SCALE)
		#define TListEntry_Rank_H TListEntryText_H
		#define TListEntry_Rank_X (TListEntry_X + (0.03 * X_SCALE))
		#define TListEntry_Rank_Y (TListEntry_Y + CENTER(TListEntry_H, TListEntry_Rank_H))

		class TListEntry1_Rank : w_RscText
		{
			idc = 4610;
			text = "1.";

			x = TListEntry_Rank_X;
			y = TListEntry_Rank_Y + (TListEntry_Y_offset * 0);
			w = TListEntry_Rank_W;
			h = TListEntry_Rank_H;
		};

		#define TListEntry_Name_W (0.3 * X_SCALE)
		#define TListEntry_Name_H TListEntryText_H
		#define TListEntry_Name_Y (TListEntry_Y + CENTER(TListEntry_H, TListEntry_Name_H))

		class TListEntry1_Name : w_RscText
		{
			idc = 4611;

			x = TListHead_Name_X;
			y = TListEntry_Name_Y + (TListEntry_Y_offset * 1);
			w = TListEntry_Name_W;
			h = TListEntry_Name_H;
		};

		#define TListEntryText2_H TListEntry_Name_H
		#define TListEntryText2_Y TListEntry_Name_Y

		#define TListEntry_PKills_W (0.02 * X_SCALE)
		#define TListEntry_PKills_X (TListHead_PKills_X + CENTER(TListHead_PKills_W, TListEntry_PKills_W))

		class TListEntry1_Kills : w_RscTextCenter
		{
			idc = 4612;

			x = TListEntry_PKills_X;
			y = TListEntryText2_Y + (TListEntry_Y_offset * 1);
			w = TListEntry_PKills_W;
			h = TListEntryText2_H;
		};

		#define TListEntry_Deaths_W (0.02 * X_SCALE)
		#define TListEntry_Deaths_X (TListHead_Deaths_X + CENTER(TListHead_Deaths_W, TListEntry_Deaths_W))

		class TListEntry1_Deaths : w_RscTextCenter
		{
			idc = 4613;

			x = TListEntry_Deaths_X;
			y = TListEntryText2_Y + (TListEntry_Y_offset * 1);
			w = TListEntry_Deaths_W;
			h = TListEntryText2_H;
		};

		#define TListEntry_Territories_W (0.02 * X_SCALE)
		#define TListEntry_Territories_X (TListHead_Territories_X + CENTER(TListHead_Territories_W, TListEntry_Territories_W))

		class TListEntry1_Territories : w_RscTextCenter
		{
			idc = 4614;

			x = TListEntry_Territories_X;
			y = TListEntryText2_Y + (TListEntry_Y_offset * 1);
			w = TListEntry_Territories_W;
			h = TListEntryText2_H;
		};
		*/
	};
};
