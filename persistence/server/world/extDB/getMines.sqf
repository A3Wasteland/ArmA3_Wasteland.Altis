// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: getMines.sqf
//	@file Author: AgentRev

private ["_maxLifetime", "_vars", "_columns", "_result", "_mines", "_mineData"];

_maxLifetime = ["A3W_mineLifetime", 0] call getPublicVar;

if (_maxLifetime > 0) then
{
	[format ["deleteExpiredServerMines:%1:%2:%3", call A3W_extDB_ServerID, call A3W_extDB_MapID, _maxLifetime], 2, true] call extDB_Database_async;
};

// DB column name, oLoad variable name
_vars =
[
	["QUOTE(ID)", "_mineID"],
	["Class", "_class"],
	["Position", "_pos"],
	["Direction", "_dir"],
	["Damage", "_damage"],
	["OwnerUID", "_owner"],
	["Variables", "_variables"]
];

_columns = [];
{ _columns pushBack (_x select 0) } forEach _vars;

_result = [format ["getServerMines:%1:%2:%3", call A3W_extDB_ServerID, call A3W_extDB_MapID, _columns joinString ","], 2, true] call extDB_Database_async;

_mines = [];

{
	_mineData = [];

	{
		if (!isNil "_x") then
		{
			_mineData pushBack [(_vars select _forEachIndex) select 1, _x];
		};
	} forEach _x;

	_mines pushBack _mineData;
} forEach _result;

_mines
