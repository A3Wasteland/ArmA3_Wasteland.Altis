// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.2
//	@file Name: oSave.sqf
//	@file Author: [GoT] JoSchaap, AgentRev
//	@file Description: Basesaving save script

if (!isServer) exitWith {};

#include "functions.sqf"

_saveableObjects = [];

_isSaveable =
{
	_result = false;
	{ if (_this == _x) exitWith { _result = true } } forEach _saveableObjects;
	_result
};

// Add objectList & general store objects
{
	_index = _forEachIndex;

	{
		_obj = _x;
		if (_index > 0) then { _obj = _x select 1 };

		if (!(_obj isKindOf "ReammoBox_F") && {!(_obj call _isSaveable)}) then
		{
			_saveableObjects pushBack _obj;
		};
	} forEach _x;
} forEach [objectList, call genObjectsArray];

// If file doesn't exist, create Info section at the top
if !(_fileName call PDB_exists) then // iniDB_exists
{
	[_fileName, "Info", "ObjCount", 0] call PDB_write; // iniDB_write
};

_savingMethod = ["A3W_savingMethod", 1] call getPublicVar;

_purchasedVehicleSaving = ["A3W_purchasedVehicleSaving"] call isConfigOn;
_missionVehicleSaving = ["A3W_missionVehicleSaving"] call isConfigOn;
_vehicleSaving = (_purchasedVehicleSaving || _missionVehicleSaving);
_vehFileName = "Vehicles" call PDB_objectFileName;

// If file doesn't exist, create Info section at the top
if (_vehicleSaving && !(_vehFileName call PDB_exists)) then // iniDB_exists
{
	[_vehFileName, "Info", "VehCount", 0] call PDB_write; // iniDB_write
};

while {true} do
{
	uiSleep 30;

	_oldObjCount = [_fileName, "Info", "ObjCount", "NUMBER"] call PDB_read; // iniDB_read
	_objCount = 0;

	{
		_obj = _x;

		if (alive _obj) then
		{
			_class = typeOf _obj;

			if (_obj getVariable ["objectLocked", false] &&
			       {(_baseSavingOn && {_class call _isSaveable}) ||
				    (_boxSavingOn && {_class call _isBox}) ||
					(_staticWeaponSavingOn && {_class call _isStaticWeapon})} ||
			   {_warchestSavingOn && {_obj call _isWarchest}} ||
			   {_beaconSavingOn && {_obj call _isBeacon}}) then
			{
				_netId = netId _obj;
				_pos = ASLtoATL getPosWorld _obj;
				{ _pos set [_forEachIndex, _x call fn_numToStr] } forEach _pos;
				_dir = [vectorDir _obj, vectorUp _obj];
				_damage = damage _obj;
				_allowDamage = if (_obj getVariable ["allowDamage", false]) then { 1 } else { 0 };

				_spawningTime = _obj getVariable "baseSaving_spawningTime";

				if (isNil "_spawningTime") then
				{
					_spawningTime = diag_tickTime;
					_obj setVariable ["baseSaving_spawningTime", _spawningTime];
				};

				_hoursAlive = (_obj getVariable ["baseSaving_hoursAlive", 0]) + ((diag_tickTime - _spawningTime) / 3600);

				_variables = [];

				switch (true) do
				{
					case (_obj isKindOf "Land_Sacks_goods_F"):
					{
						_variables pushBack ["food", _obj getVariable ["food", 20]];
					};
					case (_obj isKindOf "Land_BarrelWater_F"):
					{
						_variables pushBack ["water", _obj getVariable ["water", 20]];
					};
				};

				_owner = _obj getVariable ["ownerUID", ""];

				if (_owner != "") then
				{
					_variables pushBack ["ownerUID", _owner];
				};

				switch (true) do
				{
					case (_obj call _isBox):
					{
						_variables pushBack ["cmoney", _obj getVariable ["cmoney", 0]];
					};
					case (_obj call _isWarchest):
					{
						_variables pushBack ["a3w_warchest", true];
						_variables pushBack ["R3F_LOG_disabled", true];
						_variables pushBack ["side", str (_obj getVariable ["side", sideUnknown])];
					};
					case (_obj call _isBeacon):
					{
						_variables pushBack ["a3w_spawnBeacon", true];
						_variables pushBack ["R3F_LOG_disabled", true];
						_variables pushBack ["side", str (_obj getVariable ["side", sideUnknown])];
						_variables pushBack ["packing", false];
						_variables pushBack ["groupOnly", _obj getVariable ["groupOnly", false]];
						_variables pushBack ["ownerName", toArray (_obj getVariable ["ownerName", "[Beacon]"])];
					};
				};

				_r3fSide = _obj getVariable "R3F_Side";

				if (!isNil "_r3fSide") then
				{
					_variables pushBack ["R3F_Side", str _r3fSide];
				};

				_weapons = [];
				_magazines = [];
				_items = [];
				_backpacks = [];

				if (_class call _hasInventory) then
				{
					// Save weapons & ammo
					_weapons = (getWeaponCargo _obj) call cargoToPairs;
					_magazines = (getMagazineCargo _obj) call cargoToPairs;
					_items = (getItemCargo _obj) call cargoToPairs;
					_backpacks = (getBackpackCargo _obj) call cargoToPairs;
				};

				_turretMags = [];

				if (_staticWeaponSavingOn && {_class call _isStaticWeapon}) then
				{
					_turretMags = magazinesAmmo _obj;
				};

				_ammoCargo = getAmmoCargo _obj;
				_fuelCargo = getFuelCargo _obj;
				_repairCargo = getRepairCargo _obj;

				// Fix for -1.#IND
				if !(_ammoCargo >= 0) then { _ammoCargo = 0 };
				if !(_fuelCargo >= 0) then { _fuelCargo = 0 };
				if !(_repairCargo >= 0) then { _repairCargo = 0 };

				// Save data

				_objCount = _objCount + 1;
				_objName = format ["Obj%1", _objCount];

				{
					[_fileName, _objName, _x select 0, _x select 1, false] call PDB_write; // iniDB_write
				}
				forEach
				[
					["Class", _class],
					["Position", _pos],
					["Direction", _dir],
					["HoursAlive", _hoursAlive],
					["Damage", _damage],
					["AllowDamage", _allowDamage],
					["Variables", _variables],

					["Weapons", _weapons],
					["Magazines", _magazines],
					["Items", _items],
					["Backpacks", _backpacks],

					["TurretMagazines", _turretMags],

					["AmmoCargo", _ammoCargo],
					["FuelCargo", _fuelCargo],
					["RepairCargo", _repairCargo]
				];

				sleep 0.01;
			};
		};
	} forEach allMissionObjects "All";

	[_fileName, "Info", "ObjCount", _objCount] call PDB_write; // iniDB_write

	_fundsWest = 0;
	_fundsEast = 0;

	if (["A3W_warchestMoneySaving"] call isConfigOn) then
	{
		_fundsWest = ["pvar_warchest_funds_west", 0] call getPublicVar;
		_fundsEast = ["pvar_warchest_funds_east", 0] call getPublicVar;
	};

	[_fileName, "Info", "WarchestMoneyBLUFOR", _fundsWest] call PDB_write; // iniDB_write
	[_fileName, "Info", "WarchestMoneyOPFOR", _fundsEast] call PDB_write; // iniDB_write

	diag_log format ["A3W - %1 baseparts and objects have been saved with %2", _objCount, ["A3W_savingMethodName", "-ERROR-"] call getPublicVar];

	// Reverse-delete old objects
	if (_oldObjCount > _objCount) then
	{
		for "_i" from _oldObjCount to (_objCount + 1) step -1 do
		{
			[_fileName, format ["Obj%1", _i], false] call PDB_deleteSection; // iniDB_deleteSection
		};
	};

	if (_savingMethod == 1) then
	{
		saveProfileNamespace; // this line is crucial to ensure all profileNamespace data submitted to the server is saved
		diag_log "A3W - profileNamespace saved";
	};

	uiSleep 30;

	// Vehicle saving
	if (_vehicleSaving) then
	{
		_oldVehCount = [_vehFileName, "Info", "VehCount", "NUMBER"] call PDB_read; // iniDB_read
		_vehCount = 0;

		{
			_veh = _x;

			// Only save vehicles that are alive and touching the ground or water
			if (!(_veh isKindOf "Man") && {alive _veh && (isTouchingGround _veh || (getPos _veh) select 2 < 1)}) then
			{
				_class = typeOf _veh;
				_purchasedVehicle = _veh getVariable ["A3W_purchasedVehicle", false];
				_missionVehicle = (_veh getVariable ["A3W_missionVehicle", false] && !(_veh getVariable ["R3F_LOG_disabled", false]));

				if ((_purchasedVehicle && _purchasedVehicleSaving) ||
				    (_missionVehicle && _missionVehicleSaving)) then
				{
					_pos = ASLtoATL getPosWorld _veh;
					{ _pos set [_forEachIndex, _x call fn_numToStr] } forEach _pos;
					_dir = [vectorDir _veh, vectorUp _veh];
					_fuel = fuel _veh;
					_damage = damage _veh;
					_hitPoints = [];

					{
						_hitPoint = configName _x;
						_hitPoints set [count _hitPoints, [_hitPoint, _veh getHitPointDamage _hitPoint]];
					} forEach (_class call getHitPoints);

					_spawningTime = _veh getVariable "vehSaving_spawningTime";

					if (isNil "_spawningTime") then
					{
						_spawningTime = diag_tickTime;
						_veh setVariable ["vehSaving_spawningTime", _spawningTime];
					};

					_lastUse = _veh getVariable ["vehSaving_lastUse", _spawningTime];

					if ({isPlayer _x} count crew _veh > 0 || isPlayer ((uavControl _veh) select 0)) then
					{
						_lastUse = diag_tickTime;
						_veh setVariable ["vehSaving_lastUse", _lastUse];
						_veh setVariable ["vehSaving_hoursUnused", 0];
					};

					_hoursAlive = (_veh getVariable ["vehSaving_hoursAlive", 0]) + ((diag_tickTime - _spawningTime) / 3600);
					_hoursUnused = (_veh getVariable ["vehSaving_hoursUnused", 0]) + ((diag_tickTime - _lastUse) / 3600);

					_variables = [];

					_owner = _veh getVariable ["ownerUID", ""];

					if !(_owner in ["","0"]) then
					{
						_variables pushBack ["ownerUID", _owner];
					};

					switch (true) do
					{
						case _purchasedVehicle:
						{
							_variables pushBack ["A3W_purchasedVehicle", true];
						};
						case _missionVehicle:
						{
							_variables pushBack ["A3W_missionVehicle", true];
						};
					};

					_textures = [];
					{
						[_textures, _x select 1, [_x select 0]] call fn_addToPairs;
					} forEach (_veh getVariable ["A3W_objectTextures", []]);

					_weapons = [];
					_magazines = [];
					_items = [];
					_backpacks = [];

					if (_class call _hasInventory) then
					{
						// Save weapons & ammo
						_weapons = (getWeaponCargo _veh) call cargoToPairs;
						_magazines = _veh call fn_magazineAmmoCargo;
						_items = (getItemCargo _veh) call cargoToPairs;
						_backpacks = (getBackpackCargo _veh) call cargoToPairs;
					};

					_turretMags = magazinesAmmo _veh;
					_turretMags2 = [];
					_turretMags3 = [];
					_hasDoorGuns = isClass (configFile >> "CfgVehicles" >> _class >> "Turrets" >> "RightDoorGun");

					_turrets = allTurrets [_veh, false];

					if !(_class isKindOf "B_Heli_Transport_03_unarmed_F") then
					{
						_turrets = [[-1]] + _turrets; // only add driver turret if not unarmed Huron, otherwise flares get saved twice
					};

					if (_hasDoorGuns) then
					{
						// remove left door turret, because its mags are already returned by magazinesAmmo
						{
							if (_x isEqualTo [1]) exitWith
							{
								_turrets set [_forEachIndex, 1];
							};
						} forEach _turrets;

						_turrets = _turrets - [1];
					};

					{
						_path = _x;

						{
							if ([_turretMags, _x, -1] call fn_getFromPairs == -1 || _hasDoorGuns) then
							{
								if (_veh currentMagazineTurret _path == _x && {count _turretMags3 == 0}) then
								{
									_turretMags3 pushBack [_x, _path, [_veh currentMagazineDetailTurret _path] call getMagazineDetailAmmo];
								}
								else
								{
									_turretMags2 pushBack [_x, _path];
								};
							};
						} forEach (_veh magazinesTurret _path);
					} forEach _turrets;

					_ammoCargo = getAmmoCargo _veh;
					_fuelCargo = getFuelCargo _veh;
					_repairCargo = getRepairCargo _veh;

					// Fix for -1.#IND
					if !(_ammoCargo >= 0) then { _ammoCargo = 0 };
					if !(_fuelCargo >= 0) then { _fuelCargo = 0 };
					if !(_repairCargo >= 0) then { _repairCargo = 0 };

					// Save data

					_vehCount = _vehCount + 1;
					_vehName = format ["Veh%1", _vehCount];

					{
						[_vehFileName, _vehName, _x select 0, _x select 1, false] call PDB_write; // iniDB_write
					}
					forEach
					[
						["Class", _class],
						["Position", _pos],
						["Direction", _dir],
						["HoursAlive", _hoursAlive],
						["HoursUnused", _hoursUnused],
						["Fuel", _fuel],
						["Damage", _damage],
						["HitPoints", _hitPoints],
						["Variables", _variables],
						["Textures", _textures],

						["Weapons", _weapons],
						["Magazines", _magazines],
						["Items", _items],
						["Backpacks", _backpacks],

						["TurretMagazines", _turretMags],
						["TurretMagazines2", _turretMags2],
						["TurretMagazines3", _turretMags3],

						["AmmoCargo", _ammoCargo],
						["FuelCargo", _fuelCargo],
						["RepairCargo", _repairCargo]
					];

					sleep 0.01;
				};
			};
		} forEach allMissionObjects "AllVehicles";

		[_vehFileName, "Info", "VehCount", _vehCount] call PDB_write; // iniDB_write
		diag_log format ["A3W - %1 vehicles have been saved with %2", _vehCount, ["A3W_savingMethodName", "-ERROR-"] call getPublicVar];

		// Reverse-delete old vehicles
		if (_oldVehCount > _vehCount) then
		{
			for "_i" from _oldVehCount to (_vehCount + 1) step -1 do
			{
				[_vehFileName, format ["Veh%1", _i], false] call PDB_deleteSection; // iniDB_deleteSection
			};
		};

		if (_savingMethod == 1) then
		{
			saveProfileNamespace;
			diag_log "A3W - profileNamespace saved";
		};
	};
};
