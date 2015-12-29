#include "defs_ui.hpp"
#include "defs.hpp"

class balca_debug_main
{
	idd = balca_debug_main_IDD;
	name = "balca_debug_main";
	movingEnable = false;

	controlsBackground[] = {};
	objects[] = {};
	controls[] = {
				balca_btn_control_group
				};
/////////////
#include "defs_base_control.hpp"
/////////////

	class balca_btn_control_group : balca_debug_control_group {
		x = safezoneX_PG;
		w = 1;
		y = safezoneY_PG;
		h = 1;

		class Controls {
		//column 1
			class balca_cVeh_btn : balca_debug_btn
			{
				x = 0; w = column_weight-column_div;
				y = 0;
				text = "Create vehicle";
				action = "if (isServer) then { closeDialog 0; createDialog ""balca_debug_veh_creator""; [0] call c_proving_ground_fnc_create_vehicle } else { closeDialog 0; createDialog ""balca_debug_veh_creator""; [0] call c_proving_ground_fnc_create_vehicle; ['You may get kicked if BattlEye is monitoring createVehicle.','WARNING'] spawn BIS_fnc_guiMessage }";
			};

			class balca_cWeap_btn : balca_debug_btn
			{
				x = 0; w = column_weight-column_div;
				y = btn_height*1;
				text = "Get weapon";
				action = "closeDialog 0;createDialog ""balca_debug_weap_creator"";[0,0] call c_proving_ground_fnc_create_weapon;";
			};

			class balca_targets_btn : balca_debug_btn
			{
				x = 0; w = column_weight-column_div;
				y = btn_height*2;
				text = "Targets";
				action = "closeDialog 0;if ((serverCommandAvailable '#kick')||isServer) then {createDialog ""balca_target_display"";[0] call c_proving_ground_fnc_target;[1] call c_proving_ground_fnc_target;}else{hint 'Target management not allowed for you'}";
			};

			class balca_environment_btn : balca_debug_btn
			{
				x = 0; w = column_weight-column_div;
				y = btn_height*3;
				text = "Environment";
				action = "closeDialog 0;createDialog ""balca_environment"";[0] call c_proving_ground_fnc_environment";
			};

			class balca_stat_btn : balca_debug_btn
			{
				x = 0; w = column_weight-column_div;
				y = btn_height*4;
				text = "Statistics";
				action = "closeDialog 0;createDialog ""balca_statistics"";[0] call c_proving_ground_fnc_statistics";
			};

			class balca_realign_core_btn : balca_debug_btn
			{
				x = 0; w = column_weight-column_div;
				y = btn_height*6;
				text = "Realign core";
				action = "closeDialog 0;_core = c_proving_ground_core;_dir = direction player;_pos = getPos player;_core setPos [(_pos select 0)+10*sin(_dir),(_pos select 1)+10*cos(_dir),0];_core setDir _dir;_marker = createMarkerLocal ['respawn_west',_pos];createMarkerLocal ['respawn_east',_pos];createMarkerLocal ['respawn_guerrila',_pos];createMarkerLocal ['respawn_civilian',_pos];closeDialog 0;";
			};

			/*class balca_get_bot_btn : balca_debug_btn
			{
				x = 0; w = column_weight-column_div;
				y = btn_height*7;
				text = "Get bot in team";
				action = "((group player) createUnit [typeOf player,getpos player,[],0.1,""FORM""]) setSkill 1";
			};*/

			class balca_dVeh_btn : balca_debug_btn
			{
				x = 0; w = column_weight-column_div;
				y = btn_height*8;
				text = "Delete vehicle";
				action = "deleteVehicle cursorTarget;";
			};


		//column 2
			class balca_ammo_btn : balca_debug_btn
			{
				x = column_weight; w = column_weight-column_div;
				y = btn_height*0;
				text = "Ammo";
				action = "[] call c_proving_ground_fnc_ammo";
			};

			class balca_repair_btn : balca_debug_btn
			{
				x = column_weight; w = column_weight-column_div;
				y = btn_height*1;
				text = "Autoheal";
				action = "player setDamage 0; (vehicle player) setDamage 0;";
			};

			class balca_booster_btn : balca_debug_btn
			{
				x = column_weight; w = column_weight-column_div;
				y = btn_height*2;
				text = "Booster";
				action = "[] spawn c_proving_ground_fnc_booster;closeDialog 0;";
			};

			class balca_teleport_btn : balca_debug_btn
			{
				x = column_weight; w = column_weight-column_div;
				y = btn_height*3;
				text = "Teleport";
				action = "hint ""Click on map to teleport"";onMapSingleClick ""vehicle player setPos [_pos select 0,_pos select 1,0]; onMapSingleClick '';""; openMap true; closeDialog 0;";
			};

			class balca_sattelite_btn : balca_debug_btn
			{
				x = column_weight; w = column_weight-column_div;
				y = btn_height*4;
				text = "Sattelite";
				action = "hint ""Click on map to aim sattelite"";onMapSingleClick ""[_pos] call c_proving_ground_fnc_sattelite;onMapSingleClick '';""; openMap true; closeDialog 0;";
			};

			class balca_bulletcam_btn : balca_debug_btn
			{
				x = column_weight; w = column_weight-column_div;
				y = btn_height*5;
				text = "Bulletcam";
				action = """bulletcam"" call c_proving_ground_fnc_bulletcam;";
			};

			class balca_marker_btn : balca_debug_btn
			{
				x = column_weight; w = column_weight-column_div;
				y = btn_height*6;
				text = "Hitmarker";
				action = """hitmarker"" call c_proving_ground_fnc_bulletcam;";
			};

			/*class balca_status_btn : balca_debug_btn
			{
				x = column_weight; w = column_weight-column_div;
				y = btn_height*7;
				text = "Status display";
				action = "closeDialog 0;call c_proving_ground_fnc_status";
			};*/

			class balca_console_btn : balca_debug_btn
			{
				x = column_weight; w = column_weight-column_div;
				y = btn_height*8;
				text = "Console";
				action = "closeDialog 0;createDialog ""balca_debug_console"";[0] call c_proving_ground_fnc_exec_console; if (!isServer) then { ['Some commands can get you kicked by BattlEye.','WARNING'] spawn BIS_fnc_guiMessage }";
			};
		//column 3
			class balca_sound_btn : balca_debug_btn
			{
				x = column_weight*2; w = column_weight-column_div;
				y = btn_height*0;
				text = "Sound player";
				action = "closeDialog 0;createDialog ""balca_sound_player"";[0] call c_proving_ground_fnc_sound;";
			};

			class balca_display_btn : balca_debug_btn
			{
				x = column_weight*2; w = column_weight-column_div;
				y = btn_height*1;
				text = "BalCa";
				action = "execVM ""\x\addons\balca\balca.sqf"";closeDialog 0;";
			};

			class balca_reload_btn : balca_debug_btn
			{
				x = column_weight*2; w = column_weight-column_div;
				y = btn_height*2;
				text = "Reloader";
				action = "closeDialog 0;(vehicle player) spawn c_proving_ground_reloader_fnc_act_open_dialog;";
			};

			class balca_cfgexplorer_btn : balca_debug_btn
			{
				x = column_weight*2; w = column_weight-column_div;
				y = btn_height*3;
				text = "cfgExplorer";
				action = "closeDialog 0;createDialog ""HJ_ConfigExplorer"";[] call c_proving_ground_HJ_fnc_InitDialog;";
			};

			class balca_BIS_help_btn : balca_debug_btn
			{
				x = column_weight*2; w = column_weight-column_div;
				y = btn_height*4;
				text = "BIS Functions Viewer";
				action = "closeDialog 0;[] call BIS_fnc_help";
			};

			class balca_BIS_cfgviewer_btn : balca_debug_btn
			{
				x = column_weight*2; w = column_weight-column_div;
				y = btn_height*5;
				text = "BIS Config Viewer";
				action = "closeDialog 0;[] call BIS_fnc_configviewer";
			};
			class balca_close_btn : balca_debug_btn
			{
				x = column_weight*2; w = column_weight-column_div;
				y = btn_height*8;
				text = "Close";
				action = "closeDialog 0;";
			};
		};
	};//end btn control group
__onLoad

};

class balca_debug_veh_creator
{
	idd = balca_debug_VC_IDD;
	name = "balca_debug_veh_creator";
	movingEnable = false;

	controlsBackground[] = {balca_debug_background};
	objects[] = {};
	controls[] = {
				balca_VC_vehlist,
				balca_VC_vehicle_shortcut,
				balca_VC_veh_info,
				balca_VC_fill_static,
				balca_VC_fill_car,
				balca_VC_fill_truck,
				balca_VC_fill_APC,
				balca_VC_fill_tank,
				balca_VC_fill_helicopter,
				balca_VC_fill_plane,
				balca_VC_fill_ship,
				balca_VC_class_to_clipboard_btn,
				balca_VC_info_to_clipboard_btn,
				//balca_VC_create_veh_core_btn,
				balca_VC_create_veh_player_btn,
				balca_VC_close_btn
				};
/////////////////
	class balca_debug_background
	{
		idc = -1;
		type = CT_STATIC;
		style = ST_PICTURE;
		x = safezoneX_PG-border_offsetX; w = column_weight*3 + border_offsetX*3;
		y = safezoneY_PG-border_offsetY-btn_height*3; h = display_height+border_offsetY*2+btn_height*4;
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		text = "";
		font = "PuristaMedium";
		sizeEx = 0.032;
	};


/////////////
#include "defs_base_control.hpp"
/////////////

	class balca_VC_vehlist : balca_debug_list
	{
		idc = balca_VC_vehlist_IDC;
		x = safezoneX_PG;
		w = column_weight - column_div;
		y = safezoneY_PG + offset_top*2;
		h = display_height - offset_bottom*4 - (safezoneY_PG + offset_top*2);
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		onLBSelChanged= "[1] call c_proving_ground_fnc_create_vehicle";
		onLBDblClick = "[2] call c_proving_ground_fnc_create_vehicle";
	};

	class balca_VC_vehicle_shortcut : balca_debug_image
	{
		idc = balca_VC_vehicle_shortcut_IDC;
		x = safezoneX_PG + column_weight;
		w = column_weight - column_div;
		y = safezoneY_PG + offset_top*2;
		h = img_height;
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		text = "";
	};

	class balca_VC_veh_info : balca_debug_text
	{
		idc = balca_VC_veh_info_IDC;
		type = CT_STRUCTURED_TEXT+ST_LEFT;
		size = 0.023;
		x = safezoneX_PG + column_weight*2;
		w = column_weight - column_div;
		y = safezoneY_PG + offset_top*2;
		h = display_height - offset_bottom*3-(safezoneY_PG + offset_top*2);
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		text = "";
	};

	class balca_VC_fill_static : balca_debug_btn
	{
		x = safezoneX_PG + border_offsetX + btn_weight*0; w = btn_weight-column_div;
		y = safezoneY_PG - btn_height;
		text = "Static";
		action = "[0,0] call c_proving_ground_fnc_create_vehicle";
	};

	class balca_VC_fill_car : balca_debug_btn
	{
		x = safezoneX_PG + border_offsetX + btn_weight*0; w = btn_weight-column_div;
		y = safezoneY_PG;
		text = "Car";
		action = "[0,1] call c_proving_ground_fnc_create_vehicle";
	};

	class balca_VC_fill_truck : balca_debug_btn
	{
		x = safezoneX_PG + border_offsetX + btn_weight*1; w = btn_weight-column_div;
		y = safezoneY_PG - btn_height;
		text = "Truck";
		action = "[0,2] call c_proving_ground_fnc_create_vehicle";
	};

	class balca_VC_fill_APC : balca_debug_btn
	{
		x = safezoneX_PG + border_offsetX + btn_weight*1; w = btn_weight-column_div;
		y = safezoneY_PG;
		text = "APC";
		action = "[0,3] call c_proving_ground_fnc_create_vehicle";
	};

	class balca_VC_fill_tank : balca_debug_btn
	{
		x = safezoneX_PG + border_offsetX + btn_weight*2; w = btn_weight-column_div;
		y = safezoneY_PG - btn_height;
		text = "Tank";
		action = "[0,4] call c_proving_ground_fnc_create_vehicle";
	};

	class balca_VC_fill_helicopter : balca_debug_btn
	{
		x = safezoneX_PG + border_offsetX + btn_weight*2; w = btn_weight-column_div;
		y = safezoneY_PG;
		text = "Helicopter";
		action = "[0,5] call c_proving_ground_fnc_create_vehicle";
	};

	class balca_VC_fill_plane : balca_debug_btn
	{
		x = safezoneX_PG + border_offsetX + btn_weight*3; w = btn_weight-column_div;
		y = safezoneY_PG - btn_height;
		text = "Plane";
		action = "[0,6] call c_proving_ground_fnc_create_vehicle";
	};

	class balca_VC_fill_ship : balca_debug_btn
	{
		x = safezoneX_PG + border_offsetX + btn_weight*3; w = btn_weight-column_div;
		y = safezoneY_PG;
		text = "Ship";
		action = "[0,7] call c_proving_ground_fnc_create_vehicle";
	};

	class balca_VC_class_to_clipboard_btn : balca_debug_btn
	{
		x = safezoneX_PG; w = column_weight-column_div;
		y = display_height-safezoneY_PG- offset_bottom-btn_height;
		text = "Class to clipboard";
		action = "[4] call c_proving_ground_fnc_create_vehicle";
	};

	class balca_VC_info_to_clipboard_btn : balca_debug_btn
	{
		x = safezoneX_PG+column_weight*2; w = column_weight-column_div;
		y = display_height-safezoneY_PG- offset_bottom-btn_height;
		text = "Info to clipboard";
		action = "[5] call c_proving_ground_fnc_create_vehicle";
	};

	/*class balca_VC_create_veh_core_btn : balca_debug_btn
	{
		x = safezoneX_PG+column_weight; w = column_weight-column_div;
		y = safezoneY_PG + offset_top*2+img_height;
		text = "Create at core";
		action = "[2] call c_proving_ground_fnc_create_vehicle";
	};*/

	class balca_VC_create_veh_player_btn : balca_debug_btn
	{
		x = safezoneX_PG+column_weight; w = column_weight-column_div;
		y = safezoneY_PG + offset_top*2+img_height + btn_height;
		text = "Create at player";
		action = "[3] call c_proving_ground_fnc_create_vehicle";
	};

	class balca_VC_close_btn : balca_debug_btn
	{
		x = safezoneX_PG+column_weight*2; w = btn_weight;
		y = display_height-safezoneY_PG- offset_bottom;
		text = "Back";
		action = "closeDialog 0; createDialog 'balca_debug_main'";
	};
};

class balca_debug_weap_creator
{
	idd = balca_debug_WC_IDD;
	name = "balca_debug_weap_creator";
	movingEnable = false;

	controlsBackground[] = {balca_debug_background};
	objects[] = {};
	controls[] = {
				balca_WC_weaplist,
				balca_WC_magazinelist,
				balca_WC_weapon_shortcut,
				balca_WC_weap_info,
				balca_WC_magazine_info,
				balca_WC_fill_rifles,
				balca_WC_fill_scoped_rifles,
				balca_WC_fill_heavy,
				balca_WC_fill_launchers,
				balca_WC_fill_pistols,
				balca_WC_fill_grenades,
				balca_WC_fill_binocular,
				balca_WC_fill_items,
				balca_WC_weap_to_clipboard_btn,
				balca_WC_ammo_to_clipboard_btn,
				balca_WC_create_weap_btn,
				balca_WC_create_magazine_btn,
				balca_WC_clear_magazines_btn,
				balca_WC_close_btn
				};
/////////////////
	class balca_debug_background
	{
		idc = -1;
		type = CT_STATIC;
		style = ST_PICTURE;
		x = safezoneX_PG-border_offsetX; w = column_weight*3 + border_offsetX*3;
		y = safezoneY_PG-border_offsetY-btn_height*3; h = display_height+border_offsetY*2+btn_height*4;
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		text = "";
		font = "PuristaMedium";
		sizeEx = 0.032;
	};


/////////////
#include "defs_base_control.hpp"
/////////////

	class balca_WC_weaplist : balca_debug_list
	{
		idc = balca_WC_weaplist_IDC;
		x = safezoneX_PG;
		w = column_weight - column_div;
		y = safezoneY_PG + offset_top*2;
		h = display_height - offset_bottom*4 - (safezoneY_PG + offset_top*2);
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		onLBSelChanged= "[1] call c_proving_ground_fnc_create_weapon;";
		onLBDblClick = "[2] call c_proving_ground_fnc_create_weapon;";
	};

	class balca_WC_magazinelist : balca_debug_list
	{
		idc = balca_WC_magazinelist_IDC;
		x = safezoneX_PG + column_weight;
		w = column_weight - column_div;
		y = safezoneY_PG + offset_top*2 + img_height_wc;
		h = display_height - offset_bottom*4 - img_height_wc-(safezoneY_PG + offset_top*2);
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		onLBSelChanged= "[3] call c_proving_ground_fnc_create_weapon;";
		onLBDblClick = "[4] call c_proving_ground_fnc_create_weapon;";
	};

	class balca_WC_weapon_shortcut : balca_debug_image
	{
		idc = balca_WC_weapon_shortcut_IDC;
		x = safezoneX_PG + column_weight;
		w = column_weight - column_div;
		y = safezoneY_PG + offset_top*2;
		h = img_height_wc;
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		text = "";
	};

	class balca_WC_weap_info : balca_debug_text
	{
		idc = balca_WC_weap_info_IDC;
		type = CT_STRUCTURED_TEXT+ST_LEFT;
		size = 0.023;
		x = safezoneX_PG + column_weight*2;
		w = column_weight - column_div;
		y = safezoneY_PG + offset_top*2;
		h = img_height_wc;
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		text = "";
	};

	class balca_WC_magazine_info : balca_debug_text
	{
		idc = balca_WC_magazine_info_IDC;
		type = CT_STRUCTURED_TEXT;
		size = 0.023;
		x = safezoneX_PG + column_weight*2;
		w = column_weight - column_div;
		y = safezoneY_PG + offset_top*2 + img_height_wc;
		h = display_height - offset_bottom*4 - img_height_wc-(safezoneY_PG + offset_top*2);
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		text = "";
	};

	class balca_WC_fill_rifles : balca_debug_btn
	{
		x = safezoneX_PG + border_offsetX + btn_weight*0; w = btn_weight-column_div;
		y = safezoneY_PG - btn_height;
		text = "Rifles";
		action = "[0,0] call c_proving_ground_fnc_create_weapon;";
	};

	class balca_WC_fill_scoped_rifles : balca_debug_btn
	{
		x = safezoneX_PG + border_offsetX + btn_weight*0; w = btn_weight-column_div;
		y = safezoneY_PG;
		text = "Scoped";
		action = "[0,1] call c_proving_ground_fnc_create_weapon;";
	};

	class balca_WC_fill_heavy : balca_debug_btn
	{
		x = safezoneX_PG + border_offsetX + btn_weight*1; w = btn_weight-column_div;
		y = safezoneY_PG - btn_height;
		text = "Heavy";
		action = "[0,2] call c_proving_ground_fnc_create_weapon;";
	};

	class balca_WC_fill_launchers : balca_debug_btn
	{
		x = safezoneX_PG + border_offsetX + btn_weight*1; w = btn_weight-column_div;
		y = safezoneY_PG;
		text = "Launchers ";
		action = "[0,3] call c_proving_ground_fnc_create_weapon;";
	};

	class balca_WC_fill_pistols : balca_debug_btn
	{
		x = safezoneX_PG + border_offsetX + btn_weight*2; w = btn_weight-column_div;
		y = safezoneY_PG - btn_height;
		text = "Pistols";
		action = "[0,4] call c_proving_ground_fnc_create_weapon;";
	};

	class balca_WC_fill_grenades : balca_debug_btn
	{
		x = safezoneX_PG + border_offsetX + btn_weight*2; w = btn_weight-column_div;
		y = safezoneY_PG;
		text = "Grenades";
		action = "[0,5] call c_proving_ground_fnc_create_weapon;";
	};

	class balca_WC_fill_binocular : balca_debug_btn
	{
		x = safezoneX_PG + border_offsetX + btn_weight*3; w = btn_weight-column_div;
		y = safezoneY_PG - btn_height;
		text = "Binoculars";
		action = "[0,6] call c_proving_ground_fnc_create_weapon;";
	};

	class balca_WC_fill_items : balca_debug_btn
	{
		x = safezoneX_PG + border_offsetX + btn_weight*3; w = btn_weight-column_div;
		y = safezoneY_PG;
		text = "Items";
		action = "[0,7] call c_proving_ground_fnc_create_weapon;";
	};

	class balca_WC_weap_to_clipboard_btn : balca_debug_btn
	{
		x = safezoneX_PG; w = column_weight-column_div;
		y = display_height-safezoneY_PG- offset_bottom-btn_height;
		text = "Class to clipboard";
		action = "[5] call c_proving_ground_fnc_create_weapon;";
	};

	class balca_WC_ammo_to_clipboard_btn : balca_debug_btn
	{
		x = safezoneX_PG+column_weight; w = column_weight-column_div;
		y = display_height-safezoneY_PG- offset_bottom-btn_height;
		text = "Ammo to clipboard";
		action = "[6] call c_proving_ground_fnc_create_weapon;";
	};

	class balca_WC_create_weap_btn : balca_debug_btn
	{
		x = safezoneX_PG; w = column_weight-column_div;
		y = display_height-safezoneY_PG- offset_bottom;
		text = "Get weapon";
		action = "[2] call c_proving_ground_fnc_create_weapon;";
	};

	class balca_WC_create_magazine_btn : balca_debug_btn
	{
		x = safezoneX_PG+column_weight; w = column_weight-column_div;
		y = display_height-safezoneY_PG- offset_bottom;
		text = "Get magazine";
		action = "[4] call c_proving_ground_fnc_create_weapon;";
	};

	class balca_WC_clear_magazines_btn : balca_debug_btn
	{
		x = safezoneX_PG+column_weight*2; w = column_weight-column_div;
		y = display_height-safezoneY_PG-offset_bottom-btn_height;
		text = "Clear magazines";
		action = "c_proving_ground_MAGS = [];{player removeMagazine _x} forEach (magazines player);";
	};

	class balca_WC_close_btn : balca_debug_btn
	{
		x = safezoneX_PG+column_weight*2; w = btn_weight;
		y = display_height-safezoneY_PG- offset_bottom;
		text = "Close";
		action = "closeDialog 0;";
	};
};

class balca_debug_console
{
	idd = balca_debug_console_IDD;
	name = "balca_debug_console";
	movingEnable = false;

	controlsBackground[] = {balca_debug_background};
	objects[] = {};
	controls[] = {
				balca_debug_console_edit,
				balca_debug_console_result,
				balca_debug_console_history,
				balca_debug_console_control_group,
				};

	onKeyDown = "if((_this select 1) in [28,156]) then {[1] call c_proving_ground_fnc_exec_console;}; false";
/////////////////
	class balca_debug_background
	{
		idc = -1;
		type = CT_STATIC;
		style = ST_PICTURE;
		x = safezoneX_PG-border_offsetX; w = column_weight*3 + border_offsetX*4;
		y = safezoneY_PG-border_offsetY; h = display_height+border_offsetY*2;
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		text = "";
		font = "PuristaMedium";
		sizeEx = 0.032;
	};


/////////////
#include "defs_base_control.hpp"
/////////////

	class balca_debug_console_edit : balca_debug_edit
	{
		idc = balca_debug_console_edit_IDC;
		x = safezoneX_PG; w = column_weight*3;
		y = safezoneY_PG + offset_top*2; h = str_height*3;
		text = "enter command here";
	};

	class balca_debug_console_result : balca_debug_edit
	{
		idc = balca_debug_console_result_IDC;
		x = safezoneX_PG;
		w = column_weight*3;
		y = safezoneY_PG + offset_top*2 + str_height*3;
		h = str_height*2;
		text = "";
	};

	class balca_debug_console_history : balca_debug_list
	{
		idc = balca_debug_console_history_IDC;
		x = safezoneX_PG;
		w = column_weight*3;
		y = safezoneY_PG + offset_top*2 + str_height*5;
		h = display_height - offset_bottom*4 - str_height*5 - (safezoneY_PG + offset_top*2);
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		onLBSelChanged= "[2] call c_proving_ground_fnc_exec_console;";
		onLBDblClick = "[3] call c_proving_ground_fnc_exec_console;";
	};

	class balca_debug_console_control_group : balca_debug_control_group {
		x = safezoneX_PG;
		w = 1;
		y = display_height-safezoneY_PG- offset_bottom-btn_height;
		h = str_height*4;
		class Controls {
			class balca_debug_console_exec_btn : balca_debug_btn
			{
				x = 0; w = column_weight-column_div;
				y = 0;
				text = "Execute";
				action = "[1] call c_proving_ground_fnc_exec_console;";
			};

			class balca_debug_console_exec_global_btn : balca_debug_btn
			{
				x = column_weight; w = column_weight-column_div;
				y = 0;
				text = "Exec global";
				action = "[4] call c_proving_ground_fnc_exec_console;";
			};

			class balca_debug_console_exec_server_btn : balca_debug_btn
			{
				x = column_weight*2; w = column_weight-column_div;
				y = 0;
				text = "Exec on server";
				action = "[5] call c_proving_ground_fnc_exec_console;";
			};

			class balca_debug_console_run_tracker_btn : balca_debug_btn
			{
				x = column_weight*0; w = column_weight-column_div;
				y = btn_height;
				text = "Run tracker";
				action = "[6] call c_proving_ground_fnc_exec_console;";
			};

			class balca_debug_console_stop_tracker_btn : balca_debug_btn
			{
				x = column_weight*1; w = column_weight-column_div;
				y = btn_height;
				text = "Stop tracker";
				action = "[7] call c_proving_ground_fnc_exec_console;";
			};

			class balca_debug_console_close_btn : balca_debug_btn
			{
				x = column_weight*2; w = btn_weight;
				y = btn_height;
				text = "Back";
				action = "closeDialog 0; createDialog 'balca_debug_main'";
			};
		};
	};
};

class balca_target_display
{
	idd = balca_target_display_IDD;
	name = "balca_target_display";
	movingEnable = false;

	controlsBackground[] = {balca_debug_background};
	objects[] = {};
	controls[] = {
				balca_target_vehlist,
				balca_target_vehicle_shortcut,
				balca_target_veh_info,
				balca_target_map,
				balca_target_type_control_group,
				balca_target_management_control_group,
				balca_target_close_btn
				};
/////////////////
	class balca_debug_background
	{
		idc = -1;
		type = CT_STATIC;
		style = ST_PICTURE;
		x = safezoneX_PG-border_offsetX; w = column_weight*3 + border_offsetX*3;
		y = safezoneY_PG-border_offsetY-btn_height*3; h = display_height+border_offsetY*2+btn_height*4;
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		text = "";
		font = "PuristaMedium";
		sizeEx = 0.032;
	};


/////////////
#include "defs_base_control.hpp"
/////////////

	onUnload = "[10] call c_proving_ground_fnc_target;";

	class balca_target_vehlist : balca_debug_list
	{
		idc = balca_target_vehlist_IDC;
		x = safezoneX_PG;
		w = column_weight - column_div;
		y = safezoneY_PG + offset_top*2;
		h = display_height - offset_bottom*4 - (safezoneY_PG + offset_top*2);
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		onLBSelChanged= "[2] call c_proving_ground_fnc_target;";
		onLBDblClick = "[3] call c_proving_ground_fnc_target;";
	};

	class balca_target_vehicle_shortcut : balca_debug_image
	{
		idc = balca_target_vehicle_shortcut_IDC;
		x = safezoneX_PG + column_weight;
		w = column_weight - column_div;
		y = safezoneY_PG + offset_top*2;
		h = img_height;
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		text = "";
	};

	class balca_target_veh_info : balca_debug_text
	{
		idc = balca_target_veh_info_IDC;
		type = CT_STRUCTURED_TEXT+ST_LEFT;
		size = 0.023;
		x = safezoneX_PG + column_weight;
		w = column_weight - column_div;
		y = safezoneY_PG + offset_top*2 + img_height;
		h = display_height - offset_bottom*3 - img_height-(safezoneY_PG + offset_top*2);
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		text = "";
	};

	class balca_target_map : balca_debug_map
	{
		idc = balca_target_map_IDC;
		x = safezoneX_PG;
		w = column_weight*2 - column_div;
		y = safezoneY_PG + offset_top*2;
		h = display_height - offset_bottom*4 - (safezoneY_PG + offset_top*2);
		onMouseButtonDblClick = "[9,((_this select 0) ctrlMapScreenToWorld [_this select 2,_this select 3])] call c_proving_ground_fnc_target";
	};

	class balca_target_type_control_group : balca_debug_control_group {
		x = safezoneX_PG + border_offsetX + btn_weight*0;
		w = 1;
		y = safezoneY_PG - btn_height;
		h = str_height*4;

		class Controls {
			class balca_target_fill_man : balca_debug_btn
			{
				x = 0; w = btn_weight-column_div;
				y = 0;
				text = "Man";
				action = "[1,0] call c_proving_ground_fnc_target;";
			};

			class balca_target_fill_car : balca_debug_btn
			{
				x = 0; w = btn_weight-column_div;
				y = btn_height;
				text = "Car";
				action = "[1,1] call c_proving_ground_fnc_target;";
			};

			class balca_target_fill_truck : balca_debug_btn
			{
				x = btn_weight*1; w = btn_weight-column_div;
				y = 0;
				text = "Truck";
				action = "[1,2] call c_proving_ground_fnc_target;";
			};

			class balca_target_fill_APC : balca_debug_btn
			{
				x = btn_weight*1; w = btn_weight-column_div;
				y = btn_height;
				text = "APC";
				action = "[1,3] call c_proving_ground_fnc_target;";
			};

			class balca_target_fill_tank : balca_debug_btn
			{
				x = btn_weight*2; w = btn_weight-column_div;
				y = 0;
				text = "Tank";
				action = "[1,4] call c_proving_ground_fnc_target;";
			};

			class balca_target_fill_helicopter : balca_debug_btn
			{
				x = btn_weight*2; w = btn_weight-column_div;
				y = btn_height;
				text = "Helicopter";
				action = "[1,5] call c_proving_ground_fnc_target;";
			};

			class balca_target_fill_plane : balca_debug_btn
			{
				x = btn_weight*3; w = btn_weight-column_div;
				y = 0;
				text = "Plane";
				action = "[1,6] call c_proving_ground_fnc_target;";
			};

			class balca_target_fill_ship : balca_debug_btn
			{
				x = btn_weight*3; w = btn_weight-column_div;
				y = btn_height;
				text = "Ship";
				action = "[1,7] call c_proving_ground_fnc_target;";
			};
		};
	};//end control group

	class balca_target_management_control_group : balca_debug_control_group {
		x = safezoneX_PG+column_weight*2;
		w = 1;
		y = safezoneY_PG + offset_top*2;
		h = display_height - offset_bottom*4 - (safezoneY_PG + offset_top*2);

		class Controls {
			class balca_target_mode_desc : balca_debug_text
			{
				x = 0;
				w = column_weight/2-column_div;
				y = 0;
				h = str_height;
				text = "Mode";
			};

			class balca_target_mode_combo : balca_debug_combo
			{
				idc = balca_target_mode_IDC;
				x = 0;
				w = column_weight-column_div*3;
				y = btn_height;
				onLBSelChanged = "c_proving_ground_target_mode = (_this select 1);[0,(_this select 1)] call c_proving_ground_fnc_target;";
			};

			class balca_target_mode_land_static : balca_debug_control_group {
				idc = balca_target_land_static_IDC;
				x = 0;
				w = 1;
				y = btn_height*2;
				h = btn_height*5;
				class Controls {
					class balca_target_distance_desc : balca_debug_text
					{
						x = 0;
						w = column_weight/2-column_div;
						y = btn_height*0;
						h = str_height;
						text = "Distance";
					};

					class balca_target_direction_desc : balca_debug_text
					{
						x = 0;
						w = column_weight/2-column_div;
						y = btn_height*1;
						h = str_height;
						text = "Direction";
					};

					class balca_target_speed_desc : balca_debug_text
					{
						x = 0;
						w = column_weight/2-column_div;
						y = btn_height*2;
						h = str_height;
						text = "Speed";
					};

					class balca_target_distance : balca_debug_edit
					{
						idc = balca_target_distance_IDC;
						x = column_weight*0.5;
						w = column_weight/2-column_div;
						y = btn_height*0;
						h = str_height;
						text = "--";
					};

					class balca_target_direction : balca_debug_edit
					{
						idc = balca_target_direction_IDC;
						x = column_weight*0.5;
						w = column_weight/2-column_div;
						y = btn_height*1;
						h = str_height;
						text = "--";
					};

					class balca_target_speed : balca_debug_edit
					{
						idc = balca_target_speed_IDC;
						x = column_weight*0.5;
						w = column_weight/2-column_div;
						y = btn_height*2;
						h = str_height;
						text = "--";
					};
				};//end contols
			};//end balca_target_mode_static_land

			class balca_target_mode_land_random : balca_debug_control_group {
				idc = balca_target_land_random_IDC;
				x = 0;
				w = 1;
				y = btn_height*2;
				h = btn_height*5;
				class Controls {
					class balca_target_distance_desc : balca_debug_text
					{
						x = 0;
						w = 2*column_weight/3;
						y = btn_height*0;
						h = str_height;
						text = "Distance            +/-";
					};

					class balca_target_direction_desc : balca_debug_text
					{
						x = 0;
						w = 2*column_weight/3;
						y = btn_height*1;
						h = str_height;
						text = "Direction           +/-";
					};

					class balca_target_speed_desc : balca_debug_text
					{
						x = 0;
						w = column_weight/3-column_div;
						y = btn_height*2;
						h = str_height;
						text = "Speed";
					};

					class balca_target_rdistance : balca_debug_edit
					{
						idc = balca_target_rdistance_IDC;
						x = column_weight/3;
						w = column_weight/3-column_div*3;
						y = btn_height*0;
						h = str_height;
						text = "--";
					};

					class balca_target_distance_rand : balca_debug_edit
					{
						idc = balca_target_distance_rand_IDC;
						x = 2*column_weight/3;
						w = column_weight/3-column_div*3;
						y = btn_height*0;
						h = str_height;
						text = "--";
					};

					class balca_target_rdirection : balca_debug_edit
					{
						idc = balca_target_rdirection_IDC;
						x = column_weight/3;
						w = column_weight/3-column_div*3;
						y = btn_height*1;
						h = str_height;
						text = "--";
					};

					class balca_target_direction_rand : balca_debug_edit
					{
						idc = balca_target_direction_rand_IDC;
						x = 2*column_weight/3;
						w = column_weight/3-column_div*3;
						y = btn_height*1;
						h = str_height;
						text = "--";
					};

					class balca_target_speed_rand : balca_debug_edit
					{
						idc = balca_target_speed_rand_IDC;
						x = column_weight*0.5;
						w = column_weight/2-column_div*3;
						y = btn_height*2;
						h = str_height;
						text = "--";
					};
				};//end contols
			};//end balca_target_mode_land_random

			class balca_target_mode_land_AI : balca_debug_control_group {
				idc = balca_target_land_AI_IDC;
				x = 0;
				w = 1;
				y = btn_height*2;
				h = btn_height*5;
				class Controls {
					class balca_target_distance_desc : balca_debug_text
					{
						x = 0;
						w = column_weight/2-column_div;
						y = btn_height*0;
						h = str_height;
						text = "Distance";
					};

					class balca_target_distance : balca_debug_edit
					{
						idc = balca_target_land_AI_dist_IDC;
						x = column_weight*0.5;
						w = column_weight/2-column_div;
						y = btn_height*0;
						h = str_height;
						text = "--";
					};

					class balca_target_show_map_btn : balca_debug_btn
					{
						x = 0;
						w = column_weight-column_div;
						y = btn_height*1;
						text = "Toggle map";
						action = "[7] call c_proving_ground_fnc_target;";
					};
/*
					class balca_target_adjust_way_btn : balca_debug_btn
					{
						x = 0;
						w = column_weight-column_div;
						y = btn_height*2;
						text = "Adjust waypoints";
						action = "[10] call c_proving_ground_fnc_target;";
					};
*/
					class balca_target_clear_way_btn : balca_debug_btn
					{
						x = 0;
						w = column_weight-column_div;
						y = btn_height*3;
						text = "Clear waypoints";
						action = "[8] call c_proving_ground_fnc_target;";
					};

				};//end contols
			};//end balca_target_mode_land_AI

			class balca_target_mode_air_AI : balca_debug_control_group {
				idc = balca_target_air_AI_IDC;
				x = 0;
				w = 1;
				y = btn_height*2;
				h = btn_height*5;
				class Controls {
					class balca_target_distance_desc : balca_debug_text
					{
						x = 0;
						w = column_weight/2-column_div;
						y = btn_height*0;
						h = str_height;
						text = "Distance";
					};

					class balca_target_distance : balca_debug_edit
					{
						idc = balca_target_air_AI_dist_IDC;
						x = column_weight*0.5;
						w = column_weight/2-column_div;
						y = btn_height*0;
						h = str_height;
						text = "--";
					};


					class balca_target_show_map_btn : balca_debug_btn
					{
						x = 0;
						w = column_weight-column_div;
						y = btn_height*1;
						text = "Toggle map";
						action = "[7] call c_proving_ground_fnc_target;";
					};
/*
					class balca_target_adjust_way_btn : balca_debug_btn
					{
						x = 0;
						w = column_weight-column_div;
						y = btn_height*2;
						text = "Adjust waypoints";
						action = "[10] call c_proving_ground_fnc_target;";
					};
*/
					class balca_target_clear_way_btn : balca_debug_btn
					{
						x = 0;
						w = column_weight-column_div;
						y = btn_height*3;
						text = "Clear waypoints";
						action = "[8] call c_proving_ground_fnc_target;";
					};
				};//end contols
			};//end balca_target_mode_air_AI

			class balca_target_apply_btn : balca_debug_btn
			{
				x = 0;
				w = column_weight-column_div;
				y = btn_height*7;
				text = "Apply";
				action = "[6] call c_proving_ground_fnc_target;";
			};

			class balca_target_reset_btn : balca_debug_btn
			{
				x = 0;
				w = column_weight-column_div;
				y = btn_height*8;
				text = "Reset";
				action = "c_proving_ground_target_props = [100,0,(getDir c_proving_ground_core)+180]];[0] call c_proving_ground_fnc_target;[6] call c_proving_ground_fnc_target;";
			};

			class balca_target_create_btn : balca_debug_btn
			{
				x = 0;
				w = column_weight-column_div;
				y = btn_height*9;
				text = "Add target";
				action = "[3] call c_proving_ground_fnc_target;";
			};

			class balca_target_clear_btn : balca_debug_btn
			{
				x = 0;
				w = column_weight-column_div;
				y = btn_height*10;
				text = "Clear targets";
				action = "[5] call c_proving_ground_fnc_target;";
			};
		};
	};//end management control group

	class balca_target_close_btn : balca_debug_btn
	{
		x = safezoneX_PG + btn_weight*3; w = btn_weight;
		y = display_height-safezoneY_PG- offset_bottom;
		text = "Close";
		action = "closeDialog 0;";
	};
};

class balca_sound_player
{
	idd = balca_sound_player_IDD;
	name = "balca_sound_player";
	movingEnable = false;

	controlsBackground[] = {balca_debug_background};
	objects[] = {};
	controls[] = {
				balca_soundlist,
				balca_clipboard_btn,
				balca_close_btn
				};
/////////////////
	class balca_debug_background
	{
		idc = -1;
		type = CT_STATIC;
		style = ST_PICTURE;
		x = safezoneX_PG-border_offsetX; w = column_weight*3 + border_offsetX*3;
		y = safezoneY_PG-border_offsetY; h = display_height+border_offsetY*2+btn_height*1;
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		text = "";
		font = "PuristaMedium";
		sizeEx = 0.032;
	};


/////////////
#include "defs_base_control.hpp"
/////////////

	class balca_soundlist : balca_debug_list
	{
		idc = balca_soundlist_IDC;
		x = safezoneX_PG;
		w = column_weight*3 - column_div;
		y = safezoneY_PG + offset_top*2;
		h = display_height - offset_bottom*4 - (safezoneY_PG + offset_top*2);
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		onLBSelChanged= "";
		onLBDblClick = "[1] call c_proving_ground_fnc_sound;";
	};

	class balca_clipboard_btn : balca_debug_btn
	{
		x = safezoneX_PG; w = column_weight-column_div;
		y = display_height-safezoneY_PG- offset_bottom;
		text = "to Clipboard";
		action = "[2] call c_proving_ground_fnc_sound;";
	};

	class balca_close_btn : balca_debug_btn
	{
		x = safezoneX_PG + column_weight*2; w = btn_weight;
		y = display_height-safezoneY_PG- offset_bottom;
		text = "Close";
		action = "closeDialog 0;";
	};
};

class balca_statistics
{
	idd = balca_stat_display_IDD;
	name = "balca_statistics";
	movingEnable = false;

	controlsBackground[] = {balca_debug_background};
	objects[] = {};
	controls[] = {
				balca_stat_text,
				balca_reset_btn,
				balca_clipboard_btn,
				balca_close_btn
				};
/////////////////
	class balca_debug_background
	{
		idc = -1;
		type = CT_STATIC;
		style = ST_PICTURE;
		x = safezoneX_PG-border_offsetX; w = column_weight*3 + border_offsetX*3;
		y = safezoneY_PG-border_offsetY; h = display_height+border_offsetY*2+btn_height*1;
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		text = "";
		font = "PuristaMedium";
		sizeEx = 0.032;
	};


/////////////
#include "defs_base_control.hpp"
/////////////

	class balca_stat_text : balca_debug_text
	{
		idc = balca_stat_text_IDC;
		type = CT_STRUCTURED_TEXT+ST_LEFT;
		size = 0.023;
		x = safezoneX_PG;
		w = column_weight - column_div;
		y = safezoneY_PG + offset_top*2;
		h = display_height - offset_bottom*3 -(safezoneY_PG + offset_top*2);
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		text = "";
	};

	class balca_reset_btn : balca_debug_btn
	{
		x = safezoneX_PG; w = column_weight-column_div;
		y = display_height-safezoneY_PG- offset_bottom;
		text = "Reset";
		action = "[1] call c_proving_ground_fnc_statistics;";
	};

	class balca_clipboard_btn : balca_debug_btn
	{
		x = safezoneX_PG + column_weight; w = column_weight-column_div;
		y = display_height-safezoneY_PG- offset_bottom;
		text = "to Clipboard";
		action = "[2] call c_proving_ground_fnc_statistics;";
	};

	class balca_close_btn : balca_debug_btn
	{
		x = safezoneX_PG + column_weight*2; w = btn_weight;
		y = display_height-safezoneY_PG- offset_bottom;
		text = "Close";
		action = "closeDialog 0;";
	};
};

class balca_environment
{
	idd = balca_environment_IDD;
	name = "balca_environment";
	movingEnable = false;

	controlsBackground[] = {balca_debug_background};
	objects[] = {};
	controls[] = {
				balca_env_control_group,
				balca_apply_btn
				};
/////////////////
	class balca_debug_background
	{
		idc = -1;
		type = CT_STATIC;
		style = ST_PICTURE;
		x = safezoneX_PG-border_offsetX; w = column_weight*1 + border_offsetX*3;
		y = safezoneY_PG-border_offsetY; h = display_height+border_offsetY*2+btn_height*1;
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		text = "";
		font = "PuristaMedium";
		sizeEx = 0.032;
	};


/////////////
#include "defs_base_control.hpp"
/////////////

	class balca_env_control_group : balca_debug_control_group {
		x = safezoneX_PG+column_weight*0;
		w = 1;
		y = safezoneY_PG + offset_top*2;
		h = display_height - offset_bottom*4 - (safezoneY_PG + offset_top*2);

		class Controls {

			class balca_env_VD_desc : balca_debug_text
			{
				x = 0;
				w = column_weight/2-column_div;
				y = btn_height*1;
				h = str_height;
				text = "Viewdistance";
			};

			class balca_env_VD : balca_debug_edit
			{
				idc = balca_env_VD_IDC;
				x = column_weight*0.5;
				w = column_weight/2-column_div;
				y = btn_height*1;
				h = str_height;
				text = "--";
			};

			class balca_env_grass_desc : balca_debug_text
			{
				x = 0;
				w = column_weight/2-column_div;
				y = btn_height*2;
				h = str_height;
				text = "Grass";
			};

			class balca_env_grass : balca_debug_edit
			{
				idc = balca_env_grass_IDC;
				x = column_weight*0.5;
				w = column_weight/2-column_div;
				y = btn_height*2;
				h = str_height;
				text = "--";
			};

			class balca_env_fog_desc : balca_debug_text
			{
				x = 0;
				w = column_weight/2-column_div;
				y = btn_height*3;
				h = str_height;
				text = "Fog";
			};

			class balca_env_fog : balca_debug_edit
			{
				idc = balca_env_fog_IDC;
				x = column_weight*0.5;
				w = column_weight/2-column_div;
				y = btn_height*3;
				h = str_height;
				text = "--";
			};

			class balca_env_overcast_desc : balca_debug_text
			{
				x = 0;
				w = column_weight/2-column_div;
				y = btn_height*4;
				h = str_height;
				text = "Overcast";
			};

			class balca_env_overcast : balca_debug_edit
			{
				idc = balca_env_overcast_IDC;
				x = column_weight*0.5;
				w = column_weight/2-column_div;
				y = btn_height*4;
				h = str_height;
				text = "--";
			};

			class balca_env_rain_desc : balca_debug_text
			{
				x = 0;
				w = column_weight/2-column_div;
				y = btn_height*5;
				h = str_height;
				text = "Rain";
			};

			class balca_env_rain : balca_debug_edit
			{
				idc = balca_env_rain_IDC;
				x = column_weight*0.5;
				w = column_weight/2-column_div;
				y = btn_height*5;
				h = str_height;
				text = "--";
			};

			class balca_env_wind_desc : balca_debug_text
			{
				x = 0;
				w = column_weight/2-column_div;
				y = btn_height*6;
				h = str_height;
				text = "Wind speed";
			};

			class balca_env_wind : balca_debug_edit
			{
				idc = balca_env_wind_IDC;
				x = column_weight*0.5;
				w = column_weight/2-column_div;
				y = btn_height*6;
				h = str_height;
				text = "--";
			};

			class balca_env_wind_dir_desc : balca_debug_text
			{
				x = 0;
				w = column_weight/2-column_div;
				y = btn_height*7;
				h = str_height;
				text = "Wind direction";
			};

			class balca_env_wind_dir : balca_debug_edit
			{
				idc = balca_env_wind_dir_IDC;
				x = column_weight*0.5;
				w = column_weight/2-column_div;
				y = btn_height*7;
				h = str_height;
				text = "--";
			};
		};
	};

	class balca_apply_btn : balca_debug_btn
	{
		x = safezoneX_PG; w = column_weight-column_div;
		y = display_height-safezoneY_PG- offset_bottom;
		text = "Apply";
		action = "[1] call c_proving_ground_fnc_environment;";
	};
};


#include "CfgExplorer2\config.hpp"
#include "reloader\config.hpp"
