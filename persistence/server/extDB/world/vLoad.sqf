// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: vLoad.sqf
//	@file Author: JoSchaap, AgentRev, Austerror, Lodac
//	@file Description: Vehicle saving load script

if (!isServer) exitWith {};

#include "functions.sqf"

_maxLifetime = ["A3W_vehicleLifetime", 0] call getPublicVar;
_maxUnusedTime = ["A3W_vehicleMaxUnusedTime", 0] call getPublicVar;

_savingMethod = ["A3W_savingMethod", 1] call getPublicVar;

_serverVehicles = [format["getAllServerVehicles:%1", call(A3W_extDB_ServerID)], 2, true] call extDB_Database_async;

_serverVehiclesIDs = [];

{
	_vdb_id = _x select 0;
	_serverVehiclesIDs pushBack _vdb_id;
	_class = _x select 1;
	_pos = _x select 2;
	_hoursAlive = _x select 4;

	if (!isNil "_class" && !isNil "_pos" && {(_maxLifetime <= 0 || _hoursAlive < _maxLifetime)/* && (_maxUnusedTime <= 0 || _hoursUnused < _maxUnusedTime*/}) then
	{
		_variables = _x select 8;
		_dir = _x select 3;
		_fuel = _x select 5;
		_damage = _x select 6;
		_hitPoints = _x select 7;
		_textures = _x select 9;
		{ if (typeName _x == "STRING") then { _pos set [_forEachIndex, parseNumber _x] } } forEach _pos;

		_veh = createVehicle [_class, _pos, [], 0, "None"];
		_veh setPosWorld ATLtoASL _pos;
		
		if (!isNil "_dir") then
		{
			_veh setVectorDirAndUp _dir;
		};

		[_veh] call vehicleSetup;

		_veh setVariable ["vehSaving_hoursAlive", _hoursAlive];
		_veh setVariable ["vehSaving_spawningTime", diag_tickTime];
		_veh setVariable ["vehSaving_lastUse", diag_tickTime];		
		_veh setVariable ["vdb_id", _vdb_id];
		
		_veh setDamage _damage;
		{ _veh setHitPointDamage _x } forEach _hitPoints;

		_veh setFuel _fuel;

		if (!isNil "_textures" && _textures != "") then
		{
			/*_veh setVariable ["BIS_enableRandomization", false, true];

			_objTextures = [];
			{
				_texture = _x select 0;
				{
					_veh setObjectTextureGlobal [_x, _texture];
					[_objTextures, _x, _texture] call fn_setToPairs;
				} forEach (_x select 1);
			} forEach _textures;*/
			
			[_veh, _textures] call applyVehicleTexture;
			_veh setVariable ["Texture", _texture, true];
			

			//_veh setVariable ["A3W_objectTextures", _objTextures, true];
		};

		{ _veh setVariable [_x select 0, _x select 1] } forEach _variables;

		clearWeaponCargoGlobal _veh;
		clearMagazineCargoGlobal _veh;
		clearItemCargoGlobal _veh;
		clearBackpackCargoGlobal _veh;

		_weapons = _x select 10;
		_magazines = _x select 11;
		_items = _x select 12;
		_backpacks = _x select 13;
		
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

		_turretMags = _x select 14;
		_turretMags2 = _x select 15;
		_turretMags3 = _x select 16;

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


		_ammoCargo = _x select 17;
		_fuelCargo = _x select 18;
		_repairCargo = _x select 19;

		if (!isNil "_ammoCargo") then { _veh setAmmoCargo _ammoCargo };
		if (!isNil "_fuelCargo") then { _veh setFuelCargo _fuelCargo };
		if (!isNil "_repairCargo") then { _veh setRepairCargo _repairCargo };

		reload _veh;
	};
} forEach _serverVehicles;

diag_log format ["A3Wasteland - world persistence loaded %1 vehicles from %2", count _serverVehicles, ["A3W_savingMethodName", "a rip in the fabric of space-time"] call getPublicVar];

_serverVehiclesIDs