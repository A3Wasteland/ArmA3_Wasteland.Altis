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
	private _playerGroup = group _player;
	_playerSide = side _playerGroup;

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

	if (!isNil "_itemEntry" && markerShape _marker != "") then
	{
		_itemPrice = _itemEntry select 2;
		_skipSave = "SKIPSAVE" in (_itemEntry select [3,999]);

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
			_object setVariable ["ownerName", name _player, true];

			private _isUAV = (round getNumber (configFile >> "CfgVehicles" >> _class >> "isUav") > 0);

			if (_isUAV) then
			{
				createVehicleCrew _object;

				//assign AI to the vehicle so it can actually be used
				[_object, _playerSide, _playerGroup] spawn
				{
					params ["_uav", "_playerSide", "_playerGroup"];

					_grp = [_uav, _playerSide] call fn_createCrewUAV;

					if (isNull (_uav getVariable ["ownerGroupUAV", grpNull])) then
					{
						_uav setVariable ["ownerGroupUAV", _playerGroup, true]; // not currently used
					};
				};
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
				// _object spawn cleanVehicleWreck;
				_object setVariable ["A3W_purchasedVehicle", true, true];

				if (["A3W_vehicleLocking"] call isConfigOn && !_isUAV) then
				{
					[_object, 2] call A3W_fnc_setLockState; // Lock
				};
			};

			_object setDir (if (_object isKindOf "Plane") then { markerDir _marker } else { random 360 });

			_isDamageable = !(_object isKindOf "ReammoBox_F"); // ({_object isKindOf _x} count ["AllVehicles", "Lamps_base_F", "Cargo_Patrol_base_F", "Cargo_Tower_base_F"] > 0);

			[_object] call vehicleSetup;
			_object allowDamage _isDamageable;
			_object setVariable ["allowDamage", _isDamageable, true];

			clearBackpackCargoGlobal _object;

			// don't need this anymore at all
			/*switch (true) do
			{
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
			};*/

			if (_skipSave) then
			{
				_object setVariable ["A3W_skipAutoSave", true, true];
			}
			else
			{
				if (_object getVariable ["A3W_purchasedVehicle", false] && !isNil "fn_manualVehicleSave") then
				{
					_object call fn_manualVehicleSave;
				};
			};

			if (_object isKindOf "AllVehicles") then
			{
				if (isNull group _object) then
				{
					_object setOwner owner _player; // tentative workaround for exploding vehicles
				}
				else
				{
					(group _object) setGroupOwner owner _player;
				};
			};
		};
	};
};
