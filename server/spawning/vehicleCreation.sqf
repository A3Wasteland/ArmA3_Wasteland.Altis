//	@file Version: 1.1
//	@file Name: vehicleCreation.sqf
//	@file Author: [404] Deadbeat, modded by AgentRev
//	@file Created: 20/11/2012 05:19
//	@file Args: markerPos [, vehicleType]

if (!isServer) exitWith {};

private ["_markerPos", "_pos", "_type", "_num", "_vehicleType", "_vehicle", "_hitPoints", "_hitPoint"];

_markerPos = _this select 0;
_type = 0;  //test due to undefined variable errors..

if (count _this > 1) then
{
	_vehicleType = _this select 1;	
	if (_vehicleType in civilianVehicles) then { _type = 0 };
	if (_vehicleType in lightMilitaryVehicles) then { _type = 1 };
	if (_vehicleType in mediumMilitaryVehicles) then { _type = 2 };
}
else
{
	_num = floor (random 100);

	if (_num < 100) then { _vehicleType = civilianVehicles call BIS_fnc_selectRandom; _type = 0 };
	if (_num < 50) then { _vehicleType = lightMilitaryVehicles call BIS_fnc_selectRandom; _type = 1 };
	if (_num < 15) then { _vehicleType = mediumMilitaryVehicles call BIS_fnc_selectRandom; _type = 2 };
};

//_pos = [_markerPos, 2, 25, ( if (_type == 1) then { 2 } else { 5 } ), 0, 60 * (pi / 180), 0, [], [_markerPos]] call BIS_fnc_findSafePos;
// diabled as a test. might break other features
_pos = _markerPos;

//Car Initialization
_vehicle = createVehicle [_vehicleType, _pos, [], 0, "None"];

[_vehicle] call vehicleSetup;
_vehicle setPosATL [_pos select 0, _pos select 1, 1.5];
_vehicle setVelocity [0,0,0.01];

[_vehicle, 15*60, 30*60, 45*60, 1000, 0, false, _markerPos] execVM "server\functions\vehicle.sqf";

//Set Vehicle Attributes
_vehicle setFuel (random 0.5 + 0.25);
_vehicle setDamage (random 0.5);

// Remove wheel damage
_hitPoints = configFile >> "CfgVehicles" >> _vehicleType >> "HitPoints";
for "_i" from 0 to (count _hitPoints - 1) do
{
	_hitPoint = configName (_hitPoints select _i);
	if ([_hitPoint, (count toArray _hitPoint) - 5] call BIS_fnc_trimString == "Wheel") then
	{
		_vehicle setHitPointDamage [_hitPoint, 0];
	};
};

if (_vehicleType isKindOf "Offroad_01_armed_base_F") then
{
	_vehicle removeMagazinesTurret ["100Rnd_127x99_mag_Tracer_Yellow", [0]];
	_vehicle addMagazineTurret ["100Rnd_127x99_mag_Tracer_Yellow", [0]];
	reload _vehicle;
};

if (_type > 1) then { _vehicle setVehicleAmmo (random 1.0) };

_vehicle setDir (random 360);
[_vehicle] call randomWeapons;
