// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: oLoad.sqf
//	@file Author: AgentRev, JoSchaap, Austerror

#include "functions.sqf"
#define STR_TO_SIDE(VAL) ([sideUnknown,BLUFOR,OPFOR,INDEPENDENT,CIVILIAN,sideLogic] select ((["WEST","EAST","GUER","CIV","LOGIC"] find toUpper (VAL)) + 1))

private ["_maxLifetime", "_isWarchestEntry", "_isBeaconEntry", "_worldDir", "_methodDir", "_objCount", "_objects", "_exclObjectIDs"];

_maxLifetime = ["A3W_objectLifetime", 0] call getPublicVar;

_isWarchestEntry = { [_variables, "a3w_warchest", false] call fn_getFromPairs };
_isBeaconEntry = { [_variables, "a3w_spawnBeacon", false] call fn_getFromPairs };

_worldDir = "persistence\server\world";
_methodDir = format ["%1\%2", _worldDir, call A3W_savingMethodDir];

_objCount = 0;
_objects = call compile preprocessFileLineNumbers format ["%1\getObjects.sqf", _methodDir];

_exclObjectIDs = [];

{
	private ["_allowed", "_obj", "_objectID", "_class", "_pos", "_dir", "_locked", "_damage", "_allowDamage", "_owner", "_variables", "_weapons", "_magazines", "_items", "_backpacks", "_turretMags", "_ammoCargo", "_fuelCargo", "_repairCargo", "_hoursAlive", "_valid"];

	//{ (_x select 1) call compile format ["%1 = _this", _x select 0] } forEach _x;
	[] params _x; // automagic assignation

	if (isNil "_locked") then { _locked = 1 };
	if (isNil "_hoursAlive") then { _hoursAlive = 0 };
	_valid = false;

	if (!isNil "_class" && !isNil "_pos" && {_maxLifetime <= 0 || _hoursAlive < _maxLifetime}) then
	{
		if (isNil "_variables") then { _variables = [] };

		_allowed = switch (true) do
		{
			case (call _isWarchestEntry):       { _warchestSavingOn };
			case (call _isBeaconEntry):         { _beaconSavingOn };
			case (_class call _isBox):          { _boxSavingOn };
			case (_class call _isStaticWeapon): { _staticWeaponSavingOn };
			default                             { _baseSavingOn };
		};

		if (!_allowed) exitWith {};

		_objCount = _objCount + 1;
		_valid = true;

		{ if (typeName _x == "STRING") then { _pos set [_forEachIndex, parseNumber _x] } } forEach _pos;

		_obj = createVehicle [_class, _pos, [], 0, "None"];
		_obj allowDamage false;
		_obj hideObjectGlobal true;
		_obj setPosWorld ATLtoASL _pos;

		if (!isNil "_dir") then
		{
			_obj setVectorDirAndUp _dir;
		};

		[_obj, false] call vehicleSetup;
		[_obj] call basePartSetup;

		if (!isNil "_objectID") then
		{
			_obj setVariable ["A3W_objectID", _objectID, true];
			_obj setVariable ["A3W_objectSaved", true, true];
			A3W_objectIDs pushBack _objectID;
		};

		_obj setVariable ["baseSaving_hoursAlive", _hoursAlive];
		_obj setVariable ["baseSaving_spawningTime", diag_tickTime];
		_obj setVariable ["objectLocked", true, true]; // force lock

		if (_allowDamage > 0) then
		{
			_obj allowDamage true;
			_obj setDamage _damage;
			_obj setVariable ["allowDamage", true, true];
		}
		else
		{
			_obj setVariable ["allowDamage", false, true];
		};

		if (!isNil "_owner") then
		{
			_obj setVariable ["ownerUID", _owner, true];
		};

		private _uavSide = if (isNil "_playerSide") then { sideUnknown } else { _playerSide };
		private _uavAuto = true;

		{
			_var = _x select 0;
			_value = _x select 1;

			switch (_var) do
			{
				case "side": { _value = _value call _strToSide };
				case "cmoney": { if (_value isEqualType "") then { _value = parseNumber _value } };
				case "R3F_Side": { _value = _value call _strToSide };
				case "ownerName":
				{
					switch (typeName _value) do
					{
						case "ARRAY": { _value = toString _value };
						case "STRING":
						{
							if (_savingMethod == "iniDB") then
							{
								_value = _value call iniDB_Base64Decode;
							};
						};
						default { _value = "[Beacon]" };
					};
				};
				case "uavSide":
				{
					if (_uavSide isEqualTo sideUnknown) then { _uavSide = STR_TO_SIDE(_value) };
				};
				case "uavAuto":
				{
					if (_value isEqualType true) then
					{
						_uavAuto = _value;
					};
				};
			};

			_obj setVariable [_var, _value, true];
		} forEach _variables;

		if (unitIsUAV _obj) then
		{
			[_obj, _uavSide, false, _uavAuto] spawn fn_createCrewUAV;
		};

		clearWeaponCargoGlobal _obj;
		clearMagazineCargoGlobal _obj;
		clearItemCargoGlobal _obj;
		clearBackpackCargoGlobal _obj;

		_unlock = switch (true) do
		{
			case (_obj call _isWarchest): { true };
			case (_obj call _isBeacon):
			{
				pvar_spawn_beacons pushBack _obj;
				publicVariable "pvar_spawn_beacons";
				true
			};
			case (_locked < 1): { true };
			default { false };
		};

		if (_unlock) then
		{
			_obj setVariable ["objectLocked", false, true];
		}
		else
		{
			if (_boxSavingOn && {_class call _isBox}) then
			{
				if (!isNil "_weapons") then
				{
					{ _obj addWeaponCargoGlobal _x } forEach _weapons;
				};
				if (!isNil "_magazines") then
				{
					[_obj, _magazines] call processMagazineCargo;
				};
				if (!isNil "_items") then
				{
					{ _obj addItemCargoGlobal _x } forEach _items;
				};
				if (!isNil "_backpacks") then
				{
					{
						_bpack = _x select 0;

						if (!(_bpack isKindOf "Weapon_Bag_Base") || {[["_UAV_","_Designator_"], _bpack] call fn_findString != -1}) then
						{
							_obj addBackpackCargoGlobal _x;
						};
					} forEach _backpacks;
				};
			};

			if (!isNil "_turretMags" && _staticWeaponSavingOn && {_class call _isStaticWeapon}) then
			{
				_obj setVehicleAmmo 0;
				{ _obj removeMagazineTurret [_x select 0, _x select 1] } forEach magazinesAllTurrets _obj;
				{ _obj addMagazine _x } forEach _turretMags;
			};

			if (!isNil "_ammoCargo") then { _obj setAmmoCargo _ammoCargo };
			if (!isNil "_fuelCargo") then { _obj setFuelCargo _fuelCargo };
			if (!isNil "_repairCargo") then { _obj setRepairCargo _repairCargo };

			reload _obj;
		};

		_obj hideObjectGlobal false;
	};

	if (!_valid && !isNil "_objectID") then
	{
		if (!isNil "_obj") then
		{
			_obj setVariable ["A3W_objectID", nil, true];
		};

		_exclVehicleIDs pushBack _vehicleID;
		_exclObjectIDs pushBack _objectID;
	};
} forEach _objects;

if (_warchestMoneySavingOn) then
{
	_amounts = call compile preprocessFileLineNumbers format ["%1\getWarchestMoney.sqf", _methodDir];

	pvar_warchest_funds_west = (_amounts select 0) max 0;
	publicVariable "pvar_warchest_funds_west";
	pvar_warchest_funds_east = (_amounts select 1) max 0;
	publicVariable "pvar_warchest_funds_east";
};

diag_log format ["A3Wasteland - world persistence loaded %1 objects from %2", _objCount, call A3W_savingMethodName];

_exclObjectIDs call fn_deleteObjects;
