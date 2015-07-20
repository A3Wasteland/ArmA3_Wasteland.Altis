// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_resupplyTruck.sqf
//	@file Author: Wiking, AgentRev

#define RESUPPLY_TRUCK_DISTANCE 20
#define REARM_TIME_SLICE 10
#define REPAIR_TIME_SLICE 1
#define REFUEL_TIME_SLICE 1
#define PRICE_RELATIONSHIP 4

// Check if mutex lock is active.
if (mutexScriptInProgress) exitWith
{
	["You are already performing another action.", 5] call mf_notify_client;
};

mutexScriptInProgress = true;

_truck = _this select 0;
_unit = _this select 1;
_vehicle = vehicle _unit;

//check if caller is not in vehicle
if (_vehicle == _unit) exitWith {};

//set up prices
_vehClass = typeOf _vehicle;
_price = 50000; // price = 1000 for vehicles not found in vehicle store. (e.g. Static Weapons)

{
	if (_vehClass == _x select 1) exitWith
	{
		_price = (ceil (((_x select 2) / PRICE_RELATIONSHIP) / 5)) * 5;
	};
} forEach (call allVehStoreVehicles + call staticGunsArray);

_text = format ["Stop engine in 10s to start resupply. Cost for service is $%1 for this vehicle. This will take some time.\nYou can always abort by getting out of the vehicle.", _price];
[_text, 5] call mf_notify_client;

uiSleep 10;

if (isEngineOn _vehicle) exitWith
{
	["Engine still running. Service CANCELLED!", 5] call mf_notify_client;
	mutexScriptInProgress = false;
};

/*
if ((!isnull (gunner _vehicle)) && !(_vehicle isKindOf "StaticWeapon")) then {
	_vehicle vehicleChat format ["Gunner must be out of seat for service! Get gunner out in 20s."];
	sleep 10;
	_vehicle vehicleChat format ["Gunner must be out of seat for service! Get gunner out in 10s."];
	sleep 10;
	if (!isnull (gunner _vehicle)) exitWith
	{
		_vehicle vehicleChat format ["Gunner still inside. Service CANCELED!"];
		mutexScriptInProgress = false;
	};
};
*/

_resupplyThread = [_truck, _unit, _vehicle, _price] spawn
{
	_truck = _this select 0;
	_unit = _this select 1;
	_vehicle = _this select 2;
	_price = _this select 3;

	_vehClass = typeOf _vehicle;
	_vehCfg = configFile >> "CfgVehicles" >> _vehClass;
	_vehName = getText (_vehCfg >> "displayName");

	scopeName "fn_resupplyTruck";

	_titleText =
	{
		if (vehicle _unit == _vehicle) then
		{
			titleText [_this, "PLAIN DOWN", ((REARM_TIME_SLICE max 1) / 10) max 1];
		}
		else
		{
			titleText ["", "PLAIN"];
		};
	};

	_checkAbortConditions =
	{
		// Abort everything if vehicle is no longer local, otherwise commands won't do anything
		if (!local _vehicle) then
		{
			_crew = crew _vehicle;
			_text = format ["Vehicle resupply aborted by %1", if (count _crew > 0 && !isStreamFriendlyUIEnabled) then { name (_crew select 0) } else { "another player" }];
			[_text, 5] call mf_notify_client;
			mutexScriptInProgress = false;
			breakOut "fn_resupplyTruck";
		};

		// Abort everything if truck not in proximity or player gets out of vehicle
		if (_vehicle distance _truck > RESUPPLY_TRUCK_DISTANCE || vehicle _unit != _vehicle) then
		{
			if (_started) then { ["Vehicle resupply aborted", 5] call mf_notify_client };
			mutexScriptInProgress = false;
			breakOut "fn_resupplyTruck";
		};
	};

	_started = false;
	call _checkAbortConditions;
	_started = true;

	//Add cost for resupply
	_playerMoney = player getVariable ["bmoney", 0];

	if (_playerMoney < _price) exitWith
	{
		_text = format ["Not enough money in your BANK! You need $%1 to resupply %2. Service cancelled!", _price call fn_numbersText, _vehName];
		[_text, 10] call mf_notify_client;
		mutexScriptInProgress = false;
	};

	//start resupply here
	player setVariable ["bmoney", _playerMoney - _price, true];

	_text = format ["You paid $%1 to resupply %2.\nNo Refunds!\nPlease stand by...", _price call fn_numbersText, _vehName];
	[_text, 10] call mf_notify_client;
	[] spawn fn_savePlayerData;

	_turretsArray = [[_vehCfg, [-1]]];
	_turretsCfg = configFile >> "CfgVehicles" >> _vehClass >> "Turrets";

	if (isClass _turretsCfg) then
	{
		_nbTurrets = count _turretsCfg;
		_turretPath = 0;

		for "_i" from 0 to (_nbTurrets - 1) do
		{
			_turretCfg = _turretsCfg select _i;

			if (isClass _turretCfg && {getNumber (_turretCfg >> "hasGunner") > 0}) then
			{
				_turretsArray set [count _turretsArray, [_turretCfg, [_turretPath]]];

				_subTurretsCfg = _turretCfg >> "Turrets";

				if (isClass _subTurretsCfg) then
				{
					_nbSubTurrets = count _subTurretsCfg;
					_subTurretPath = 0;

					for "_j" from 0 to (_nbSubTurrets - 1) do
					{
						_subTurretCfg = _subTurretsCfg select _j;

						if (isClass _subTurretCfg && {getNumber (_subTurretCfg >> "hasGunner") > 0}) then
						{
							_turretsArray set [count _turretsArray, [_subTurretCfg, [_turretPath, _subTurretPath]]];
							_subTurretPath = _subTurretPath + 1;
						};
					};
				};

				_turretPath = _turretPath + 1;
			};
		};
	};

	sleep (REARM_TIME_SLICE / 2);
	call _checkAbortConditions;

	/*_engineOn = false;

	if !(_vehicle isKindOf "Air") then
	{
		_engineOn = isEngineOn _vehicle;
		_vehicle engineOn false;
		_unit action ["EngineOff", _vehicle];
	};*/

	{
		_turretCfg = _x select 0;
		_turretPath = _x select 1;
		_turretMags = getArray (_turretCfg >> "magazines");
		_turretMagPairs = [];

		{ [_turretMagPairs, _x, 1] call fn_addToPairs } forEach _turretMags;

		{
			_mag = _x select 0;
			_ammo = _x select 1;

			if (_ammo >= getNumber (configFile >> "CfgMagazines" >> _mag >> "count")) then
			{
				{
					if (_x select 0 == _mag) exitWith
					{
						_count = if (count _x > 2) then { _x select 2 } else { 0 };
						_x set [2, _count + 1];
					};
				} forEach _turretMagPairs;
			};
		} forEach magazinesAmmo _vehicle;

		{
			_mag = _x select 0;
			_qty = _x select 1;
			_fullQty = if (count _x > 2) then { _x select 2 } else { 0 };

			if (_fullQty < _qty) then
			{
				_vehicle removeMagazinesTurret [_mag, _turretPath];

				for "_i" from 1 to _qty do
				{
					_magName = getText (configFile >> "CfgMagazines" >> _mag >> "displayName");

					if (_magName == "") then
					{
						{
							_weaponCfg = configFile >> "CfgWeapons" >> _x;

							if ({_mag == _x} count getArray (_weaponCfg >> "magazines") > 0) exitWith
							{
								_magName = getText (_weaponCfg >> "displayName");
							};
						} forEach getArray (_turretCfg >> "weapons");
					};

					_text = format ["Reloading %1...", if (_magName != "") then { _magName } else { _vehName }];
					_text call _titleText;

					sleep (REARM_TIME_SLICE / 2);
					call _checkAbortConditions;

					_vehicle addMagazineTurret [_mag, _turretPath];

					sleep (REARM_TIME_SLICE / 2);
					call _checkAbortConditions;
				};
			};
		} forEach _turretMagPairs;
	} forEach _turretsArray;

	_vehicle setVehicleAmmoDef 1; // Full ammo reset just to be sure

	if (damage _vehicle > 0.001) then
	{
		call _checkAbortConditions;

		while {damage _vehicle > 0.001} do
		{
			"Repairing..." call _titleText;

			sleep 1;
			call _checkAbortConditions;

			_vehicle setDamage ((damage _vehicle) - 0.1);
		};

		sleep 3;
	};

	if (fuel _vehicle < 0.999) then
	{
		call _checkAbortConditions;

		while {fuel _vehicle < 0.999} do
		{
			"Refueling..." call _titleText;

			sleep REFUEL_TIME_SLICE;
			call _checkAbortConditions;

			_vehicle setFuel ((fuel _vehicle) + 0.1);
		};

		sleep 2;
	};

	//if !(_vehicle isKindOf "Air") then
	//{
		_vehicle removeEventHandler ["Engine", _vehicle getVariable ["A3W_resupplyEngineEH", -1]];
		_vehicle engineOn true; //_engineOn;
	//};

	["Your vehicle is ready!", 5] call mf_notify_client;
	mutexScriptInProgress = false;
};

//if !(_vehicle isKindOf "Air") then
//{
	_vehicle setVariable ["A3W_resupplyThread", _resupplyThread];
	_vehicle setVariable ["A3W_resupplyEngineEH", _vehicle addEventHandler ["Engine",
	{
		_vehicle = _this select 0;
		_started = _this select 1;

		if (_started && !scriptDone (_vehicle getVariable ["A3W_resupplyThread", scriptNull])) then
		{
			_vehicle engineOn false;
			player action ["EngineOff", _vehicle];
		};
	}]];
//};
