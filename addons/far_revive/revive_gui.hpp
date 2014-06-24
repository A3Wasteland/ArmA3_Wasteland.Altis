//	@file Name: revive_gui.hpp
//	@file Author: AgentRev

// To block input without showing anything
class ReviveBlankGUI
{
	idd = 910;
	movingEnabled = false;
};

class ReviveGUI : IGUIBack
{
	idd = 911;
	movingEnabled = false;
	controls[] = {RevProgBar, RevBarText, RevSuicideBtn, RevTextBG, RevText};
	controlsBackground[] = {RevBG};

	class RevBG : IGUIBack
	{
		idc = -1;

		#define RevBG_W (0.35 * X_SCALE)
		#define RevBG_H (0.25 * Y_SCALE)
		#define RevBG_X (0.5 - (RevBG_W / 2)) // middle of screen
		#define RevBG_Y ((0.5 + (safezoneH / 4)) - (RevBG_H / 2)) // middle of screen bottom

		x = RevBG_X;
		y = RevBG_Y;
		w = RevBG_W;
		h = RevBG_H;
	};

	#define BORDER_X (0.01 * X_SCALE)
	#define BORDER_Y (0.01 * Y_SCALE)

	class RevProgBar : RscProgressBar
	{
		idc = 9110;
		colorFrame[] = {1,1,1,1};
		colorBar[] = {0.75,0,0,1};
		texture = "#(argb,8,8,3)color(0.75,0,0,1)";

		// inside RevBG at the top
		#define RevProgBar_W (RevBG_W - (BORDER_X * 2)) // background width minus 0.01 border on each side
		#define RevProgBar_H (0.035 * Y_SCALE)
		#define RevProgBar_X (RevBG_X + CENTER(RevBG_W, RevProgBar_W)) // middle of background
		#define RevProgBar_Y (RevBG_Y + BORDER_Y) // 0.01 below background top

		x = RevProgBar_X;
		y = RevProgBar_Y;
		w = RevProgBar_W;
		h = RevProgBar_H;
	};

	class RevBarText : RscStructuredText
	{
		idc = 9111;
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

	class RevSuicideBtn : w_RscButton
	{
		idc = 9112;
		text = "Suicide";
		sizeEx = 0.04 * TEXT_SCALE;
		action = "execVM 'client\functions\confirmSuicide.sqf'";

		colorFocused[] = {0.3,0,0,1};
		colorBackground[] = {0.5,0,0,1};
		colorBackgroundActive[] = {0.8,0,0,1};

		// below RevProgBar
		#define RevSuicideBtn_W (0.10 * X_SCALE)
		#define RevSuicideBtn_H (0.035 * Y_SCALE)
		#define RevSuicideBtn_X (RevProgBar_X + CENTER(RevProgBar_W, RevSuicideBtn_W)) // centered under RevProgBar
		#define RevSuicideBtn_Y (RevProgBar_Y + RevProgBar_H + BORDER_Y) // below RevProgBar

		x = RevSuicideBtn_X;
		y = RevSuicideBtn_Y;
		w = RevSuicideBtn_W;
		h = RevSuicideBtn_H;
	};

	class RevTextBG : IGUIBack
	{
		idc = -1;

		// below RevSuicideBtn
		#define RevTextBG_X RevProgBar_X
		#define RevTextBG_Y (RevSuicideBtn_Y + RevSuicideBtn_H + BORDER_Y)
		#define RevTextBG_W RevProgBar_W
		#define RevTextBG_H (((RevBG_Y + RevBG_H) - RevTextBG_Y) - BORDER_Y) // ends above background bottom minus border

		x = RevTextBG_X;
		y = RevTextBG_Y;
		w = RevTextBG_W;
		h = RevTextBG_H;
	};

	class RevText : RscStructuredText
	{
		idc = 9113;
		text = "";

		class Attributes {
			align = "center";
		};

		// centered inside RevTextBG
		#define RevText_W (RevTextBG_W - (BORDER_X * 2))
		#define RevText_H (RevTextBG_H - (BORDER_Y * 2))
		#define RevText_X (RevTextBG_X + BORDER_X)
		#define RevText_Y (RevTextBG_Y + BORDER_Y)

		x = RevText_X;
		y = RevText_Y;
		w = RevText_W;
		h = RevText_H;
	};
};
