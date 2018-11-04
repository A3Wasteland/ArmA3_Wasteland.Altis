// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2017 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: killFeedMenu_gui.hpp

#include "killFeed_defines.hpp"

class A3W_killFeedMenu
{
	idd = A3W_killFeedMenu_IDD;
	movingEnable = true;
	enableSimulation = true;
	onLoad = "uiNamespace setVariable ['A3W_killFeedMenu', _this select 0]";
	onUnload = "uiNamespace setVariable ['A3W_killFeedMenu', nil]; saveProfileNamespace";

	#define FeedMenu_MARGIN 0.02
	#define FeedMenu_MARGIN_X (FeedMenu_MARGIN * X_SCALE)
	#define FeedMenu_MARGIN_Y (FeedMenu_MARGIN * Y_SCALE)

	class ControlsBackground
	{
		class FeedMenu_BG : IGUIBack
		{
			idc = -1;
			colorBackground[] = {0, 0, 0, 0.6};
			moving = true;

			#define FeedMenu_BG_W (1.0 * X_SCALE)
			#define FeedMenu_BG_H (0.7 * Y_SCALE)
			#define FeedMenu_BG_X CENTER(1,FeedMenu_BG_W)
			#define FeedMenu_BG_Y CENTER(1,FeedMenu_BG_H)

			w = FeedMenu_BG_W;
			h = FeedMenu_BG_H;
			x = FeedMenu_BG_X;
			y = FeedMenu_BG_Y;
		};

		class FeedMenu_TopBar : IGUIBack
		{
			idc = -1;
			colorBackground[] = {A3W_UICOLOR_R, A3W_UICOLOR_G, A3W_UICOLOR_B, 0.8};

			#define FeedMenu_TopBar_H (0.05 * Y_SCALE)

			w = FeedMenu_BG_W;
			h = FeedMenu_TopBar_H;
			x = FeedMenu_BG_X;
			y = FeedMenu_BG_Y;
		};

		class FeedMenu_TopText : w_RscTextCenter
		{
			idc = -1;
			text = "Killfeed";
			sizeEx = 0.06 * TEXT_SCALE;

			w = FeedMenu_BG_W;
			h = FeedMenu_TopBar_H;
			x = FeedMenu_BG_X;
			y = FeedMenu_BG_Y;
		};
	};

	#define FeedMenu_Options_W (FeedMenu_BG_W - (FeedMenu_MARGIN_X * 2))
	#define FeedMenu_Options_H (0.105 * Y_SCALE)
	#define FeedMenu_OptionsL_X (FeedMenu_BG_X + FeedMenu_MARGIN_X)
	#define FeedMenu_OptionsR_X (FeedMenu_BG_X + FeedMenu_MARGIN_X + (FeedMenu_BG_W * 0.45))
	#define FeedMenu_Options_Y (FeedMenu_BG_Y + FeedMenu_TopBar_H + FeedMenu_MARGIN_Y)
	#define FeedMenu_Options_TEXTSIZE (0.04 * TEXT_SCALE)

	#define FeedMenu_Option_MARGIN_Y (0.015 * Y_SCALE)

	#define FeedMenu_Label_W (0.175 * X_SCALE)
	#define FeedMenu_Label_H (0.02 * Y_SCALE)
	#define FeedMenu_Label_MARGIN_X (0.005 * X_SCALE)

	class FeedMenu_Label : w_RscText
	{
		idc = -1;
		sizeEx = FeedMenu_Options_TEXTSIZE;
		style = ST_RIGHT;

		w = FeedMenu_Label_W;
		h = FeedMenu_Label_H;
	};

	#define FeedMenu_Checkbox_W (0.025 * X_SCALE)
	#define FeedMenu_Checkbox_H (0.025 * Y_SCALE)

	#define FeedMenu_Slider_W (0.2 * X_SCALE)
	#define FeedMenu_Slider_H (0.025 * Y_SCALE)
	#define FeedMenu_Slider_MARGIN_X (0.005 * X_SCALE)

	class FeedMenu_Slider : w_RscXSliderH
	{
		w = FeedMenu_Slider_W;
		h = FeedMenu_Slider_H;
	};

	#define FeedMenu_Edit_W (0.075 * X_SCALE)
	#define FeedMenu_Edit_H FeedMenu_Slider_H

	class FeedMenu_Edit : RscEdit
	{
		sizeEx = FeedMenu_Options_TEXTSIZE;
		w = FeedMenu_Edit_W;
		h = FeedMenu_Edit_H;
	};


	class Controls
	{
		class FeedMenu_MaxKillsLabel : FeedMenu_Label
		{
			text = "Max kills shown:";

			#define FeedMenu_MaxKillsLabel_X FeedMenu_OptionsL_X
			#define FeedMenu_MaxKillsLabel_Y FeedMenu_Options_Y

			x = FeedMenu_MaxKillsLabel_X;
			y = FeedMenu_MaxKillsLabel_Y;
		};

		class FeedMenu_MaxKillsSlider : FeedMenu_Slider
		{
			idc = A3W_killFeedMenu_MaxKillsSlider_IDC;

			#define FeedMenu_MaxKillsSlider_X (FeedMenu_MaxKillsLabel_X + FeedMenu_Label_W + FeedMenu_Label_MARGIN_X)
			#define FeedMenu_MaxKillsSlider_Y (FeedMenu_MaxKillsLabel_Y + CENTER(FeedMenu_Label_H,FeedMenu_Slider_H))

			x = FeedMenu_MaxKillsSlider_X;
			y = FeedMenu_MaxKillsSlider_Y;
		};

		class FeedMenu_MaxKillsEdit : FeedMenu_Edit
		{
			idc = A3W_killFeedMenu_MaxKillsEdit_IDC;

			#define FeedMenu_MaxKillsEdit_X (FeedMenu_MaxKillsSlider_X + FeedMenu_Slider_W + FeedMenu_Slider_MARGIN_X)
			#define FeedMenu_MaxKillsEdit_Y (FeedMenu_MaxKillsSlider_Y + CENTER(FeedMenu_Slider_H,FeedMenu_Edit_H))

			x = FeedMenu_MaxKillsEdit_X;
			y = FeedMenu_MaxKillsEdit_Y;
		};

		class FeedMenu_FadeTimeLabel : FeedMenu_Label
		{
			text = "Kill fade time:";

			#define FeedMenu_FadeTimeLabel_X FeedMenu_OptionsL_X
			#define FeedMenu_FadeTimeLabel_Y (FeedMenu_MaxKillsLabel_Y + FeedMenu_Label_H + FeedMenu_Option_MARGIN_Y)

			x = FeedMenu_FadeTimeLabel_X;
			y = FeedMenu_FadeTimeLabel_Y;
		};

		class FeedMenu_FadeTimeSlider : FeedMenu_Slider
		{
			idc = A3W_killFeedMenu_FadeTimeSlider_IDC;

			#define FeedMenu_FadeTimeSlider_X (FeedMenu_FadeTimeLabel_X + FeedMenu_Label_W + FeedMenu_Label_MARGIN_X)
			#define FeedMenu_FadeTimeSlider_Y (FeedMenu_FadeTimeLabel_Y + CENTER(FeedMenu_Label_H,FeedMenu_Slider_H))

			x = FeedMenu_FadeTimeSlider_X;
			y = FeedMenu_FadeTimeSlider_Y;
		};

		class FeedMenu_FadeTimeEdit : FeedMenu_Edit
		{
			idc = A3W_killFeedMenu_FadeTimeEdit_IDC;

			#define FeedMenu_FadeTimeEdit_X (FeedMenu_FadeTimeSlider_X + FeedMenu_Slider_W + FeedMenu_Slider_MARGIN_X)
			#define FeedMenu_FadeTimeEdit_Y (FeedMenu_FadeTimeSlider_Y + CENTER(FeedMenu_Slider_H,FeedMenu_Edit_H))

			x = FeedMenu_FadeTimeEdit_X;
			y = FeedMenu_FadeTimeEdit_Y;
		};

		class FeedMenu_FadeTimeSuffix : FeedMenu_Label
		{
			text = "s";
			style = ST_CENTER;

			#define FeedMenu_FadeTimeSuffix_W (0.015 * X_SCALE)
			#define FeedMenu_FadeTimeSuffix_X (FeedMenu_FadeTimeEdit_X + FeedMenu_Edit_W)
			#define FeedMenu_FadeTimeSuffix_Y FeedMenu_FadeTimeLabel_Y

			w = FeedMenu_FadeTimeSuffix_W;
			x = FeedMenu_FadeTimeSuffix_X;
			y = FeedMenu_FadeTimeSuffix_Y;
		};

		class FeedMenu_ShowIconsLabel : FeedMenu_Label
		{
			text = "Show team icons:";

			#define FeedMenu_ShowIconsLabel_X FeedMenu_OptionsL_X
			#define FeedMenu_ShowIconsLabel_Y (FeedMenu_FadeTimeLabel_Y + FeedMenu_Label_H + FeedMenu_Option_MARGIN_Y)

			x = FeedMenu_ShowIconsLabel_X;
			y = FeedMenu_ShowIconsLabel_Y;
		};

		class FeedMenu_ShowIconsCheck : w_RscCheckBox
		{
			idc = A3W_killFeedMenu_ShowIconsCheck_IDC;

			#define FeedMenu_ShowIconsCheck_X (FeedMenu_ShowIconsLabel_X + FeedMenu_Label_W + FeedMenu_Label_MARGIN_X)
			#define FeedMenu_ShowIconsCheck_Y (FeedMenu_ShowIconsLabel_Y + CENTER(FeedMenu_Label_H,FeedMenu_Checkbox_H))

			w = FeedMenu_Checkbox_W;
			h = FeedMenu_Checkbox_H;
			x = FeedMenu_ShowIconsCheck_X;
			y = FeedMenu_ShowIconsCheck_Y;
		};

		class FeedMenu_ShowChatLabel : FeedMenu_Label
		{
			text = "Show kills in chat:";

			#define FeedMenu_ShowChatLabel_X (FeedMenu_ShowIconsCheck_X + FeedMenu_Checkbox_W + (FeedMenu_MARGIN_X * 2)) //FeedMenu_OptionsL_X
			#define FeedMenu_ShowChatLabel_Y FeedMenu_ShowIconsLabel_Y //+ FeedMenu_Label_H + FeedMenu_Option_MARGIN_Y)

			x = FeedMenu_ShowChatLabel_X;
			y = FeedMenu_ShowChatLabel_Y;
		};

		class FeedMenu_ShowChatCheck : w_RscCheckBox
		{
			idc = A3W_killFeedMenu_ShowChatCheck_IDC;

			#define FeedMenu_ShowChatCheck_X (FeedMenu_ShowChatLabel_X + FeedMenu_Label_W + FeedMenu_Label_MARGIN_X)
			#define FeedMenu_ShowChatCheck_Y (FeedMenu_ShowChatLabel_Y + CENTER(FeedMenu_Label_H,FeedMenu_Checkbox_H))

			w = FeedMenu_Checkbox_W;
			h = FeedMenu_Checkbox_H;
			x = FeedMenu_ShowChatCheck_X;
			y = FeedMenu_ShowChatCheck_Y;
		};

		class FeedMenu_OffsetXLabel : FeedMenu_Label
		{
			text = "Feed offset X:";

			#define FeedMenu_OffsetXLabel_X FeedMenu_OptionsR_X
			#define FeedMenu_OffsetXLabel_Y FeedMenu_Options_Y

			x = FeedMenu_OffsetXLabel_X;
			y = FeedMenu_OffsetXLabel_Y;
		};

		class FeedMenu_OffsetXSlider : FeedMenu_Slider
		{
			idc = A3W_killFeedMenu_OffsetXSlider_IDC;

			#define FeedMenu_OffsetXSlider_X (FeedMenu_OffsetXLabel_X + FeedMenu_Label_W + FeedMenu_Label_MARGIN_X)
			#define FeedMenu_OffsetXSlider_Y (FeedMenu_OffsetXLabel_Y + CENTER(FeedMenu_Label_H,FeedMenu_Slider_H))

			x = FeedMenu_OffsetXSlider_X;
			y = FeedMenu_OffsetXSlider_Y;
		};

		class FeedMenu_OffsetXEdit : FeedMenu_Edit
		{
			idc = A3W_killFeedMenu_OffsetXEdit_IDC;

			#define FeedMenu_OffsetXEdit_X (FeedMenu_OffsetXSlider_X + FeedMenu_Slider_W + FeedMenu_Slider_MARGIN_X)
			#define FeedMenu_OffsetXEdit_Y (FeedMenu_OffsetXSlider_Y + CENTER(FeedMenu_Slider_H,FeedMenu_Edit_H))

			x = FeedMenu_OffsetXEdit_X;
			y = FeedMenu_OffsetXEdit_Y;
		};

		class FeedMenu_OffsetYLabel : FeedMenu_Label
		{
			text = "Feed offset Y:";

			#define FeedMenu_OffsetYLabel_X FeedMenu_OptionsR_X
			#define FeedMenu_OffsetYLabel_Y (FeedMenu_OffsetXLabel_Y + FeedMenu_Label_H + FeedMenu_Option_MARGIN_Y)

			x = FeedMenu_OffsetYLabel_X;
			y = FeedMenu_OffsetYLabel_Y;
		};

		class FeedMenu_OffsetYSlider : FeedMenu_Slider
		{
			idc = A3W_killFeedMenu_OffsetYSlider_IDC;

			#define FeedMenu_OffsetYSlider_X (FeedMenu_OffsetYLabel_X + FeedMenu_Label_W + FeedMenu_Label_MARGIN_X)
			#define FeedMenu_OffsetYSlider_Y (FeedMenu_OffsetYLabel_Y + CENTER(FeedMenu_Label_H,FeedMenu_Slider_H))

			x = FeedMenu_OffsetYSlider_X;
			y = FeedMenu_OffsetYSlider_Y;
		};

		class FeedMenu_OffsetYEdit : FeedMenu_Edit
		{
			idc = A3W_killFeedMenu_OffsetYEdit_IDC;

			#define FeedMenu_OffsetYEdit_X (FeedMenu_OffsetYSlider_X + FeedMenu_Slider_W + FeedMenu_Slider_MARGIN_X)
			#define FeedMenu_OffsetYEdit_Y (FeedMenu_OffsetYSlider_Y + CENTER(FeedMenu_Slider_H,FeedMenu_Edit_H))

			x = FeedMenu_OffsetYEdit_X;
			y = FeedMenu_OffsetYEdit_Y;
		};

		class FeedMenu_OpacityLabel : FeedMenu_Label
		{
			text = "Feed opacity:";

			#define FeedMenu_OpacityLabel_X FeedMenu_OptionsR_X
			#define FeedMenu_OpacityLabel_Y (FeedMenu_OffsetYLabel_Y + FeedMenu_Label_H + FeedMenu_Option_MARGIN_Y)

			x = FeedMenu_OpacityLabel_X;
			y = FeedMenu_OpacityLabel_Y;
		};

		class FeedMenu_OpacitySlider : FeedMenu_Slider
		{
			idc = A3W_killFeedMenu_OpacitySlider_IDC;

			#define FeedMenu_OpacitySlider_X (FeedMenu_OpacityLabel_X + FeedMenu_Label_W + FeedMenu_Label_MARGIN_X)
			#define FeedMenu_OpacitySlider_Y (FeedMenu_OpacityLabel_Y + CENTER(FeedMenu_Label_H,FeedMenu_Slider_H))

			x = FeedMenu_OpacitySlider_X;
			y = FeedMenu_OpacitySlider_Y;
		};

		class FeedMenu_OpacityEdit : FeedMenu_Edit
		{
			idc = A3W_killFeedMenu_OpacityEdit_IDC;

			#define FeedMenu_OpacityEdit_X (FeedMenu_OpacitySlider_X + FeedMenu_Slider_W + FeedMenu_Slider_MARGIN_X)
			#define FeedMenu_OpacityEdit_Y (FeedMenu_OpacitySlider_Y + CENTER(FeedMenu_Slider_H,FeedMenu_Edit_H))

			x = FeedMenu_OpacityEdit_X;
			y = FeedMenu_OpacityEdit_Y;
		};

		class FeedMenu_OptionsLine: w_RscPicture
		{
			idc = -1;
			text = "#(argb,8,8,3)color(1,1,1,1)";

			#define FeedMenu_OptionsLine_W FeedMenu_Options_W
			#define FeedMenu_OptionsLine_H (0.002 * SZ_SCALE_ABS) // (0.002 * Y_SCALE)
			#define FeedMenu_OptionsLine_X FeedMenu_OptionsL_X
			#define FeedMenu_OptionsLine_Y (FeedMenu_Options_Y + FeedMenu_Options_H)

			w = FeedMenu_OptionsLine_W;
			h = FeedMenu_OptionsLine_H;
			x = FeedMenu_OptionsLine_X;
			y = FeedMenu_OptionsLine_Y;
		};


		#define FeedMenu_LogList_X (FeedMenu_BG_X + FeedMenu_MARGIN_X)

		class FeedMenu_LogLabel : FeedMenu_Label
		{
			text = "Kill log";
			style = ST_LEFT;

			#define FeedMenu_LogLabel_W (0.075 * X_SCALE)
			#define FeedMenu_LogLabel_X FeedMenu_LogList_X
			#define FeedMenu_LogLabel_Y (FeedMenu_OptionsLine_Y + FeedMenu_OptionsLine_H + FeedMenu_MARGIN_Y)

			w = FeedMenu_LogLabel_W;
			x = FeedMenu_LogLabel_X;
			y = FeedMenu_LogLabel_Y;
		};

		class FeedMenu_LogLimitList : w_RscXListBox
		{
			idc = A3W_killFeedMenu_LogLimitList_IDC;

			#define FeedMenu_LogLimitList_W (0.25 * X_SCALE)
			#define FeedMenu_LogLimitList_H FeedMenu_Slider_H
			#define FeedMenu_LogLimitList_X (FeedMenu_LogLabel_X + FeedMenu_LogLabel_W + FeedMenu_Label_MARGIN_X)
			#define FeedMenu_LogLimitList_Y (FeedMenu_LogLabel_Y + CENTER(FeedMenu_Label_H,FeedMenu_LogLimitList_H))

			w = FeedMenu_LogLimitList_W;
			h = FeedMenu_LogLimitList_H;
			x = FeedMenu_LogLimitList_X;
			y = FeedMenu_LogLimitList_Y;
		};

		#define FeedMenu_BottomButton_W (0.09 * X_SCALE)
		#define FeedMenu_BottomButton_H (0.033 * Y_SCALE)
		#define FeedMenu_BottomButton_Y (FeedMenu_BG_Y + FeedMenu_BG_H - FeedMenu_MARGIN_Y - FeedMenu_BottomButton_H)

		class FeedMenu_Log : w_RscList
		{
			idc = A3W_killFeedMenu_LogList_IDC;
			colorBackground[] = {0, 0, 0, 0.6};

			#define FeedMenu_LogList_W (FeedMenu_BG_W - (FeedMenu_MARGIN_X * 2))
			#define FeedMenu_LogList_Y (FeedMenu_LogLabel_Y + FeedMenu_Label_H + FeedMenu_MARGIN_Y)
			#define FeedMenu_LogList_H (FeedMenu_BottomButton_Y - FeedMenu_MARGIN_Y - FeedMenu_LogList_Y)

			w = FeedMenu_LogList_W;
			h = FeedMenu_LogList_H;
			x = FeedMenu_LogList_X;
			y = FeedMenu_LogList_Y;
		};

		#define FeedMenu_BottomButton_X FeedMenu_LogList_X
		#define FeedMenu_BottomButton_MARGIN_X (0.01 * X_SCALE)

		class FeedMenu_CloseButton : w_RscButton
		{
			idc = 2;
			text = "Close";
			onButtonClick = "closeDialog 0";

			#define FeedMenu_CloseButton_X FeedMenu_BottomButton_X

			w = FeedMenu_BottomButton_W;
			h = FeedMenu_BottomButton_H;
			x = FeedMenu_CloseButton_X;
			y = FeedMenu_BottomButton_Y;
		};

		class FeedMenu_RefreshButton : w_RscButton
		{
			idc = A3W_killFeedMenu_RefreshButton_IDC;
			text = "Refresh";
			onButtonClick = "with missionNamespace do { call A3W_fnc_killFeedMenuRefresh }";

			#define FeedMenu_RefreshButton_X (FeedMenu_CloseButton_X + (FeedMenu_BottomButton_W + FeedMenu_BottomButton_MARGIN_X))

			w = FeedMenu_BottomButton_W;
			h = FeedMenu_BottomButton_H;
			x = FeedMenu_RefreshButton_X;
			y = FeedMenu_BottomButton_Y;
		};

		class FeedMenu_ResetButton : w_RscButton
		{
			idc = A3W_killFeedMenu_ResetButton_IDC;
			text = "Reset";
			onButtonClick = "execVM 'client\systems\killFeed\killFeedMenuReset.sqf'";

			#define FeedMenu_ResetButton_X (FeedMenu_BottomButton_X + FeedMenu_LogList_W - FeedMenu_BottomButton_W)

			w = FeedMenu_BottomButton_W;
			h = FeedMenu_BottomButton_H;
			x = FeedMenu_ResetButton_X;
			y = FeedMenu_BottomButton_Y;
		};
	};
};

