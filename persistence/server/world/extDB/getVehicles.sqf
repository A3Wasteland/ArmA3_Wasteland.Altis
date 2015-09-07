// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: getVehicles.sqf
//	@file Author: AgentRev

private ["_maxLifetime", "_maxUnusedTime", "_vars", "_columns", "_result", "_vehicles", "_vehData"];

_maxLifetime = ["A3W_vehicleLifetime", 0] call getPublicVar;
_maxUnusedTime = ["A3W_vehicleMaxUnusedTime", 0] call getPublicVar;

if (_maxLifetime > 0 || _maxUnusedTime > 0) then
{
	[format ["deleteExpiredServerVehicles:%1:%2:%3:%4", call A3W_extDB_ServerID, call A3W_extDB_MapID, _maxLifetime, _maxUnusedTime], 2, true] call extDB_Database_async;
};

// DB column name, vLoad variable name
_vars =
[
	["ID", "_vehicleID"],
	["Class", "_class"],
	["Position", "_pos"],
	["Direction", "_dir"],
	["Velocity", "_vel"],
	["Flying", "_flying"],
	["Damage", "_damage"],
	["Fuel", "_fuel"],
	["HitPoints", "_hitPoints"],
	["OwnerUID", "_owner"],
	["Variables", "_variables"],
	["Textures", "_textures"],
	["Weapons", "_weapons"],
	["Magazines", "_magazines"],
	["Items", "_items"],
	["Backpacks", "_backpacks"],
	["TurretMagazines", "_turretMags"],
	["TurretMagazines2", "_turretMags2"],
	["TurretMagazines3", "_turretMags3"],
	["AmmoCargo", "_ammoCargo"],
	["FuelCargo", "_fuelCargo"],
	["RepairCargo", "_repairCargo"]
];

_columns = [];
{ _columns pushBack (_x select 0) } forEach _vars;

_result = [format ["getServerVehicles:%1:%2:%3", call A3W_extDB_ServerID, call A3W_extDB_MapID, _columns joinString ","], 2, true] call extDB_Database_async;

_vehicles = [];

{
	_vehData = [];

	{
		if (!isNil "_x") then
		{
			_vehData pushBack [(_vars select _forEachIndex) select 1, _x];
		};
	} forEach _x;

	_vehicles pushBack _vehData;
} forEach _result;

_vehicles
