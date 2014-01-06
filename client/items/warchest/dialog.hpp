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
			style = ST_SINGLE + ST_CENTER;
			text = "War Chest"; //--- ToDo: Localize;
			x = 0.3;
			y = 0.25;
			w = 0.4;
			h = 0.05;
			colorBackground[] = {0,0,0,0.7};
		};
		
		class FundsTitle: RscText {
			style = ST_SINGLE + ST_CENTER;
			text = "Team Funds:"; //--- ToDo: Localize;
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
			style = ST_SINGLE + ST_RIGHT;
			text = ""; //--- ToDo: Localize;
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
			idc = -1;
			text = "Withdraw"; //--- ToDo: Localize;
			action = FNC_WITHDRAW;
			x = 0.35;
			y = 0.475;
			w = 0.125;
			h = 0.05;
		};
		class DepositButton: w_RscButton {
			idc = -1;
			text = "Deposit"; //--- ToDo: Localize;
			action = FNC_DEPOSIT;
			x = 0.525;
			y = 0.475;
			w = 0.125;
			h = 0.05;
		};
		class DoneButton: w_RscButton {
			idc = -1;
			text = "Done";
			action = FNC_CLOSE;
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