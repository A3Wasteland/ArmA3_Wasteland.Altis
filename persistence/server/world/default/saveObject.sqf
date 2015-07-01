// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: saveObject.sqf
//	@file Author: AgentRev

private ["_obj", "_objCount", "_spawningTime", "_hoursAlive", "_props", "_fileName", "_objName"];
_obj = _this select 0;
_objCount = if (count _this > 1) then { _this select 1 } else { nil };

if (!alive _obj || isNil "_objCount") exitWith {nil}; // profileNamespace and iniDB require sequential _objCount to save properly

_spawningTime = _obj getVariable "baseSaving_spawningTime";

if (isNil "_spawningTime") then
{
	_spawningTime = diag_tickTime;
	[_obj, "baseSaving_spawningTime"] call fn_setTickTime;
};

_hoursAlive = (_obj getVariable ["baseSaving_hoursAlive", 0]) + ((diag_tickTime - _spawningTime) / 3600);

_props = [_obj] call fn_getObjectProperties;
_props pushBack ["HoursAlive", _hoursAlive];

_fileName = "Objects" call PDB_objectFileName;
_objName = format ["Obj%1", _objCount];

{
	[_fileName, _objName, _x select 0, _x select 1, false] call PDB_write; // iniDB_write
} forEach _props;

nil
