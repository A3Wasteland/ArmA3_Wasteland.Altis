// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: deleteObjects.sqf
//	@file Author: AgentRev

private ["_objects", "_values", "_hcObjSavingOn", "_id"];
_objects = _this;
_values = "";
_hcObjSavingOn = (isServer && ["A3W_hcObjSaving"] call isConfigOn);

{
	if (typeName _x == "OBJECT") then
	{
		_id = _x getVariable "A3W_objectID";
		[_x, ["A3W_objectID", nil, true]] call fn_secureSetVar;
		[_x, ["A3W_objectSaved", false, true]] call fn_secureSetVar;

		if (_hcObjSaving) then
		{
			A3W_objectIDs = A3W_objectIDs - [_id];
		};
	}
	else
	{
		_id = _x;
	};

	if (!isNil "_id") then
	{
		_values = _values + ((if (_values != "") then { "," } else { "" }) + str _id);
	};
} forEach _objects;

if (_values != "") then
{
	["deleteServerObjects:" + _values] call extDB_Database_async;
};
