// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: saveVehicle.sqf
//	@file Author: AgentRev

private ["_veh", "_vehCount", "_spawningTime", "_lastUse", "_hoursAlive", "_hoursUnused", "_props", "_fileName", "_vehName"];
_veh = _this select 0;
_vehCount = if (count _this > 1) then { _this select 1 } else { nil };

if (!alive _veh || isNil "_vehCount") exitWith {nil}; // profileNamespace and iniDB require sequential _vehCount to save properly

_spawningTime = _veh getVariable "vehSaving_spawningTime";

if (isNil "_spawningTime") then
{
	_spawningTime = diag_tickTime;
	[_veh, "vehSaving_spawningTime"] call fn_setTickTime;
};

_lastUse = _veh getVariable ["vehSaving_lastUse", _spawningTime];

if ({isPlayer _x} count crew _veh > 0 || isPlayer ((uavControl _veh) select 0)) then
{
	_lastUse = diag_tickTime;
	[_veh, "vehSaving_lastUse"] call fn_setTickTime;
	[_veh, ["vehSaving_hoursUnused", 0]] call fn_secureSetVar;
};

_hoursAlive = (_veh getVariable ["vehSaving_hoursAlive", 0]) + ((diag_tickTime - _spawningTime) / 3600);
_hoursUnused = (_veh getVariable ["vehSaving_hoursUnused", 0]) + ((diag_tickTime - _lastUse) / 3600);

_props = [_veh] call fn_getVehicleProperties;
_props append
[
	["HoursAlive", _hoursAlive],
	["HoursUnused", _hoursUnused]
];

_fileName = "Vehicles" call PDB_objectFileName;
_vehName = format ["Veh%1", _vehCount];

{
	[_fileName, _vehName, _x select 0, _x select 1, false] call PDB_write; // iniDB_write
} forEach _props;

nil
