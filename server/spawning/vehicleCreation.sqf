// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.1
//	@file Name: vehicleCreation.sqf
//	@file Author: [404] Deadbeat, modded by AgentRev
//	@file Created: 20/11/2012 05:19
//	@file Args: markerPos [, vehicleType]

if (!isServer) exitWith {};

private ["_markerPos", "_pos", "_type", "_num", "_vehicleType", "_respawnSettings", "_vehicle", "_hitPoint"];

_markerPos = _this select 0;
_type = 0;  //test due to undefined variable errors..

if (count _this > 1) then
{
	_vehicleType = _this select 1;

	switch (true) do
	{
		case ({_vehicleType == _x} count civilianVehicles > 0):       { _type = 0 };
		case ({_vehicleType == _x} count lightMilitaryVehicles > 0):  { _type = 1 };
		case ({_vehicleType == _x} count mediumMilitaryVehicles > 0): { _type = 2 };
	};
}
else
{
	_num = random 100;

	switch (true) do
	{
		case (_num < 15): { _vehicleType = mediumMilitaryVehicles call BIS_fnc_selectRandom; _type = 2 };
		case (_num < 50): { _vehicleType = lightMilitaryVehicles call BIS_fnc_selectRandom; _type = 1 };
		default           { _vehicleType = civilianVehicles call BIS_fnc_selectRandom; _type = 0 };
	};
};

_respawnSettings = if (count _this > 2) then { _this select 2 } else { nil };

//_pos = [_markerPos, 2, 25, ( if (_type == 1) then { 2 } else { 5 } ), 0, 60 * (pi / 180), 0, [], [_markerPos]] call BIS_fnc_findSafePos;
// diabled as a test. might break other features
_pos = _markerPos;

//Car Initialization
_vehicle = createVehicle [_vehicleType, _pos, [], 0, "None"];

_vehicle setPosATL [_pos select 0, _pos select 1, 1.5];
_vehicle setDir random 360;
_vehicle setVelocity [0,0,0.01];

_vehicle setDamage (random 0.5); // setDamage must always be called before vehicleSetup

// Reset wheel damage
{
	_hitPoint = configName _x;
	if (["Wheel", _hitPoint] call fn_findString != -1) then
	{
		_vehicle setHitPointDamage [_hitPoint, 0];
	};
} forEach (_vehicleType call getHitPoints);

[_vehicle] call vehicleSetup;

if (!isNil "_respawnSettings") then
{
	[_respawnSettings, "Vehicle", _vehicle] call fn_setToPairs;
	_vehicle setVariable ["vehicleRespawn_settingsArray", _respawnSettings];
};

//[_vehicle, _markerPos, 10, 20, 30] call addVehicleRespawn;
[_vehicle, _markerPos, 15*60, 30*60, 45*60] call addVehicleRespawn;

//Set Vehicle Attributes
_vehicle setFuel (0.2 + random 0.1);

// Reset armed Offroad to 1 mag
if (_vehicleType isKindOf "Offroad_01_armed_base_F") then
{
	_vehicle removeMagazinesTurret ["100Rnd_127x99_mag_Tracer_Yellow", [0]];
	_vehicle addMagazineTurret ["100Rnd_127x99_mag_Tracer_Yellow", [0]];
	reload _vehicle;
};

if (_vehicleType isKindOf "Helicopter_Base_F") then
{
	_vehicle addweapon "CMFlareLauncher";
	_vehicle addmagazine "168Rnd_CMFlare_Chaff_Magazine";
	reload _vehicle;
};

if (_type > 1) then { _vehicle setVehicleAmmo (random 1.0) };

[_vehicle] call randomWeapons;
