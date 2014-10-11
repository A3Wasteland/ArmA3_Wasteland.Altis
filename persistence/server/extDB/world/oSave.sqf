//	@file Version: 1.2
//	@file Name: oSave.sqf
//	@file Author: [GoT] JoSchaap, AgentRev
//	@file Description: Basesaving save script

if (!isServer) exitWith {};

#include "functions.sqf"

_serverObjectsIDs = _this select 0;
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


while {true} do
{
	_old_serverObjectsIDs = + _serverObjectsIDs;

	uiSleep 60;
	{
		_obj = _x;

		if (alive _obj) then
		{
			_class = typeOf _obj;
			_db_id = _obj getVariable ["db_id", -1];

			if ( true &&
				 {(_baseSavingOn && {_class in _saveableObjects}) ||
					 (_boxSavingOn && {_class call _isBox}) ||
					 (_staticWeaponSavingOn && {_class call _isStaticWeapon})} ||
			     {_warchestSavingOn && {_obj call _isWarchest}} ||
			     {_beaconSavingOn && {_obj call _isBeacon}}) then
			{

				if (_obj getVariable ["objectLocked", false]) then
				{
					//_netId = netId _obj;
					_pos = getPosATL _obj;
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
					diag_log format ["DEBUG SAVE OBJECT ID: %1", _db_id];
					if (_db_id == -1) then
					{
						_db_id = (["insertServerObject:" +
										str(call(A3W_extDB_ServerID)) + ":" +
										str(_class) + ":" +
										str(_pos) + ":" +
										str(_dir) + ":" +
										str(_hoursAlive) + ":" +
										str(_damage) + ":" +
										str(_allowDamage) + ":" +
										str(_variables) + ":" +
										str(_weapons) + ":" +
										str(_magazines) + ":" +
										str(_items) + ":" +
										str(_backpacks) + ":" +
										str(_turretmags) + ":" +
										str(_ammoCargo) + ":" +
										str(_fuelCargo) + ":" +
										str(_repairCargo),2] call extDB_Database_async) select 0;

						_db_saved = _obj setVariable ["db_id", _db_id];
						_serverObjectsIDs pushBack _db_id;
					}
					else
					{
						["updateServerObject:" +
										str(_db_id) + ":" +
										str(_pos) + ":" +
										str(_dir) + ":" +
										str(_hoursAlive) + ":" +
										str(_damage) + ":" +
										str(_allowDamage) + ":" +
										str(_variables) + ":" +
										str(_weapons) + ":" +
										str(_magazines) + ":" +
										str(_items) + ":" +
										str(_backpacks) + ":" +
										str(_turretmags) + ":" +
										str(_ammoCargo) + ":" +
										str(_fuelCargo) + ":" +
										str(_repairCargo)] call extDB_Database_async;

						_old_serverObjectsIDs = _old_serverObjectsIDs - [_db_id];
					};
				}
				else
				{
					_old_serverObjectsIDs = _old_serverObjectsIDs - [_db_id];
				};
				sleep 0.01;
			};
		};
	} forEach allMissionObjects "All";

	{
		[format["deleteServerObject:%1", _x]] call extDB_Database_async;
		_serverObjectsIDs = _serverObjectsIDs - [_x];
	} forEach _old_serverObjectsIDs;

	if (["A3W_warchestMoneySaving"] call isConfigOn) then
	{
		_fundsWest = ["pvar_warchest_funds_west", 0] call getPublicVar;
		_fundsEast = ["pvar_warchest_funds_east", 0] call getPublicVar;
		["updateWarchestMoney:" + str(call(A3W_extDB_ServerID)) + ":" +  str(_fundsWest) + ":" + str(_fundsEast)] call extDB_Database_async;
	};

	diag_log format ["A3W - %1 baseparts and objects have been saved with %2", count(_serverObjectsIDs), ["A3W_savingMethodName", "-ERROR-"] call getPublicVar];
};