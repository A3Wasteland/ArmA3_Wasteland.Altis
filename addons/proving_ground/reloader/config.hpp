#include "defs_ui.hpp"
#include "defs.hpp"

class balca_loader_main
{
	idd = balca_loader_main_IDD;
	name = "balca_loader_main";
	movingEnable = false;

	controlsBackground[] = {balca_loader_background_veh,balca_loader_background_ammo};
	objects[] = {};
	controls[] =
	{
		balca_loader_vehicle_shortcut,
		balca_loader_vehicle_list_desc,
		balca_loader_turret_list_desc,
		balca_loader_weapon_list_desc,
		balca_loader_vehicle_list,
		balca_loader_turret_list,
		balca_loader_weapon_list,
		balca_loader_capacity,
		balca_loader_default_loadout_desc,
		balca_loader_default_loadout,
		balca_loader_compatible_magazines_desc,
		balca_loader_current_magazines_desc,
		balca_loader_ammo_info_desc,
		balca_loader_compatible_magazines,
		balca_loader_current_magazines,
		balca_loader_ammo_info,
		balca_loader_restore_btn,
		balca_loader_load_btn,
		balca_loader_unload_btn,
		balca_loader_close_btn
	};

//background
	class balca_loader_background_veh
	{
		idc = -1;
		type = CT_STATIC;
		style = ST_PICTURE;
		x = safezoneX_PG; w = display_weight;
		y = safezoneY_PG; h = display_height/2;
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		text = "";
		font = "TahomaB";
		sizeEx = 0.032;
	};

	class balca_loader_background_ammo
	{
		idc = -1;
		type = CT_STATIC;
		style = ST_PICTURE;
		x = safezoneX_PG; w = display_weight;
		y = display_height/2+border_offsetY; h = display_height/2;
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		text = "";
		font = "TahomaB";
		sizeEx = 0.032;
	};
//abstract classes

	class balca_loader_text
	{
		idc = -1;
		type = CT_STATIC;
		style = ST_LEFT;
		x = 0.0; w = 0.3;
		y = 0.0; h = 0.03;
		sizeEx = 0.023;
		colorBackground[] = {0.5, 0.5, 0.5, 0};
		colorText[] = {0.85, 0.85, 0.85, 1};
		font = "TahomaB";
		text = "";
	};

	class balca_loader_image
	{
		idc = -1;
		type = CT_STATIC;
		style = ST_PICTURE;
		x = 0.25; w = 0.1;
		y = 0.1; h = 0.1;
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		text = "";
		font = "TahomaB";
		sizeEx = 0.032;
	};

	class balca_loader_btn
	{
		idc = -1;
		type = 16;
		style = 0;

		text = "btn";
		action = "";

		x = 0;
		y = 0;

		w = 0.23;
		h = 0.11;

		size = 0.03921;
		sizeEx = 0.03921;

		color[] = {0.543, 0.5742, 0.4102, 1.0};
		color2[] = {0.95, 0.95, 0.95, 1};
		colorBackground[] = {1, 1, 1, 1};
		colorbackground2[] = {1, 1, 1, 0.4};
		colorDisabled[] = {1, 1, 1, 0.25};
		periodFocus = 1.2;
		periodOver = 0.8;

		class HitZone
		{
			left = 0.004;
			top = 0.029;
			right = 0.004;
			bottom = 0.029;
		};

		class ShortcutPos
		{
			left = 0.0145;
			top = 0.026;
			w = 0.0392157;
			h = 0.0522876;
		};

		class TextPos
		{
			left = 0.05;
			top = 0.034;
			right = 0.005;
			bottom = 0.005;
		};

		textureNoShortcut = "";
		animTextureNormal = "\ca\ui\data\ui_button_normal_ca.paa";
		animTextureDisabled = "\ca\ui\data\ui_button_disabled_ca.paa";
		animTextureOver = "\ca\ui\data\ui_button_over_ca.paa";
		animTextureFocused = "\ca\ui\data\ui_button_focus_ca.paa";
		animTexturePressed = "\ca\ui\data\ui_button_down_ca.paa";
		animTextureDefault = "\ca\ui\data\ui_button_default_ca.paa";
		period = 0.4;
		font = "TahomaB";

		soundEnter[] = {"\ca\ui\data\sound\mouse2", 0.09, 1};
		soundPush[] = {"\ca\ui\data\sound\new1", 0.09, 1};
		soundClick[] = {"\ca\ui\data\sound\mouse3", 0.07, 1};
		soundEscape[] = {"\ca\ui\data\sound\mouse1", 0.09, 1};

		class Attributes
		{
			font = "TahomaB";
			color = "#E5E5E5";
			align = "left";
			shadow = "true";
		};

		class AttributesImage
		{
			font = "TahomaB";
			color = "#E5E5E5";
			align = "left";
			shadow = "true";
		};
	};

	class balca_loader_list
	{
		type = CT_LISTBOX;
		style = ST_LEFT;
		idc = -1;
		text = "";
		w = 0.275;
		h = 0.04;
		colorSelect[] = {1, 1, 1, 1};
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0.8,0.8,0.8,1};
		colorSelectBackground[] = {0.40, 0.43, 0.28, 0.5};
		colorScrollbar[] = {0.2, 0.2, 0.2, 1};
		arrowEmpty = "\ca\ui\data\ui_arrow_combo_ca.paa";
		arrowFull = "\ca\ui\data\ui_arrow_combo_active_ca.paa";
		wholeHeight = 0.45;
		rowHeight = 0.04;
		color[] = {0.30, 0.32, 0.21, 1};
		colorActive[] = {0,0,0,1};
		colorDisabled[] = {0,0,0,0.3};
		font = "TahomaB";
		sizeEx = 0.023;
		soundSelect[] = {"",0.1,1};
		soundExpand[] = {"",0.1,1};
		soundCollapse[] = {"",0.1,1};
		maxHistoryDelay = 1;
		autoScrollSpeed = -1;
		autoScrollDelay = 5;
		autoScrollRewind = 0;

		class ListScrollBar
		{
			color[] = {0.30, 0.32, 0.21, 0.6};
			colorActive[] = {0.30, 0.32, 0.21, 1};
			colorDisabled[] = {0.30, 0.32, 0.21, 0.3};
			thumb = "\ca\ui\data\ui_scrollbar_thumb_ca.paa";
			arrowFull = "\ca\ui\data\ui_arrow_top_active_ca.paa";
			arrowEmpty = "\ca\ui\data\ui_arrow_top_ca.paa";
			border = "\ca\ui\data\ui_border_scroll_ca.paa";
		};
	};

	class balca_loader_pict
	{
		idc = -1;
		type = CT_STATIC;
		style = ST_PICTURE;
		x = 0.25; w = 0.5;
		y = 0.1; h = 0.8;
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		text = "";
		font = "TahomaB";
		sizeEx = 0.032;
	};

//controls

	class balca_loader_vehicle_list_desc : balca_loader_text
	{
		x = safezoneX_PG + border_offsetX + column_weight;
		w = column_weight - border_offsetX;
		y = safezoneY_PG + border_offsetY;
		h = str_height;
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		text = "Vehicles";
	};

	class balca_loader_turret_list_desc : balca_loader_text
	{
		x = safezoneX_PG + border_offsetX + column_weight*2;
		w = column_weight - border_offsetX;
		y = safezoneY_PG + border_offsetY;
		h = str_height;
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		text = "Turrets";
	};

	class balca_loader_weapon_list_desc : balca_loader_text
	{
		x = safezoneX_PG + border_offsetX + column_weight*3;
		w = column_weight - border_offsetX;
		y = safezoneY_PG + border_offsetY;
		h = str_height;
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		text = "Weapons";
	};

	class balca_loader_capacity : balca_loader_text
	{
		idc = balca_loader_capacity_IDC;
		x = safezoneX_PG + border_offsetX + column_weight*3;
		w = column_weight - border_offsetX;
		y = display_height/2 - str_height;
		h = str_height;
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		text = "Capacity";
	};

	class balca_loader_default_loadout_desc : balca_loader_text
	{
		x = safezoneX_PG + border_offsetX;
		w = column_weight - border_offsetX;
		y = display_height/2 + border_offsetY*2;
		h = str_height;
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		text = "Default loadout";
	};


	class balca_loader_compatible_magazines_desc : balca_loader_text
	{
		x = safezoneX_PG + border_offsetX + column_weight*1;
		w = column_weight - border_offsetX;
		y = display_height/2 + border_offsetY*2;
		h = str_height;
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		text = "Compatible magazines";
	};

	class balca_loader_current_magazines_desc : balca_loader_text
	{
		x = safezoneX_PG + border_offsetX + column_weight*2;
		w = column_weight - border_offsetX;
		y = display_height/2 + border_offsetY*2;
		h = str_height;
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		text = "Current magazines";
	};

	class balca_loader_ammo_info_desc : balca_loader_text
	{
		x = safezoneX_PG + border_offsetX + column_weight*3;
		w = column_weight - border_offsetX;
		y = display_height/2 + border_offsetY*2;
		h = str_height;
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		text = "Ammo info";
	};

	class balca_loader_ammo_info : balca_loader_text
	{
		idc = balca_loader_ammo_info_IDC;
		type = CT_STRUCTURED_TEXT;
		size = 0.023;
		x = safezoneX_PG + border_offsetX + column_weight*3;
		w = column_weight - border_offsetX;
		y = display_height/2 + border_offsetY*2 + offset_top;
		h = display_height/2 - offset_bottom - (safezoneY_PG + border_offsetY + offset_top);
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		text = "";
	};
////////
	class balca_loader_vehicle_shortcut : balca_loader_image
	{
		idc = balca_loader_vehicle_shortcut_IDC;
		x = safezoneX_PG + border_offsetX;
		w = column_weight - border_offsetX;
		y = safezoneY_PG + border_offsetY + offset_top;
		h = img_height;
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		text = "\ca\ui\data\ui_action_getingunner_ca.paa";
	};
////////
	class balca_loader_vehicle_list : balca_loader_list
	{
		idc = balca_loader_vehicle_list_IDC;
		x = safezoneX_PG + border_offsetX + column_weight*1;
		w = column_weight - column_div;
		y = safezoneY_PG + border_offsetY + offset_top;
		h = display_height/2 - offset_bottom - (safezoneY_PG + border_offsetY + offset_top);
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		onLBSelChanged= "[_this] call c_proving_ground_reloader_fnc_fill_turret_list;";
		onLBDblClick = "[_this] call c_proving_ground_reloader_fnc_fill_turret_list;";
	};

	class balca_loader_turret_list : balca_loader_list
	{
		idc = balca_loader_turret_list_IDC;
		x = safezoneX_PG + border_offsetX + column_weight*2;
		w = column_weight - column_div;
		y = safezoneY_PG + border_offsetY + offset_top;
		h = display_height/2 - offset_bottom - (safezoneY_PG + border_offsetY + offset_top);
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		onLBSelChanged= "[_this] call c_proving_ground_reloader_fnc_fill_weapon_list;";
		onLBDblClick = "[_this] call c_proving_ground_reloader_fnc_fill_weapon_list;";
	};

	class balca_loader_weapon_list : balca_loader_list
	{
		idc = balca_loader_weapon_list_IDC;
		x = safezoneX_PG + border_offsetX + column_weight*3;
		w = column_weight - column_div;
		y = safezoneY_PG + border_offsetY + offset_top;
		h = display_height/2 - offset_bottom - (safezoneY_PG + border_offsetY + offset_top);
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		onLBSelChanged= "[_this] call c_proving_ground_reloader_fnc_fill_compatible_magazines_list;[_this] call c_proving_ground_reloader_fnc_fill_current_magazines_list;";
		onLBDblClick = "[_this] call c_proving_ground_reloader_fnc_fill_compatible_magazines_list;[_this] call c_proving_ground_reloader_fnc_fill_current_magazines_list;";
	};

	class balca_loader_default_loadout : balca_loader_list
	{
		idc = balca_loader_default_loadout_IDC;
		x = safezoneX_PG + border_offsetX;
		w = column_weight - column_div;
		y = display_height/2 + border_offsetY*2 + offset_top;
		h = display_height/2 - offset_bottom - (safezoneY_PG + border_offsetY + offset_top);
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		onLBSelChanged= "[_this] call c_proving_ground_reloader_fnc_ammo_info;";
	};

	class balca_loader_compatible_magazines : balca_loader_list
	{
		idc = balca_loader_compatible_magazines_IDC;
		x = safezoneX_PG + border_offsetX + column_weight*1;
		w = column_weight - column_div;
		y = display_height/2 + border_offsetY*2 + offset_top;
		h = display_height/2 - offset_bottom - (safezoneY_PG + border_offsetY + offset_top);
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		onLBSelChanged= "[_this] call c_proving_ground_reloader_fnc_ammo_info;";
		onLBDblClick = "[_this] call c_proving_ground_reloader_fnc_add_magazine;";
	};

	class balca_loader_current_magazines : balca_loader_list
	{
		idc = balca_loader_current_magazines_IDC;
		x = safezoneX_PG + border_offsetX + column_weight*2;
		w = column_weight - column_div;
		y = display_height/2 + border_offsetY*2 + offset_top;
		h = display_height/2 - offset_bottom - (safezoneY_PG + border_offsetY + offset_top);
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		onLBSelChanged= "[_this] call c_proving_ground_reloader_fnc_ammo_info;";
		onLBDblClick = "[_this] call c_proving_ground_reloader_fnc_remove_magazine;";
	};
////////
	class balca_loader_restore_btn : balca_loader_btn
	{
		idc = balca_loader_restore_btn_IDC;
		x = safezoneX_PG + border_offsetX; w = 0.16;
		y = display_height - 0.16;
		text = "Restore";
		action = "call c_proving_ground_reloader_fnc_restore_loadout;";
	};

	class balca_loader_load_btn : balca_loader_btn
	{
		idc = balca_loader_load_btn_IDC;
		x = safezoneX_PG + border_offsetX + column_weight*1; w = 0.16;
		y = display_height - 0.16;
		text = "Load";
		action = "call c_proving_ground_reloader_fnc_add_magazine;";
	};

	class balca_loader_unload_btn : balca_loader_btn
	{
		idc = balca_loader_unload_btn_IDC;
		x = safezoneX_PG + border_offsetX + column_weight*2; w = 0.16;
		y = display_height - 0.16;
		text = "Unload";
		action = "call c_proving_ground_reloader_fnc_remove_magazine";
	};

	class balca_loader_close_btn : balca_loader_btn
	{
		x = safezoneX_PG + border_offsetX + column_weight*3; w = 0.16;
		y = display_height - 0.16;
		text = "Close";
		action = "closeDialog 0;";
	};
};


