// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Brett, v1.062, #Comaxy)
////////////////////////////////////////////////////////
#include "defines.sqf"
class WarchestDialog {
	idd = IDD_WARCHEST;
	class controlsBackground  {
		class WarchestBackground: IGUIBack {
			x = 0.3;
			y = 0.25;
			w = 0.4;
			h = 0.3;
		};
		class WarchestTitle: RscText {
			idc = IDC_MENUTITLE;
			style = ST_CENTER;
			text = "Warchest";
			x = 0.3;
			y = 0.25;
			w = 0.4;
			h = 0.05;
			colorBackground[] = {0,0,0,0.7};
		};

		class FundsTitle: RscText {
			idc = IDC_FUNDSTITLE;
			style = ST_LEFT;
			text = "Balance:";
			x = 0.35;
			y = 0.325;
			w = 0.15;
			h = 0.05;
			colorBackground[] = {0,0,0,0.7};
		};

		class AmountBackground: IGUIBack {
			x = 0.35;
			y = 0.4;
			w = 0.3;
			h = 0.05;
			colorBackground[] = {0,0,0,0.7};
		};

		class Decoration1: IGUIBack {
			x = 0.3;
			y = 0.56;
			w = 0.29;
			h = 0.04;
			colorBackground[] = {0,0,0,0.7};
		};
	};
	class controls {
		class Funds: RscText {
			idc = IDC_FUNDS;
			style = ST_RIGHT;
			text = "";
			x = 0.5;
			y = 0.325;
			w = 0.15;
			h = 0.05;
			colorBackground[] = {0,0,0,0.7};
		};
		class Amount: RscEdit {
			idc = IDC_AMOUNT;
			text = "";
			x = 0.35;
			y = 0.4;
			w = 0.3;
			h = 0.05;
			colorText[] = {1,1,1,1};
			colorBackground[] = {0,0,0,0.7};
		};
		class WithdrawButton: w_RscButton {
			idc = IDC_WITHDRAWBUTTON;
			text = "Withdraw";
			action = "call mf_items_warchest_withdraw";
			x = 0.35;
			y = 0.475;
			w = 0.125;
			h = 0.05;
		};
		class DepositButton: w_RscButton {
			idc = IDC_DEPOSITBUTTON;
			text = "Deposit";
			action = "call mf_items_warchest_deposit";
			x = 0.525;
			y = 0.475;
			w = 0.125;
			h = 0.05;
		};
		class DoneButton: w_RscButton {
			idc = -1;
			text = "Done";
			action = "closeDialog 0";
			x = 0.60;
			y = 0.56;
			w = 0.1;
			h = 0.04;
		};
	};
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
