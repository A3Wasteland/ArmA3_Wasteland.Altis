//	@file Version: 1.2
//	@file Name: oSave.sqf
//	@file Author: [GoT] JoSchaap, AgentRev
//	@file Description: Basesaving save script

if (!isServer) exitWith {};

#include "functions.sqf"

_saveableObjects = [];

// Add objectList & general store objects
{
	_obj = _x;
	if (!(_obj isKindOf "ReammoBox_F") && {!(_obj in _saveableObjects)}) then
	{
		_saveableObjects pushBack _obj;
	};
} forEach objectList;

{
	_obj = _x select 1;
	if (!(_obj isKindOf "ReammoBox_F") && {!(_obj in _saveableObjects)}) then
	{
		_saveableObjects pushBack _obj;
	};
} forEach (call genObjectsArray);

// If file doesn't exist, create Info section at the top
if !(_fileName call PDB_exists) then // iniDB_exists
{
	[_fileName, "Info", "ObjCount", 0] call PDB_write; // iniDB_write
};

_savingMethod = ["A3W_savingMethod", 1] call getPublicVar;

while {true} do
{
	uiSleep 60;

	_oldObjCount = [_fileName, "Info", "ObjCount", "NUMBER"] call PDB_read; // iniDB_read
	_objCount = 0;

	{
		_obj = _x;

		if (alive _obj) then
		{
			_class = typeOf _obj;

			if (_obj getVariable ["objectLocked", false] &&
			       {(_baseSavingOn && {_class in _saveableObjects}) ||
				    (_boxSavingOn && {_class call _isBox}) ||
					(_staticWeaponSavingOn && {_class call _isStaticWeapon})} ||
			   {_warchestSavingOn && {_obj call _isWarchest}} ||
			   {_beaconSavingOn && {_obj call _isBeacon}}) then
			{
				_netId = netId _obj;
				_pos = ASLtoATL getPosWorld _obj;
				_dir = [vectorDir _obj, vectorUp _obj];
				_damage = damage _obj;
				_allowDamage = if (_obj getVariable ["allowDamage", false]) then { 1 } else { 0 };

				if (isNil {_obj getVariable "baseSaving_spawningTime"}) then
				{
					_obj setVariable ["baseSaving_spawningTime", diag_tickTime];
				};

				_hoursAlive = (_obj getVariable ["baseSaving_hoursAlive", 0]) + ((diag_tickTime - (_obj getVariable "baseSaving_spawningTime")) / 3600);

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


	if (["A3W_warchestMoneySaving"] call isConfigOn) then
	{
		_fundsWest = ["pvar_warchest_funds_west", 0] call getPublicVar;
		_fundsEast = ["pvar_warchest_funds_east", 0] call getPublicVar;
		[_fileName, "Info", "WarchestMoneyBLUFOR", _fundsWest] call PDB_write; // iniDB_write
		[_fileName, "Info", "WarchestMoneyOPFOR", _fundsEast] call PDB_write; // iniDB_write
	};

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
};