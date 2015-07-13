// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: vLoad.sqf
//	@file Author: AgentRev, JoSchaap, Austerror

private ["_maxLifetime", "_maxUnusedTime", "_worldDir", "_methodDir", "_vehCount", "_vehicles", "_exclVehicleIDs"];

_maxLifetime = ["A3W_vehicleLifetime", 0] call getPublicVar;
_maxUnusedTime = ["A3W_vehicleMaxUnusedTime", 0] call getPublicVar;

_worldDir = "persistence\server\world";
_methodDir = format ["%1\%2", _worldDir, call A3W_savingMethodDir];

_vehCount = 0;
_vehicles = call compile preprocessFileLineNumbers format ["%1\getVehicles.sqf", _methodDir];

_exclVehicleIDs = [];

{
	private ["_veh", "_vehicleID", "_class", "_pos", "_dir", "_vel", "_flying", "_damage", "_fuel", "_hitPoints", "_owner", "_variables", "_textures", "_weapons", "_magazines", "_items", "_backpacks", "_turretMags", "_turretMags2", "_turretMags3", "_ammoCargo", "_fuelCargo", "_repairCargo", "_hoursAlive", "_hoursUnused", "_valid"];

	{ (_x select 1) call compile format ["%1 = _this", _x select 0]	} forEach _x;

	if (isNil "_flying") then { _flying = 0 };
	if (isNil "_hoursAlive") then { _hoursAlive = 0 };
	if (isNil "_hoursUnused") then { _hoursUnused = 0 };
	_valid = false;

	if (!isNil "_class" && !isNil "_pos" && {count _pos == 3 && (_maxLifetime <= 0 || _hoursAlive < _maxLifetime) && (_maxUnusedTime <= 0 || _hoursUnused < _maxUnusedTime)}) then
	{
		_vehCount = _vehCount + 1;
		_valid = true;

		{ if (typeName _x == "STRING") then { _pos set [_forEachIndex, parseNumber _x] } } forEach _pos;

		_isUAV = (getNumber (configFile >> "CfgVehicles" >> _class >> "isUav") > 0);
		_flying = (_flying > 0);

		_veh = createVehicle [_class, _pos, [], 0, if (_isUAV && _flying) then { "FLY" } else { "None" }];
		_veh allowDamage false;
		_veh hideObjectGlobal true;

		_velMag = vectorMagnitude velocity _veh;

		_veh setPosWorld ATLtoASL _pos;

		if (!isNil "_dir") then
		{
			_veh setVectorDirAndUp _dir;
		};

		// UAV AI
		if (_isUAV) then
		{
			createVehicleCrew _veh;

			if (_flying) then
			{
				if (isNil "_vel" || {count _vel < 3}) then
				{
					_vel = (vectorDir _veh) vectorMultiply _velMag;
				};

				_veh setVelocity _vel;
				_veh flyInHeight (((_veh call fn_getPos3D) select 2) max 500);
			};

			[_veh, _flying] spawn
			{
				_uav = _this select 0;
				_flying = _this select 1;

				waitUntil {!isNull driver _uav};

				if (_flying) then
				{
					_wp = (group _uav) addWaypoint [getPosATL _uav, 0];
					_wp setWaypointType "MOVE";
				};

				{
					[[_x, ["AI","",""]], "A3W_fnc_setName", true] call A3W_fnc_MP;
				} forEach crew _uav;
			};
		};

		[_veh] call vehicleSetup;

		if (!isNil "_vehicleID") then
		{
			_veh setVariable ["A3W_vehicleID", _vehicleID, true];
			_veh setVariable ["A3W_vehicleSaved", true, true];
			A3W_vehicleIDs pushBack _vehicleID;
		};

		_veh setVariable ["vehSaving_hoursUnused", _hoursUnused];
		_veh setVariable ["vehSaving_lastUse", diag_tickTime];
		_veh setVariable ["vehSaving_hoursAlive", _hoursAlive];
		_veh setVariable ["vehSaving_spawningTime", diag_tickTime];

		_veh allowDamage true;
		_veh setDamage _damage;
		{ _veh setHitPointDamage _x } forEach _hitPoints;

		_veh setFuel _fuel;

		if (!isNil "_textures") then
		{
			_veh setVariable ["BIS_enableRandomization", false, true];

			_objTextures = [];
			{
				_texture = _x select 0;
				{
					_veh setObjectTextureGlobal [_x, _texture];
					[_objTextures, _x, _texture] call fn_setToPairs;
				} forEach (_x select 1);
			} forEach _textures;

			_veh setVariable ["A3W_objectTextures", _objTextures, true];
		};

		if (!isNil "_owner") then
		{
			_veh setVariable ["ownerUID", _owner, true];
		};

		{ _veh setVariable [_x select 0, _x select 1, true] } forEach _variables;

		clearWeaponCargoGlobal _veh;
		clearMagazineCargoGlobal _veh;
		clearItemCargoGlobal _veh;
		clearBackpackCargoGlobal _veh;

		if (!isNil "_weapons") then
		{
			{ _veh addWeaponCargoGlobal _x } forEach _weapons;
		};
		if (!isNil "_magazines") then
		{
			[_veh, _magazines] call processMagazineCargo;
		};
		if (!isNil "_items") then
		{
			{ _veh addItemCargoGlobal _x } forEach _items;
		};
		if (!isNil "_backpacks") then
		{
			{
				_bpack = _x select 0;

				if (!(_bpack isKindOf "Weapon_Bag_Base") || {{_bpack isKindOf _x} count ["B_UAV_01_backpack_F", "B_Static_Designator_01_weapon_F", "O_Static_Designator_02_weapon_F"] > 0}) then
				{
					_veh addBackpackCargoGlobal _x;
				};
			} forEach _backpacks;
		};

		_veh setVehicleAmmo 0;

		if (!isNil "_turretMags3") then
		{
			{
				_veh addMagazineTurret [_x select 0, _x select 1];
				_veh setVehicleAmmo (_x select 2);
			} forEach _turretMags3;
		};
		if (!isNil "_turretMags") then
		{
			{ _veh addMagazine _x } forEach _turretMags;
		};
		if (!isNil "_turretMags2") then
		{
			{ _veh addMagazineTurret _x } forEach _turretMags2;
		};

		if (!isNil "_ammoCargo") then { _veh setAmmoCargo _ammoCargo };
		if (!isNil "_fuelCargo") then { _veh setFuelCargo _fuelCargo };
		if (!isNil "_repairCargo") then { _veh setRepairCargo _repairCargo };

		reload _veh;
		_veh hideObjectGlobal false;
	};

	if (!_valid && !isNil "_vehicleID") then
	{
		_exclVehicleIDs pushBack _vehicleID;
	};
} forEach _vehicles;

diag_log format ["A3Wasteland - world persistence loaded %1 vehicles from %2", _vehCount, call A3W_savingMethodName];

_exclVehicleIDs call fn_deleteVehicles;
