
_vehicle = _this;
_driver = driver _vehicle;
_eng = isengineon _vehicle;
_vehicle setVelocity [0,0,0];

if (_eng) then {
	_vehicle vehicleChat format ["Stop engine in 15s to start resupply. Cost for service is $500 or 1/4 of vehicle store price for armed or resupply vehicles. Service will take 2 minutes."];
	sleep 15;
	_eng = isengineon _vehicle;
	if (_eng) exitWith {_vehicle vehicleChat format ["Engine still running. Service CANCELED!"];};
};


if (!isnull (gunner _vehicle)) then {
	_vehicle vehicleChat format ["Gunner must be out of seat for service! Get gunner out in 20s."];
	sleep 10;
	_vehicle vehicleChat format ["Gunner must be out of seat for service! Get gunner out in 10s."];
	sleep 10;
	if (!isnull (gunner _vehicle)) exitWith {_vehicle vehicleChat format ["Gunner still inside. Service CANCELED!"];};
};


if((player == driver _vehicle) && (!_eng))then {
	_type = typeOf _vehicle;
	_playerMoney = player getVariable "cmoney";

	_price = 500;
	if(_type == "B_G_Offroad_01_armed_F") then {_price = 625;};
	if(_type == "B_Truck_01_medical_F") then {_price = 1500;};
	if(_type == "B_Truck_01_Repair_F") then {_price = 1875;};
	if(_type == "B_Truck_01_ammo_F") then {_price = 3750;};
	if(_type == "O_Truck_03_medical_F") then {_price = 1500;};
	if(_type == "O_Truck_03_repair_F") then {_price = 1875;};
	if(_type == "O_Truck_03_ammo_F") then {_price = 3750;};
	if(_type == "I_Truck_02_medical_F") then {_price = 1500;};
	if(_type == "I_Truck_02_box_F") then {_price = 1750;};
	if(_type == "I_Truck_02_ammo_F") then {_price = 3500;};
	if(_type == "B_MRAP_01_hmg_F") then {_price = 2000;};
	if(_type == "B_MRAP_01_gmg_F") then {_price = 2500;};
	if(_type == "O_MRAP_02_hmg_F") then {_price = 2000;};
	if(_type == "O_MRAP_02_gmg_F") then {_price = 2500;};
	if(_type == "I_MRAP_03_hmg_F") then {_price = 2000;};
	if(_type == "I_MRAP_03_gmg_F") then {_price = 2500;};
	if(_type == "O_APC_Wheeled_02_rcws_F") then {_price = 3125;};
	if(_type == "B_APC_Wheeled_01_cannon_F") then {_price = 3750;};
	if(_type == "I_APC_Wheeled_03_cannon_F") then {_price = 4375;};
	if(_type == "B_APC_Tracked_01_CRV_F") then {_price = 4000;};	
	if(_type == "B_APC_Tracked_01_rcws_F") then {_price = 4500;};
	if(_type == "I_APC_tracked_03_cannon_F") then {_price = 4750;};
	if(_type == "O_APC_Tracked_02_cannon_F") then {_price = 5000;};
	if(_type == "B_APC_Tracked_01_AA_F") then {_price = 5000;};
	if(_type == "O_APC_Tracked_02_AA_F") then {_price = 5000;};
	if(_type == "B_MBT_01_cannon_F") then {_price = 6250;};
	if(_type == "B_MBT_01_TUSK_F") then {_price = 6250;};
	if(_type == "O_MBT_02_cannon_F") then {_price = 6250;};
	if(_type == "I_MBT_03_cannon_F") then {_price = 6250;};
	if(_type == "B_Heli_Transport_01_F") then {_price = 3750;};
	if(_type == "B_Heli_Transport_01_camo_F") then {_price = 4000;};
	if(_type == "B_Heli_Light_01_armed_F") then {_price = 5000;};
	if(_type == "O_Heli_Light_02_F") then {_price = 5000;};
	if(_type == "I_Heli_light_03_F") then {_price = 5625;};
	if(_type == "B_Heli_Attack_01_F") then {_price = 6875;};
	if(_type == "O_Heli_Attack_02_F") then {_price = 7500;};
	if(_type == "O_Heli_Attack_02_black_F") then {_price = 7500;};
	if(_type == "I_Plane_Fighter_03_AA_F") then {_price = 5000;};
	if(_type == "I_Plane_Fighter_03_CAS_F") then {_price = 6250;};
	if(_type == "B_Plane_CAS_01_F") then {_price = 7500;};
	if(_type == "O_Plane_CAS_02_F") then {_price = 7500;};
	if(_type == "O_Boat_Armed_01_hmg_F") then {_price = 1000;};
	if(_type == "B_Boat_Armed_01_minigun_F") then {_price = 1000;};
	if(_type == "I_Boat_Armed_01_minigun_F") then {_price = 1000;};

	if (_playerMoney < _price) then {
		_text = format ["Not enough money! You need $%1 to resupply %2. Service cancelled!",_price,typeOf _vehicle];
		[_text, 10] call mf_notify_client;
	} else {
		player setVariable["cmoney",(player getVariable "cmoney")-_price,true];
		player setVariable["timesync",(player getVariable "timesync")-(_price * 3),true];
		[] call fn_savePlayerData;
		
		_vehicle setFuel 0;
		_vehicle setVelocity [0,0,0];
		_text = format ["Servicing %1 for $%2. Please stand by...", _type, _price];
		[_text, 10] call mf_notify_client;
		sleep 10;
		["Repairing 1/3...", 15] call mf_notify_client;
		_this animate ["HideBackpacks", 1];
		_this animate ["HideBumper1", 1];
		_this animate ["HideBumper2", 1];
		_this animate ["HideDoor1", 1]; 
		_this animate ["HideDoor2", 1];
		_this animate ["HideDoor3", 1];
		sleep 15;
		_vehicle setFuel 0;
		["Repairing 2/3...", 15] call mf_notify_client;
		sleep 15;
		["Repairing 3/3...", 15] call mf_notify_client;
		_this animate ["HideBackpacks", 0];
		_this animate ["HideBumper1", 0];
		_this animate ["HideBumper2", 0];
		_this animate ["HideDoor1", 0]; 
		_this animate ["HideDoor2", 0];
		_this animate ["HideDoor3", 0];
		sleep 15;
		_vehicle setDamage 0;
		_vehicle setFuel 0;
		["Reloading ammo!", 7.5] call mf_notify_client;
		sleep 7.5;
		["Reloading ammo 1/3...", 7.5] call mf_notify_client;
		sleep 7.5;
		_vehicle setFuel 0;
		["Reloading ammo 2/3...", 7.5] call mf_notify_client;
		sleep 7.5;
		_vehicle setFuel 0;
		["Reloading ammo 3/3...", 7.5] call mf_notify_client;
		sleep 7.5;
		_vehicle setFuel 0;
		_vehicle setVehicleAmmo 1;
		["You can enter the gunner seat now but refueling will take another 30 seconds.", 7.5] call mf_notify_client;
		sleep 7.5;
		["Refueling 1/3...", 7.5] call mf_notify_client;
		sleep 7.5;
		["Refueling 2/3...", 7.5] call mf_notify_client;
		sleep 7.5;
		["Refueling 3/3...", 7.5] call mf_notify_client;
		sleep 7.5;
		_vehicle setFuel 1;
		_text = format ["%1 is ready.", _type];
		[_text, 15] call mf_notify_client;
		if (true) exitWith {};
	};
};