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

[_boat, 10*60, 20*60, 30*60, 1000, 0, false, _markerPos] execVM "server\functions\vehicle.sqf";

//Set Vehicle Attributes
_boat setFuel (random 0.5 + 0.25);

if (_boatType isKindOf "Boat_Armed_01_base_F") then
{
	private ["_boatCfg", "_turretsCfg", "_turretsCount", "_turretPath", "_turret"];
	_boatCfg = configFile >> "CfgVehicles" >> _boatType;
	
	{
		_boat removeMagazinesTurret [_x, [-1]];
	} forEach getArray (_boatCfg >> "magazines");
	
	_turretsCfg = configFile >> "CfgVehicles" >> _boatType >> "Turrets";
	_turretsCount = count _turretsCfg;
	_turretPath = 0;
	
	for "_t" from 0 to (_turretsCount - 1) do 
	{
		_turret = _turretsCfg select _t;
		
		if (getNumber (_turret >> "hasGunner") > 0) then
		{
			{
				_boat removeMagazinesTurret [_x, [_turretPath]];
			} forEach getArray (_turret >> "magazines");
			
			_turretPath = _turretPath + 1;
		};
	};
	
	switch (true) do
	{
		case (_boatType isKindOf "Boat_Armed_01_minigun_base_F"):
		{
			_boat addMagazineTurret ["2000Rnd_65x39_Belt_Tracer_Red", [1]];
			_boat setVehicleAmmo 0.50;
		};
		default
		{
			_boat addMagazineTurret ["200Rnd_127x99_mag_Tracer_Green", [1]];
		};
	};
	
	for "_i" from 0 to (floor (random 3.0) - 1) do
	{
		_boat addMagazineTurret ["SmokeLauncherMag_boat", [-1]];
	};
	
	_boat setHitPointDamage ["HitTurret", 1]; // disable front GMG
	
	sleep 0.1;
	reload _boat;
};

_boat setDir (random 360);
