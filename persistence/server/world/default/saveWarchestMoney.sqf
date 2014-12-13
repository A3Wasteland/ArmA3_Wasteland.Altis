// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: saveWarchestMoney.sqf
//	@file Author: AgentRev

private ["_fundsWest", "_fundsEast", "_fileName"];

_fundsWest = 0;
_fundsEast = 0;

if (["A3W_warchestMoneySaving"] call isConfigOn) then
{
	_fundsWest = ["pvar_warchest_funds_west", 0] call getPublicVar;
	_fundsEast = ["pvar_warchest_funds_east", 0] call getPublicVar;
};

_fileName = "Objects" call PDB_objectFileName;

[_fileName, "Info", "WarchestMoneyBLUFOR", _fundsWest] call PDB_write; // iniDB_write
[_fileName, "Info", "WarchestMoneyOPFOR", _fundsEast] call PDB_write; // iniDB_write
