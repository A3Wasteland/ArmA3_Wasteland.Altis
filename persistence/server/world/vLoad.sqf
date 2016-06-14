// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: vLoad.sqf
//	@file Author: AgentRev, JoSchaap, Austerror

#include "functions.sqf"

private ["_maxLifetime", "_maxUnusedTime", "_worldDir", "_methodDir", "_vehCount", "_vehicles", "_exclVehicleIDs"];

_maxLifetime = ["A3W_vehicleLifetime", 0] call getPublicVar;
_maxUnusedTime = ["A3W_vehicleMaxUnusedTime", 0] call getPublicVar;

_worldDir = "persistence\server\world";
_methodDir = format ["%1\%2", _worldDir, call A3W_savingMethodDir];

_vehCount = 0;
_vehicles = call compile preprocessFileLineNumbers format ["%1\getVehicles.sqf", _methodDir];

_exclVehicleIDs = [];

{
	private ["_veh", "_vehicleID", "_class", "_pos", "_dir", "_vel", "_flying", "_hoursAlive", "_hoursUnused", "_damage", "_fuel", "_hitPoints", "_owner", "_variables", "_textures", "_weapons", "_magazines", "_items", "_backpacks", "_turretMags", "_turretMags2", "_turretMags3", "_ammoCargo", "_fuelCargo", "_repairCargo", "_valid", "_turretWeapons", "_path", "_magsAdded", "_magPathStr"];

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

		private _uavSide = sideUnknown;

		{
			_x params ["_var", "_val"];

			switch (_var) do
			{
				case "uavSide": { _uavSide = _val call _strToSide };
			};

			_veh setVariable [_var, _val, true];
		} forEach _variables;

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

			[_veh, _flying, _uavSide] spawn
			{
				params ["_uav", "_flying", "_uavSide"];
				private "_grp";

				waitUntil {_grp = group _uav; !isNull _grp};

				if (_uavSide != sideUnknown && side _uav != _uavSide) then
				{
					_grp = createGroup _uavSide;
					(crew _uav) joinSilent _grp;
				};

				_grp setCombatMode "BLUE"; // hold fire

				if (_flying) then
				{
					_wp = (group _uav) addWaypoint [getPosATL _uav, 0];
					_wp setWaypointType "MOVE";
				};

				{
					[_x, ["UAV","",""]] remoteExec ["A3W_fnc_setName", 0, _x];
				} forEach crew _uav;
			};
		};

		[_veh, false] call vehicleSetup;

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

		if (!isNil "_turretMags" && !isNil "_turretMags3" && {_turretMags isEqualTo [] && _turretMags3 isEqualTo []}) then
		{
			// for vehicles saved from A3 v1.56 and onwards, remove all default mags because empty ones are saved
			{ _veh removeMagazineTurret [_x select 0, _x select 1] } forEach magazinesAllTurrets _veh;
		}
		else
		{
			// for older vehicle saves, mark all default mags as empty so it can still be resupplied to its default ammo capacity
			_veh setVehicleAmmo 0;
		};

		// Remove all turret weapons to ensure they are reloaded properly
		_turretWeapons = _veh call fn_removeTurretWeapons;

		if (!isNil "_turretMags3") then
		{
			_magsAdded = [];

			{
				_mag = _x select 0;
				_path = _x select 1;
				_ammoCoef = _x select 2;

				_magPathStr = toLower (_mag + str _path);

				if (_magPathStr in _magsAdded) then
				{
					_veh addMagazineTurret [_mag, _path];
				}
				else
				{
					_magsAdded pushBack _magPathStr;
				};

				_veh setMagazineTurretAmmo [_mag, _ammoCoef * getNumber (configFile >> "CfgMagazines" >> _mag >> "count"), _path];
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

		// Re-add all turret weapons to ensure they are reloaded properly
		{ _veh addWeaponTurret _x } forEach _turretWeapons;

		if (!isNil "_ammoCargo") then { _veh setAmmoCargo _ammoCargo };
		if (!isNil "_fuelCargo") then { _veh setFuelCargo _fuelCargo };
		if (!isNil "_repairCargo") then { _veh setRepairCargo _repairCargo };

		//reload _veh;
		_veh hideObjectGlobal false;
	};

	if (!_valid && !isNil "_vehicleID") then
	{
		_exclVehicleIDs pushBack _vehicleID;
	};
} forEach _vehicles;

diag_log format ["A3Wasteland - world persistence loaded %1 vehicles from %2", _vehCount, call A3W_savingMethodName];

_exclVehicleIDs call fn_deleteVehicles;
