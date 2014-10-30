// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.1
//	@file Name: boatCreation.sqf
//	@file Author: [GoT] JoSchaap, AgentRev
//	@file Created: 20/11/2012 05:19
//	@file Args: markerPos [, carType]

if (!isServer) exitWith {};

private ["_markerPos", "_pos", "_boatType", "_boat"];

_markerPos = _this select 0;

_boatType = waterVehicles call BIS_fnc_selectRandom;

//_pos = [_markerPos, 1, 15, 5, 2, 60 * (pi / 180), 0, [], [[], _markerPos]] call BIS_fnc_findSafePos;
_pos = _markerPos;

//Car Initialization
_boat = createVehicle [_boatType, _pos, [], 0, "None"];

_boat setDamage (random 0.5); // setDamage must always be called before vehicleSetup

[_boat] call vehicleSetup;
_boat setPosASL [_pos select 0, _pos select 1, 0];
_boat setVelocity [0,0,0];

[_boat, 10*60, 20*60, 30*60, 1000, 0, false, _markerPos] spawn vehicleRespawnCheck;

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

_boat setDir (random 360);
