//	@file Version: 1.1
//	@file Name: fn_chopShop.sqf
//	@file Author: Lodac, Wiking, AgentRev
//	@file Created: 13/07/2014 21:58

#define CHOPSHOP_TRUCK_DISTANCE 20
#define PRICE_RELATIONSHIP 4


// Check if mutex lock is active.
	if (mutexScriptInProgress) exitWith
	{
		titleText ["You are already performing another action.", "PLAIN DOWN", 0.5];
	};
	mutexScriptInProgress = true;

	_vehicle = vehicle player;

	//check if caller is in vehicle
	if (_vehicle == player) exitWith {};

	//set up prices
	_vehClass = typeOf _vehicle;
	_price = 1000; // price = 1000 for vehicles not found in vehicle store. (e.g. Static Weapons)	
	{	
		if (_vehClass == _x select 1) then
		{	
			_price = _x select 2;
			_price = round (_price / PRICE_RELATIONSHIP);
		};
	} forEach (call allVehStoreVehicles);

	_text = format ["Stop engine in 10s to start chopping. You will get $%1 for this vehicle. This will take some time.\nYou can always abort by getting out of the vehicle.", _price];
	titleText [_text, "PLAIN DOWN", 0.5];
	sleep 10;
	_eng = isEngineOn _vehicle;
	if (_eng) exitWith 
	{
		titleText ["Engine still running. Chopping CANCELED!", "PLAIN DOWN", 0.5];
		mutexScriptInProgress = false;
	};

		_vehicle = _this;
		_vehClass = typeOf _vehicle;
		_vehicleCfg = configFile >> "CfgVehicles" >> _vehClass;
		_vehName = getText (_vehicleCfg >> "displayName");

	

		_price = 1000; // price = 500 for vehicles not found in vehicle store (e.g. static weapons)
		{	
			if (_vehClass == _x select 1) then
			{	
				_price = _x select 2;
				_price = round (_price / PRICE_RELATIONSHIP);
			};
		} forEach (call allVehStoreVehicles);
		player setVariable["cmoney",(player getVariable "cmoney")+_price,true];
		player setVariable["timesync",(player getVariable "timesync")+(_price * 3),true];
		[] call fn_savePlayerData;
		["Dismantling will take about 1 minute.", 10] call mf_notify_client;
		_vehicle setFuel 0;
		_vehicle setVelocity [0,0,0];
		_text = format ["Selling %1 for $%2. Removing Engine, emptying fluids, and removing ammo.", _type, _price];
		[_text, 5] call mf_notify_client;
		sleep 5;
		["Chopping up vehicle.", 5] call mf_notify_client;
		_this animate ["HideBackpacks", 1];
		sleep 1;
		_this animate ["HideBumper1", 1];
		sleep 1;
		_this animate ["HideBumper2", 1];
		sleep 1;
		_this animate ["HideDoor1", 1];
		sleep 1;		
		_this animate ["HideDoor2", 1];
		sleep 1;
		_this animate ["HideDoor3", 1];
		sleep 1;
		deleteVehicle _this;

		_text = format ["%1 has been chopped.", _type];
		[_text, 10] call mf_notify_client;
		mutexScriptInProgress = false;
		if (true) exitWith {};
	