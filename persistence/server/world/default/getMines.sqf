// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: getMines.sqf
//	@file Author: AgentRev

private ["_mineFileName", "_exists", "_mineCount", "_vars", "_mines", "_mineData", "_mineName", "_params", "_value"];

_mineFileName = "Mines" call PDB_objectFileName;

_exists = _mineFileName call PDB_exists; // iniDB_exists
if (isNil "_exists" || {!_exists}) exitWith {[]};

_mineCount = [_mineFileName, "Info", "MineCount", "NUMBER"] call PDB_read; // iniDB_read
if (isNil "_mineCount" || {_mineCount <= 0}) exitWith {[]};

// [key name, data type], oLoad variable name
_vars =
[
	[["Class", "STRING"], "_class"],
	[["Position", "ARRAY"], "_pos"],
	[["Direction", "ARRAY"], "_dir"],
	[["HoursAlive", "NUMBER"], "_hoursAlive"],
	[["Damage", "NUMBER"], "_damage"],
	[["OwnerUID", "STRING"], "_owner"],
	[["Variables", "ARRAY"], "_variables"]
];

_mines = [];

for "_i" from 1 to _mineCount do
{
	_mineData = [];
	_mineName = format ["Mine%1", _i];

	{
		_params = _x select 0;
		_value = [_mineFileName, _mineName, _params select 0, _params select 1] call PDB_read;
		if (!isNil "_value") then { _mineData pushBack [_x select 1, _value] };
	} forEach _vars;

	_mines pushBack _mineData;
};

_mines
