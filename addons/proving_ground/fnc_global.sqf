_fnc_create_land_target = {
	private ["_index","_unit_type"];
	_index = _this select 0;
	_unit_type = _this select 1;
	_offset = if (count(_this) >2) then {_this select 2}else{0};
	_is_new = false;
	if (_index == -1) then {_index = (count PG_get(land_targets));_is_new = true};
	_core = PG_get(core);
	_dir = getDir _core;
	_pos = getPos _core;
	_tdist = PG_get(target_props) select 0;
	_tspeed = PG_get(target_props) select 1;
	_tdir = PG_get(target_props) select 2;
	_grp = createGroup PG_get(opfor);
	_grp copyWaypoints PG_get(target_grp);
	_pos = if (PG_get(target_mode)<2) then {
		[(_pos select 0)+(_tdist+20)*sin(_dir),(_pos select 1)+(_tdist+20)*cos(_dir),0];
	}else{
		waypointPosition ((waypoints _grp) select 0)
	};
	
	
	_unit = objNull;
	if (_unit_type isKindOf "Man") then {
		_unit = _grp createUnit [_unit_type,_pos,[],0.1,"NONE"];
		switch PG_get(target_mode) do {
			case 2: {//land AI

				};
			default {
					_unit setBehaviour "CARELESS"; 
					_unit disableAI "PATHPLAN";
					_unit disableAI "MOVE";
					_unit doWatch _core;
					_unit stop true;
			};
		};
		_unit allowFleeing 0; 
		_unit disableAI "TARGET";
		_unit disableAI "AUTOTARGET";
//		_unit disableAI "ANIM";
		_unit setCombatMode "BLUE";
		switch (_index%4) do {
			case 0: {_unit setUnitPos "UP"};
			case 1: {_unit setUnitPos "MIDDLE"};
			case 2: {_unit setUnitPos "DOWN"};
			default {_unit setUnitPos "UP"};
		};
	}else{
		_unit = createVehicle [_unit_type, _pos, [], 0, "NONE"];
		[_unit,_grp] call PG_get(fnc_create_crew);
		_unit setCombatMode "BLUE";
		_unit engineOn true;
		if !(_unit isKindOf "Plane") then {_unit flyInHeight 5;};
	};
	_unit setDir _tdir;
	{_unit removeMagazine _x} forEach magazines _unit;
	group player reveal _unit;
	//hint on hit
	_unit addEventHandler["hit","hintSilent format['""%1"" hit, damage:%2',getText(configFile >> 'cfgVehicles' >> typeof (_this select 0) >> 'displayName'),ceil((_this select 2)*100)/100]; [4,_this] call c_proving_ground_fnc_statistics"]; 
	//hint when killed
	_unit addEventHandler["killed","hintSilent format['""%1"" killed',getText(configFile >> 'cfgVehicles' >> typeof (_this select 0) >> 'displayName')];[5,_this] call c_proving_ground_fnc_statistics"];


	//hint format ["%1",[_index,_trgname]];

	_target = [_unit,_unit_type,_grp,_offset];
	PG_set_arr(LAND_TARGETS,_index,_target);
	switch PG_get(target_mode) do {
		case 0: {//land static
				if (_is_new) then {
					[] call PG_get(fnc_calc_offsets);
				}else{
					[0,_index] call PG_get(fnc_move_land_targets);
				};
			};
		case 1: {//land random
				_unit spawn PG_get(fnc_move_rand_land);
			};
	};
	_unit
};

_fnc_create_crew = {
	private["_unit","_crew","_grp","_veh"];
	_veh = _this select 0;
	_grp = _this select 1;
	_crew = getArray(configFile >> "cfgVehicles" >> (typeOf _veh) >> "typicalCargo");
	_target_mode = PG_get(target_mode);

	{
		_unit = (_grp createUnit [_x,[0,0,0],[],0.1,"NONE"]);
		{_unit removeMagazine _x} forEach magazines _unit;
		switch _target_mode do {
			case 2: {//land AI
					_unit doWatch PG_get(core);
				};
			case 3: {//air AI
				};
			default {
					_unit disableAI "PATHPLAN";
					_unit disableAI "MOVE";
					_unit doWatch PG_get(core);
					_unit stop true;
			};
		};
		_unit allowFleeing 0; 
		_unit disableAI "TARGET";
		_unit disableAI "AUTOTARGET";
		_unit setCombatMode "BLUE";
		switch (_forEachIndex) do {
			case 0: {_unit moveInDriver _veh};
			case 1: {_unit moveInGunner _veh};
			case 2: {_unit moveInCommander _veh};
			default {_unit moveInCargo _veh};
		};
	} forEach _crew;
};

_fnc_create_air_target = {
	_index = _this select 0;
	_veh_type = _this select 1;
	_count = count PG_get(air_targets);
	if (_index == -1) then {_index = _count;};
	
		
	_core = PG_get(core);
	_tdist = PG_get(target_props) select 0;
	_tspeed = PG_get(target_props) select 1;
	_tdir = PG_get(target_props) select 2;
	_dir = getDir _core;
	_pos = getPos _core;
	_veh = createVehicle [_veh_type, [0,0,1000], [], 0, "FLY"];
	_grp = createGroup PG_get(opfor);
	_veh setDir _dir; 
	_veh setPos [_pos select 0,_pos select 1,10]; 
	_veh engineOn true;
	_veh setVelocity [80*sin(_dir),80*cos(_dir),10];
	[_veh,_grp] call PG_get(fnc_create_crew);
	_veh addEventHandler ["IncomingMissile","(_this select 0) fire [""CMFlareLauncher"",""Burst""]"];
	_target = [_veh,_veh_type,_grp];
	PG_set_arr(AIR_TARGETS,_index,_target);
	group player reveal _veh;
	_grp copyWaypoints PG_get(air_target_grp);
	_veh flyInHeight 300;

	_veh addEventHandler["hit","hintSilent format['""%1"" hit\ndamage:%2\ncrew status: %3',getText(configFile >> 'cfgVehicles' >> typeof (_this select 0) >> 'displayName'),ceil((_this select 2)*100)/100,[(_this select 0)] call {_crew = crew (_this select 0);_crew_stat = [];{_crew_stat set [count _crew_stat, damage _x]} forEach _crew;_crew_stat}]; "]; 
	_veh addEventHandler["killed","hintSilent format['""%1"" killed',getText(configFile >> 'cfgVehicles' >> typeof (_this select 0) >> 'displayName')];"];

	_veh
};

_fnc_move_land_targets = {
	_shift = _this select 0;
	_move_only = _this select 1;//change position only of selected unit index, -1 - change position of all units
	_core = PG_get(core);
	_tdist = PG_get(target_props) select 0;
	_tspeed = PG_get(target_props) select 1;
	_tdir = PG_get(target_props) select 2;
	_dir = getDir _core;
	_pos = getPos _core;
	_land_targets = if (_move_only>-1) then {[PG_get(land_targets) select _move_only]}else{PG_get(land_targets)};

	{//change unit position
		_target = _x;
		_unit = _target select 0;
		_side_offset = _shift + (_target select 3);
		_tpos = [(_pos select 0)+_side_offset*sin(_dir+90)+_tdist*sin(_dir),(_pos select 1)+_side_offset*cos(_dir+90)+_tdist*cos(_dir),0];
		_unit setPos _tpos;
		_unit setDir _tdir;
	} forEach _land_targets;;
};

_fnc_calc_offsets = {
	_land_targets = PG_get(land_targets);
	_core = PG_get(CORE);
	_dir = getDir _core;
	_pos = getPos _core;
	_center_offset = 0;
	_prev_size = 0;
	_betweenArray = [];
	{//calculate side offsets
		_unit = _x select 0;
		_type = _x select 1;
		_size = switch true do {
			case (_type isKindOf "man"): {1};
			case (_type isKindOf "air"): {12};
			default {3+abs(5*sin(_dir-_tdir))};
		};
		_between = _size + _prev_size;
		_center_offset = _center_offset + _size;
		_betweenArray set [count _betweenArray,_between];
		_prev_size = _size;
	} forEach _land_targets;
	_side_offset = - _center_offset;
	_new_land_targets = [];
	{
		_between = _betweenArray select _forEachIndex;
		_side_offset = _side_offset + _between;
		_new_land_targets set [_forEachIndex,[_x select 0,_x select 1,_x select 2,_side_offset]];
	} forEach _land_targets;
	PG_set(land_targets,_new_land_targets);
	[0,-1] call PG_get(fnc_move_land_targets);
};

_fnc_move_rand_land = {
	_unit = _this;
	_props = PG_get(target_props);
	_tdist = _props select 0;
	_tdir = _props select 2;
	_core = PG_get(core);
	_dir = getDir _core;
	_pos = getPos _core;
	_rprops = PG_get(target_props_rand);
	_rdist = _rprops select 0;
	_rspeed = _rprops select 1;
	_rdir = _rprops select 2;
	_PG_tdist = _unit getVariable "PG_tdist";
	switch true do {
		case ((_PG_tdist select 0)==_tdist): {};//do nothing
		default {//it is new unit or _tdist changed
			_cdist = _tdist -_rdist + random(2*_rdist);
			_cdir = _tdir -_rdir + random(2*_rdir);
			_side_offset = -20+random(40);
			_tpos = [(_pos select 0)+_side_offset*sin(_dir+90)+_cdist*sin(_dir),(_pos select 1)+_side_offset*cos(_dir+90)+_cdist*cos(_dir),0];
			_unit setPos _tpos;
			_unit setDir _cdir;
			if (_rspeed!=0) then {
				_shift = _side_offset;
				_delay = 0.03;
				_shift_inc = (random(_rspeed)*_delay);
				if (random(2)>1) then {_shift_inc = -_shift_inc};
				while {((alive _unit)&&(PG_get(target_props_rand) select 1) != 0)&&(PG_get(target_mode) == 1)} do {
					sleep _delay;
					_shift = _shift + _shift_inc;
					if (abs(_shift)>20) then {_shift_inc = -_shift_inc};
					_tpos = [(_pos select 0)+_shift*sin(_dir+90)+_cdist*sin(_dir),(_pos select 1)+_shift*cos(_dir+90)+_cdist*cos(_dir),0];
					_unit setPos _tpos;
				};
			};
		};
	};
};

PG_set(fnc_create_crew,_fnc_create_crew);
PG_set(fnc_create_land_target,_fnc_create_land_target);
PG_set(fnc_create_air_target,_fnc_create_air_target);
PG_set(fnc_calc_offsets,_fnc_calc_offsets);
PG_set(fnc_move_land_targets,_fnc_move_land_targets);
PG_set(fnc_move_rand_land,_fnc_move_rand_land);

_booster_keyhandler = 
{
	private["_handled","_ctrl", "_dikCode", "_shift", "_ctrlKey", "_alt"];
	_ctrl = _this select 0;
	_dikCode = _this select 1;
	_shift = _this select 2;
	_ctrlKey = _this select 3;
	_alt = _this select 4;
	_handled = false;
	if (!_shift && !_ctrlKey && !_alt && (_dikCode == 18)&&(vehicle player != player)) then {
			
			_ctrl = nil;
			_handled = true;
			_veh = vehicle player;
			_vel = velocity _veh;
			_pos = getPos _veh;
			_dir = getdir _veh;
			_pitch = acos((vectorUp _veh) select 2);
			_vel_new = [((_vel select 0) + 10*sin(_dir)),((_vel select 1) + 10*cos(_dir)),((_vel select 2) + 10*sin(_pitch))];
			_veh setVelocity _vel_new;
		};
	_handled;
};
PG_set(booster_keyhandler,_booster_keyhandler);

_fnc_add_weapon = {
	_weapon = _this select 0;
	_weaponCfg = (configFile >> "cfgWeapons" >> _weapon);
	_type = getNumber(_weaponCfg >> "type");
	if (_type in [1,2,4,5]) then {
		{_cWepType = [getNumber(configFile >> "cfgWeapons" >> _x >> "type")];
		if (_cWepType select 0 in [1,5]) then {_cWepType = [1,5];};
		if (_type in _cWepType) then {
			player removeWeapon _x;
			_current_magazines = magazines player;
			_compatible_magazines = getArray(configFile >> "cfgWeapons" >> _x >> "magazines");
			{if (_x in _compatible_magazines) then {
				player removeMagazine _x;
			};} forEach _current_magazines;
		};} forEach (weapons player);
	};
	_magazines = [];
	{
		_magazines = _magazines + getArray( (if ( _x == "this" ) then { _weaponCfg } else { _weaponCfg >> _x }) >> "magazines")
	} forEach getArray(_weaponCfg >> "muzzles");
	if (count(_magazines) > 0) then {
		player addMagazine (_magazines select 0);
	};
	player addWeapon _weapon;
	player selectWeapon _weapon;
	//remove uncompatible magazines
	_compatible_magazines = [];
	{
		_compatible_magazines = _compatible_magazines + getArray(configFile >> "cfgWeapons" >> _x >> "magazines");
	} forEach (weapons player);
	{if !(_x in _compatible_magazines) then {
		player removeMagazine _x;
	};} forEach (magazines player);
	PG_set(mags,magazines player);
	PG_set(weapons,weapons player);
};
PG_set(fnc_add_weapon,_fnc_add_weapon);