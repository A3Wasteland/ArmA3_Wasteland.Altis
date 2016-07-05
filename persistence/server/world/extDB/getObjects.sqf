// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: getObjects.sqf
//	@file Author: AgentRev

private ["_maxLifetime", "_saveUnlockedObjects", "_vars", "_columns", "_result", "_objects", "_objData"];

_maxLifetime = ["A3W_objectLifetime", 0] call getPublicVar;
_saveUnlockedObjects = ["A3W_extDB_SaveUnlockedObjects", 0] call getPublicVar;

if (_maxLifetime > 0 || _saveUnlockedObjects <= 0) then
{
	[format ["deleteExpiredServerObjects:%1:%2:%3:%4", call A3W_extDB_ServerID, call A3W_extDB_MapID, _maxLifetime, _saveUnlockedObjects], 2, true] call extDB_Database_async;
};

// DB column name, oLoad variable name
_vars =
[
	["QUOTE(ID)", "_objectID"],
	["Class", "_class"],
	["Position", "_pos"],
	["Direction", "_dir"],
	["Locked", "_locked"],
	["Damage", "_damage"],
	["AllowDamage", "_allowDamage"],
	["OwnerUID", "_owner"],
	["Variables", "_variables"],
	["Weapons", "_weapons"],
	["Magazines", "_magazines"],
	["Items", "_items"],
	["Backpacks", "_backpacks"],
	["TurretMagazines", "_turretMags"],
	["AmmoCargo", "_ammoCargo"],
	["FuelCargo", "_fuelCargo"],
	["RepairCargo", "_repairCargo"]
];

_columns = [];
{ _columns pushBack (_x select 0) } forEach _vars;

_result = [format ["getServerObjects:%1:%2:%3", call A3W_extDB_ServerID, call A3W_extDB_MapID, _columns joinString ","], 2, true] call extDB_Database_async;

_objects = [];

{
	_objData = [];

	{
		if (!isNil "_x") then
		{
			_objData pushBack [(_vars select _forEachIndex) select 1, _x];
		};
	} forEach _x;

	_objects pushBack _objData;
} forEach _result;

_objects
