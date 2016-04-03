// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_removeManagedAction.sqf
//	@file Author: AgentRev

if (!hasInterface) exitWith {-1};

private ["_obj", "_id"];
_obj = _this select 0;
_id = _this select 1;

if (isNull _obj || _id < 0) exitWith {};

_obj removeAction _id;

waitUntil {!managedActions_arrayCleanup};

{
	if (!(_x isEqualTo -1) && {_x select 0 == _obj && _x select 1 == _id}) exitWith
	{
		_x set [0, objNull];
	};
} forEach managedActions_array;
