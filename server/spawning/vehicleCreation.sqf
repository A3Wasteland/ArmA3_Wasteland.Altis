// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.1
//	@file Name: vehicleCreation.sqf
//	@file Author: [404] Deadbeat, modded by AgentRev
//	@file Created: 20/11/2012 05:19
//	@file Args: markerPos [, vehicleType]

if (!isServer) exitWith {};

params ["_markerPos", ["_vehicleType","",[""]], ["_respawnSettings",nil,[createHashMap]]];
private ["_pos", "_vehicle", "_hitPoint"];

//_pos = [_markerPos, 2, 25, 5, 0, 60 * (pi / 180), 0, [], [_markerPos]] call BIS_fnc_findSafePos;
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
	if (toLower _x find "wheel" != -1) then
	{
		_vehicle setHitPointDamage [_x, 0];
	};
} forEach (getAllHitPointsDamage _vehicle param [0,[]]);

[_vehicle] call vehicleSetup;

if (!isNil "_respawnSettings") then
{
	_respawnSettings set ["_veh", _vehicle];
	_vehicle setVariable ["vehicleRespawn_settingsArray", _respawnSettings];
};

//[_vehicle, _markerPos, 10, 20, 30] call addVehicleRespawn;
[_vehicle, _markerPos, 15*60, 30*60, 45*60] call addVehicleRespawn;

//Set Vehicle Attributes
_vehicle setFuel (0.2 + random 0.1);

// Reset Offroad HMG to 1-2 mags
if (_vehicleType isKindOf "Offroad_01_armed_base_F") then
{
	_vehicle setVehicleAmmo ((1 + floor random 2) / 4);
};

// Reset Offroad AT to 0-4 rockets 
if (_vehicleType isKindOf "Offroad_01_AT_base_F") then
{
	{
		_x params ["_mag", "_path", "_ammo"];
		_vehicle setMagazineTurretAmmo [_mag, floor random 3, _path];
	} forEach magazinesAllTurrets _vehicle;
};

//if (_type > 1) then { _vehicle setVehicleAmmo (random 1.0) };

[_vehicle] call randomWeapons;
