// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: saveVehicle.sqf
//	@file Author: AgentRev

#define FILTERED_CHARS [39,58] // single quote, colon

private ["_veh", "_vehicleID", "_spawningTime", "_lastUse", "_flying", "_props", "_updateValues", "_key", "_val"];
_veh = _this select 0;

_vehicleID = _veh getVariable "A3W_vehicleID";

if (isNil "_vehicleID") then
{
	_vehicleID = ([format ["newServerVehicle:%1:%2", call A3W_extDB_ServerID, call A3W_extDB_MapID], 2] call extDB_Database_async) select 0;
	_veh setVariable ["A3W_vehicleID", _vehicleID, true];
};

_spawningTime = _veh getVariable "vehSaving_spawningTime";

if (isNil "_spawningTime") then
{
	_spawningTime = diag_tickTime;
	_veh setVariable ["vehSaving_spawningTime", _spawningTime];
};

_lastUse = _veh getVariable ["vehSaving_lastUse", _spawningTime];

_flying = (!isTouchingGround _veh && (getPos _veh) select 2 > 1);
_props = [_veh, _flying] call fn_getVehicleProperties;

_updateValues = "";

{
	_key = _x select 0;
	_val = _x select 1;

	_val = if (typeName _val == "SCALAR") then {
		_val call fn_numToStr
	} else {
		format ["'%1'", toString (toArray str _val - FILTERED_CHARS)]
	};

	_updateValues = _updateValues + format ["%1%2=%3", if (_updateValues != "") then { "," } else { "" }, _key, _val];
} forEach _props;

_updateValues = _updateValues + (",Flying=" + (if (_flying) then { "1" } else { "0" }));

if ({isPlayer _x} count crew _veh > 0 || isPlayer ((uavControl _veh) select 0)) then
{
	_lastUse = diag_tickTime;
	_veh setVariable ["vehSaving_lastUse", _lastUse];
};

if (_lastUse > _veh getVariable ["vehSaving_lastUseSave", _spawningTime]) then
{
	_updateValues = _updateValues + ",LastUsed=NOW()";
	_veh setVariable ["vehSaving_lastUseSave", diag_tickTime];
};

[format ["updateServerVehicle:%1:", _vehicleID] + _updateValues] call extDB_Database_async;

_vehicleID
