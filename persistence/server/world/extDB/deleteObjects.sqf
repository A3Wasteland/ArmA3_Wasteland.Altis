// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: deleteObjects.sqf
//	@file Author: AgentRev

private ["_objects", "_values", "_id"];
_objects = _this;

_values = "";

{
	if (typeName _x == "OBJECT") then
	{
		_id = _x getVariable "A3W_objectID";
		_x setVariable ["A3W_objectID", nil];
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
