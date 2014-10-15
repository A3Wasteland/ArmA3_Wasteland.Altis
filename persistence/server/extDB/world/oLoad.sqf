//	@file Version: 1.2
//	@file Name: oLoad.sqf
//	@file Author: JoSchaap, AgentRev, Austerror
//	@file Description: Basesaving load script

if (!isServer) exitWith {};

#include "functions.sqf"

_strToSide =
{
	switch (toUpper _this) do
	{
		case "WEST":  { BLUFOR };
		case "EAST":  { OPFOR };
		case "GUER":  { INDEPENDENT };
		case "CIV":   { CIVILIAN };
		case "LOGIC": { sideLogic };
		default       { sideUnknown };
	};
};

_isWarchestEntry = { [_variables, "a3w_warchest", false] call fn_getFromPairs };
_isBeaconEntry = { [_variables, "a3w_spawnBeacon", false] call fn_getFromPairs };

_maxLifetime = ["A3W_objectLifetime", 0] call getPublicVar;

_savingMethod = ["A3W_savingMethod", 1] call getPublicVar;

_serverObjects = [format["getAllServerObjects:%1", call(A3W_extDB_ServerID)], 2, true] call extDB_Database_async;

_serverObjectsIDs = [];

{
	_db_id = _x select 0;

	_class = _x select 1;
	_pos = _x select 2;
	_hoursAlive = _x select 4;

	if (!isNil "_class" && {!isNil "_pos"} && {_maxLifetime <= 0 || {_hoursAlive < _maxLifetime}}) then
	{
		_variables = _x select 7;

		_allowed = switch (true) do
		{
			case (call _isWarchestEntry):       { _warchestSavingOn };
			case (call _isBeaconEntry):         { _beaconSavingOn };
			case (_class call _isBox):          { _boxSavingOn };
			case (_class call _isStaticWeapon): { _staticWeaponSavingOn };
			default                             { _baseSavingOn };
		};

		if (_allowed) then
		{
			_dir = _x select 3;
			_damage = _x select 5;
			_allowDamage = _x select 6;

			_obj = createVehicle [_class, _pos, [], 0, "CAN_COLLIDE"];
			_obj setPosWorld ATLtoASL _pos;

			if (!isNil "_dir") then
			{
				_obj setVectorDirAndUp _dir;
			};

			_serverObjectsIDs pushBack _db_id;
			_obj setVariable ["db_id", _db_id];
			_obj setVariable ["baseSaving_hoursAlive", _hoursAlive];
			_obj setVariable ["baseSaving_spawningTime", diag_tickTime];
			_obj setVariable ["objectLocked", true, true]; // force lock

			if (_allowDamage > 0) then
			{
				_obj setDamage _damage;
				_obj setVariable ["allowDamage", true];
			}
			else
			{
				_obj allowDamage false;
			};

			clearWeaponCargoGlobal _obj;
			clearMagazineCargoGlobal _obj;
			clearItemCargoGlobal _obj;
			clearBackpackCargoGlobal _obj;

			{
				_var = _x select 0;
				_value = _x select 1;

				switch (_var) do
				{
					case "side": { _value = _value call _strToSide };
					case "R3F_Side": { _value = _value call _strToSide };
				};

				_obj setVariable [_var, _value, true];
			} forEach _variables;

			if (_boxSavingOn && {_class call _isBox}) then
			{
				_weapons = _x select 8;
				_magazines = _x select 9;
				_items = _x select 10;
				_backpacks = _x select 11;
				if (!isNil "_weapons") then
				{
					{ _obj addWeaponCargoGlobal _x } forEach _weapons;
				};
				if (!isNil "_magazines") then
				{
					{ _obj addMagazineCargoGlobal _x } forEach _magazines;
				};
				if (!isNil "_items") then
				{
					{ _obj addItemCargoGlobal _x } forEach _items;
				};
				if (!isNil "_backpacks") then
				{
					{
						if !((_x select 0) isKindOf "Weapon_Bag_Base") then
						{
							_obj addBackpackCargoGlobal _x;
						};
					} forEach _backpacks;
				};
			};

			_unlock = switch (true) do
			{
				case (_obj call _isWarchest): { true };
				case (_obj call _isBeacon):
				{
					pvar_spawn_beacons pushBack _obj;
					publicVariable "pvar_spawn_beacons";
					true
				};
				default { false };
			};

			if (_unlock) exitWith
			{
				_obj setVariable ["objectLocked", false, true];
			};

			if (_staticWeaponSavingOn && {_class call _isStaticWeapon}) then
			{
				_turretMags = _x select 12;

				if (!isNil "_turretMags") then
				{
					_obj setVehicleAmmo 0;
					{ _obj addMagazine _x } forEach _turretMags;
				};
			};

			_ammoCargo = _x select 13;
			_fuelCargo = _x select 14;
			_repairCargo = _x select 15;

			_obj setAmmoCargo _ammoCargo;
			_obj setFuelCargo _fuelCargo;
			_obj setRepairCargo _repairCargo;
		};
	};
} forEach _serverObjects;

if (_warchestMoneySavingOn) then
{
	_serverInfo = [format["getWarchestMoney:%1", call(A3W_extDB_ServerID)], 2] call extDB_Database_async;

	diag_log format ["WAR CHEST MONEY:%1", _serverInfo];

	pvar_warchest_funds_west = _serverInfo select 0;
	publicVariable "pvar_warchest_funds_west";
	pvar_warchest_funds_east = _serverInfo select 1;
	publicVariable "pvar_warchest_funds_east";
};


diag_log format ["A3Wasteland - world persistence loaded %1 objects from %2", count _serverObjectsIDs, ["A3W_savingMethodName", "a rip in the fabric of space-time"] call getPublicVar];

_serverObjectsIDs