#include "constants.h"

class bank_menu {
	idd = bank_dialog_idd;
	movingEnable = true;
	controlsBackground[] = {
		bank_menu_background
	};

	name = "BANK_MENU";
	onUnload = "";
	onLoad="uiNamespace setVariable ['BANK_MENU',_this select 0]";

	objects[] = {};
	controls[] = {
		bank_menu_header,
		bank_menu_balance_label,
		bank_menu_balance_field,
		bank_menu_balance_cash_label,
		bank_menu_balance_cash_field,
		bank_menu_amount_label,
		bank_menu_amount_field,
		bank_menu_destination_label,
		bank_menu_destination_field,
		bank_menu_transaction_fee_label,
		bank_menu_transaction_fee_field,
		bank_menu_button_deposit,
		bank_menu_button_withdraw,
		bank_menu_button_close
	};

	class bank_menu_header : ui_RscMenuTitle {
		idc = bank_menu_header_idc;
		moving = 1;
		x = 0.30-10; y = 0.10-10;
		w = 0.39; h = 0.63;
		text = "Bank Menu";
	};

	class bank_menu_background: ui_Rscbackground {
		idc = bank_menu_background_idc;
		moving = 1;
		x = 0.30-10; y = 0.10-10;
		w = 0.39; h = 0.63;
	};

	//Bank(atm) balance
	class bank_menu_balance_label : ui_RscText {
		idc = bank_menu_balance_label_idc;
		x = 0.32-10; y = 0.47-10;
		w = 0.13; h = 0.04;
		text = "";
	};

	class bank_menu_balance_field: ui_RscText {
		idc = bank_menu_balance_field_idc;
		x = 0.49-10; y = 0.47-10;
		w = 0.18; h = 0.04;
		colorBackground[] = FIELD_BACKGROUND;
		text = "0";
	};

	//Cash(inventory) balance
	class bank_menu_balance_cash_label : ui_RscText {
		idc = bank_menu_balance_cash_label_idc;
		x = 0.32-10; y = 0.47-10;
		w = 0.13; h = 0.04;
		text = "";
	};

	class bank_menu_balance_cash_field: ui_RscText {
		idc = bank_menu_balance_cash_field_idc;
		x = 0.49-10; y = 0.47-10;
		w = 0.18; h = 0.04;
		colorBackground[] = FIELD_BACKGROUND;
		text = "0";
	};

	//Transaction amount
	class bank_menu_amount_label : ui_RscText {
		idc = bank_menu_amount_label_idc;
		x = 0.32-10; y = 0.47-10;
		w = 0.13; h = 0.04;
		text = "";
	};

	class bank_menu_amount_field: ui_RscEdit {
		idc = bank_menu_amount_field_idc;
		x = 0.49-10; y = 0.47-10;
		w = 0.18; h = 0.04;
		colorBackground[] = FIELD_BACKGROUND;
		text = "0";
	};

	//Transaction fee
	class bank_menu_transaction_fee_label : ui_RscText {
		idc = bank_menu_transaction_fee_label_idc;
		x = 0.32-10; y = 0.47-10;
		w = 0.13; h = 0.04;
		text = "";
	};

	class bank_menu_transaction_fee_field: ui_RscText {
		idc = bank_menu_transaction_fee_field_idc;
		x = 0.49-10; y = 0.47-10;
		w = 0.18; h = 0.04;
		colorBackground[] = FIELD_BACKGROUND;
		text = "0";
	};

	//Destination
	class bank_menu_destination_label : ui_RscText {
		idc = bank_menu_destination_label_idc;
		x = 0.32-10; y = 0.47-10;
		w = 0.13; h = 0.04;
		text = "";
	};

	class bank_menu_destination_field : ui_RscCombo {
		idc = bank_menu_destination_field_idc;
		x = 0.32-10; y = 0.14-10;
		w = 0.35; h = 0.30;
		onLBSelChanged = "";
	};

	//Buttons
	class bank_menu_button_deposit : ui_RscMenuButton {
		idc = bank_menu_button_deposit_idc;
		x = 0.32-10; y = 0.62-10;
		w = 0.35; h = 0.04;
		colorBackgroundDisabled[] = DISABLED_BUTTON_BACKGROUND;
		colorDisabled[] = DISABLED_BUTTON_TEXT;
		text = "";
	};

	class bank_menu_button_withdraw : ui_RscMenuButton {
		idc = bank_menu_button_withdraw_idc;
		x = 0.32-10; y = 0.67-10;
		w = 0.35; h = 0.04;
		colorBackgroundDisabled[] = DISABLED_BUTTON_BACKGROUND;
		colorDisabled[] = DISABLED_BUTTON_TEXT;
		text = "";
	};

	class bank_menu_button_close : ui_RscMenuButton {
		idc = bank_menu_button_close_idc;
		x = 0.75-10; y = 0.67-10;
		w = 0.35; h = 0.04;
		colorBackgroundDisabled[] = DISABLED_BUTTON_BACKGROUND;
		colorDisabled[] = DISABLED_BUTTON_TEXT;
		text = "Close";
		action = "closeDialog 0;";
	};
};