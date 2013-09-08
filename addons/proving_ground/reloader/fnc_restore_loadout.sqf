#include "defs.hpp"
//diag_log "restore_loadout";
_veh = GET_SELECTED_VEHICLE;
_veh_type = GET_SELECTED_DATA(balca_loader_vehicle_list_IDC);

//hull
_current_magazines = [];
_default_magazines_hull = getArray(configFile >> "CfgVehicles" >> _veh_type >> "magazines");
if ((_veh isKindOf "Plane")or(_veh isKindOf "Helicopter")or(_veh isKindOf "Car")) then {
	_current_magazines = magazines _veh;
	{_veh removeMagazine _x;} forEach _current_magazines;
	{_veh addMagazine _x;} forEach _default_magazines_hull;
}else{
	_current_magazines = _veh magazinesTurret [-1];
	{_veh removeMagazineTurret [_x,-1];} forEach _current_magazines;
	{_veh addMagazineTurret [_x,-1];} forEach _default_magazines_hull;
};
//diag_log "restore_loadout_1";
//turrets
_turrets= configFile >> "CfgVehicles" >> _veh_type >> "Turrets";
for "_i" from 0 to (count _turrets)-1 do {
	_turret = _turrets select _i;
	_weapons = _veh weaponsTurret [_i];


	if !(isNil {_weapons select 0}) then
	{
		_current_magazines = _veh magazinesTurret [_i];
		_default_magazines = getArray(_turret >> "magazines");
		{_veh removeMagazineTurret [_x,[_i]];} forEach _current_magazines;
		{_veh addMagazineTurret [_x,[_i]];} forEach _default_magazines;
	};
	_subturrets = _turret >> "Turrets";
	for "_j" from 0 to (count _turrets)-1 do {
		_turret = _subturrets select _j;
		_weapons = _veh weaponsTurret [_i,_j];
		if !(isNil {_weapons select 0}) then
		{
			_current_magazines = _veh magazinesTurret [_i,_j];
			_default_magazines = getArray(_turret >> "magazines");
			{_veh removeMagazineTurret [_x,[_i,_j]];} forEach _current_magazines;
			{_veh addMagazineTurret [_x,[_i,_j]];} forEach _default_magazines;
		};
	};
};

[] call GFNC(fill_current_magazines_list);
//diag_log "restore_loadout_end";