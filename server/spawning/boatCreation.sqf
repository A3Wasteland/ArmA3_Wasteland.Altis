// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.1
//	@file Name: boatCreation.sqf
//	@file Author: [GoT] JoSchaap, AgentRev
//	@file Created: 20/11/2012 05:19
//	@file Args: markerPos [, carType]

if (!isServer) exitWith {};

params ["_markerPos", ["_boatType","",[""]], ["_respawnSettings",nil,[createHashMap]]];
private ["_pos", "_boat"];

if (_boatType == "") then
{
	_boatType = waterVehicles call fn_selectRandomNested;
};

//_pos = [_markerPos, 1, 15, 5, 2, 60 * (pi / 180), 0, [], [[], _markerPos]] call BIS_fnc_findSafePos;
_pos = _markerPos;

//Car Initialization
_boat = createVehicle [_boatType, _pos, [], 0, "None"];

_boat setPosASL [_pos select 0, _pos select 1, 0];
_boat setDir random 360;
_boat setVelocity [0,0,0];

_boat setDamage (random 0.5); // setDamage must always be called before vehicleSetup

[_boat] call vehicleSetup;

if (!isNil "_respawnSettings") then
{
	_respawnSettings set ["_veh", _boat];
	_boat setVariable ["vehicleRespawn_settingsArray", _respawnSettings];
};

//[_boat, _markerPos, 10, 20, 30] call addVehicleRespawn;
[_boat, _markerPos, 10*60, 20*60, 30*60] call addVehicleRespawn;

//Set Vehicle Attributes
_boat setFuel (0.3 + random 0.2);

if (_boatType isKindOf "Boat_Armed_01_base_F") then
{
	_boat setVehicleAmmo 0;

	if (_boatType isKindOf "Boat_Armed_01_minigun_base_F") then
	{
		if (_boatType == "I_Boat_Armed_01_minigun_F") then
		{
			_boat addMagazineTurret ["1000Rnd_65x39_Belt_Tracer_Yellow", [1]];
		}
		else
		{
			_boat addMagazineTurret ["1000Rnd_65x39_Belt_Tracer_Red", [1]];
		};
	}
	else
	{
		_boat addMagazineTurret ["200Rnd_127x99_mag_Tracer_Green", [1]];
	};

	for "_i" from 0 to ((floor random 3) - 1) do
	{
		_boat addMagazineTurret ["SmokeLauncherMag_boat", [-1]];
	};

	_boat setHitPointDamage ["HitTurret", 1]; // disable front GMG
	reload _boat;
};
