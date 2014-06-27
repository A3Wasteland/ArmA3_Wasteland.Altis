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

_exists = _fileName call iniDB_exists;
_objectsCount = 0;

if (!isNil "_exists" && {_exists}) then
{
	_objectsCount = [_fileName, "Info", "ObjCount", "NUMBER"] call iniDB_read;
	
	if (!isNil "_objectsCount") then
	{
		for "_i" from 1 to _objectsCount do
		{
			_objName = format ["Obj%1", _i];
			
			_class = [_fileName, _objName, "Class", "STRING"] call iniDB_read;
			_pos = [_fileName, _objName, "Position", "ARRAY"] call iniDB_read;
			_hoursAlive = [_fileName, _objName, "HoursAlive", "NUMBER"] call iniDB_read;
			
			if (!isNil "_class" && {!isNil "_pos"} && {_maxLifetime <= 0 || {_hoursAlive < _maxLifetime}}) then 
			{
				_variables = [_fileName, _objName, "Variables", "ARRAY"] call iniDB_read;
				
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
					_dir = [_fileName, _objName, "Direction", "ARRAY"] call iniDB_read;
					_damage = [_fileName, _objName, "Damage", "NUMBER"] call iniDB_read;
					_allowDamage = [_fileName, _objName, "AllowDamage", "NUMBER"] call iniDB_read;
					
					_obj = createVehicle [_class, _pos, [], 0, "CAN_COLLIDE"];
					_obj setPosATL _pos;
					
					if (!isNil "_dir") then
					{
						_obj setVectorDirAndUp _dir;
					};
					
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
					
					{
						_var = _x select 0;
						_value = _x select 1;
						
						switch (_var) do
						{
							case "side": { _value = _value call _strToSide };
							case "ownerName": { _value = _value call iniDB_Base64Decode };
						};
						
						_obj setVariable [_var, _value, true];
					} forEach _variables;
					
					clearWeaponCargoGlobal _obj;
					clearMagazineCargoGlobal _obj;
					clearItemCargoGlobal _obj;
					clearBackpackCargoGlobal _obj;
					
					_unlock = switch (true) do
					{
						case (_obj call _isWarchest): { true };
						case (_obj call _isBeacon):
						{
							[pvar_spawn_beacons, _obj] call BIS_fnc_arrayPush;
							publicVariable "pvar_spawn_beacons";
							true
						};
						default { false };
					};
					
					if (_unlock) exitWith
					{
						_obj setVariable ["objectLocked", false, true];
					};
					
					if (_boxSavingOn && {_class call _isBox}) then
					{
						_weapons = [_fileName, _objName, "Weapons", "ARRAY"] call iniDB_read;
						_magazines = [_fileName, _objName, "Magazines", "ARRAY"] call iniDB_read;
						_items = [_fileName, _objName, "Items", "ARRAY"] call iniDB_read;
						_backpacks = [_fileName, _objName, "Backpacks", "ARRAY"] call iniDB_read;
						
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
					
					if (_staticWeaponSavingOn && {_class call _isStaticWeapon}) then
					{
						_turretMags = [_fileName, _objName, "TurretMagazines", "ARRAY"] call iniDB_read;
						
						if (!isNil "_turretMags") then
						{
							_obj setVehicleAmmo 0;
							{ _obj addMagazine _x } forEach _turretMags;
						};
					};
				};
			};
		};
	};
	
	if (_warchestMoneySavingOn) then
	{
		pvar_warchest_funds_west = ([_fileName, "Info", "WarchestMoneyBLUFOR", "NUMBER"] call iniDB_read) max 0;
		publicVariable "pvar_warchest_funds_west";
		pvar_warchest_funds_east = ([_fileName, "Info", "WarchestMoneyOPFOR", "NUMBER"] call iniDB_read) max 0;
		publicVariable "pvar_warchest_funds_east";
	};
};

diag_log format ["A3Wasteland - world persistence loaded %1 objects from iniDB", _objectsCount];

execVM "persistence\world\oSave.sqf";
