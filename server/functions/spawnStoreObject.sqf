//	@file Version: 1.0
//	@file Name: spawnStoreObject.sqf
//	@file Author: AgentRev
//	@file Created: 11/10/2013 22:17
//	@file Args:

if (!isServer) exitWith {};

private ["_player", "_class", "_marker", "_key", "_isGenStore", "_isGunStore", "_isVehStore", "_objectID", "_objectsArray", "_itemEntry", "_itemPrice", "_safePos", "_object"];

_player = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_class = [_this, 1, "", [""]] call BIS_fnc_param;
_marker = [_this, 2, "", [""]] call BIS_fnc_param;
_key = [_this, 3, "", [""]] call BIS_fnc_param;

_isGenStore = ["GenStore", _marker] call fn_startsWith;
_isGunStore = ["GunStore", _marker] call fn_startsWith;
_isVehStore = ["VehStore", _marker] call fn_startsWith;

if (_key != "" && isPlayer _player && {_isGenStore || _isGunStore || _isVehStore}) then
{
	_objectID = "";
	
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
			
			_object = createVehicle [_class, _safePos, [], 0, "None"];
			_objectID = netId _object;

			_object setVariable ["A3W_purchasedStoreObject", true];

			if (getNumber (configFile >> "CfgVehicles" >> _class >> "isUav") > 0) then
			{
				//assign AI to the vehicle so it can actually be used
				createVehicleCrew _object;
				
				waitUntil {!isNull driver _object};
				
				[_object, { {_x setName ["AI","",""]} forEach crew _this }, true, false] spawn fn_vehicleInit;

				//assign AI to player's side to allow terminal connection
				(crew _object) joinSilent (createGroup side _player);
			};
			
			// Spawn remaining calls to speed up delivery confirmation
			[_object, _safePos, _marker] spawn
			{
				_object = _this select 0;
				_safePos = _this select 1;
				_marker = _this select 2;
				
				_isDamageable = ({_object isKindOf _x} count ["AllVehicles", "Lamps_base_F", "Cargo_Patrol_base_F", "Cargo_Tower_base_F"] > 0);
				
				[_object, false] call vehicleSetup;
				_object allowDamage _isDamageable;
				_object setVariable ["allowDamage", _isDamageable];
				
				if (_object isKindOf "AllVehicles" && !(_object isKindOf "StaticWeapon")) then
				{
					_object setPosATL [_safePos select 0, _safePos select 1, 0.05];
					_object setVelocity [0,0,0.01];
					// _object spawn cleanVehicleWreck;
				};
				
				if (_object isKindOf "Plane") then
				{
					_object setDir (markerDir _marker);
				}
				else
				{
					_object setDir (random 360);
				};

				switch (true) do
				{
					case ({_object isKindOf _x} count ["Box_NATO_AmmoVeh_F", "Box_East_AmmoVeh_F", "Box_IND_AmmoVeh_F"] > 0):
					{
						_object setAmmoCargo 5;
					};

					case ({_object isKindOf _x} count ["B_Truck_01_ammo_F", "O_Truck_02_Ammo_F", "O_Truck_03_ammo_F", "I_Truck_02_ammo_F"] > 0):
					{
						_object setAmmoCargo 25;
					};

					case ({_object isKindOf _x} count ["C_Van_01_fuel_F", "I_G_Van_01_fuel_F"] > 0):
					{
						_object setFuelCargo 10;
					};

					case ({_object isKindOf _x} count ["B_Truck_01_fuel_F", "O_Truck_02_fuel_F", "O_Truck_03_fuel_F", "I_Truck_02_fuel_F"] > 0):
					{
						_object setFuelCargo 25;
					};

					case ({_object isKindOf _x} count ["B_Truck_01_Repair_F", "O_Truck_02_box_F", "O_Truck_03_repair_F", "I_Truck_02_box_F"] > 0):
					{
						_object setRepairCargo 25;
					};
				};
			};
		};
	};
	
	// [compile format ["%1 = '%2'", _key, _objectID], "BIS_fnc_spawn", _player, false] call TPG_fnc_MP;
	
	if (isPlayer _player) then
	{
		_player setVariable [_key, _objectID, true];
	}
	else
	{
		deleteVehicle _object;
	};
};
