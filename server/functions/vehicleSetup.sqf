// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: vehicleSetup.sqf
//	@file Author: AgentRev
//	@file Created: 15/06/2013 19:57

if (!isServer) exitWith {};

params [["_vehicle",objNull,[objNull]], ["_brandNew",true,[false]]]; // _brandNew: true for newly spawned/purchased vehicle (default), false for vehicles restored from save
private ["_class", "_getInOut", "_centerOfMass", "_weapons"];
_class = typeOf _vehicle;

_vehicle setVariable [call vChecksum, true];

clearMagazineCargoGlobal _vehicle;
clearWeaponCargoGlobal _vehicle;
clearItemCargoGlobal _vehicle;

if !(_class isKindOf "AllVehicles") exitWith {}; // if not actual vehicle, finish here

clearBackpackCargoGlobal _vehicle;

// Disable thermal on all manned vehicles
if (!unitIsUAV _vehicle) then
{
	_vehicle disableTIEquipment true;
};

if ({_vehicle isKindOf _x} count ["StaticMGWeapon","StaticGrenadeLauncher","StaticMortar"] > 0) then
{
	_vehicle enableWeaponDisassembly false;
};

_vehicle setUnloadInCombat [false, false]; // Try to prevent AI from getting out of vehicles while in combat (not sure if this actually works...)

/*{
	_vehicle setVariable ["A3W_hitPoint_" + getText (_x >> "name"), configName _x, true];
} forEach (_class call getHitPoints);

_vehicle setVariable ["A3W_hitPointSelections", true, true];*/

_vehicle setVariable ["A3W_handleDamageEH", _vehicle addEventHandler ["HandleDamage", vehicleHandleDamage]];
_vehicle setVariable ["A3W_dammagedEH", _vehicle addEventHandler ["Dammaged", vehicleDammagedEvent]];
_vehicle setVariable ["A3W_engineEH", _vehicle addEventHandler ["Engine", vehicleEngineEvent]];

_vehicle addEventHandler ["GetIn", fn_vehicleGetInOutServer];
_vehicle addEventHandler ["GetOut", fn_vehicleGetInOutServer];
_vehicle addEventHandler ["Killed", fn_vehicleKilledServer];

if ({_class isKindOf _x} count ["Air","UGV_01_base_F"] > 0) then
{
	_vehicle remoteExec ["A3W_fnc_setupAntiExplode", 0, _vehicle];
};

if (_vehicle getVariable ["A3W_resupplyTruck", false] || getNumber (configFile >> "CfgVehicles" >> _class >> "transportAmmo") > 0) then
{
	[_vehicle] remoteExecCall ["A3W_fnc_setupResupplyTruck", 0, _vehicle];
};

[_vehicle, _brandNew] call A3W_fnc_setVehicleLoadout;

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
	case (_class isKindOf "MRAP_02_base_F"):
	{
		// Lower Ifrit center of mass to prevent rollovers
		_centerOfMass = getCenterOfMass _vehicle;
		_centerOfMass set [2, (_centerOfMass select 2) - 0.1]; // cannot be static number like SUV due to different values for each variant
		_vehicle setCenterOfMass _centerOfMass;
	};
	case (_class isKindOf "Offroad_01_repair_base_F"):
	{
		_vehicle animate ["HideServices", 0];
	};
	case ({_class isKindOf _x} count ["B_Heli_Light_01_F", "B_Heli_Light_01_armed_F"] > 0):
	{
		// Add flares to poor MH-9's
		_vehicle addWeaponTurret ["CMFlareLauncher", [-1]];

		if (_brandNew) then
		{
			_vehicle addMagazineTurret ["60Rnd_CMFlare_Chaff_Magazine", [-1]];
		};
	};
	case (_class isKindOf "Plane_Fighter_03_base_F"):
	{
		if (_brandNew) then
		{
			_vehicle addMagazineTurret ["300Rnd_20mm_shells", [-1]];
		};
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
	case (_class isKindOf "Truck_01_base_F"):
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
