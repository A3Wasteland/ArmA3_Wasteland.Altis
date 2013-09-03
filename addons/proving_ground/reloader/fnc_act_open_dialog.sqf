#include "defs.hpp"
disableSerialization;

_reloader = _this;

_vehlist = nearestObjects [_reloader, ["LandVehicle","Helicopter","Plane","Ship"], 15];
if ((count _vehlist == 0)&&(vehicle player != player)) then {
	_vehlist = [vehicle player];
};
/*if isNil{GVAR(init)} then {
	call compile preprocessFileLineNumbers __scriptPath(init);
};*/


createDialog "balca_loader_main";
uiNamespace setVariable ["balca_reloader_vehlist",_vehlist];
lbClear GET_CTRL(balca_loader_vehicle_list_IDC);
{GET_CTRL(balca_loader_vehicle_list_IDC) lbAdd (getText (configFile >> "CfgVehicles" >> typeOf(_x) >> "displayName"));
GET_CTRL(balca_loader_vehicle_list_IDC) lbSetData [(lbSize GET_CTRL(balca_loader_vehicle_list_IDC))-1,typeOf(_x)];
} forEach _vehlist;

GET_CTRL(balca_loader_vehicle_list_IDC) lbSetCurSel 0;
[] call GFNC(fill_turret_list);