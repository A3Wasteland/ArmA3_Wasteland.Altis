#include "defs.hpp"
disableSerialization;
_veh = GET_SELECTED_VEHICLE;
_veh_type = GET_SELECTED_DATA(balca_loader_vehicle_list_IDC);
_index_turret = GET_INDEX_TURRET;
_weapons = GET_WEAPONS_TURRET;

lbClear GET_CTRL(balca_loader_weapon_list_IDC);
{GET_CTRL(balca_loader_weapon_list_IDC) lbAdd str _x;
GET_CTRL(balca_loader_weapon_list_IDC) lbSetData [(lbSize GET_CTRL(balca_loader_weapon_list_IDC))-1,_x];
} forEach _weapons;
GET_CTRL(balca_loader_weapon_list_IDC) lbSetCurSel 0;


[[0,0]] call GFNC(fill_compatible_magazines_list);
[[0,0]] call GFNC(fill_current_magazines_list);

GET_CTRL(balca_loader_current_magazines_IDC) lbSetCurSel 0;
GET_CTRL(balca_loader_compatible_magazines_IDC) lbSetCurSel 0;