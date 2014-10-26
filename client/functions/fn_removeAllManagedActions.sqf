// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_removeAllManagedActions.sqf
//	@file Author: AgentRev

if (!hasInterface) exitWith {-1};

private "_obj";
_obj = _this;

if (isNull _obj) exitWith {};

waitUntil {!managedActions_arrayCleanup};

{
	if (!(_x isEqualTo -1) && {_x select 0 == _obj}) then
	{
		_obj removeAction (_x select 1);
		_x set [0, objNull];
	};
} forEach managedActions_array;
