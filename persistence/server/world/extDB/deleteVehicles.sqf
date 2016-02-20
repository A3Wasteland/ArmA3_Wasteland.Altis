// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: deleteVehicles.sqf
//	@file Author: AgentRev

private ["_vehicles", "_values", "_hcObjSavingOn", "_id"];
_vehicles = _this;
_values = [];
_hcObjSavingOn = (isServer && ["A3W_hcObjSaving"] call isConfigOn);

{
	if (typeName _x == "OBJECT") then
	{
		_id = _x getVariable "A3W_vehicleID";
		[_x, ["A3W_vehicleID", nil, true]] call fn_secureSetVar;
		[_x, ["A3W_vehicleSaved", false, true]] call fn_secureSetVar;

		if (_hcObjSavingOn) then
		{
			A3W_vehicleIDs = A3W_vehicleIDs - [_id];
		};
	}
	else
	{
		_id = _x;
	};

	if (!isNil "_id") then
	{
		_values pushBack str _id;
	};
} forEach _vehicles;

if (count _values > 0) then
{
	["deleteServerVehicles:" + (_values joinString ",")] call extDB_Database_async;
};
