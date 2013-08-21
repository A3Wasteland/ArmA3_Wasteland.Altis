#include "defs.hpp"
private["_core"];
if (!__launchCondition) exitWith {};

if (isClass(configFile >> "cfgPatches" >> "ace_main")) then {
	ace_sys_wounds_enabled = true;
	publicVariable "ace_sys_wounds_enabled";
};

if (time==0) then {
	sleep .1;
};

if !(isNil{GVAR(init)}) exitWith {};

//init functions
__prepFnc(ammo);
__prepFnc(booster);
__prepFnc(target);
__prepFnc(status);
__prepFnc(autoheal);
__prepFnc(sound);
__prepFnc(bulletcam);
__prepFnc(bullettrack);
__prepFnc(create_vehicle);
__prepFnc(create_weapon);
__prepFnc(exec_console);
__prepFnc(sattelite);
__prepFnc(statistics);
__prepFnc(environment);
if (isClass(configFile >> "cfgVehicles" >> "An2_1_TK_CIV_EP1")) then {
	PG_set(satcam_keyhandler,__preprocess __scriptPath(satcam_keyhandler_OA));
}else{
	PG_set(satcam_keyhandler,__preprocess __scriptPath(satcam_keyhandler));
};
#include "fnc_global.sqf"

PG_set(STATUS,true);
[] call PG_get(fnc_status);

GVAR(init) = true;

//init functions for HJ_cfgExplorer
#define __addon_prefix proving_ground_HJ_
#define __scriptPath(a) __quoted(__concat4(__path,\CfgExplorer2\scripts\,a,.sqf))
#define __scriptName(a) __concat4(__autor_prefix,__addon_prefix,fnc_,a)
__prepFnc(InitDialog);
__prepFnc(EndDialog);
__prepFnc(onDoubleClickClass);
__prepFnc(onButtonClick_dump);
__prepFnc(onButtonClick_up);
__prepFnc(showConfig);
__prepFnc(FillClasses);
__prepFnc(FillValues);
__prepFnc(ArrayToString);
__prepFnc(onConfigChange);
//init functions for Reloader
#define __addon_prefix proving_ground_reloader_
#define __scriptPath(a) __quoted(__concat4(__path,\Reloader\fnc_,a,.sqf))
#define __scriptName(a) __concat4(__autor_prefix,__addon_prefix,fnc_,a)
__prepFnc(act_open_dialog);
__prepFnc(add_magazine);
__prepFnc(ammo_info);
__prepFnc(fill_compatible_magazines_list);
__prepFnc(fill_current_magazines_list);
__prepFnc(fill_turret_list);
__prepFnc(fill_weapon_list);
__prepFnc(get_capacity);
__prepFnc(get_current_magazines_turret);
__prepFnc(get_selected_data);
__prepFnc(get_selected_turret);
__prepFnc(get_selected_vehicle);
__prepFnc(remove_magazine);
__prepFnc(restore_loadout);