// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: getVehicles.sqf
//	@file Author: AgentRev

private ["_vehFileName", "_exists", "_vehCount", "_vars", "_vehicles", "_vehData", "_vehName", "_params", "_value"];

_vehFileName = "Vehicles" call PDB_objectFileName;

_exists = _vehFileName call PDB_exists; // iniDB_exists
if (isNil "_exists" || {!_exists}) exitWith {[]};

_vehCount = [_vehFileName, "Info", "VehCount", "NUMBER"] call PDB_read; // iniDB_read
if (isNil "_vehCount" || {_vehCount <= 0}) exitWith {[]};

// [key name, data type], vLoad variable name
_vars =
[
	[["Class", "STRING"], "_class"],
	[["Position", "ARRAY"], "_pos"],
	[["Direction", "ARRAY"], "_dir"],
	[["HoursAlive", "NUMBER"], "_hoursAlive"],
	[["HoursUnused", "NUMBER"], "_hoursUnused"],
	[["Damage", "NUMBER"], "_damage"],
	[["Fuel", "NUMBER"], "_fuel"],
	[["HitPoints", "ARRAY"], "_hitPoints"],
	[["OwnerUID", "STRING"], "_owner"],
	[["Variables", "ARRAY"], "_variables"],
	[["Textures", "ARRAY"], "_textures"],
	[["Weapons", "ARRAY"], "_weapons"],
	[["Magazines", "ARRAY"], "_magazines"],
	[["Items", "ARRAY"], "_items"],
	[["Backpacks", "ARRAY"], "_backpacks"],
	[["TurretMagazines", "ARRAY"], "_turretMags"], // deprecated
	[["TurretMagazines2", "ARRAY"], "_turretMags2"],
	[["TurretMagazines3", "ARRAY"], "_turretMags3"], // deprecated
	[["AmmoCargo", "NUMBER"], "_ammoCargo"],
	[["FuelCargo", "NUMBER"], "_fuelCargo"],
	[["RepairCargo", "NUMBER"], "_repairCargo"]
];

_vehicles = [];

for "_i" from 1 to _vehCount do
{
	_vehData = [];
	_vehName = format ["Veh%1", _i];

	{
		_params = _x select 0;
		_value = [_vehFileName, _vehName, _params select 0, _params select 1] call PDB_read;
		if (!isNil "_value") then { _vehData pushBack [_x select 1, _value] };
	} forEach _vars;

	_vehicles pushBack _vehData;
};

_vehicles
