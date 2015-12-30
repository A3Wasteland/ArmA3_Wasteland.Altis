#include "constants.h"

class cctv_menu {
	idd = bank_dialog_idd;
	movingEnable = true;
	controlsBackground[] = {
		cctv_menu_background
	};

	name = "CCTV_MENU";
	onUnload = "";
	onLoad="uiNamespace setVariable ['CCTV_MENU',_this select 0]";

	objects[] = {};
	controls[] = {
		cctv_menu_header,
		cctv_menu_camera_name_label,
		cctv_menu_camera_name_field,
		cctv_menu_access_control_label,
		cctv_menu_access_control_field,
		cctv_menu_button_ok,
		cctv_menu_button_cancel
	};

	class cctv_menu_header : cctv_ui_RscMenuTitle {
		idc = cctv_menu_header_idc;
		moving = 1;
		x = 0.30-10; y = 0.10-10;
		w = 0.39; h = 0.63;
		text = "Bank Menu";
	};

	class cctv_menu_background: cctv_ui_Rscbackground {
		idc = cctv_menu_background_idc;
		moving = 1;
		x = 0.30-10; y = 0.10-10;
		w = 0.39; h = 0.63;
	};

	//Camera name
	class cctv_menu_camera_name_label : cctv_ui_RscText {
		idc = cctv_menu_camera_name_label_idc;
		x = 0.32-10; y = 0.47-10;
		w = 0.13; h = 0.04;
		text = "";
	};

	class cctv_menu_camera_name_field: cctv_ui_RscEdit {
		idc = cctv_menu_camera_name_field_idc;
		x = 0.49-10; y = 0.47-10;
		w = 0.18; h = 0.04;
		colorBackground[] = FIELD_BACKGROUND;
		text = "0";
	};


	//Access Type
	class cctv_menu_access_control_label : cctv_ui_RscText {
		idc = cctv_menu_access_control_label_idc;
		x = 0.32-10; y = 0.47-10;
		w = 0.13; h = 0.04;
		text = "";
	};

	class cctv_menu_access_control_field : cctv_ui_RscCombo {
		idc = cctv_menu_access_control_field_idc;
		x = 0.32-10; y = 0.14-10;
		w = 0.35; h = 0.30;
		onLBSelChanged = "";
	};

	//Buttons
	class cctv_menu_button_ok : cctv_ui_RscMenuButton {
		idc = cctv_menu_button_ok_idc;
		x = 0.32-10; y = 0.62-10;
		w = 0.35; h = 0.04;
		colorBackgroundDisabled[] = DISABLED_BUTTON_BACKGROUND;
		colorDisabled[] = DISABLED_BUTTON_TEXT;
		font = "PuristaBold";
		text = "";
	};


	class cctv_menu_button_cancel : cctv_ui_RscMenuButton {
		idc = cctv_menu_button_cancel_idc;
		x = 0.75-10; y = 0.67-10;
		w = 0.35; h = 0.04;
		colorBackgroundDisabled[] = DISABLED_BUTTON_BACKGROUND;
		colorDisabled[] = DISABLED_BUTTON_TEXT;
		font = "PuristaBold";
		text = "Close";
		action = "closeDialog 0;";
	};
};