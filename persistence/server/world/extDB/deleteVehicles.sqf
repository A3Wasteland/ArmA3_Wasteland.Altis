// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: deleteVehicles.sqf
//	@file Author: AgentRev

private ["_vehicles", "_values", "_id"];
_vehicles = _this;

_values = "";

{
	_id = if (typeName _x == "OBJECT") then { _x getVariable "A3W_vehicleID" } else { _x };

	if (!isNil "_id") then
	{
		_values = _values + ((if (_values != "") then { "," } else { "" }) + str _id);
	};
} forEach _vehicles;

if (_values != "") then
{
	["deleteServerVehicles:" + _values] call extDB_Database_async;
};
