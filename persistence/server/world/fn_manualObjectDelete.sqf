// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_manualObjectDelete.sqf
//	@file Author: AgentRev

private ["_obj", "_id"];

_obj = _this select 0;
_id = _this select 1;

if (typeName _obj == "STRING") then { _obj = objectFromNetId _obj };

if (!isNil "_id") then
{
	[_id] call fn_deleteObjects;
};

if (!isNull _obj) then
{
	deleteVehicle _obj;
};
