//	@file Version: 1.1
//	@file Name: fn_chopShop.sqf
//	@file Author: Lodac, Wiking, Gigatek (original auth)
//	@file Created: 13/07/2014 21:58

#define CHOPSHOP_TRUCK_DISTANCE 20
#define CHOPSHOP_PRICE_RELATIONSHIP 2

_vehicle = vehicle player;
_driver = driver _vehicle;
_eng = isengineon _vehicle;
_vehicle setVelocity [0,0,0];

if (_eng) then {
	_vehicle vehicleChat format ["Stop engine in 15s to sell vehicle. You will get 1/2 of the vehicle store price."];
	sleep 15;
	_eng = isengineon _vehicle;
	if (_eng) exitWith {_vehicle vehicleChat format ["Engine still running. Deal CANCELED!"];};
};


if((player == driver _vehicle) && (!_eng))then {
	_type = typeOf _vehicle;
	_playerMoney = player getVariable "cmoney";

	_price = 300;
	//find price from vehicle store prices
	{	
	if (_type == _x select 1) then
	{	
	_price = _x select 2;
	_price = _price / CHOPSHOP_PRICE_RELATIONSHIP;
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
		_vehicle animate ["HideBackpacks", 1];
		sleep 1;
		_vehicle animate ["HideBumper1", 1];
		sleep 1;
		_vehicle animate ["HideBumper2", 1];
		sleep 1;
		_vehicle animate ["HideDoor1", 1];
		sleep 1;		
		_vehicle animate ["HideDoor2", 1];
		sleep 1;
		_vehicle animate ["HideDoor3", 1];
		sleep 1;
		deleteVehicle _vehicle;

		_text = format ["%1 has been chopped.", _type];
		[_text, 10] call mf_notify_client;
		if (true) exitWith {};
	};