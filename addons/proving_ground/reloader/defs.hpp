#include "macros.hpp"

#define TEXT_GRAY(Text) ("<t color='#C0C0C0'>" + ##Text + "</t>")

#define balca_loader_main_IDD 66361

#define balca_loader_vehicle_shortcut_IDC (balca_loader_main_IDD + 1)
#define balca_loader_vehicle_list_IDC (balca_loader_main_IDD + 2)
#define balca_loader_turret_list_IDC (balca_loader_main_IDD + 3)
#define balca_loader_weapon_list_IDC (balca_loader_main_IDD + 4)
#define balca_loader_capacity_IDC (balca_loader_main_IDD + 5)
#define balca_loader_default_loadout_IDC (balca_loader_main_IDD + 6)
#define balca_loader_compatible_magazines_IDC (balca_loader_main_IDD + 7)
#define balca_loader_current_magazines_IDC (balca_loader_main_IDD + 8)
#define balca_loader_ammo_info_IDC (balca_loader_main_IDD + 9)
#define balca_loader_restore_btn_IDC (balca_loader_main_IDD + 10)
#define balca_loader_load_btn_IDC (balca_loader_main_IDD + 11)
#define balca_loader_unload_btn_IDC (balca_loader_main_IDD + 12)



#define GET_DISPLAY (findDisplay balca_loader_main_IDD)
#define GET_CTRL(a) (GET_DISPLAY displayCtrl ##a)

#define GET_SELECTED_DATA(a) ([##a] call GFNC(get_selected_data))
#define GET_SELECTED_VEHICLE ([] call GFNC(get_selected_vehicle))
#define GET_SELECTED_TURRET ([] call GFNC(get_selected_turret))
#define GET_CURRENT_MAGAZINES_TURRET [] call GFNC(get_current_magazines_turret)
#define GET_WEAPONS_TURRET ((GET_SELECTED_VEHICLE) weaponsTurret (GET_SELECTED_TURRET))

#define CHANGABLE_WEAPONS [["AirBombLauncher","Ch29Launcher","Ch29Launcher_Su34","R73Launcher_2","R73Launcher","HeliBombLauncher"],["Mk82BombLauncher","Mk82BombLauncher_6","MaverickLauncher","BombLauncherA10"],["BombLauncherF35", "SidewinderLaucher_F35"],["ACE_R73Launcher","ACE_R27Launcher","ACE_Kh25Launcher","ACE_KAB500KRLauncher","ACE_KAB500LLauncher"]]

#define BALCA_RELOADER_DEBUG (true)


