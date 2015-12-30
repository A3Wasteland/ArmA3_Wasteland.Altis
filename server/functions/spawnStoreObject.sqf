// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: spawnStoreObject.sqf
//	@file Author: AgentRev
//	@file Created: 11/10/2013 22:17
//	@file Args:

if (!isServer) exitWith {};

scopeName "spawnStoreObject";
private ["_player", "_class", "_marker", "_key", "_isGenStore", "_isGunStore", "_isVehStore", "_timeoutKey", "_objectID", "_playerSide", "_objectsArray", "_itemEntry", "_itemPrice", "_safePos", "_object"];

_player = param [0, objNull, [objNull]];
_class = param [1, "", [""]];
_marker = param [2, "", [""]];
_key = param [3, "", [""]];

_isGenStore = ["GenStore", _marker] call fn_startsWith;
_isGunStore = ["GunStore", _marker] call fn_startsWith;
_isVehStore = ["VehStore", _marker] call fn_startsWith;

if (_key != "" && isPlayer _player && {_isGenStore || _isGunStore || _isVehStore}) then
{
	_timeoutKey = _key + "_timeout";
	_objectID = "";
	_playerSide = side group _player;

	if (_isGenStore || _isGunStore) then
	{
		_marker = _marker + "_objSpawn";

		switch (true) do
		{
			case _isGenStore: { _objectsArray = genObjectsArray };
			case _isGunStore: { _objectsArray = staticGunsArray };
		};

		if (!isNil "_objectsArray") then
		{
			{
				if (_class == _x select 1) exitWith
				{
					_itemEntry = _x;
				};
			} forEach (call _objectsArray);
		};
	};

	if (_isVehStore) then
	{
		// LAND VEHICLES
		{
			{
				if (_class == _x select 1) exitWith
				{
					_itemEntry = _x;
					_marker = _marker + "_landSpawn";
				};
			} forEach (call _x);
		} forEach [landArray, armoredArray, tanksArray];

		// SEA VEHICLES
		if (isNil "_itemEntry") then
		{
			{
				if (_class == _x select 1) exitWith
				{
					_itemEntry = _x;
					_marker = _marker + "_seaSpawn";
				};
			} forEach (call boatsArray);
		};

		// HELICOPTERS
		if (isNil "_itemEntry") then
		{
			{
				if (_class == _x select 1) exitWith
				{
					_itemEntry = _x;
					_marker = _marker + "_heliSpawn";
				};
			} forEach (call helicoptersArray);
		};

		// AIRPLANES
		if (isNil "_itemEntry") then
		{
			{
				if (_class == _x select 1) exitWith
				{
					_itemEntry = _x;
					_marker = _marker + "_planeSpawn";
				};
			} forEach (call planesArray);
		};
	};

	if (!isNil "_itemEntry" && {{_x == _marker} count allMapMarkers > 0}) then
	{
		_itemPrice = _itemEntry select 2;

		/*if (_class isKindOf "Box_NATO_Ammo_F") then
		{
			switch (side _player) do
			{
				case OPFOR:       { _class = "Box_East_Ammo_F" };
				case INDEPENDENT: { _class = "Box_IND_Ammo_F" };
			};
		};*/

		if (_player getVariable ["cmoney", 0] >= _itemPrice) then
		{
			_safePos = (markerPos _marker) findEmptyPosition [0, 50, _class];
			if (count _safePos == 0) then { _safePos = markerPos _marker };

			if (_player getVariable [_timeoutKey, true]) then { breakOut "spawnStoreObject" }; // Timeout

			_object = createVehicle [_class, _safePos, [], 0, "None"];

			if (_player getVariable [_timeoutKey, true]) then // Timeout
			{
				deleteVehicle _object;
				breakOut "spawnStoreObject";
			};

			_objectID = netId _object;
			_object setVariable ["A3W_purchasedStoreObject", true];
			_object setVariable ["ownerUID", getPlayerUID _player, true];
			_object setVariable ["R3F_LOG_Disabled", false, true];

			if (getNumber (configFile >> "CfgVehicles" >> _class >> "isUav") > 0) then
			{
				//assign AI to the vehicle so it can actually be used
				createVehicleCrew _object;

				[_object, _playerSide] spawn
				{
					_veh = _this select 0;
					_side = _this select 1;

					waitUntil {!isNull driver _veh};

					//assign AI to player's side to allow terminal connection
					(crew _veh) joinSilent createGroup _side;

					{
						[[_x, ["AI","",""]], "A3W_fnc_setName", true] call A3W_fnc_MP;
					} forEach crew _veh;
				};
			};
			
			if (_class isKindOf "Plane") then
			{
				{
					if (["CMFlare", _x] call fn_findString != -1) then
					{
						_object removeMagazinesTurret [_x, [-1]];
					};
				} forEach getArray (configFile >> "CfgVehicles" >> _class >> "magazines");

				_object addMagazineTurret ["60Rnd_CMFlare_Chaff_Magazine", [-1]];
			};

			if (isPlayer _player && !(_player getVariable [_timeoutKey, true])) then
			{
				_player setVariable [_key, _objectID, true];
			}
			else // Timeout
			{
				if (!isNil "_object") then { deleteVehicle _object };
				breakOut "spawnStoreObject";
			};

			if (_object isKindOf "AllVehicles" && !(_object isKindOf "StaticWeapon")) then
			{
				_object setPosATL [_safePos select 0, _safePos select 1, 0.05];
				_object setVelocity [0,0,0.01];
				_object engineOn true; // Lets already turn the engine one to see if it fixes exploding vehicles.
				_object lock 2; // Spawn vehicles in locked
				_object setVariable ["R3F_LOG_disabled", true, true]; // Spawn vehicles in locked
				// _object spawn cleanVehicleWreck;
				_object setVariable ["A3W_purchasedVehicle", true, true];
			};

			_object setDir (if (_object isKindOf "Plane") then { markerDir _marker } else { random 360 });

			_isDamageable = !(_object isKindOf "ReammoBox_F");// || _object isKindOf "Land_InfoStand_V2_F"); // ({_object isKindOf _x} count ["AllVehicles", "Lamps_base_F", "Cargo_Patrol_base_F", "Cargo_Tower_base_F"] > 0);

			[_object, false] call vehicleSetup;
			_object allowDamage _isDamageable;
			_object setVariable ["allowDamage", _isDamageable, true];

			switch (true) do
			{
				// Add default password to baselocker, safe and doorlocks.
				case ({_object isKindOf _x} count ["Land_InfoStand_V2_F", "Land_Device_assembled_F", "Box_NATO_AmmoVeh_F"] > 0):
				{
					_object setVariable ["password", "0000", true];
				};

				// Add food to bought food sacks.
				case ({_object isKindOf _x} count ["Land_Sacks_goods_F"] > 0):
				{
					_object setVariable ["food", 50, true];
				};
				
				// Add water to bought water barrels.
				case ({_object isKindOf _x} count ["Land_BarrelWater_F"] > 0):
				{
					_object setVariable ["water", 50, true];
				};

				case ({_object isKindOf _x} count ["Box_NATO_AmmoVeh_F", "Box_East_AmmoVeh_F", "Box_IND_AmmoVeh_F"] > 0):
				{
					_object setAmmoCargo 5;
				};

				case (_object isKindOf "O_Heli_Transport_04_ammo_F"):
				{
					_object setAmmoCargo 10;
				};

				case ({_object isKindOf _x} count ["B_Truck_01_ammo_F", "O_Truck_02_Ammo_F", "O_Truck_03_ammo_F", "I_Truck_02_ammo_F"] > 0):
				{
					_object setAmmoCargo 25;
				};

				case ({_object isKindOf _x} count ["C_Van_01_fuel_F", "I_G_Van_01_fuel_F", "O_Heli_Transport_04_fuel_F"] > 0):
				{
					_object setFuelCargo 10;
				};

				case ({_object isKindOf _x} count ["B_Truck_01_fuel_F", "O_Truck_02_fuel_F", "O_Truck_03_fuel_F", "I_Truck_02_fuel_F"] > 0):
				{
					_object setFuelCargo 25;
				};

				case (_object isKindOf "Offroad_01_repair_base_F"):
				{
					_object setRepairCargo 5;
				};

				case (_object isKindOf "O_Heli_Transport_04_repair_F"):
				{
					_object setRepairCargo 10;
				};

				case ({_object isKindOf _x} count ["B_Truck_01_Repair_F", "O_Truck_02_box_F", "O_Truck_03_repair_F", "I_Truck_02_box_F"] > 0):
				{
					_object setRepairCargo 25;
				};
			};

			if (_object getVariable ["A3W_purchasedVehicle", false] && !isNil "fn_manualVehicleSave") then
			{
				_object call fn_manualVehicleSave;
			};
		};
	};
};
