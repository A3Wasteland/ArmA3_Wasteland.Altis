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
	_diag_tickTime = diag_tickTime; // Doesn't Need to be accurate... once its close enough

	_old_serverObjectsIDs = + _serverObjectsIDs;

	uiSleep 60;
	{
		_obj = _x;
		if (alive _obj) then
		{
			sleep 0.01;

			_db_id = _obj getVariable ["db_id", -1];
			if (_db_id > -2) then // -2 Means Ignore not savableObject, was scanned previously
			{
				_saveableObj = false;
				_updateObj = false;

				_class = typeOf _obj;
				_variables = [];
				_turretMags = [];


				if ((_baseSavingOn && {_class in _saveableObjects})) then
				{
					_saveableObj = true;
					_updateObj = _obj getVariable ["objectLocked", false];
				}
				else
				{
					if (_boxSavingOn && {_class call _isBox}) then
					{
						_saveableObj = true;
						_updateObj = _obj getVariable ["objectLocked", false];

						_variables = [["cmoney", _obj getVariable ["cmoney", 0]]];
					}
					else
					{
						if (_staticWeaponSavingOn && {_class call _isStaticWeapon}) then
						{
							_saveableObj = true;
							_updateObj = _obj getVariable ["objectLocked", false];
							_turretMags = magazinesAmmo _obj;
						}
						else
						{
							if (_beaconSavingOn && {_obj call _isBeacon}) then
							{
								_saveableObj = true;
								_updateObj = true;

								_variables = [	["a3w_spawnBeacon", true],
												["R3F_LOG_disabled", true],
												["side", str (_obj getVariable ["side", sideUnknown])],
												["packing", false],
												["groupOnly", _obj getVariable ["groupOnly", false]],
												["ownerName", _obj getVariable ["ownerName", "[Beacon]"]]
											];
							}
							else
							{
								if (_warchestSavingOn && {_obj call _isWarchest}) then
								{
									_saveableObj = true;
									_updateObj = true;

									_variables = [["a3w_warchest", true],
													["R3F_LOG_disabled", true],
													["side", str (_obj getVariable ["side", sideUnknown])]];
								};
							};
						};
					};
				};

				if (!_saveableObj) exitWith
				{
					_obj setVariable ["db_id", -2];
				};

				if (!_updateObj) exitWith
				{
					//_old_serverObjectsIDs = _old_serverObjectsIDs - [_db_id];
					_obj setVariable ["db_id", nil];
				};

				// Getting Info
				_pos = ASLtoATL getPosWorld _obj;
				_dir = [vectorDir _obj, vectorUp _obj];
				_damage = damage _obj;
				_allowDamage = if (_obj getVariable ["allowDamage", false]) then { 1 } else { 0 };

				_hoursAlive = (_obj getVariable ["baseSaving_hoursAlive", 0]) + ((_diag_tickTime - (_obj getVariable ["baseSaving_spawningTime", _diag_tickTime])) / 3600);


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

				// Don't ask why this seams to work
				//	And no >= is not a mistake just weird behaviour *shrugs*
				_ammoCargo = getAmmoCargo _obj;
				if (_ammoCargo >= 0) then
				{
				} else {_ammoCargo = 0};

				_fuelCargo = getFuelCargo _obj;
				if (_fuelCargo >= 0) then
				{
				} else {_fuelCargo = 0};

				_repairCargo = getRepairCargo _obj;
				if (_repairCargo >= 0) then
				{
				} else {_repairCargo = 0};

				// Save data
				if (_db_id == -1) then
				{
					// Also set in oLoad.sqf
					if (isNil {_obj getVariable "baseSaving_spawningTime"}) then
					{
						_obj setVariable ["baseSaving_spawningTime", diag_tickTime];
					};

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

					_obj setVariable ["db_id", _db_id];
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