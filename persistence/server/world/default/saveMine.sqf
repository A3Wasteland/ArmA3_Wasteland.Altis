// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: saveMine.sqf
//	@file Author: AgentRev

params ["_dummy", "_mineCount"];
private ["_mine", "_spawningTime", "_hoursAlive", "_props", "_fileName", "_mineName"];

_mine = _dummy getVariable ["A3W_stickyCharges_linkedBomb", objNull];

if (!mineActive _mine || isNil "_mineCount") exitWith {nil}; // profileNamespace and iniDB require sequential _mineCount to save properly

_spawningTime = _dummy getVariable "mineSaving_spawningTime";

if (isNil "_spawningTime") then
{
	_spawningTime = diag_tickTime;
	[_dummy, "mineSaving_spawningTime"] call fn_setTickTime;
};

_hoursAlive = (_dummy getVariable ["mineSaving_hoursAlive", 0]) + ((diag_tickTime - _spawningTime) / 3600);

_props = [_dummy] call fn_getMineProperties;
_props pushBack ["HoursAlive", _hoursAlive];

_fileName = "Mines" call PDB_objectFileName;
_mineName = format ["Mine%1", _mineCount];

{
	[_fileName, _mineName, _x select 0, _x select 1, false] call PDB_write; // iniDB_write
} forEach _props;

nil
