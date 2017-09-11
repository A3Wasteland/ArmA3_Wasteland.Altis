// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: revive_gui.hpp
//	@file Author: AgentRev

#include "gui_defines.hpp"

class ReviveGUI : IGUIBack
{
	idd = ReviveGUI_IDD;
	fadeOut = 0;
	fadeIn = 0;
	duration = 1e11;
	name = "ReviveGUI";
	movingEnabled = false;
	onLoad = "uiNamespace setVariable ['ReviveGUI', _this select 0]";
	onUnload = "uiNamespace setVariable ['ReviveGUI', nil]";
	controls[] = {RevProgBar, RevBarText /*, RevSuicideBtn*/, RevRespawnText, RevTextBG, RevText /*, RevLastResortBtn*/};
	controlsBackground[] = {RevBG};

	class RevBG : IGUIBack
	{
		idc = -1;

		#define RevBG_W (0.35 * X_SCALE)
		#define RevBG_H (0.30 * Y_SCALE)
		#define RevBG_X (0.5 - (RevBG_W / 2)) // middle of screen
		#define RevBG_Y ((0.5 + (safezoneH / 4)) - (RevBG_H / 2)) // middle of screen bottom

		x = RevBG_X;
		y = RevBG_Y;
		w = RevBG_W;
		h = RevBG_H;
	};

	#define RevBORDER_X (0.01 * X_SCALE)
	#define RevBORDER_Y (0.01 * Y_SCALE)

	class RevProgBar : RscProgressBar
	{
		idc = RevProgBar_IDC;
		colorFrame[] = {1,1,1,1};
		colorBar[] = {0.75,0,0,1};
		texture = "#(argb,8,8,3)color(0.75,0,0,1)";

		// inside RevBG at the top
		#define RevProgBar_W (RevBG_W - (RevBORDER_X * 2)) // background width minus 0.01 border on each side
		#define RevProgBar_H (0.035 * Y_SCALE)
		#define RevProgBar_X (RevBG_X + CENTER(RevBG_W, RevProgBar_W)) // middle of background
		#define RevProgBar_Y (RevBG_Y + RevBORDER_Y) // 0.01 below background top

		x = RevProgBar_X;
		y = RevProgBar_Y;
		w = RevProgBar_W;
		h = RevProgBar_H;
	};

	class RevBarText : RscStructuredText
	{
		idc = RevBarText_IDC;
		text = "1:00";
		size = 0.04 * TEXT_SCALE;

		// centered in RevProgBar
		#define RevBarText_H (0.02 * Y_SCALE)
		#define RevBarText_Y (RevProgBar_Y + CENTER(RevProgBar_H, RevBarText_H))

		x = RevProgBar_X;
		y = RevBarText_Y;
		w = RevProgBar_W;
		h = RevBarText_H;

		class Attributes {
			align = "center";
		};
	};

	/*class RevSuicideBtn : w_RscButton
	{
		idc = RevSuicideBtn_IDC;
		text = "Give up";
		sizeEx = 0.04 * TEXT_SCALE;
		action = "execVM 'client\functions\confirmSuicide.sqf'";

		colorFocused[] = {0.3,0,0,1};
		colorBackground[] = {0.5,0,0,1};
		colorBackgroundActive[] = {0.8,0,0,1};

		// below RevProgBar
		#define RevSuicideBtn_W (0.10 * X_SCALE)
		#define RevSuicideBtn_H (0.035 * Y_SCALE)
		#define RevSuicideBtn_X (RevProgBar_X + CENTER(RevProgBar_W, RevSuicideBtn_W)) // centered under RevProgBar
		#define RevSuicideBtn_Y (RevProgBar_Y + RevProgBar_H + RevBORDER_Y) // below RevProgBar

		x = RevSuicideBtn_X;
		y = RevSuicideBtn_Y;
		w = RevSuicideBtn_W;
		h = RevSuicideBtn_H;
	};*/

	class RevRespawnText : RscStructuredText
	{
		idc = -1;
		text = "Press spacebar to respawn";
		size = 0.04 * TEXT_SCALE;

		class Attributes {
			align = "center";
		};

		// below RevProgBar
		#define RevRespawnText_W RevProgBar_W
		#define RevRespawnText_H (0.02 * Y_SCALE)
		#define RevRespawnText_X (RevProgBar_X + CENTER(RevProgBar_W, RevRespawnText_W)) // centered under RevProgBar
		#define RevRespawnText_Y (RevProgBar_Y + RevProgBar_H + RevBORDER_Y) // below RevProgBar

		x = RevRespawnText_X;
		y = RevRespawnText_Y;
		w = RevRespawnText_W;
		h = RevRespawnText_H;
	};

	class RevTextBG : IGUIBack
	{
		idc = -1;
		colorBackground[] = {0, 0, 0, 0.4};

		// below RevRespawnText
		#define RevTextBG_X RevProgBar_X
		#define RevTextBG_Y (RevRespawnText_Y + RevRespawnText_H + RevBORDER_Y)
		#define RevTextBG_W RevProgBar_W
		#define RevTextBG_H (((RevBG_Y + RevBG_H) - RevTextBG_Y) - RevBORDER_Y) // ends above background bottom minus border

		x = RevTextBG_X;
		y = RevTextBG_Y;
		w = RevTextBG_W;
		h = RevTextBG_H;
	};

	class RevText : RscStructuredText
	{
		idc = RevText_IDC;
		text = "";
		size = 0.04 * TEXT_SCALE;

		class Attributes {
			align = "center";
		};

		// centered inside RevTextBG
		#define RevText_W (RevTextBG_W - RevBORDER_X)
		#define RevText_H (RevTextBG_H - RevBORDER_Y)
		#define RevText_X (RevTextBG_X + (RevBORDER_X / 2))
		#define RevText_Y (RevTextBG_Y + (RevBORDER_Y / 2))

		x = RevText_X;
		y = RevText_Y;
		w = RevText_W;
		h = RevText_H;
	};

	/*class RevLastResortBtn : w_RscButton // now Backspace key!
	{
		idc = RevLastResortBtn_IDC;
		action = "execVM 'addons\far_revive\FAR_lastResort.sqf'";

		colorFocused[] = {0,0,0,0};
		colorBackground[] = {0,0,0,0};
		colorBackgroundActive[] = {1,0,0,1};
		colorShadow[] = {0,0,0,0};

		// top right
		#define RevLastResortBtn_W (0.02 * X_SCALE)
		#define RevLastResortBtn_H (0.02 * Y_SCALE)
		#define RevLastResortBtn_X ((safeZoneXAbs + safeZoneWAbs) - (RevLastResortBtn_W / 2))
		#define RevLastResortBtn_Y (SZ_TOP - (RevLastResortBtn_H / 2))

		x = RevLastResortBtn_X;
		y = RevLastResortBtn_Y;
		w = RevLastResortBtn_W;
		h = RevLastResortBtn_H;
	};*/
};
