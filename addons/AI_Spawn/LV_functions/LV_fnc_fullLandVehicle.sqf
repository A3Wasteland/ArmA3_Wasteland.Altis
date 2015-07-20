//ARMA3Alpha function LV_fnc_fullLandVehicle v1.2 - by SPUn / lostvar
//Spawns random vehicle full of random units and returns driver 
private ["_BLUhq","_BLUgrp","_veh","_grp","_OPFhq","_OPFgrp","_INDhq","_INDgrp","_roads","_radius","_pos1","_man1","_man","_i","_pos","_side","_BLUveh","_OPFveh","_INDveh","_men","_veh1","_vehSpots","_roadFound","_vehicle","_vCrew","_allUnitsArray","_crew","_driver"];
_pos = _this select 0;
_side = _this select 1;

_BLUveh = ["B_MRAP_01_F","B_MRAP_01_hmg_F","B_MRAP_01_gmg_F","B_Quadbike_01_F","B_Truck_01_transport_F","B_Truck_01_covered_F","B_APC_Tracked_01_rcws_F","B_APC_Tracked_01_AA_F","B_APC_Wheeled_01_cannon_F","B_MBT_01_cannon_F","B_MBT_01_arty_F","B_MBT_01_mlrs_F"];
_OPFveh = ["O_MRAP_02_F","O_MRAP_02_gmg_F","O_MRAP_02_hmg_F","O_Quadbike_01_F","O_Truck_02_transport_F","O_Truck_02_covered_F","O_MBT_02_arty_F","O_MBT_02_cannon_F","O_APC_Wheeled_02_rcws_F","O_APC_Tracked_02_cannon_F","O_APC_Tracked_02_AA_F"];
_INDveh = ["I_MRAP_03_F","I_MRAP_03_gmg_F","I_MRAP_03_hmg_F","I_Quadbike_01_F","I_Truck_02_transport_F","I_Truck_02_covered_F","I_APC_Wheeled_03_cannon_F","I_APC_Wheeled_03_cannon_F","I_APC_Wheeled_03_cannon_F"];

_men = [];
_veh = [];

switch(_side)do{
	case 0:{
		_BLUhq = createCenter west;
		_BLUgrp = createGroup west;
		_veh = _BLUveh;
		_grp = _BLUgrp;
	};
	case 1:{
		_OPFhq = createCenter east;
		_OPFgrp = createGroup east;
		_veh = _OPFveh;
		_grp = _OPFgrp;
	};
	case 2:{
		_INDhq = createCenter resistance;
		_INDgrp = createGroup resistance;
		_veh = _INDveh;
		_grp = _INDgrp;
	};
};

_veh1 = _veh select (floor(random(count _veh)));
_vehSpots = getNumber (configFile >> "CfgVehicles" >> _veh1 >> "transportSoldier");

_radius = 40;
_roads = [];
while{(count _roads) == 0}do{
	_roads = _pos nearRoads _radius;
	_radius = _radius + 10;
};
if(((_roads select 0) distance _pos)<200)then{
	_pos = getPos(_roads select 0);
	_pos1 = [_pos,0,25,5,0,1,0] call BIS_fnc_findSafePos;
}else{
	_pos1 = [_pos,0,200,5,0,1,0] call BIS_fnc_findSafePos;
};
_pos = [_pos1 select 0, _pos1 select 1, 0];

sleep 0.5;

_vehicle = createVehicle [_veh1, _pos, [], 0, "NONE"];
_vehicle setPos _pos;

_vehicle allowDamage false;
sleep 2;
if(((vectorUp _vehicle) select 2) != 0)then{ _vehicle setvectorup [0,0,0]; };
sleep 2;
_vehicle allowDamage true;

_vCrew = [_vehicle, _grp] call BIS_fnc_spawnCrew;
//_allUnitsArray set [(count _allUnitsArray), _vehicle];
_crew = crew _vehicle;

if(_vehSpots > 0)then{
	_i = 1; 
	for "_i" from 1 to _vehSpots do {
		_man1 = getText (configFile >> "CfgVehicles" >> _veh1 >> "crew");
		_man = _grp createUnit [_man1, _pos, [], 0, "NONE"];
		_man moveInCargo _vehicle;
		sleep 0.3;
	};
};

_driver = driver _vehicle;
_driver