// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: atm_gui.hpp
//	@file Author: AgentRev

#include "gui_defines.hpp"

class AtmGUI
{
	idd = AtmGUI_IDD;
	movingEnable = true;
	enableSimulation = true;
	controls[] = {AtmBalanceHead, AtmBalanceText, AtmAmountLabel, AtmAmountInput, AtmAccountLabel, AtmAccountDropdown, AtmFeeLabel, AtmFeeText, AtmTotalLabel, AtmTotalText, AtmDepositButton, AtmWithdrawButton, AtmCancelButton};
	controlsBackground[] = {AtmBG, AtmTopBG, AtmTopLogo, AtmBalanceBG};


	#define Atm_TEXT_SIZE (0.04 * TEXT_SCALE)

	class AtmLabelText : w_RscText {
		sizeEx = Atm_TEXT_SIZE;
	};


	class AtmBG : IGUIBack
	{
		idc = -1;
		colorBackground[] = {0, 0, 0, 0.6};

		#define AtmBG_W (0.5 * X_SCALE)
		#define AtmBG_H (0.4 * Y_SCALE)
		#define AtmBG_X (0.5 - (AtmBG_W / 2)) // middle of screen
		#define AtmBG_Y (0.5 - (AtmBG_H / 2)) // middle of screen

		x = AtmBG_X;
		y = AtmBG_Y;
		w = AtmBG_W;
		h = AtmBG_H;
	};

	class AtmTopBG : IGUIBack
	{
		idc = -1;
		colorBackground[] = {A3W_UICOLOR_R, A3W_UICOLOR_G, A3W_UICOLOR_B, 0.8};

		#define AtmTopBG_Y AtmBG_Y
		#define AtmTopBG_H (0.08 * Y_SCALE)

		x = AtmBG_X;
		y = AtmTopBG_Y;
		w = AtmBG_W;
		h = AtmTopBG_H;
	};

	class AtmTopLogo : w_RscPicture
	{
		idc = -1;
		text = "client\icons\suatmm_logo.paa";

		#define AtmTopLogo_W (0.08 * X_SCALE)
		#define AtmTopLogo_H (0.08 * Y_SCALE)
		#define AtmTopLogo_X (AtmBG_X + CENTER(AtmBG_W, AtmTopLogo_W))
		#define AtmTopLogo_Y (AtmTopBG_Y + CENTER(AtmTopBG_H, AtmTopLogo_H))

		x = AtmTopLogo_X;
		y = AtmTopLogo_Y;
		w = AtmTopLogo_W;
		h = AtmTopLogo_H;
	};


	#define Atm_OUTER_MARGIN_X (0.02 * X_SCALE)
	#define Atm_OUTER_MARGIN_Y (0.02 * Y_SCALE)

	#define Atm_INNER_MARGIN_X (0.01 * X_SCALE)
	#define Atm_INNER_MARGIN_Y (0.01 * Y_SCALE)

	#define AtmBalanceBG_W (AtmBG_W - (Atm_OUTER_MARGIN_X * 2))
	#define AtmBalanceBG_X (AtmBG_X + Atm_OUTER_MARGIN_X)
	#define AtmBalanceBG_Y (AtmTopBG_Y + AtmTopBG_H + Atm_OUTER_MARGIN_Y)


	class AtmBalanceHead : w_RscStructuredText
	{
		idc = -1;
		text = "<t underline='true' shadow='0'>Balance</t>";
		size = 0.035 * TEXT_SCALE;

		#define AtmBalanceHead_W AtmBalanceBG_W
		#define AtmBalanceHead_H (0.022 * Y_SCALE)
		#define AtmBalanceHead_X AtmBalanceBG_X
		#define AtmBalanceHead_Y (AtmBalanceBG_Y + (Atm_INNER_MARGIN_Y / 2))

		x = AtmBalanceHead_X;
		y = AtmBalanceHead_Y;
		w = AtmBalanceHead_W;
		h = AtmBalanceHead_H;
	};

	class AtmBalanceText : w_RscStructuredText
	{
		idc = AtmBalanceText_IDC;
		text = "$0";
		size = 0.06 * TEXT_SCALE;

		class Attributes : Attributes {
			color = "#80FF80";
			align = "center";
		};

		#define AtmBalanceText_W AtmBalanceBG_W
		#define AtmBalanceText_H (0.03 * Y_SCALE)
		#define AtmBalanceText_X AtmBalanceBG_X
		#define AtmBalanceText_Y (AtmBalanceHead_Y + AtmBalanceHead_H)

		x = AtmBalanceText_X;
		y = AtmBalanceText_Y;
		w = AtmBalanceText_W;
		h = AtmBalanceText_H;
	};

	class AtmBalanceBG : IGUIBack
	{
		idc = -1;
		colorBackground[] = {0.15, 0.15, 0.15, 0.9};

		#define AtmBalanceBG_H ((AtmBalanceText_Y - AtmBalanceBG_Y) + AtmBalanceText_H + Atm_INNER_MARGIN_Y)

		x = AtmBalanceBG_X;
		y = AtmBalanceBG_Y;
		w = AtmBalanceBG_W;
		h = AtmBalanceBG_H;
	};


	#define AtmLabel_W (0.08 * X_SCALE)
	#define AtmLabel_H (0.02 * Y_SCALE)
	#define AtmLabel_X (AtmBG_X + Atm_OUTER_MARGIN_X)

	#define AtmInput_X (AtmLabel_X + + AtmLabel_W + Atm_INNER_MARGIN_X)
	#define AtmInput_W (AtmBG_W - ((AtmInput_X - AtmLabel_X) + (Atm_OUTER_MARGIN_X * 2)))
	#define AtmInput_H (0.028 * Y_SCALE)
	#define AtmInput_Y_START (AtmBalanceBG_Y + AtmBalanceBG_H + Atm_OUTER_MARGIN_Y)
	#define AtmInput_Y_MARGIN (AtmInput_H + Atm_INNER_MARGIN_Y)

	#define AtmLabel_Y_OFFSET CENTER(AtmInput_H, AtmLabel_H)


	#define AtmAmountInput_Y AtmInput_Y_START

	class AtmAmountLabel : AtmLabelText
	{
		idc = -1;
		text = "Amount:";

		#define AtmAmountLabel_Y (AtmAmountInput_Y + AtmLabel_Y_OFFSET)

		x = AtmLabel_X;
		y = AtmAmountLabel_Y;
		w = AtmLabel_W;
		h = AtmLabel_H;
	};

	class AtmAmountInput : RscEdit
	{
		idc = AtmAmountInput_IDC;
		text = "";
		sizeEx = Atm_TEXT_SIZE;

		x = AtmInput_X;
		y = AtmAmountInput_Y;
		w = AtmInput_W;
		h = AtmInput_H;
	};


	#define AtmAccountDropdown_Y (AtmAmountInput_Y + AtmInput_Y_MARGIN)

	class AtmAccountLabel : AtmLabelText
	{
		idc = -1;
		text = "Account:";

		#define AtmAccountLabel_Y (AtmAccountDropdown_Y + AtmLabel_Y_OFFSET)

		x = AtmLabel_X;
		y = AtmAccountLabel_Y;
		w = AtmLabel_W;
		h = AtmLabel_H;
	};

	class AtmAccountDropdown : RscCombo
	{
		idc = AtmAccountDropdown_IDC;
		sizeEx = Atm_TEXT_SIZE;
		wholeHeight = 0.35 * Y_SCALE;
		colorBackground[] = {0, 0, 0, 0.6};

		x = AtmInput_X;
		y = AtmAccountDropdown_Y;
		w = AtmInput_W;
		h = AtmInput_H;
	};


	#define AtmFeeText_Y (AtmAccountDropdown_Y + AtmInput_Y_MARGIN)

	class AtmFeeLabel : AtmLabelText
	{
		idc = -1;
		text = "Fee:";

		#define AtmFeeLabel_Y (AtmFeeText_Y + AtmLabel_Y_OFFSET)

		x = AtmLabel_X;
		y = AtmFeeLabel_Y;
		w = AtmLabel_W;
		h = AtmLabel_H;
	};

	class AtmFeeText : AtmLabelText
	{
		idc = AtmFeeText_IDC;
		text = "$0";
		colorBackground[] = {0, 0, 0, 0.4};

		x = AtmInput_X;
		y = AtmFeeText_Y;
		w = AtmInput_W;
		h = AtmInput_H;
	};


	#define AtmTotalText_Y (AtmFeeText_Y + AtmInput_Y_MARGIN)

	class AtmTotalLabel : AtmLabelText
	{
		idc = -1;
		text = "Total:";

		#define AtmTotalLabel_Y (AtmTotalText_Y + AtmLabel_Y_OFFSET)

		x = AtmLabel_X;
		y = AtmTotalLabel_Y;
		w = AtmLabel_W;
		h = AtmLabel_H;
	};

	class AtmTotalText : AtmLabelText
	{
		idc = AtmTotalText_IDC;
		text = "$0";
		colorBackground[] = {0, 0, 0, 0.4};

		x = AtmInput_X;
		y = AtmTotalText_Y;
		w = AtmInput_W;
		h = AtmInput_H;
	};


	#define AtmButton_W ((AtmBG_W - ((Atm_OUTER_MARGIN_X * 2) + (Atm_INNER_MARGIN_X * 2))) / 3)
	#define AtmButton_H (0.033 * Y_SCALE)
	#define AtmButton_Y ((AtmBG_Y + AtmBG_H) - (Atm_OUTER_MARGIN_Y + AtmButton_H))

	class AtmButton : w_RscButton
	{
		sizeEx = Atm_TEXT_SIZE;
		y = AtmButton_Y;
		w = AtmButton_W;
		h = AtmButton_H;
	};

	class AtmGreenButton : AtmButton
	{
		colorBackground[] = {0, 0.5, 0, 1}; // normal
		colorFocused[] = {0, 0.3, 0, 1}; // pulse
		colorBackgroundActive[] = {0, 0.6, 0, 1}; // hover
	};


	class AtmDepositButton : AtmGreenButton
	{
		idc = AtmDepositButton_IDC;
		text = "Deposit";
		// action is defined in client\items\atm\select_account.sqf

		#define AtmDepositButton_X (AtmBG_X + Atm_OUTER_MARGIN_X)

		x = AtmDepositButton_X;
	};

	class AtmWithdrawButton : AtmGreenButton
	{
		idc = AtmWithdrawButton_IDC;
		text = "Withdraw";
		action = "call mf_items_atm_withdraw";

		#define AtmWithdrawButton_X (AtmDepositButton_X + AtmButton_W + Atm_INNER_MARGIN_X)

		x = AtmWithdrawButton_X;
	};

	class AtmCancelButton : AtmButton
	{
		idc = AtmCancelButton_IDC;
		text = "Cancel";
		action = "closeDialog 0";

		#define AtmCancelButton_X (AtmWithdrawButton_X + AtmButton_W + Atm_INNER_MARGIN_X)

		x = AtmCancelButton_X;
	};
};
