private ["_vehicle", "_driver","_eng","_type","_playerMoney","_price"];
_vehicle = _this;
_driver = driver _vehicle;
_eng = isengineon _vehicle;
waitUntil {sleep 0.1; isTouchingGround _vehicle || !alive _vehicle || (getPos _vehicle) select 2 < 1};
_vehicle setVelocity [0,0,0];

if (_eng) then {
	_vehicle vehicleChat format ["Stop engine in 15s to sell the vehicle for parts, you will get 50 - 13000 dollars depending on the vehicle."];
	sleep 17;
	_eng = isengineon _vehicle;
	if (_eng) exitWith {_vehicle vehicleChat format ["Engine still running. Service CANCELED!"];};
};


if((player == driver _vehicle) && (!_eng))then {
	_type = typeOf _vehicle;
	_playerMoney = player getVariable "cmoney";

	_price = 300;
	if(_vehicle iskindof "Air") then {_price = 5000;};
	if(_vehicle iskindof "Tank") then {_price = 6000;};
	
	if(_type == "C_Kart_01_F") then {_price = 50;};
	if(_type == "C_Quadbike_01_F") then {_price = 75;};
	if(_type == "B_Quadbike_01_F") then {_price = 100;};
	if(_type == "O_Quadbike_01_F") then {_price = 100;};
	if(_type == "I_Quadbike_01_F") then {_price = 100;};
	if(_type == "B_G_Quadbike_01_F") then {_price = 100;};
	
	if(_type == "C_Hatchback_01_F") then {_price = 200;};
	if(_type == "C_Hatchback_01_sport_F") then {_price = 350;};
	if(_type == "C_SUV_01_F") then {_price = 375;};
	if(_type == "C_Offroad_01_F") then {_price = 375;};
	if(_type == "B_G_Offroad_01_F") then {_price = 400;};
	if(_type == "B_G_Offroad_01_armed_F") then {_price = 1250;};
	
	if(_type == "C_Van_01_transport_F") then {_price = 125;};
	if(_type == "B_G_Van_01_transport_F") then {_price = 150;};
	if(_type == "C_Van_01_box_F") then {_price = 150;};
	if(_type == "C_Van_01_fuel_F") then {_price = 1000;};
	if(_type == "B_G_Van_01_fuel_F") then {_price = 1050;};
	
	if(_type == "B_Truck_01_mover_F") then {_price = 1000;};
	if(_type == "B_Truck_01_transport_F") then {_price = 1500;};
	if(_type == "B_Truck_01_covered_F") then {_price = 2000;};
	if(_type == "B_Truck_01_box_F") then {_price = 2000;};
	if(_type == "B_Truck_01_fuel_F") then {_price = 2500;};
	if(_type == "B_Truck_01_medical_F") then {_price = 3000;};
	if(_type == "B_Truck_01_Repair_F") then {_price = 3750;};
	if(_type == "B_Truck_01_ammo_F") then {_price = 5500;};
	
	if(_type == "O_Truck_03_device_F") then {_price = 1250;};
	if(_type == "O_Truck_03_transport_F") then {_price = 1500;};
	if(_type == "O_Truck_03_covered_F") then {_price = 2000;};
	if(_type == "O_Truck_03_fuel_F") then {_price = 2500;};
	if(_type == "O_Truck_03_medical_F") then {_price = 3000;};
	if(_type == "O_Truck_03_repair_F") then {_price = 3750;};
	if(_type == "O_Truck_03_ammo_F") then {_price = 5500;};
	
	if(_type == "I_Truck_02_transport_F") then {_price = 1000;};
	if(_type == "I_Truck_02_covered_F") then {_price = 1500;};
	if(_type == "I_Truck_02_fuel_F") then {_price = 2000;};
	if(_type == "I_Truck_02_medical_F") then {_price = 3000;};
	if(_type == "I_Truck_02_box_F") then {_price = 3500;};
	if(_type == "I_Truck_02_ammo_F") then {_price = 5000;};
	
	if(_type == "B_UGV_01_F") then {_price = 1000;};
	if(_type == "B_UGV_01_rcws_F") then {_price = 3750;};
	if(_type == "I_UGV_01_F") then {_price = 1000;};
	if(_type == "I_UGV_01_rcws_F") then {_price = 3750;};
	if(_type == "O_UGV_01_F") then {_price = 1000;};
	if(_type == "O_UGV_01_rcws_F") then {_price = 3750;};
	
	
	if(_type == "B_MRAP_01_F") then {_price = 1000;};
	if(_type == "B_MRAP_01_hmg_F") then {_price = 3750;};
	if(_type == "B_MRAP_01_gmg_F") then {_price = 3750;};
	if(_type == "O_MRAP_02_F") then {_price = 1000;};
	if(_type == "O_MRAP_02_hmg_F") then {_price = 3750;};
	if(_type == "O_MRAP_02_gmg_F") then {_price = 3750;};
	if(_type == "I_MRAP_03_F") then {_price = 1000;};
	if(_type == "I_MRAP_03_hmg_F") then {_price = 3750;};
	if(_type == "I_MRAP_03_gmg_F") then {_price = 3750;};
	if(_type == "B_APC_Wheeled_01_cannon_F") then {_price = 5000;};
	if(_type == "O_APC_Wheeled_02_rcws_F") then {_price = 5000;};
	if(_type == "I_APC_Wheeled_03_cannon_F") then {_price = 5000;};
	
	
	if(_type == "B_APC_Tracked_01_CRV_F") then {_price = 6250;};
	if(_type == "B_APC_Tracked_01_rcws_F") then {_price = 6500;};
	if(_type == "I_APC_tracked_03_cannon_F") then {_price = 7500;};
	if(_type == "O_APC_Tracked_02_cannon_F") then {_price = 8000;};
	if(_type == "B_APC_Tracked_01_AA_F") then {_price = 10000;};
	if(_type == "O_APC_Tracked_02_AA_F") then {_price = 10000;};
	if(_type == "B_MBT_01_cannon_F") then {_price = 10000;};
	if(_type == "B_MBT_01_TUSK_F") then {_price = 11000;};
	if(_type == "O_MBT_02_cannon_F") then {_price = 12000;};
	if(_type == "I_MBT_03_cannon_F") then {_price = 12500;};
	
        if(_type == "C_Heli_Light_01_civil_F") then {_price = 1500;};
	if(_type == "B_Heli_Light_01_F") then {_price = 1500;};
	if(_type == "O_Heli_Light_02_unarmed_F") then {_price = 2250;};
	if(_type == "I_Heli_light_03_unarmed_F") then {_price = 2250;};
	if(_type == "I_Heli_Transport_02_F") then {_price = 3750;};
	
	if(_type == "B_Heli_Transport_03_F") then {_price = 7500;};
	if(_type == "B_Heli_Transport_03_unarmed_F") then {_price = 5000;};
	if(_type == "O_Heli_Transport_04_F") then {_price = 2250;};
	if(_type == "O_Heli_Transport_04_covered_F") then {_price = 3750;};
	if(_type == "O_Heli_Transport_04_ammo_F") then {_price = 5000;};
	if(_type == "O_Heli_Transport_04_bench_F") then {_price = 3000;};
	if(_type == "O_Heli_Transport_04_fuel_F") then {_price = 3750;};
	if(_type == "O_Heli_Transport_04_medevac_F") then {_price = 3750;};
	if(_type == "O_Heli_Transport_04_repair_F") then {_price = 3750;};
	
	
	if(_type == "B_Heli_Transport_01_F") then {_price = 7500;};
	if(_type == "B_Heli_Transport_01_camo_F") then {_price = 8000;};
	if(_type == "B_Heli_Light_01_armed_F") then {_price = 7500;};
	if(_type == "O_Heli_Light_02_F") then {_price = 10000;};
	if(_type == "I_Heli_light_03_F") then {_price = 8750;};
	if(_type == "B_Heli_Attack_01_F") then {_price = 11250;};
	if(_type == "O_Heli_Attack_02_F") then {_price = 12500;};
	if(_type == "O_Heli_Attack_02_black_F") then {_price = 13000;};
	
	if(_type == "I_Plane_Fighter_03_AA_F") then {_price = 10000;};
	if(_type == "I_Plane_Fighter_03_CAS_F") then {_price = 12500;};
	if(_type == "B_Plane_CAS_01_F") then {_price = 15000;};
	if(_type == "O_Plane_CAS_02_F") then {_price = 15000;};
	if(_type == "B_UAV_02_F") then {_price = 3750;};
	if(_type == "B_UAV_02_CAS_F") then {_price = 3750;};
	if(_type == "O_UAV_02_F") then {_price = 3750;};
	if(_type == "O_UAV_02_CAS_F") then {_price = 3750;};
	if(_type == "I_UAV_02_F") then {_price = 3750;};
	if(_type == "I_UAV_02_CAS_F") then {_price = 3750;};
	

		player setVariable["cmoney",(player getVariable "cmoney")+_price,true];
		player setVariable["timesync",(player getVariable "timesync")+(_price * 3),true];
		[] call fn_savePlayerData;
		["Service will take about 1 minute.", 10] call mf_notify_client;
		
		_vehicle setFuel 0;
		_vehicle setVelocity [0,0,0];
		_text = format ["Selling %1 for $%2. Disabling engine and emptying fluids and ammo", _type, _price];
		[_text, 5] call mf_notify_client;
		sleep 5;
		["Chopping up vehicle", 5] call mf_notify_client;
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

		_text = format ["%1 is chopped up for parts, see you next time!", _type];
		[_text, 10] call mf_notify_client;
		if (true) exitWith {};
	};
