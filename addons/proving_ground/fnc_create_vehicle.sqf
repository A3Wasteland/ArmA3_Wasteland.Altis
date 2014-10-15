#include "defs.hpp"
#define GET_DISPLAY (findDisplay balca_debug_VC_IDD)
#define GET_CTRL(a) (GET_DISPLAY displayCtrl ##a)
#define GET_SELECTED_DATA(a) ([##a] call {_idc = _this select 0;_selection = (lbSelection GET_CTRL(_idc) select 0);if (isNil {_selection}) then {_selection = 0};(GET_CTRL(_idc) lbData _selection)})
#define KINDOF_ARRAY(a,b) [##a,##b] call {_veh = _this select 0;_types = _this select 1;_res = false; {if (_veh isKindOf _x) exitwith { _res = true };} forEach _types;_res}

_mode = _this select 0;
_veh_type = _this select 1;
switch (_mode) do {
case 0: {

		_kindOf = ["tank"];
		_filter = [];
		switch (_veh_type) do {
			case 0: {_kindOf = ["staticWeapon"];};
			case 1: {_kindOf = ["car","Motorcycle"];_filter = ["Truck_F","Wheeled_APC_F"];};
			case 2: {_kindOf = ["Truck_F"];};
			case 3: {_kindOf = ["Wheeled_APC_F","Tracked_APC_F"];};
			case 4: {_kindOf = ["tank"];_filter = ["Tracked_APC_F"];};
			case 5: {_kindOf = ["helicopter"];_filter = ["ParachuteBase"];};
			case 6: {_kindOf = ["plane"];_filter = ["ParachuteBase"];};
			case 7: {_kindOf = ["ship"];};
			default {_kindOf = ["tank"];_filter = [];};
		};
		_cfgvehicles = configFile >> "cfgVehicles";
		lbClear GET_CTRL(balca_VC_vehlist_IDC);
		for "_i" from 0 to (count _cfgvehicles)-1 do {
			_vehicle = _cfgvehicles select _i;
			if (isClass _vehicle) then {
				_veh_type = configName(_vehicle);
				if ((getNumber(_vehicle >> "scope")==2)and(getText(_vehicle >> "picture")!="")and(KINDOF_ARRAY(_veh_type,_kindOf))and!(KINDOF_ARRAY(_veh_type,_filter))) then {
					GET_CTRL(balca_VC_vehlist_IDC) lbAdd (getText(_vehicle >> "displayName"));
					GET_CTRL(balca_VC_vehlist_IDC) lbSetData [(lbSize GET_CTRL(balca_VC_vehlist_IDC))-1,_veh_type];
					GET_CTRL(balca_VC_vehlist_IDC) lbSetPicture [(lbSize GET_CTRL(balca_VC_vehlist_IDC))-1,getText(_vehicle >> "picture")];
				};
			};
		};
		lbSort GET_CTRL(balca_VC_vehlist_IDC);
	};
case 1: {
		_veh_type = GET_SELECTED_DATA(balca_VC_vehlist_IDC);
		GET_CTRL(balca_VC_vehicle_shortcut_IDC) ctrlSetText (getText(configFile >> "CfgVehicles" >> _veh_type >> "picture"));
		_vehicle = (configFile >> "CfgVehicles" >> _veh_type);
		_displayName = getText(_vehicle >> "displayName");
		_armor = getNumber(_vehicle >> "armor");
		_maxSpeed = getNumber(_vehicle >> "maxSpeed");
		_weapons =  getArray(_vehicle >> "weapons");
		_magazines = getArray(_vehicle >> "magazines");
		_turrets= (_vehicle >> "Turrets");
		for "_i" from 0 to (count _turrets)-1 do {
			_turret = _turrets select _i;
			_weapons = _weapons + getArray(_turret >> "weapons");
			_magazines = _magazines + getArray(_turret >> "magazines");
			_subturrets = _turret >> "Turrets";
			for "_j" from 0 to (count _subturrets)-1 do {
				_turret = _subturrets select _j;
				_weapons = _weapons + getArray(_turret >> "weapons");
				_magazines = _magazines + getArray(_turret >> "magazines");
			};
		};
		_lb = parseText "<br/>";
		_text = composeText [str configName(_vehicle),_lb,
			"DisplayName: ",str _displayName,_lb,
			"Armor: ", str _armor,_lb,
			"MaxSpeed: ", str _maxSpeed,_lb,
			"Weapons: ", str _weapons,_lb,
			"Magazines: ", str _magazines,_lb];
		GET_CTRL(balca_VC_veh_info_IDC) ctrlSetStructuredText _text;
	};
case 2: {
		_old_veh = PG_get(VEH);
		_core = PG_get(CORE);
		_dir = getDir _core;
		_pos = getPos _core;
		_veh_type = GET_SELECTED_DATA(balca_VC_vehlist_IDC);
		deleteVehicle _old_veh;
		_veh = createVehicle [_veh_type, _pos, [], 0, "CAN_COLLIDE"];
		_veh spawn vehicleRepair;
		_veh setDir _dir;
		PG_set(VEH,_veh);
	};

case 3: {
		_dir = getdir player;
		_pos = getPos player;
		_pos = [(_pos select 0)+20*sin(_dir),(_pos select 1)+20*cos(_dir),0];
		_veh_type = GET_SELECTED_DATA(balca_VC_vehlist_IDC);
		_old_veh = nearestObjects [_pos, ["AllVehicles"], 5];
		{deleteVehicle _x} forEach _old_veh;
		_veh = createVehicle [_veh_type, _pos, [], 0, "CAN_COLLIDE"];
		_veh spawn vehicleRepair;
		_veh setDir _dir;
		if (!isNil "notifyAdminMenu") then { ["vehicle", _veh_type] call notifyAdminMenu };
	};

case 4: {//class to clipboard
	copyToClipboard (""""+GET_SELECTED_DATA(balca_VC_vehlist_IDC)+"""");
	};

case 5: {//detailed info to clipboard
	copyToClipboard ctrlText GET_CTRL(balca_VC_veh_info_IDC);
	};
}
