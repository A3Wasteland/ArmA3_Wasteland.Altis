#include "defs.hpp"
#define GET_DISPLAY (findDisplay balca_target_display_IDD)
#define GET_CTRL(a) (GET_DISPLAY displayCtrl ##a)
#define GET_SELECTED_DATA(a) ([##a] call {_idc = _this select 0;_selection = (lbSelection GET_CTRL(_idc) select 0);if (isNil {_selection}) then {_selection = 0};(GET_CTRL(_idc) lbData _selection)})
#define KINDOF_ARRAY(a,b) [##a,##b] call {_veh = _this select 0;_types = _this select 1;_res = false; {if (_veh isKindOf _x) exitwith { _res = true };} forEach _types;_res}

//if (!isServer) exitWith {closeDialog 0};

_addMarker = {
	_name = _this select 0;
	_pos = _this select 1;
	_text = _this select 2;
	createMarkerLocal [_name,_pos];
	_name setMarkerColorLocal "ColorBlack";
	_name setMarkerSizeLocal [0.3,0.3];
	_name setMarkerAlphaLocal 1;
	_name setMarkerTextLocal _text;
	_name setMarkerTypeLocal "mil_circle";
	PG_set(WP_Markers,(PG_get(WP_Markers)+[_name]));
};

_clearMarkers = {
	{deleteMarker _x} forEach PG_get(WP_Markers);PG_set(WP_Markers,[]);
};

_drawMarkers = {
	_grp = _this;
	{if ((waypointType _x)=="MOVE") then {
		_markerName = format ["PG_WPMarker%1",str (_forEachIndex+1)];
		_pos = waypointPosition _x;
		_text = str _forEachIndex + " " + str (waypointType _x);
		[_markerName,_pos,_text] call _addMarker;
	};} forEach waypoints _grp;
};



_mode = _this select 0;
_opt = _this select 1;
switch (_mode) do {
case 0: {//init;
		_target_mode = if isNil{_opt} then {//restore values
			GET_CTRL(balca_target_mode_IDC) lbAdd 'Static land';
			GET_CTRL(balca_target_mode_IDC) lbAdd 'Random land';
			GET_CTRL(balca_target_mode_IDC) lbAdd 'AI land';
			GET_CTRL(balca_target_mode_IDC) lbAdd 'AI air';
			GET_CTRL(balca_target_mode_IDC) lbSetCurSel PG_get(target_mode);
			GET_CTRL(balca_target_map_IDC) ctrlShow false;
			PG_get(target_mode)
		}else{//onLBSelChanged
			PG_set(target_mode,_opt);
			{
				_unit = _x select 0;
				deleteVehicle _unit;
				if !(_unit isKindOf "Man") then {{deleteVehicle _x} forEach units (_x select 2);};
			} forEach PG_get(LAND_TARGETS);
			_opt
		};
		switch _target_mode do {
			case 0: {
				if (ctrlVisible balca_target_map_IDC) then {[7] call PG_get(FNC_target)};
				GET_CTRL(balca_target_land_static_IDC) ctrlShow true;
				GET_CTRL(balca_target_land_random_IDC) ctrlShow false;
				GET_CTRL(balca_target_land_AI_IDC) ctrlShow false;
				GET_CTRL(balca_target_air_AI_IDC) ctrlShow false;
				_props = PG_get(TARGET_PROPS);
				_tdist = _props select 0;
				_tspeed = _props select 1;
				_tdir = _props select 2;
				GET_CTRL(balca_target_distance_IDC) ctrlSetText str _tdist;
				GET_CTRL(balca_target_speed_IDC) ctrlSetText  str _tspeed;
				GET_CTRL(balca_target_direction_IDC) ctrlSetText str _tdir;
			};
			case 1: {
				if (ctrlVisible balca_target_map_IDC) then {[7] call PG_get(FNC_target)};
				GET_CTRL(balca_target_land_static_IDC) ctrlShow false;
				GET_CTRL(balca_target_land_random_IDC) ctrlShow true;
				GET_CTRL(balca_target_land_AI_IDC) ctrlShow false;
				GET_CTRL(balca_target_air_AI_IDC) ctrlShow false;
				_props = PG_get(TARGET_PROPS);
				_tdist = _props select 0;
				_tdir = _props select 2;
				_rprops = PG_get(TARGET_PROPS_RAND);
				_rdist = _rprops select 0;
				_rspeed = _rprops select 1;
				_rdir = _rprops select 2;
				GET_CTRL(balca_target_rdistance_IDC) ctrlSetText str _tdist;
				GET_CTRL(balca_target_rdirection_IDC) ctrlSetText str _tdir;
				GET_CTRL(balca_target_distance_rand_IDC) ctrlSetText str _rdist;
				GET_CTRL(balca_target_speed_rand_IDC) ctrlSetText  str _rspeed;
				GET_CTRL(balca_target_direction_rand_IDC) ctrlSetText str _rdir;
			};
			case 2: {
				GET_CTRL(balca_target_land_static_IDC) ctrlShow false;
				GET_CTRL(balca_target_land_random_IDC) ctrlShow false;
				GET_CTRL(balca_target_land_AI_IDC) ctrlShow true;
				GET_CTRL(balca_target_air_AI_IDC) ctrlShow false;
				_props = PG_get(TARGET_PROPS);
				_tdist = _props select 0;
				GET_CTRL(balca_target_land_AI_dist_IDC) ctrlSetText str _tdist;
			};
			case 3: {
				GET_CTRL(balca_target_land_static_IDC) ctrlShow false;
				GET_CTRL(balca_target_land_random_IDC) ctrlShow false;
				GET_CTRL(balca_target_land_AI_IDC) ctrlShow false;
				GET_CTRL(balca_target_air_AI_IDC) ctrlShow true;
				_air_wp_dist = PG_get(air_wp_dist);
				GET_CTRL(balca_target_air_AI_dist_IDC) ctrlSetText str _air_wp_dist;
				PG_set(target_mode,3);
			};
			default {};
		};
	};
case 1: {

		_kindOf = ["TargetBase"];
		_filter = [];
		switch (_opt) do {
			case 0: {_kindOf = ["CAManBase"];};
			case 1: {_kindOf = ["car"];_filter = ["truck","Wheeled_APC_F"];};
			case 2: {_kindOf = ["truck"];};
			case 3: {_kindOf = ["Wheeled_APC_F","Tracked_APC"];};
			case 4: {_kindOf = ["tank"];_filter = ["Tracked_APC"];};
			case 5: {_kindOf = ["helicopter"];_filter = ["ParachuteBase"];};
			case 6: {_kindOf = ["plane"];_filter = ["ParachuteBase"];};
			case 7: {_kindOf = ["ship"];};
			default {_kindOf = ["TargetBase"];_filter = [];};
		};
		_cfgvehicles = configFile >> "cfgVehicles";
		lbClear GET_CTRL(balca_target_vehlist_IDC);
		for "_i" from 0 to (count _cfgvehicles)-1 do {
			_vehicle = _cfgvehicles select _i;
			if (isClass _vehicle) then {
				_opt = configName(_vehicle);
				if ((getNumber(_vehicle >> "scope")==2)and(KINDOF_ARRAY(_opt,_kindOf))and!(KINDOF_ARRAY(_opt,_filter))) then {
					GET_CTRL(balca_target_vehlist_IDC) lbAdd (getText(_vehicle >> "displayName"));
					GET_CTRL(balca_target_vehlist_IDC) lbSetData [(lbSize GET_CTRL(balca_target_vehlist_IDC))-1,_opt];
					if !(_kindOf select 0 in ["TargetBase","CAManBase"]) then {
						GET_CTRL(balca_target_vehlist_IDC) lbSetPicture [(lbSize GET_CTRL(balca_target_vehlist_IDC))-1,getText(_vehicle >> "picture")];
					}else{
						GET_CTRL(balca_target_vehlist_IDC) lbSetPicture [(lbSize GET_CTRL(balca_target_vehlist_IDC))-1,getText(_vehicle >> "icon")];
					};


				};
			};
		};
		lbSort GET_CTRL(balca_target_vehlist_IDC);
	};
case 2: {//info
		_opt = GET_SELECTED_DATA(balca_target_vehlist_IDC);
		GET_CTRL(balca_target_vehicle_shortcut_IDC) ctrlSetText (getText(configFile >> "CfgVehicles" >> _opt >> "picture"));
		_vehicle = (configFile >> "CfgVehicles" >> _opt);
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
			"Weapons: ", str _weapons,_lb];
		GET_CTRL(balca_target_veh_info_IDC) ctrlSetStructuredText _text;
	};
case 3: {//add target
		_unit_type = GET_SELECTED_DATA(balca_target_vehlist_IDC);
		if (PG_get(target_mode)<3) then {//land
			[-1,_unit_type] call PG_get(FNC_CREATE_LAND_TARGET);
		}else {//air AI
			if (_unit_type isKindOf "Air") then {
				[-1,_unit_type] call PG_get(FNC_CREATE_AIR_TARGET);
			}else{
				hint "It can not fly";
			};
		};
	};
case 4: {//reset
			_core = PG_get(CORE);
			_dir = getDir _core;
			_pos = getPos _core;
			switch PG_get(target_mode) do {
				case 2: {//land AI
					{deleteWaypoint _x} forEach waypoints PG_get(TARGET_GRP);
					[6] call PG_get(FNC_target);
				};
				case 3: {//air AI
					_air_wp_dist = parseNumber ctrlText GET_CTRL(balca_target_air_AI_dist_IDC);
					PG_set(air_wp_dist,_air_wp_dist);
					[6] call PG_get(FNC_target);
				};
				default {};
			};
	};

case 5: {//clear targets
		{
			deleteVehicle (_x select 0);
			{deleteVehicle _x} forEach units(_x select 2);
			deleteGroup(_x select 2);
		}forEach PG_get(LAND_TARGETS);
		PG_set(LAND_TARGETS,[]);
		{
			deleteVehicle (_x select 0);
			{deleteVehicle _x} forEach units(_x select 2);
			deleteGroup(_x select 2);
		}forEach PG_get(AIR_TARGETS);
		PG_set(AIR_TARGETS,[]);
	};
case 6: {//apply
		_reset_land = {
				{
					_unit = _x select 0;
					deleteVehicle _unit;
					if !(_unit isKindOf "Man") then {{deleteVehicle _x} forEach units (_x select 2);};
				} forEach PG_get(LAND_TARGETS);
			};
		_core = PG_get(CORE);
		_dir = getDir _core;
		_pos = getPos _core;
		_props = PG_get(TARGET_PROPS);
		switch PG_get(target_mode) do {
			case 0: {//land static
				GVAR(target_props) = [parseNumber ctrlText GET_CTRL(balca_target_distance_IDC),parseNumber ctrlText GET_CTRL(balca_target_speed_IDC),(parseNumber ctrlText GET_CTRL(balca_target_direction_IDC))%360];
				call PG_get(FNC_MOVE_LAND_TARGETS);//reset position of targets
				if ((PG_get(TARGET_PROPS) select 1)>0) then {//if speed>0 start moving
					[] spawn {
						_shift = 0;
						_delay = 0.03;
						_speed = (PG_get(TARGET_PROPS) select 1);
						_shift_inc = (_speed*_delay);
						while {((PG_get(TARGET_PROPS) select 1) == _speed)&&(PG_get(target_mode) in [0,3])} do {
							sleep _delay;
							_shift = _shift + _shift_inc;
							if (abs(_shift)>20) then {_shift_inc = -_shift_inc};
							[_shift,-1] call PG_get(fnc_move_land_targets);
						};
						[0,-1] call PG_get(fnc_move_land_targets);
					};
				};
				[] call _reset_land;
			};
			case 1: {//land random
				GVAR(target_props) = [parseNumber ctrlText GET_CTRL(balca_target_rdistance_IDC),0,parseNumber ctrlText GET_CTRL(balca_target_rdirection_IDC)];
				GVAR(target_props_rand) = [parseNumber ctrlText GET_CTRL(balca_target_distance_rand_IDC),parseNumber ctrlText GET_CTRL(balca_target_speed_rand_IDC),parseNumber ctrlText GET_CTRL(balca_target_direction_rand_IDC)];
				[] call _reset_land;
			};
			case 2: {//land AI
				_grp = PG_get(TARGET_GRP);
				if ((ctrlVisible balca_target_map_IDC)&&((count waypoints PG_get(TARGET_GRP))>1)) then {
					//_wp = _grp addWaypoint [[_pos select 0,_pos select 1],0];
					//_wp setWaypointType "CYCLE";
					[7] call PG_get(FNC_target);
				}else{
					[] call _clearMarkers;
					{deleteWaypoint [_grp,0]} forEach (waypoints _grp);
					_wp = _grp addWaypoint [[(_pos select 0)+20*sin(_dir+90)+(_props select 0)*sin(_dir),(_pos select 1)+20*cos(_dir+90)+(_props select 0)*cos(_dir)],0,0];
					_wp setWaypointType "MOVE";
					_wp setWaypointCompletionRadius 30;
					_wp = _grp addWaypoint [[(_pos select 0)-20*sin(_dir+90)+(_props select 0)*sin(_dir),(_pos select 1)-20*cos(_dir+90)+(_props select 0)*cos(_dir)],0,1];
					_wp setWaypointType "MOVE";
					_wp setWaypointCompletionRadius 30;
					_wp = _grp addWaypoint [[_pos select 0,_pos select 1],0,2];
					_wp setWaypointType "CYCLE";
				};
				[] call _reset_land;
			};
			case 3: {//air AI
				_grp = PG_get(AIR_TARGET_GRP);
				if ((ctrlVisible balca_target_map_IDC)&&((count waypoints PG_get(AIR_TARGET_GRP))>1)) then {
					//_wp = _grp addWaypoint [[_pos select 0,_pos select 1],0];
					//_wp setWaypointType "CYCLE";
					[7] call PG_get(FNC_target);
				}else{
					_air_wp_dist = parseNumber ctrlText GET_CTRL(balca_target_air_AI_dist_IDC);
					{deleteWaypoint [_grp,0]} forEach (waypoints PG_get(AIR_TARGET_GRP));
					PG_set(air_wp_dist,_air_wp_dist);
					[] call _clearMarkers;
					_wp = _grp addWaypoint [[(_pos select 0)+_air_wp_dist,(_pos select 1)],0,0];
					_wp setWaypointType "MOVE";
					_wp setWaypointCompletionRadius 30;
					_wp = _grp addWaypoint [[(_pos select 0),(_pos select 1)+_air_wp_dist],0,1];
					_wp setWaypointType "MOVE";
					_wp setWaypointCompletionRadius 30;
					_wp = _grp addWaypoint [[(_pos select 0)-_air_wp_dist,(_pos select 1)],0,2];
					_wp setWaypointType "MOVE";
					_wp setWaypointCompletionRadius 30;
					_wp = _grp addWaypoint [[(_pos select 0),(_pos select 1)-_air_wp_dist],0,3];
					_wp setWaypointType "MOVE";
					_wp setWaypointCompletionRadius 30;
					_wp = _grp addWaypoint [[_pos select 0,_pos select 1],0,4];
					_wp setWaypointType "CYCLE";
				};
			};
			default {};
		};
	};
case 7: {//toggle map
		_map_enabled = ctrlVisible balca_target_map_IDC;
		if _map_enabled then {
			GET_CTRL(balca_target_map_IDC) ctrlShow false;
			GET_CTRL(balca_target_vehlist_IDC) ctrlShow true;
			GET_CTRL(balca_target_vehicle_shortcut_IDC) ctrlShow true;
			GET_CTRL(balca_target_veh_info_IDC) ctrlShow true;
			[] call _clearMarkers;
		}else{
			GET_CTRL(balca_target_map_IDC) ctrlShow true;
			GET_CTRL(balca_target_vehlist_IDC) ctrlShow false;
			GET_CTRL(balca_target_vehicle_shortcut_IDC) ctrlShow false;
			GET_CTRL(balca_target_veh_info_IDC) ctrlShow false;
			_grp = switch PG_get(target_mode) do {
				case 2: {//land AI
					PG_get(target_grp);
				};
				case 3: {//air AI
					PG_get(air_target_grp)
				};
				default {};
			};
			_grp call _drawMarkers;
			hint "Double click on map to add new waypoint";
		};
	};
case 8: {//clear waypoint
		_grp = switch PG_get(target_mode) do {
			case 2: {//land AI
				PG_get(target_grp);
			};
			case 3: {//air AI
				PG_get(air_target_grp)
			};
			default {};
		};
		{deleteWaypoint [_grp,0]} forEach (waypoints _grp);
		[] call _clearMarkers;
	};
case 9: {//add waypoint
		_grp = switch PG_get(target_mode) do {
			case 2: {//land AI
				PG_get(target_grp);
			};
			case 3: {//air AI
				PG_get(air_target_grp)
			};
			default {};
		};
		_count = (count (waypoints _grp)) max 1;
		deleteWaypoint [_grp,_count-1];
		_wp = _grp addWaypoint [_opt,0,_count-1];
		_wp setWaypointType "MOVE";
		_wp setWaypointCompletionRadius 30;
		if (ctrlVisible balca_target_map_IDC) then {
			_markerName = format ["PG_WPMarker%1",str (_count-1)];
			_pos = waypointPosition _wp;
			_text = str (_count-1) + " " + str (waypointType _wp);
			[_markerName,_pos,_text] call _addMarker
		};
		_wp = _grp addWaypoint [_opt,0,_count];
		_wp setWaypointType "CYCLE";
	};
case 10: {//unload
		[] call _clearMarkers;
	};
};
