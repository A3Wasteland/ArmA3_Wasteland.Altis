// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: deleteMines.sqf
//	@file Author: AgentRev

private ["_mines", "_values", "_hcObjSavingOn", "_id"];
_mines = _this; // array containing objects or numbers, objects being dummies and numbers being mine IDs
_values = [];
_hcObjSavingOn = (isServer && ["A3W_hcObjSaving"] call isConfigOn);

{
	if (_x isEqualType objNull) then
	{
		_x = _x getVariable ["A3W_stickyCharges_linkedBomb", objNull];
		_id = _x getVariable "A3W_mineID";
		[_x, ["A3W_mineID", nil, true]] call fn_secureSetVar;
		[_x, ["A3W_mineSaved", false, true]] call fn_secureSetVar;

		if (_hcObjSaving) then
		{
			A3W_mineIDs = A3W_mineIDs - [_id];
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
} forEach _mines;

if (count _values > 0) then
{
	["deleteServerMines:" + (_values joinString ",")] call extDB_Database_async;
};
