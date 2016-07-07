// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_manualMineDelete.sqf
//	@file Author: AgentRev

// function currently unused, but is there in case.

params ["_mine", "_id"];

if (_mine isEqualType "") then { _mine = objectFromNetId _mine };

if (!isNil "_id") then
{
	[_id] call fn_deleteMines;
};

if (!isNull _mine) then
{
	deleteVehicle _mine;
};
