#include "defs.hpp"

_veh = GET_SELECTED_VEHICLE;
_magazine = GET_SELECTED_DATA(balca_loader_current_magazines_IDC);
_index_turret = GET_SELECTED_TURRET;
if (((_veh isKindOf "Plane")or(_veh isKindOf "Helicopter"))and(_index_turret select 0 < 1)) then {
	_veh removeMagazine _magazine
}else{
	_veh removeMagazineTurret [_magazine,_index_turret];
};
[] call GFNC(fill_current_magazines_list);