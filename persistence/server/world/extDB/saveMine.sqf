// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: saveMine.sqf
//	@file Author: AgentRev

params ["_dummy", "", ["_manual",false]];
private ["_mine", "_mineID", "_updateValues"];

_mine = _dummy getVariable ["A3W_stickyCharges_linkedBomb", objNull];

if (!mineActive _mine) exitWith {nil};

_mineID = _dummy getVariable "A3W_mineID";

if (isNil "_mineID") then
{
	_mineID = ([format ["newServerMine:%1:%2", call A3W_extDB_ServerID, call A3W_extDB_MapID], 2] call extDB_Database_async) select 0;
	[_dummy, ["A3W_mineID", _mineID, true]] call fn_secureSetVar;
	[_dummy, ["A3W_mineSaved", true, true]] call fn_secureSetVar;

	A3W_mineIDs pushBack _mineID;
};

_updateValues = [[_dummy] call fn_getMineProperties, 0] call extDB_pairsToSQL;

if (_manual) then
{
	_updateValues = _updateValues + ",LastInteraction=NOW()";
};

[format ["updateServerMine:%1:", _mineID] + _updateValues] call extDB_Database_async;

_mineID
