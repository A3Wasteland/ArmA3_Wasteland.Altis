// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_manualVehicleDelete.sqf
//	@file Author: AgentRev

private ["_veh", "_id"];

_veh = _this select 0;
_id = _this select 1;

if (typeName _veh == "STRING") then { _veh = objectFromNetId _veh };

if (!isNil "_id") then
{
	[_id] call fn_deleteVehicles;
};

if (!isNull _veh) then
{
	deleteVehicle _veh;
};
