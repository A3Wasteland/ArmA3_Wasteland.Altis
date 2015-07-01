// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: getObjects.sqf
//	@file Author: AgentRev

private ["_objFileName", "_exists", "_objCount", "_vars", "_objects", "_objData", "_objName", "_params", "_value"];

_objFileName = "Objects" call PDB_objectFileName;

_exists = _objFileName call PDB_exists; // iniDB_exists
if (isNil "_exists" || {!_exists}) exitWith {[]};

_objCount = [_objFileName, "Info", "ObjCount", "NUMBER"] call PDB_read; // iniDB_read
if (isNil "_objCount" || {_objCount <= 0}) exitWith {[]};

// [key name, data type], oLoad variable name
_vars =
[
	[["Class", "STRING"], "_class"],
	[["Position", "ARRAY"], "_pos"],
	[["Direction", "ARRAY"], "_dir"],
	[["HoursAlive", "NUMBER"], "_hoursAlive"],
	[["HoursUnused", "NUMBER"], "_hoursUnused"],
	[["Damage", "NUMBER"], "_damage"],
	[["AllowDamage", "NUMBER"], "_allowDamage"],
	[["OwnerUID", "STRING"], "_owner"],
	[["Variables", "ARRAY"], "_variables"],
	[["Weapons", "ARRAY"], "_weapons"],
	[["Magazines", "ARRAY"], "_magazines"],
	[["Items", "ARRAY"], "_items"],
	[["Backpacks", "ARRAY"], "_backpacks"],
	[["TurretMagazines", "ARRAY"], "_turretMags"],
	[["AmmoCargo", "NUMBER"], "_ammoCargo"],
	[["FuelCargo", "NUMBER"], "_fuelCargo"],
	[["RepairCargo", "NUMBER"], "_repairCargo"]
];

_objects = [];

for "_i" from 1 to _objCount do
{
	_objData = [];
	_objName = format ["Obj%1", _i];

	{
		_params = _x select 0;
		_value = [_objFileName, _objName, _params select 0, _params select 1] call PDB_read;
		if (!isNil "_value") then { _objData pushBack [_x select 1, _value] };
	} forEach _vars;

	_objects pushBack _objData;
};

_objects
