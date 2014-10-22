//	@file Version: 1.2
//	@file Name: vLoad.sqf
//	@file Author: JoSchaap, AgentRev, Austerror
//	@file Description: Vehicle saving load script

if (!isServer) exitWith {};

_vehFileName = "Vehicles" call PDB_objectFileName;

_maxLifetime = ["A3W_objectLifetime", 0] call getPublicVar;

_exists = _vehFileName call PDB_exists; // iniDB_exists
_vehCount = 0;

_savingMethod = ["A3W_savingMethod", 1] call getPublicVar;

if (!isNil "_exists" && {_exists}) then
{
	_vehCount = [_vehFileName, "Info", "VehCount", "NUMBER"] call PDB_read; // iniDB_read

	if (!isNil "_vehCount") then
	{
		for "_i" from 1 to _vehCount do
		{
			_vehName = format ["Veh%1", _i];

			_class = [_vehFileName, _vehName, "Class", "STRING"] call PDB_read; // iniDB_read
			_pos = [_vehFileName, _vehName, "Position", "ARRAY"] call PDB_read; // iniDB_read
			_hoursAlive = [_vehFileName, _vehName, "HoursAlive", "NUMBER"] call PDB_read; // iniDB_read

			if (!isNil "_class" && {!isNil "_pos"} && {_maxLifetime <= 0 || {_hoursAlive < _maxLifetime}}) then
			{
				_variables = [_vehFileName, _vehName, "Variables", "ARRAY"] call PDB_read; // iniDB_read
				_dir = [_vehFileName, _vehName, "Direction", "ARRAY"] call PDB_read; // iniDB_read
				_fuel = [_vehFileName, _vehName, "Fuel", "NUMBER"] call PDB_read; // iniDB_read
				_damage = [_vehFileName, _vehName, "Damage", "NUMBER"] call PDB_read; // iniDB_read
				_hitPoints = [_vehFileName, _vehName, "HitPoints", "ARRAY"] call PDB_read; // iniDB_read
				_texture = [_vehFileName, _vehName, "Texture", "STRING"] call PDB_read; // iniDB_read

				{ if (typeName _x == "STRING") then { _pos set [_forEachIndex, parseNumber _x] } } forEach _pos;

				_veh = createVehicle [_class, _pos, [], 0, "CAN_COLLIDE"];
				_veh setPosWorld ATLtoASL _pos;

				if (!isNil "_dir") then
				{
					_veh setVectorDirAndUp _dir;
				};

				_veh setVariable ["vehSaving_hoursAlive", _hoursAlive];
				_veh setVariable ["vehSaving_spawningTime", diag_tickTime];

				_veh setDamage _damage;
				{ _veh setHitPointDamage _x } forEach _hitPoints;

				_veh setFuel _fuel;

				[_veh, _texture] call applyVehicleTexture;

				{ _veh setVariable [_x select 0, _x select 1] } forEach _variables;

				clearWeaponCargoGlobal _veh;
				clearMagazineCargoGlobal _veh;
				clearItemCargoGlobal _veh;
				clearBackpackCargoGlobal _veh;

				_weapons = [_vehFileName, _vehName, "Weapons", "ARRAY"] call PDB_read; // iniDB_read
				_magazines = [_vehFileName, _vehName, "Magazines", "ARRAY"] call PDB_read; // iniDB_read
				_items = [_vehFileName, _vehName, "Items", "ARRAY"] call PDB_read; // iniDB_read
				_backpacks = [_vehFileName, _vehName, "Backpacks", "ARRAY"] call PDB_read; // iniDB_read

				if (!isNil "_weapons") then
				{
					{ _veh addWeaponCargoGlobal _x } forEach _weapons;
				};
				if (!isNil "_magazines") then
				{
					{ _veh addMagazineCargoGlobal _x } forEach _magazines;
				};
				if (!isNil "_items") then
				{
					{ _veh addItemCargoGlobal _x } forEach _items;
				};
				if (!isNil "_backpacks") then
				{
					{
						if !((_x select 0) isKindOf "Weapon_Bag_Base") then
						{
							_veh addBackpackCargoGlobal _x;
						};
					} forEach _backpacks;
				};

				_turretMags = [_vehFileName, _vehName, "TurretMagazines", "ARRAY"] call PDB_read; // iniDB_read
				_turretMags2 = [_vehFileName, _vehName, "TurretMagazines2", "ARRAY"] call PDB_read; // iniDB_read
				_turretMags3 = [_vehFileName, _vehName, "TurretMagazines3", "ARRAY"] call PDB_read; // iniDB_read

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

				_ammoCargo = [_vehFileName, _vehName, "AmmoCargo", "NUMBER"] call PDB_read; // iniDB_read
				_fuelCargo = [_vehFileName, _vehName, "FuelCargo", "NUMBER"] call PDB_read; // iniDB_read
				_repairCargo = [_vehFileName, _vehName, "RepairCargo", "NUMBER"] call PDB_read; // iniDB_read

				if (!isNil "_ammoCargo") then { _veh setAmmoCargo _ammoCargo };
				if (!isNil "_fuelCargo") then { _veh setFuelCargo _fuelCargo };
				if (!isNil "_repairCargo") then { _veh setRepairCargo _repairCargo };

				reload _veh;
			};
		};
	};
};

diag_log format ["A3Wasteland - world persistence loaded %1 vehicles from %2", _vehCount, ["A3W_savingMethodName", "a rip in the fabric of space-time"] call getPublicVar];
