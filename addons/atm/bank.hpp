class ATM_management {
	idd = 2700;
	name= "atm_menu";
	movingEnable = false;
	enableSimulation = true;
	
	class controlsBackground {
		class ATM_RscTitleBackground:ATM_RscText {
			colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
			idc = -1;
			x = 0.35;
			y = 0.2;
			w = 0.3;
			h = (1 / 25);
		};
		
		class MainBackground:ATM_RscText {
			colorBackground[] = {0, 0, 0, 0.7};
			idc = -1;
			x = 0.35;
			y = 0.2 + (11 / 250);
			w = 0.3;
			h = 0.6 - (22 / 250);
		};
	};
	
	class controls {

		class CashTitle : ATM_RscStructuredText
		{
			idc = 2701;
			text = "";
			
			x = 0.39;
			y = 0.26;
			w = 0.3;
			h = 0.14;
		};
		
		class moneyEdit : ATM_RscEdit {
		
		idc = 2702;
		
		text = "0";
		sizeEx = 0.030;
		x = 0.4; y = 0.41;
		w = 0.2; h = 0.03;
		
		};
		
		class Title : ATM_RscTitle {
			colorBackground[] = {0, 0, 0, 0};
			idc = -1;
			text = "$STR_ATM_Title";
			x = 0.35;
			y = 0.2;
			w = 0.6;
			h = (1 / 25);
		};
		
		class WithdrawButton : ATM_RscButtonMenu 
		{
			idc = -1;
			text = "$STR_ATM_Withdraw";
			colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
			onButtonClick = "_nil=[]execVM ""addons\atm\withdraw.sqf""";
			
			x = 0.432;
			y = 0.46;
			w = (6 / 40);
			h = (1 / 25);
		};
		
		class DepositButton : ATM_RscButtonMenu 
		{
			idc = -1;
			text = "$STR_ATM_Deposit";
			colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
			onButtonClick = "_nil=[]execVM ""addons\atm\deposit.sqf""";
			
			x = 0.432;
			y = 0.512;
			w = (6 / 40);
			h = (1 / 25);
		};
		
		class PlayerList : ATM_RscCombo 
		{
			idc = 2703;
			
			x = 0.4; y = 0.58;
			w = 0.2; h = 0.03;
		};
		
		class TransferButton : ATM_RscButtonMenu 
		{
			idc = -1;
			text = "$STR_ATM_Transfer";
			colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
			onButtonClick = "_nil=[]execVM ""addons\atm\transfer.sqf""";
			
			x = 0.432;
			y = 0.63;
			w = (5.30 / 40);
			h = (1 / 25);
		};
		
		class CloseButtonKey : ATM_RscButtonMenu {
			idc = -1;
			text = "$STR_ATM_Close";
			onButtonClick = "closeDialog 0;";
			x = 0.35;
			y = 0.8 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};
	};
};