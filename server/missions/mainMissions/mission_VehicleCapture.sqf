// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: mission_VehicleCapture.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, JoSchaap, AgentRev
//	@file Created: 08/12/2012 15:19

if (!isServer) exitwith {};
#include "mainMissionDefines.sqf";

private ["_vehicle", "_vehicleName", "_vehDeterminer"];

// setupVars must be defined in the top mission file

_setupObjects =
{
	_missionPos = markerPos _missionLocation;

	// Class, Position, Fuel, Ammo, Damage, Special
	_vehicle = [_vehicleClass, _missionPos] call createMissionVehicle;

	/*switch (true) do
	{
		// GMG MRAPs
		/*case ({ _vehicle isKindOf _x } count ["MRAP_01_gmg_base_F","MRAP_02_gmg_base_F","MRAP_03_gmg_base_F"] > 0):
		{
			_vehicle setVehicleAmmoDef 1;

			// Reduce grenades to 50
			_vehicle removeMagazines "96Rnd_40mm_G_belt";
			_vehicle addMagazine ["96Rnd_40mm_G_belt", 50];
		};//

		// AMV-7 Marshall
		case (_vehicle isKindOf "B_APC_Wheeled_01_cannon_F"):
		{
			_vehicle setVehicleAmmoDef 1;

			// Reduce all shells and MG ammo, reset smoke mags
			_vehicle addMagazineTurret ["SmokeLauncherMag", [0,0]];
			_vehicle setVehicleAmmo 0.5;
		};

		// AFV-4 Gorgon
		case (_vehicle isKindOf "I_APC_Wheeled_03_cannon_F"):
		{
			_vehicle setVehicleAmmoDef 1;

			// Reduce all shells and MG ammo, reset AT missiles and smoke mags
			_vehicle addMagazineTurret ["2Rnd_GAT_missiles", [0]];
			_vehicle addMagazineTurret ["SmokeLauncherMag", [0,0]];
			_vehicle setVehicleAmmo 0.5;
		};

		// BTR-K Kamysh
		case (_vehicle isKindOf "O_APC_Tracked_02_cannon_F"):
		{
			_vehicle setVehicleAmmoDef 1;

			// Reduce all shells and MG ammo, reset AT missiles and smoke mags
			_vehicle addMagazineTurret ["2Rnd_GAT_missiles", [0]];
			_vehicle addMagazineTurret ["SmokeLauncherMag", [0,0]];
			_vehicle setVehicleAmmo 0.5;
		};

		// FV-720 Mora
		case (_vehicle isKindOf "I_APC_tracked_03_cannon_F"):
		{
			_vehicle setVehicleAmmoDef 1;

			// Reduce all shells and MG ammo, reset smoke mags
			_vehicle removeMagazineTurret ["1000Rnd_65x39_Belt_Yellow", [0]];
			_vehicle addMagazineTurret ["SmokeLauncherMag", [0,0]];
			_vehicle setVehicleAmmo 0.5;
		};

		// M2A4 Slammer UP
		case (_vehicle isKindOf "B_MBT_01_TUSK_F"):
		{
			_vehicle setVehicleAmmoDef 1;

			// Reduce AP shells & MG ammo, reset HE shells and smoke mags
			_vehicle removeMagazineTurret ["2000Rnd_65x39_Belt", [0]];
			_vehicle removeMagazineTurret ["500Rnd_127x99_mag_Tracer_Red", [0,0]];
			_vehicle addMagazineTurret ["20Rnd_105mm_HEAT_MP_T_Red", [0]];
			_vehicle addMagazineTurret ["SmokeLauncherMag", [0,0]];
			_vehicle setVehicleAmmo 0.5;
		};

		// M2A1 Slammer
		case (_vehicle isKindOf "B_MBT_01_cannon_F"):
		{
			_vehicle setVehicleAmmoDef 1;

			// Reduce AP shells & MG ammo, reset HE shells and smoke mags
			_vehicle addMagazineTurret ["16Rnd_120mm_HE_shells_Tracer_Red", [0]];
			_vehicle addMagazineTurret ["SmokeLauncherMag", [0,0]];
			_vehicle setVehicleAmmo 0.5;
		};

		// T-100 Varsuk
		case (_vehicle isKindOf "O_MBT_02_cannon_F"):
		{
			_vehicle setVehicleAmmoDef 1;

			// Reduce all shells & MG ammo, reset smoke mags
			_vehicle removeMagazineTurret ["2000Rnd_65x39_Belt_Green", [0]];
			_vehicle removeMagazineTurret ["450Rnd_127x108_Ball", [0,0]];
			_vehicle addMagazineTurret ["SmokeLauncherMag", [0,0]];
			_vehicle setVehicleAmmo 0.5;
		};

		// MBT-52 Kuma
		case (_vehicle isKindOf "I_MBT_03_cannon_F"):
		{
			_vehicle setVehicleAmmoDef 1;

			// Reduce AP shells & MG ammo, reset HE shells and smoke mags
			_vehicle removeMagazineTurret ["2000Rnd_65x39_Belt_Yellow", [0]];
			_vehicle removeMagazineTurret ["500Rnd_127x99_mag_Tracer_Yellow", [0,0]];
			_vehicle addMagazineTurret ["14Rnd_120mm_HE_shells_Tracer_Yellow", [0]];
			_vehicle addMagazineTurret ["SmokeLauncherMag", [0,0]];
			_vehicle setVehicleAmmo 0.5;
		};

		// PO-30 Orca
		case (_vehicle isKindOf "Heli_Light_02_base_F"):
		{
			// Reset all ammo
			_vehicle setVehicleAmmoDef 1;
		};

		// Mi-48 Kajman
		case (_vehicle isKindOf "Heli_Attack_02_base_F"):
		{
			_vehicle setVehicleAmmo 0;

			// Custom load
			_vehicle addMagazine "250Rnd_30mm_HE_shells";
			_vehicle addMagazine ["38Rnd_80mm_rockets", 20];
			_vehicle addmagazine ["8Rnd_LG_scalpel", 2];
		};

		// All other helicopters
		case (_vehicle isKindOf "Helicopter_Base_F"):
		{
			// Cut all ammo by half
			_vehicle setVehicleAmmoDef 0.5;
		};
	};

	// Reset all flares to 120
	if (_vehicleClass isKindOf "Air") then
	{
		{
			if (["CMFlare", _x] call fn_findString != -1) then
			{
				_vehicle removeMagazinesTurret [_x, [-1]];
			};
		} forEach getArray (configFile >> "CfgVehicles" >> _vehicleClass >> "magazines");

		_vehicle addMagazineTurret ["120Rnd_CMFlare_Chaff_Magazine", [-1]];
	};

	reload _vehicle;*/

	_aiGroup = createGroup CIVILIAN;
	[_aiGroup, _missionPos, _nbUnits] call createCustomGroup;

	_missionPicture = getText (configFile >> "CfgVehicles" >> _vehicleClass >> "picture");
	_vehicleName = getText (configFile >> "CfgVehicles" >> _vehicleClass >> "displayName");

	_vehDeterminer = if ("AEIMO" find (_vehicleName select [0,1]) != -1) then { "An" } else { "A" };

	_missionHintText = format ["%1 <t color='%3'>%2</t> has been immobilized, go get it for your team!", _vehDeterminer, _vehicleName, mainMissionColor];
};

_waitUntilMarkerPos = nil;
_waitUntilExec = nil;
_waitUntilCondition = {!alive _vehicle};

_failedExec =
{
	// Mission failed
	deleteVehicle _vehicle;
};

_successExec =
{
	// Mission completed
	[_vehicle, 1] call A3W_fnc_setLockState; // Unlock

	_successHintMessage = format ["The %1 has been captured, well done.", _vehicleName];
};

_this call mainMissionProcessor;
