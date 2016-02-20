// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
/*
	Original Script
	createOutpost.sqf Author: Joris-Jan van 't Land
	Edited by armatec, JoSchaap, AgentRev

	Description:
	Takes an array of data about a dynamic object template and creates the objects.

	Parameter(s):
	_this select 0: compositions name - "fuelDepot_us"
	_this select 1: Direction in degrees - Number
	_this select 2: Location to start

	Exsample:
	["fuelDepot_us", 0, getpos player] execVM "Createcomposition.sqf";
*/
private ["_fileName", "_dir", "_pos", "_objList", "_objs", "_class", "_relPos", "_relDir", "_fuel", "_damage", "_init"];
_fileName = _this select 0;
_pos = _this select 1;
_dir = _this select 2;

_objList = call compile preprocessFileLineNumbers format ["server\missions\outposts\%1.sqf", _fileName];
_objs = [];

{
	_class = _x select 0;
	_relPos = _x select 1;
	_relDir = _x select 2;
	_init = _x param [3, nil];

	if (count _relPos == 2) then { _relPos set [2, 0] };

	_finalPos = _pos vectorAdd ([_relPos, -(_dir)] call BIS_fnc_rotateVector2D);
	_obj = createVehicle [_class, _finalPos, [], 0, "None"];
	_obj setDir (_dir + _relDir);
	_obj setPos _finalPos;
	_obj setPosATL _finalPos;

	if (!isNil "_fuel") then {_obj setFuel _fuel };
	if (!isNil "_damage") then {_obj setDamage _damage };
	if (!isNil "_init") then { _obj call _init };

	_obj setVariable ["R3F_LOG_disabled", true, true];
	[_obj] call basePartSetup;
	_objs pushBack _obj;
} forEach _objList;

_objs
