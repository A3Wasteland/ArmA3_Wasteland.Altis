//	@file Version: 1.0
//	@file Name: vehicleSetup.sqf
//	@file Author: AgentRev
//	@file Created: 15/06/2013 19:57

if (!isServer) exitWith {};

private ["_vehicle", "_class", "_getInOut", "_centerOfMass", "_weapons"];
_vehicle = _this select 0;
_class = typeOf _vehicle;

_vehicle setVariable [call vChecksum, true];
if (vehicleThermalsOn) then
{
	_vehicle disableTIEquipment false;
}
else
{
	if !(_vehicle isKindOf "UAV_02_base_F") then
	{
		_vehicle disableTIEquipment true;
	};
};


clearMagazineCargoGlobal _vehicle;
clearWeaponCargoGlobal _vehicle;
clearItemCargoGlobal _vehicle;

if !(_class isKindOf "AllVehicles") exitWith {}; // if not actual vehicle, finish here

clearBackpackCargoGlobal _vehicle;

if !(_vehicle isKindOf "UAV_02_base_F") then
{
	_vehicle disableTIEquipment true;
};

_vehicle addEventHandler ["HandleDamage", vehicleHandleDamage];

_getInOut =
{
	_vehicle = _this select 0;
	_unit = _this select 2;

	_unit setVariable ["lastVehicleRidden", netId _vehicle, true];
	_unit setVariable ["lastVehicleOwner", owner _vehicle == owner _unit, true];

	_vehicle setVariable ["vehSaving_hoursUnused", 0];
	_vehicle setVariable ["vehSaving_lastUse", diag_tickTime];
};

_vehicle addEventHandler ["GetIn", _getInOut];
_vehicle addEventHandler ["GetOut", _getInOut];

// Wreck cleanup
_vehicle addEventHandler ["Killed", { (_this select 0) setVariable ["processedDeath", diag_tickTime] }];

// Vehicle customization
switch (true) do
{
	case (_class isKindOf "SUV_01_base_F"):
	{
		// Lower SUV center of mass to prevent rollovers
		_centerOfMass = getCenterOfMass _vehicle;
		_centerOfMass set [2, -0.657]; // original = -0.557481
		_vehicle setCenterOfMass _centerOfMass;
	};
	case ({_class isKindOf _x} count ["Heli_Light_01_base_F", "O_Heli_Light_02_unarmed_F"] > 0):
	{
		// Add flares to those poor defenceless helis
		_vehicle addWeaponTurret ["CMFlareLauncher", [-1]];
		_vehicle addMagazineTurret ["120Rnd_CMFlare_Chaff_Magazine", [-1]];
	};
};

_weapons = getArray (configFile >> "CfgVehicles" >> _class >> "weapons");

// Horn customizations
switch (true) do
{
	case ({_x == "TruckHorn"} count _weapons > 0):
	{
		// Replace clown bike horn to something better
		_vehicle removeWeaponTurret ["TruckHorn", [-1]];
		_vehicle addWeaponTurret ["TruckHorn2", [-1]];
	};
	case ({_x == "CarHorn"} count _weapons > 0):
	{
		// Replace other clown bike horn to something better
		_vehicle removeWeaponTurret ["CarHorn", [-1]];
		_vehicle addWeaponTurret ["SportCarHorn", [-1]];
	};
	case (_class isKindOf "Truck_01_base_F");
	{
		// Give real truck horn to HEMTT
		_vehicle removeWeaponTurret ["TruckHorn2", [-1]];
		_vehicle addWeaponTurret ["TruckHorn3", [-1]];
	};
	case (_class isKindOf "Kart_01_Base_F"):
	{
		// Add quadbike horn to karts
		_vehicle addWeaponTurret ["MiniCarHorn", [-1]];
	};
};
