// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: mLoad.sqf
//	@file Author: AgentRev, JoSchaap, Austerror

#include "functions.sqf"

private ["_maxLifetime", "_worldDir", "_methodDir", "_mineCount", "_mines", "_exclMineIDs"];

_maxLifetime = ["A3W_mineLifetime", 0] call getPublicVar;

_worldDir = "persistence\server\world";
_methodDir = format ["%1\%2", _worldDir, call A3W_savingMethodDir];

_mineCount = 0;
_mines = call compile preprocessFileLineNumbers format ["%1\getMines.sqf", _methodDir];

_exclMineIDs = [];

{
	private ["_mine", "_dummy", "_mineID", "_class", "_pos", "_dir", "_damage", "_owner", "_variables", "_hoursAlive", "_valid"];

	//{ (_x select 1) call compile format ["%1 = _this", _x select 0] } forEach _x;
	[] params _x; // automagic assignation

	if (isNil "_hoursAlive") then { _hoursAlive = 0 };
	_valid = false;

	if (!isNil "_class" && !isNil "_pos" && {_maxLifetime <= 0 || _hoursAlive < _maxLifetime}) then
	{
		if (isNil "_variables") then { _variables = [] };

		_mineCount = _mineCount + 1;
		_valid = true;

		{ if (typeName _x == "STRING") then { _pos set [_forEachIndex, parseNumber _x] } } forEach _pos;

		_mine = createMine [_class, ASLtoAGL ATLtoASL _pos, [], 0];

		if (!isNil "_dir") then
		{
			[_mine, _dir] remoteExecCall ["setVectorDirAndUp", 0, _mine];
		};

		_dummy = createVehicle [STICKY_CHARGE_DUMMY_OBJ, [-1e6,-1e6,1e6], [], 0, "NONE"];
		_dummy setVariable ["A3W_stickyCharges_isDummy", true, true];
		_dummy setObjectTextureGlobal [0, "#(argb,8,8,3)color(0,0,0,0)"];
		_dummy attachTo [_mine, [0,0,0]];

		_dummy setVariable ["A3W_stickyCharges_linkedBomb", _mine, true];
		_dummy setVariable ["mineSaving_hoursAlive", _hoursAlive];
		_dummy setVariable ["mineSaving_spawningTime", diag_tickTime];

		if (!isNil "_mineID") then
		{
			_dummy setVariable ["A3W_mineID", _mineID, true];
			_dummy setVariable ["A3W_mineSaved", true, true];
			A3W_mineIDs pushBack _mineID;
		};

		if (!isNil "_owner") then
		{
			_dummy setVariable ["A3W_stickyCharges_ownerUID", _owner, true];
		};

		{
			_x params ["_var", "_value"];

			switch (_var) do
			{
				case "side":
				{
					_var = "A3W_stickyCharges_side";
					_value = _value call _strToSide;
					_value revealMine _mine;
				};
			};

			_dummy setVariable [_var, _value, true];
		} forEach _variables;
	};

	if (!_valid && !isNil "_mineID") then
	{
		if (!isNil "_dummy") then
		{
			_dummy setVariable ["A3W_mineID", nil, true];
		};

		_exclMineIDs pushBack _mineID;
	};
} forEach _mines;

diag_log format ["A3Wasteland - world persistence loaded %1 mines from %2", _mineCount, call A3W_savingMethodName];

_exclMineIDs call fn_deleteMines;
