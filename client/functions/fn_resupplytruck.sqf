//	@file Version: 1.1
//	@file Name: fn_resupplyTruck.sqf
//	@file Author: Wiking, AgentRev
//	@file Created: 13/07/2014 21:58

#define Resupply_Distance (["Resupply_Distance", 30] call getPublicVar)
#define Resupply_Price (["Resupply_Price", 2] call getPublicVar)
#define Resupply_RearmTime (["Resupply_RearmTime", 5] call getPublicVar)
#define Resupply_RepairTime (["Resupply_RepairTime", 5] call getPublicVar)
#define Resupply_RefuelTime (["Resupply_RefuelTime", 5] call getPublicVar)

// Check if mutex lock is active.
if (mutexScriptInProgress) exitWith
{
	titleText ["You are already performing another action.", "PLAIN DOWN", 0.5];
};
mutexScriptInProgress = true;

_truck = _this select 0;
_unit = _this select 1;
_vehicle = vehicle _unit;

//check if caller is the driver
if ((_unit != driver _vehicle) && !(_vehicle isKindOf "StaticWeapon")) exitWith
{
	["You must be in the driver seat to resupply the vehicle.\n UAV/UGV cannot be resupplied. Use an ammotruck instead.", 5] call mf_notify_client;
	mutexScriptInProgress = false;
};


//check if caller is not in vehicle
if ((_vehicle == _unit) && !(_vehicle isKindOf "StaticWeapon")) exitWith
{
	["You must be in the driver seat to resupply the vehicle.", 5] call mf_notify_client;
	mutexScriptInProgress = false;
};

//set up prices
	_vehClass = typeOf _vehicle;
	_price = 3000; // price = 1000 for vehicles not found in vehicle store. (e.g. Static Weapons)	
{	
	if (_vehClass == _x select 1) then
	{	
	_price = _x select 2;
	_price = round (_price / Resupply_Price);
	};
} forEach (call allVehStoreVehicles);

_text = format ["Stop engine in 10s to start resupply. Cost for service is $%1 for this vehicle. This will take some time.\nYou can always abort by getting out of the vehicle.\n UAV/UGV cannot be resupplied. Use an ammotruck instead.", _price];
			titleText [_text, "PLAIN DOWN", 0.5];
sleep 10;
_eng = isEngineOn _vehicle;
if (_eng) exitWith {
	titleText ["Engine still running. Service CANCELED!", "PLAIN DOWN", 0.5];
	mutexScriptInProgress = false;
};
/*
if ((!isnull (gunner _vehicle)) && !(_vehicle isKindOf "StaticWeapon") && !(_vehicle isKindOf "UAV_01_base_F") && !(_vehicle isKindOf "UAV_02_base_F") && !(_vehicle isKindOf "UGV_01_base_F")) then {
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
_resupplyThread = _vehicle spawn
{
	_vehicle = _this;
	_vehClass = typeOf _vehicle;
	_vehicleCfg = configFile >> "CfgVehicles" >> _vehClass;
	_vehName = getText (_vehicleCfg >> "displayName");

	scopeName "fn_resupplyTruck";

	_price = 3000; // price = 1000 for vehicles not found in vehicle store (e.g. static weapons)
	{	
	if (_vehClass == _x select 1) then
	{	
	_price = _x select 2;
	_price = round (_price / Resupply_Price);
	};
	
} forEach (call allVehStoreVehicles);
	
	
	
	_titleText =
	{
		if (vehicle player == _vehicle) then
		{
			titleText [_this, "PLAIN DOWN", ((Resupply_RearmTime max 1) / 10) max 1];
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
			_text = format ["Vehicle resupply aborted by %1", if (count _crew > 0) then { name (_crew select 0) } else { "another player" }];
			titleText [_text, "PLAIN DOWN", 0.5];
			mutexScriptInProgress = false;
			breakOut "fn_resupplyTruck";
		};

		// Abort everything if no Tempest Device in proximity
		if ({alive _x} count (_vehicle nearEntities [["O_Truck_03_device_F"], Resupply_Distance]) == 0) then
		{
			if (_started) then { titleText ["Vehicle resupply aborted!", "PLAIN DOWN", 0.5] };
			mutexScriptInProgress = false;
			breakOut "fn_resupplyTruck";
		};
		// Abort everything if player gets out of vehicle
		if (vehicle player != _vehicle) then
		{
			if (_started) then { titleText ["Vehicle resupply aborted!", "PLAIN DOWN", 0.5] };
			mutexScriptInProgress = false;
			breakOut "fn_resupplyTruck";
		};
		
	};

	_started = false;
	call _checkAbortConditions;
	_started = true;
	
	//Add cost for resupply
_playerMoney = player getVariable "cmoney";

if (_playerMoney < _price) then
	{
		_text = format ["Not enough money! You need $%1 to resupply %2. Service cancelled!",_price,_vehName];
		[_text, 10] call mf_notify_client;
		mutexScriptInProgress = false;
		breakOut "fn_resupplyTruck";
		
	} else 
	{
//start resupply here - 	
		player setVariable["cmoney",(player getVariable "cmoney")-_price,true];
		_text = format ["You paid $%1 to resupply %2.\nNo Refunds!\nPlease stand by...",_price,_vehName];
		[_text, 10] call mf_notify_client;		
		[] call fn_savePlayerData;
	};

	_turretsArray = [[_vehicleCfg, [-1]]];
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

	sleep (Resupply_RearmTime);
	call _checkAbortConditions;
	
	_engineOn = false;
	
	if !(_vehicle isKindOf "Air") then
	{
		_engineOn = isEngineOn _vehicle;
		player action ["EngineOff", _vehicle];
	};

	{
		_turretCfg = _x select 0;
		_turretPath = _x select 1;
		_turretMags = getArray (_turretCfg >> "magazines");
		_turretMagPairs = [];

		{ [_turretMagPairs, _x, 1] call BIS_fnc_addToPairs } forEach _turretMags;

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

					sleep (Resupply_RearmTime);
					call _checkAbortConditions;

					_vehicle addMagazineTurret [_mag, _turretPath];

					sleep (Resupply_RearmTime);
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

			sleep Resupply_RepairTime;
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

			sleep Resupply_RefuelTime;
			call _checkAbortConditions;

			_vehicle setFuel ((fuel _vehicle) + 0.1);
		};

		sleep 2;
	};

	if !(_vehicle isKindOf "Air") then
	{
		_vehicle removeEventHandler ["Engine", _vehicle getVariable ["truckResupplyEngineEH", -1]];
		_vehicle engineOn _engineOn;
	};

	titleText ["Your vehicle is ready!", "PLAIN DOWN", 0.5];
	mutexScriptInProgress = false;
};

if !(_vehicle isKindOf "Air") then
{
	_vehicle setVariable ["truckResupplyThread", _resupplyThread];
	_vehicle setVariable ["truckResupplyEngineEH", _vehicle addEventHandler ["Engine",
	{
		_vehicle = _this select 0;
		_started = _this select 1;
		_resupplyThread = _vehicle getVariable "truckResupplyThread";

		if (!isNil "_resupplyThread" && {!scriptDone _resupplyThread}) then
		{
			player action ["EngineOff", _vehicle];
		};
	}]];
};
